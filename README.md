# RADXA YOCTO

Po stažení projektu z GITu je třeba doinstalovat následující

```bash
git clone -b scarthgap https://git.yoctoproject.org/git/poky
git clone -b scarthgap https://git.openembedded.org/meta-openembedded
git clone -b scarthgap https://github.com/superna9999/meta-meson.git
```

Pak je potřeba opravit cesty v build/conf/bblayers.conf

Na Ubuntu je pak dobré povolit unprivileged user namespaces (AppArmor to blokuje)

```bash
echo "kernel.apparmor_restrict_unprivileged_userns=0" | sudo tee /etc/sysctl.d/60-apparmor-namespace.conf
sudo sysctl -p /etc/sysctl.d/60-apparmor-namespace.conf
```

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

Zapsání na Radxa Zepro

Na Radxa Zero stiskneme tlačítko a připojíme napájení

```bash
source .venv/bin/activate
boot-g12.py rz-udisk-loader.bin
lsblk   # Zjistíme na kterém zařízení máme RADXA Zero
sudo dd if=core-image-base-radxa-zero.wic of=/dev/sdX bs=4M status=progress conv=fsync
```
