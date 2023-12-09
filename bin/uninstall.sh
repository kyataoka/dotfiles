#!/bin/zsh

# Uninstall Homebrew packages and dependencies
brew bundle dump \
	--formula \
	--cask \
	--tap \
	--mas \
	--force \
	--file="$SCRIPT_DIR/../backup/Brewfile_backup_$(date +%Y%m%d%H%M%S)"

brew uninstall --ignore-dependencies $(brew list)

# Remove global npm packages
npm ls -gp --depth=0 | awk -F/ '/node_modules/ && !/\/npm$/ {print $NF}' | xargs npm -g rm

# Uninstall Mac App Store apps
mas list | awk '{print $1}' | while read id; do
	mas uninstall $id
done

# Remove Homebrew and related files
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
sudo rm -rf /usr/local/Frameworks/ \
	/usr/local/Homebrew/ \
	/usr/local/bin/ \
	/usr/local/etc/ \
	/usr/local/include/ \
	/usr/local/lib/ \
	/usr/local/opt/ \
	/usr/local/sbin/ \
	/usr/local/share/ \
	/usr/local/var/

# Remove other configuration files
rm -rf ~/.tmux.conf \
	~/.vimrc \
	~/.zprezto \
	~/.zlogin \
	~/.zlogout \
	~/.zpreztorc \
	~/.zprofile \
	~/.zshenv \
	~/.zshrc
