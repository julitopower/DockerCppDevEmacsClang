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
                       libboost-all-dev \
                       doxygen \
                       graphviz


# RTAGS
RUN mkdir -p /opt/src && cd /opt/src/ && git clone --recursive https://github.com/Andersbakken/rtags.git && \
    cd rtags && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 . && make
ENV PATH "${PATH}:/opt/src/rtags/bin/"

# Install emacs configuration
COPY emacs.d ${HOME}/.emacs.d
RUN emacs --batch -l ${HOME}/.emacs.d/init.el
RUN mkdir -p /tmp/irony_install/ && cd /tmp/irony_install/ && cmake -DCMAKE_INSTALL_PREFIX\=/root/.emacs.d/irony/ \
    /root/.emacs.d/elpa/irony-20191009.2139/server && \
    cmake --build . --use-stderr --config Release --target install

# Install gitconfig
COPY gitconfig ${HOME}/.gitconfig

# Enable 256 ANSI colors for Emacs
ENV TERM xterm-256color

RUN ln /usr/bin/clang-6.0 /usr/bin/clang
RUN pip3 install pytest numpy ujson
RUN git clone https://github.com/Tencent/rapidjson.git && cp -r rapidjson/include/* /usr/include/

# Install eigen
RUN git clone https://github.com/eigenteam/eigen-git-mirror.git && cd eigen-git-mirror && cp -r Eigen /usr/include/

# Install Poco libraries
RUN mkdir -p /opt/src && cd /opt/src/ && git clone https://github.com/pocoproject/poco && \
    cd /opt/src/poco/ && rm -rf cmake-build && mkdir cmake-build &&  \
    cd cmake-build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j4 && make install

# Final cleanup to help reduce side when building with --squash
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
