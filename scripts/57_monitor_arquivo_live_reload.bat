@echo off
setlocal enabledelayedexpansion
set "ARQUIVO_ALVO=%~1"
if not defined ARQUIVO_ALVO set /p "ARQUIVO_ALVO=Arquivo a monitorar: "
set "COMANDO=echo Arquivo alterado, rode seu build aqui"

echo ====================================================
echo MONITOR DE ARQUIVOS MODIFICADOS (LIVE RELOAD)
echo Pressione CTRL+C para encerrar
echo ====================================================

set "ULTIMO=%%~tF"
for %%F in ("%ARQUIVO_ALVO%") do set "ULTIMO=%%~tF"

:LOOP
for %%F in ("%ARQUIVO_ALVO%") do set "ATUAL=%%~tF"
if not "!ATUAL!"=="!ULTIMO!" (
    echo [%TIME%] Arquivo modificado! Executando comando...
    %COMANDO%
    set "ULTIMO=!ATUAL!"
)
timeout /t 1 >nul
goto LOOP
