#!/bin/zsh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source ~/.zshrc

sudo -v

brew update
brew bundle --file="$SCRIPT_DIR"/../files/Brewfile