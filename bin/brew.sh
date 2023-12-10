#!/bin/zsh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

brew update
brew bundle --file="$SCRIPT_DIR"/../files/Brewfile

source ~/.zshrc