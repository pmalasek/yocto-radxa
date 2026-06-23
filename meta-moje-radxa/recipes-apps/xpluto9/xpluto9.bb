# Základní metadata recipe
SUMMARY = "xPluto9 application bundle"
DESCRIPTION = "Installs xPluto9 binaries, certificates, and environment file into /opt/pluto"
LICENSE = "CLOSED"

inherit systemd

# Datové soubory ponecháváme v meta-moje-radxa/xpluto9
# (bin/, certs/, .env), i když recipe je už ve standardním recipes-* stromu.
# Používáme THISDIR, aby cesta byla vždy správně rozlišená při parsování recipe.
FILESEXTRAPATHS:prepend := "${THISDIR}/../../xpluto9:"

# Co se má vzít z layer do WORKDIR během buildu
SRC_URI = " \
	file://pluto/ \
	file://.env \
	file://pluto-loader.service \
	file://pluto-can.service \
"

# Pracovní adresář receptu (po unpack fázi)
S = "${WORKDIR}"

# Instalace do image rootfs (přes ${D} staging adresář)
do_install() {
	# Vytvoření cílové struktury v /opt/pluto
	install -d ${D}/opt/pluto/bin
	install -d ${D}/opt/pluto/certs/ca
	install -d ${D}/opt/pluto/certs/fleet
	install -d ${D}/opt/pluto/logic/data
	install -d ${D}/opt/pluto/logs
	install -d ${D}/opt/pluto/updates/backup
	install -d ${D}/opt/pluto/updates/pending
	# data/ adresáře se vytvoří prázdné — soubory vznikají za běhu aplikace
	install -d ${D}/opt/pluto/data/incoming
	install -d ${D}/opt/pluto/data/outgoing

	# Kopírování jednotlivých podadresářů (data/ záměrně vynechána)
	cp -a ${WORKDIR}/pluto/bin/.     ${D}/opt/pluto/bin/
	cp -a ${WORKDIR}/pluto/certs/.   ${D}/opt/pluto/certs/
	cp -a ${WORKDIR}/pluto/logic/.   ${D}/opt/pluto/logic/
	cp -a ${WORKDIR}/pluto/logs/.    ${D}/opt/pluto/logs/
	cp -a ${WORKDIR}/pluto/updates/. ${D}/opt/pluto/updates/

	# Nastavení spustitelnosti binárních souborů
	chmod 0755 ${D}/opt/pluto/bin/pluto-backend
	chmod 0755 ${D}/opt/pluto/bin/pluto-can-receiver
	chmod 0755 ${D}/opt/pluto/bin/pluto-can-sender
	chmod 0755 ${D}/opt/pluto/bin/pluto-loader
	chmod 0755 ${D}/opt/pluto/bin/pluto-logger

	# Certifikáty jen pro vlastníka
	chmod 0600 ${D}/opt/pluto/certs/ca/ca.key
	chmod 0600 ${D}/opt/pluto/certs/fleet/fleet.key

	# Instalace .env jako soubor jen pro vlastníka (0600)
	install -m 0600 ${WORKDIR}/.env ${D}/opt/pluto/.env

	# Zamezení host contamination: vždy sjednotit ownership na root:root
	chown -R root:root ${D}/opt/pluto

	# Instalace systemd service jednotek
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/pluto-loader.service ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/pluto-can.service ${D}${systemd_unitdir}/system/
}

# Co vše patří do výsledného balíčku ${PN}
FILES:${PN} += " \
	/opt/pluto \
	${systemd_unitdir}/system/pluto-loader.service \
	${systemd_unitdir}/system/pluto-can.service \
"

# Systemd integrace
SYSTEMD_SERVICE:${PN} = "pluto-loader.service pluto-can.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

# Explicitní runtime závislosti pro knihovny, které jsou v tomto buildu dostupné.
# (ověřeno v build/tmp/pkgdata/radxa-zero/runtime)
RDEPENDS:${PN} += " \
	libsystemd \
	bluez5 \
	fmt \
	spdlog \
	cnats \
	systemd \
"

# Binárky v /opt/pluto/bin jsou předkompilované Go binárky (staticky linkované).
# Zakázat strip a debug split — Yocto by je jinak rozbilo.
# ldflags: staticky linkované Go binárky nemají GNU_HASH — to je v pořádku.
INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INSANE_SKIP:${PN} += "ldflags"
