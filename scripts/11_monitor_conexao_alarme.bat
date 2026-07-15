@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo MONITOR DE CONEXAO CONTINUA
echo Pressione CTRL+C para encerrar
echo ====================================================

:LOOP
ping -n 1 8.8.8.8 >nul
if errorlevel 1 (
    color 4F
    echo [%TIME%] CONEXAO CAIU!
) else (
    color 2F
    echo [%TIME%] Conexao OK
)
timeout /t 3 >nul
goto LOOP
