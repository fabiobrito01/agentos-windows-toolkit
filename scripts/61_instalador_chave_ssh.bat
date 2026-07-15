@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo INSTALADOR AUTOMATICO DE CHAVE SSH
echo ====================================================

set /p SERVIDOR=Usuario@IP do servidor (ex: root@192.168.1.10):
set "CHAVE_PUB=%USERPROFILE%\.ssh\id_rsa.pub"

if not exist "%CHAVE_PUB%" (
    echo Chave publica nao encontrada em %CHAVE_PUB%
    echo Gere uma com: ssh-keygen -t rsa
    pause
    exit /b
)

type "%CHAVE_PUB%" | ssh %SERVIDOR% "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

echo Chave SSH instalada no servidor remoto.
echo ====================================================
pause
