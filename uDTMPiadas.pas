unit uDTMPiadas;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, System.IniFiles, System.IOUtils;

type
  TdtmPiadas = class(TDataModule)
    conexaoPiadas: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmPiadas: TdtmPiadas;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdtmPiadas.DataModuleCreate(Sender: TObject);
var Ini: TIniFile; Path, Auth: string;
begin
  Path := TPath.Combine(ExtractFilePath(ParamStr(0)), 'config.ini');

  if not FileExists(Path) then
    raise Exception.Create('Arquivo config.ini não encontrado.');

  Ini := TIniFile.Create(Path);
  try
    ConexaoPiadas.Params.Clear;
    ConexaoPiadas.Params.DriverID := 'MSSQL';

    ConexaoPiadas.Params.Values['Server'] := Ini.ReadString('DB','Server','');
    ConexaoPiadas.Params.Values['Database'] := 'master';

    Auth := Ini.ReadString('DB','Auth','Windows');

    if SameText(Auth, 'SQL') then
    begin
      ConexaoPiadas.Params.Values['User_Name'] := Ini.ReadString('DB','User','');
      ConexaoPiadas.Params.Values['Password'] := Ini.ReadString('DB','Password','');
    end
    else
    begin
      ConexaoPiadas.Params.Values['OSAuthent'] := 'Yes';
    end;

    ConexaoPiadas.LoginPrompt := False;

  finally
    Ini.Free;
  end;
end;

end.
