unit uCadPiadas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  RxCurrEdit, Vcl.DBCtrls, RxToolEdit, cCadPiadas, System.IniFiles, Xml.XMLDoc, Xml.XMLIntf, PngSpeedButton, PngBitBtn,
  System.StrUtils, cAtualizaDB;

type
  TcadPiadas = class(TForm)
    pnlRodape: TPanel;
    btnNovo: TBitBtn;
    btnAlterar: TBitBtn;
    btnCancelar: TBitBtn;
    btnGravar: TBitBtn;
    btnApagar: TBitBtn;
    pgcPrincipal: TPageControl;
    tsListagem: TTabSheet;
    pnlListagemTopo: TPanel;
    mskPesquisar: TMaskEdit;
    grdPiadas: TDBGrid;
    tsManutencao: TTabSheet;
    QryPiadas: TFDQuery;
    dsPiadas: TDataSource;
    btnSair: TBitBtn;
    edtPiadaId: TLabeledEdit;
    lkpClassificacao: TDBLookupComboBox;
    QryClassificacoes: TFDQuery;
    dsClassificacoes: TDataSource;
    f1QryClassificacoesId: TFDAutoIncField;
    QryClassificacoesclassificacao: TWideStringField;
    edtPiada: TMemo;
    edtPesTipo: TEdit;
    edtPesCategoria: TEdit;
    dlgAbrirPasta: TOpenDialog;
    f1QryPiadaspiadaId: TFDAutoIncField;
    QryPiadastexto: TWideStringField;
    QryPiadascategoria: TWideStringField;
    QryPiadastipo: TWideStringField;
    QryPiadasdataPiada: TSQLTimeStampField;
    QryPiadasclassificacao: TWideStringField;
    btnPesquisar: TPngBitBtn;
    btnImportar: TPngBitBtn;
    btnExportar: TPngBitBtn;
    btnLimpar: TPngBitBtn;
    dlgSalvarPasta: TSaveDialog;
    lblIndice: TLabel;
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    cbbTipo: TComboBox;
    cbbCategoria: TComboBox;
    lbl6: TLabel;
    lbl7: TLabel;
    tmr1: TTimer;
    lblqualquercoisa: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure grdPiadasDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure btnApagarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure grdPiadasDblClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure grdPiadasTitleClick(Column: TColumn);
    procedure edtPiadaKeyPress(Sender: TObject; var Key: Char);
    procedure edtPiadaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdPiadasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbbTipoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbbCategoriaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbbCategoriaKeyPress(Sender: TObject; var Key: Char);
    procedure cbbTipoKeyPress(Sender: TObject; var Key: Char);
    procedure tsManutencaoShow(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);

    type
    TEstadoDoCadastro = (ecInserir, ecAlterar, ecNenhum);
    TAcaoExcluirEstoque = (aeeApagar, aeeAlterar);

    procedure btnSairClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
  private
    oPiadas:TPiadas;
    procedure ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar: TbitBtn; pgcPrincipal: TPageControl; Flag: Boolean);
    procedure LimparEdits;
    procedure ExibirLabelIndice(Campo: string; aLabel: TLabel);
    function RetornarCampoTraduzido(Campo: string): string;
    function NormalizarTexto(const Texto: string): string;
    function AcharNó(Node: IXMLNode; const Key: string): string;
    function SomenteNumeros(const Texto: string): string;
    procedure ImportarXML(const FileName: string);
    procedure InserirPiada(const Texto, Categoria, Tipo: string; ClassificacaoId: Integer);
    function PuxarClassificacaoId(const Nome: string): Integer;
    function PiadaJaExiste(const Texto: string): Boolean;
    function StringSafe(F: TField): string;
    procedure ExportarCSV(ADataset: TDataSet);
    procedure BloqueiaPontoEVirgula(var Key: Char);
    procedure BloqueiaTeclas(var Key: Word; Shift: TShiftState);
    procedure BloqueiaCTRL_DEL_DBGrid(var Key: Word; Shift: TShiftState);
    function SemEnter(const S: string): string;
    procedure AdicionarItemCombo(Combo: TComboBox; const Valor: string);
    procedure CarregarCombos;
    { Private declarations }
  public
    { Public declarations }
    IndiceAtual:string;
    EstadoDoCadastro:TEstadoDoCadastro;
    function Apagar:Boolean; virtual;
    function Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; virtual;
    procedure ControlarIndiceTab(pgcPrincipal: TPageControl; Indice: Integer);
  end;

