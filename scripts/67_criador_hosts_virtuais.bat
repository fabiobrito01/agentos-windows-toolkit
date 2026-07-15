@echo off
setlocal enabledelayedexpansion
set "HOSTS=%windir%\System32\drivers\etc\hosts"

echo ====================================================
echo CRIADOR DE HOSTS VIRTUAIS LOCAIS
echo Requer execucao como Administrador
echo ====================================================

set /p DOMINIO=Dominio local (ex: meu-app.local):
set /p PASTA=Caminho da pasta publica do projeto:

echo 127.0.0.1 %DOMINIO% >> "%HOSTS%"
ipconfig /flushdns >nul

echo Dominio %DOMINIO% criado apontando para 127.0.0.1
echo Configure seu servidor (Apache/Nginx) para servir %PASTA% nesse dominio.
echo ====================================================
pause
