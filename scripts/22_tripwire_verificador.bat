@echo off
setlocal enabledelayedexpansion
set "ALVO=%CD%\config\secrets.local.json"
set "LOG_HASH=%CD%\config\.hash_baseline.txt"

echo ====================================================
echo VERIFICADOR DE INTEGRIDADE (TRIPWIRE)
echo ====================================================

if not exist "%ALVO%" (
    echo Arquivo alvo nao encontrado: %ALVO%
    pause
    exit /b
)

if not exist "%LOG_HASH%" (
    certutil -hashfile "%ALVO%" MD5 | findstr /v "hash" > "%LOG_HASH%"
    echo Assinatura base criada em: %LOG_HASH%
    pause
    exit /b
)

certutil -hashfile "%ALVO%" MD5 | findstr /v "hash" > _hash_atual.txt
fc "%LOG_HASH%" _hash_atual.txt >nul
if errorlevel 1 (
    echo [ALERTA] O arquivo foi modificado desde a ultima verificacao!
) else (
    echo Arquivo integro. Nenhuma alteracao detectada.
)
del _hash_atual.txt >nul 2>&1
echo ====================================================
pause
