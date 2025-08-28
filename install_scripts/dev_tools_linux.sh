#!/usr/bin/env bash

# GOLANG
if ! command -v go &> /dev/null; then
    curl -L -O https://go.dev/dl/go1.24.5.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.24.5.linux-amd64.tar.gz
    rm go1.24.5.linux-amd64.tar.gz
fi

# NODE
if ! command -v node &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
fi

# RUST
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# ZIG
if ! command -v zig &> /dev/null; then
    sudo dnf install zig -y
fi

# LazyGit
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit -y
