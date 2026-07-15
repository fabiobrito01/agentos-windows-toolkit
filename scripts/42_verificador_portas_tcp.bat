@echo off
setlocal enabledelayedexpansion
set "PORTAS=8080 3306 5432 27017 3000 5000"

echo ====================================================
echo VERIFICADOR DE PORTAS TCP LOCAIS
echo ====================================================

for %%P in (%PORTAS%) do (
    echo Verificando porta %%P...
    netstat -ano | findstr ":%%P "
)

echo ====================================================
pause
