#!/bin/zsh
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
CONFIG_FILE="$ROOT_DIR"/config.ini

# Permission
sudo -v

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

# Set default browser to chrome
defaultbrowser chrome

# uninstall defaultbrowser if it was not installed
if [ "$IS_DEFAULTBROWSER_INSTALLED" = false ]; then
  brew uninstall defaultbrowser
fi

###############################################################################
# Dock settings
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

# Disable auto rearrange spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Restart Dock
killall Dock

###############################################################################
# Sound settings
###############################################################################

# Set beep sound to Funky
defaults write -g com.apple.sound.beep.sound -string "/System/Library/Sounds/Funky.aiff"

###############################################################################
# Sharing settings
###############################################################################

# Set computer name
computer_name=$(awk -F '=' '/^\[name\]/{f=1} f==1&&/^computer_name/{gsub(/"/, "", $2); print $2; f=0}' $CONFIG_FILE)
sudo scutil --set ComputerName "$computer_name"

# Set hostname
hostname=$(awk -F '=' '/^\[name\]/{f=1} f==1&&/^hostname/{gsub(/"/, "", $2); print $2; f=0}' $CONFIG_FILE)
sudo scutil --set HostName "$hostname"

# Set local hostname
local_hostname=$(awk -F '=' '/^\[name\]/{f=1} f==1&&/^local_hostname/{gsub(/"/, "", $2); print $2; f=0}' $CONFIG_FILE)
sudo scutil --set LocalHostName "$local_hostname"

# Set file sharing to ON
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist

# Set screen sharing to ON
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist

# Set remote login to ON
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

###############################################################################
# Keyboard settings
###############################################################################

# Set key repeat rate
defaults write -g KeyRepeat -float 1.8

# Set initial key repeat delay
defaults write -g InitialKeyRepeat -int 15

# Set press and hold to OFF
defaults write -g ApplePressAndHoldEnabled -bool false

###############################################################################
# Trackpad settings
###############################################################################

# Set speed of trackpad
defaults write -g com.apple.trackpad.scaling -float 2.5

# Set app expose to ON
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

###############################################################################
# Mouse settings
###############################################################################

# Set speed of mouse
defaults write -g com.apple.mouse.scaling -float 2.5

###############################################################################
# Finder settings
###############################################################################

# Set Finder to show all extensions
defaults write -g AppleShowAllExtensions -bool true

# Set Finder to show drives on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

# Set Finder to show removable media on desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Set Finder to show mounted servers on desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

###############################################################################
# Sleep settings
###############################################################################

# Set computer sleep to never
sudo pmset -a sleep 0

# Set screen saver to never start
defaults -currentHost write com.apple.screensaver idleTime -int 0

# Set display sleep to never
sudo pmset -a displaysleep 0

###############################################################################
# Other settings
###############################################################################

# Set DS_Store to OFF
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Set screenshot location
mkdir -p "$HOME/Documents/screenshot"
defaults write com.apple.screencapture location -string "$HOME/Documents/screenshot"

# Set install application updates from the App Store to ON
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true
