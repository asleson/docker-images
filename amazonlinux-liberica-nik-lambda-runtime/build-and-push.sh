#!/bin/sh
set -eu
export DIR_NAME=$1
export JAVA_VERSION=$2
export NIK_VERSION=$3
export AWS_LINUX_VERSION=$4

# replace a + character in the versions with _
export FORMATTED_JAVA_VERSION="${JAVA_VERSION//+/_}"
export FORMATTED_NIK_VERSION="${NIK_VERSION//+/_}"

docker build --platform linux/arm64 --build-arg AWS_LINUX_VERSION=$AWS_LINUX_VERSION \
--build-arg ARCH=aarch64 \
--build-arg JAVA_VERSION="$JAVA_VERSION" \
--build-arg DIR_NAME="$DIR_NAME" \
--build-arg NIK_VERSION="$NIK_VERSION" \
-t http4k/amazonlinux-liberica-nik-lambda-runtime:latest-arm64 \
-t http4k/amazonlinux-liberica-nik-lambda-runtime:amazonlinux$AWS_LINUX_VERSION-"$FORMATTED_JAVA_VERSION"-"$FORMATTED_NIK_VERSION"-arm64 .

docker build --platform linux/amd64 --build-arg AWS_LINUX_VERSION=$AWS_LINUX_VERSION \
--build-arg ARCH=amd64 \
--build-arg JAVA_VERSION="$JAVA_VERSION" \
--build-arg DIR_NAME="$DIR_NAME" \
--build-arg NIK_VERSION="$NIK_VERSION" \
-t http4k/amazonlinux-liberica-nik-lambda-runtime \
-t http4k/amazonlinux-liberica-nik-lambda-runtime:latest \
-t http4k/amazonlinux-liberica-nik-lambda-runtime:amazonlinux$AWS_LINUX_VERSION-"$FORMATTED_JAVA_VERSION"-"$FORMATTED_NIK_VERSION" .

docker push -a http4k/amazonlinux-liberica-nik-lambda-runtime
