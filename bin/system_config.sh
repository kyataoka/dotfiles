#!/bin/zsh
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
TMP_DIR="$(cd "$(dirname "$0")" && pwd)/../tmp"

mkdir -p "$TMP_DIR"

# Change default browser
git clone https://github.com/kerma/defaultbrowser.git "$TMP_DIR/defaultbrowser"
cd "$TMP_DIR/defaultbrowser"
make
make install
defaultbrowser chrome
make uninstall
cd "$ROOT_DIR"

# Enable key press and hold
defaults write -g ApplePressAndHoldEnabled -bool true

# Remove all default apps from dock
defaults write com.apple.dock persistent-apps -array

# Set dock size
defaults write com.apple.dock tilesize -int 36

# Hide App Suggestions
defaults write com.apple.dock show-recents -bool false

# Restart Dock
killall Dock

rm -rf "$TMP_DIR"
