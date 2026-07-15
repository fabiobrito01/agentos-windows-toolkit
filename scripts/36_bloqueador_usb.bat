@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo BLOQUEADOR DE PORTAS USB
echo Requer execucao como Administrador
echo ====================================================
echo 1. Bloquear novos dispositivos USB de armazenamento
echo 2. Restaurar funcionamento padrao
set /p OPC=Escolha:

if "%OPC%"=="1" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 4 /f
    echo Portas USB de armazenamento BLOQUEADAS.
)

if "%OPC%"=="2" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR" /v Start /t REG_DWORD /d 3 /f
    echo Portas USB de armazenamento RESTAURADAS.
)
echo ====================================================
pause
