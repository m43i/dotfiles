#!/usr/bin/env bash
set -e

sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra ripgrep
git clone -b v0.11.2 https://github.com/neovim/neovim.git $HOME/tools/neovim

cd $HOME/tools/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
