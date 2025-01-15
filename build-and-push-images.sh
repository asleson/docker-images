#!/bin/bash
set -eu
docker login

JAVA_VERSIONS=("11.0.18" "17.0.6" "19.0.2" "21.0.3")

cd amazoncorretto-lambda-runtime
for java_version in "${JAVA_VERSIONS[@]}"; do
    echo "Building and pushing amazoncorretto-lambda-runtime $java_version"
    ./build-and-push.sh "$java_version"
done
cd ..

cd amazoncorretto-lambda-runtime-arm64
for java_version in "${JAVA_VERSIONS[@]}"; do
    echo "Building and pushing amazoncorretto-lambda-runtime-arm64 $java_version"
    ./build-and-push.sh "$java_version"
done
cd ..

GRAAL_JAVA_VERSIONS=("21.0.0" "22.0.1")
AWS_LINUX_VERSIONS=("2.0.20240412.0")

cd amazonlinux-java-graal-community-lambda-runtime
for java_version in "${GRAAL_JAVA_VERSIONS[@]}"; do
  for linux_version in "${AWS_LINUX_VERSIONS[@]}"; do
    echo "Building and pushing amazonlinux-java-graal-community-lambda-runtime $java_version $linux_version"
    ./build-and-push.sh "$java_version" "$linux_version"
  done
done
cd ..

LIBERICA_NIK_VERSIONS=("23.0.6|17.0.13+12|23.0.6+1" "24.1.1|23.0.1+13|24.1.1+1")

cd amazonlinux-liberica-nik-lambda-runtime
for version_group in "${LIBERICA_NIK_VERSIONS[@]}"; do
  IFS='|' read -r -a sub_array <<< "${version_group}"
  dir_name="${sub_array[0]}"
  jdk_version="${sub_array[1]}"
  nik_version="${sub_array[2]}"
  for linux_version in "${AWS_LINUX_VERSIONS[@]}"; do
    echo "Building and pushing amazonlinux-java-liberica-lambda-runtime $dir_name $jdk_version $nik_version $linux_version"
    ./build-and-push.sh $dir_name $jdk_version $nik_version $linux_version
  done
done
cd ..
