@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo MODO CAFEINA (ANTI-SONO)
echo ====================================================
echo 1. Ativar (nunca desligar tela/suspender)
echo 2. Desativar (restaurar padrao)
set /p OPC=Escolha:

if "%OPC%"=="1" (
    powercfg /change monitor-timeout-ac 0
    powercfg /change standby-timeout-ac 0
    echo Modo Cafeina ATIVADO. O PC nao vai dormir.
)

if "%OPC%"=="2" (
    powercfg /change monitor-timeout-ac 20
    powercfg /change standby-timeout-ac 30
    echo Modo Cafeina DESATIVADO. Padroes restaurados.
)
echo ====================================================
pause
