#!/usr/bin/env bash
set -e

sudo dnf -y install cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel g++
git clone -b v0.15.1 https://github.com/alacritty/alacritty.git $HOME/tools/alacritty

cd $HOME/tools/alacritty
cargo build --release
sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
