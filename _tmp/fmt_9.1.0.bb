DESCRIPTION = "A modern C++ formatting library"
HOMEPAGE = "https://github.com/fmtlib/fmt"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.rst;md5=8b3e3cc1fd3c5cc6c38bf6cf7cbefd68"

DEPENDS = "cmake-native ninja-native"

SRC_URI = "git://github.com/fmtlib/fmt.git;branch=${PV};protocol=https"
SRCREV = "v${PV}"
S = "${WORKDIR}/git"

EXTRA_OECMAKE = " \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DFMT_TEST=OFF \
    -DCMAKE_INSTALL_PREFIX=${D}${prefix} \
"

inherit cmake

do_install:append() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}
}

FILES:${PN} = "${libdir}/libfmt.so* ${libdir}/*.so"
FILES:${PN}-dev = "${includedir} ${libdir}/pkgconfig ${libdir}/*.a ${libdir}/cmake"

SOLIBS = ".so.9"
GNU_HASH_STYLE = "gnu"
