#!/bin/zsh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
CONFIG_FILE="$ROOT_DIR"/config.ini

source ~/.zshrc || true

brew update
brew bundle --file="$ROOT_DIR"/files/Brewfile

# Accept Xcode license with agreement
sudo xcodebuild -license accept || true
