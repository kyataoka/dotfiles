COMMON_CONFIG = config.ini

$(COMMON_CONFIG):
	@echo "Error: $(COMMON_CONFIG) not found. Please create it from $(COMMON_CONFIG).example."
	@exit 1

.PHONY: install init link brew asdf node system_config uninstall update_brewfile test

install: $(COMMON_CONFIG)
	init
	link
	brew
	asdf
	system_config

init:
	bin/init.sh

link:
	bin/link.sh

brew:
	bin/brew.sh

asdf:
	bin/asdf.sh

node:
	bin/node.sh

system_config: $(COMMON_CONFIG)
	bin/system_config.sh

uninstall:
	bin/uninstall.sh

update_brewfile:
	bin/update_brewfile.sh

test:
	bin/test.sh