@echo off
setlocal enabledelayedexpansion

:: 📁 CONFIGURAÇÃO DA ORIGEM (Pasta Atual)
set "PROJECT_DIR=%~dp0"
set "PROJECT_DIR=%PROJECT_DIR:~0,-1%"
for %%A in ("%PROJECT_DIR%") do set "NOME_PASTA=%%~nxA"

echo ====================================================
echo 🤖 AgentOS - Backup Automático Multi-Unidade
echo ====================================================
echo.

:: 🔍 DETECTAR UNIDADES DISPONÍVEIS
echo Unidades de disco encontradas no seu computador:
set "contador=0"
for /f "skip=1 tokens=1,2 delims=:" %%A in ('wmic logicaldisk get deviceid^,volumename 2^>nul') do (
    set "letra=%%A"
    set "nome_vol=%%B"
    if not "!letra!"=="" (
        set "letra=!letra:~0,1!"
        :: Ignora unidades de CD/Disquete comuns vazias
        if exist "!letra!:" (
            set /a contador+=1
            set "unidade_!contador!=!letra!:"
            echo  [!contador!] !letra!: !nome_vol!
        )
    )
)

echo ----------------------------------------------------
set /p "opcao=Selecione o numero da unidade para salvar o backup: "

if not defined unidade_%opcao% (
    echo [ERRO] Opcao invalida! Operacao cancelada.
    goto :end
)

:: Define o destino baseado na escolha do usuário
set "DRIVE_ESCOLHIDO=!unidade_%opcao%!"
set "BACKUP_DIR=%DRIVE_ESCOLHIDO%\Backups_Seguranca"

:: 📝 SALVAR O LEMBRETE DE SINTONIA
:: Grava a unidade escolhida num arquivo oculto para o restaurar saber onde buscar
echo %DRIVE_ESCOLHIDO%> "%PROJECT_DIR%\.backup_location.txt"

:: Gerar Timestamp (Formato: YYYYMMDD_HHMMSS)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set "dt=%%I"
set "TIMESTAMP=%dt:~0,4%%dt:~4,2%%dt:~6,2%_%dt:~8,2%%dt:~10,2%%dt:~12,2%"
set "TARGET_BACKUP=%BACKUP_DIR%\Backup_%NOME_PASTA%_%TIMESTAMP%"

echo.
echo ----------------------------------------------------
echo Iniciando cópia dos arquivos...
echo Origem:  %PROJECT_DIR%
echo Destino: %TARGET_BACKUP%
echo ----------------------------------------------------

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

:: Executa o Robocopy protegendo os arquivos essenciais
robocopy "%PROJECT_DIR%" "%TARGET_BACKUP%" /E /XD .git /XF backup.bat restaurar.bat .backup_location.txt

echo ----------------------------------------------------
echo 🎉 Backup concluido com sucesso na unidade %DRIVE_ESCOLHIDO%!
echo ====================================================

:end
pause
