SUMMARY = "Bluetooth configuration for Radxa Zero (BCM43455)"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://main.conf"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}/bluetooth
    install -m 0644 ${WORKDIR}/main.conf ${D}${sysconfdir}/bluetooth/main.conf
}

FILES:${PN} += "${sysconfdir}/bluetooth/main.conf"
