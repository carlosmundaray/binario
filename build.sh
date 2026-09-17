#!/usr/bin/env bash
# ==============================================================================
# BINARIO LINUX - BUILD SCRIPT
# Compila la imagen ISO autoarrancable usando mkarchiso
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_DIR="${SCRIPT_DIR}/archiso"
WORK_DIR="/tmp/archiso-binario-work"
OUT_DIR="${SCRIPT_DIR}/out"

echo "=========================================================="
echo "          COMPILADOR DE ISO - BINARIO LINUX              "
echo "=========================================================="

if [ "$EUID" -ne 0 ]; then
  echo "[-] ERROR: Este script debe ejecutarse con permisos de superusuario (root o sudo)."
  exit 1
fi

if ! command -v mkarchiso &>/dev/null; then
  echo "[-] Instalando dependencia requerida: archiso..."
  pacman -Sy --noconfirm archiso
fi

echo "[+] Limpiando directorios de trabajo anteriores..."
rm -rf "${WORK_DIR}"
mkdir -p "${OUT_DIR}"

echo "[+] Ajustando permisos de los scripts de personalización y lanzadores..."
chmod +x "${PROFILE_DIR}/airootfs/root/customize_airootfs.sh" || true
chmod +x "${PROFILE_DIR}/airootfs/usr/local/bin/binario-install" || true
chmod +x "${PROFILE_DIR}/airootfs/usr/local/bin/launch-heroic" || true
chmod +x "${PROFILE_DIR}/airootfs/usr/local/bin/launch-protonup" || true

echo "[+] Iniciando proceso de compilación con mkarchiso..."
mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" "${PROFILE_DIR}"

echo "=========================================================="
echo " [✓] ¡COMPILACIÓN COMPLETADA EXITOSAMENTE!                 "
echo " La ISO de Binario Linux se encuentra en:                 "
ls -lh "${OUT_DIR}"/*.iso
echo "=========================================================="
