FROM nvidia/cuda:11.1-devel-ubuntu20.04

MAINTAINER Julio Delgado <julio.delgadomangas@gmail.com>
ENV USER root
ENV HOME /root
ENV CONDA_ENV_NAME=dev
WORKDIR /opt/dev-conda/

RUN apt-get update && apt-get install wget vim -y

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
&& chmod +x Miniconda3-latest-Linux-x86_64.sh \
&& bash Miniconda3-latest-Linux-x86_64.sh -b -p ./miniconda

# Create the environment:
COPY environment.yml .
RUN ./miniconda/bin/conda update -n base -c defaults conda
RUN ./miniconda/bin/conda init
RUN ./miniconda/bin/conda env create -f environment.yml

# Make RUN commands use the new environment. Unfortunately ARG/ENV don't work here
# So we have to hardcode the name of the conda environment
SHELL ["/opt/dev-conda/miniconda/bin/conda", "run", "-n", "dev", "/bin/bash", "-c"]

# Make sure CMake can find the compiler
#ENV CC /opt/conda/envs/$CONDA_ENV_NAME/bin/x86_64-conda-linux-gnu-cc
#ENV CXX /opt/conda/envs/$CONDA_ENV_NAME/bin/x86_64-conda-linux-gnu-cpp
#ENV CPP /opt/conda/envs/$CONDA_ENV_NAME/bin/x86_64-conda-linux-gnu-cpp
#RUN echo $CONDA_ENV_NAME
#RUN ln -s /opt/conda/envs/${CONDA_ENV_NAME}/bin/x86_64-conda-linux-gnu-gcc /usr/bin/gcc

# Get our environment to be activate on login
RUN sed s/base/dev/ ~/.bashrc -i

# Install emacs configuration
COPY emacs.d ${HOME}/.emacs.d
RUN emacs --batch -l ${HOME}/.emacs.d/init.el
#RUN mkdir -p /tmp/irony_install/ && cd /tmp/irony_install/ && cmake -DCMAKE_INSTALL_PREFIX\=/root/.emacs.d/irony/ \
#    /root/.emacs.d/elpa/irony-20200130.849/server && \
#    cmake --build . --use-stderr --config Release --target install

# Install gitconfig
COPY gitconfig ${HOME}/.gitconfig

# Enable 256 ANSI colors for Emacs
ENV TERM xterm-256color
