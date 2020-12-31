FROM ubuntu:16.04 as stage1
RUN apt-get update && apt-get install -y gawk gperf grep gettext python python-dev automake bison flex texinfo help2man libtool libtool-bin make vim git bzip2 xz-utils unzip libncurses5-dev wget gcc g++

RUN useradd esp-idf
RUN mkdir /github
RUN chown esp-idf /github
USER esp-idf

WORKDIR /github
RUN git clone -b xtensa-1.22.x https://github.com/espressif/crosstool-NG.git
WORKDIR /github/crosstool-NG
RUN git checkout 2852398

RUN ./bootstrap 
RUN ./configure --enable-local
RUN make 
USER root
RUN make install
USER esp-idf
RUN ./ct-ng xtensa-esp32-elf
RUN ./ct-ng build

FROM ubuntu:16.04 as stage2
RUN apt-get update && apt-get install -y gawk gperf grep gettext python python-dev automake bison flex texinfo help2man libtool libtool-bin make vim git bzip2 xz-utils unzip libncurses5-dev wget gcc g++
COPY --from=stage1 /github/crosstool-NG/builds/xtensa-esp32-elf /usr/local
RUN useradd esp-idf
RUN mkdir /github
RUN chown esp-idf /github
USER esp-idf
WORKDIR /github
RUN git clone -b v3.3.3 --recursive https://github.com/espressif/esp-idf.git
WORKDIR /github/esp-idf
RUN git checkout v3.3.3
ENV IDF_PATH /github/esp-idf
USER root
RUN apt-get install -y python-pip
RUN pip install --user -r /github/esp-idf/requirements.txt
