@echo off
setlocal enabledelayedexpansion
set "SERVIDORES=google.com github.com firebase.google.com cloudflare.com"

echo ====================================================
echo TESTE DE LATENCIA EM MASSA
echo ====================================================

for %%S in (%SERVIDORES%) do (
    echo Testando %%S ...
    ping -n 1 %%S | findstr "tempo="
    echo ----------------------------------------------------
)

echo Teste concluido.
echo ====================================================
pause
