# docker build -t senzing/sz-quickstart-loader .
# docker run --user $UID -it -v $PWD:/data -e SENZING_ENGINE_CONFIGURATION_JSON senzing/sz-quickstart-loader -f /data/<input-file>

ARG BASE_IMAGE=senzing/senzingsdk-runtime:4.4.1@sha256:bdc8cd2cf4799a25092d3ec8ed23d916b9d28a3b5e3271973c1ebfac6e3d993c
FROM ${BASE_IMAGE}

ARG VERSION=dev
LABEL Name="senzing/sz-file-loader" \
      Maintainer="support@senzing.com" \
      Version="${VERSION}"

ENV REFRESHED_AT=2026-09-17

USER root

RUN apt-get update \
 && apt-get -y install --no-install-recommends senzingsdk-poc \
 && apt-get -y autoremove \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

ENV PYTHONPATH=/opt/senzing/er/sdk/python

USER 1001

WORKDIR /tmp

# Batch CLI loader (runs and exits) — no long-running service to health-check.
HEALTHCHECK NONE
ENTRYPOINT ["/opt/senzing/er/bin/sz_file_loader"]

