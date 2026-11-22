# alienware-rgb-linux

Controle das luzes RGB do **Alienware m16 R2** no Linux, sem Alienware Command Center.

| Zona | Dispositivo | Protocolo |
|---|---|---|
| Touchpad, tampa (traseira), botão de energia | AW-ELC `187c:0551` | AlienFX API v4 (output reports de 34 bytes) |
| Teclado RGB | Darfon `0d62:d2b1` | AlienFX API v5 (feature reports `0xCC`, 64 bytes) |

O OpenRGB detecta o AW-ELC, mas não o teclado do m16 R2 ("Unknown platform 1102").

## Instalação

```sh
./install.sh
```

Instala o comando em `~/.local/bin`, a regra udev (acesso sem root), o modo discreto no login e o atalho **Super+Alt+T** (GNOME).

## Uso

```sh
alien-rgb discreto            # apaga tampa e touchpad; teclado e energia em lilás
alien-rgb normal              # tudo em lilás
alien-rgb alternar            # troca entre os dois (Super+Alt+T)
alien-rgb tampa,touchpad 8000ff
alien-rgb teclado ad7fa8
alien-rgb tudo 000000
```

Zonas: `touchpad`, `tampa`, `energia`, `teclado`, `tudo`. A cor padrão (`COR` no script) é `#AD7FA8`, o magenta claro da paleta Ubuntu do terminal.

## Créditos

Protocolo e mapeamento de luzes portados do [alien-tools](https://github.com/T-Troll/alien-tools) de T-Troll (MIT), em especial `AlienRGB-SDK/alienrgb-controls.h` e `alienrgb-gui/Mappings/devices.csv` (entrada "Alienware m16R2").

Testado apenas no m16 R2 com Ubuntu. Use por sua conta e risco.
