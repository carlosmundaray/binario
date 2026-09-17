#!/usr/bin/env bash
# Binario Linux - Profile Definition for Archiso
# https://gitlab.archlinux.org/archlinux/archiso

iso_name="binario"
iso_label="BINARIO_$(date +%Y%m)"
iso_publisher="Binario Linux Project <https://github.com/carlosmundaray/binario>"
iso_application="Binario Linux Live/Rescue & Installation Disc"
iso_version="$(date +%Y.%m.%d)"
install_dir="binario"
buildmodes=('iso')
bootmodes=(
    'bios.syslinux.mbr'
    'bios.syslinux.eltorito'
    'uefi-ia32.systemd-boot.esp'
    'uefi-ia32.systemd-boot.eltorito'
    'uefi-x64.systemd-boot.esp'
    'uefi-x64.systemd-boot.eltorito'
)
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19' '-b' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/etc/sudoers.d"]="0:0:750"
  ["/root"]="0:0:700"
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/usr/local/bin/binario-install"]="0:0:755"
  ["/usr/local/bin/launch-heroic"]="0:0:755"
  ["/usr/local/bin/launch-protonup"]="0:0:755"
)
