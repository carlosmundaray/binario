# 🎮 🛡️ Binario Linux

**Binario Linux** es una distribución de alto rendimiento basada en **Arch Linux**, optimizada desde el núcleo para **videojuegos (Gaming)**, **estabilidad a largo plazo** y **seguridad reforzada**.

---

## 🚀 Características Principales

### 🎮 Gaming y Tiendas Preinstaladas
- **Tiendas y Lanzadores**:
  - **Steam**: Plataforma líder con compatibilidad Proton y Steam Native Runtime preconfigurados.
  - **Epic Games Store & GOG (Heroic Launcher)**: Lanzador nativo de alto rendimiento para tus bibliotecas de Epic Games, GOG y Prime Gaming.
  - **Lutris**: Gestor universal para Epic Games, Battle.net, EA App, Ubisoft Connect y emuladores.
  - **ProtonUp-Qt**: Gestor gráfico para descargar e instalar con un clic las versiones más recientes de **GE-Proton** (Proton-GE) y Wine-GE.
- **Rendimiento & Overlays**:
  - **Feral GameMode** (`gamemode` + 32-bit): Ajuste automático de prioridades y gobernador de CPU al iniciar juegos.
  - **MangoHud & GOverlay**: Monitor gamer en pantalla para FPS, frametimes, uso de VRAM/RAM y temperaturas de GPU/CPU.
  - **Valve Gamescope**: Microcompositor para FSR scaling, control de latencia y resolución.
- **Capa de Compatibilidad & Codecs**:
  - **Wine Staging**, **Wine Mono**, **Wine Gecko**, **Winetricks** y **VKD3D** (Direct3D 12 -> Vulkan).
  - **Stack GStreamer completo** (plugins good, bad, ugly, libav) para garantizar la reproducción fluida de cinemáticas en juegos de Windows sin pantallas negras.
  - **Soporte Plug & Play para Mandos**: Reglas `udev` para PlayStation DualSense/DualShock, Xbox One/Series X/S, Nintendo Switch Pro y volantes.
- **Streaming y Comunicación**:
  - **OBS Studio** para grabación y streaming de partidas en Twitch/YouTube.
  - **Discord** para chat de voz en grupo.

### 🛡️ Seguridad y Respaldo
- **Hardening del Sistema**: AppArmor activo por defecto para confinamiento de procesos.
- **Firewall**: UFW preconfigurado con políticas restrictivas de entrada.
- **Instantáneas del Sistema**: Soporte para Btrfs y Snapper / Timeshift para revertir actualizaciones en caso de fallo.
- **Sandboxing**: Flatpak y Flatseal para aislar aplicaciones no confiables.

### 🖥️ Experiencia de Usuario
- **Entorno de Escritorio**: **KDE Plasma 6** con soporte nativo de Wayland (G-Sync/FreeSync VRR, HDR y baja latencia).
- **Instalador Intuitivo**: Instalador gráfico **Calamares** o instalador por terminal **archinstall** con un solo clic.

---

## 📂 Estructura del Proyecto

```
binario/
├── .github/workflows/
│   └── build-iso.yml         # Compilación automática en la nube con GitHub Actions
├── archiso/
│   ├── profiledef.sh         # Metadatos de la ISO (versión, compresión zstd, permisos)
│   ├── packages.x86_64       # Lista exhaustiva de paquetes preinstalados
│   ├── pacman.conf           # Repositorios y soporte multilib
│   └── airootfs/             # Sistema de archivos integrado (os-release, sysctl, scripts)
├── calamares/                # Configuración del instalador gráfico
├── build.sh                  # Script de compilación local
└── README.md
```

---

## 🔨 ¿Cómo Compilar la ISO de Binario Linux?

Tienes dos formas de generar el archivo `.iso`:

### Opción A: Compilación Automática en GitHub (Recomendada)
1. Sube este repositorio a tu cuenta de GitHub:
   ```bash
   git init
   git add .
   git commit -m "Inicializar Binario Linux (Gaming & Security OS)"
   git branch -M main
   git remote add origin https://github.com/carlosmundaray/binario.git
   git push -u origin main
   ```
2. Ve a la pestaña **Actions** en tu repositorio: [https://github.com/carlosmundaray/binario/actions](https://github.com/carlosmundaray/binario/actions)
3. El workflow `Build Binario Linux ISO` compilará la ISO en los servidores de GitHub y te permitirá descargar el archivo `.iso` y su suma `SHA256` terminada.

### Opción B: Compilación Local (Arch Linux, WSL2 o Docker)
Si cuentas con un entorno Arch Linux o ArchWSL:

```bash
# 1. Clonar el repositorio
git clone https://github.com/carlosmundaray/binario.git
cd binario

# 2. Dar permisos de ejecución y compilar
sudo ./build.sh
```

La ISO resultante se generará en la carpeta `out/`.

---

## 📄 Licencia y Créditos
- Basado en el ecosistema libre de **Arch Linux** y el proyecto **Archiso**.
