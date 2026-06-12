FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://can.cfg"
SRC_URI += "file://usb-ethernet.cfg"
SRC_URI += "file://meson-g12-spi-b-mcp2515-20mhz.dts"

# fdtoverlay (z dtc) pro slouceni overlay do DTB v dobe buildu
DEPENDS += "dtc-native"

# Kernel musi kompilovat DTB se symboly (__symbols__), jinak fdtoverlay
# neumi rozlozit odkazy typu <&spicc1>, <&gpio_intc> apod.
KERNEL_DTC_FLAGS = "-@"

# Slouci MCP2515 CAN overlay primo do base DTB hned po kompilaci device tree.
# Bezi po do_compile:append z kernel-devicetree.bbclass (tam se .dtb kompiluji).
apply_can_overlay() {
    base_dtb="${B}/arch/${ARCH}/boot/dts/amlogic/meson-g12a-radxa-zero.dtb"
    overlay_dts="${WORKDIR}/meson-g12-spi-b-mcp2515-20mhz.dts"
    overlay_dtbo="${WORKDIR}/meson-g12-spi-b-mcp2515-20mhz.dtbo"

    if [ ! -e "$base_dtb" ]; then
        bbfatal "apply_can_overlay: base DTB nenalezen: $base_dtb"
    fi

    dtc -@ -I dts -O dtb -o "$overlay_dtbo" "$overlay_dts"
    fdtoverlay -i "$base_dtb" -o "$base_dtb" "$overlay_dtbo"
    bbnote "apply_can_overlay: MCP2515 overlay sloucen do $base_dtb"
}
do_compile[postfuncs] += "apply_can_overlay"
