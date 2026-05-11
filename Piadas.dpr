program Piadas;

uses
  Vcl.Forms,
  uCadPiadas in 'uCadPiadas.pas' {cadPiadas},
  uDTMPiadas in 'uDTMPiadas.pas' {dtmPiadas: TDataModule},
  cCadPiadas in 'cCadPiadas.pas',
  Vcl.Themes,
  Vcl.Styles,
  cAtualizaTabelasSQL in 'Tabelas\cAtualizaTabelasSQL.pas',
  cAtualizaDB in 'Tabelas\cAtualizaDB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdtmPiadas, dtmPiadas);
  Application.CreateForm(TcadPiadas, cadPiadas);
  Application.Run;
end.
