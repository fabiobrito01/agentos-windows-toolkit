# Auditoria para publicação pública

Revisão realizada em 14 de julho de 2026.

## Alterações aplicadas

- Remoção de nomes de usuário, perfil privado, projeto particular e caminhos absolutos do computador de origem.
- Conversão de caminhos para argumentos, perguntas interativas, `%USERPROFILE%` ou diretório atual.
- Remoção de senha MySQL da linha de comando; o cliente agora solicita a senha.
- Remoção do ZIP duplicado do recriador, reduzindo risco de conteúdo desatualizado.
- Organização dos scripts e ferramentas em pastas previsíveis.
- Inclusão de licença, política de segurança, guia de contribuição, manual e portal pesquisável.

## Ferramentas não publicadas

Dez protótipos foram retirados porque a finalidade ou implementação não atendia ao padrão de uma caixa de ferramentas pública: cofre sem criptografia, botão de disfarce, revelação de senha Wi-Fi, FTP com senha em texto puro, bloqueio de Windows Update, encerramento automático por CPU, desativação ampla de telemetria, remoção forçada, bloqueio de executáveis via Registro e desinstalação agressiva de aplicativos.

## Limites da revisão

Scripts Batch dependem do ambiente, idioma e versão do Windows. A revisão estática reduz riscos conhecidos, mas não garante compatibilidade com todo hardware, política corporativa ou versão futura. Ferramentas de alto risco devem ser testadas em máquina virtual antes do uso em produção.
