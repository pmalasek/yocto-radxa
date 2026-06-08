SUMMARY = "Resize root filesystem to fill disk on first boot"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://resize-rootfs.sh \
    file://resize-rootfs.service \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "resize-rootfs.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

RDEPENDS:${PN} = "util-linux-sfdisk e2fsprogs-resize2fs util-linux-findmnt"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/resize-rootfs.sh ${D}${sbindir}/resize-rootfs.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/resize-rootfs.service ${D}${systemd_system_unitdir}/resize-rootfs.service
}

FILES:${PN} = " \
    ${sbindir}/resize-rootfs.sh \
    ${systemd_system_unitdir}/resize-rootfs.service \
"
