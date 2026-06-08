# Just – Task Runner pro tento projekt

## Co je `just`?

[`just`](https://github.com/casey/just) je jednoduchý task runner inspirovaný `make`, ale bez jeho záludností (závislosti na tabulátorech, implicitní pravidla pro soubory, automatická rekompilace atd.). Recepty jsou definované v souboru `justfile` a spouštějí se příkazem `just <recept>`.

Klíčové vlastnosti:
- Recepty mohou mít parametry (`just build-pkg nats`)
- Proměnné a interpolace (`{{machine}}`, `{{image}}`)
- Víceřádkové shebang skripty (`#!/usr/bin/env bash`)
- Automatický výpis dostupných příkazů (`just --list`)
- Žádná závislost na existenci souborů – čistě taskový runner

---

## Instalace

### Ubuntu / Debian

```bash
# Pomocí snapu (doporučeno – vždy aktuální verze):
sudo snap install just --classic

# Nebo přes cargo (vyžaduje Rust):
cargo install just

# Nebo stáhnout předkompilovaný binární soubor:
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/.local/bin
```

### Fedora / RHEL / CentOS Stream

```bash
# Přes DNF (dostupné v repozitářích Fedora):
sudo dnf install just

# Nebo přes cargo:
cargo install just

# Nebo předkompilovaný binární soubor:
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/.local/bin
```

### Windows 11

```powershell
# Pomocí winget (doporučeno):
winget install --id Casey.Just

# Pomocí Scoop:
scoop install just

# Pomocí Chocolatey:
choco install just

# Pomocí Cargo (vyžaduje Rust):
cargo install just
```

> **Poznámka pro Windows:** `just` vyžaduje shell pro spouštění receptů. Ve výchozím nastavení používá `sh` (dostupný přes Git Bash nebo WSL). Přidejte do `justfile` řádek `set shell := ["cmd", "/C"]` pro použití `cmd.exe`, nebo použijte WSL2.

### macOS

```bash
# Pomocí Homebrew (doporučeno):
brew install just

# Pomocí MacPorts:
port install just

# Pomocí Cargo:
cargo install just
```

---

## Ověření instalace

```bash
just --version
# just 1.x.x
```

---

## Použití

```bash
just               # Zobrazí seznam dostupných receptů (výchozí akce)
just --list        # Totéž – explicitní výpis
just <recept>      # Spustí pojmenovaný recept
just <recept> arg  # Spustí recept s parametrem
```

---

## Recepty v tomto projektu

### Buildování

| Příkaz | Popis |
|---|---|
| `just build` | Sestaví hlavní obraz (`core-image-base`) pro Radxa Zero |
| `just build-pkg <pkg>` | Sestaví konkrétní balíček, např. `just build-pkg nats` |
| `just compile <pkg>` | Sestaví balíček pouze do fáze `compile`, např. `just compile nats` |

### Čištění

| Příkaz | Popis |
|---|---|
| `just clean <pkg>` | Vyčistí build artefakty balíčku, zachová sstate cache |
| `just cleansstate <pkg>` | Vyčistí sstate cache balíčku – vynutí úplné přebuilování |
| `just cleanall` | Smaže celý adresář `build/tmp/` (zachová `downloads/` a `sstate-cache/`) |

### Vývojové nástroje

| Příkaz | Popis |
|---|---|
| `just devshell <pkg>` | Otevře interaktivní vývojový shell pro ladění balíčku |
| `just menuconfig` | Spustí `menuconfig` pro konfiguraci jádra |
| `just depexp <pkg>` | Zobrazí strom závislostí balíčku |
| `just server` | Spustí BitBake server na pozadí |

### Obraz a nasazení

| Příkaz | Popis |
|---|---|
| `just ls-deploy` | Vypíše soubory v deploy adresáři (`build/tmp/deploy/images/radxa-zero/`) |
| `just extract` | Rozbalí nejnovější `.wic.bz2` obraz na `.wic` |
| `just flash /dev/sdX` | Zapíše `.wic` obraz na zadané blokové zařízení (vyžaduje `root`) |
| `just usb-boot` | Přepne Radxa Zero do USB boot módu pomocí `rz-udisk-loader.bin` |

### Nastavení prostředí

| Příkaz | Popis |
|---|---|
| `just setup` | Kompletní inicializace: nainstaluje závislosti, naklonuje vrstvy, opraví AppArmor |
| `just setup-environment` | Naklonuje chybějící vrstvy (`poky`, `meta-openembedded`, `meta-meson`) a vytvoří potřebné adresáře |
| `just deps` | Nainstaluje systémové závislosti na Ubuntu/Debian (`apt install`) |
| `just fix-apparmor` | Povolí unprivileged user namespaces – nutné na Ubuntu s AppArmor |

---

## Typický pracovní postup

```bash
# 1. První spuštění – inicializace prostředí
just setup

# 2. Sestavení obrazu
just build

# 3. Rozbalení a zápis na kartu
just extract
just flash /dev/sdb

# nebo pro vývoj jednoho balíčku:
just build-pkg nats
just devshell nats
just clean nats
```

---

## Více informací

- Domovská stránka: <https://just.systems>
- Dokumentace: <https://just.systems/man/en/>
- GitHub: <https://github.com/casey/just>
