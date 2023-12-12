FROM golang:1.20-alpine AS go-builder

ARG VERSION=v0.1.9

# Set up dependencies
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3

ADD https://github.com/CascadiaFoundation/cascadia/releases/download/${VERSION}/cascadiad ./

RUN mv cascadiad /usr/local/bin/

WORKDIR /root/.cascadiad/bin

RUN chmod a+x /usr/local/bin/cascadiad*
