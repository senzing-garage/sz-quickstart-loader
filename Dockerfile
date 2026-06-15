# docker build -t brian/sz_sqs_consumer .
# docker run --user $UID -it -v $PWD:/data -e AWS_DEFAULT_REGION -e AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID -e AWS_SESSION_TOKEN -e SENZING_ENGINE_CONFIGURATION_JSON brian/sz_sqs_consumer -q <queue url>

ARG BASE_IMAGE=senzing/senzingsdk-runtime:4.3.1@sha256:705e35afbffaf557455317a8c125dc38b0693810e8b0c124cfba87fde1d6194b
FROM ${BASE_IMAGE}

ARG VERSION=dev
LABEL Name="senzing/sz_file_loader" \
      Maintainer="support@senzing.com" \
      Version="${VERSION}"

USER root

RUN apt-get update \
 && apt-get -y install senzingsdk-poc\
 && apt-get -y autoremove \
 && apt-get -y clean

ENV PYTHONPATH=/opt/senzing/er/sdk/python

USER 1001

WORKDIR /tmp
ENTRYPOINT ["/opt/senzing/er/bin/sz_file_loader"]

