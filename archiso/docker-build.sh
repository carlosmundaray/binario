#!/usr/bin/env bash
# ==============================================================================
# BINARIO LINUX - COMPILADOR DENTRO DE CONTENEDOR ARCH LINUX
# ==============================================================================

set -e

echo "==> [1/4] Inicializando pacman-key y actualizando archiso..."
pacman-key --init
pacman-key --populate archlinux
pacman -Sy --noconfirm archiso syslinux mkinitcpio

echo "==> [2/4] Copiando perfil al sistema de archivos nativo de Linux..."
rm -rf /tmp/profile /tmp/archiso-work
mkdir -p /tmp/profile
cp -r /archiso_in/* /tmp/profile/

echo "==> [3/4] Configurando módulos Syslinux (BIOS) y permisos..."
if [ -d /usr/lib/syslinux/bios ]; then
  cp /usr/lib/syslinux/bios/*.c32 /tmp/profile/syslinux/ 2>/dev/null || true
fi
chmod +x /tmp/profile/airootfs/root/customize_airootfs.sh || true
chmod +x /tmp/profile/airootfs/usr/local/bin/* || true

echo "==> [4/4] Ejecutando mkarchiso para compilar Binario Linux..."
mkarchiso -v -w /tmp/archiso-work -o /out /tmp/profile

echo "=========================================================="
echo "==> [✓] ¡COMPILACIÓN DE LA ISO COMPLETADA EXITOSAMENTE!"
echo "=========================================================="
