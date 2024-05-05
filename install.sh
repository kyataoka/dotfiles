#!/bin/zsh
ROOT_DIR=$(cd "$(dirname "$0")" && pwd)

# Function to run scripts and handle errors
run_script() {
  local script_path="$1"
  if ! "$ROOT_DIR/bin/$script_path"; then
    echo "Failed to run $script_path"
    # Kill the sudo keep-alive process
    kill "$SUDO_PID"
    exit 1
  fi
}

# Check if sudo is available
sudo -v
[[ $? -ne 0 ]] && exit 1

# Start sudo keep-alive in the background
while true; do
  sudo -v
  [[ $? -ne 0 ]] && exit 1
  sleep 60
done & SUDO_PID=$!

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
  caffeinate run_script "$script"
done

# Kill the sudo keep-alive process
kill "$SUDO_PID"

# Ask user to restart the system
read -q "REPLY?Do you want to restart the system now? (y/n) "
echo
if [[ "$REPLY" = "y" ]]; then
  sudo reboot
fi