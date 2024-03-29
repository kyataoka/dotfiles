#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR"/.. && pwd)"

ln -sf "$DOTFILES_DIR"/vimrc ~/.vimrc
ln -sf "$DOTFILES_DIR"/tmux.conf ~/.tmux.conf
ln -sf "$DOTFILES_DIR"/zshrc ~/.zshrc
ln -sf "$DOTFILES_DIR"/zprezto ~/.zprezto
ln -sf "$DOTFILES_DIR"/gitconfig ~/.gitconfig
