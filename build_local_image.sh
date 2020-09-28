#!/bin/bash

source ./_common.sh

function build_docker_image() {
  local docker_image_name=${2}
  local release_version=${3}

  DOCKER_IMAGE_TAGS=()

  DOCKER_IMAGE_TAGS+=(${docker_image_name}:${release_version}-${TIMESTAMP})
  DOCKER_IMAGE_TAGS+=(${docker_image_name}:${release_version})

  docker build \
    --build-arg LABEL_BUILD_DATE=$(date "${CURRENT_DATE}" "+%Y-%m-%dT%H:%M:%SZ") \
    --build-arg LABEL_NAME="${docker_image_name}-${release_version}" \
    --build-arg LABEL_VCS_REF=$(git rev-parse HEAD) \
    --build-arg LABEL_VCS_URL=$(git config --get remote.origin.url) \
    --build-arg LABEL_VERSION="${release_version}" \
    --build-arg APPLICATION_SERVER="${5}" \
    $(get_docker_image_tags_args ${DOCKER_IMAGE_TAGS[@]}) \
    ${TEMP_DIR}
}

function check_usage() {
  if [ ! -n "${3}" ]; then
    echo "Usage: ${0} path-to-bundle image-name version [push] [application server]"
    echo ""
    echo "Example: ${0} ../bundles/master portal-snapshot demo-cbe09fb0 push jboss-eap"

    exit 1
  fi

  check_utils curl docker java
}

function main() {
  check_usage ${@}

  make_temp_directory

  if [[ ${5} == "jboss-eap" ]]; then

    prepare_temp_for_manual_installation "${@}"

    prepare_jboss_eap

  else
    prepare_temp_directory ${@}

    prepare_tomcat
  fi

  build_docker_image ${@}

  if [[ ${5} != "jboss-eap" ]]; then
    test_docker_image
  fi

  push_docker_images ${4}

  clean_up_temp_directory
}

function prepare_temp_directory() {
  cp -a ${1} ${TEMP_DIR}/liferay
}

main ${@}
