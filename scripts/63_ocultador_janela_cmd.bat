@echo off
setlocal enabledelayedexpansion
set "SCRIPT_ALVO=meu_script_de_fundo.bat"

echo ====================================================
echo OCULTADOR DINAMICO DE JANELA CMD
echo ====================================================

(
echo Set objShell = CreateObject("WScript.Shell"^)
echo objShell.Run "%SCRIPT_ALVO%", 0, False
) > _run_hidden.vbs

cscript //nologo _run_hidden.vbs
del _run_hidden.vbs >nul 2>&1

echo Script executado em segundo plano sem janela visivel.
echo ====================================================
