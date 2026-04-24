do_fix_pseudo_glibc() {
    # Projdeme zdrojaky a opravime chybejici const u open_how
    find ${S} -type f -name "wrapfuncs.in" -exec sed -i 's/struct open_how/const struct open_how/g' {} + || true
    find ${S} -type f -name "openat2.c" -exec sed -i 's/struct open_how/const struct open_how/g' {} + || true
}

# Rekneme Yocto, at tuto nasi funkci spusti ihned po do_patch
do_patch[postfuncs] += "do_fix_pseudo_glibc"
