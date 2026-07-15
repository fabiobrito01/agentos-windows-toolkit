@echo off
setlocal enabledelayedexpansion
set "PROJECT_DIR=%~1"
if not defined PROJECT_DIR set /p "PROJECT_DIR=Pasta do projeto: "
echo ====================================================
echo Limpando Arquivos Temporarios de Desenvolvimento
echo ====================================================
echo Alvo: %PROJECT_DIR%
echo ----------------------------------------------------
if exist "%PROJECT_DIR%\build" (
    echo [OK] Removendo pasta /build...
    rmdir /s /q "%PROJECT_DIR%\build"
)
if exist "%PROJECT_DIR%\.dart_tool" (
    echo [OK] Removendo pasta /.dart_tool...
    rmdir /s /q "%PROJECT_DIR%\.dart_tool"
)
if exist "%PROJECT_DIR%\.idea" (
    echo [OK] Removendo configuracoes locais da IDE (.idea)...
    rmdir /s /q "%PROJECT_DIR%\.idea"
)
echo ----------------------------------------------------
echo Limpeza concluida com sucesso!
echo ====================================================
pause
