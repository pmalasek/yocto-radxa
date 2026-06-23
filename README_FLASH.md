# Flashování image na Radxa Zero

Tento dokument popisuje, jak zapsat výsledný Yocto image na Radxa Zero ze systémů Linux, Windows a macOS.

---

## Příprava image

Výsledný obraz po buildu najdete v:

```
build/tmp/deploy/images/radxa-zero/
```

Před flashováním je třeba obraz rozbalit z formátu `.wic.bz2`:

```bash
bzcat core-image-base-radxa-zero-*.wic.bz2 > core-image-base-radxa-zero.wic
```

---

## Uvedení Radxa Zero do USB Mass Storage režimu

Radxa Zero musí být před zápisem přepnuta do režimu USB Mass Storage přes zavaděč `pyamlboot`:

1. Stáhněte USB loader:

   ```bash
   wget https://dl.radxa.com/zero/images/loader/rz-udisk-loader.bin
   ```

2. **Stiskněte a podržte tlačítko** na Radxa Zero (na spodní straně desky, vedle USB-C konektoru), pak připojte napájení (USB-C). Tlačítko držte dokud se zařízení neobjeví jako USB Mass Storage.

3. Spusťte boot-g12.py:

   ```bash
   boot-g12.py rz-udisk-loader.bin
   ```

---

## Flashování na Linuxu

### Požadavky

```bash
python3 -m venv ~/radxa-flash
source ~/radxa-flash/bin/activate
pip install pyamlboot
```

### Zápis image

```bash
sudo su
lsblk        # zjistěte, na kterém /dev/sdX je Radxa Zero
dd if=core-image-base-radxa-zero.wic of=/dev/sdX bs=4M status=progress conv=fsync
```

> **Varování:** Správně určete `/dev/sdX` – zápisem na špatné zařízení dojde ke ztrátě dat!

Alternativně lze použít `bmaptool` (rychlejší):

```bash
sudo apt install bmap-tools
sudo bmaptool copy core-image-base-radxa-zero.wic /dev/sdX
```

---

## Flashování na macOS

### Požadavky

```bash
brew install python3
python3 -m venv ~/radxa-flash
source ~/radxa-flash/bin/activate
pip install pyamlboot
```

### Zápis image

```bash
diskutil list                        # zjistěte disk (např. /dev/disk4)
diskutil unmountDisk /dev/diskN
sudo dd if=core-image-base-radxa-zero.wic of=/dev/rdiskN bs=4m
```

> Použijte `/dev/rdiskN` (raw disk) místo `/dev/diskN` pro výrazně vyšší rychlost zápisu.

Alternativně použijte grafický nástroj **[balenaEtcher](https://etcher.balena.io/)** – viz sekce níže.

---

## Flashování na Windows

### Možnost 1: balenaEtcher (doporučeno)

1. Stáhněte a nainstalujte [balenaEtcher](https://etcher.balena.io/).
2. Klikněte na **Flash from file** a vyberte `.wic` soubor (nebo `.wic.bz2` – Etcher podporuje přímý zápis z archivu).
3. Vyberte cílové zařízení (Radxa Zero v USB Mass Storage režimu).
4. Klikněte na **Flash!**.

### Možnost 2: Win32DiskImager

1. Stáhněte [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/).
2. Vyberte `.wic` soubor jako Image File.
3. Vyberte správné zařízení (písmeno disku odpovídající Radxa Zero).
4. Klikněte na **Write**.

### Možnost 3: WSL2 + dd

Pokud máte nainstalovaný WSL2, můžete použít stejný postup jako na Linuxu:

```bash
# Ve WSL2:
python3 -m venv ~/radxa-flash
source ~/radxa-flash/bin/activate
pip install pyamlboot
boot-g12.py rz-udisk-loader.bin
```

> **Poznámka:** Přístup k fyzickým diskovým zařízením z WSL2 vyžaduje `usbipd-win`. Doporučujeme použít balenaEtcher.

---

## WiFi připojení

Po prvním startu se zařízení automaticky připojí k WiFi síti:

| Parametr  | Hodnota      |
|-----------|--------------|
| **SSID**  | `XTUNING`    |
| **Heslo** | `ATXGroup`   |

> Síť `XTUNING` musí být dostupná, jinak se zařízení nepřipojí k síti a bude dostupné pouze přes UART konzoli nebo po ruční konfiguraci sítě.

---

## Výchozí přihlašovací údaje

| Uživatel    | Heslo           | Poznámka                                    |
|-------------|-----------------|---------------------------------------------|
| `root`      | `ATXGroup.2026` | Superuživatel, plný přístup                 |
| `xsystem`   | `Pluto9`        | Systémový uživatel pro provoz aplikací      |

Hesla jsou uložena jako SHA-512 hashe (generováno pomocí `openssl passwd -6`):

```bash
# root password hash generated with:   openssl passwd -6 "ATXGroup.2026"
# xsystem password hash generated with: openssl passwd -6 "Pluto9"
```

> **Bezpečnostní doporučení:** Po prvním přihlášení změňte výchozí hesla příkazem `passwd`.

---

## Ověření spuštění

Po úspěšném zápisu a restartu zařízení se lze přihlásit přes SSH (po připojení k síti XTUNING):

```bash
ssh root@<IP-adresa-zařízení>
```

IP adresu zařízení zjistíte například ze DHCP serveru routeru nebo přes `nmap`:

```bash
nmap -sn 192.168.1.0/24
```
