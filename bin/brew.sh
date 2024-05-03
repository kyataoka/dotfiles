#!/bin/zsh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
CONFIG_FILE="$ROOT_DIR"/config.ini

source ~/.zshrc

brew update
brew bundle --file="$ROOT_DIR"/files/Brewfile