
FROM gcr.io/kaniko-project/executor:v0.16.0 AS kaniko

FROM jenkins/inbound-agent:latest-alpine
USER root

RUN apk --update add \
  bash \
  curl \
  git \
  jq \
  unzip \
  npm

#
# Add kaniko to this image by re-using binaries and steps from official image
#
COPY --from=kaniko /kaniko/ /kaniko/

ENV SSL_CERT_DIR /kaniko/ssl/certs
ENV PATH $PATH:/usr/local/bin:/kaniko
ENV DOCKER_CONFIG /kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG /kaniko/.config/gcloud/docker_credential_gcr_config.json

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install

COPY files/Dockerfile.example /home/Dockerfile
COPY files/config.json /kaniko/.docker/config.json
RUN chmod 755 /home/Dockerfile /kaniko/.docker/config.json

USER root

