@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo DIAGNOSTICO DE INTERNET E ROTAS
echo ====================================================
echo Testando conexao com 8.8.8.8 (Google DNS)...
ping -n 4 8.8.8.8

echo.
echo Se a conexao falhou, aplicando correcoes...
echo Limpando cache DNS...
ipconfig /flushdns
echo Liberando IP atual...
ipconfig /release
echo Renovando IP via DHCP...
ipconfig /renew

echo ----------------------------------------------------
echo Testando novamente apos correcao...
ping -n 4 8.8.8.8
echo ====================================================
pause
