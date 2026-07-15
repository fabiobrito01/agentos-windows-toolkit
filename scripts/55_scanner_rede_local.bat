@echo off
setlocal enabledelayedexpansion
set "PREFIXO_REDE=%~1"
if not defined PREFIXO_REDE set /p "PREFIXO_REDE=Prefixo da rede (ex.: 192.168.1.): "

echo ====================================================
echo SCANNER DE IP DA REDE LOCAL
echo Quem esta no meu Wi-Fi?
echo ====================================================

for /L %%i in (1,1,254) do (
    ping -n 1 -w 100 %PREFIXO_REDE%%%i | findstr "TTL=" >nul
    if not errorlevel 1 echo Ativo: %PREFIXO_REDE%%%i
)

echo ----------------------------------------------------
echo Tabela ARP (enderecos MAC):
arp -a
echo ====================================================
pause
