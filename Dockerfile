# \BUILD\---------------------------------------------------------------
#
#  CONTENTS      : STRique repeat detection pipeline
#
#  DESCRIPTION   : Dockerfile
#
#  RESTRICTIONS  : none
#
#  REQUIRES      : none
#
# -----------------------------------------------------------------------
# Copyright (c) 2018-2019, Pay Giesselmann, Max Planck Institute for Molecular Genetics
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Written by Pay Giesselmann
# ---------------------------------------------------------------------------------

# STRique Dockerfile

# PACKAGE STAGE
FROM ubuntu:18.04
MAINTAINER Pay Giesselmann <giesselmann@molgen.mpg.de>

## packages
RUN apt-get --yes update && \
    apt-get install -y --no-install-recommends wget locales \
    git gcc g++ make cmake python3-dev python3-pip \
    ca-certificates apt-transport-https zlib1g-dev \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /app
COPY . /app/
WORKDIR /app

RUN pip3 install setuptools wheel
RUN pip3 install -r requirements.txt
RUN wget https://github.com/nanoporetech/vbz_compression/releases/download/1.0.2/pyvbz-1.0.1-cp36-cp36m-linux_x86_64.whl
RUN pip3 install pyvbz-1.0.1-cp36-cp36m-linux_x86_64.whl
RUN wget https://github.com/nanoporetech/vbz_compression/releases/download/1.0.2/ont-vbz-hdf-plugin_1.0.2-1.bionic_amd64.deb
RUN dpkg -i ont-vbz-hdf-plugin_1.0.2-1.bionic_amd64.deb
RUN python3 setup.py install
# RUN rm -rf build
# RUN rm -rf submodules/seqan

WORKDIR /app
# CMD python3 /app/scripts/STRique.py
# default entrypoint is /bin/sh
