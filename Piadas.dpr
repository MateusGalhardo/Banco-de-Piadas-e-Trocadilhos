program Piadas;

uses
  Vcl.Forms,
  uCadPiadas in 'uCadPiadas.pas' {cadPiadas},
  uDTMPiadas in 'uDTMPiadas.pas' {dtmPiadas: TDataModule},
  cCadPiadas in 'cCadPiadas.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdtmPiadas, dtmPiadas);
  Application.CreateForm(TcadPiadas, cadPiadas);
  Application.Run;
end.
