#!/bin/bash
export DOCKER_BUILDKIT=1
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

(cd $SCRIPT_DIR/.. && \
docker build \
--build-arg BASE_IMAGE=python:3 \
--platform linux/amd64 \
-t "henk-9000:app-amd64" \
.)
