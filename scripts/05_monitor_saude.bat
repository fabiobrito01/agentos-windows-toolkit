@echo off
setlocal enabledelayedexpansion
set "LOG_DIR=%~1"
if not defined LOG_DIR set "LOG_DIR=%USERPROFILE%\Documents\RelatoriosSaude"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set DT=%%I
set TIMESTAMP=%DT:~0,8%_%DT:~8,6%
set "LOG_FILE=%LOG_DIR%\saude_%TIMESTAMP%.txt"

echo ====================================================  > "%LOG_FILE%"
echo RELATORIO DE SAUDE DO SISTEMA - %DATE% %TIME%        >> "%LOG_FILE%"
echo ====================================================  >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"
echo --- CPU E MEMORIA --- >> "%LOG_FILE%"
wmic cpu get loadpercentage /value >> "%LOG_FILE%"
wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /value >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"
echo --- TOP PROCESSOS POR MEMORIA --- >> "%LOG_FILE%"
tasklist /fo table | sort /r >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"
echo --- CONEXOES DE REDE ATIVAS --- >> "%LOG_FILE%"
netstat -n >> "%LOG_FILE%"

echo Relatorio salvo em: %LOG_FILE%
notepad "%LOG_FILE%"
pause
