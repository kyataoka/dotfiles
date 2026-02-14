#!/bin/zsh
set -e

source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
source "$ROOT_DIR/scripts/lib/messages.sh"

source ~/.zshrc || true

SELECTED_BREWFILE="$ROOT_DIR/.brewfile_selected"

brew update

brew_exit=0
if [[ -f "$SELECTED_BREWFILE" ]]; then
  brew bundle --verbose --file="$SELECTED_BREWFILE" || brew_exit=$?
  rm -f "$SELECTED_BREWFILE"
else
  brew bundle --verbose --file="$ROOT_DIR"/files/brew/Brewfile || brew_exit=$?
fi

if [[ $brew_exit -ne 0 ]]; then
  echo "${_MSG[brew_bundle_failed]}"
  if ! read -q "response?${_MSG[brew_continue_prompt]}"; then
    echo
    exit 1
  fi
  echo
fi

# Accept Xcode license with agreement
sudo xcodebuild -license accept || true
