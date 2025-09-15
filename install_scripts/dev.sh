#!/usr/bin/env bash

# Ensure mise is installed
if ! command -v mise &> /dev/null; then
    curl https://mise.run | sh
fi

# Detect if bash or zsh is being used
if [ -n "$ZSH_VERSION" ]; then
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
    source ~/.zshrc
elif [ -n "$BASH_VERSION" ]; then
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
    source ~/.bashrc
else
    echo "Unsupported shell. Please use bash or zsh."
    exit 1
fi

# Go
mise use -g go@1.25

# Java
mise use -g java@21

# Node
mise use -g node@22

# Bun
mise use -g bun@latest

# Zig
mise use -g zig@latest

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install tmux
source ./tmux.sh

# Install ghostty
source ./ghostty.sh

# Install alacritty
# source ./alacritty.sh

# Install nvim
source ./nvim.sh
