FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install -y gawk gperf grep gettext python python-dev automake bison flex texinfo help2man libtool libtool-bin make vim git bzip2 xz-utils unzip libncurses5-dev wget gcc g++

RUN useradd esp-idf
RUN mkdir /build
RUN chown esp-idf /build
USER esp-idf
WORKDIR /build
RUN git clone -b xtensa-1.22.x https://github.com/espressif/crosstool-NG.git
WORKDIR /build/crosstool-NG


RUN ./bootstrap 
RUN ./configure --enable-local 
RUN make 
USER root
RUN make install
USER esp-idf
RUN ./ct-ng xtensa-esp32-elf
RUN ./ct-ng build
RUN chmod -R u+w builds/xtensa-esp32-elf
ENV PATH /build/crosstool-NG/builds/xtensa-esp32-elf/bin:$PATH


