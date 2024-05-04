#!/bin/zsh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR"/.. && pwd)"

source ~/.zshrc || true

ln -sf "$DOTFILES_DIR"/files/vimrc ~/.vimrc
ln -sf "$DOTFILES_DIR"/files/tmux.conf ~/.tmux.conf
ln -sf "$DOTFILES_DIR"/files/zshrc ~/.zshrc
ln -sf "$DOTFILES_DIR"/files/zprezto ~/.zprezto
ln -sf "$DOTFILES_DIR"/files/git/gitconfig ~/.gitconfig
