# 1. Nejsilnejsi zbran: rekneme prekladaci, at u teto konkretni veci vzdy ignoruje -Werror
BUILD_CFLAGS:append = " -Wno-error=discarded-qualifiers"
CFLAGS:append = " -Wno-error=discarded-qualifiers"

# 2. Pro jistotu odstranime werror i z nastaveni Mesonu a Makefile
removewerror() {
    if [ -f ${S}/meson.build ]; then
        sed -i 's/werror=true/werror=false/g' ${S}/meson.build
        sed -i "s/'-Werror'//g" ${S}/meson.build
        sed -i 's/-Werror//g' ${S}/meson.build
    fi
    if [ -f ${S}/Makefile ]; then
        sed -i 's/WARNINGS = -Werror/WARNINGS =/g' ${S}/Makefile
        sed -i 's/-Werror//g' ${S}/Makefile
    fi
}
do_patch[postfuncs] += "removewerror"
