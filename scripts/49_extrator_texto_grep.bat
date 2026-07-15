@echo off
setlocal enabledelayedexpansion
set "PASTA_BUSCA=%~1"
if not defined PASTA_BUSCA set /p "PASTA_BUSCA=Pasta para busca: "

echo ====================================================
echo EXTRATOR DE TEXTO (GREP SIMPLES)
echo ====================================================
set /p TERMO=Termo a buscar:

findstr /S /I /C:"%TERMO%" "%PASTA_BUSCA%\*.*"

echo ====================================================
pause
