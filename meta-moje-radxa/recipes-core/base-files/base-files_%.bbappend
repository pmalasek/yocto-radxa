FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Override hostname - set to xPluto9
hostname:pn-base-files = "xPluto9"

# Override fstab - use LABEL=boot instead of UUID (UUID changes every build)
do_install:append() {
    install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/fstab
}
