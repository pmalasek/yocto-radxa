# Základní metadata recipe
SUMMARY = "xPluto9 application bundle"
DESCRIPTION = "Installs xPluto9 binaries, certificates, and environment file into /opt/pluto9"
LICENSE = "CLOSED"

# Datové soubory ponecháváme v meta-moje-radxa/xpluto9
# (bin/, certs/, .env), i když recipe je už ve standardním recipes-* stromu.
# Používáme THISDIR, aby cesta byla vždy správně rozlišená při parsování recipe.
FILESEXTRAPATHS:prepend := "${THISDIR}/../../xpluto9:"

# Co se má vzít z layer do WORKDIR během buildu
SRC_URI = " \
	file://bin/ \
	file://certs/ \
	file://.env \
"

# Pracovní adresář receptu (po unpack fázi)
S = "${WORKDIR}"

# Instalace do image rootfs (přes ${D} staging adresář)
do_install() {
	# Vytvoření cílové struktury v /opt/pluto9
	install -d ${D}/opt/pluto9/bin
	install -d ${D}/opt/pluto9/certs

	# Zkopírování binárních souborů
	cp -a ${WORKDIR}/bin/. ${D}/opt/pluto9/bin/
	# Zkopírování certifikátů se zachováním podadresářů, práv a časů
	cp -a ${WORKDIR}/certs/. ${D}/opt/pluto9/certs/
	# Instalace .env jako soubor jen pro vlastníka (0600)
	install -m 0600 ${WORKDIR}/.env ${D}/opt/pluto9/.env

	# Zamezení host contamination: vždy sjednotit ownership na root:root
	chown -R root:root ${D}/opt/pluto9
}

# Co vše patří do výsledného balíčku ${PN}
FILES:${PN} += " \
	/opt/pluto9 \
"

# Explicitní runtime závislosti pro knihovny, které jsou v tomto buildu dostupné.
# (ověřeno v build/tmp/pkgdata/radxa-zero/runtime)
RDEPENDS:${PN} += " \
	libsystemd \
	bluez5 \
	fmt \
	spdlog \
	cnats \
"

# Binárky v /opt/pluto9/bin jsou předkompilované a už stripnuté.
# Povolit QA check 'already-stripped' pouze pro tento balíček.
INSANE_SKIP:${PN} += "already-stripped"
