@echo off
setlocal enabledelayedexpansion
set "TARGET_DIR=%~1"
if not defined TARGET_DIR set "TARGET_DIR=%USERPROFILE%\Downloads"
echo ====================================================
echo Organizando Arquivos por Categoria
echo ====================================================
echo Escaneando: %TARGET_DIR%
echo ----------------------------------------------------
cd /d "%TARGET_DIR%"
if not exist "Documentos" mkdir "Documentos"
if not exist "Imagens" mkdir "Imagens"
if not exist "Instaladores" mkdir "Instaladores"
echo [OK] Separando PDFs e Word...
move *.pdf "Documentos" >nul 2>&1
move *.docx "Documentos" >nul 2>&1
move *.txt "Documentos" >nul 2>&1
echo [OK] Separando Fotos...
move *.png "Imagens" >nul 2>&1
move *.jpg "Imagens" >nul 2>&1
move *.jpeg "Imagens" >nul 2>&1
echo [OK] Separando Programas...
move *.exe "Instaladores" >nul 2>&1
move *.msi "Instaladores" >nul 2>&1
echo ----------------------------------------------------
echo Tudo organizado no seu devido lugar!
echo ====================================================
pause
