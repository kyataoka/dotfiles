#!/bin/zsh
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."

# config
new_config_file="$ROOT_DIR/config.ini"

# If the configuration file exists, ask the user if they want to overwrite it
if [ -f "$new_config_file" ]; then
  echo "Configuration file already exists. Do you want to overwrite it? (y/n)"
  read -q "response?Enter your response(y/n): "
  if [ "$response" != "y" ]; then
    echo "Exiting..."
    exit 0
  fi
fi

# prompt
echo "Please enter the new settings for your configuration file:"
read "computer_name?Enter computer_name: "

# Generate a default hostname based on the computer name
# Convert to lowercase, replace spaces with hyphens, and remove apostrophes
default_hostname=$(echo "$computer_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d "'")

read "hostname?Enter hostname (default: $default_hostname): "
if [ -z "$hostname" ]; then
  hostname=$default_hostname
else
  # Update the default hostname if a new hostname is provided
  default_hostname=$hostname
fi
read "local_hostname?Enter local_hostname (default: $default_hostname): "
if [ -z "$local_hostname" ]; then
  local_hostname=$default_hostname
fi

# Display the new settings
echo "New settings:"
echo "computer_name = $computer_name"
echo "hostname = $hostname"
echo "local_hostname = $local_hostname"

read -q "response?Do you want to save the new configuration? (y/n) "
if [ "$response" != "y" ]; then
  echo "Exiting..."
  exit 1
fi

# 新しい設定ファイルを作成し、設定を書き込む
{
  echo "[name]"
  echo "computer_name = $computer_name"
  echo "hostname = $hostname"
  echo "local_hostname = $local_hostname"
} >| "$new_config_file"

echo "New configuration saved to '$new_config_file'"

# パッケージ選択
BREWFILE="$ROOT_DIR/files/Brewfile"
SELECTED_BREWFILE="$ROOT_DIR/.brewfile_selected"

echo ""
read -q "select_packages?Do you want to select packages to install? (y/n) "
echo ""

if [[ "$select_packages" == "y" ]]; then
  source "$ROOT_DIR/bin/checkbox.sh"
  trap 'tput cnorm; tput sgr0' INT TERM

  # Brewfileからアイテムを種類別に抽出
  brew_items=()
  cask_items=()
  mas_items=()
  while IFS= read -r line; do
    if [[ "$line" =~ '^brew "([^"]+)"' ]]; then
      brew_items+=("${match[1]}")
    elif [[ "$line" =~ '^cask "([^"]+)"' ]]; then
      cask_items+=("${match[1]}")
    elif [[ "$line" =~ '^mas "([^"]+)"' ]]; then
      mas_items+=("${match[1]}")
    fi
  done < "$BREWFILE"

  selected_brew=()
  selected_cask=()
  selected_mas=()

  # ページ 1/3: CLIツール
  if (( ${#brew_items[@]} > 0 )); then
    if checkbox_select "CLIツールを選択してください:" "[1/3]" "Enter:次へ" "${brew_items[@]}"; then
      selected_brew=("${CHECKBOX_RESULT[@]}")
    else
      echo "キャンセルされました"
      exit 1
    fi
  fi

  # ページ 2/3: GUIアプリ
  if (( ${#cask_items[@]} > 0 )); then
    if checkbox_select "GUIアプリを選択してください:" "[2/3]" "Enter:次へ" "${cask_items[@]}"; then
      selected_cask=("${CHECKBOX_RESULT[@]}")
    else
      echo "キャンセルされました"
      exit 1
    fi
  fi

  # ページ 3/3: App Storeアプリ
  if (( ${#mas_items[@]} > 0 )); then
    if checkbox_select "App Storeアプリを選択してください:" "[3/3]" "Enter:確定" "${mas_items[@]}"; then
      selected_mas=("${CHECKBOX_RESULT[@]}")
    else
      echo "キャンセルされました"
      exit 1
    fi
  fi

  # 選択結果をBrewfile形式で保存
  tput clear
  {
    for item in "${selected_brew[@]}"; do
      grep -x "brew \"$item\"" "$BREWFILE"
    done
    for item in "${selected_cask[@]}"; do
      grep -x "cask \"$item\"" "$BREWFILE"
    done
    for item in "${selected_mas[@]}"; do
      grep "^mas \"$item\"" "$BREWFILE"
    done
  } > "$SELECTED_BREWFILE"

  total=$(( ${#selected_brew[@]} + ${#selected_cask[@]} + ${#selected_mas[@]} ))
  echo "パッケージ選択完了: $total 件を選択しました"
else
  # 全パッケージをインストール（選択ファイルがあれば削除）
  rm -f "$SELECTED_BREWFILE"
  echo "全パッケージをインストールします"
fi
