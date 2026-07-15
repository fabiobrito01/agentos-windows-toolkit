@echo off
setlocal enabledelayedexpansion
set "DB_USER=%~1"
set "DB_NAME=%~2"
set "BACKUP_DIR=%~3"
if not defined DB_USER set /p "DB_USER=Usuario MySQL: "
if not defined DB_NAME set /p "DB_NAME=Nome do banco: "
if not defined BACKUP_DIR set "BACKUP_DIR=%USERPROFILE%\Documents\Backups\BancoDados"

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set DT=%%I
set TIMESTAMP=%DT:~0,8%

echo ====================================================
echo BACKUP DE BANCO DE DADOS (MySQL)
echo ====================================================

echo A senha sera solicitada de forma interativa pelo MySQL.
mysqldump -u "%DB_USER%" -p "%DB_NAME%" > "%BACKUP_DIR%\%DB_NAME%_%TIMESTAMP%.sql"
if errorlevel 1 (echo [ERRO] O backup falhou.& pause& exit /b 1)

echo Backup salvo em: %BACKUP_DIR%
echo ====================================================
pause
