DESCRIPTION = "NATS C client library"
HOMEPAGE = "https://github.com/nats-io/nats.c"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1f34b1fc0e1b634660cea2b10cb992bb"

DEPENDS = "openssl cmake-native ninja-native"

SRC_URI = "git://github.com/nats-io/nats.c.git;branch=v${PV};protocol=https"
SRCREV = "v${PV}"
S = "${WORKDIR}/git"

EXTRA_OECMAKE = " \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DNATS_BUILD_EXAMPLES=OFF \
    -DNATS_BUILD_STREAMING=OFF \
    -DNATS_BUILD_TESTING=OFF \
    -DNATS_BUILD_WITH_TLS=ON \
    -DCMAKE_INSTALL_PREFIX=${D}${prefix} \
"

inherit cmake

do_install:append() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}
}

FILES:${PN} = "${libdir}/libnats.so* ${libdir}/*.so"
FILES:${PN}-dev = "${includedir} ${libdir}/pkgconfig ${libdir}/*.a ${libdir}/cmake"

SOLIBS = ".so.3.7"
GNU_HASH_STYLE = "gnu"
