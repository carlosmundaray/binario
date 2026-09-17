# ==============================================================================
# BINARIO LINUX - COMPILADOR LOCAL DE ISO (WINDOWS / DOCKER)
# ==============================================================================

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       COMPILADOR LOCAL DE ISO - BINARIO LINUX            " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Verificar si Docker Desktop está instalado y corriendo
Write-Host "[1/3] Verificando Docker Desktop..." -ForegroundColor Green
try {
    $dockerCheck = docker ps 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[-] ERROR: Docker Desktop no esta respondiendo o no esta abierto." -ForegroundColor Red
        Write-Host "    Por favor abre Docker Desktop en tu equipo y vuelve a ejecutar este script." -ForegroundColor Yellow
        pause
        exit 1
    }
} catch {
    Write-Host "[-] ERROR: No se encontro el comando docker." -ForegroundColor Red
    pause
    exit 1
}

Write-Host "[+] Docker Desktop activo y listo." -ForegroundColor Green

# 2. Crear carpeta de salida 'out' si no existe
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$outDir = Join-Path $scriptDir "out"
if (!(Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

Write-Host "[2/3] Preparando entorno de compilacion y cache de paquetes..." -ForegroundColor Green
Write-Host "      (Los paquetes se guardaran en cache para que las siguientes compilaciones sean ultrarrapidas)" -ForegroundColor Gray

# 3. Ejecutar compilación en contenedor Arch Linux privilegiado
Write-Host "[3/3] Iniciando mkarchiso en Arch Linux local..." -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor DarkGray

docker run --privileged --rm `
  -v "${scriptDir}/archiso:/archiso_in:ro" `
  -v "${outDir}:/out" `
  -v binario_pacman_cache:/var/cache/pacman/pkg `
  archlinux:latest `
  bash -c '
    set -e
    echo "==> [1/4] Sincronizando repositorios y archiso..."
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

    echo "==> [4/4] Ejecutando mkarchiso para generar la ISO..."
    mkarchiso -v -w /tmp/archiso-work -o /out /tmp/profile

    echo "==> [✓] ¡COMPILACIÓN LOCAL COMPLETADA EXITOSAMENTE!"
  '

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n==========================================================" -ForegroundColor Green
    Write-Host " [✓] ¡ISO GENERADA CON EXITO EN TU COMPUTADORA!            " -ForegroundColor Green
    Write-Host " Ubicacion:" -ForegroundColor Yellow
    Get-ChildItem -Path $outDir -Filter "*.iso" | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize
    Write-Host "==========================================================" -ForegroundColor Green
} else {
    Write-Host "`n[-] Hubo un problema durante la compilacion de la ISO." -ForegroundColor Red
}
