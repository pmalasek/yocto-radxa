# RADXA YOCTO

Po stažení projektu z GITu je třeba doinstalovat následující

```bash
git clone -b scarthgap https://git.yoctoproject.org/git/poky
git clone -b scarthgap https://git.openembedded.org/meta-openembedded
git clone -b scarthgap https://github.com/superna9999/meta-meson.git
```

Pak je potřeba opravit cesty v build/conf/bblayers.conf

A můžeme začít "péct" :

```bash
source poky/oe-init-build-env build     #inicializace prostředí
bitbake core-image-base                 # spuštění generování
```

Výsledný soubor najdeme na

```bash
cd tmp/deploy/images/radxa-zero/
bzcat core-image-base-radxa-zero-20260423194113.wic.bz2 > core-image-base-radxa-zero.wic    # rozbalení BZIP2
```
