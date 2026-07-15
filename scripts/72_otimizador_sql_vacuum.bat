@echo off
setlocal enabledelayedexpansion
set "BANCO=%~1"
if not defined BANCO set /p "BANCO=Arquivo SQLite: "

if not exist "sqlite3.exe" (
    echo sqlite3.exe nao encontrado. Baixe em: https://sqlite.org/download.html
    pause
    exit /b
)

echo ====================================================
echo OTIMIZADOR DE TABELAS SQL (VACUUM)
echo ====================================================

sqlite3.exe "%BANCO%" "VACUUM;"

echo Banco de dados otimizado.
echo ====================================================
pause
