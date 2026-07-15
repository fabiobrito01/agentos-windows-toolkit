@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo KILL SWITCH - Liberar memoria RAM
echo ====================================================

REM Adicione ou remova processos conforme necessario
taskkill /F /IM chrome.exe >nul 2>&1
taskkill /F /IM spotify.exe >nul 2>&1
taskkill /F /IM discord.exe >nul 2>&1
taskkill /F /IM steam.exe >nul 2>&1

echo Processos pesados finalizados.
echo ====================================================
pause
