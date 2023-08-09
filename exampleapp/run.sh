#!/usr/bin/env bash
set -eE -o pipefail
cd "$(dirname "$0")"

: ${APP_NAME:="k8s-exer-exampleapp"}
: ${APP_VERSION:="latest"}
: ${REGISTRY_ADDR:="${REGISTRY_ADDR:-""}"}
: ${REGISTRY_ADDR:="${K3D_REGISTRY_LOCAL_ADDR:-""}"}
: ${REGISTRY_ADDR:="${K3D_REGISTRY_ADDR:-""}"}
: ${REGISTRY_ADDR:?"registry address is required"}
export TAG="${REGISTRY_ADDR}/${APP_NAME}:${APP_VERSION}"

docker build -t "${TAG}" .
trap "docker rmi '${TAG}'" EXIT 
docker run -it "${TAG}"
