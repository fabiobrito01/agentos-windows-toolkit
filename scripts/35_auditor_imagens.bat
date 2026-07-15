@echo off
setlocal enabledelayedexpansion
set "IMG_DIR=%~1"
if not defined IMG_DIR set "IMG_DIR=%CD%\assets\images"

echo ====================================================
echo AUDITOR DE ATIVOS - IMAGENS PESADAS
echo ====================================================
echo Escaneando: %IMG_DIR%
echo ----------------------------------------------------

for %%F in ("%IMG_DIR%\*.png" "%IMG_DIR%\*.jpg" "%IMG_DIR%\*.jpeg") do (
    if exist "%%F" (
        set /a KB=%%~zF/1024
        if !KB! GTR 500 (
            echo [PESADO] %%F - !KB! KB
        )
    )
)

echo ----------------------------------------------------
echo Auditoria concluida.
echo ====================================================
pause
