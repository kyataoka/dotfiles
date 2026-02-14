#!/bin/zsh
set -e

source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"

source ~/.zshrc || true

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
# Sound settings
###############################################################################

# Set beep sound to Funky
defaults write -g com.apple.sound.beep.sound -string "/System/Library/Sounds/Funk.aiff"

###############################################################################
# Sharing settings
###############################################################################

# Set computer name
computer_name=$(read_config "name" "computer_name")
sudo scutil --set ComputerName "$computer_name"

# Set hostname
hostname=$(read_config "name" "hostname")
sudo scutil --set HostName "$hostname"

# Set local hostname
local_hostname=$(read_config "name" "local_hostname")
sudo scutil --set LocalHostName "$local_hostname"

# Set file sharing to ON
sudo launchctl enable system/com.apple.smbd
sudo launchctl bootstrap system /System/Library/LaunchDaemons/com.apple.smbd.plist || true

# Set screen sharing to ON
sudo launchctl enable system/com.apple.screensharing
sudo launchctl bootstrap system /System/Library/LaunchDaemons/com.apple.screensharing.plist || true

# Set remote login to ON
sudo launchctl enable system/ssh
sudo launchctl bootstrap system /System/Library/LaunchDaemons/ssh.plist || true

###############################################################################
# Keyboard settings
###############################################################################

# Set key repeat rate
defaults write -g KeyRepeat -float 2.0

# Set initial key repeat delay
defaults write -g InitialKeyRepeat -int 15

# Set press and hold to OFF
defaults write -g ApplePressAndHoldEnabled -bool false

# Set automatic spelling correction to OFF
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Set automatic capitalization to OFF
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Set automatic period substitution to OFF
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

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

# Set Finder to show hard drives on desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

# Set Finder to show drives on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

# Set Finder to show removable media on desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Set Finder to show mounted servers on desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

# Set Finder to new window target to home
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Set Finder to Column view
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Set Finder to show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Set Finder to show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Set Finder search scope to current folder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Set Finder to disable extension change warning
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Set Finder to desktop group by kind
defaults write com.apple.finder DesktopViewSettings -dict-add GroupBy "Kind"

# Restart Finder
killall Finder

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
applications=()
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  applications+=("$line")
done < "$ROOT_DIR/files/dock/apps.txt"
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

# Set hot corner bottom-right to Quick Note
defaults write com.apple.dock wvous-br-corner -int 14
defaults write com.apple.dock wvous-br-modifier -int 0

# Restart Dock
killall Dock

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
# Status Menu settings
###############################################################################

# Show Sound in menu bar (always)
defaults -currentHost write com.apple.controlcenter Sound -int 18

# Hide WiFi from menu bar
defaults -currentHost write com.apple.controlcenter WiFi -int 8

# Hide Bluetooth from menu bar
defaults -currentHost write com.apple.controlcenter Bluetooth -int 8

# Hide Siri from menu bar
defaults -currentHost write com.apple.controlcenter Siri -int 8
defaults write com.apple.Siri StatusMenuVisible -bool false

# Hide Spotlight from menu bar
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1

# Set menu bar clock to 24-hour format with seconds
defaults write com.apple.menuextra.clock Show24Hour -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool true

# Restart ControlCenter to apply changes
killall ControlCenter

###############################################################################
# Other settings
###############################################################################

# Set print dialog to expanded by default
defaults write -g PMPrintingExpandedStateForPrint -bool true

# Set DS_Store to OFF
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Set screenshot location
mkdir -p "$HOME/Documents/screenshot"
defaults write com.apple.screencapture location -string "$HOME/Documents/screenshot"

# Set install application updates from the App Store to ON
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true
