FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://90-admins"

do_install:append() {
    install -d ${D}${sysconfdir}/sudoers.d
    install -m 0440 ${WORKDIR}/90-admins ${D}${sysconfdir}/sudoers.d/90-admins
}

FILES:${PN} += "${sysconfdir}/sudoers.d/90-admins"
CONFFILES:${PN} += "${sysconfdir}/sudoers.d/90-admins"