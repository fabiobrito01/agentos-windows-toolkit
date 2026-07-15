@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo TIMER / DESPERTADOR DO TERMINAL
echo ====================================================
set /p MIN=Minutos:
set /a SEGUNDOS=!MIN!*60

for /l %%i in (%SEGUNDOS%,-1,1) do (
    cls
    set /a M=%%i/60
    set /a S=%%i%%60
    echo ====================================================
    echo TEMPO RESTANTE: !M! min !S! seg
    echo ====================================================
    timeout /t 1 >nul
)

cls
echo ====================================================
echo TEMPO ESGOTADO!
echo ====================================================
echo
pause
