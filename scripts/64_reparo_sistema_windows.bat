@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo VERIFICADOR DE INTEGRIDADE DO SISTEMA
echo Requer execucao como Administrador
echo Este processo pode demorar varios minutos.
echo ====================================================

DISM /Online /Cleanup-Image /RestoreHealth
sfc /scannow

echo Verificacao e reparo concluidos.
echo ====================================================
pause
