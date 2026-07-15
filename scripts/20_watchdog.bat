@echo off
setlocal enabledelayedexpansion
set "PROCESSO=code.exe"
set "CAMINHO_APP=code"

echo ====================================================
echo WATCHDOG - Reiniciador de Apps Travados
echo Monitorando: %PROCESSO%
echo Pressione CTRL+C para encerrar
echo ====================================================

:LOOP
tasklist /FI "IMAGENAME eq %PROCESSO%" 2>nul | find /I /N "%PROCESSO%">nul
if "%ERRORLEVEL%"=="1" (
    echo [%TIME%] %PROCESSO% nao esta rodando. Reiniciando...
    start "" "%CAMINHO_APP%"
) else (
    echo [%TIME%] %PROCESSO% OK
)
timeout /t 30 >nul
goto LOOP
