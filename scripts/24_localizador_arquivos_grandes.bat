@echo off
setlocal enabledelayedexpansion
set "SCAN_DIR=%~1"
if not defined SCAN_DIR set /p "SCAN_DIR=Pasta a verificar: "
set "RESULTADOS=%USERPROFILE%\Documents\arquivos_grandes.txt"
set "LIMITE=104857600"

echo Escaneando %SCAN_DIR% por arquivos acima de 100MB... > "%RESULTADOS%"
echo ==================================================== >> "%RESULTADOS%"

for /R "%SCAN_DIR%" %%F in (*) do (
    set /a SIZE=%%~zF
    if !SIZE! GTR %LIMITE% (
        echo %%F - !SIZE! bytes >> "%RESULTADOS%"
    )
)

echo Resultado salvo em: %RESULTADOS%
notepad "%RESULTADOS%"
pause