var cadPiadas:TcadPiadas;

implementation

uses
  uDTMPiadas;

{$R *.dfm}

function TcadPiadas.Apagar: Boolean;
begin
  if oPiadas.Selecionar(QryPiadas.FieldByName('piadaId').AsInteger) then begin
     Result:=oPiadas.Apagar;
  end;
end;

procedure TcadPiadas.btnAlterarClick(Sender: TObject);
begin
  if f1QryPiadaspiadaId.AsInteger = 0 then begin
    Exit;
  end;

  if oPiadas.Selecionar(QryPiadas.FieldByName('piadaId').AsInteger) then begin
     edtPiadaId.Text:=IntToStr(oPiadas.piadaId);

     edtPiada.Text                  :=oPiadas.Texto;
     cbbCategoria.Text              :=oPiadas.Categoria;
     lkpClassificacao.KeyValue      :=oPiadas.ClassificacaoId;   //puxa todas as informações
     cbbTipo.Text                   :=oPiadas.Tipo;
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;

  //desativa os botões e altera o estado do cadastro
  tsManutencao.TabVisible := True;
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, pgcPrincipal,False);
    EstadoDoCadastro:=ecAlterar;
    btnCancelar.Font.Color := clBlack;
end;

procedure TcadPiadas.btnApagarClick(Sender: TObject);
begin
  if f1QryPiadaspiadaId.AsInteger = 0 then begin
    Exit;
  end;

  Apagar;
  QryPiadas.Close;  //limpa os campos e atualiza a query
  QryPiadas.Open;
end;

procedure TcadPiadas.btnCancelarClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, pgcPrincipal,True);
  ControlarIndiceTab(pgcPrincipal, 0);
  EstadoDoCadastro:=ecNenhum;
  LimparEdits; //define os botões, volta pra pagina de listagem, define o estado do cadastro como nenhum e limpa os campos
  tsManutencao.TabVisible := False;
end;

procedure TcadPiadas.btnExportarClick(Sender: TObject);
begin
  ExportarCSV(QryPiadas); //chama a função pra exportar
end;

procedure TcadPiadas.ExportarCSV(ADataset: TDataSet);
var Lista: TStringList;
begin
  dlgSalvarPasta.FileName := 'Piadas.csv'; //define um nome padrão

  if not dlgSalvarPasta.Execute then //se não executar ele sai
    Exit;

  Lista := TStringList.Create; //cria a stringlist

  try
    Lista.Add('Codigo;Piada;Categoria;Tipo;DataCadastro;Classificacao');  //adiciona todas as colunas no cabeçalho

    ADataset.First;
    while not ADataset.Eof do
    begin
      Lista.Add(      //adiciona todo o conteúdo delas
        ADataset.FieldByName('piadaId').AsString + ';' +
        SemEnter(ADataset.FieldByName('texto').AsString) + ';' + //transforma o enter em espaço
        ADataset.FieldByName('categoria').AsString + ';' +
        ADataset.FieldByName('tipo').AsString + ';' +
        ADataset.FieldByName('dataPiada').AsString + ';' +
        ADataset.FieldByName('classificacao').AsString
      );

      ADataset.Next;
    end;

    Lista.SaveToFile(dlgSalvarPasta.FileName); //salva o arquivo
  finally
    Lista.Free;
    ShowMessage('Exportação realizada com sucesso!');
  end;
end;

