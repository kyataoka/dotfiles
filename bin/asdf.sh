#!/bin/zsh
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
CONFIG_FILE="$ROOT_DIR"/config.ini

source ~/.zshrc

root_password=$(awk -F ' = ' '/^\[password\]/{f=1} f==1&&/^root_password/{gsub(/"/, "", $2); print $2; f=0}' $CONFIG_FILE)
echo $root_password | sudo -Sv

set -e

# Install nodejs
asdf plugin add nodejs
asdf install nodejs $(asdf latest nodejs)
asdf global nodejs $(asdf latest nodejs)

# Install flutter
asdf plugin add flutter
asdf install flutter $(asdf latest flutter)
asdf global flutter $(asdf latest flutter)
