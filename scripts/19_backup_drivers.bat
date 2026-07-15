@echo off
setlocal enabledelayedexpansion
set "DRIVER_BACKUP=%~1"
if not defined DRIVER_BACKUP set "DRIVER_BACKUP=%USERPROFILE%\Documents\Backups\Drivers"

if not exist "%DRIVER_BACKUP%" mkdir "%DRIVER_BACKUP%"

echo ====================================================
echo BACKUP DE DRIVERS DO WINDOWS
echo Requer execucao como Administrador
echo ====================================================

dism /online /export-driver /destination:"%DRIVER_BACKUP%"

echo Backup de drivers concluido em: %DRIVER_BACKUP%
echo ====================================================
pause
