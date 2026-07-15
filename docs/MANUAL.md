# Manual do AgentOS Toolbox

## Como escolher uma ferramenta

Use o [catálogo interativo](../index.html) para pesquisar por nome e filtrar por categoria ou risco. Cada cartão abre o código-fonte correspondente; leia-o antes de executar.

## Níveis de risco

| Nível | Significado | Prática recomendada |
|---|---|---|
| Baixo | Consulta informações ou cria saída separada. | Confira a pasta de saída. |
| Moderado | Move arquivos, inicia/encerra processos ou usa software externo. | Feche trabalhos abertos e teste com dados descartáveis. |
| Alto | Exclui/espelha dados ou altera Registro, serviços e sistema. | Faça backup, crie ponto de restauração e use VM quando possível. |

## Execução

No Explorer, dê duplo clique em ferramentas simples. Para informar argumentos, abra o Terminal na raiz do projeto:

```cmd
scripts\03_organizar_downloads.bat "D:\MinhaPasta\Downloads"
scripts\35_auditor_imagens.bat "D:\MeuProjeto\assets\images"
scripts\71_backup_nas_incremental.bat "D:\Projetos" "\\servidor\backup"
```

Argumentos com espaços devem ficar entre aspas. Quando um argumento obrigatório não é informado, os scripts atualizados perguntam pelo caminho ou adotam uma pasta do perfil do usuário.

## Administração

Não abra toda a caixa de ferramentas como administrador. Eleve somente o script que precisa dessa permissão. Registro, serviços, DISM, SFC, drivers, USB, NTP e arquivo `hosts` normalmente exigem elevação.

## Dependências opcionais

- Git: automação de commits.
- Docker: limpeza de cache e Compose.
- FFmpeg: extração de áudio.
- MySQL (`mysqldump`): backup de banco.
- SQLite: otimização de banco.
- VeraCrypt: cofre criptografado.
- ADB: coleta de dispositivo Android.
- WinGet: instalação de aplicativos.

## Backup e reversão

Antes de executar uma ferramenta de risco alto:

1. Confirme origem e destino.
2. Faça cópia dos dados importantes.
3. Crie um ponto de restauração quando houver alteração do Windows.
4. Registre o estado anterior de serviços e chaves do Registro.
5. Nunca interrompa DISM, SFC ou operações de disco durante a gravação.

## Solução de problemas

- **Acesso negado:** abra apenas o script necessário como administrador.
- **Comando não encontrado:** instale a dependência indicada e reabra o Terminal.
- **Caminho não encontrado:** use caminho absoluto entre aspas.
- **PowerShell bloqueado:** confira a política da organização; não reduza políticas corporativas sem autorização.
- **Antivírus alertou:** não force a execução. Revise o código e abra uma Issue com o nome do arquivo e o alerta.
