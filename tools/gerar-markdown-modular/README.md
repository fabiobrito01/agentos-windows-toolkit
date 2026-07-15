# Gerador de Markdown Modular Robusto — portátil

Ferramenta para transformar o conteúdo de qualquer projeto de software em documentos Markdown organizados, adequados para análise, documentação, backup textual e envio a ferramentas de inteligência artificial.

Não precisa ser instalada e não possui caminhos fixos. Copie a pasta inteira para outro computador Windows e execute normalmente.

## Começar em três passos

1. Dê dois cliques em `EXECUTAR_EXPORTACAO.cmd`.
2. Na janela que abrir, selecione a pasta raiz do projeto.
3. Aguarde. Ao terminar, a pasta `Exportacao_IA` será aberta automaticamente.

Leia `MANUAL_DE_USO.md` para conhecer todas as opções, cuidados de segurança, automação e solução de problemas.

## Requisitos

- Windows 10 ou Windows 11.
- Windows PowerShell 5.1 ou superior, já incluído no Windows.
- Permissão de leitura no projeto e gravação na pasta escolhida.

## O que será gerado

- `INDEX.md`: resumo por módulo.
- `PROJETO_*_parteNNN.md`: código e textos exportados.
- `MANIFESTO.json`: relação de todos os arquivos e seus estados.
- `exportacao.log`: registro da execução e eventuais avisos.

Arquivos de credenciais e segredos são ignorados por padrão.
