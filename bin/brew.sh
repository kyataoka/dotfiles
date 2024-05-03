#!/bin/zsh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
CONFIG_FILE="$ROOT_DIR"/config.ini

source ~/.zshrc

root_password=$(awk -F ' = ' '/^\[password\]/{f=1} f==1&&/^root_password/{gsub(/"/, "", $2); print $2; f=0}' $CONFIG_FILE)
echo $root_password | sudo -Sv

brew update
brew bundle --file="$SCRIPT_DIR"/../files/Brewfile