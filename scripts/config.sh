#!/bin/zsh
set -e

source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
source "$ROOT_DIR/scripts/lib/messages.sh"

# config
new_config_file="$CONFIG_FILE"

# If the configuration file exists, ask the user if they want to overwrite it
if [ -f "$new_config_file" ]; then
  echo "${_MSG[config_exists]}"
  read -q "response?${_MSG[enter_response]}"
  if [ "$response" != "y" ]; then
    echo "${_MSG[exit]}"
    exit 0
  fi
fi

# prompt
echo "${_MSG[enter_settings]}"
read "computer_name?${_MSG[enter_computer_name]}"

# Generate a default hostname based on the computer name
# Convert to lowercase, replace spaces with hyphens, and remove apostrophes
default_hostname=$(echo "$computer_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d "'")

read "hostname?$(printf "${_MSG[enter_hostname]}" "$default_hostname")"
if [ -z "$hostname" ]; then
  hostname=$default_hostname
else
  # Update the default hostname if a new hostname is provided
  default_hostname=$hostname
fi
read "local_hostname?$(printf "${_MSG[enter_local_hostname]}" "$default_hostname")"
if [ -z "$local_hostname" ]; then
  local_hostname=$default_hostname
fi

# Display the new settings
echo "${_MSG[new_settings]}"
echo "computer_name = $computer_name"
echo "hostname = $hostname"
echo "local_hostname = $local_hostname"

read -q "response?${_MSG[save_config]}"
if [ "$response" != "y" ]; then
  echo "${_MSG[exit]}"
  exit 1
fi

# 新しい設定ファイルを作成し、設定を書き込む
{
  echo "[name]"
  echo "computer_name = $computer_name"
  echo "hostname = $hostname"
  echo "local_hostname = $local_hostname"
} >| "$new_config_file"

printf "${_MSG[config_saved]}\n" "$new_config_file"

# パッケージ選択
BREWFILE="$ROOT_DIR/files/brew/Brewfile"
SELECTED_BREWFILE="$ROOT_DIR/.brewfile_selected"

echo ""
read -q "select_packages?${_MSG[select_packages]}"
echo ""

if [[ "$select_packages" == "y" ]]; then
  source "$ROOT_DIR/scripts/lib/checkbox.sh"
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
    if checkbox_select "${_MSG[select_cli]}" "[1/3]" "${_MSG[confirm_next]}" "${brew_items[@]}"; then
      selected_brew=("${CHECKBOX_RESULT[@]}")
    else
      echo "${_MSG[cancelled]}"
      exit 1
    fi
  fi

  # ページ 2/3: GUIアプリ
  if (( ${#cask_items[@]} > 0 )); then
    if checkbox_select "${_MSG[select_gui]}" "[2/3]" "${_MSG[confirm_next]}" "${cask_items[@]}"; then
      selected_cask=("${CHECKBOX_RESULT[@]}")
    else
      echo "${_MSG[cancelled]}"
      exit 1
    fi
  fi

  # ページ 3/3: App Storeアプリ
  if (( ${#mas_items[@]} > 0 )); then
    if checkbox_select "${_MSG[select_mas]}" "[3/3]" "${_MSG[confirm_done]}" "${mas_items[@]}"; then
      selected_mas=("${CHECKBOX_RESULT[@]}")
    else
      echo "${_MSG[cancelled]}"
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
  printf "${_MSG[select_complete]}\n" "$total"
else
  # 全パッケージをインストール（選択ファイルがあれば削除）
  rm -f "$SELECTED_BREWFILE"
  echo "${_MSG[install_all]}"
fi