procedure TcadPiadas.btnGravarClick(Sender: TObject);
begin
  if Trim(cbbTipo.Text)= '' then begin
    ShowMessage('Insira o Tipo da Piada/Trocadilho');
    Exit;
  end
  else if Trim(cbbCategoria.Text)= '' then begin
    ShowMessage('Insira a Categoria');         //verificações para impedir que o usuário deixe campos vazios
    Exit;
  end
  else if VarIsNull(lkpClassificacao.KeyValue) then begin
    ShowMessage('Insira a Classificação Indicativa');
    Exit;
  end
  else if Trim(edtPiada.Text)= '' then begin
    ShowMessage('Insira sua Piada');
    Exit;
  end;

  if not Gravar(EstadoDoCadastro) then
  begin
    ShowMessage('Erro ao gravar');
    Exit;
  end;

  AdicionarItemCombo(cbbCategoria, cbbCategoria.Text);
  AdicionarItemCombo(cbbTipo, cbbTipo.Text);

  tsManutencao.TabVisible := False;
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, pgcPrincipal, True);
  ControlarIndiceTab(pgcPrincipal, 0);

  EstadoDoCadastro := ecNenhum;
  LimparEdits;                            //define os botões ativos, o estado do cadastro e limpa os campos

  QryPiadas.Close;
  QryPiadas.Open;
end;

procedure TcadPiadas.ImportarXML(const FileName: string);
var XMLDoc: IXMLDocument; RootNode, Node: IXMLNode; I, ClassificacaoId, Inseridos, Ignorados: Integer; Texto, Categoria, Tipo, Classificacao: string; Log: TStringList;
begin
  Inseridos := 0;
  Ignorados := 0;              //define as duas var e cria a stringlist
  Log := TStringList.Create;

  try
    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.LoadFromFile(FileName);        //cria o xmldocument e carrega o arquivo
    XMLDoc.Active := True;

    RootNode := XMLDoc.DocumentElement;  //pega o nó raiz

    //validando se o nó raiz existe
    if (RootNode = nil) or (RootNode.NodeName <> 'piadas') then
      raise Exception.Create('XML inválido: raiz <piadas> não encontrada');

    //percorre os registros
    for I := 0 to RootNode.ChildNodes.Count - 1 do
    begin
      try
        Node := RootNode.ChildNodes[I];

        //lendo os campos
        Texto := Trim(AcharNó(Node, 'texto'));
        Categoria := Trim(AcharNó(Node, 'categoria'));
        Tipo := Trim(AcharNó(Node, 'tipo'));
        Classificacao := Trim(AcharNó(Node, 'classificacao'));

        //validações sendo adicionadas no log caso existam
        if Texto = '' then
        begin
          Inc(Ignorados);
          Log.Add('Registro ' + IntToStr(I+1) + ': texto vazio');
          Continue;
        end;

        if Categoria = '' then
        begin
          Inc(Ignorados);
          Log.Add('Registro ' + IntToStr(I+1) + ': categoria vazia');
          Continue;
        end;

        if Tipo = '' then
        begin
          Inc(Ignorados);
          Log.Add('Registro ' + IntToStr(I+1) + ': tipo vazio');
          Continue;
        end;

        if Classificacao = '' then
        begin
          Inc(Ignorados);
          Log.Add('Registro ' + IntToStr(I+1) + ': classificação vazia');
          Continue;
        end;

        //usei uma função para evitar duplicidade
        if PiadaJaExiste(Texto) then
        begin
          Inc(Ignorados);
          Log.Add('Registro ' + IntToStr(I+1) + ': piada duplicada');
          Continue;
        end;

        //outra função para puxar o ClassificacaoId
        ClassificacaoId := PuxarClassificacaoId(Classificacao);

        if ClassificacaoId = 0 then
        begin
          Inc(Ignorados);
          Log.Add('Registro ' + IntToStr(I+1) + ': classificação inválida (' + Classificacao + ')');
          Continue;
        end;

        //adicionando no banco usando uma procedure
        InserirPiada(Texto, Categoria, Tipo, ClassificacaoId);
        Inc(Inseridos);

      except
        on E: Exception do
        begin         //caso ocorra algum erro na importação essa mensagem de erro é adicionada ao log e a piada é ignorada
          Inc(Ignorados);
          Log.Add('Registro ' + IntToStr(I+1) + ': erro inesperado - ' + E.Message);
          Continue;
        end;
      end;
    end;

    //mensagem do log
    ShowMessage(
      'Importação concluída!' + sLineBreak +
      'Inseridos: ' + IntToStr(Inseridos) + sLineBreak +
      'Ignorados: ' + IntToStr(Ignorados) );

    if Log.Count > 0 then   //se existir algo no log ele mostra a mensagem
      ShowMessage('Detalhes:' + sLineBreak + Log.Text);

  finally
    Log.Free;
  end;
