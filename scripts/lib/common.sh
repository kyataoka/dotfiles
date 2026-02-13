# 共通変数定義
# 各スクリプトから source して利用する
# zsh では source 時に $0 が source 先のパスになるため、
# このファイルの位置から ROOT_DIR を算出する

ROOT_DIR="$(cd "$(dirname "$0")"/../.. && pwd)"
CONFIG_FILE="$ROOT_DIR/config.ini"
