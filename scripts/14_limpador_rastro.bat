@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo LIMPADOR DE RASTRO - Privacidade
echo Recomendado executar como Administrador
echo ====================================================

echo Limpando arquivos temporarios...
del /s /f /q "%temp%\*.*" >nul 2>&1
del /s /f /q "%windir%\Temp\*.*" >nul 2>&1

echo Esvaziando a lixeira...
rd /s /q "%systemdrive%\$Recycle.Bin" >nul 2>&1

echo Limpeza concluida.
echo ====================================================
pause
