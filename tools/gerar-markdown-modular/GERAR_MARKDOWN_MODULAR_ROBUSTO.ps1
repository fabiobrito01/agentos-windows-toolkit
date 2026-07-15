#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$RaizProjeto,

    [Parameter(Position = 1)]
    [string]$PastaSaida,

    [string[]]$Modulos,
    [ValidateRange(1, 1024)][int]$LimiteArquivoMB = 5,
    [ValidateRange(1, 1024)][int]$LimiteParteMB = 2,
    [switch]$IncluirOcultos,
    [switch]$IncluirArquivosSensiveis,
    [switch]$LimparSaida,
    [switch]$SemProgresso,
    [switch]$SelecionarPasta,
    [switch]$AbrirSaida
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = if ($SemProgresso) { 'SilentlyContinue' } else { 'Continue' }

$pastasIgnoradas = @(
    'node_modules', '.git', 'build', '.dart_tool', '.gradle', '.pub-cache',
    'Pods', 'DerivedData', '.idea', '.vs', '.vscode', 'bin', 'obj',
    'coverage', '.next', 'dist', '__pycache__', '.pytest_cache', '.venv', 'venv'
)
$extensoesTexto = @(
    '.dart','.js','.mjs','.cjs','.ts','.jsx','.tsx','.json','.jsonc','.md','.txt',
    '.py','.java','.kt','.kts','.c','.h','.cpp','.hpp','.cs','.go','.rs','.php',
    '.css','.scss','.sass','.less','.html','.htm','.sql','.graphql','.gql','.yaml',
    '.yml','.ps1','.psm1','.psd1','.bat','.cmd','.sh','.xml','.gradle','.properties',
    '.gitignore','.gitattributes','.editorconfig','.plist','.cfg','.conf','.ini','.toml',
    '.lock','.csv','.tsv','.env.example','.env.sample'
)
$nomesSensiveis = @('.env', '.npmrc', '.pypirc', 'id_rsa', 'id_ed25519', 'credentials.json')
$padroesSensiveis = @('*.pem','*.key','*.pfx','*.p12','*.jks','*.keystore','*secret*','*credential*')
$utf8SemBom = [System.Text.UTF8Encoding]::new($false)
$script:logPath = $null
$encodingsEstritas = @(
    [System.Text.UTF8Encoding]::new($false, $true),
    [System.Text.UnicodeEncoding]::new($false, $true, $true),
    [System.Text.UnicodeEncoding]::new($true, $true, $true)
)

function Write-Log([string]$Mensagem, [ValidateSet('INFO','AVISO','ERRO')][string]$Nivel = 'INFO') {
    $linha = '[{0}] [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Nivel, $Mensagem
    if ($script:logPath) { [System.IO.File]::AppendAllText($script:logPath, $linha + [Environment]::NewLine, $utf8SemBom) }
    $cor = @{ INFO = 'Gray'; AVISO = 'Yellow'; ERRO = 'Red' }[$Nivel]
    Write-Host $linha -ForegroundColor $cor
}

function Get-NomeSeguro([string]$Nome) {
    $invalido = '[{0}]' -f [regex]::Escape((-join [System.IO.Path]::GetInvalidFileNameChars()))
    $resultado = ([regex]::Replace($Nome, $invalido, '_')).Trim().TrimEnd('.')
    $resultado = [regex]::Replace($resultado, '\s+', '_')
    if ([string]::IsNullOrWhiteSpace($resultado)) { return 'RAIZ' }
    return $resultado
}

function Test-Ignorado([string]$Relativo) {
    $segmentos = $Relativo -split '[\\/]'
    foreach ($segmento in $segmentos) {
        if ($pastasIgnoradas -contains $segmento) { return $true }
    }
    return $false
}

function Test-Sensivel([System.IO.FileInfo]$Arquivo) {
    if ($IncluirArquivosSensiveis) { return $false }
    if ($nomesSensiveis -contains $Arquivo.Name.ToLowerInvariant()) { return $true }
    foreach ($padrao in $padroesSensiveis) {
        if ($Arquivo.Name -like $padrao) { return $true }
    }
    return $false
}

