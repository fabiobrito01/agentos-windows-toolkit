@echo off
setlocal enabledelayedexpansion
set "HOSTS=%windir%\System32\drivers\etc\hosts"

echo ====================================================
echo MODO FOCO - Bloqueador de Distracoes
echo ====================================================
echo ATENCAO: requer execucao como Administrador.
echo Edite a lista SITES abaixo no arquivo antes de usar.
echo ----------------------------------------------------
echo 1. Bloquear sites
echo 2. Instrucoes para desbloquear
set /p OPC=Escolha:

if "%OPC%"=="1" (
    echo. >> "%HOSTS%"
    echo # === MODO FOCO INICIO === >> "%HOSTS%"
    echo 127.0.0.1 www.facebook.com >> "%HOSTS%"
    echo 127.0.0.1 facebook.com >> "%HOSTS%"
    echo 127.0.0.1 www.instagram.com >> "%HOSTS%"
    echo 127.0.0.1 instagram.com >> "%HOSTS%"
    echo 127.0.0.1 www.youtube.com >> "%HOSTS%"
    echo 127.0.0.1 youtube.com >> "%HOSTS%"
    echo 127.0.0.1 www.tiktok.com >> "%HOSTS%"
    echo # === MODO FOCO FIM === >> "%HOSTS%"
    ipconfig /flushdns >nul
    echo Sites bloqueados. Reinicie o navegador.
) else (
    echo Para desbloquear: abra o arquivo abaixo como Administrador no Bloco de Notas
    echo %HOSTS%
    echo E apague as linhas entre "MODO FOCO INICIO" e "MODO FOCO FIM"
)
echo ====================================================
pause
