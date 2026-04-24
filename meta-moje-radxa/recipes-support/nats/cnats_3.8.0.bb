SUMMARY = "A C client for the NATS messaging system"
HOMEPAGE = "https://github.com/nats-io/nats.c"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2b42edef8fa55315f34f2370b4715ca9"

DEPENDS = "openssl"

SRC_URI = "git://github.com/nats-io/nats.c.git;protocol=https;nobranch=1"
SRCREV = "v3.8.0"

S = "${WORKDIR}/git"

inherit cmake

EXTRA_OECMAKE = "-DNATS_BUILD_EXAMPLES=OFF -DNATS_BUILD_TESTING=OFF -DNATS_BUILD_STREAMING=OFF"
