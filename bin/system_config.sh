#!/bin/zsh
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
TMP_DIR="$(cd "$(dirname "$0")" && pwd)/../tmp"

mkdir -p "$TMP_DIR"

# Change default browser
git clone https://github.com/kerma/defaultbrowser.git "$TMP_DIR/defaultbrowser"
cd "$TMP_DIR/defaultbrowser"
make
sudo make install
defaultbrowser chrome
sudo make uninstall
cd "$ROOT_DIR"

# Enable key press and hold
defaults write -g ApplePressAndHoldEnabled -bool true

# Setup Dock
dockutil --remove all --no-restart
# Add applications to dock
applications=(
  "/Applications/Finder.app"
  "/Applications/Launchpad.app"
  "/Applications/Mission Control.app"
  "/System/Applications/Home.app"
  "/Applications/Google Chrome.app"
  "/Applications/Safari.app"
  "/Applications/Discord.app"
  "/System/Applications/Messages.app"
  "/System/Applications/Mail.app"
  "/System/Applications/Maps.app"
  "/System/Applications/Photos.app"
  "/System/Applications/Calendar.app"
  "/System/Applications/Notes.app"
  "/System/Applications/Reminders.app"
  "/System/Applications/Music.app"
  "/System/Applications/App Store.app"
  "/System/Applications/Utilities/Terminal.app"
  "/System/Applications/System Settings.app"
  "/Applications/Visual Studio Code.app"
  "/Applications/Xcode.app"
  "/Applications/Parallels Desktop.app"
  "/Applications/Microsoft Remote Desktop.app"
  "/Applications/RemotePlay.app"
  "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
  "/Applications/Unity Hub.app"
  "/Applications/Minecraft.app"
  "/Applications/1Password.app"
  "/System/Applications/Utilities/Screen Sharing.app"
  "/Applications/AppCleaner.app"
)
position=1
for app in "${applications[@]}"; do
  # if app exists add it to the dock
  if [ -d "$app" ]; then
    dockutil --add "$app" --position $position --section apps --no-restart > /dev/null
    position=$((position + 1))
  fi
done
# Add directories to dock
dockutil --add "$HOME/Downloads" --position 1 --section others --view fan --display stack --sort dateadded --no-restart > /dev/null
dockutil --add "$HOME/Documents/screenshot" --position 2 --section others --view grid --display stack --sort dateadded --no-restart > /dev/null
# Restart Dock
killall Dock

# Set dock size
defaults write com.apple.dock tilesize -int 36

# Hide App Suggestions
defaults write com.apple.dock show-recents -bool false

# Restart Dock
killall Dock

rm -rf "$TMP_DIR"
