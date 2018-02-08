object TfmEventSettingsDemo: TTfmEventSettingsDemo
  Left = 416
  Top = 191
  Caption = #1042#1099#1074#1086#1076' '#1089#1087#1080#1089#1082#1072' '#1096#1072#1073#1083#1086#1085#1086#1074' '#1076#1083#1103' '#1075#1088#1091#1087#1087#1086#1074#1099#1093' '#1088#1077#1081#1089#1086#1074
  ClientHeight = 328
  ClientWidth = 660
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object gbReisList: TGroupBox
    Left = 0
    Top = 0
    Width = 660
    Height = 328
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Panel2: TPanel
      Left = 2
      Top = 281
      Width = 656
      Height = 45
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMenuHighlight
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 280
        Top = 24
        Width = 132
        Height = 16
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      end
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 103
        Height = 16
        Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1085#1086#1084#1077#1088#1091':'
      end
      object Edit1: TEdit
        Left = 16
        Top = 16
        Width = 57
        Height = 24
        TabOrder = 0
      end
      object DateTimePicker1: TDateTimePicker
        Left = 424
        Top = 16
        Width = 97
        Height = 24
        Date = 41799.580404236120000000
        Time = 41799.580404236120000000
        TabOrder = 1
      end
      object DateTimePicker2: TDateTimePicker
        Left = 552
        Top = 16
        Width = 97
        Height = 24
        Date = 41799.580496111110000000
        Time = 41799.580496111110000000
        TabOrder = 2
      end
      object BitBtn1: TBitBtn
        Left = 104
        Top = 16
        Width = 145
        Height = 25
        Caption = #1055#1086#1080#1089#1082' \ '#1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
        TabOrder = 3
      end
    end
  end
  object ADOStoredProc1: TADOStoredProc
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Ggv123;Persist Security Info=True;U' +
      'ser ID=kobra_main;Initial Catalog=ANN;Data Source=srvr145\sql_de' +
      'v1'
    CursorType = ctStatic
    LockType = ltBatchOptimistic
    ProcedureName = 'spANN_MyFirstProcedure;1'
    Parameters = <>
    Prepared = True
    Left = 80
    Top = 216
  end
  object DataSource1: TDataSource
    DataSet = ADOStoredProc1
    Left = 128
    Top = 216
  end
end
