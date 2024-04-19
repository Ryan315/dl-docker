FROM jupyter/minimal-notebook:python-3.8.8
USER root
WORKDIR /tmp

ENV OS debian119
{% if "x86_64" in cuda %}
ENV NVARCH x86_64
{% if "requires" in cuda.x86_64 %}
ENV NVIDIA_REQUIRE_CUDA "{{ cuda.x86_64.requires }}"
{% endif %}

ENV NV_CUDA_CUDART_VERSION {{ cuda.x86_64.components.cudart.version }}
ENV NV_CUDA_COMPAT_PACKAGE cuda-compat-{{ cuda.version.major }}-{{ cuda.version.minor }}
{% endif %}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

ENV CUDA_VERSION {{ cuda.version.release_label }}

ENV NV_CUDA_LIB_VERSION "{{ cuda.version.release_label + "-1" }}"
{% if "x86_64" in cuda %}

ENV NV_CUDA_CUDART_DEV_VERSION {{ cuda.x86_64.components.cudart_dev.version }}
ENV NV_NVML_DEV_VERSION {{ cuda.x86_64.components.nvml_dev.version }}
ENV NV_LIBCUSPARSE_DEV_VERSION {{ cuda.x86_64.components.libcusparse_dev.version }}
    {% if "libnpp_dev" in cuda.x86_64.components %}
        {% set has_libnpp_dev_package = true %}
ENV NV_LIBNPP_DEV_VERSION {{ cuda.x86_64.components.libnpp_dev.version }}
ENV NV_LIBNPP_DEV_PACKAGE libnpp-dev-{{ cuda.version.major }}-{{ cuda.version.minor }}=${NV_LIBNPP_DEV_VERSION}
    {% endif %}

ENV NV_LIBCUBLAS_DEV_VERSION {{ cuda.x86_64.components.libcublas_dev.version }}
ENV NV_LIBCUBLAS_DEV_PACKAGE_NAME libcublas-dev-{{ cuda.version.major }}-{{ cuda.version.minor }}
ENV NV_LIBCUBLAS_DEV_PACKAGE ${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}
    {% if "nvprof" in cuda.x86_64.components %}
        {% set has_nvprof_package = true %}

ENV NV_NVPROF_VERSION {{ cuda.x86_64.components.nvprof.version }}
ENV NV_NVPROF_DEV_PACKAGE cuda-nvprof-{{ cuda.version.major }}-{{ cuda.version.minor }}=${NV_NVPROF_VERSION}
    {% endif %}
    {% if "libnccl2" in cuda.x86_64.components and cuda.x86_64.components.libnccl2 and "libnccl2_dev" in cuda.x86_64.components and cuda.x86_64.components.libnccl2_dev %}
        {% set has_libnccl_dev_package = true %}

ENV NV_LIBNCCL_DEV_PACKAGE_NAME libnccl-dev
ENV NV_LIBNCCL_DEV_PACKAGE_VERSION {{ cuda.x86_64.components.libnccl2_dev.version }}
ENV NCCL_VERSION {{ cuda.x86_64.components.libnccl2_dev.version }}
ENV NV_LIBNCCL_DEV_PACKAGE ${NV_LIBNCCL_DEV_PACKAGE_NAME}=${NV_LIBNCCL_DEV_PACKAGE_VERSION}+cuda{{ cuda.version.major }}.{{ cuda.version.minor }}
        {% if "libnccl2" in cuda.x86_64.components and "source" in cuda.x86_64.components.libnccl2 %}
ENV NV_LIBNCCL_PACKAGE_SHA256SUM {{ cuda.x86_64.components.libnccl2.sha256sum }}
ENV NV_LIBNCCL_PACKAGE_SOURCE {{ cuda.x86_64.components.libnccl2.source }}
ENV NV_LIBNCCL_PACKAGE_SOURCE_NAME {{ cuda.x86_64.components.libnccl2.basename }}

RUN apt-get update && apt-get install -y --no-install-recommends wget

