#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR"/.. && pwd)"

ln -sf "$DOTFILES_DIR"/vimrc ~/.vimrc
ln -sf "$DOTFILES_DIR"/tmux.conf ~/.tmux.conf