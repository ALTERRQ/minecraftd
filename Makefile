PREFIX ?=

MINECRAFT_USER  ?= minecraft
MINECRAFT_GROUP ?= minecraft
REAL_USER := $(shell logname 2>/dev/null || echo $$USER)

.PHONY: null
null:
	@:

.PHONY: install
install:
	install -Dm644 src/minecraft.conf $(PREFIX)/usr/lib/sysusers.d/minecraft.conf
	systemd-sysusers
	gpasswd -a $(REAL_USER) $(MINECRAFT_GROUP)
	install -Dm755 -o $(MINECRAFT_USER) -g $(MINECRAFT_GROUP) LICENSE $(PREFIX)/usr/share/licenses/minecraftd/LICENSE
	install -Dm755 -o $(MINECRAFT_USER) -g $(MINECRAFT_GROUP) minecraftd $(PREFIX)/usr/bin/minecraftd
	install -Dm644 -o $(MINECRAFT_USER) -g $(MINECRAFT_GROUP) src/minecraftd.conf $(PREFIX)/etc/minecraftd.conf
	install -Dm644 -o $(MINECRAFT_USER) -g $(MINECRAFT_GROUP) src/minecraftd.service $(PREFIX)/usr/lib/systemd/system/minecraftd.service

.PHONY: uninstall
uninstall:
	-gpasswd -d $(REAL_USER) $(MINECRAFT_GROUP)
	rm -r $(PREFIX)/usr/share/licenses/minecraftd
	rm $(PREFIX)/usr/bin/minecraftd
	rm $(PREFIX)/etc/minecraftd.conf
	rm $(PREFIX)/usr/lib/sysusers.d/minecraft.conf
	rm $(PREFIX)/usr/lib/systemd/system/minecraftd.service
