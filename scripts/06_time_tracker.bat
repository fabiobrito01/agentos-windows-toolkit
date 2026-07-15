@echo off
setlocal enabledelayedexpansion
set "TRACKER_LOG=%~1"
if not defined TRACKER_LOG set "TRACKER_LOG=%USERPROFILE%\Documents\time_tracker.csv"

if not exist "%TRACKER_LOG%" (
    echo Data,Hora,Acao > "%TRACKER_LOG%"
)

echo ====================================================
echo TIME TRACKER DE PROJETOS
echo ====================================================
echo 1. Iniciar sessao de trabalho
echo 2. Finalizar/pausar sessao
set /p OPC=Escolha:

if "%OPC%"=="1" (
    echo %DATE%,%TIME%,INICIO >> "%TRACKER_LOG%"
    echo Sessao iniciada e registrada.
)
if "%OPC%"=="2" (
    echo %DATE%,%TIME%,FIM >> "%TRACKER_LOG%"
    echo Sessao finalizada e registrada.
)
echo Arquivo: %TRACKER_LOG%
echo ====================================================
pause
