@echo off
setlocal enabledelayedexpansion
set "ORIGEM=%~1"
if not defined ORIGEM set /p "ORIGEM=Pasta de origem: "
set "DESTINO=%~2"
if not defined DESTINO set "DESTINO=%USERPROFILE%\Documents\Backups\Zips"

if not exist "%DESTINO%" mkdir "%DESTINO%"

echo ====================================================
echo COMPACTADOR DE BACKUPS EM LOTE
echo ====================================================

for /D %%F in ("%ORIGEM%\*") do (
    echo Compactando %%~nxF ...
    powershell -command "Compress-Archive -Path '%%F' -DestinationPath '%DESTINO%\%%~nxF.zip' -Force"
)

echo Compactacao concluida em: %DESTINO%
echo ====================================================
pause
