SUMMARY = "CAN MCP2515 Device Tree Overlay pro Radxa Zero"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "dtc-native"
SRC_URI = "file://meson-g12-spi-b-mcp2515-20mhz.dts"

S = "${WORKDIR}"

do_compile() {
    dtc -@ -O dtb -o meson-g12-spi-b-mcp2515-20mhz.dtbo meson-g12-spi-b-mcp2515-20mhz.dts
}

do_install() {
    install -d ${D}/boot/overlays
    install -m 0644 meson-g12-spi-b-mcp2515-20mhz.dtbo ${D}/boot/overlays/
}

FILES:${PN} += "/boot/overlays/meson-g12-spi-b-mcp2515-20mhz.dtbo"
