#!/bin/zsh
ROOT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$ROOT_DIR/scripts/lib/messages.sh"

# Ask user to sync iCloud Drive
read -q "response?${_MSG[icloud_sync]}"
if [ "$response" != "y" ]; then
  echo "${_MSG[exit]}"
  exit 1
fi

# Ask user to grant Terminal App Manage
read -q "response?${_MSG[terminal_manage]}"
if [ "$response" != "y" ]; then
  echo "${_MSG[exit]}"
  exit 1
fi

# Function to run scripts and handle errors
run_script() {
  local script_path="$1"
  if ! "$ROOT_DIR/scripts/$script_path"; then
    printf "${_MSG[failed_to_run]}\n" "$script_path"
    exit 1
  fi
}

# Check if sudo is available
sudo -v || { echo "${_MSG[sudo_failed]}"; exit 1; }

# Start sudo keep-alive in the background
while true; do
  sudo -v
  [[ $? -ne 0 ]] && exit 1
  sleep 60
done & SUDO_PID=$!

# Keep system awake in the background
caffeinate -dim -w $SUDO_PID &

# Kill sudo keep-alive on exit
trap "kill $SUDO_PID" EXIT

# List of scripts to be run
scripts=(
  "config.sh"
  "init.sh"
  "link.sh"
  "brew.sh"
  "asdf.sh"
  "node.sh"
  "system_config.sh"
)

# Run each script in the list
for script in "${scripts[@]}"; do
  run_script "$script"
done

# Ask user to restart the system
read -q "REPLY?${_MSG[restart_prompt]}"
echo
if [[ "$REPLY" = "y" ]]; then
  sudo reboot
fi
