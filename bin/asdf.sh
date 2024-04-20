#!/bin/zsh

set -e

asdf plugin add nodejs
asdf install nodejs $(asdf latest nodejs)
asdf global nodejs $(asdf latest nodejs)

asdf plugin add flutter
asdf install flutter $(asdf latest flutter)
asdf global flutter $(asdf latest flutter)
