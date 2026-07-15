# Manual de uso — Gerador de Markdown Modular Robusto

## 1. Para que serve

A ferramenta percorre um projeto, identifica arquivos de texto e código-fonte e reúne o conteúdo em arquivos Markdown. Projetos grandes são automaticamente separados em módulos e partes menores.

Ela não altera o código-fonte do projeto. Apenas cria ou atualiza a pasta de saída.

## 2. Como levar para outro computador

Copie a pasta `GERAR_MARKDOWN_MODULAR_ROBUSTO` inteira, por pendrive, rede, nuvem ou arquivo ZIP. Não separe os arquivos internos. Nenhum caminho do computador original fica gravado na ferramenta.

No computador de destino, extraia o ZIP para qualquer local, como Área de Trabalho, Documentos ou outra unidade. Não é necessário instalar.

## 3. Uso normal, recomendado

1. Abra a pasta da ferramenta.
2. Execute `EXECUTAR_EXPORTACAO.cmd` com dois cliques.
3. O Windows abrirá um seletor de pastas.
4. Selecione a pasta principal do projeto, aquela que contém os arquivos e subpastas que deseja exportar.
5. Aguarde o processamento.
6. Ao final, o Explorador de Arquivos abrirá `Exportacao_IA`, criada dentro do projeto.

Se cancelar o seletor, nada será criado ou alterado.

## 4. Resultado da exportação

| Arquivo | Função |
|---|---|
| `INDEX.md` | Mostra os módulos e as quantidades processadas. |
| `PROJETO_*_parteNNN.md` | Contém os caminhos e conteúdos dos arquivos do projeto. |
| `MANIFESTO.json` | Registra cada arquivo, tamanho, estado e possíveis erros. |
| `exportacao.log` | Registra horários, etapas, avisos e falhas. |

Uma exportação nova substitui somente os artefatos gerados anteriormente. Outros arquivos colocados manualmente em `Exportacao_IA` não são apagados.

## 5. Proteções automáticas

A ferramenta ignora, por padrão:

- dependências e caches, como `node_modules`, `.dart_tool`, `.gradle` e `.venv`;
- compilações, como `build`, `dist`, `bin` e `obj`;
- controles internos, como `.git` e `.idea`;
- arquivos binários, que são apenas relacionados no Markdown;
- arquivos individuais acima de 5 MB;
- `.env`, chaves privadas, certificados, credenciais e arquivos com nomes que indiquem segredos;
- a própria pasta `Exportacao_IA`, evitando exportação recursiva.

Nunca publique a exportação sem revisar seu conteúdo. Segredos podem existir em arquivos com nomes inesperados.

## 6. Uso avançado pelo PowerShell

Abra o PowerShell na pasta da ferramenta e execute:

```powershell
.\GERAR_MARKDOWN_MODULAR_ROBUSTO.ps1 -RaizProjeto "C:\Projetos\MeuSistema" -LimparSaida
```

Escolher outra pasta de saída:

```powershell
.\GERAR_MARKDOWN_MODULAR_ROBUSTO.ps1 `
  -RaizProjeto "D:\Projetos\MeuSistema" `
  -PastaSaida "E:\Exportacoes\MeuSistema" `
  -LimparSaida
```

Exportação automatizada, sem barra de progresso:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File ".\GERAR_MARKDOWN_MODULAR_ROBUSTO.ps1" `
  -RaizProjeto "D:\Projetos\MeuSistema" `
  -PastaSaida "D:\Exportacoes\MeuSistema" `
  -LimparSaida -SemProgresso
```

## 7. Parâmetros disponíveis

| Parâmetro | Explicação |
|---|---|
| `-RaizProjeto` | Pasta principal do projeto. |
| `-PastaSaida` | Destino da exportação. Se omitido, usa `Exportacao_IA` dentro do projeto. |
| `-SelecionarPasta` | Abre o seletor visual de projetos. |
| `-AbrirSaida` | Abre a pasta de saída ao terminar. |
| `-Modulos app,api` | Exporta apenas os módulos informados e os arquivos da raiz. |
| `-LimiteArquivoMB 5` | Limite para um arquivo individual. |
| `-LimiteParteMB 2` | Tamanho-alvo de cada Markdown. Um único arquivo pode ultrapassar o limite. |
| `-LimparSaida` | Remove artefatos antigos da ferramenta antes de gerar os novos. |
| `-SemProgresso` | Oculta a barra de progresso, útil em automações. |
| `-IncluirOcultos` | Inclui arquivos ocultos, mantendo caches e builds ignorados. |
| `-IncluirArquivosSensiveis` | Inclui possíveis segredos. Não recomendado. |

## 8. Códigos para automação

| Código | Significado |
|---:|---|
| `0` | Exportação concluída sem erros. |
| `1` | Falha fatal, como pasta inexistente ou falta de permissão. |
| `2` | Exportação concluída, mas algum arquivo não pôde ser lido. |
| `3` | Seleção de pasta cancelada pelo usuário. |

## 9. Solução de problemas

### O Windows bloqueou o arquivo CMD

Clique com o botão direito no arquivo, escolha **Propriedades**, marque **Desbloquear** se essa opção existir e confirme. Também é possível executar o comando PowerShell mostrado neste manual.

### Acesso negado

Escolha um projeto no qual seu usuário tenha permissão de leitura e gravação. Como alternativa, informe uma `-PastaSaida` em Documentos ou em outra pasta permitida.

### Um arquivo não apareceu com conteúdo

Consulte `MANIFESTO.json` e `exportacao.log`. O arquivo pode ser binário, grande, sensível, oculto ou pertencer a uma pasta ignorada.

### A exportação ficou grande

Reduza `-LimiteParteMB`, selecione módulos com `-Modulos` ou revise se o projeto contém pastas geradas que deveriam ser ignoradas.

### Quero usar em Linux ou macOS

O núcleo é PowerShell, mas o lançador visual foi preparado para Windows. Em outros sistemas com PowerShell 7, use o script pela linha de comando com `-RaizProjeto` e `-PastaSaida`; o seletor visual e a abertura pelo Explorer não se aplicam.

## 10. Exemplo completo

Para um projeto em `D:\Projetos\Loja`, a execução padrão cria:

```text
D:\Projetos\Loja\Exportacao_IA\
  INDEX.md
  MANIFESTO.json
  exportacao.log
  PROJETO__RAIZ__parte001.md
  PROJETO_APP_parte001.md
  PROJETO_API_parte001.md
```

Guarde a pasta da ferramenta separada dos projetos. Ela pode ser reutilizada quantas vezes quiser.
