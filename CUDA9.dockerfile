FROM ubuntu:18.04
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

# CUDA 9.2 is not officially supported on ubuntu 18.04 yet, we use the ubuntu 17.10 repository for CUDA instead.
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1710/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1710/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
    rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 9.2.148

ENV CUDA_PKG_VERSION 9-2=$CUDA_VERSION-1
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION && \
    ln -s cuda-9.2 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# nvidia-docker 1.0
LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.2"


# ------------------------------------------------------------------------------------------

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------------------------------------
# Repository
RUN apt-get update --fix-missing && apt-get install -y apt-utils software-properties-common
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"

# ------------------------------------------------------------------------------------------
RUN apt-get install -y \
        wget git zsh vim curl \
    # essentials for opencv
        build-essential cmake unzip pkg-config \
        libjpeg-dev libpng-dev libtiff-dev \
        libjasper1 libjasper-dev \
        libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
        libxvidcore-dev libx264-dev \
        libgtk-3-dev \
        libatlas-base-dev gfortran \
        python3.6-dev python3-pip \
        ca-certificates \
       # language-pack-en-base \
        openssh-server \
        libcanberra-gtk-module libcanberra-gtk3-module && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py
ARG PIP=pip3
RUN ${PIP} install numpy

# ------------------------------------------------------------------------------------------
# Configuration
# ----- ssh
RUN mkdir -p /var/run/sshd /root/.ssh
RUN sed -ri 's#session  required  pam_loginuid.so#session   required    pam_loginuid.so#g' /etc/pam.d/sshd
# ----- oh my zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# ------------------------------------------------------------------------------------------
WORKDIR /home
# opencv
ADD opencv_3.4.4.sh /home
RUN chmod 755 /home/opencv_3.4.4.sh
RUN sh /home/opencv_3.4.4.sh

# detectron2 pytorch
RUN ${PIP} install -U torch==1.4+cu100 torchvision==0.5+cu100 -f https://download.pytorch.org/whl/torch_stable.html
RUN ${PIP} install cython pyyaml==5.1
# RUN ${PIP} install -U 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'
# RUN ${PIP} install detectron2 -f https://dl.fbaipublicfiles.com/detectron2/wheels/cu100/index.html

# other pip packages
RUN ${PIP} install tensorboard matplotlib sklearn

# --------------------------------------------------------------------------------------------
# ignore output warnings
RUN export NO_AT_BRIDGE=1

# --------------------------------------------------------------------------------------------
EXPOSE 6006
WORKDIR /root/code