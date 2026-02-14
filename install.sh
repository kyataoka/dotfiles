#!/bin/zsh
ROOT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$ROOT_DIR/scripts/lib/messages.sh"

# Check Terminal Full Disk Access permission
if ! plutil -lint /Library/Preferences/com.apple.TimeMachine.plist &>/dev/null; then
  open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
  echo "${_MSG[terminal_fda_guide]}"
  exit 1
fi

# Ask user to sync iCloud Drive
open "x-apple.systempreferences:com.apple.systempreferences.AppleIDSettings:icloud"
read -q "response?${_MSG[icloud_sync]}"
echo
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

# Ask user to skip password prompts during setup
SUDOERS_TMP="/etc/sudoers.d/dotfiles_nopasswd"
read -q "response?${_MSG[nopasswd_prompt]}"
echo
if [ "$response" = "y" ]; then
  echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee "$SUDOERS_TMP" > /dev/null
  sudo chmod 0440 "$SUDOERS_TMP"
  if ! sudo visudo -c -f "$SUDOERS_TMP" 2>/dev/null; then
    sudo rm -f "$SUDOERS_TMP"
  else
    echo "${_MSG[nopasswd_enabled]}"
  fi
fi

# Start sudo keep-alive in the background
# -n: non-interactive (never prompt), avoids blocking in background
# kill -0 "$$": exit loop when parent script finishes
while true; do sudo -n true; sleep 30; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_PID=$!

# Keep system awake in the background
caffeinate -dim -w $SUDO_PID &

# Cleanup on exit
cleanup() {
  kill $SUDO_PID 2>/dev/null
  if [ -f "$SUDOERS_TMP" ]; then
    sudo rm -f "$SUDOERS_TMP"
    echo "${_MSG[nopasswd_removed]}"
  fi
}
trap cleanup EXIT

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
  cleanup
  sudo reboot
fi
