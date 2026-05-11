unit cAtualizaTabelasSQL;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, cAtualizaDB;

type
  TAtualizaTabelasSQL = class(TAtualizaDB)

  private
    function TabelaExiste(aTableName: string): Boolean;

    procedure CriarClassificacoes;
    procedure CriarPiadas;

  public
    constructor Create(aConexao: TFDConnection);

    procedure Execute;
  end;

implementation

{ cAtualizaTabelasSQL }

constructor TAtualizaTabelasSQL.Create(aConexao: TFDConnection);
begin
  inherited Create(aConexao);
end;

procedure TAtualizaTabelasSQL.Execute;
begin
  CriarClassificacoes;
  CriarPiadas;
end;

function TAtualizaTabelasSQL.TabelaExiste(aTableName: string): Boolean;
var Qry: TFDQuery;
begin
  Result := False;

  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := ConnectionDB;

    Qry.SQL.Text :=
      ' SELECT 1 ' +
      ' FROM INFORMATION_SCHEMA.TABLES ' +
      ' WHERE TABLE_NAME = :TableName ';

    Qry.ParamByName('TableName').AsString := aTableName;

    Qry.Open;

    Result := not Qry.IsEmpty;

  finally
    Qry.Free;
  end;
end;

procedure TAtualizaTabelasSQL.CriarClassificacoes;
begin
  if not TabelaExiste('Classificacoes') then
  begin
    ExecutaDiretoSQL(

      ' CREATE TABLE Classificacoes ( ' +
      '   Id INT IDENTITY(1,1) PRIMARY KEY, ' +
      '   classificacao NVARCHAR(20) NOT NULL UNIQUE ' +
      ' ) '

    );

    ExecutaDiretoSQL(

      ' INSERT INTO Classificacoes (classificacao) ' +
      ' VALUES ' +
      ' (''Livre''), ' +
      ' (''10+''), ' +
      ' (''12+''), ' +
      ' (''14+''), ' +
      ' (''16+''), ' +
      ' (''18+'') '

    );
  end;
end;

procedure TAtualizaTabelasSQL.CriarPiadas;
begin
  if not TabelaExiste('Piadas') then
  begin
    ExecutaDiretoSQL(

      ' CREATE TABLE Piadas ( ' +
      '   piadaId INT IDENTITY(1,1) PRIMARY KEY, ' +
      '   texto NVARCHAR(800) NOT NULL, ' +
      '   categoria NVARCHAR(100) NOT NULL, ' +
      '   tipo NVARCHAR(50) NOT NULL, ' +
      '   classificacaoId INT NOT NULL, ' +
      '   dataPiada DATETIME2 DEFAULT GETDATE(), ' +

      '   CONSTRAINT uq_piadas_texto UNIQUE (texto), ' +

      '   CONSTRAINT fk_piadas_classificacao ' +
      '     FOREIGN KEY (classificacaoId) ' +
      '     REFERENCES Classificacoes(Id) ' +

      ' ) '

    );
  end;
end;

end.
