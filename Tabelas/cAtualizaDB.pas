unit cAtualizaDB;

interface

uses System.SysUtils, FireDAC.Comp.Client, Data.DB;

type
  TAtualizaDB = class
  protected
    ConnectionDB: TFDConnection;

  public
    constructor Create(aConnection: TFDConnection);

    procedure ExecutaDiretoSQL(aSQL: string);
  end;

  TAtualizaDBSQL = class
  private
    ConnectionDB: TFDConnection;

    function DatabaseExiste(aDatabase: string): Boolean;
    procedure CriarDatabase;

  public
    constructor Create(aConnection: TFDConnection);

    procedure AtualizaDB;
  end;

implementation

uses
  cAtualizaTabelasSQL;

{ TAtualizaDB }

constructor TAtualizaDB.Create(aConnection: TFDConnection);
begin
  inherited Create;
  ConnectionDB := aConnection;
end;

function TAtualizaDBSQL.DatabaseExiste(aDatabase: string): Boolean;
var Qry: TFDQuery;
begin
  Result := False;

  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := ConnectionDB;

    Qry.SQL.Text :=
      ' SELECT database_id ' +
      ' FROM sys.databases ' +      //da um select pra ver se o database existe e retorna um resultado
      ' WHERE name = :Database ';

    Qry.ParamByName('Database').AsString := aDatabase;

    Qry.Open;

    Result := not Qry.IsEmpty;

  finally
    Qry.Free;
  end;
end;

procedure TAtualizaDB.ExecutaDiretoSQL(aSQL: string);
var
  Qry: TFDQuery;
begin
  Qry := nil;

  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := ConnectionDB;

    Qry.SQL.Clear;
    Qry.SQL.Add(aSQL);
                                        //procedure para executar um comando no sql, usando a string aSQL declarada
    ConnectionDB.StartTransaction;      //na procedure

    try
      Qry.ExecSQL;

      ConnectionDB.Commit;

    except
      on E: Exception do
      begin
        ConnectionDB.Rollback;

        raise Exception.Create(
          'Erro ao executar SQL:' + sLineBreak +
          E.Message
        );
      end;
    end;

  finally
    if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

{ TAtualizaDBSQL }

constructor TAtualizaDBSQL.Create(aConnection: TFDConnection);
begin
  inherited Create;

  ConnectionDB := aConnection;
end;

procedure TAtualizaDBSQL.AtualizaDB;
var
  oTable: TAtualizaTabelasSQL;
begin
  CriarDatabase;
                                  //define o uso do banco 'piadas', pq o banco padrão é o 'master', assim evita erro
  ConnectionDB.Close;                                     //para alguns usuários
  ConnectionDB.Params.Values['Database'] := 'Piadas';
  ConnectionDB.Open;

  oTable := TAtualizaTabelasSQL.Create(ConnectionDB);
  try
    oTable.Execute;
  finally
    oTable.Free;
  end;
end;

procedure TAtualizaDBSQL.CriarDatabase;
var
  Qry: TFDQuery;
begin
  if not DatabaseExiste('Piadas') then
  begin
    Qry := TFDQuery.Create(nil);

    try
      Qry.Connection := ConnectionDB;
                                           //se o database 'piadas' n existe, cria ele, para automatizar o processo
      Qry.SQL.Text :=
        'CREATE DATABASE Piadas';

      Qry.ExecSQL;

    finally
      Qry.Free;
      Sleep(500);
    end;
  end;
end;

end.
