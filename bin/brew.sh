#!/bin/zsh
set -e

source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"

source ~/.zshrc || true

SELECTED_BREWFILE="$ROOT_DIR/.brewfile_selected"

brew update

if [[ -f "$SELECTED_BREWFILE" ]]; then
  brew bundle --file="$SELECTED_BREWFILE"
  rm -f "$SELECTED_BREWFILE"
else
  brew bundle --file="$ROOT_DIR"/files/Brewfile
fi

# Accept Xcode license with agreement
sudo xcodebuild -license accept || true
