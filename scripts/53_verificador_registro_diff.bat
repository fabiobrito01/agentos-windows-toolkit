@echo off
setlocal enabledelayedexpansion
set "CHAVE=HKEY_LOCAL_MACHINE\Software"
set "SNAPSHOT_DIR=%temp%\reg_snapshots"

if not exist "%SNAPSHOT_DIR%" mkdir "%SNAPSHOT_DIR%"

echo ====================================================
echo VERIFICADOR DE ALTERACOES NO REGISTRO
echo ====================================================
echo 1. Tirar snapshot ANTES de instalar
echo 2. Comparar APOS instalar
set /p OPC=Escolha:

if "%OPC%"=="1" (
    reg export "%CHAVE%" "%SNAPSHOT_DIR%\before.reg" /y
    echo Snapshot salvo. Agora instale o programa e rode a opcao 2.
)

if "%OPC%"=="2" (
    reg export "%CHAVE%" "%SNAPSHOT_DIR%\after.reg" /y
    fc "%SNAPSHOT_DIR%\before.reg" "%SNAPSHOT_DIR%\after.reg"
)
echo ====================================================
pause
