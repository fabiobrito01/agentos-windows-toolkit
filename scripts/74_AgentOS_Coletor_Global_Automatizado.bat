@echo off
setlocal enabledelayedexpansion
title AgentOS - Buscador e Coletor de Arquivos

set "ORIGEM=%~1"
set "DESTINO=%~2"
if not defined ORIGEM set /p "ORIGEM=Pasta em que deseja pesquisar: "
if not defined DESTINO set /p "DESTINO=Pasta para receber copias: "
if not exist "%ORIGEM%\" (echo [ERRO] Origem invalida.& pause& exit /b 1)
if not defined DESTINO (echo [ERRO] Destino nao informado.& pause& exit /b 1)

set /p "TERMO=Parte do nome do arquivo: "
if not defined TERMO (echo Operacao cancelada.& pause& exit /b 2)
if /I "%ORIGEM%"=="%DESTINO%" (echo [ERRO] Origem e destino devem ser diferentes.& pause& exit /b 1)

echo Serao copiados arquivos de "%ORIGEM%" para "%DESTINO%".
set /p "CONFIRMA=Digite COLETAR para continuar: "
if /I not "%CONFIRMA%"=="COLETAR" (echo Operacao cancelada.& pause& exit /b 2)
if not exist "%DESTINO%" mkdir "%DESTINO%"

set /a CONTADOR=0
for /R "%ORIGEM%" %%F in (*%TERMO%*) do if exist "%%~fF" (
  copy /Y "%%~fF" "%DESTINO%\" >nul && set /a CONTADOR+=1
)
echo [OK] !CONTADOR! arquivo(s) copiado(s) para "%DESTINO%".
pause
