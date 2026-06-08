# Justfile pro Yocto/Radxa Zero projekt
# Použití: just <recept>  (just --list pro seznam)

set quiet

machine   := "radxa-zero"
image     := "core-image-base"
build_dir := "build"
deploy    := build_dir / "tmp/deploy/images" / machine
init      := "source poky/oe-init-build-env " + build_dir + " > /dev/null"
chip_dir  := "chip"

# Výchozí recept – zobrazí seznam
default:
    @just --list

# ── Buildování ────────────────────────────────────────────────────────────────

# Sestaví hlavní obraz (core-image-base)
build:
    bash -c "{{init}} && bitbake {{image}}"

# Sestaví konkrétní balíček: just build-pkg nats
build-pkg pkg:
    bash -c "{{init}} && bitbake {{pkg}}"

# Sestaví konkrétní balíček a závislosti pouze do fáze compile: just compile nats
compile pkg:
    bash -c "{{init}} && bitbake -c compile {{pkg}}"

# ── Čištění ───────────────────────────────────────────────────────────────────

# Vyčistí build artefakty balíčku (zachová sstate): just clean nats
clean pkg:
    bash -c "{{init}} && bitbake -c clean {{pkg}}"

# Vyčistí sstate cache balíčku (vynucené přebuilování): just cleansstate nats
cleansstate pkg:
    bash -c "{{init}} && bitbake -c cleansstate {{pkg}}"

# Vyčistí celý tmp/ adresář (ponechá downloads a sstate-cache)
cleanall:
    @echo "Mažu {{build_dir}}/tmp/ ..."
    rm -rf {{build_dir}}/tmp/

# ── Vývojové nástroje ─────────────────────────────────────────────────────────

# Otevře devshell pro balíček: just devshell nats
devshell pkg:
    bash -c "{{init}} && bitbake -c devshell {{pkg}}"

# Otevře menuconfig pro kernel
menuconfig:
    bash -c "{{init}} && bitbake -c menuconfig virtual/kernel"

# Zobrazí závislosti balíčku (otevře okno): just depexp nats
depexp pkg:
    bash -c "{{init}} && bitbake -g {{pkg}} && cat pn-buildlist | grep -ve '^-' | sort -u"

# Spustí BitBake server (pro použití příkazové řádky bez zdrojování)
server:
    bash -c "{{init}} && bitbake --server-only"

# ── Obraz a nasazení ──────────────────────────────────────────────────────────

# Vypíše soubory v deploy adresáři
ls-deploy:
    ls -lh {{deploy}}/

# Rozbalí nejnovější WIC obraz (bzip2 → .wic)
extract:
    #!/usr/bin/env bash
    set -euo pipefail
    latest=$(ls -t {{deploy}}/{{image}}-{{machine}}-*.wic.bz2 2>/dev/null | head -1)
    if [[ -z "$latest" ]]; then
        echo "Žádný .wic.bz2 obraz nenalezen v {{deploy}}/"
        exit 1
    fi
    out="{{deploy}}/{{image}}-{{machine}}.wic"
    echo "Rozbaluji $latest → $out"
    bzcat "$latest" > "$out"
    echo "Hotovo: $out ($(du -h "$out" | cut -f1))"

# Zapíše obraz na SD kartu (vyžaduje root): just flash /dev/sdb
flash dev:
    #!/usr/bin/env bash
    set -euo pipefail
    wic="{{deploy}}/{{image}}-{{machine}}.wic"
    if [[ ! -f "$wic" ]]; then
        echo "Obraz $wic neexistuje – spusťte nejprve: just extract"
        exit 1
    fi
    echo "Zapisuji $wic → {{dev}}"
    sudo dd if="$wic" of={{dev}} bs=4M status=progress conv=fsync
    echo "Hotovo."

