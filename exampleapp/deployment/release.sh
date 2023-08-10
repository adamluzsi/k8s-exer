#!/usr/bin/env bash
set -eE -o pipefail
cd "$(dirname "$0")"
source .envrc

(
  type cat
  type envsubst
  type echo
  type kubectl
) 1>/dev/null

: ${REGISTRY_ADDR:="${REGISTRY_ADDR:-""}"}
: ${REGISTRY_ADDR:="${K3D_REGISTRY_LOCAL_ADDR:-""}"}
: ${REGISTRY_ADDR:="${K3D_REGISTRY_ADDR:-""}"}

: ${REGISTRY_ADDR:?"required"}
: ${APP_NAME:?"required"}
: ${APP_VERSION:?"required"}
: ${KUBECONFIG:?"required"}

function main() {
  #releaseApp
  deployApp
}

function releaseApp() {
  local TAG
  TAG="${REGISTRY_ADDR}/${APP_NAME}:${APP_VERSION}"
  echo "TAG: ${TAG}"
  docker build -t "${TAG}" .
  docker push "${TAG}"
  docker rmi "${TAG}"
}

function deployApp() {
  # k8s deployment
  cat deployment.envsubst.yaml | envsubst >deployment.yaml
  kubectl apply -f deployment.yaml
  kubectl get deployment "${APP_NAME}"
  kubectl describe deployment "${APP_NAME}"
  
  local done="" state
  echo # new line for printing
  while true; do
    state=$(kubectl get pods -l "app=${APP_NAME}")
    if echo "${state}" | grep -q -i -e 'Running\|Terminated' ; then
      echo "${state}"
      break
    fi
    if echo "${state}" | grep -q -i -e 'No resources found in default namespace'; then
      echo "${state}"
      return 1
    fi
    sleep 1
    printf "\rdeployment is running"
  done
   
  kubectl rollout status deployment/"${APP_NAME}"
}

function rollback() {
    kubectl rollout undo deployment/${APP_NAME}
}

main "${@}"
