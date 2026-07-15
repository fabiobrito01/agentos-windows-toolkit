@echo off
setlocal enabledelayedexpansion
set "UNIDADE=D:"
set "ARQUIVO_TESTE=%UNIDADE%\teste_benchmark.tmp"
set "TAMANHO=104857600"

echo ====================================================
echo MEDIDOR DE VELOCIDADE DE DISCO
echo ====================================================

echo Testando escrita...
set START=%TIME%
fsutil file createnew "%ARQUIVO_TESTE%" %TAMANHO%
set END=%TIME%

echo Arquivo de teste de 100MB criado.
echo Inicio: %START%  Fim: %END%

del "%ARQUIVO_TESTE%" >nul 2>&1
echo ====================================================
echo Para benchmark preciso, use CrystalDiskMark.
echo ====================================================
pause
