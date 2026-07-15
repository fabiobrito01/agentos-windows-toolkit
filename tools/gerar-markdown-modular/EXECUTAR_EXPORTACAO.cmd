@echo off
setlocal
chcp 65001 >nul
title Gerar Markdown Modular Robusto

set "SCRIPT=%~dp0GERAR_MARKDOWN_MODULAR_ROBUSTO.ps1"
if not exist "%SCRIPT%" (
  echo ERRO: o arquivo GERAR_MARKDOWN_MODULAR_ROBUSTO.ps1 nao esta junto deste executavel.
  echo Mantenha todos os arquivos do pacote na mesma pasta.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo       GERADOR DE MARKDOWN MODULAR ROBUSTO - PORTATIL
echo ============================================================
echo.
echo Uma janela sera aberta para escolher a pasta do projeto.
echo A exportacao sera criada em Exportacao_IA dentro do projeto.
echo Arquivos sensiveis, caches e builds serao ignorados.
echo.

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" -SelecionarPasta -LimparSaida -AbrirSaida
set "RESULTADO=%ERRORLEVEL%"

echo.
if "%RESULTADO%"=="0" (
  echo SUCESSO: exportacao concluida. A pasta de saida foi aberta.
) else if "%RESULTADO%"=="2" (
  echo ATENCAO: exportacao concluida com avisos. Consulte exportacao.log.
) else if "%RESULTADO%"=="3" (
  echo Operacao cancelada. Nenhum projeto foi alterado.
) else (
  echo ERRO: a exportacao falhou. Leia a mensagem acima.
)
echo.
pause
exit /b %RESULTADO%
