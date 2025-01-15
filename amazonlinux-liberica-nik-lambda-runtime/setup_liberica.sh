#!/bin/bash

# get the major version of NIK
NIK_MAJOR_VERSION=$(( $(echo ${NIK_VERSION} | cut -d. -f1) + 0 ))
echo "NIK Major version: $NIK_MAJOR_VERSION"

# the filename stucture is different between NIK versions less than 24
# so build the filename based on the NIK major version
if [ "$NIK_MAJOR_VERSION" -lt 24 ]; then
    LIBERICA_FILENAME="bellsoft-liberica-vm-core-openjdk${JAVA_VERSION}-${NIK_VERSION}-linux-${ARCH}.tar.gz"
else
    LIBERICA_FILENAME="bellsoft-liberica-vm-openjdk${JAVA_VERSION}-${NIK_VERSION}-linux-${ARCH}.tar.gz"
fi

echo "LIBERICA_FILENAME=$LIBERICA_FILENAME"

LIBERICA_URL="https://download.bell-sw.com/vm/${DIR_NAME}/${LIBERICA_FILENAME}"
echo "LIBERICA_URL=${LIBERICA_URL}"

# download the file using curl
curl -4 -L $LIBERICA_URL -o /tmp/$LIBERICA_FILENAME

# extract file to /tmp directory, then search for all directories in /tmp created after the
# extraction, and move them to /tmp
tar -zxvf /tmp/${LIBERICA_FILENAME} -C /tmp && \
    for dir in $(find /tmp -mindepth 1 -maxdepth 1 -type d -cnewer /tmp/${LIBERICA_FILENAME}); do \
        mv "$dir" /usr/lib/graalvm; \
    done
rm -rf /tmp/*


