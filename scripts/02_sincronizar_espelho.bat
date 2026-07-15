@echo off
setlocal enabledelayedexpansion
set "ORIGEM=%~1"
set "DESTINO_REPLICADO=%~2"
if not defined ORIGEM set /p "ORIGEM=Pasta de origem: "
if not defined DESTINO_REPLICADO set /p "DESTINO_REPLICADO=Pasta de destino: "
if not exist "%ORIGEM%\" (echo [ERRO] Origem invalida.& pause& exit /b 1)
if not defined DESTINO_REPLICADO (echo [ERRO] Destino nao informado.& pause& exit /b 1)
echo ====================================================
echo Sincronizando Espelhamento Total
echo ====================================================
echo Atualizando: %DESTINO_REPLICADO%
echo ----------------------------------------------------
echo ATENCAO: /MIR remove no destino arquivos que nao existem na origem.
set /p "CONFIRMA=Digite ESPELHAR para continuar: "
if /I not "%CONFIRMA%"=="ESPELHAR" (echo Operacao cancelada.& pause& exit /b 2)
robocopy "%ORIGEM%" "%DESTINO_REPLICADO%" /MIR /MT:8 /R:2 /W:2 /XD build .git .dart_tool .idea
echo ----------------------------------------------------
echo Sincronizacao concluida!
echo ====================================================
pause
