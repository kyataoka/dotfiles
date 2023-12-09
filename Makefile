install: init link brew asdf system_config

init:
	bin/init.sh

link:
	bin/link.sh

brew:
	bin/brew.sh

asdf:
	bin/asdf.sh

system_config:
	bin/system_config.sh

uninstall:
	bin/uninstall.sh

update_brewfile:
	bin/update_brewfile.sh
