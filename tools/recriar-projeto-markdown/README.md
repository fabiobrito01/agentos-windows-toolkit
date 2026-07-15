# Recriador de Projeto a partir de Markdown

Reconstrói pastas e arquivos textuais a partir do ZIP ou da pasta `Exportacao_IA` criada pelo Gerador de Markdown Modular Robusto.

## Uso recomendado

- Se você possui um ZIP, execute `RECRIAR_DE_ZIP.cmd`.
- Se possui a pasta com os arquivos `.md`, execute `RECRIAR_DE_PASTA.cmd`.
- Escolha sempre uma pasta nova e vazia como destino.

Na primeira janela escolha a **fonte**: o ZIP ou a pasta `Exportacao_IA` que contém arquivos `PROJETO_*_parteNNN.md`. Na segunda janela escolha **outra pasta**, nova ou vazia, para receber o projeto. Não selecione a pasta desta ferramenta como fonte.

O programa valida cada escolha. Se a fonte não contiver partes reconhecíveis ou se uma `Exportacao_IA` for escolhida como destino, ele mostrará um aviso e permitirá escolher novamente.

Ao terminar, consulte `RELATORIO_RECRIACAO.md` e `RELATORIO_RECRIACAO.json` no projeto reconstruído.

## Limite inevitável

O exportador armazena o conteúdo integral dos arquivos textuais. Arquivos binários, sensíveis, grandes ou que falharam na leitura são apenas registrados e não podem ser reconstruídos a partir do Markdown. O relatório identifica esses itens.

## Segurança

- Caminhos absolutos e tentativas de sair da pasta de destino são bloqueados.
- Arquivos existentes não são substituídos por padrão.
- Para substituir arquivos existentes, use `-Sobrescrever` pela linha de comando.
- A gravação de cada arquivo é atômica para reduzir o risco de arquivos incompletos.

## Linha de comando

```powershell
.\RECRIAR_PROJETO_DE_MARKDOWN.ps1 `
  -Fonte "D:\Exportacao_IA.zip" `
  -Destino "D:\Projeto_Recriado"
```

Simular sem criar os arquivos:

```powershell
.\RECRIAR_PROJETO_DE_MARKDOWN.ps1 `
  -Fonte "D:\Exportacao_IA" `
  -Destino "D:\Projeto_Recriado" `
  -Simular
```

Códigos de saída: `0` sucesso, `1` falha fatal, `2` concluído com erros individuais e `3` cancelado.
