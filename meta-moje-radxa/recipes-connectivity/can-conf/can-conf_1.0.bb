SUMMARY = "Configure CAN0 interface at boot (bitrate 250000)"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://can0-setup.service"

inherit systemd

SYSTEMD_SERVICE:${PN} = "can0-setup.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

RDEPENDS:${PN} = "iproute2"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/can0-setup.service ${D}${systemd_system_unitdir}/can0-setup.service
}

FILES:${PN} = "${systemd_system_unitdir}/can0-setup.service"
