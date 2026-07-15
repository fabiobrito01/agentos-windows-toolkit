@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo DESLIGAMENTO AGENDADO INTELIGENTE
echo ====================================================
echo 1. Agendar desligamento
echo 2. Cancelar desligamento agendado
set /p OPC=Escolha:

if "%OPC%"=="1" (
    set /p MIN=Minutos para desligar:
    set /a SEGUNDOS=!MIN!*60
    shutdown /s /t !SEGUNDOS!
    echo Desligamento agendado para !MIN! minutos.
)

if "%OPC%"=="2" (
    shutdown /a
    echo Desligamento cancelado.
)
echo ====================================================
pause
