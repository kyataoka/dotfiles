COMMON_CONFIG = config.ini

$(COMMON_CONFIG):
	@echo "Error: $(COMMON_CONFIG) not found. Please create it from $(COMMON_CONFIG).example."
	@exit 1

.PHONY: install config init link brew asdf node system_config uninstall update_brewfile test

install: config init link brew asdf system_config

config:
	@bin/config.sh

init: $(COMMON_CONFIG)
	@bin/init.sh

link: $(COMMON_CONFIG)
	@bin/link.sh

brew: $(COMMON_CONFIG)
	@bin/brew.sh

asdf: $(COMMON_CONFIG)
	@bin/asdf.sh

node: $(COMMON_CONFIG)
	@bin/node.sh

system_config: $(COMMON_CONFIG)
	@bin/system_config.sh

uninstall:
	@bin/uninstall.sh

update_brewfile:
	@bin/update_brewfile.sh