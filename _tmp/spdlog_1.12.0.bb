DESCRIPTION = "Very fast C++ logging library"
HOMEPAGE = "https://github.com/gabime/spdlog"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b98a1c21e3d33a0e08f87f76be31c52c"

DEPENDS = "fmt cmake-native ninja-native"

SRC_URI = "git://github.com/gabime/spdlog.git;branch=v${PV};protocol=https"
SRCREV = "v${PV}"
S = "${WORKDIR}/git"

EXTRA_OECMAKE = " \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DSPDLOG_BUILD_SHARED=ON \
    -DSPDLOG_BUILD_TESTS=OFF \
    -DSPDLOG_BUILD_EXAMPLE=OFF \
    -DSPDLOG_FMT_EXTERNAL=ON \
    -DCMAKE_INSTALL_PREFIX=${D}${prefix} \
"

inherit cmake

do_install:append() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}
}

FILES:${PN} = "${libdir}/libspdlog.so* ${libdir}/*.so"
FILES:${PN}-dev = "${includedir} ${libdir}/pkgconfig ${libdir}/*.a ${libdir}/cmake"

SOLIBS = ".so.1.12"
GNU_HASH_STYLE = "gnu"
