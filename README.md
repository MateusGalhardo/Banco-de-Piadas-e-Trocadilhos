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

- [Sobre o Projeto](#-sobre-o-projeto)
- [Tecnologias](#-tecnologias)
- [Pré-requisitos](#-pré-requisitos)
- [Configuração do Banco de Dados](#-configuração-do-banco-de-dados)
- [Configuração da Conexão no Delphi](#-configuração-da-conexão-no-delphi)
- [Como Compilar e Executar](#-como-compilar-e-executar)
- [Importar e Exportar Dados](#-importar-e-exportar-dados)
- [Funcionalidades](#-funcionalidades)
- [Estrutura do Projeto](#-estrutura-do-projeto)

---

## 💡 Sobre o Projeto

Aplicação desktop desenvolvida em **Delphi (VCL)** que permite o gerenciamento completo de um banco de piadas e trocadilhos. O sistema suporta cadastro manual, importação em lote via arquivos `.XML` e exportação de dados filtrados para `.CSV`, com persistência em **SQL Server** via **FireDAC**.

---

## 🛠️ Tecnologias

| Tecnologia | Função |
|---|---|
| **Delphi VCL** | Framework principal da aplicação desktop |
| **FireDAC + MSSQL Driver** | Acesso ao banco de dados (queries, transações, conexão) |
| **SQL Server Express** | Banco de dados relacional para persistência |
| **Xml.XMLDoc / Xml.XMLIntf** | Leitura e importação de piadas em lote via XML |
| **TStringList** | Geração e gravação do arquivo CSV |
| **RxLib** | Componentes visuais extras (RxCurrEdit, RxToolEdit etc.) |
| **PngBitBtn / PngSpeedButton** | Botões com suporte a ícones PNG |

---

## ✅ Pré-requisitos

Certifique-se de ter os seguintes itens instalados e configurados antes de abrir o projeto:

### 1. RAD Studio / Delphi
- Versão compatível com VCL, FireDAC e `Vcl.DBGrids`
- Durante a instalação, marque o componente **FireDAC** e o driver **MSSQL**

### 2. SQL Server Express
- Baixe gratuitamente em: https://www.microsoft.com/pt-br/sql-server/sql-server-downloads
- Durante a instalação, anote o **nome da instância** (ex: `MEUPC\SQLEXPRESS`)
- Habilite o **SQL Server Browser** e o protocolo **TCP/IP** no SQL Server Configuration Manager

### 3. Componentes de terceiros
Os seguintes pacotes precisam estar instalados no Delphi:

| Pacote | Como obter |
|---|---|
| **RxLib** | https://github.com/bgolovan/rxlib |
| **PngBitBtn / PngSpeedButton** | Incluídos na pasta `Win32/Debug/` como `.dcu` — instale o pacote no Delphi |

> ⚠️ **Atenção:** sem esses componentes instalados, o projeto não abrirá corretamente no IDE.

---

## 🗄️ Configuração do Banco de Dados

### Passo 1 — Criar o banco

No **SQL Server Management Studio (SSMS)** ou via query, execute:

```sql
CREATE DATABASE piadas;
```

### Passo 2 — Executar o script do projeto

Abra o arquivo `SQL/SQLUsado.sql` e execute-o no banco `piadas`. Ele cria as tabelas e insere os dados iniciais:

```sql
-- Tabela de classificações indicativas
CREATE TABLE Classificacoes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    classificacao NVARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO Classificacoes (classificacao)
VALUES ('Livre'), ('12+'), ('16+'), ('18+');

-- Tabela principal de piadas
CREATE TABLE Piadas (
    piadaId         INT IDENTITY(1,1) PRIMARY KEY,
    texto           NVARCHAR(800) NOT NULL,
    categoria       NVARCHAR(100) NOT NULL,
    tipo            NVARCHAR(50)  NOT NULL,
    classificacaoId INT NOT NULL,
    dataPiada       DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT uq_piadas_texto UNIQUE (texto),
    CONSTRAINT fk_piadas_classificacao
        FOREIGN KEY (classificacaoId) REFERENCES Classificacoes(Id)
);
```

---

## 🔌 Configuração da Conexão no Delphi

A conexão com o banco está definida no arquivo `uDTMPiadas.dfm`. Você precisa ajustá-la para apontar para o seu SQL Server.

### Opção A — Pelo IDE (recomendado)

1. Abra o projeto no Delphi
2. Acesse o **DataModule** `uDTMPiadas` (clique duas vezes em `uDTMPiadas.pas`)
3. Selecione o componente `conexaoPiadas` (do tipo `TFDConnection`)
4. No **Object Inspector**, edite a propriedade `Params`:

| Parâmetro | Valor padrão no projeto | O que alterar |
|---|---|---|
| `DriverID` | `MSSQL` | Manter |
| `Server` | `DC-TR-07-VM\SQLEXPRESS` | **Trocar pelo seu servidor** (ex: `MEUPC\SQLEXPRESS`) |
| `Database` | `piadas` | Manter (ou ajustar se criou com outro nome) |
| `OSAuthent` | `Yes` | Manter para usar autenticação Windows |

> 💡 `OSAuthent=Yes` utiliza o **usuário Windows logado** para autenticar no banco. Certifique-se de que esse usuário tem permissão de acesso. Se preferir usar usuário/senha do SQL Server, altere para `OSAuthent=No` e adicione os parâmetros `User_Name` e `Password`.

### Opção B — Editar o .dfm diretamente

Abra `uDTMPiadas.dfm` em qualquer editor de texto e altere a linha:

```
'Server=DC-TR-07-VM\SQLEXPRESS'
```

para o nome do seu servidor:

```
'Server=SEU_COMPUTADOR\SQLEXPRESS'
```

---

## ▶️ Como Compilar e Executar

```
1. Abra o arquivo  Piadas.dpr  no RAD Studio
2. Verifique se os componentes de terceiros estão instalados (RxLib, PngBitBtn)
3. Ajuste a conexão conforme descrito acima
4. Pressione  F9  ou clique em  Run > Run  para compilar e executar
```

> O executável compilado fica em `Win32/Debug/Piadas.exe` e pode ser distribuído para outras máquinas Windows **sem precisar instalar o Delphi** — desde que o SQL Server esteja acessível na rede e a string de conexão esteja correta.

---

## 📥 Importar e Exportar Dados

### Importando um XML

1. Na tela principal, clique no botão **Importar** (ícone XML 🟠)
2. Selecione o arquivo `.xml` no seu computador
3. O sistema processa cada registro e exibe um log com quantas piadas foram **inseridas** e quantas foram **ignoradas**

**Motivos para um registro ser ignorado:**
- Campo obrigatório vazio (`texto`, `categoria`, `tipo` ou `classificacao`)
- Piada duplicada — texto já existe no banco (comparação sem distinção de maiúsculas)
- Classificação inválida — valor não encontrado na tabela `Classificacoes`

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

1. Use os filtros de pesquisa para exibir apenas os dados desejados (ou deixe em branco para exportar tudo)
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
- 📥 **Importação em lote via XML** com validação completa e log de erros por registro
- 📤 **Exportação para CSV** do conjunto de dados exibido na grade no momento
- 🚫 **Prevenção de duplicatas** automática na importação (comparação case-insensitive)
- 🏷️ **Classificação indicativa** gerenciada via lookup: `Livre`, `12+`, `16+`, `18+`
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
    └── Piadas.exe                 # Executável compilado (Windows 32-bit)
```
