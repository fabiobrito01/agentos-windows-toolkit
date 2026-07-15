@echo off
setlocal enabledelayedexpansion
set "CACHE_FILE=%temp%\ip_cache.txt"

echo ====================================================
echo MONITOR DE IP PUBLICO
echo ====================================================

curl -s https://api.ipify.org > _ip_atual.txt
set /p IP_ATUAL=<_ip_atual.txt

if not exist "%CACHE_FILE%" (
    copy _ip_atual.txt "%CACHE_FILE%" >nul
    echo Primeira execucao. IP registrado: %IP_ATUAL%
) else (
    set /p IP_ANTERIOR=<"%CACHE_FILE%"
    if "!IP_ATUAL!"=="!IP_ANTERIOR!" (
        echo IP nao mudou: %IP_ATUAL%
    ) else (
        echo [ALERTA] IP mudou de !IP_ANTERIOR! para !IP_ATUAL!
        copy _ip_atual.txt "%CACHE_FILE%" >nul
    )
)
del _ip_atual.txt >nul 2>&1
echo ====================================================
pause
