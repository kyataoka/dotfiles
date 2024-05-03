#!/bin/zsh
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
CONFIG_FILE="$ROOT_DIR"/config.ini

root_password=$(awk -F ' = ' '/^\[password\]/{f=1} f==1&&/^root_password/{gsub(/"/, "", $2); print $2; f=0}' $CONFIG_FILE)
echo $root_password | sudo -Sv

# Install Xcode command line tools
xcode-select --install

# Accept Xcode license with agreement
sudo xcodebuild -license accept

# Install Rosetta 2 for Apple Silicon
if [ "$(uname -m)" = "arm64" ]; then
  softwareupdate --install-rosetta --agree-to-license
fi

# Install Prezto
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
fi

# Install Homebrew
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "${ZDOTDIR:-$HOME}/.zprofile"
fi

# Set up Homebrew environment
eval "$(/opt/homebrew/bin/brew shellenv)"
