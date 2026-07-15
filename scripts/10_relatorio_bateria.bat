@echo off
setlocal enabledelayedexpansion
set "OUTPUT_DIR=%~1"
if not defined OUTPUT_DIR set "OUTPUT_DIR=%USERPROFILE%\Documents\RelatoriosBateria"
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

set "REPORT=%OUTPUT_DIR%\battery_report.html"
echo Gerando relatorio de bateria...
powercfg /batteryreport /output "%REPORT%"
echo Relatorio salvo em: %REPORT%
start "" "%REPORT%"
pause
