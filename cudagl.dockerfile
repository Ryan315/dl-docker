ARG IMAGE_NAME=nvidia/cuda
FROM nvidia/cudagl:10.2-devel-ubuntu18.04

LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

ENV NCCL_VERSION 2.9.6

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------------------------------------
# Repository
RUN apt-get update --fix-missing && apt-get install -y apt-utils software-properties-common
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"

RUN apt-get install -y \
        wget git zsh vim curl \
        python3-dev python3-pip \
        ca-certificates \
        locales \
       # language-pack-en-base \
        openssh-server \
        libcanberra-gtk-module libcanberra-gtk3-module

ARG PIP=pip3
RUN ${PIP} install numpy pillow torch torchvision torchaudio
RUN locale-gen en_US.UTF-8

# ------------------------------------------------------------------------------------------
# Configuration
# ----- ssh
RUN mkdir -p /var/run/sshd /root/.ssh
RUN sed -ri 's#session  required  pam_loginuid.so#session   required    pam_loginuid.so#g' /etc/pam.d/sshd
# ----- oh my zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
#     dpkg-reconfigure --frontend=noninteractive locales && \
#     update-locale LANG=en_US.UTF-8

# ENV LANG en_US.UTF-8

ARG username=ryan90
ARG uid=1000
ARG gid=100
ENV USER $username
ENV UID $uid
ENV GID $gid
ENV HOME /home/$USER
RUN adduser --disabled-password \
    --gecos "Non-root user" \
    --uid $UID \
    --gid $GID \
    --home $HOME \
    $USER

ENV PROJECT_DIR $HOME/code
WORKDIR $PROJECT_DIR

EXPOSE 6006
EXPOSE 8080
EXPOSE 5000