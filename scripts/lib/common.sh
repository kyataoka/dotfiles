# 共通変数定義
# 各スクリプトから source して利用する
# zsh では source 時に $0 が source 先のパスになるため、
# このファイルの位置から ROOT_DIR を算出する

ROOT_DIR="$(cd "$(dirname "$0")"/../.. && pwd)"
CONFIG_FILE="$ROOT_DIR/config.ini"
BREWFILE="$ROOT_DIR/files/brew/Brewfile"
SELECTED_BREWFILE="$ROOT_DIR/.brewfile_selected"

# config.ini から値を読み取る
# 使用例: read_config "name" "computer_name"
read_config() {
  local section="$1" key="$2"
  awk -F ' = ' "/^\[$section\]/{f=1} f==1&&/^$key/{print \$2; exit}" "$CONFIG_FILE"
}
