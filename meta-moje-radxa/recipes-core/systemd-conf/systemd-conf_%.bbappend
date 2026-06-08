FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://timeouts.conf"

do_install:append() {
    install -d ${D}${systemd_unitdir}/system.conf.d
    install -m 0644 ${WORKDIR}/timeouts.conf ${D}${systemd_unitdir}/system.conf.d/timeouts.conf
}

FILES:${PN} += "${systemd_unitdir}/system.conf.d/timeouts.conf"
