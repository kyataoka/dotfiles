#!/bin/zsh
set -e

source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"

source ~/.zshrc || true

ln -sf "$ROOT_DIR"/files/vimrc ~/.vimrc
ln -sf "$ROOT_DIR"/files/tmux.conf ~/.tmux.conf
ln -sf "$ROOT_DIR"/files/zshrc ~/.zshrc
ln -sf "$ROOT_DIR"/files/zpreztorc ~/.zpreztorc
ln -sf "$ROOT_DIR"/files/git/gitconfig ~/.gitconfig
ln -sf "$ROOT_DIR"/files/git/gitignore ~/.gitignore
