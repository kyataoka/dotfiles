#!/bin/zsh
set -e

source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
source "$ROOT_DIR/scripts/lib/messages.sh"

source ~/.zshrc || true

SELECTED_BREWFILE="$ROOT_DIR/.brewfile_selected"

brew update

brewfile="$ROOT_DIR/files/brew/Brewfile"
if [[ -f "$SELECTED_BREWFILE" ]]; then
  brewfile="$SELECTED_BREWFILE"
fi

brew_exit=0
brew bundle --verbose --file="$brewfile" || brew_exit=$?

if [[ $brew_exit -ne 0 ]]; then
  echo "${_MSG[brew_bundle_failed]}"
  brew bundle check --verbose --file="$brewfile" || true
  if ! read -q "response?${_MSG[brew_continue_prompt]}"; then
    echo
    exit 1
  fi
  echo
fi

[[ "$brewfile" == "$SELECTED_BREWFILE" ]] && rm -f "$SELECTED_BREWFILE"

# Accept Xcode license with agreement
sudo xcodebuild -license accept || true
