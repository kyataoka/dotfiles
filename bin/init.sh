#!/bin/zsh

xcode-select --install

# Install rosetta2
if [ "$(uname -m)" = "arm64" ]; then
  softwareupdate --install-rosetta --agree-to-license
fi

# Install Prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/kataokahiroki/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
