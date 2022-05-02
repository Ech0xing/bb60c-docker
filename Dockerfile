FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y wget unzip build-essential libusb-1.0-0-dev

RUN mkdir /root/foss

##########
#  FTDI  #
##########

WORKDIR /root/foss
RUN wget https://ftdichip.com/wp-content/uploads/2021/09/libftd2xx-x86_64-1.4.24.tgz
RUN tar zxvf libftd2xx-x86_64-1.4.24.tgz --one-top-level

WORKDIR /root/foss/libftd2xx-x86_64-1.4.24/release
RUN cp ftd2xx.h /usr/include/
RUN cp WinTypes.h /usr/include/
RUN ldconfig

WORKDIR /root/foss/libftd2xx-x86_64-1.4.24/release/build
RUN cp libftd2xx.* /usr/lib/
RUN chmod 0755 /usr/lib/libftd2xx.so.1.4.24
RUN ln -sf /usr/lib/libftd2xx.so.1.4.24 /usr/lib/libftd2xx.so

######################
#  SIGNAL HOUND SDK  #
######################

WORKDIR /root/foss
RUN wget https://signalhound.com/download/bbsa-application-programming-interface-for-windows-3264-bit/ -O signal_hound_sdk.zip
RUN unzip signal_hound_sdk.zip

WORKDIR /root/foss/signal_hound_sdk/device_apis/bb_series/include
RUN cp bb_api.h /usr/include/

WORKDIR /root/foss/signal_hound_sdk/device_apis/bb_series/linux/lib/Ubuntu\ 18.04/
RUN ldconfig -v -n .
RUN ln -sf libbb_api.so.4 libbb_api.so
RUN cp libbb_api.* /usr/lib/

WORKDIR /root
