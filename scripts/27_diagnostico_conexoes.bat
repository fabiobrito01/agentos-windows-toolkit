@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo DIAGNOSTICADOR DE CONEXOES OCULTAS
echo Requer execucao como Administrador
echo ====================================================

netstat -b -n | findstr /V "127.0.0.1"

echo ====================================================
pause
