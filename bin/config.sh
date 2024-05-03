#!/bin/zsh
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."

# config
new_config_file="$ROOT_DIR/config.ini"

# prompt
echo "Please enter the new settings for your configuration file:"
read "computer_name?Enter computer_name: "
read "hostname?Enter hostname: "
read "local_hostname?Enter local_hostname: "

# 新しい設定ファイルを作成し、設定を書き込む
{
  echo "[name]"
  echo "computer_name = $computer_name"
  echo "hostname = $hostname"
  echo "local_hostname = $local_hostname"
} >| "$new_config_file"

echo "New configuration saved to '$new_config_file'"
