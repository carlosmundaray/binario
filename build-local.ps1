# ==============================================================================
# BINARIO LINUX - COMPILADOR LOCAL DE ISO (WINDOWS / DOCKER)
# ==============================================================================

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       COMPILADOR LOCAL DE ISO - BINARIO LINUX            " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Verificar si Docker Desktop esta instalado y corriendo
Write-Host "[1/3] Verificando Docker Desktop..." -ForegroundColor Green
try {
    $dockerCheck = docker ps 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[-] ERROR: Docker Desktop no esta respondiendo o no esta abierto." -ForegroundColor Red
        Write-Host "    Por favor abre Docker Desktop en tu equipo y vuelve a ejecutar este script." -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "[-] ERROR: No se encontro el comando docker." -ForegroundColor Red
    exit 1
}

Write-Host "[+] Docker Desktop activo y listo." -ForegroundColor Green

# 2. Rutas del proyecto
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $scriptDir) { $scriptDir = (Get-Location).Path }
$outDir = Join-Path $scriptDir "out"
if (!(Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

$archisoDockerPath = (Join-Path $scriptDir "archiso").Replace('\', '/')
$outDockerPath = $outDir.Replace('\', '/')

Write-Host "[2/3] Preparando entorno de compilacion..." -ForegroundColor Green
Write-Host "      Cache persistente: binario_pacman_cache" -ForegroundColor Gray

# 3. Ejecutar compilacion en contenedor Arch Linux privilegiado
Write-Host "[3/3] Iniciando compilacion de Binario Linux en contenedor..." -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor DarkGray

docker run --privileged --rm `
  -v "${archisoDockerPath}:/archiso_in:ro" `
  -v "${outDockerPath}:/out" `
  -v binario_pacman_cache:/var/cache/pacman/pkg `
  archlinux:latest `
  bash /archiso_in/docker-build.sh

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host " [OK] ISO GENERADA CON EXITO EN TU COMPUTADORA!" -ForegroundColor Green
    Write-Host " Ubicacion en tu disco duro:" -ForegroundColor Yellow
    Get-ChildItem -Path $outDir -Filter "*.iso" | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize
    Write-Host "==========================================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "[-] Hubo un problema durante la compilacion de la ISO." -ForegroundColor Red
}
