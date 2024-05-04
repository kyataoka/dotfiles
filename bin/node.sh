#!/bin/zsh
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."

source ~/.zshrc || true

npm install -g yarn
npm install -g pnpm