# Zapíše obraz na eMMC (přes USB disk mód): just flash-emmc /dev/sdX
# Před spuštěním musí být deska v USB disk módu: just usb-boot
flash-emmc dev:
    #!/usr/bin/env bash
    set -euo pipefail
    wic="{{deploy}}/{{image}}-{{machine}}.wic"
    mmc_bl="{{deploy}}/u-boot.bin.mmc.bin"
    if [[ ! -f "$wic" ]]; then
        echo "Obraz $wic neexistuje – spusťte nejprve: just extract"
        exit 1
    fi
    if [[ ! -f "$mmc_bl" ]]; then
        echo "eMMC bootloader $mmc_bl nenalezen"
        exit 1
    fi
    echo "Zapisuji $wic → {{dev}}"
    sudo dd if="$wic" of={{dev}} bs=4M status=progress conv=fsync
    echo "Přepisuji bootloader eMMC variantou ($mmc_bl)..."
    sudo dd if="$mmc_bl" of={{dev}} conv=notrunc bs=1 count=440
    sudo dd if="$mmc_bl" of={{dev}} conv=notrunc bs=512 skip=1 seek=1
    sudo sync
    echo "Hotovo. (použit u-boot.bin.mmc.bin)"

# Přepne Radxa Zero do USB boot módu (spouští se z adresáře chip/)
usb-boot:
    #!/usr/bin/env bash
    set -euo pipefail
    loader="{{chip_dir}}/rz-udisk-loader.bin"
    if [[ ! -f "$loader" ]]; then
        echo "Soubor $loader nenalezen – spusťte nejprve: just setup-usb"
        exit 1
    fi
    boot_g12="$HOME/.local/bin/boot-g12.py"
    if [[ ! -x "$boot_g12" ]]; then
        echo "boot-g12.py nenalezen – spusťte nejprve: just setup-usb"
        exit 1
    fi
    cd "{{chip_dir}}"
    sudo "$boot_g12" rz-udisk-loader.bin

# ── Nastavení prostředí ───────────────────────────────────────────────────────

# Nainstaluje závislosti, naklonuje vrstvy a opraví AppArmor
setup: deps setup-environment fix-apparmor

# Naklonuje chybějící vrstvy (poky, meta-openembedded, meta-meson)
setup-environment:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -d poky ]]             || git clone -b scarthgap https://git.yoctoproject.org/git/poky
    [[ -d meta-openembedded ]] || git clone -b scarthgap https://git.openembedded.org/meta-openembedded
    [[ -d meta-meson ]]        || git clone -b scarthgap https://github.com/superna9999/meta-meson.git
    mkdir -p meta-moje-radxa/xpluto9/bin meta-moje-radxa/xpluto9/certs
    touch meta-moje-radxa/xpluto9/.env
    echo "Vrstvy jsou připraveny."

# Nainstaluje závislosti na Ubuntu/Debian
deps:
    sudo apt install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
        build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
        xz-utils debianutils iputils-ping lz4 zstd
    sudo ln -sf /usr/lib/x86_64-linux-gnu/libcrypt.so.2 \
                /usr/lib/x86_64-linux-gnu/libcrypt.so || true

# Připraví adresář chip/ pro USB boot (stáhne loader, nainstaluje boot-g12.py)
setup-usb:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p "{{chip_dir}}"
    loader="{{chip_dir}}/rz-udisk-loader.bin"
    if [[ ! -f "$loader" ]]; then
        echo "Stahuji rz-udisk-loader.bin → $loader"
        curl -fL -o "$loader" \
            https://dl.radxa.com/zero/images/loader/rz-udisk-loader.bin
        echo "Staženo: $loader ($(du -h "$loader" | cut -f1))"
    else
        echo "$loader již existuje, přeskakuji stažení."
    fi
    echo "Instaluji pyamlboot (boot-g12.py)..."
    if ! command -v pipx &>/dev/null; then
        sudo apt install -y pipx
    fi
    pipx install pyamlboot
    echo "USB boot prostředí připraveno v {{chip_dir}}/"

# Povolí unprivileged user namespaces (potřeba na Ubuntu s AppArmor)
fix-apparmor:
    echo "kernel.apparmor_restrict_unprivileged_userns=0" \
        | sudo tee /etc/sysctl.d/60-apparmor-namespace.conf
    sudo sysctl -p /etc/sysctl.d/60-apparmor-namespace.conf
