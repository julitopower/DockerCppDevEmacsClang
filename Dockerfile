FROM ubuntu:16.04
MAINTAINER Julio Delgado <julio.delgadomangas@gmail.com>
ENV USER root
ENV HOME /root

RUN apt-get update && apt-get install software-properties-common python-software-properties wget -y
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
        apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main" && \
        apt-get update && \
        apt-get install -y clang-6.0

RUN add-apt-repository ppa:kelleyk/emacs && apt-get update \
    && apt-get install -y curl \
                       file \
                       git \
                       emacs25 \
                       gcc \
                       g++



# Install emacs configuration
COPY emacs.d ${HOME}/.emacs.d
RUN emacs --batch -l ${HOME}/.emacs.d/init.el

# Install gitconfig
COPY gitconfig ${HOME}/.gitconfig

# Enable 256 ANSI colors for Emacs
ENV TERM xterm-256color

RUN apt-get install -y libclang-6.0-dev cmake
RUN ln /usr/bin/clang-6.0 /usr/bin/clang
RUN apt-get install -y python3-pip rc
RUN pip3 install pytest numpy ujson
RUN apt-get install libboost-all-dev -y
RUN git clone https://github.com/Tencent/rapidjson.git && cp -r rapidjson/include/* /usr/include/
