#!/usr/bin/env bash

if !command -v tmux &> /dev/null; then
    if command -v pacman &> /dev/null; then
        sudo pacman -Syu --noconfirm tmux
    elif command -v dnf &> /dev/null; then
        sudo dnf -y install tmux
    fi

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
