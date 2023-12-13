FROM golang:1.20-alpine AS go-builder

ARG VERSION=v0.1.9

# Set up dependencies
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3

ADD https://github.com/CascadiaFoundation/cascadia/releases/download/${VERSION}/cascadiad-${VERSION}-linux-amd64.tar.gz ./

# Extract
RUN tar -xzf "cascadiad-${VERSION}-linux-amd64.tar.gz" && \
    rm -f "cascadiad-${VERSION}-linux-amd64.tar.gz"

# Final image
FROM ubuntu:focal

# Install ca-certificates
RUN apt-get update && apt-get --no-install-recommends --yes install \
    ca-certificates

# Copy over binaries and libraries from the build-env
COPY --from=go-builder /go/bin/cascadiad /usr/bin/cascadiad

ENV GOBIN=/go/bin
WORKDIR /root/.cascadiad/bin

RUN chmod a+x /usr/bin/cascadiad*

CMD ["/bin/bash"]
