@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo CRIADOR DE PONTO DE RESTAURACAO
echo Requer execucao como Administrador
echo ====================================================
set /p DESC=Descricao do ponto de restauracao:

wmic /namespace:\\root\default path SystemRestore call CreateRestorePoint "%DESC%", 100, 7

echo Ponto de restauracao criado.
echo ====================================================
pause
