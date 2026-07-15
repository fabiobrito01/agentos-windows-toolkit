@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo LIMPADOR ABSOLUTO DE CACHE DO DOCKER
echo ====================================================

docker system prune -a --volumes -f

echo Limpeza do Docker concluida.
echo ====================================================
pause
