#!/bin/sh
# Instala o alien-rgb para o usuário atual (pede senha para a regra udev).
set -e
cd "$(dirname "$0")"

install -Dm755 alien-rgb "$HOME/.local/bin/alien-rgb"
install -Dm644 autostart/alien-rgb.desktop "$HOME/.config/autostart/alien-rgb.desktop"

sudo install -m644 udev/71-alienware-rgb.rules /etc/udev/rules.d/71-alienware-rgb.rules
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=hidraw

# Atalho Super+Alt+T para alternar discreto/normal (GNOME)
K=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/alien-rgb/
LIST=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
case "$LIST" in
  *"$K"*) ;;
  "@as []") gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$K']" ;;
  *) gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "${LIST%]}, '$K']" ;;
esac
S="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K"
gsettings set "$S" name 'Alternar luzes Alienware (discreto/normal)'
gsettings set "$S" command "$HOME/.local/bin/alien-rgb alternar"
gsettings set "$S" binding '<Super><Alt>t'

"$HOME/.local/bin/alien-rgb" discreto
echo "Instalado. Use: alien-rgb discreto | normal | alternar  (atalho Super+Alt+T)"
