#!/usr/bin/env bash
# ==============================================================================
# BINARIO LINUX - AIROOTFS CUSTOMIZATION SCRIPT
# Ejecutado automáticamente por mkarchiso para configurar el entorno Live/Base
# ==============================================================================

set -e -u

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
useradd -m -u 1000 -g 1000 -G wheel,video,audio,storage,optical,network,power,gamemode -s /bin/bash binario || true
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

echo "==> [Binario] Habilitando servicios Systemd esenciales..."
systemctl enable NetworkManager.service || true
systemctl enable sddm.service || true
systemctl enable ufw.service || true
systemctl enable apparmor.service || true
systemctl enable ananicy-cpp.service || true
systemctl enable power-profiles-daemon.service || true

echo "==> [Binario] Configurando Fastfetch para inicio de terminal..."
echo "fastfetch" >> /etc/skel/.bashrc
echo "fastfetch" >> /root/.bashrc

echo "==> [Binario] Personalización completada con éxito."
