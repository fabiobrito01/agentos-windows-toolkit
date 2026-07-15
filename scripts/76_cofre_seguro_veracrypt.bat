@echo off
:: =========================================================================
:: AgentOS - Modulo 09: Cofre com Criptografia Real (VeraCrypt - AES-256)
:: Compativel com Windows Home. Requer VeraCrypt instalado.
:: Download: https://www.veracrypt.fr
:: =========================================================================
title AgentOS - Cofre Real Criptografado (VeraCrypt)
setlocal enabledelayedexpansion

:: --- CONFIGURACOES DO COFRE ---
set "COFRE_NOME=CofreSeguro.hc"
set "COFRE_TAMANHO=5000M"
set "LETRA_DRIVE=Z"

:: Caminho do executavel do VeraCrypt (ajuste se instalou em outro local)
set "VC_EXE=%ProgramFiles%\VeraCrypt\VeraCrypt.exe"
if not exist "%VC_EXE%" set "VC_EXE=%ProgramFiles(x86)%\VeraCrypt\VeraCrypt.exe"
:: ------------------------------

:: --- CHECAGEM: VeraCrypt instalado? ---
if not exist "%VC_EXE%" (
    echo [ERRO] VeraCrypt nao encontrado em: %VC_EXE%
    echo Baixe e instale em: https://www.veracrypt.fr/en/Downloads.html
    echo Se instalou em outro local, edite a variavel VC_EXE neste script.
    pause
    exit /b 1
)

:MENU
cls
echo =========================================================================
echo              AGENTOS - COFRE CRIPTOGRAFADO REAL (VeraCrypt AES-256)
echo =========================================================================
echo.
echo  [1] Abrir / Montar Cofre Seguro
echo  [2] Fechar / Desmontar Cofre
echo  [3] Criar um Novo Cofre (Primeira Vez)
echo  [4] Sair
echo.
echo =========================================================================
set /p "opc=Escolha uma opcao: "

if "%opc%"=="1" goto ABRIR
if "%opc%"=="2" goto FECHAR
if "%opc%"=="3" goto CRIAR
if "%opc%"=="4" exit
goto MENU

:CRIAR
cls
if exist "%COFRE_NOME%" (
    echo [ERRO] Ja existe um cofre com o nome %COFRE_NOME% nesta pasta.
    pause
    goto MENU
)

echo [+] Vamos criar o cofre. O assistente do VeraCrypt vai abrir.
echo.
echo Sugestao de configuracao no assistente:
echo   - Tipo de volume: Standard
echo   - Local: %CD%\%COFRE_NOME%
echo   - Algoritmo de criptografia: AES
echo   - Tamanho: %COFRE_TAMANHO%
echo   - Sistema de arquivos: NTFS
echo   - Mova o mouse na tela de geracao de chaves para aumentar a aleatoriedade
echo.
pause

:: Abre o assistente interativo oficial (mais seguro do que automatizar senha via linha de comando)
"%VC_EXE%" /create "%CD%\%COFRE_NOME%"

if exist "%COFRE_NOME%" (
    echo.
    echo [SUCESSO] Cofre %COFRE_NOME% criado!
    echo Use a opcao [1] para montar e [2] para desmontar quando terminar.
) else (
    echo [AVISO] Nenhum arquivo de cofre foi detectado. A criacao pode ter sido cancelada.
)
pause
goto MENU

:ABRIR
cls
echo [+] Montando o cofre criptografado...
if not exist "%COFRE_NOME%" (
    echo [ERRO] Arquivo do cofre %COFRE_NOME% nao foi encontrado nesta pasta.
    echo Use a opcao 3 para criar um novo primeiro.
    pause
    goto MENU
)

if exist %LETRA_DRIVE%:\ (
    echo [AVISO] A unidade %LETRA_DRIVE%: ja parece estar montada/em uso.
    pause
    goto MENU
)

:: A senha sera pedida pela propria janela do VeraCrypt (segura, nao aparece em texto)
"%VC_EXE%" /v "%CD%\%COFRE_NOME%" /l %LETRA_DRIVE% /a /e

if exist %LETRA_DRIVE%:\ (
    echo.
    echo [SUCESSO] Cofre montado! Unidade %LETRA_DRIVE%: liberada.
    explorer %LETRA_DRIVE%:\
) else (
    echo.
    echo [ERRO] Senha incorreta, cancelado, ou falha ao montar o volume.
)
pause
goto MENU

:FECHAR
cls
echo [+] Desmontando e trancando o cofre...
if not exist %LETRA_DRIVE%:\ (
    echo [AVISO] O cofre nao parece estar montado.
    pause
    goto MENU
)

"%VC_EXE%" /d %LETRA_DRIVE% /q

if not exist %LETRA_DRIVE%:\ (
    echo.
    echo [SUCESSO] O cofre foi desmontado e os dados estao criptografados com AES-256!
) else (
    echo.
    echo [ERRO] Nao foi possivel desmontar. Feche arquivos/programas abertos na unidade.
)
pause
goto MENU
