#!/usr/bin/env bash

sudo rm -rf /usr/local/go
curl -L -O https://go.dev/dl/go1.24.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.24.5.linux-amd64.tar.gz
rm go1.24.5.linux-amd64.tar.gz
