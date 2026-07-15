@echo off
setlocal enabledelayedexpansion

:: 📁 CONFIGURAÇÃO AUTOMÁTICA PORTÁTIL
set "PROJECT_DIR=%~dp0"
set "PROJECT_DIR=%PROJECT_DIR:~0,-1%"
for %%A in ("%PROJECT_DIR%") do set "NOME_PASTA=%%~nxA"

echo ====================================================
echo 🤖 AgentOS - Restauração Rápida Blindada
echo ====================================================
echo.

:: 🔑 LER O LEMBRETE DE SINTONIA
if not exist "%PROJECT_DIR%\.backup_location.txt" (
    echo [ERRO] Nao encontrei o registro de localizacao do backup!
    echo Rode o backup.bat primeiro para criar o ponto de sintonia.
    echo.
    goto :end
)

set /p DRIVE_SALVO=<"%PROJECT_DIR%\.backup_location.txt"
set "BACKUP_DIR=%DRIVE_SALVO%\Backups_Seguranca"

echo Localizando historicos na unidade: %DRIVE_SALVO%
echo ----------------------------------------------------

:: Encontrar a pasta de backup mais recente
set "LATEST_BACKUP="
for /f "delims=" %%F in ('dir "%BACKUP_DIR%\Backup_%NOME_PASTA%_*" /B /AD /O-N 2^>nul') do (
    set "LATEST_BACKUP=%BACKUP_DIR%\%%F"
    goto :found
)

:found
if "%LATEST_BACKUP%"=="" (
    echo ❌ Nenhum backup encontrado para "%NOME_PASTA%".
    goto :end
)

:: --- TRAVA DE SEGURANÇA (Blindagem contra nomes errados) ---
for %%B in ("%LATEST_BACKUP%") do set "NOME_BACKUP_VERIF=%%~nxB"
set "NOME_ESPERADO=Backup_%NOME_PASTA%_"

echo !NOME_BACKUP_VERIF! | findstr /b /c:"%NOME_ESPERADO%" >nul
if errorlevel 1 (
    echo [ERRO CRÍTICO] Falha na verificacao de segurança!
    echo O backup encontrado nao pertence a esta pasta de projeto.
    echo Operacao abortada para proteger seus dados.
    goto :end
)
:: --- FIM DA TRAVA ---

echo Ultimo backup localizado: %LATEST_BACKUP%
echo.
set /p "CONFIRM=Confirma a restauracao? Os arquivos atuais serao substituidos e este backup sera APAGADO! (S/N): "
if /i "%CONFIRM%" NEQ "S" (
    echo Operacao cancelada pelo usuario.
    goto :end
)

echo ----------------------------------------------------
echo Limpando arquivos antigos...
echo ----------------------------------------------------

:: Limpar subpastas atuais
for /d %%p in ("%PROJECT_DIR%\*") do (
    set "dirname=%%~nxp"
    if /i "!dirname!" NEQ "backup.bat" if /i "!dirname!" NEQ "restaurar.bat" (
        rmdir /s /q "%%p"
    )
)

:: Limpar arquivos soltos atuais
for %%f in ("%PROJECT_DIR%\*") do (
    set "filename=%%~nxf"
    if /i "!filename!" NEQ "backup.bat" if /i "!filename!" NEQ "restaurar.bat" if /i "!filename!" NEQ ".backup_location.txt" (
        del /q "%%f"
    )
)

:: Copiar arquivos de volta usando Robocopy
robocopy "%LATEST_BACKUP%" "%PROJECT_DIR%" /E

echo ----------------------------------------------------
echo 🧼 Removendo o arquivo de backup utilizado...
rmdir /s /q "%LATEST_BACKUP%"

:: 🧹 VERIFICAÇÃO EXTRA: Apaga a pasta principal se ela ficar vazia
set "vazia=1"
for /f "delims=" %%I in ('dir "%BACKUP_DIR%" /B /A 2^>nul') do set "vazia=0"

if "!vazia!"=="1" (
    echo 🗑️  A pasta "Backups_Seguranca" ficou vazia e tambem foi removida!
    rmdir /q "%BACKUP_DIR%" 2^>nul
)
echo ----------------------------------------------------

echo ✅ Pasta restaurada com sucesso! Sistema blindado e limpo.
echo ====================================================

:end
pause
