#!/bin/zsh
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
CONFIG_FILE="$ROOT_DIR"/config.ini

echo $CONFIG_FILE

HOGE="hoge"
echo "before: $HOGE"
source ~/dotfiles/test
echo "after:  $HOGE"
echo
computer_name=$(awk -F '=' '/^\[name\]/{f=1} f==1&&/^computer_name/{print $2;f=0}' $CONFIG_FILE)
echo ComputerName "$computer_name"
hostname=$(awk -F '=' '/^\[name\]/{f=1} f==1&&/^hostname/{print $2;f=0}' $CONFIG_FILE)
echo HostName "$hostname"
local_hostname=$(awk -F '=' '/^\[name\]/{f=1} f==1&&/^local_hostname/{print $2;f=0}' $CONFIG_FILE)
echo LocalHostName "$local_hostname"