end;

function TcadPiadas.PuxarClassificacaoId(const Nome: string): Integer;
var Qry: TFDQuery;
begin
  Result := 0;  //resultado inicial é 0

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := dtmPiadas.conexaoPiadas;

    Qry.SQL.Text :=
      'SELECT Id FROM Classificacoes WHERE classificacao = :c';

    Qry.ParamByName('c').AsString := Nome; //"nome" é uma coluna na tabela classificacao e aqui defino ela como "c"
    Qry.Open;

    if not Qry.IsEmpty then
      Result := Qry.FieldByName('Id').AsInteger;   //se encontrar a classificacaoId ela se torna o resultado

  finally
    Qry.Free;
  end;
end;

procedure TcadPiadas.btnImportarClick(Sender: TObject);
begin
   if dlgAbrirPasta.Execute then
    ImportarXML(dlgAbrirPasta.FileName); //abre a pasta de arquivos e chama a função de importar XML
end;

procedure TcadPiadas.InserirPiada(const Texto, Categoria, Tipo: string; ClassificacaoId: Integer);
var Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := dtmPiadas.conexaoPiadas;

    Qry.SQL.Text :=
      'INSERT INTO Piadas (texto, categoria, tipo, classificacaoId) ' +
      'VALUES (:texto, :categoria, :tipo, :classificacaoId)';            //insere todos os campos

    Qry.ParamByName('texto').AsString := Texto;
    Qry.ParamByName('categoria').AsString := Categoria;    //define os parametros
    Qry.ParamByName('tipo').AsString := Tipo;
    Qry.ParamByName('classificacaoId').AsInteger := ClassificacaoId;

    Qry.ExecSQL;

  finally
    Qry.Free;
  end;
  QryPiadas.Close;
  QryPiadas.Open;
end;

function TcadPiadas.PiadaJaExiste(const Texto: string): Boolean;
var Qry: TFDQuery;
begin
  Result := False; //resultado inicial é false, ou seja a piada ainda não existe no banco

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := dtmPiadas.conexaoPiadas;

    Qry.SQL.Text :=
      'SELECT 1 FROM Piadas WHERE LOWER(texto) = LOWER(:texto)'; //select ignorando maiúsculas e minúsculas

    Qry.ParamByName('texto').AsString := Texto;
    Qry.Open;

    Result := not Qry.IsEmpty;

  finally
    Qry.Free;
  end;
end;

function TcadPiadas.AcharNó(Node: IXMLNode; const Key: string): string;
begin
   if (Node = nil) or (Node.ChildNodes.FindNode(Key) = nil) then
    Exit('');
                                             //retorna o valor de um nó, se for vazio retorna string vazia
  Result := VarToStr(Node.ChildValues[Key]);
end;

procedure TcadPiadas.btnLimparClick(Sender: TObject);
begin
  mskPesquisar.Text:= '';
  edtPesTipo.text:= '';       //limpa os campos de pesquisa
  edtPesCategoria.text:= '';

  btnPesquisar.Click; //volta a grid original com uma pesquisa vazia
