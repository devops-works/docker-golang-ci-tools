FROM devopsworks/golang-upx:1.22.1-1

ARG GOPROXY
ARG TARGETARCH=${TARGETARCH:-amd64}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


# Install golang-ci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | \
    sh -s -- -b $(go env GOPATH)/bin v1.57.1

# Install various tools
RUN go install honnef.co/go/tools/cmd/staticcheck@latest && \
    go install github.com/goreleaser/goreleaser@latest && \
    rm -rf  /go/pkg/

RUN  apt-get remove -y docker.io docker-doc docker-compose podman-docker containerd runc || true && \
     apt-get update && apt-get -y install ca-certificates curl && \
     install -m 0755 -d /etc/apt/keyrings && \
     curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
     chmod a+r /etc/apt/keyrings/docker.asc && \
     echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
       tee /etc/apt/sources.list.d/docker.list > /dev/null && \
     apt-get update && \
     apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin podman && \
     rm -rf /var/lib/apt/lists/*
