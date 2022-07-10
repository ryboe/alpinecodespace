FROM mcr.microsoft.com/vscode/devcontainers/base:alpine

LABEL org.opencontainers.image.authors="Ryan Boehning <1250684+ryboe@users.noreply.github.com>"

# dlv needs gcc and musl-dev. The rest are useful dev tools.
RUN apk add --no-cache fd file fzf gcc musl-dev ripgrep

# Install the latest gh CLI tool. The first request fetches the URL for the
# latest release tarball. The second request downloads the tarball.
RUN wget --quiet --timeout=30 --output-document=- 'https://api.github.com/repos/cli/cli/releases/latest' \
    | jq -r '.assets[] | select(.name | test("gh_.*?_linux_amd64.tar.gz")).browser_download_url' \
    | wget --quiet --timeout=180 --input-file=- --output-document=- \
    | sudo tar -xvz -C /usr/local/ --strip-components=1

RUN wget --quiet --timeout=30 --output-document=/usr/local/bin/gitprompt https://github.com/ryboe/gitprompt/releases/latest/download/gitprompt-x86_64-unknown-linux-musl \
    && chmod +x /usr/local/bin/gitprompt

# Change vscode default shell to zsh.
RUN sed -i 's/\/home\/vscode:\/bin\/bash/\/home\/vscode:\/bin\/zsh/' /etc/passwd
USER vscode
