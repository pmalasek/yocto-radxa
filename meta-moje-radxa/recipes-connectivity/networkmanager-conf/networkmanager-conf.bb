SUMMARY = "Preconfigured WiFi for XTUNING"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://XTUNING.nmconnection \
           file://NetworkManager.conf \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}/NetworkManager/system-connections
    install -m 0600 ${WORKDIR}/XTUNING.nmconnection ${D}${sysconfdir}/NetworkManager/system-connections/

    install -d ${D}${sysconfdir}/NetworkManager
    install -m 0644 ${WORKDIR}/NetworkManager.conf ${D}${sysconfdir}/NetworkManager/NetworkManager.conf
}

FILES:${PN} += " \
    ${sysconfdir}/NetworkManager/system-connections/XTUNING.nmconnection \
    ${sysconfdir}/NetworkManager/NetworkManager.conf \
"
