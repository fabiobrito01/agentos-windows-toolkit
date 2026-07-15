@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo LIMPADOR DE MEMORIA STANDBY
echo ====================================================
echo Requer RAMMap.exe (Sysinternals) na mesma pasta deste script.

if not exist "RAMMap.exe" (
    echo RAMMap.exe nao encontrado. Baixe em: https://learn.microsoft.com/sysinternals/downloads/rammap
    pause
    exit /b
)

RAMMap.exe -Ew

echo Memoria standby limpa.
echo ====================================================
pause
