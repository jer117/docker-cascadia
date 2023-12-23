FROM golang:1.20-bullseye AS go-builder

ARG VERSION=v0.2.0

# Set Golang environment variables.
ENV GOPATH=/go
ENV PATH=$PATH:/go/bin

# Set up dependencies
ENV PACKAGES curl make git libc-dev bash gcc python3 wget

RUN apt-get update
RUN apt-get install -y $PACKAGES

# Update ca certs
RUN update-ca-certificates

ADD https://github.com/CascadiaFoundation/cascadia/releases/download/${VERSION}/cascadiad-${VERSION}-linux-amd64.tar.gz ./

# Extract
RUN tar -xzf "cascadiad-${VERSION}-linux-amd64.tar.gz" && \
    rm -f "cascadiad-${VERSION}-linux-amd64.tar.gz"

RUN mkdir -p /root/.cascadiad/bin
RUN mkdir /root/.cascadiad/config

WORKDIR /root/.cascadiad/bin

# Final image
FROM ubuntu:jammy

# Install ca-certificates
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y ca-certificates curl wget jq \
    && apt-get -y purge && apt-get -y clean

# Copy over binaries and libraries from the build-env
COPY --from=go-builder /go/bin/cascadiad /usr/bin/cascadiad

RUN chmod a+x /usr/bin/cascadiad*

CMD ["/bin/bash"]

COPY . .

ENV SHELL /bin/bash