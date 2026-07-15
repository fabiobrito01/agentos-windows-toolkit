@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo CONVERSOR DOS PARA UNIX (CRLF para LF)
echo ====================================================

set /p ARQUIVO=Caminho do arquivo a converter:

powershell -command "(Get-Content '%ARQUIVO%' -Raw) -replace \"`r`n\", \"`n\" | Set-Content '%ARQUIVO%' -NoNewline"

echo Arquivo convertido para terminacao de linha UNIX (LF).
echo ====================================================
pause