end;

procedure TcadPiadas.btnNovoClick(Sender: TObject);
begin
  tsManutencao.TabVisible := True;
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, pgcPrincipal,False);
  EstadoDoCadastro:=ecInserir; //define os botões ativos, o estado do cadastro como inserir e limpa os campos
  LimparEdits;

  btnCancelar.Font.Color := clBlack;
end;

procedure TcadPiadas.AdicionarItemCombo(Combo: TComboBox; const Valor: string);
var
  Texto: string;
begin
  Texto := NormalizarTexto(Valor);        //coloca o item criado dentro dos 'Items' da combobox

  if Texto = '' then
    Exit;

  if Combo.Items.IndexOf(Texto) = -1 then
    Combo.Items.Add(Texto);
end;

procedure TcadPiadas.CarregarCombos;
begin
  cbbCategoria.Items.Clear;
  cbbTipo.Items.Clear;

  QryPiadas.First;

  while not QryPiadas.Eof do       //carrega as combobox para que estejam atualizadas depois de criar um novo item
  begin
    AdicionarItemCombo(cbbCategoria,
      QryPiadas.FieldByName('categoria').AsString);

    AdicionarItemCombo(cbbTipo,
      QryPiadas.FieldByName('tipo').AsString);

    QryPiadas.Next;
  end;

end;

function TcadPiadas.NormalizarTexto(const Texto: string): string;
var i: Integer; maiuscula: Boolean;
begin
  Result := LowerCase(Trim(Texto));
  maiuscula := True;                  //função para substituir o AnsiProperString, a primeira letra de cada palavra
                                      //fica maiúscula, o resto minúsculo
  for i := 1 to Length(Result) do
  begin
    if maiuscula and (Result[i] in ['a'..'z', 'á'..'ú', 'ã', 'õ', 'â', 'ê', 'ô']) then
    begin
      Result[i] := UpCase(Result[i]);
      maiuscula := False;
    end
    else if Result[i] = ' ' then
      maiuscula := True;
  end;
end;

procedure TcadPiadas.BloqueiaPontoEVirgula(var Key: Char);
begin
    case Key of
    ';', #13:             //bloqueia ';'
      Key := #0;
  end;
end;

