#!/bin/zsh
ROOT_DIR=$(cd "$(dirname "$0")" && pwd)

# Ask user to sync iCloud Drive
read -q "response?Have you synced iCloud Drive? (y/n) "
if [ "$response" != "y" ]; then
  echo "Exiting..."
  exit 1
fi

# Ask user to grant Terminal App Manage
read -q "response?Have you granted Terminal App Manage? (y/n) "
if [ "$response" != "y" ]; then
  echo "Exiting..."
  exit 1
fi

# Function to run scripts and handle errors
run_script() {
  local script_path="$1"
  if ! "$ROOT_DIR/bin/$script_path"; then
    echo "Failed to run $script_path"
    exit 1
  fi
}

# Check if sudo is available
sudo -v || { echo "sudo authentication failed"; exit 1; }

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
read -q "REPLY?Do you want to restart the system now? (y/n) "
echo
if [[ "$REPLY" = "y" ]]; then
  sudo reboot
fi