# Odstraň zbytečné firmware pro Radxa Zero
# Necháme jen BCM (WiFi) a Amlogic (Video decoder)

# Update SRCREV to include brcmfmac43456-sdio.radxa,zero.{bin,txt} firmware
# (meta-meson pins an older commit that lacks these files)
SRCREV_brcmfmac-sdio-firmware = "0dd4b9f62b339414de9c3d47a783fe310958cd34"

# Declare bcm43456 sub-package (not present in poky's linux-firmware recipe)
PACKAGES =+ "${PN}-bcm43456"
FILES:${PN}-bcm43456 = "${nonarch_base_libdir}/firmware/brcm/brcmfmac43456*"
LICENSE:${PN}-bcm43456 = "Firmware-broadcom_bcm43xx"
RDEPENDS:${PN}-bcm43456 += "${PN}-broadcom-license"

# Define BT firmware sub-package for Radxa Zero (BCM4345C5 - AP6256)
PACKAGES =+ "${PN}-bcm43455-bt"
FILES:${PN}-bcm43455-bt = " \
    ${nonarch_base_libdir}/firmware/brcm/BCM4345C5.hcd \
"

do_install:append() {
    # Install BCM4345C5 Bluetooth HCD firmware for Radxa Zero (AP6256)
    install -m 0644 ${WORKDIR}/brcmfmac_sdio-firmware/BCM4345C5.hcd ${D}${nonarch_base_libdir}/firmware/brcm/

    # Odstraň všechny zbytečné firmware
    rm -rf ${D}${nonarch_base_libdir}/firmware/qcom
    rm -rf ${D}${nonarch_base_libdir}/firmware/netronome
    rm -rf ${D}${nonarch_base_libdir}/firmware/mrvl
    rm -rf ${D}${nonarch_base_libdir}/firmware/mellanox
    rm -rf ${D}${nonarch_base_libdir}/firmware/intel
    rm -rf ${D}${nonarch_base_libdir}/firmware/amdgpu
    rm -rf ${D}${nonarch_base_libdir}/firmware/nvidia
    rm -rf ${D}${nonarch_base_libdir}/firmware/amd
    rm -rf ${D}${nonarch_base_libdir}/firmware/amd-ucode
    rm -rf ${D}${nonarch_base_libdir}/firmware/cavium
    rm -rf ${D}${nonarch_base_libdir}/firmware/cxgb3
    rm -rf ${D}${nonarch_base_libdir}/firmware/cxgb4
    rm -rf ${D}${nonarch_base_libdir}/firmware/ti-connectivity
    rm -rf ${D}${nonarch_base_libdir}/firmware/ath*
    rm -rf ${D}${nonarch_base_libdir}/firmware/rtl*
    rm -rf ${D}${nonarch_base_libdir}/firmware/iwlwifi*
    rm -rf ${D}${nonarch_base_libdir}/firmware/mediatek
    rm -rf ${D}${nonarch_base_libdir}/firmware/libertas*
}
