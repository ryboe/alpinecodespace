# alpinecodespace

An [Alpine](https://www.alpinelinux.org) docker image for use as the base image
for a custom [Codespace](https://github.com/features/codespaces) project.

## Features

Since it's based on the `mcr.microsoft.com/vscode/devcontainers/base:alpine`
image, it supports all Codespace features. In addition, it has these changes:

1. The default user will be `vscode`.
2. The `vscode` user's default shell is `/bin/zsh`.
3. These packages are installed:

   ```txt
   gcc
   musl-dev
   ```

## Usage

Here are some examples of how to create a custom Codespace images:

### Go

```dockerfile
# syntax=docker/dockerfile:1
ARG GO_VERSION
FROM golang:${GO_VERSION}-alpine AS build
ENV CGO_ENABLED="0"

# These are all the tools installed by the "Go: Install/Update Tools"
# command, plus gofumpt. gofumpt is a stricter gofmt that enforces additional
# formatting rules for better consistency and readabilty.
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    <<-EOT
    go install github.com/cweill/gotests/gotests@latest
    go install github.com/fatih/gomodifytags@latest
    go install github.com/josharian/impl@latest
    go install github.com/haya14busa/goplay/cmd/goplay@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install golang.org/x/tools/gopls@latest
    go install mvdan.cc/gofumpt@latest
EOT


FROM ghcr.io/ryboe/alpinecodespace:latest
ENV PATH="/home/vscode/go/bin:/usr/local/go/bin:${PATH}"
COPY --from=build /usr/local/go/ /usr/local/go/
COPY --from=build /go/bin/ /home/vscode/go/bin
```

### Rust

```dockerfile
# syntax=docker/dockerfile:1
ENV PATH="$HOME/.cargo/bin:$PATH"

RUN set -o pipefail \
    && curl --retry 3 --retry-delay 2 --max-time 30 -sSfL https://sh.rustup.rs | sh -s -- -y
```