function Test-Texto([System.IO.FileInfo]$Arquivo) {
    $nome = $Arquivo.Name.ToLowerInvariant()
    if ($extensoesTexto -contains $Arquivo.Extension.ToLowerInvariant()) { return $true }
    return $extensoesTexto -contains $nome
}

function Read-TextoSeguro([string]$Caminho) {
    $bytes = [System.IO.File]::ReadAllBytes($Caminho)
    if ($bytes.Length -eq 0) { return '' }
    if ($bytes -contains 0) { throw 'O arquivo contem bytes nulos e parece ser binario.' }
    foreach ($encoding in $encodingsEstritas) {
        try { return $encoding.GetString($bytes) } catch [System.Text.DecoderFallbackException] { }
    }
    return [System.Text.Encoding]::Default.GetString($bytes)
}

function Get-FenceSegura([string]$Conteudo) {
    $maximo = 2
    foreach ($match in [regex]::Matches($Conteudo, '`+')) {
        if ($match.Length -gt $maximo) { $maximo = $match.Length }
    }
    return '`' * ($maximo + 1)
}

function Write-TextoAtomico([string]$Caminho, [string]$Conteudo) {
    $temporario = "$Caminho.tmp.$PID"
    try {
        [System.IO.File]::WriteAllText($temporario, $Conteudo, $utf8SemBom)
        Move-Item -LiteralPath $temporario -Destination $Caminho -Force
    } finally {
        if (Test-Path -LiteralPath $temporario) { Remove-Item -LiteralPath $temporario -Force -ErrorAction SilentlyContinue }
    }
}

