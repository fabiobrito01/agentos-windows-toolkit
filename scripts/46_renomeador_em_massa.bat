@echo off
setlocal enabledelayedexpansion
set "PASTA_ALVO=%~1"
if not defined PASTA_ALVO set /p "PASTA_ALVO=Pasta alvo: "
set "PREFIXO=foto_"

echo ====================================================
echo RENOMEADOR DE ARQUIVOS EM MASSA
echo ====================================================
set /a CONT=1

for %%F in ("%PASTA_ALVO%\*.*") do (
    set "NUM=00!CONT!"
    set "NUM=!NUM:~-2!"
    ren "%%F" "%PREFIXO%!NUM!%%~xF"
    set /a CONT+=1
)

echo Renomeacao concluida.
echo ====================================================
pause
