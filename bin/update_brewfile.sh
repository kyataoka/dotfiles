#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

brew update
brew bundle dump \
  --formula \
  --cask \
  --tap \
  --mas \
  --force \
  --file="$SCRIPT_DIR/../files/Brewfile"