try {
    if ($SelecionarPasta -and [string]::IsNullOrWhiteSpace($RaizProjeto)) {
        try {
            Add-Type -AssemblyName System.Windows.Forms
            $seletor = [System.Windows.Forms.FolderBrowserDialog]::new()
            $seletor.Description = 'Selecione a pasta raiz do projeto que sera exportado'
            $seletor.ShowNewFolderButton = $false
            if ($seletor.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
                Write-Host 'Operacao cancelada pelo usuario.' -ForegroundColor Yellow
                exit 3
            }
            $RaizProjeto = $seletor.SelectedPath
            $seletor.Dispose()
        } catch {
            throw "Nao foi possivel abrir o seletor de pastas. Informe -RaizProjeto. Detalhe: $($_.Exception.Message)"
        }
    }
    if ([string]::IsNullOrWhiteSpace($RaizProjeto)) {
        throw 'Informe a pasta do projeto com -RaizProjeto ou use -SelecionarPasta.'
    }
    $RaizProjeto = [System.IO.Path]::GetFullPath($RaizProjeto.Trim().Trim('"')).TrimEnd('\','/')
    if (-not (Test-Path -LiteralPath $RaizProjeto -PathType Container)) { throw "Pasta raiz nao encontrada: $RaizProjeto" }
    if (-not $PastaSaida) { $PastaSaida = Join-Path $RaizProjeto 'Exportacao_IA' }
    $PastaSaida = [System.IO.Path]::GetFullPath($PastaSaida.Trim().Trim('"')).TrimEnd('\','/')
    if ($PastaSaida -eq $RaizProjeto) { throw 'A pasta de saida nao pode ser igual a raiz do projeto.' }

    [void][System.IO.Directory]::CreateDirectory($PastaSaida)
    $script:logPath = Join-Path $PastaSaida 'exportacao.log'
    [System.IO.File]::WriteAllText($script:logPath, '', $utf8SemBom)
    Write-Log "Raiz: $RaizProjeto"
    Write-Log "Saida: $PastaSaida"

    if ($LimparSaida) {
        Get-ChildItem -LiteralPath $PastaSaida -File -Force | Where-Object {
            $_.Name -match '^(PROJETO_.+\.md|INDEX\.md|MANIFESTO\.json|exportacao\.log)$'
        } | Where-Object { $_.FullName -ne $script:logPath } | Remove-Item -Force
    } else {
        Get-ChildItem -LiteralPath $PastaSaida -File -Filter 'PROJETO_*.md' -ErrorAction SilentlyContinue | Remove-Item -Force
    }

    $saidaRelativa = if ($PastaSaida.StartsWith($RaizProjeto + '\', [StringComparison]::OrdinalIgnoreCase)) {
        $PastaSaida.Substring($RaizProjeto.Length + 1)
    } else { $null }

    $todos = Get-ChildItem -LiteralPath $RaizProjeto -Recurse -File -Force -ErrorAction Stop | Where-Object {
        $rel = $_.FullName.Substring($RaizProjeto.Length).TrimStart('\','/')
        (-not $saidaRelativa -or -not ($rel -eq $saidaRelativa -or $rel.StartsWith($saidaRelativa + '\', [StringComparison]::OrdinalIgnoreCase))) -and
        (-not (Test-Ignorado $rel)) -and
        (-not $_.Attributes.HasFlag([IO.FileAttributes]::ReparsePoint)) -and
        ($IncluirOcultos -or (-not $_.Attributes.HasFlag([IO.FileAttributes]::Hidden) -and -not $_.Attributes.HasFlag([IO.FileAttributes]::System)))
    }

    $grupos = [ordered]@{}
    foreach ($arquivo in ($todos | Sort-Object FullName)) {
        $relativo = $arquivo.FullName.Substring($RaizProjeto.Length).TrimStart('\','/')
        $primeiro = ($relativo -split '[\\/]', 2)[0]
        $modulo = if ($relativo -notmatch '[\\/]') { '_RAIZ_' } else { $primeiro }
        if ($Modulos -and $modulo -ne '_RAIZ_' -and $Modulos -notcontains $modulo) { continue }
        if (-not $grupos.Contains($modulo)) { $grupos[$modulo] = [System.Collections.Generic.List[object]]::new() }
        $grupos[$modulo].Add($arquivo)
    }
    if ($Modulos) {
        $inexistentes = $Modulos | Where-Object { -not $grupos.Contains($_) }
        foreach ($item in $inexistentes) { Write-Log "Modulo solicitado nao encontrado ou vazio: $item" 'AVISO' }
    }
    if ($grupos.Count -eq 0) { throw 'Nenhum arquivo elegivel foi encontrado para exportacao.' }

    $resumo = [System.Collections.Generic.List[object]]::new()
    $manifestoArquivos = [System.Collections.Generic.List[object]]::new()
    $limiteArquivo = [int64]$LimiteArquivoMB * 1MB
    $limiteParte = [int64]$LimiteParteMB * 1MB

    foreach ($entrada in $grupos.GetEnumerator()) {
        $modulo = [string]$entrada.Key
        $arquivos = @($entrada.Value)
        Write-Log "Processando modulo: $modulo ($($arquivos.Count) arquivos)"
        $parte = 1; $partes = 0; $texto = 0; $binarios = 0; $grandes = 0; $sensiveis = 0; $erros = 0
        $blocos = [System.Collections.Generic.List[string]]::new()
        $bytesAtuais = 0L
        $nomeBase = 'PROJETO_' + (Get-NomeSeguro $modulo).ToUpperInvariant()

        $salvarParte = {
            if ($blocos.Count -eq 0) { return }
            $cabecalho = "# Projeto - $modulo`n`nGerado em: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')`n`nParte $parte`n`n---`n"
            $nome = '{0}_parte{1:D3}.md' -f $nomeBase, $parte
            Write-TextoAtomico (Join-Path $PastaSaida $nome) ($cabecalho + ($blocos -join ''))
            $partes++; $parte++; $blocos.Clear(); $bytesAtuais = 0L
        }

        $indice = 0
        foreach ($arquivo in $arquivos) {
            $indice++
            Write-Progress -Activity "Exportando $modulo" -Status "$indice de $($arquivos.Count)" -PercentComplete (100 * $indice / [Math]::Max(1, $arquivos.Count))
            $relativo = $arquivo.FullName.Substring($RaizProjeto.Length).TrimStart('\','/').Replace('\','/')
            $status = 'texto'; $detalhe = $null
            try {
                if (Test-Sensivel $arquivo) {
                    $sensiveis++; $status = 'sensivel_ignorado'; $bloco = "`n## $relativo`n`n*(Arquivo sensivel ignorado por seguranca.)*`n"
                } elseif ($arquivo.Length -gt $limiteArquivo) {
                    $grandes++; $status = 'grande_ignorado'; $bloco = "`n## $relativo`n`n*(Arquivo ignorado: $([Math]::Round($arquivo.Length / 1MB, 2)) MB; limite: $LimiteArquivoMB MB.)*`n"
                } elseif (Test-Texto $arquivo) {
                    $conteudo = Read-TextoSeguro $arquivo.FullName
                    $fence = Get-FenceSegura $conteudo
                    $linguagem = $arquivo.Extension.TrimStart('.').ToLowerInvariant()
                    $bloco = "`n## $relativo`n`n$fence$linguagem`n$conteudo`n$fence`n"
                    $texto++
                } else {
                    $binarios++; $status = 'binario'; $bloco = "`n## $relativo`n`n*(Arquivo binario ou formato nao suportado; $([Math]::Round($arquivo.Length / 1KB, 1)) KB.)*`n"
                }
            } catch {
                $erros++; $status = 'erro'; $detalhe = $_.Exception.Message
                $bloco = "`n## $relativo`n`n*(Erro ao ler arquivo: $detalhe)*`n"
                Write-Log "$relativo - $detalhe" 'AVISO'
            }
            $bytesBloco = $utf8SemBom.GetByteCount($bloco)
            if ($blocos.Count -gt 0 -and ($bytesAtuais + $bytesBloco) -gt $limiteParte) { . $salvarParte }
            $blocos.Add($bloco); $bytesAtuais += $bytesBloco
            $manifestoArquivos.Add([pscustomobject]@{ caminho = $relativo; bytes = $arquivo.Length; status = $status; detalhe = $detalhe })
        }
        . $salvarParte
        Write-Progress -Activity "Exportando $modulo" -Completed
        $resumo.Add([pscustomobject]@{ Modulo=$modulo; Arquivos=$arquivos.Count; Texto=$texto; Binarios=$binarios; Grandes=$grandes; Sensiveis=$sensiveis; Erros=$erros; Partes=$partes })
    }

    $index = "# Indice da Exportacao`n`nGerado em: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')`n`n| Modulo | Arquivos | Texto | Binarios | Grandes | Sensiveis | Erros | Partes |`n|---|---:|---:|---:|---:|---:|---:|---:|`n"
    foreach ($r in $resumo) { $index += "| $($r.Modulo.Replace('|','\|')) | $($r.Arquivos) | $($r.Texto) | $($r.Binarios) | $($r.Grandes) | $($r.Sensiveis) | $($r.Erros) | $($r.Partes) |`n" }
    Write-TextoAtomico (Join-Path $PastaSaida 'INDEX.md') $index

    $manifesto = [ordered]@{
        versao = 2; geradoEm = (Get-Date).ToString('o'); raizProjeto = $RaizProjeto; pastaSaida = $PastaSaida
        configuracao = [ordered]@{ limiteArquivoMB=$LimiteArquivoMB; limiteParteMB=$LimiteParteMB; incluirOcultos=[bool]$IncluirOcultos; incluirArquivosSensiveis=[bool]$IncluirArquivosSensiveis }
        resumo = @($resumo); arquivos = @($manifestoArquivos)
    }
    Write-TextoAtomico (Join-Path $PastaSaida 'MANIFESTO.json') ($manifesto | ConvertTo-Json -Depth 6)
    $totalErros = ($resumo | Measure-Object Erros -Sum).Sum
    Write-Log "Concluido: $($manifestoArquivos.Count) arquivos catalogados, $totalErros erro(s)."
    Write-Host "`nExportacao criada em: $PastaSaida" -ForegroundColor Green
    if ($AbrirSaida -and (Test-Path -LiteralPath $PastaSaida)) {
        Start-Process -FilePath 'explorer.exe' -ArgumentList ('"{0}"' -f $PastaSaida)
    }
    if ($totalErros -gt 0) { exit 2 }
    exit 0
} catch {
    Write-Log $_.Exception.Message 'ERRO'
    exit 1
}
