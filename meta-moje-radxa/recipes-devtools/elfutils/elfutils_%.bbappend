# 1. Zakážeme chybu prohození const u bsearch pro GCC 14
BUILD_CFLAGS:append = " -Wno-error=discarded-qualifiers"
CFLAGS:append = " -Wno-error=discarded-qualifiers"

# 2. Funkce pro odstranění -Werror z Makefile (přejmenovaná bez podtržítek)
removewerror() {
    find ${S} -name Makefile.in -exec sed -i 's/-Werror//g' {} +
    find ${S} -name Makefile.am -exec sed -i 's/-Werror//g' {} +
}

# 3. Přidání do post-patch fáze
do_patch[postfuncs] += "removewerror"
