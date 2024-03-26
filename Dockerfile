FROM devopsworks/golang-upx:1.22.1-1

ARG GOPROXY
ARG TARGETARCH=${TARGETARCH:-amd64}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install various tools
RUN go install honnef.co/go/tools/cmd/staticcheck@latest; \
    go install github.com/goreleaser/goreleaser@latest

# Install golang-ci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | \
    sh -s -- -b $(go env GOPATH)/bin v1.57.1