procedure TcadPiadas.BloqueiaTeclas(var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    Key := 0;
    Exit;
  end;
                                  //bloqueia enter e combinações
  if (Key = VK_DELETE) then
  begin
    Key := 0;
    Exit;
  end;

  if (key = VK_RETURN) and (ssCtrl in Shift) then
  begin
     key := 0;
  end;
end;

procedure TcadPiadas.BloqueiaCTRL_DEL_DBGrid(var Key: Word; Shift: TShiftState);
begin
  if (Shift =[ssCtrl]) and (Key = 46) then  //se ctrl estiver pressionado junto com o del, anula os dois
      Key := 0
end;

procedure TcadPiadas.btnPesquisarClick(Sender: TObject);
begin
  QryPiadas.Close;
  QryPiadas.SQL.Clear;

  QryPiadas.SQL.Add(
    'SELECT p.piadaId, p.texto, p.categoria, p.tipo, p.dataPiada, c.classificacao ' +
    'FROM piadas p ' +
    'LEFT JOIN classificacoes c ON c.Id = p.classificacaoId ' +     //select base
    'WHERE 1=1 ' );

  if Trim(edtPesCategoria.Text) <> '' then
    QryPiadas.SQL.Add('AND p.categoria LIKE :categoria'); //se a pesquisa de categoria não estiver vazia adiciona filtros

  if Trim(edtPesTipo.Text) <> '' then
    QryPiadas.SQL.Add('AND p.tipo LIKE :tipo'); //mesma coisa só que pra tipo

  if Trim(mskPesquisar.Text) <> '' then
    QryPiadas.SQL.Add('AND p.texto LIKE :texto'); //mesma coisa só que pra piada

  QryPiadas.SQL.Add('ORDER BY p.categoria, p.tipo');

  if Trim(edtPesCategoria.Text) <> '' then
    QryPiadas.ParamByName('categoria').AsString :=
      '%' + edtPesCategoria.Text + '%';

  if Trim(edtPesTipo.Text) <> '' then
    QryPiadas.ParamByName('tipo').AsString :=
      '%' + edtPesTipo.Text + '%';           //coloca a pesquisa do usuário dentro do select com like
                                             //caso seu respectivo campo esteja preenchido
  if Trim(mskPesquisar.Text) <> '' then
    QryPiadas.ParamByName('texto').AsString :=
      '%' + mskPesquisar.Text + '%';

  QryPiadas.Open;
end;

procedure TcadPiadas.btnSairClick(Sender: TObject);
begin
  Application.Terminate; //fecha o programa
end;

procedure TcadPiadas.cbbTipoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BloqueiaTeclas(Key, Shift);
end;

procedure TcadPiadas.cbbTipoKeyPress(Sender: TObject; var Key: Char);
begin
  BloqueiaPontoEVirgula(Key);
end;

function TcadPiadas.SemEnter(const S: string): string;
begin
  Result := StringReplace(S, sLineBreak, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #13#10, ' ', [rfReplaceAll]); //substitui a quebra de linha por um espaço comum
  Result := StringReplace(Result, #13, ' ', [rfReplaceAll]);    //pq enter quebra o csv
  Result := StringReplace(Result, #10, ' ', [rfReplaceAll]);
end;

procedure TcadPiadas.ControlarIndiceTab(pgcPrincipal:TPageControl; Indice: Integer);
begin
  if (pgcPrincipal.Pages[Indice].TabVisible) then
      pgcPrincipal.TabIndex:=Indice;            //troca pra aba informada caso ela esteja visível.
end;

procedure TcadPiadas.cbbCategoriaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BloqueiaTeclas(Key, Shift);
end;

procedure TcadPiadas.cbbCategoriaKeyPress(Sender: TObject; var Key: Char);
begin
  BloqueiaPontoEVirgula(Key);
end;

procedure TcadPiadas.edtPiadaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BloqueiaTeclas(Key, Shift);
end;

procedure TcadPiadas.edtPiadaKeyPress(Sender: TObject; var Key: Char);
begin
  BloqueiaPontoEVirgula(Key);
end;

procedure TcadPiadas.FormCreate(Sender: TObject);
var DB: TAtualizaDBSQL;
begin
   DTMPiadas.conexaoPiadas.Params.Values['Database'] := 'master';
   DTMPiadas.conexaoPiadas.Connected := True; //antes de conectar no db correto, conecta no master para padronizar

   dtmPiadas.ConexaoPiadas.Open;

   DB := TAtualizaDBSQL.Create(DTMPiadas.conexaoPiadas);
  try
    DB.AtualizaDB;
  finally
    DB.Free;
  end;

  grdPiadas.TitleFont.Color:=clWhite;   //define cor do título das colunas
  QryPiadas.FetchOptions.Mode := fmAll;
  QryPiadas.Open;
  KeyPreview:= True;
  QryClassificacoes.Open;
  oPiadas := TPiadas.Create(DTMPiadas.ConexaoPiadas); //cria a conexão

  grdPiadas.FixedColor   := $2E200A;  // cabeçalho escuro
  grdPiadas.Color        := $2E2F32;  // fundo da grid
  grdPiadas.Font.Color   := clWhite;

  btnApagar.Font.Color    := $003C14DC;  // vermelho suave
  btnCancelar.Font.Color  := $9D9D9D;  // cinza
  btnSair.Font.Color      := $002222B2;

  tsManutencao.TabVisible := False;
  CarregarCombos;

  ShowHint := True;
  btnImportar.Hint  := 'Importar piadas de um arquivo XML';
  btnExportar.Hint  := 'Exportar os dados visíveis para CSV';
  btnPesquisar.Hint := 'Buscar com os filtros preenchidos';
  btnLimpar.Hint    := 'Limpar todos os filtros de pesquisa';
  edtPiada.Text:= '';
end;

procedure TcadPiadas.FormDestroy(Sender: TObject);
begin
  FreeAndNil(oPiadas); //libera memória
end;

procedure TcadPiadas.FormShow(Sender: TObject);
begin
  dsPiadas.DataSet := QryPiadas;

  QryClassificacoes.Open;

  QryPiadas.DisableControls;
  try
    QryPiadas.Open;
    QryPiadas.First;
  finally
    QryPiadas.EnableControls;
  end;

  ControlarIndiceTab(pgcPrincipal, 0);
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar,
                  btnGravar, btnApagar,
                  pgcPrincipal,True);

  mskPesquisar.SetFocus;

  IndiceAtual:=QryPiadas.FieldByName('piadaId').AsString;   //define o indice atual inicial e o texto da label
  lblIndice.Caption:= 'Código'
end;

function TcadPiadas.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  if Trim(edtPiadaId.Text) = '' then
     oPiadas.PiadaId := 0
  else
     oPiadas.PiadaId:=StrToInt(edtPiadaId.Text);

  oPiadas.texto            :=edtPiada.Text;
  oPiadas.Categoria        :=NormalizarTexto(cbbCategoria.Text);
  oPiadas.ClassificacaoId  :=lkpClassificacao.KeyValue;  //define o conteúdo de cada campo
  oPiadas.Tipo             :=NormalizarTexto(cbbTipo.Text);

  if (EstadoDoCadastro=ecInserir) then
     Result:=oPiadas.Inserir                 //se o estado do cadastro foi inserir ele insere, se for alterar ele atualiza
  else if (EstadoDoCadastro=ecAlterar) then
     Result:=oPiadas.Atualizar;
end;

procedure TcadPiadas.grdPiadasDblClick(Sender: TObject);
begin
  if f1QryPiadaspiadaId.AsInteger = 0 then begin
    Exit;
  end;

  btnAlterar.Click; //double click tem o mesmo efeito de clicar no botão alterar
  btnCancelar.font.color:= clBlack
end;

procedure TcadPiadas.grdPiadasDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var Grid: TDBGrid; IsSelected: Boolean; CellRect: TRect; TextX, TextY: Integer; DisplayText: string;
begin
  Grid := Sender as TDBGrid;
  IsSelected := gdSelected in State;
  CellRect := Rect;

  //fundo
  if IsSelected then
    Grid.Canvas.Brush.Color := $6B3B3D                          //apenas visuais de grid
  else
  begin
    try
      if Odd(Grid.DataSource.DataSet.RecNo) then
        Grid.Canvas.Brush.Color := $3B3838
      else
        Grid.Canvas.Brush.Color := $312F2F;
    except
      Grid.Canvas.Brush.Color := $312F2F;
    end;
  end;
  Grid.Canvas.FillRect(CellRect);

  //linha
  Grid.Canvas.Pen.Color := $464444;
  Grid.Canvas.Pen.Width := 1;
  Grid.Canvas.MoveTo(CellRect.Left,  CellRect.Bottom - 1);
  Grid.Canvas.LineTo(CellRect.Right, CellRect.Bottom - 1);

  //cor do texto
  if IsSelected then
    Grid.Canvas.Font.Color := clWhite
  else if (Column.FieldName = 'piadaId') or (Column.FieldName = 'dataPiada') then
    Grid.Canvas.Font.Color := $888888
  else
    Grid.Canvas.Font.Color := $E8E8E8;

  Grid.Canvas.Brush.Style := bsClear;

  //texto
  DisplayText := '';
  if Assigned(Column.Field) then
    DisplayText := Column.Field.DisplayText;

  TextY := CellRect.Top + (CellRect.Height - Grid.Canvas.TextHeight('Wg')) div 2;

  if Column.FieldName = 'piadaId' then
    TextX := CellRect.Left + (CellRect.Width - Grid.Canvas.TextWidth(DisplayText)) div 2
  else
    TextX := CellRect.Left + 6;

  Grid.Canvas.TextRect(CellRect, TextX, TextY, DisplayText);
end;

procedure TcadPiadas.grdPiadasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BloqueiaCTRL_DEL_DBGrid(Key, Shift);
end;

procedure TcadPiadas.grdPiadasTitleClick(Column: TColumn);
begin
  IndiceAtual:=Column.FieldName;
  QryPiadas.IndexFieldNames:=IndiceAtual;   //quando o título da coluna é clicado a grid passa a ser ordenada pelo campo
  ExibirLabelIndice(IndiceAtual,lblIndice);
end;

function TcadPiadas.RetornarCampoTraduzido(Campo:string):string;
var I:Integer;
begin
  for I := 0 to qryPiadas.Fields.Count-1 do begin
    if LowerCase (qryPiadas.Fields[I].FieldName)= LowerCase(Campo) then begin
    Result:=qryPiadas.Fields[I].DisplayLabel; //passa por todos os campos retornando um nome com letras minúsculas
    Break;
    end;
  end;
end;

procedure TcadPiadas.ExibirLabelIndice(Campo:string; aLabel:TLabel);
begin
  Alabel.Caption:= RetornarCampoTraduzido(Campo); //label indice recebe o nome do campo traduzido
end;

procedure TcadPiadas.ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar:TbitBtn; pgcPrincipal: TPageControl; Flag:Boolean);
begin
  btnNovo.Enabled:=Flag;
  btnApagar.Enabled:=Flag;
  btnAlterar.Enabled:=Flag;
  pgcPrincipal.Pages[0].TabVisible:=Flag;   //procedure pra controlar quais botões serão ativos
  btnCancelar.Enabled:=not(Flag);
  btnGravar.Enabled:=not(Flag);
end;

procedure TcadPiadas.LimparEdits;
  Var i: Integer;
begin
  for i := 0 to ComponentCount -1 do begin
    if (Components[i] is TLabeledEdit) then
        TLabeledEdit(Components[i]).Text:=EmptyStr
      else if (Components[i] is TEdit) then
      TEdit(Components[i]).Text:=''
      else if (Components[i] is TMemo) then
      TMemo(Components[i]).Text:=''                     //limpa todos os campos para evitar sujeira
      else if (Components[i] is TDBLookupComboBox) then
      TDBLookupComboBox(Components[i]).KeyValue:=Null
      else if (Components[i] is TCurrencyEdit) then
      TCurrencyEdit(Components[i]).Value:=0
      else if (Components[i] is TDateEdit) then
      TDateEdit(Components[i]).Date:=0
      else if (Components[i] is TMaskEdit) then
      TMaskEdit(Components[i]).Text:= ''
      else if (Components[i] is TComboBox) then
      TComboBox(Components[i]).Text := '';
    end;
  end;

function TcadPiadas.StringSafe(F: TField): string;
begin
  if (F = nil) or F.IsNull then
    Result := ''                  //evita campos nulos
  else
    Result := F.AsString;
end;

procedure TcadPiadas.tmr1Timer(Sender: TObject);
begin
   Sleep(30);
  lbl7.Left := lbl7.Left + 5;
                                     //puxa o trollface
  // posição final
  if lbl7.Left >= 20 then
    tmr1.Enabled := False;
end;

procedure TcadPiadas.tsManutencaoShow(Sender: TObject);
begin
  cbbCategoria.SetFocus;
  lbl7.Left := -lbl7.Width;
  tmr1.Enabled := True;
  CarregarCombos;
end;

function TcadPiadas.SomenteNumeros(const Texto:string):string;
var I:Integer;
begin
  Result:='';

  for I:= 1 to Length(Texto) do
    if Texto[I] in ['0'..'9'] then    //o resultado sempre é apenas os números do campo
    Result:= Result+Texto[I];
end;

end.
