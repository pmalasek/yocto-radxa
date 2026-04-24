# Odstraň zbytečné firmware pro Radxa Zero
# Necháme jen BCM (WiFi) a Amlogic (Video decoder)

do_install:append() {
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
