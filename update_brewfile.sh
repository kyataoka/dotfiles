#!/bin/zsh
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

brew update
brew bundle dump \
  --formula \
  --cask \
  --tap \
  --mas \
  --force \
  --file="$ROOT_DIR/files/Brewfile"
