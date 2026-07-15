@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo INSTALACAO EM MASSA (WINGET)
echo ====================================================

REM Ajuste a lista de IDs conforme suas necessidades
winget install --id Git.Git -e --silent
winget install --id Microsoft.VisualStudioCode -e --silent
winget install --id Google.Chrome -e --silent
winget install --id 7zip.7zip -e --silent

echo Instalacao em massa concluida.
echo ====================================================
pause
