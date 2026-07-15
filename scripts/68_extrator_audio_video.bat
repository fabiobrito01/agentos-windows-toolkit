@echo off
setlocal enabledelayedexpansion
set "PASTA_VIDEOS=%~1"
if not defined PASTA_VIDEOS set /p "PASTA_VIDEOS=Pasta de videos: "
set "PASTA_SAIDA=%~2"
if not defined PASTA_SAIDA set "PASTA_SAIDA=%PASTA_VIDEOS%\Audios"

if not exist "ffmpeg.exe" (
    echo ffmpeg.exe nao encontrado no PATH ou na pasta do script.
    echo Baixe em: https://ffmpeg.org/download.html
    pause
    exit /b
)

if not exist "%PASTA_SAIDA%" mkdir "%PASTA_SAIDA%"

echo ====================================================
echo EXTRATOR DE AUDIOS DE VIDEOS (MP4 para MP3)
echo ====================================================

for %%F in ("%PASTA_VIDEOS%\*.mp4") do (
    echo Extraindo audio de %%~nxF...
    ffmpeg -i "%%F" -vn -ab 192k -ar 44100 -y "%PASTA_SAIDA%\%%~nF.mp3"
)

echo Extracao concluida em: %PASTA_SAIDA%
echo ====================================================
pause
