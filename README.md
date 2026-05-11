<div align="center">

# 🃏 Banco de Piadas e Trocadilhos

**Sistema desktop para cadastro, importação e exportação de piadas e trocadilhos**

[![Delphi](https://img.shields.io/badge/Delphi-VCL-EE1F35?style=for-the-badge&logo=delphi&logoColor=white)](https://www.embarcadero.com/products/delphi)
[![SQL Server](https://img.shields.io/badge/SQL_Server-Express-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/pt-br/sql-server/sql-server-downloads)
[![FireDAC](https://img.shields.io/badge/FireDAC-Database_Layer-0078D4?style=for-the-badge)](https://docwiki.embarcadero.com/RADStudio/en/FireDAC)
[![Windows](https://img.shields.io/badge/Windows-Desktop_App-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/pt-br/windows)

---

> 🎯 **Desafio:** Banco de Piadas e Trocadilhos &nbsp;·&nbsp; 📥 **Entrada:** XML &nbsp;·&nbsp; 📤 **Saída:** CSV

</div>

---

## 📋 Índice

- [Objetivo](#-objetivo)
- [Tecnologias Utilizadas](#️-tecnologias-utilizadas)
- [Pré-requisitos](#-pré-requisitos)
- [Como Executar](#-como-executar)
- [Configuração via config.ini](#-configuração-via-configini)
- [Como Importar / Exportar Dados](#-como-importar--exportar-dados)
- [Funcionalidades](#-funcionalidades)
- [Estrutura do Projeto](#-estrutura-do-projeto)

---

## 🎯 Objetivo

Aplicação desktop desenvolvida em **Delphi (VCL)** como parte de um **desafio de estágio em desenvolvimento de sistemas**.

O sistema realiza o gerenciamento completo de um banco de piadas e trocadilhos, com suporte a:

- Cadastro e manutenção manual de registros
- **Importação em lote** via arquivos `.XML`
- **Exportação filtrada** dos dados para `.CSV`
- Persistência relacional no **SQL Server** via **FireDAC**

> **Combinação sorteada:** Entrada `XML` → Saída `CSV`

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Função |
|---|---|
| **Delphi VCL** | Framework principal da aplicação desktop |
| **FireDAC + MSSQL Driver** | Acesso ao banco de dados (queries, transações, conexão) |
| **SQL Server Express** | Banco de dados relacional para persistência |
| **Xml.XMLDoc / Xml.XMLIntf** | Leitura e importação de piadas em lote via XML |
| **TStringList** | Geração e gravação do arquivo CSV |
| **System.IniFiles** | Leitura das configurações de conexão via `config.ini` |
| **RxLib** | Componentes visuais extras (RxCurrEdit, RxToolEdit etc.) |
| **PngBitBtn / PngSpeedButton** | Botões com suporte a ícones PNG |

---

## ✅ Pré-requisitos

Antes de compilar ou executar o projeto, certifique-se de ter:

**1. RAD Studio / Delphi**
Versão compatível com VCL, FireDAC e `Vcl.DBGrids`. Durante a instalação, marque o componente **FireDAC** e o driver **MSSQL**.

**2. SQL Server Express**
Baixe em: https://www.microsoft.com/pt-br/sql-server/sql-server-downloads
Ao instalar, anote o **nome da instância** (ex: `MEUPC\SQLEXPRESS`) e habilite o **SQL Server Browser** e o protocolo **TCP/IP** no SQL Server Configuration Manager.

**3. Componentes de terceiros**

| Pacote | Como obter |
|---|---|
| **RxLib** | https://github.com/bgolovan/rxlib |
| **PngBitBtn / PngSpeedButton** | Incluídos em `Win32/Debug/` como `.dcu` — instale o pacote no Delphi |

> ⚠️ Sem esses componentes instalados, o projeto não abrirá corretamente no IDE.

---

## ▶️ Como Executar

### Passo 1 — Baixar Programa

- Baixe os arquivos localizados nesse repositório na aba "Releases" ou no link a seguir:
- `https://github.com/MateusGalhardo/Banco-de-Piadas-e-Trocadilhos/releases`

### Passo 2 — Configurar a conexão

Edite o arquivo `config.ini` conforme descrito na seção abaixo.

### Passo 3 — Compilar e executar

```
1. Abra o arquivo Piadas.exe
2. Confirme que os componentes de terceiros estão instalados
3. O banco de dados e tabelas necessárias serão criados automáticamente
```

> O executável compilado fica em `Win32/Debug/Piadas.exe` e pode ser distribuído para outras máquinas Windows sem instalar o Delphi, desde que o SQL Server esteja acessível.

---

## ⚙️ Configuração via config.ini

O arquivo `Win32/Debug/config.ini` centraliza todas as configurações de conexão com o banco de dados. Ele é lido automaticamente pelo sistema na inicialização (O banco `master` é apenas a base, ao executar o programa um novo banco é criado para o uso).

**Localização:** `Win32/Debug/config.ini`

```ini
[DB]
Server=NOME_DO_SEU_SERVIDOR\SQLEXPRESS
Database=master
OSAuthent=1
DriverID=MSSQL
User=
Password=
```

### Descrição dos parâmetros

| Parâmetro | Descrição | Exemplo |
|---|---|---|
| `Server` | Nome do servidor e instância do SQL Server | `MEUPC\SQLEXPRESS` |
| `Database` | Nome do banco de dados criado | `master` |
| `OSAuthent` | `1` = usa autenticação Windows · `0` = usa usuário/senha | `1` |
| `DriverID` | Driver de conexão — manter `MSSQL` | `MSSQL` |
| `User` | Usuário SQL (somente se `OSAuthent=0`) | `sa` |
| `Password` | Senha SQL (somente se `OSAuthent=0`) | `senha123` |

### Exemplos de configuração

**Autenticação Windows (recomendado):**
```ini
[DB]
Server=MEUPC\SQLEXPRESS
Database=master
OSAuthent=1
DriverID=MSSQL
User=
Password=
```

**Autenticação SQL Server (usuário/senha):**
```ini
[DB]
Server=MEUPC\SQLEXPRESS
Database=master
OSAuthent=0
DriverID=MSSQL
User=sa
Password=minhasenha
```

> 💡 Com `OSAuthent=1`, o sistema utiliza o **usuário Windows logado** para autenticar. Certifique-se de que esse usuário tem permissão no banco. Se o servidor estiver em rede, use o nome completo: `SERVIDOR\INSTANCIA` ou o IP.

---

## 📥 Como Importar / Exportar Dados

### Importando um XML

1. Na tela principal, clique no botão **Importar** (ícone XML 🟠)
2. Selecione o arquivo `.xml` no seu computador
3. O sistema processa cada registro e exibe um log com quantas piadas foram **inseridas** e quantas foram **ignoradas**

**Motivos para um registro ser ignorado:**
- Campo obrigatório vazio (`texto`, `categoria`, `tipo` ou `classificacao`)
- Piada já existente no banco (comparação sem distinção de maiúsculas)
- Classificação com valor inválido (não encontrado em `Classificacoes`)

**Estrutura obrigatória do arquivo XML:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<piadas>
  <piada>
    <texto>Por que o livro de matemática estava triste? Porque tinha muitos problemas.</texto>
    <categoria>Escola</categoria>
    <tipo>Piada</tipo>
    <classificacao>Livre</classificacao>
  </piada>
  <piada>
    <texto>O trocadilho que você fez foi muito bom... de não fazer.</texto>
    <categoria>Linguagem</categoria>
    <tipo>Trocadilho</tipo>
    <classificacao>12+</classificacao>
  </piada>
</piadas>
```

> ⚠️ O nó raiz **deve** se chamar `<piadas>` e cada item **deve** se chamar `<piada>`.
> Valores aceitos para `<classificacao>`: `Livre`, `12+`, `16+`, `18+`

---

### Exportando para CSV

1. Use os filtros de pesquisa para exibir os dados desejados (ou deixe em branco para exportar tudo)
2. Clique no botão **Exportar** (ícone CSV 🟢)
3. Escolha onde salvar — o nome padrão sugerido é `Piadas.csv`

**Formato do arquivo gerado (separador `;`):**

```
Codigo;Piada;Categoria;Tipo;DataCadastro;Classificacao
1;Por que o livro de matemática estava triste?...;Escola;Piada;07/05/2026 10:00:00;Livre
2;O trocadilho que você fez foi muito bom...;Linguagem;Trocadilho;07/05/2026 10:01:00;12+
```

> 💡 Para abrir corretamente no Excel, use **Dados > De Texto/CSV** e defina `;` como delimitador.

---

## ✨ Funcionalidades

- 📝 **Cadastro manual** de piadas com texto, categoria, tipo e classificação indicativa
- ✏️ **Edição** de registros via duplo clique na grade ou pelo botão Alterar
- 🗑️ **Exclusão** com confirmação antes de apagar
- 🔍 **Pesquisa dinâmica** combinando texto, categoria e tipo simultaneamente
- 🔃 **Ordenação por coluna** — clique no cabeçalho da grade para ordenar pelo campo desejado
- 📥 **Importação em lote via XML** com validação completa e log de registros ignorados
- 📤 **Exportação para CSV** do conjunto de dados exibido na grade no momento
- 🚫 **Prevenção de duplicatas** automática na importação (comparação case-insensitive)
- 🏷️ **Classificação indicativa** gerenciada via lookup: `Livre`, `12+`, `16+`, `18+`
- ⚙️ **Conexão configurável** via arquivo `config.ini`, sem necessidade de recompilar
- 🗂️ **Interface com abas** separando listagem e manutenção de registros
- 🎨 **Grade com linhas alternadas** e destaque visual na linha selecionada

---

## 📁 Estrutura do Projeto

```
Projeto Desafio/
│
├── 📄 Piadas.dpr                  # Arquivo principal do projeto Delphi
├── 📄 uCadPiadas.pas / .dfm       # Formulário principal (cadastro, pesquisa, importação, exportação)
├── 📄 uDTMPiadas.pas / .dfm       # DataModule com a conexão FireDAC ao SQL Server
├── 📄 cCadPiadas.pas              # Classe TPiadas (regras de negócio: inserir, atualizar, apagar, selecionar)
│
├── 📁 Tabelas/
│   ├── cAtualizaDB.pas            # Gerenciamento de versão/atualização do banco
│   └── cAtualizaTabelasSQL.pas    # Scripts SQL para criação/atualização de tabelas
│
├── 📁 SQL/
│   └── SQLUsado.sql               # Script de criação das tabelas e dados iniciais
│
├── 📁 Images/
│   ├── icons8-xml-16.png          # Ícone do botão Importar
│   ├── icons8-csv-16.png          # Ícone do botão Exportar
│   ├── icons8-search-16.png       # Ícone do botão Pesquisar
│   └── icons8-broom-16.png        # Ícone do botão Limpar
│
└── 📁 Win32/Debug/
    ├── Piadas.exe                 # Executável compilado (Windows 32-bit)
    └── config.ini                 # Arquivo de configuração da conexão com o banco
```
