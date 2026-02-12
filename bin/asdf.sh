#!/bin/zsh
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
CONFIG_FILE="$ROOT_DIR"/config.ini

source ~/.zshrc || true

# Install nodejs
asdf plugin add nodejs || true
asdf install nodejs $(asdf latest nodejs)
asdf set --home nodejs $(asdf latest nodejs)

# Install flutter
asdf plugin add flutter || true
asdf install flutter $(asdf latest flutter)
asdf set --home flutter $(asdf latest flutter)

# Install golang
asdf plugin add golang || true
asdf install golang $(asdf latest golang)
asdf set --home golang $(asdf latest golang)
