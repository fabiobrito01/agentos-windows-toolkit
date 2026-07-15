#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Position=0)][string]$Fonte,
    [Parameter(Position=1)][string]$Destino,
    [switch]$SelecionarZip,
    [switch]$SelecionarPasta,
    [switch]$Sobrescrever,
    [switch]$Simular,
    [switch]$AbrirDestino,
    [switch]$SemProgresso
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = if ($SemProgresso) { 'SilentlyContinue' } else { 'Continue' }
$utf8SemBom = [Text.UTF8Encoding]::new($false)
$script:logPath = $null
$script:criados = 0
$script:sobrescritos = 0
$script:ignorados = 0
$script:omitidos = 0
$script:erros = 0
$script:registros = [Collections.Generic.List[object]]::new()

function Write-Log([string]$Mensagem, [ValidateSet('INFO','AVISO','ERRO')][string]$Nivel='INFO') {
    $linha = '[{0}] [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'),$Nivel,$Mensagem
    if ($script:logPath) { [IO.File]::AppendAllText($script:logPath,$linha+[Environment]::NewLine,$utf8SemBom) }
    Write-Host $linha -ForegroundColor (@{INFO='Gray';AVISO='Yellow';ERRO='Red'}[$Nivel])
}

function Select-ZipFile {
    Add-Type -AssemblyName System.Windows.Forms
    $dialogo = [Windows.Forms.OpenFileDialog]::new()
    $dialogo.Title = 'Selecione o ZIP criado pelo exportador Markdown'
    $dialogo.Filter = 'Pacote ZIP (*.zip)|*.zip|Todos os arquivos (*.*)|*.*'
    $dialogo.Multiselect = $false
    try {
        if ($dialogo.ShowDialog() -ne [Windows.Forms.DialogResult]::OK) { return $null }
        return $dialogo.FileName
    } finally { $dialogo.Dispose() }
}

function Select-Folder([string]$Descricao, [bool]$PermitirCriar) {
    Add-Type -AssemblyName System.Windows.Forms
    $dialogo = [Windows.Forms.FolderBrowserDialog]::new()
    $dialogo.Description = $Descricao
    $dialogo.ShowNewFolderButton = $PermitirCriar
    try {
        if ($dialogo.ShowDialog() -ne [Windows.Forms.DialogResult]::OK) { return $null }
        return $dialogo.SelectedPath
    } finally { $dialogo.Dispose() }
}

function Test-FonteValida([string]$Caminho) {
    if ([string]::IsNullOrWhiteSpace($Caminho) -or -not (Test-Path -LiteralPath $Caminho)) { return $false }
    if (Test-Path -LiteralPath $Caminho -PathType Container) {
        return $null -ne (Get-ChildItem -LiteralPath $Caminho -File -Filter 'PROJETO_*_parte*.md' -ErrorAction SilentlyContinue | Select-Object -First 1)
    }
    if ([IO.Path]::GetExtension($Caminho) -ine '.zip') { return $false }
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $testeZip=[IO.Compression.ZipFile]::OpenRead($Caminho)
        try { return $null -ne ($testeZip.Entries | Where-Object { $_.Name -match '^PROJETO_.+_parte\d+\.md$' } | Select-Object -First 1) }
        finally { $testeZip.Dispose() }
    } catch { return $false }
}

function Show-Aviso([string]$Mensagem) {
    try {
        Add-Type -AssemblyName System.Windows.Forms
        [void][Windows.Forms.MessageBox]::Show($Mensagem,'Recriar Projeto',[Windows.Forms.MessageBoxButtons]::OK,[Windows.Forms.MessageBoxIcon]::Warning)
    } catch { Write-Host $Mensagem -ForegroundColor Yellow }
}

