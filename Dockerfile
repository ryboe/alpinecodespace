# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:alpine

LABEL org.opencontainers.image.authors="Ryan Boehning <1250684+ryboe@users.noreply.github.com>"

# Install the latest gh CLI tool. The first request fetches the URL for the
# latest release tarball. The second request downloads the tarball.
RUN <<-EOT
  wget --quiet --timeout=30 --output-document=- 'https://api.github.com/repos/cli/cli/releases/latest' |
  jq -r ".assets[] | select(.name | test(\"gh_.*?_linux_amd64.tar.gz\")).browser_download_url" |
  wget --quiet --timeout=180 --input-file=- --output-document=- |
  sudo tar -xvz -C /usr/local/ --strip-components=1
EOT

# Many tools need a C compiler (gcc) and a C stdlib (musl-dev).
RUN apk add --no-cache gcc musl-dev

# Change vscode default shell to zsh.
RUN sed -i 's/\/home\/vscode:\/bin\/bash/\/home\/vscode:\/bin\/zsh/' /etc/passwd
USER vscode
