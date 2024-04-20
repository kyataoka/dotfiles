#!/bin/zsh
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."

###############################################################################
# Change default browser
###############################################################################

# if defaultbrowser is not installed, install it. and uninstall after use
if ! command -v defaultbrowser &> /dev/null; then
  IS_DEFAULTBROWSER_INSTALLED=false
  brew install defaultbrowser
else
  IS_DEFAULTBROWSER_INSTALLED=true
fi

# Enable key press and hold
defaults write -g ApplePressAndHoldEnabled -bool true

# uninstall defaultbrowser if it was not installed
if [ "$IS_DEFAULTBROWSER_INSTALLED" = false ]; then
  brew uninstall defaultbrowser
fi

###############################################################################
# Setup Dock
###############################################################################

# if dockutil is not installed, install it. and uninstall after use
if ! command -v dockutil &> /dev/null; then
  IS_DOCKUTIL_INSTALLED=false
  brew install dockutil
else
  IS_DOCKUTIL_INSTALLED=true
fi

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

# Uninstall dockutil if it was not installed
if [ "$IS_DOCKUTIL_INSTALLED" = false ]; then
  brew uninstall dockutil
fi

# Set dock size
defaults write com.apple.dock tilesize -int 36

# Hide App Suggestions
defaults write com.apple.dock show-recents -bool false

# Restart Dock
killall Dock
