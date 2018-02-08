object frmGateExit: TfrmGateExit
  Left = 192
  Top = 114
  Width = 507
  Height = 640
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1082#1086#1085#1089#1090#1072#1085#1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gbSetValues: TGroupBox
    Left = 0
    Top = 0
    Width = 499
    Height = 201
    Align = alTop
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1082#1086#1085#1089#1090#1072#1085#1090#1099
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMenuHighlight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 38
      Height = 16
      Caption = #1071#1079#1099#1082': '
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 96
      Height = 16
      Caption = #1058#1080#1087' '#1082#1086#1085#1089#1090#1072#1085#1090#1099': '
    end
    object Label3: TLabel
      Left = 8
      Top = 88
      Width = 201
      Height = 16
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1074' '#1077#1076#1080#1085#1089#1090#1074#1077#1085#1085#1086#1084' '#1095#1080#1089#1083#1077': '
    end
    object Label4: TLabel
      Left = 8
      Top = 120
      Width = 219
      Height = 16
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1074#1086' '#1084#1085#1086#1078#1077#1089#1090#1074#1077#1085#1085#1086#1084' '#1095#1080#1089#1083#1077': '
    end
    object cbxLang: TComboBox
      Left = 232
      Top = 24
      Width = 257
      Height = 21
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
      OnChange = cbxLangChange
    end
    object cbxType: TComboBox
      Left = 232
      Top = 56
      Width = 257
      Height = 21
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 1
      OnChange = cbxTypeChange
      Items.Strings = (
        #1042#1099#1093#1086#1076
        #1057#1090#1086#1081#1082#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080)
    end
    object edSingle: TEdit
      Left = 232
      Top = 84
      Width = 257
      Height = 21
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnChange = edSingleChange
    end
    object edPlural: TEdit
      Left = 232
      Top = 116
      Width = 257
      Height = 21
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnChange = edPluralChange
    end
    object btSave: TBitBtn
      Tag = 1
      Left = 5
      Top = 152
      Width = 93
      Height = 33
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 4
      OnClick = btSaveClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000520B0000520B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FF164D87FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF045BA70F
        5396244370244370FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF045BA7055DAA0C569913529014508E244370244370FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF045BA7106EBA0762AC0C
        589D11539213529015508C174D87244370244370FF00FFFF00FFFF00FFFF00FF
        FF00FF045BA7106EBA0D6AB61C79C12074B71A65A610539313529014508E164F
        8A184E87244370FF00FFFF00FFFF00FF045BA7106EBA1373BD248CD4AAD9F3AD
        DCF381BFE53689C911539312529014518E164F8A244370FF00FFFF00FF045BA7
        106EBA1C80C9248CD45DB8DED5E7EBC5CCCFD1E1E5D9EEF37DC1EB3D87C11C63
        A113518F244370FF00FFFF00FF045BA7258ED5248CD491CFED5DB8DED5E7EBC5
        CCCFD1E1E5D9EEF3DEF6FB83C9E93262903788C6244370FF00FFFF00FF045BA7
        248CD45DB8DEB0E1F05DB8DEDEF6FBDEF6FBC5CCCFD5E7EBF4BA6889BBC41480
        271F2B46244370FF00FFFF00FF045BA783C9E95DB8DECEEEF75DB8DE5DB8DEBF
        E7F4DEF6FBDEF6FBFF8E0114802732BF4F148027FF00FFFF00FFFF00FF18375E
        84CCE75DB8DE5DB8DEB0E1F0DEF6FB5DB8DE5DB8DEB0E1F014802732BF4F2198
        37219837148027FF00FFFF00FF2443706ABFE1BFE7F4CEEEF75DB8DE5DB8DEBF
        E7F4CEEEF7219837219837219837219837148027148027148027FF00FFFF00FF
        24437024437068A9CAB0E1F0DEF6FB5DB8DE5DB8DE77C5E32443702198372198
        37148027FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF24437024437084CCE7BF
        E7F492D3EA244370FF00FF219837219837148027FF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF244370244370244370FF00FFFF00FF2198372198
        37148027FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF219837219837219837FF00FFFF00FF}
    end
    object btDelete: TBitBtn
      Left = 145
      Top = 152
      Width = 93
      Height = 33
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 5
      OnClick = btSaveClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FFFFFFEDD3C1
        C17545FBF6F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFEED6C4B4520EAB4403C17037FDFAF8FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9CEBEF3D7C0BC580CBA5308
        AE4500AB4402D29469FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF6
        F3D1864D993708BE5D17C05B0CD27321B14901AE4701B4581DEED5C4FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFE7B994B96A409E3600A8470FE5B48BD78A4CD17528
        C7681AAF4700AE4600AF4B05F0DACAFFFFFFFFFFFFF6E3D4D4A385AC46079F37
        00AA4910E9BB94FFFFFFFDF8F4DB9154D58134BC5A0FAF4600AC4602B25314F0
        DCCDF0DDD1BE5F1DA53F04A23A00AD4B0FE7B58BFFFFFFFFFFFFFFFFFFFEFDFB
        DB9253D07D32B54F04B14800AD4806AE4A08AB4809AA4100A73E00AF4C0FE8BB
        94FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDF8F4DD975AC2661CB14900B14800AE
        4500AE4600AA4200B04D0EE7B58BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFC26217B24B00B24A00B04800AE4600B7530FEBC29FFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDAA885B54D02B54D00B34B00B1
        4900AF4700B7520BEBC19EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        D8A27BB75001B85000B54D00B95305BA5A11B44D03AD4500B24E09E7B58CFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFDBA984B95201BB5200B84F00C05D0DC96B1CD9
        A885C06727B8540AAF4600B34D09E8BA93FFFFFFFFFFFFFFFFFFD8A27ABB5401
        BE5600BC5300C96A18CF7628DBA984FFFFFFF2DDCDD99661BC5A0FAF4701B34C
        07E7B58BFFFFFFFFFFFFB54D01BE5700C45C04D27725D17A2CD8A37DFFFFFFFF
        FFFFFFFFFFFFFFFFE1B08AC5661DB34F07B44D05E8BA92FFFFFFEDD5C4BB5A0F
        CB762ECE7528DBA984FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDF9F6D68B
        4EB8560FB6530CE1A97AFFFFFFEFDACAB55817D8A17BFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFDF8F4EBC8ADC57D4CE9C6AC}
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 201
    Width = 499
    Height = 405
    Align = alClient
    TabOrder = 1
    object mpgConst: TProfGrid
      Left = 2
      Top = 15
      Width = 495
      Height = 388
      ColCount = 4
      RowCount = 5
      FixedCols = 0
      FixedRows = 1
      About = 'v2.32.28 Cracked by Semen Sorokin '#39'03  '
      BorderForText = 2
      DefaultColWidth = 64
      DefaultRowHeight = 21
      EditColor = clWindow
      EditFontColor = clWindowText
      EditControlOptions = [ecoAutoIncreaseRowHeight, ecoAutoIncreaseColumnWidth, ecoUseEditColor, ecoUseEditFontColor, ecoUseCellFont]
      EditorOptions = [eoAutoIncreaseRowHeight, eoAutoDecreaseRowHeight, eoShowOnChar, eoClearOnChar, eoAllowPaste]
      ExportTag = 'ProfGridTag'
      FixedColor = clBtnFace
      FixedGridLineColor = clBlack
      GridLineColor = clSilver
      GridLineWidth = 1
      HideSelection = False
      InplaceScrollBar = False
      LoadedEvents = []
      Options = [pgoFixedVertLine, pgoFixedHorzLine, pgoVertLine, pgoHorzLine, pgoDrawFocusSelected, pgoRowSizing, pgoColSizing, pgoTabs, pgoRowSelect, pgoAutoIncreaseRowHeights, pgoAutoDecreaseRowHeights, pgoDrawFocusRectangle, pgoClearCellOnDel, pgoCut, pgoCopy, pgoPaste]
      PrintFooter.Alignment = taLeftJustify
      PrintFooter.Font.Charset = DEFAULT_CHARSET
      PrintFooter.Font.Color = clWindowText
      PrintFooter.Font.Height = -13
      PrintFooter.Font.Name = 'Arial'
      PrintFooter.Font.Style = []
      PrintHeader.Alignment = taLeftJustify
      PrintHeader.Font.Charset = DEFAULT_CHARSET
      PrintHeader.Font.Color = clWindowText
      PrintHeader.Font.Height = -13
      PrintHeader.Font.Name = 'Arial'
      PrintHeader.Font.Style = []
      PrintOptions = [poPrintGridLines, poUseCellColors, poUseFontColors, poUseGridColor, poUseFixedColor, poUseGridLineColor, poUseFixedGridLineColor, poUseInnerBorderColors, poUseOuterBorderColors]
      PrintToFitOptions.ShrinkToPagesWide = 0
      PrintToFitOptions.ShrinkToPagesTall = 0
      PrintToFitOptions.ExpandToPagesWide = 0
      PrintToFitOptions.ExpandToPagesTall = 0
      SelectionColor = clHighlight
      SelectionFontColor = clHighlightText
      SortColumn = 0
      SortDescending = False
      SortIndicator = False
      SortIndicatorColor = clBtnFace
      SortOnClick = False
      SortOnDblClick = False
      SpreadsheetEnabled = False
      SpreadsheetHeaders = False
      SpreadsheetOptions = [soExcelStyleHeadings, soExcelStyleHeadingHighlight, soExcelStyleNavigation]
      TabOptions = []
      WordWrap = True
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnSelectCell = mpgConstSelectCell
    end
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 256
    Top = 152
  end
end
