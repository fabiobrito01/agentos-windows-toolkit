@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo INICIADOR DE AMBIENTE DE TRABALHO
echo ====================================================

set "PROJECT_DIR=%~1"
if not defined PROJECT_DIR set "PROJECT_DIR=%CD%"
where code >nul 2>&1 && start "" code "%PROJECT_DIR%"
start "" "https://github.com"
start "" cmd /k "cd /d "%PROJECT_DIR%""

echo Ambiente inicializado.
echo ====================================================
