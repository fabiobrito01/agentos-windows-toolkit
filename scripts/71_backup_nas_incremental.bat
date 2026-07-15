@echo off
setlocal enabledelayedexpansion
set "ORIGEM=%~1"
if not defined ORIGEM set /p "ORIGEM=Pasta de origem: "
set "DESTINO_NAS=%~2"
if not defined DESTINO_NAS set /p "DESTINO_NAS=Destino de rede (ex.: \\servidor\backup): "
if not defined DESTINO_NAS (echo [ERRO] Destino nao informado.& pause& exit /b 1)

echo ====================================================
echo COPIADOR INCREMENTAL ESPELHADO VIA REDE (NAS)
echo ====================================================
echo Origem:  %ORIGEM%
echo Destino: %DESTINO_NAS%
echo ----------------------------------------------------

robocopy "%ORIGEM%" "%DESTINO_NAS%" /E /Z /COPYALL /R:3 /W:5

echo ----------------------------------------------------
echo Backup incremental concluido.
echo ====================================================
pause
