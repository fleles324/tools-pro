# TOOLS PRO

![version](https://img.shields.io/badge/version-v1.1.7-blue) ![platform](https://img.shields.io/badge/platform-Windows-0078D6?logo=windows) ![language](https://img.shields.io/badge/language-AutoIt-green) ![license](https://img.shields.io/badge/license-TBD-lightgrey)

TOOLS PRO é um launcher híbrido para Windows que organiza, protege e executa softwares de jogos e técnicos com uma interface simples por abas. Foca em praticidade, segurança e atualização automática.

## Visão Geral
- Abas: GAME, TECH, TOOL, FOLDER, INFO e CONFIG
- Cabeçalho informativo com data fixa à esquerda e dicas ao centro (hora no título)
- Atualização automática via GitHub com barra de progresso
- Proteção por senha mestra e verificação de integridade (SHA-256)
- Integração com WinRAR para empacotar/validar pacotes técnicos
- Logs de eventos para auditoria básica

## Funcionalidades
- GAME: lista e executa jogos rapidamente
- TECH: empacota, extrai e roda softwares técnicos protegidos (WinRAR)
- TOOL: centraliza ferramentas administrativas e de TI
- FOLDER: acesso a pastas restritas com autenticação; suporte a ocultar/mostrar pastas
- INFO: identidade visual, versão e créditos
- CONFIG: trocar senha mestra, abrir pasta de programas, verificar atualizações

## Atualizações
- Verifica versão mais recente no GitHub (releases)
- Baixa automaticamente o instalador/atualização
- Exibe barra de progresso com percentual e tamanho aproximado

## Segurança
- Senha mestra para ações sensíveis
- Hash SHA-256 para validar integridade de arquivos
- Preferência por caminhos absolutos para reduzir erros
- Evita incluir segredos/credenciais no repositório público

## Uso
1. Abra o aplicativo e escolha a aba desejada
2. Clique em “ADD” para adicionar itens; a categoria é pré-selecionada conforme a aba
3. Em “CONFIG”, verifique atualizações ou ajuste a senha mestra
4. Em “FOLDER”, acesse pastas restritas com autenticação

## Screenshots
- Imagem principal:
![Aplicativo](Screenshot/app.png)
- Cabeçalho:
![Cabeçalho](Screenshot/header.png)

## Requisitos
- Windows
- Permissões para executar scripts e acessar pastas
- WinRAR (opcional) para fluxos técnicos de compactação

## Destaques da v1.1.7
- Cabeçalho redesenhado; abas alinhadas e conteúdo com offset consistente
- Hora em tempo real no título da janela
- Tela “Novo Registro” com categoria pré-selecionada pela aba ativa
- Diálogo “Novo” tem botão “Fechar” que encerra apenas o diálogo
- Ajustes nas abas INFO e CONFIG para evitar conteúdo colado no topo

## Licença
Defina a licença do projeto (ex.: MIT, GPL, proprietária) conforme sua necessidade.
