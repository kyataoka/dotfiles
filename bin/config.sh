#!/bin/zsh
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."

# config
new_config_file="$ROOT_DIR/config.ini"

# If the configuration file exists, ask the user if they want to overwrite it
if [ -f "$new_config_file" ]; then
  echo "Configuration file already exists. Do you want to overwrite it? (y/n)"
  read "response?Enter your response(Y/n): "
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

hostname=$default_hostname
read "hostname?Enter hostname (default: $hostname): "
local_hostname=$default_hostname
read "local_hostname?Enter local_hostname (default: $local_hostname): "

# 新しい設定ファイルを作成し、設定を書き込む
{
  echo "[name]"
  echo "computer_name = $computer_name"
  echo "hostname = $hostname"
  echo "local_hostname = $local_hostname"
} >| "$new_config_file"

echo "New configuration saved to '$new_config_file'"
