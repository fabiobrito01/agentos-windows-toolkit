@echo off
setlocal enabledelayedexpansion
set "TAMANHO=16"

echo ====================================================
echo GERADOR DE SENHAS FORTES CRIPTOGRAFICAS
echo ====================================================

powershell -command "Add-Type -AssemblyName System.Web; [System.Web.Security.Membership]::GeneratePassword(%TAMANHO%, 4)"

echo ====================================================
pause
