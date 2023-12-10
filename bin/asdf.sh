#!/bin/zsh

set -e

sudo xcodebuild -license

asdf plugin add nodejs
asdf install nodejs lts
asdf global nodejs lts

asdf plugin add flutter
asdf install flutter $(asdf latest flutter)
asdf global flutter $(asdf latest flutter)
