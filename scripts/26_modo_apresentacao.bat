@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo MODO APRESENTACAO / FOCO VISUAL EXTREMO
echo ====================================================
echo 1. Ocultar barra de tarefas e icones
echo 2. Restaurar area de trabalho
set /p OPC=Escolha:

if "%OPC%"=="1" (
    taskkill /F /IM explorer.exe
    echo Interface oculta. Use ALT+TAB para alternar janelas.
)

if "%OPC%"=="2" (
    start explorer.exe
    echo Interface restaurada.
)
echo ====================================================
pause
