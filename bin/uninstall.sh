#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

brew bundle dump\
	--formula \
	--cask \
	--tap \
	--mas \
	--force \
	--file="$SCRIPT_DIR/../backup/Brewfile_backup_$(date +%Y%m%d%H%M%S)"

rm -rf ~/.tmux.conf
rm -rf ~/.vimrc

npm ls -gp --depth=0 | awk -F/ '/node_modules/ && !/\/npm$/ {print $NF}' | xargs npm -g rm

mas list | awk '{print $1}' | while read id; do
  mas uninstall $id
done

brew uninstall $(brew list)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
sudo rm -rf /usr/local/Frameworks/\
  /usr/local/Homebrew/\
	/usr/local/bin/\
	/usr/local/etc/\
	/usr/local/include/\
	/usr/local/lib/\
	/usr/local/opt/\
	/usr/local/sbin/\
	/usr/local/share/\
	/usr/local/var/

rm -rf ~/.zprezto\
	~/.zlogin\
	~/.zlogout\
	~/.zpreztorc\
	~/.zprofile\
	~/.zshenv\
	~/.zshrc
