#!/usr/bin/env bash
# ==============================================================================
# BINARIO LINUX - AIROOTFS CUSTOMIZATION SCRIPT
# Ejecutado automáticamente por mkarchiso para configurar el entorno Live/Base
# ==============================================================================

set -e -u

echo "==> [Binario] Configurando identidad del sistema..."
echo "binario-os" > /etc/hostname

cat << 'EOF' > /etc/os-release
NAME="Binario Linux"
PRETTY_NAME="Binario Linux (Gaming & Security Edition)"
ID=binario
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;0;200;255"
HOME_URL="https://github.com/carlosmundaray/binario"
DOCUMENTATION_URL="https://wiki.archlinux.org"
SUPPORT_URL="https://github.com/carlosmundaray/binario/issues"
BUG_REPORT_URL="https://github.com/carlosmundaray/binario/issues"
LOGO=binario-logo
EOF

cat << 'EOF' > /etc/lsb-release
DISTRIB_ID=Binario
DISTRIB_RELEASE=rolling
DISTRIB_DESCRIPTION="Binario Linux Gaming & Security"
DISTRIB_CODENAME=rolling
EOF

cat << 'EOF' > /etc/issue
\e[38;2;0;220;255m
 ____  _             _         
| __ )(_)_ __   __ _| |_ _   _ 
|  _ \| | '_ \ / _` | __| | | |
| |_) | | | | | (_| | |_| |_| |
|____/|_|_| |_|\__,_|\__|\__,_|  [Gaming & Security Edition]
\e[0m
Bienvenido a \e[1mBinario Linux\e[0m (\l) - Arch Linux Optimized Kernel
Fecha y hora: \d \t

Para iniciar el instalador grafico ejecuta: \e[1;32mbinario-install\e[0m
O instalador en terminal: \e[1;36marchinstall\e[0m

EOF

echo "==> [Binario] Configurando idioma y locales..."
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
sed -i 's/#\(es_ES\.UTF-8\)/\1/' /etc/locale.gen
locale-gen
echo "LANG=es_ES.UTF-8" > /etc/locale.conf

echo "==> [Binario] Configurando zona horaria y reloj..."
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc --utc

echo "==> [Binario] Creando usuario live 'binario'..."
groupadd -r -g 1000 binario || true
useradd -m -u 1000 -g 1000 -G wheel,video,audio,storage,optical,network,power,gamemode,input -s /bin/bash binario || true
echo "binario:binario" | chpasswd
echo "root:root" | chpasswd

# Permitir sudo al grupo wheel sin contraseña en el Live Environment
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/00-wheel-nopasswd
chmod 440 /etc/sudoers.d/00-wheel-nopasswd

echo "==> [Binario] Configurando auto-login para SDDM en Live Mode..."
mkdir -p /etc/sddm.conf.d
cat <<EOF > /etc/sddm.conf.d/autologin.conf
[Autologin]
User=binario
Session=plasma
EOF

echo "==> [Binario] Configurando UFW Firewall por defecto..."
ufw default deny incoming || true
ufw default allow outgoing || true

echo "==> [Binario] Habilitando repositorio Flathub para Gaming & Apps..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true

echo "==> [Binario] Habilitando servicios Systemd esenciales..."
systemctl enable NetworkManager.service || true
systemctl enable sddm.service || true
systemctl enable ufw.service || true
systemctl enable apparmor.service || true
systemctl enable ananicy-cpp.service || true
systemctl enable power-profiles-daemon.service || true

echo "==> [Binario] Configurando permisos de accesos directos en el escritorio..."
chmod +x /etc/skel/Desktop/*.desktop 2>/dev/null || true

echo "==> [Binario] Configurando Fastfetch para inicio de terminal..."
echo "fastfetch" >> /etc/skel/.bashrc
echo "fastfetch" >> /root/.bashrc

echo "==> [Binario] Generando initramfs con soporte Live archiso para kernels..."
mkinitcpio -P || true

echo "==> [Binario] Personalización completada con éxito."
