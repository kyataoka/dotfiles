install:
  init link brew asdf system_config

init:
	zsh bin/init.sh

link:
	zsh bin/link.sh

brew:
	zsh bin/brew.sh

asdf:
	zsh bin/asdf.sh

system_config:
	zsh bin/system_config.sh

uninstall:
	zsh bin/uninstall.sh

update_brewfile:
	zsh bin/update_brewfile.sh
