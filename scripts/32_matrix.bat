@echo off
title Matrix
mode con: cols=120 lines=30
color 0A
setlocal enabledelayedexpansion

:: Caracteres usados no efeito (numeros, letras e simbolos)
set "CHARS=01アイウエオカキクケコサシスセソタチツテト$#@%&!?+=*<>"

:LOOP
set "LINE="
for /l %%i in (1,1,120) do (
    set /a "IDX=!random! %% 40"
    call set "CHAR=%%CHARS:~!IDX!,1%%"
    set "LINE=!LINE!!CHAR!"
)
echo !LINE!
goto LOOP
