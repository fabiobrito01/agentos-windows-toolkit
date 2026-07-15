@echo off
setlocal enabledelayedexpansion
set "PASTA_RAIZ=%~1"
if not defined PASTA_RAIZ set /p "PASTA_RAIZ=Pasta raiz: "

echo ====================================================
echo DELETADOR DE PASTAS VAZIAS RECURSIVO
echo ====================================================

for /F "delims=" %%D in ('dir "%PASTA_RAIZ%" /ad /b /s ^| sort /r') do (
    rd "%%D" 2>nul
)

echo Pastas vazias removidas.
echo ====================================================
pause
