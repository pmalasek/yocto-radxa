DESCRIPTION = "A modern C++ formatting library"
HOMEPAGE = "https://github.com/fmtlib/fmt"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.rst;md5=af88d758f75f3c5c48a967501f24384b"

DEPENDS = "cmake-native ninja-native"

SRC_URI = "git://github.com/fmtlib/fmt.git;protocol=https;nobranch=1"
SRCREV = "a33701196adfad74917046096bf5a2aa0ab0bb50"
S = "${WORKDIR}/git"

EXTRA_OECMAKE = " \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DFMT_TEST=OFF \
"

inherit cmake

GNU_HASH_STYLE = "gnu"
