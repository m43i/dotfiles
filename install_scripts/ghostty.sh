#!/usr/bin/env bash

if command -v pacman &> /dev/null; then
    sudo pacman -Syu --noconfirm ghostty
elif command -v dnf &> /dev/null; then
    sudo dnf copr enable pgdev/ghostty -y
    sudo dnf install ghostty -y
fi
