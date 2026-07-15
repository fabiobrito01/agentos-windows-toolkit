@echo off
setlocal enabledelayedexpansion
set "PROJECT_DIR=%~1"
if not defined PROJECT_DIR set /p "PROJECT_DIR=Pasta do projeto: "

cd /d "%PROJECT_DIR%"

echo ====================================================
echo COMMITER AUTO-GIT
echo ====================================================
git status
echo ----------------------------------------------------
set /p MSG=Mensagem do commit:

git add .
git commit -m "%MSG%"
git push origin main

echo ====================================================
echo Commit e push concluidos.
echo ====================================================
pause
