# docker build -t senzing/sz-quickstart-loader .
# docker run --user $UID -it -v $PWD:/data -e SENZING_ENGINE_CONFIGURATION_JSON senzing/sz-quickstart-loader -f /data/<input-file>

ARG BASE_IMAGE=senzing/senzingsdk-runtime:4.3.4@sha256:3426be4ee9e84200e7977b7731652a4267877e4f1cc913bc3732b10f979025b7
FROM ${BASE_IMAGE}

ARG VERSION=dev
LABEL Name="senzing/sz-file-loader" \
      Maintainer="support@senzing.com" \
      Version="${VERSION}"

ENV REFRESHED_AT=2026-07-31

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

