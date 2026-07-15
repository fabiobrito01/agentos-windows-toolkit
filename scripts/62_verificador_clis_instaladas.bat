@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo VERIFICADOR DE VERSOES DE CLIs INSTALADAS
echo ====================================================

echo --- Node.js ---
node --version 2>&1

echo --- Python ---
python --version 2>&1

echo --- Git ---
git --version 2>&1

echo --- Docker ---
docker --version 2>&1

echo --- Java ---
java -version 2>&1

echo --- Go ---
go version 2>&1

echo --- .NET ---
dotnet --version 2>&1

echo ====================================================
pause
