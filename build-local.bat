@echo off
title Compilador Local de ISO - Binario Linux
echo ==========================================================
echo        COMPILADOR LOCAL DE ISO - BINARIO LINUX
echo ==========================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build-local.ps1"
echo.
echo Presiona cualquier tecla para salir...
pause >nul
