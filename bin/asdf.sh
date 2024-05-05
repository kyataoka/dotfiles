#!/bin/zsh
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
CONFIG_FILE="$ROOT_DIR"/config.ini

source ~/.zshrc || true

# Install nodejs
asdf plugin add nodejs
asdf install nodejs $(asdf latest nodejs)
asdf global nodejs $(asdf latest nodejs)

# Install flutter
asdf plugin add flutter
asdf install flutter $(asdf latest flutter)
asdf global flutter $(asdf latest flutter)