function Get-CaminhoDestinoSeguro([string]$Relativo) {
    $limpo = $Relativo.Trim().Replace('/',[IO.Path]::DirectorySeparatorChar).Replace('\',[IO.Path]::DirectorySeparatorChar)
    if ([string]::IsNullOrWhiteSpace($limpo) -or [IO.Path]::IsPathRooted($limpo)) { throw "Caminho invalido no Markdown: $Relativo" }
    $completo = [IO.Path]::GetFullPath((Join-Path $script:destinoRaiz $limpo))
    if (-not $completo.StartsWith($script:destinoPrefixo,[StringComparison]::OrdinalIgnoreCase)) {
        throw "Caminho fora do destino bloqueado: $Relativo"
    }
    return $completo
}

function Add-Registro([string]$Parte,[string]$Caminho,[string]$Status,[string]$Detalhe='') {
    $script:registros.Add([pscustomobject]@{ parte=$Parte; caminho=$Caminho; status=$Status; detalhe=$Detalhe })
}

function Save-ReconstructedFile([string]$Parte,[string]$Relativo,[Collections.Generic.List[string]]$Linhas) {
    try {
        $alvo = Get-CaminhoDestinoSeguro $Relativo
        $conteudo = $Linhas -join "`n"
        $existe = Test-Path -LiteralPath $alvo
        if ($existe -and -not $Sobrescrever) {
            $script:ignorados++; Add-Registro $Parte $Relativo 'existente_ignorado' 'Use -Sobrescrever para substituir.'; return
        }
        if (-not $Simular) {
            $pasta = Split-Path -Parent $alvo
            [void][IO.Directory]::CreateDirectory($pasta)
            $temporario = "$alvo.recriando.$PID.tmp"
            try {
                [IO.File]::WriteAllText($temporario,$conteudo,$utf8SemBom)
                Move-Item -LiteralPath $temporario -Destination $alvo -Force
            } finally {
                if (Test-Path -LiteralPath $temporario) { Remove-Item -LiteralPath $temporario -Force -ErrorAction SilentlyContinue }
            }
        }
        if ($existe) { $script:sobrescritos++; $status='sobrescrito' } else { $script:criados++; $status=if($Simular){'seria_criado'}else{'criado'} }
        Add-Registro $Parte $Relativo $status
    } catch {
        $script:erros++; Add-Registro $Parte $Relativo 'erro' $_.Exception.Message
        Write-Log "$Parte :: $Relativo :: $($_.Exception.Message)" 'AVISO'
    }
}

function Read-MarkdownStream([IO.Stream]$Stream,[string]$NomeParte) {
    $reader = [IO.StreamReader]::new($Stream,[Text.Encoding]::UTF8,$true,65536,$true)
    try {
        $caminho = $null; $fence = $null; $conteudo = [Collections.Generic.List[string]]::new(); $aguardando = $false
        while (($linha = $reader.ReadLine()) -ne $null) {
            if ($null -ne $fence) {
                if ($linha.TrimEnd() -eq $fence) {
                    Save-ReconstructedFile $NomeParte $caminho $conteudo
                    $caminho=$null; $fence=$null; $conteudo=[Collections.Generic.List[string]]::new(); $aguardando=$false
                } else { $conteudo.Add($linha) }
                continue
            }
            if ($linha.StartsWith('## ')) {
                if ($aguardando -and $caminho) {
                    $script:omitidos++; Add-Registro $NomeParte $caminho 'omitido' 'Sem bloco de conteudo; binario, grande, sensivel ou erro na exportacao.'
                }
                $caminho=$linha.Substring(3).Trim(); $aguardando=$true; continue
            }
            if ($aguardando -and $linha -match '^(`{3,})([^`]*)$') {
                $fence=$Matches[1]; $conteudo=[Collections.Generic.List[string]]::new(); continue
            }
            if ($aguardando -and $linha -match '^\*\(.+\)\*$') {
                $script:omitidos++; Add-Registro $NomeParte $caminho 'omitido' $linha.Trim('*()')
                $caminho=$null; $aguardando=$false
            }
        }
        if ($null -ne $fence -and $caminho) {
            $script:erros++; Add-Registro $NomeParte $caminho 'erro' 'Bloco Markdown sem fechamento.'
        } elseif ($aguardando -and $caminho) {
            $script:omitidos++; Add-Registro $NomeParte $caminho 'omitido' 'Sem bloco de conteudo.'
        }
    } finally { $reader.Dispose() }
}

try {
    if ($SelecionarZip -and [string]::IsNullOrWhiteSpace($Fonte)) {
        do {
            $Fonte=Select-ZipFile
            if ([string]::IsNullOrWhiteSpace($Fonte)) { break }
            if (-not (Test-FonteValida $Fonte)) {
                Show-Aviso 'O ZIP escolhido nao contem arquivos PROJETO_*_parteNNN.md. Selecione o ZIP completo criado a partir da Exportacao_IA.'
                $Fonte=$null
            }
        } while ([string]::IsNullOrWhiteSpace($Fonte))
    }
    if ($SelecionarPasta -and [string]::IsNullOrWhiteSpace($Fonte)) {
        do {
            $Fonte=Select-Folder 'FONTE: selecione a pasta Exportacao_IA que contem os arquivos PROJETO_*_parteNNN.md' $false
            if ([string]::IsNullOrWhiteSpace($Fonte)) { break }
            if (-not (Test-FonteValida $Fonte)) {
                Show-Aviso 'Esta nao e uma pasta Exportacao_IA valida. Ela precisa conter arquivos PROJETO_*_parteNNN.md. Selecione novamente.'
                $Fonte=$null
            }
        } while ([string]::IsNullOrWhiteSpace($Fonte))
    }
    if ([string]::IsNullOrWhiteSpace($Fonte)) { Write-Host 'Operacao cancelada ou fonte nao informada.' -ForegroundColor Yellow; exit 3 }
    $Fonte=[IO.Path]::GetFullPath($Fonte.Trim().Trim('"'))
    if (-not (Test-Path -LiteralPath $Fonte)) { throw "Fonte nao encontrada: $Fonte" }
    if (-not (Test-FonteValida $Fonte)) { throw 'A fonte escolhida nao contem partes PROJETO_*_parteNNN.md reconheciveis.' }

    if ([string]::IsNullOrWhiteSpace($Destino)) {
        do {
            $Destino=Select-Folder 'DESTINO: selecione uma pasta NOVA ou VAZIA para receber o projeto reconstruido' $true
            if ([string]::IsNullOrWhiteSpace($Destino)) { Write-Host 'Operacao cancelada.' -ForegroundColor Yellow; exit 3 }
            if (Test-FonteValida $Destino) {
                Show-Aviso 'Voce escolheu uma Exportacao_IA como destino. Essa pasta e a FONTE. Escolha outra pasta nova ou vazia para receber o projeto reconstruido.'
                $Destino=$null
            }
        } while ([string]::IsNullOrWhiteSpace($Destino))
    }
    $script:destinoRaiz=[IO.Path]::GetFullPath($Destino.Trim().Trim('"')).TrimEnd('\','/')
    if ($script:destinoRaiz -eq $Fonte -or $script:destinoRaiz.StartsWith($Fonte.TrimEnd('\','/')+'\',[StringComparison]::OrdinalIgnoreCase)) {
        throw 'O destino nao pode ser igual nem ficar dentro da fonte da exportacao.'
    }
    [void][IO.Directory]::CreateDirectory($script:destinoRaiz)
    $script:destinoPrefixo=$script:destinoRaiz+[IO.Path]::DirectorySeparatorChar
    $script:logPath=Join-Path $script:destinoRaiz 'RECRIACAO_PROJETO.log'
    [IO.File]::WriteAllText($script:logPath,'',$utf8SemBom)
    Write-Log "Fonte: $Fonte"; Write-Log "Destino: $($script:destinoRaiz)"; if($Simular){Write-Log 'Modo simulacao: nenhum arquivo sera gravado.' 'AVISO'}

    $partesProcessadas=0
    if ([IO.Path]::GetExtension($Fonte) -ieq '.zip') {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $zip=[IO.Compression.ZipFile]::OpenRead($Fonte)
        try {
            $entradas=@($zip.Entries | Where-Object { -not $_.FullName.EndsWith('/') -and $_.Name -match '^PROJETO_.+_parte\d+\.md$' } | Sort-Object FullName)
            if ($entradas.Count -eq 0) { throw 'O ZIP nao contem partes PROJETO_*_parteNNN.md reconheciveis.' }
            foreach($entrada in $entradas) {
                $partesProcessadas++; Write-Progress -Activity 'Reconstruindo projeto' -Status $entrada.Name -PercentComplete (100*$partesProcessadas/$entradas.Count)
                $stream=$entrada.Open(); try { Read-MarkdownStream $stream $entrada.Name } finally { $stream.Dispose() }
            }
        } finally { $zip.Dispose() }
    } elseif (Test-Path -LiteralPath $Fonte -PathType Container) {
        $partes=@(Get-ChildItem -LiteralPath $Fonte -File -Filter 'PROJETO_*_parte*.md' | Sort-Object Name)
        if ($partes.Count -eq 0) { throw 'A pasta nao contem partes PROJETO_*_parteNNN.md reconheciveis.' }
        foreach($parte in $partes) {
            $partesProcessadas++; Write-Progress -Activity 'Reconstruindo projeto' -Status $parte.Name -PercentComplete (100*$partesProcessadas/$partes.Count)
            $stream=[IO.File]::OpenRead($parte.FullName); try { Read-MarkdownStream $stream $parte.Name } finally { $stream.Dispose() }
        }
    } else { throw 'A fonte deve ser um arquivo ZIP ou uma pasta Exportacao_IA.' }
    Write-Progress -Activity 'Reconstruindo projeto' -Completed

    $relatorio=[ordered]@{
        versao=1; concluidoEm=(Get-Date).ToString('o'); fonte=$Fonte; destino=$script:destinoRaiz; simulacao=[bool]$Simular
        resumo=[ordered]@{ partes=$partesProcessadas; criados=$script:criados; sobrescritos=$script:sobrescritos; existentesIgnorados=$script:ignorados; omitidosNaExportacao=$script:omitidos; erros=$script:erros }
        arquivos=@($script:registros)
    }
    [IO.File]::WriteAllText((Join-Path $script:destinoRaiz 'RELATORIO_RECRIACAO.json'),($relatorio|ConvertTo-Json -Depth 6),$utf8SemBom)
    $resumoMd="# Relatorio de recriacao`n`n- Fonte: ``$Fonte```n- Destino: ``$($script:destinoRaiz)```n- Partes processadas: $partesProcessadas`n- Arquivos criados: $($script:criados)`n- Arquivos sobrescritos: $($script:sobrescritos)`n- Existentes ignorados: $($script:ignorados)`n- Nao recuperaveis por omissao na exportacao: $($script:omitidos)`n- Erros: $($script:erros)`n`nConsulte ``RELATORIO_RECRIACAO.json`` para os detalhes de cada arquivo.`n"
    [IO.File]::WriteAllText((Join-Path $script:destinoRaiz 'RELATORIO_RECRIACAO.md'),$resumoMd,$utf8SemBom)
    Write-Log "Concluido: $($script:criados) criados, $($script:sobrescritos) sobrescritos, $($script:omitidos) omitidos, $($script:erros) erros."
    if($AbrirDestino -and -not $Simular){Start-Process explorer.exe -ArgumentList ('"{0}"' -f $script:destinoRaiz)}
    if($script:erros -gt 0){exit 2}; exit 0
} catch {
    Write-Log $_.Exception.Message 'ERRO'; exit 1
}
