@echo off
setlocal enabledelayedexpansion
title AgentOS - Preparar Arquivos para Celular

set "ORIGEM=%~1"
set "PASTA_TEMP=%~2"
if not defined ORIGEM set /p "ORIGEM=Pasta em que deseja pesquisar: "
if not defined PASTA_TEMP set "PASTA_TEMP=%TEMP%\AgentOS_Coleta_Celular"
if not exist "%ORIGEM%\" (echo [ERRO] Origem invalida.& pause& exit /b 1)
set /p "TERMO=Parte do nome do arquivo: "
if not defined TERMO (echo Operacao cancelada.& pause& exit /b 2)

if exist "%PASTA_TEMP%" (
  echo A pasta temporaria existente sera limpa: "%PASTA_TEMP%"
  set /p "CONFIRMA=Digite LIMPAR para continuar: "
  if /I not "!CONFIRMA!"=="LIMPAR" (echo Operacao cancelada.& pause& exit /b 2)
  rmdir /s /q "%PASTA_TEMP%"
)
mkdir "%PASTA_TEMP%"

set /a CONTADOR=0
for /R "%ORIGEM%" %%F in (*%TERMO%*) do if exist "%%~fF" (
  copy /Y "%%~fF" "%PASTA_TEMP%\" >nul && set /a CONTADOR+=1
)
echo [OK] !CONTADOR! arquivo(s) preparados.
start "" "%PASTA_TEMP%"
start "" "shell:MyComputerFolder"
pause
