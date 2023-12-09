#!/bin/zsh

asdf plugin add nodejs
asdf install nodejs lts
asdf global nodejs lts

asdf plugin add flutter
asdf install flutter 3.10.5-stable
asdf install flutter 3.7.4-stable
asdf install flutter 3.3.1-stable
asdf global flutter 3.10.5-stable