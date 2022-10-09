#!/bin/bash
export DOCKER_BUILDKIT=1
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

(cd $SCRIPT_DIR/.. && \
docker build \
--build-arg BASE_IMAGE=arm64v8/python:3 \
--platform linux/arm64/v8 \
-t "henk-9000:app-arm64" \
.)
