@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo ALTERNADOR DE PERFIS DE ENERGIA
echo ====================================================
echo 1. Alto desempenho
echo 2. Economia de energia
echo 3. Equilibrado
set /p OPC=Escolha:

if "%OPC%"=="1" powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
if "%OPC%"=="2" powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a
if "%OPC%"=="3" powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e

echo Perfil de energia alterado.
echo ====================================================
pause
