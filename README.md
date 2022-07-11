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
   bat
   exa
   fd
   file
   fzf
   gcc
   gh
   gitprompt
   musl-dev
   ripgrep
   ```

   Regardless of your work, you're very likely to need a C compiler (`gcc`) and
   a libc (`musl-dev`). The rest are very useful utilities that I recommend.

## Usage

Here's an example of how to create a custom Go Codespace image from this image:

```dockerfile
FROM ghcr.io/ryboe/alpinecodespace:latest

COPY --from=goimage /usr/local/go/ /usr/local/go/

ENV GOPATH="/home/vscode/go"
ENV PATH="${GOPATH}/bin:/usr/local/go/bin:${PATH}"

# These are all the Go tools installed by the "Go: Install/Update Tools"
# command.
RUN go install github.com/haya14busa/goplay/cmd/goplay@latest
RUN go install github.com/josharian/impl@latest
RUN go install github.com/fatih/gomodifytags@latest
RUN go install github.com/cweill/gotests/gotests@latest
RUN go install mvdan.cc/gofumpt@latest
RUN go install golang.org/x/tools/gopls@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest
RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```
