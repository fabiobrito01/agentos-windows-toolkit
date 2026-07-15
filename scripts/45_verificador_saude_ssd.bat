@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo VERIFICADOR DE SAUDE DO SSD/HD (SMART)
echo ====================================================

wmic diskdrive get model,status

echo ====================================================
echo Se o status for diferente de "OK", faca backup imediato.
echo ====================================================
pause
