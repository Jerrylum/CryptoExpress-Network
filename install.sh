#!/bin/bash

# This will download the .tar.gz
download() {
    local BINARY_FILE=$1
    local URL=$2
    local DEST_DIR=$(pwd)
    echo "===> Downloading: " "${URL}"
    if [ -d fabric-samples ]; then
       DEST_DIR="fabric-samples"
    fi
    echo "===> Will unpack to: ${DEST_DIR}"
    curl -L --retry 5 --retry-delay 3 "${URL}" | tar xz -C ${DEST_DIR}|| rc=$?
    if [ -n "$rc" ]; then
        echo "==> There was an error downloading the binary file."
        return 22
    else
        echo "==> Done."
    fi
}

pullBinaries() {
    echo "===> Downloading version ${FABRIC_TAG} platform specific fabric binaries"
    download "${BINARY_FILE}" "https://github.com/hyperledger/fabric/releases/download/v${VERSION}/${BINARY_FILE}"
    if [ $? -eq 22 ]; then
        echo
        echo "------> ${FABRIC_TAG} platform specific fabric binary is not available to download <----"
        echo
        exit
    fi

    echo "===> Downloading version ${CA_TAG} platform specific fabric-ca-client binary"
    download "${CA_BINARY_FILE}" "https://github.com/hyperledger/fabric-ca/releases/download/v${CA_VERSION}/${CA_BINARY_FILE}"
    if [ $? -eq 22 ]; then
        echo
        echo "------> ${CA_TAG} fabric-ca-client binary is not available to download  (Available from 1.1.0-rc1) <----"
        echo
        exit
    fi
}

_arg_fabric_version="2.5.6"
_arg_ca_version="1.5.9"
VERSION=$_arg_fabric_version
CA_VERSION=$_arg_ca_version

# prior to 1.2.0 architecture was determined by uname -m
if [[ $VERSION =~ ^1\.[0-1]\.* ]]; then
    export FABRIC_TAG=${MARCH}-${VERSION}
    export CA_TAG=${MARCH}-${CA_VERSION}
else
    # starting with 1.2.0, multi-arch images will be default
    : "${CA_TAG:="$CA_VERSION"}"
    : "${FABRIC_TAG:="$VERSION"}"
fi

# Prior to fabric 2.5, use amd64 binaries on darwin-arm64
OS=$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')
ARCH=$(uname -m | sed 's/x86_64/amd64/g' | sed 's/aarch64/arm64/g')
PLATFORM=${OS}-${ARCH}
if [[ $VERSION =~ ^2\.[0-4]\.* ]]; then
  PLATFORM=$(echo $PLATFORM | sed 's/darwin-arm64/darwin-amd64/g')
fi
echo $PLATFORM

BINARY_FILE=hyperledger-fabric-${PLATFORM}-${VERSION}.tar.gz
CA_BINARY_FILE=hyperledger-fabric-ca-${PLATFORM}-${CA_VERSION}.tar.gz

echo
echo "Pull Hyperledger Fabric binaries"
echo
pullBinaries