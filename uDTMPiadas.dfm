object dtmPiadas: TdtmPiadas
  OldCreateOrder = False
  Height = 407
  Width = 807
  object conexaoPiadas: TFDConnection
    Params.Strings = (
      'Server=DC-TR-07-VM\SQLEXPRESS'
      'Database=piadas'
      'OSAuthent=Yes'
      'DriverID=MSSQL')
    Connected = True
    LoginPrompt = False
    Left = 592
    Top = 64
  end
end
