@echo off
setlocal enabledelayedexpansion
echo ====================================================
echo ALTERNADOR DE RESOLUCAO DE TELA
echo ====================================================
echo 1. 4K (3840x2160)
echo 2. Full HD (1920x1080)
echo 3. Personalizado
set /p OPC=Escolha:

if "%OPC%"=="1" set WIDTH=3840 & set HEIGHT=2160
if "%OPC%"=="2" set WIDTH=1920 & set HEIGHT=1080
if "%OPC%"=="3" (
    set /p WIDTH=Largura:
    set /p HEIGHT=Altura:
)

powershell -command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class Display { [DllImport(\"user32.dll\")] public static extern int ChangeDisplaySettings(IntPtr lpDevMode, int dwFlags); }'; Write-Host 'Use uma ferramenta como QRes ou NirCmd para troca real de resolucao via CLI'"

echo Resolucao solicitada: %WIDTH%x%HEIGHT%
echo Nota: para troca real de resolucao recomenda-se NirCmd ou QRes.
echo ====================================================
pause
