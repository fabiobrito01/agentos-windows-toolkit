@echo off
setlocal enabledelayedexpansion
set "COMPOSE_DIR=%~1"
if not defined COMPOSE_DIR set /p "COMPOSE_DIR=Pasta do docker-compose: "

echo ====================================================
echo AUTOMACAO DE INICIALIZACAO DE CONTAINERS
echo ====================================================

cd /d "%COMPOSE_DIR%"
docker-compose up -d

echo Containers iniciados.
echo ====================================================
pause
