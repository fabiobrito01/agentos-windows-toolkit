@echo off
setlocal enabledelayedexpansion
set "BASE_DIR=%~1"
if not defined BASE_DIR set "BASE_DIR=%USERPROFILE%\Documents\Projetos"

echo ====================================================
echo CRIADOR DE ESTRUTURA DE PASTAS PADRAO
echo ====================================================
set /p NOME=Nome do novo projeto:

set "DEST=%BASE_DIR%\%NOME%"

mkdir "%DEST%"
mkdir "%DEST%\src"
mkdir "%DEST%\docs"
mkdir "%DEST%\tests"
mkdir "%DEST%\assets"
mkdir "%DEST%\config"
mkdir "%DEST%\scripts"

echo Estrutura criada em: %DEST%
echo ====================================================
pause
