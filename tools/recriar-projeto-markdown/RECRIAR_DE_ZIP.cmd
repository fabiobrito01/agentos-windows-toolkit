@echo off
setlocal
chcp 65001 >nul
title Recriar Projeto de um ZIP Markdown
set "SCRIPT=%~dp0RECRIAR_PROJETO_DE_MARKDOWN.ps1"
if not exist "%SCRIPT%" (echo ERRO: script principal nao encontrado.& pause & exit /b 1)
echo ETAPA 1 - FONTE: selecione o ZIP que contem os Markdown.
echo ETAPA 2 - DESTINO: selecione uma pasta nova ou vazia.
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" -SelecionarZip -AbrirDestino
set "RC=%ERRORLEVEL%"
echo.
if "%RC%"=="0" (echo Projeto recriado com sucesso.) else if "%RC%"=="2" (echo Concluido com avisos. Consulte o relatorio.) else if "%RC%"=="3" (echo Operacao cancelada.) else (echo Falha na recriacao.)
pause
exit /b %RC%
