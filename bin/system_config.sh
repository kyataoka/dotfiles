#!/bin/zsh
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
TMP_DIR="$(cd "$(dirname "$0")" && pwd)/../tmp"

mkdir -p "$TMP_DIR"

#change default browser
git clone https://github.com/kerma/defaultbrowser.git $TMP_DIR/defaultbrowser
cd "$TMP_DIR/defaultbrowser"
make
make install
defaultbrowser chrome
make uninstall
cd $ROOT_DIR

sudo defaults write -g ApplePressAndHoldEnabled -bool true

rm -rf $TMP_DIR