#!/bin/zsh

source ~/.zshrc

sudo -v

set -e

# Install nodejs
asdf plugin add nodejs
asdf install nodejs $(asdf latest nodejs)
asdf global nodejs $(asdf latest nodejs)

# Install flutter
asdf plugin add flutter
asdf install flutter $(asdf latest flutter)
asdf global flutter $(asdf latest flutter)
