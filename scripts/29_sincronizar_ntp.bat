@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo SINCRONIZADOR DE HORARIO (NTP)
echo Requer execucao como Administrador
echo ====================================================

w32tm /config /manualpeerlist:"a.ntp.br,b.ntp.br,c.ntp.br" /syncfromflags:manual /reliable:yes /update
net stop w32time
net start w32time
w32tm /resync /force

echo Relogio sincronizado com servidores NTP.br
echo ====================================================
pause
