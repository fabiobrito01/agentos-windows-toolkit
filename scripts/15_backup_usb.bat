@echo off
setlocal enabledelayedexpansion
set "DISPOSITIVO=%~1"
set "DESTINO_BACKUP=%~2"
if not defined DISPOSITIVO set /p "DISPOSITIVO=Unidade ou pasta de origem: "
if not defined DESTINO_BACKUP set "DESTINO_BACKUP=%USERPROFILE%\Documents\Backups\PenDrive"

if not exist "%DISPOSITIVO%" (
    echo Dispositivo %DISPOSITIVO% nao encontrado. Conecte o Pen Drive e tente novamente.
    pause
    exit /b
)

if not exist "%DESTINO_BACKUP%" mkdir "%DESTINO_BACKUP%"

echo ====================================================
echo BACKUP INCREMENTAL DE PEN DRIVE
echo ====================================================
echo Origem:  %DISPOSITIVO%
echo Destino: %DESTINO_BACKUP%
echo ----------------------------------------------------

robocopy "%DISPOSITIVO%" "%DESTINO_BACKUP%" /E /XO

echo ----------------------------------------------------
echo Backup concluido.
echo ====================================================
pause
