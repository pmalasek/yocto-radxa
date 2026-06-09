# Odstraň nftables - NM funguje i bez firewall backendu
# Ušetří ~1MB (libnftables)
PACKAGECONFIG:remove = "nftables"

# Zakáž NetworkManager-wait-online.service - zbytečně zdrží boot
# Aplikace mají používat D-Bus signály nebo retry logiku místo čekání na síť při bootu

do_install:append() {
    # Mask wait-online service by symlinking to /dev/null
    install -d ${D}${systemd_system_unitdir}
    ln -sf /dev/null ${D}${systemd_system_unitdir}/NetworkManager-wait-online.service
}
