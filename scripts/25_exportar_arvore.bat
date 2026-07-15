@echo off
setlocal enabledelayedexpansion
set "ALVO_DIR=%~1"
if not defined ALVO_DIR set /p "ALVO_DIR=Pasta a mapear: "

echo ====================================================
echo EXPORTADOR DE ARVORE DE DIRETORIOS
echo ====================================================
echo Mapeando: %ALVO_DIR%

tree "%ALVO_DIR%" /A /F | clip

echo Estrutura copiada para a area de transferencia.
echo Cole com Ctrl+V no seu editor ou Markdown.
echo ====================================================
pause
