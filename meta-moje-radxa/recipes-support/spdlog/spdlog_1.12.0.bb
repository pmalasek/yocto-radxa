DESCRIPTION = "Very fast C++ logging library"
HOMEPAGE = "https://github.com/gabime/spdlog"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=bd5cc7fa6ff5ee46fc1047f0f0c895b7"

DEPENDS = "fmt cmake-native ninja-native"

SRC_URI = "git://github.com/gabime/spdlog.git;protocol=https;nobranch=1"
SRCREV = "7e635fca68d014934b4af8a1cf874f63989352b7"
S = "${WORKDIR}/git"

EXTRA_OECMAKE = " \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DSPDLOG_BUILD_SHARED=ON \
    -DSPDLOG_BUILD_TESTS=OFF \
    -DSPDLOG_BUILD_EXAMPLE=OFF \
    -DSPDLOG_FMT_EXTERNAL=ON \
"

inherit cmake

GNU_HASH_STYLE = "gnu"