RUN wget -q ${NV_LIBNCCL_PACKAGE_SOURCE} \
    && echo "$NV_LIBNCCL_PACKAGE_SHA256SUM  ${NV_LIBNCCL_PACKAGE_SOURCE_NAME}" | sha256sum -c --strict - \
    && dpkg -i ${NV_LIBNCCL_PACKAGE_SOURCE_NAME} \
    && rm -f ${NV_LIBNCCL_PACKAGE_SOURCE_NAME} \
    && apt-get purge --autoremove -y wget \
    && rm -rf /var/lib/apt/lists/*

        {% endif %}
        {% if "libnccl2_dev" in cuda.x86_64.components and "source" in cuda.x86_64.components.libnccl2_dev %}
ENV NV_LIBNCCL_DEV_PACKAGE_SHA256SUM {{ cuda.x86_64.components.libnccl2_dev.sha256sum }}
ENV NV_LIBNCCL_DEV_PACKAGE_SOURCE {{ cuda.x86_64.components.libnccl2_dev.source }}
ENV NV_LIBNCCL_DEV_PACKAGE_SOURCE_NAME {{ cuda.x86_64.components.libnccl2_dev.basename }}
RUN apt-get update && apt-get install -y --no-install-recommends wget

RUN wget -q ${NV_LIBNCCL_DEV_PACKAGE_SOURCE} \
    && echo "$NV_LIBNCCL_DEV_PACKAGE_SHA256SUM  ${NV_LIBNCCL_DEV_PACKAGE_SOURCE_NAME}" | sha256sum -c --strict - \
    && dpkg -i ${NV_LIBNCCL_DEV_PACKAGE_SOURCE_NAME} \
    && rm -f ${NV_LIBNCCL_DEV_PACKAGE_SOURCE_NAME} \
    && apt-get purge --autoremove -y wget \
    && rm -rf /var/lib/apt/lists/*
        {% endif %}
    {% endif %}
{% endif %}
ENV CUDNN_VERSION {{ cuda.x86_64.components.cudnn8.version }}

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    wget software-properties-common tzdata dirmngr gpg-agent \
{% if cuda.os.version == "22.04" and not (cuda.image_tag_suffix | length) %}
    gnupg2 curl ca-certificates && \
    curl -fsSLO {{ cuda.repo_url }}/${NVARCH}/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
{% elif cuda.os.version != "16.04" or cuda.flavor == "jetson" %}
    {# Still used for internal 22.04 images until https://jirasw.nvidia.com/browse/CUDAINST-1240 #}
    gnupg2 curl ca-certificates && \
    curl -fsSL {{ cuda.repo_url }}/${NVARCH}/3bf863cc.pub | apt-key add - && \
    echo "deb {{ cuda.repo_url }}/${NVARCH} /" > /etc/apt/sources.list.d/cuda.list && \
{% else %}
    ca-certificates apt-transport-https gnupg-curl && \
    NVIDIA_GPGKEY_SUM=a21c1a0b18a4196fa901b833e13c4fa64f094d7d9e8a6495318e7255f0ef23d1 && \
    NVIDIA_GPGKEY_FPR=eb693b3035cd5710e231e123a4b469963bf863cc && \
    apt-key adv --fetch-keys {{ cuda.repo_url }}/${NVARCH}/3bf863cc.pub && \
    apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +5 > cudasign.pub && \
    echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub && \
    echo "deb {{ cuda.repo_url }}/${NVARCH} /" > /etc/apt/sources.list.d/cuda.list && \
{% endif %}
    wget {{ cuda.repo_url }}/${NVARCH}/cuda-$OS.pin && \
    mv cuda-$OS.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    apt-key adv --fetch-keys {{ cuda.repo_url }}/${NVARCH}/7fa2af80.pub && \
    add-apt-repository "deb {{ cuda.repo_url }}/${NVARCH}/ /" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    cuda-cudart-dev-{{ cuda.version.major }}-{{ cuda.version.minor }}=${NV_CUDA_CUDART_DEV_VERSION} \
    ${NV_CUDA_COMPAT_PACKAGE} \
    cuda-command-line-tools-{{ cuda.version.major }}-{{ cuda.version.minor }}=${NV_CUDA_LIB_VERSION} \
    cuda-minimal-build-{{ cuda.version.major }}-{{ cuda.version.minor }}=${NV_CUDA_LIB_VERSION} \
    cuda-libraries-dev-{{ cuda.version.major }}-{{ cuda.version.minor }}=${NV_CUDA_LIB_VERSION} \
    cuda-nvml-dev-{{ cuda.version.major }}-{{ cuda.version.minor }}=${NV_NVML_DEV_VERSION} \
{% if has_nvprof_package %}
    ${NV_NVPROF_DEV_PACKAGE} \
{% endif %}
{% if has_libnpp_dev_package %}
    ${NV_LIBNPP_DEV_PACKAGE} \
{% endif %}
    libcusparse-dev-{{ cuda.version.major }}-{{ cuda.version.minor }}=${NV_LIBCUSPARSE_DEV_VERSION} \
    ${NV_LIBCUBLAS_DEV_PACKAGE} \
{% if has_libnccl_dev_package %}
    libnccl2=${NCCL_VERSION}+cuda{{ cuda.version.major }}.{{ cuda.version.minor }} \
    ${NV_LIBNCCL_DEV_PACKAGE} \
{% endif %}
{% if has_cuda_profiler_api_package %}
    ${NV_CUDA_PROFILER_API_PACKAGE} \
{% endif %}
    libcudnn8=${CUDNN_VERSION}+cuda{{ cuda.version.major }}.{{ cuda.version.minor }} && \
    apt-mark hold libcudnn8 \
{% if ( cuda.version.major | int ) == 11 and ( cuda.version.minor | int ) <= 2 %}
    && ln -s cuda-{{ cuda.version.major }}.{{ cuda.version.minor }} /usr/local/cuda \
{% endif %}
    && echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf
#
# cleanup
#
RUN npm cache clean --force && \
    conda clean --all -f -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/jovyan