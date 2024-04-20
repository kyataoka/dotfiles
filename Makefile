COMMON_CONFIG = config.ini

$(COMMON_CONFIG):
	@echo "Error: $(COMMON_CONFIG) not found. Please create it from $(COMMON_CONFIG).example."
	@exit 1

.PHONY: install init link brew asdf node system_config uninstall update_brewfile

install: $(COMMON_CONFIG)
	init
	link
	brew
	asdf
	system_config

init:
	bin/init.sh
	@source ~/.zshrc

link:
	bin/link.sh
	@source ~/.zshrc

brew:
	bin/brew.sh
	@source ~/.zshrc

asdf:
	bin/asdf.sh
	@source ~/.zshrc

node:
	bin/node.sh
	@source ~/.zshrc

system_config: $(COMMON_CONFIG)
	bin/system_config.sh
	@source ~/.zshrc

uninstall:
	bin/uninstall.sh

update_brewfile:
	bin/update_brewfile.sh
