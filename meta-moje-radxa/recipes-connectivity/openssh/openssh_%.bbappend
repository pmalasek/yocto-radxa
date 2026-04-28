FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://10-plutolinux-root-login.conf"

do_install:append() {
    install -d ${D}${sysconfdir}/ssh/sshd_config.d
    install -m 0644 ${WORKDIR}/10-plutolinux-root-login.conf ${D}${sysconfdir}/ssh/sshd_config.d/10-plutolinux-root-login.conf
}

FILES:${PN}-sshd += "${sysconfdir}/ssh/sshd_config.d/10-plutolinux-root-login.conf"
CONFFILES:${PN}-sshd += "${sysconfdir}/ssh/sshd_config.d/10-plutolinux-root-login.conf"