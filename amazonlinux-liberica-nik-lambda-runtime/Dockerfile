# install base linux + tools
ARG AWS_LINUX_VERSION=2.0.20230912.0
FROM amazonlinux:$AWS_LINUX_VERSION

RUN yum install -y gcc gcc-c++ libc6-dev binutils zlib1g-dev curl bash zlib zlib-devel tar zip gzip

# get liberica jdk...
ARG DIR_NAME=24.1.1
ARG JAVA_VERSION=23.0.1+13
ARG NIK_VERSION=24.1.1+1
ARG ARCH=aarch64
ENV LANG=en_US.UTF-8

# copy the setup script into the Docker image
COPY setup_liberica.sh /tmp/setup_liberica.sh

# make the script executable
RUN chmod +x /tmp/setup_liberica.sh

# run the setup script which will download the liberica nik and extract it
RUN /tmp/setup_liberica.sh

# add lambda runtime bootstrap script
COPY bootstrap .
RUN chmod 777 bootstrap

# add script to create native executable and zip it
COPY packageZip .
RUN chmod 777 packageZip

# set entry point script - this takes 2 args:
# 1. the input UberJar
# 2. the path to the output ZIP (optional, defaults to function.zip)
ENTRYPOINT ["./packageZip"]