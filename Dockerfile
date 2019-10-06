FROM ubuntu:bionic
MAINTAINER Julio Delgado <julio.delgadomangas@gmail.com>
ENV USER root
ENV HOME /root

RUN apt-get update && apt-get install software-properties-common wget -y
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
        apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main" && \
        apt-get update && \
        apt-get install -y clang-6.0

RUN add-apt-repository ppa:kelleyk/emacs && apt-get update \
    && apt-get install -y curl \
                       file \
                       git \
                       emacs26 \
                       gcc \
                       g++ \
                       libclang-6.0-dev \
                       cmake \
                       python3-pip \
                       rc \
                       libboost-all-dev


# Install emacs configuration
COPY emacs.d ${HOME}/.emacs.d
RUN emacs --batch -l ${HOME}/.emacs.d/init.el
RUN mkdir -p /tmp/irony_install/ && cd /tmp/irony_install/ && cmake -DCMAKE_INSTALL_PREFIX\=/root/.emacs.d/irony/ \
    /root/.emacs.d/elpa/irony-20190703.1732/server && \
    cmake --build . --use-stderr --config Release --target install

# Install gitconfig
COPY gitconfig ${HOME}/.gitconfig

# Enable 256 ANSI colors for Emacs
ENV TERM xterm-256color

RUN ln /usr/bin/clang-6.0 /usr/bin/clang
RUN pip3 install pytest numpy ujson
RUN git clone https://github.com/Tencent/rapidjson.git && cp -r rapidjson/include/* /usr/include/
