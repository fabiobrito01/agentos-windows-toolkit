@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo CRIADOR DE LINKS SIMBOLICOS
echo Requer execucao como Administrador
echo ====================================================

set /p LINK=Caminho do link virtual (ex: C:\CacheLink):
set /p DESTINO=Caminho real dos dados (ex: D:\Cache):

mklink /D "%LINK%" "%DESTINO%"

echo Link simbolico criado.
echo ====================================================
pause
