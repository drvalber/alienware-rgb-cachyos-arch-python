#!/bin/sh
# Instala o alien-rgb para o usuário atual (pede senha para a regra udev).
set -e
cd "$(dirname "$0")"

install -Dm755 alien-rgb "$HOME/.local/bin/alien-rgb"
install -Dm644 autostart/alien-rgb.desktop "$HOME/.config/autostart/alien-rgb.desktop"

sudo install -m644 udev/71-alienware-rgb.rules /etc/udev/rules.d/71-alienware-rgb.rules
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=hidraw

# Atalho Super+Alt+T para alternar discreto/normal
atalho_gnome() {
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
}

atalho_kde() {
  D=alien-rgb-alternar.desktop
  mkdir -p "$HOME/.local/share/applications"
  cat > "$HOME/.local/share/applications/$D" <<EOF
[Desktop Entry]
Type=Application
Name=Alternar luzes Alienware (discreto/normal)
Exec=$HOME/.local/bin/alien-rgb alternar
Icon=preferences-desktop-color
NoDisplay=true
X-KDE-Shortcuts=Meta+Alt+T
EOF
  KW=$(command -v kwriteconfig6 || command -v kwriteconfig5)
  "$KW" --file kglobalshortcutsrc --group services --group "$D" --key _launch "Meta+Alt+T"
  echo "Atalho KDE criado; pode ser preciso sair e entrar na sessão para ativá-lo."
}

case "${XDG_CURRENT_DESKTOP:-}" in
  *KDE*) atalho_kde ;;
  *GNOME*|*Unity*) atalho_gnome ;;
  *) echo "Ambiente '${XDG_CURRENT_DESKTOP:-?}' não suportado para o atalho; configure manualmente: alien-rgb alternar" ;;
esac

"$HOME/.local/bin/alien-rgb" discreto
echo "Instalado. Use: alien-rgb discreto | normal | alternar  (atalho Super+Alt+T)"
