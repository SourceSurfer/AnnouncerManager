object frmSeconds: TfrmSeconds
  Left = 504
  Top = 235
  BorderStyle = bsToolWindow
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 400
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 8
    Top = 370
    Width = 121
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btCancel: TButton
    Left = 136
    Top = 370
    Width = 121
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = btCancelClick
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 340
    Height = 73
    Align = alTop
    Caption = #1042#1088#1077#1084#1103' '#1086#1079#1074#1091#1095#1080#1074#1072#1085#1080#1103' '#1089#1086#1086#1073#1097#1077#1085#1080#1081
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 167
      Height = 39
      Caption = 
        #1059#1082#1072#1078#1080#1090#1077', '#1079#1072#1076#1077#1088#1078#1082#1091' ('#1074' '#1089#1077#1082#1091#1085#1076#1072#1093') '#13#10#1087#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1085#1072#1095#1072#1083#1072' '#13#10#1086#1079#1074#1091#1095#1080#1074#1072#1085#1080#1103 +
        ' '#1089#1086#1086#1073#1097#1077#1085#1080#1103':'
    end
    object spnSeconds: TRzSpinEdit
      Left = 176
      Top = 24
      Width = 121
      Height = 21
      Max = 9999.000000000000000000
      Min = 1.000000000000000000
      Value = 15.000000000000000000
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 122
    Width = 340
    Height = 245
    Align = alTop
    Caption = #1060#1080#1083#1100#1090#1088' '#1088#1077#1081#1089#1086#1074
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 184
      Height = 13
      Caption = #1063#1072#1089#1086#1074' '#1085#1072#1079#1072#1076' '#1076#1086' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080': '
    end
    object Label3: TLabel
      Left = 8
      Top = 56
      Width = 208
      Height = 13
      Caption = #1063#1072#1089#1086#1074' '#1074#1087#1077#1088#1077#1076' '#1087#1086#1089#1083#1077' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080': '
    end
    object spnEarly: TRzSpinEdit
      Left = 232
      Top = 24
      Width = 65
      Height = 21
      Min = 1.000000000000000000
      Value = 5.000000000000000000
      TabOrder = 0
    end
    object spnLate: TRzSpinEdit
      Left = 232
      Top = 56
      Width = 65
      Height = 21
      Min = 1.000000000000000000
      Value = 5.000000000000000000
      TabOrder = 1
    end
    object pgLD: TProfGrid
      Left = 2
      Top = 120
      Width = 336
      Height = 123
      ColCount = 3
      RowCount = 2
      FixedCols = 0
      FixedRows = 1
      About = 'v2.32.28 Cracked by Semen Sorokin '#39'03  '
      BorderForText = 2
      DefaultColWidth = 64
      DefaultRowHeight = 19
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
      Options = [pgoFixedVertLine, pgoFixedHorzLine, pgoVertLine, pgoHorzLine, pgoRowSizing, pgoColSizing, pgoEditing, pgoTabs, pgoAutoIncreaseRowHeights, pgoAutoDecreaseRowHeights, pgoDrawFocusRectangle, pgoClearCellOnDel, pgoCut, pgoCopy, pgoPaste]
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
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnButtonClicked = pgLDButtonClicked
      OnCheckBoxChanged = pgLDCheckBoxChanged
    end
    object chbxShowVisin: TCheckBox
      Left = 8
      Top = 88
      Width = 321
      Height = 25
      Caption = #1057#1082#1088#1099#1074#1072#1090#1100' '#1088#1077#1081#1089#1099', '#1086#1090#1084#1077#1095#1077#1085#1085#1099#1077' '#1074' '#1057#1055#1055' '#1082#1072#1082' '#1085#1077#1086#1079#1074#1091#1095#1080#1074#1072#1077#1084#1099#1077
      TabOrder = 3
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 73
    Width = 340
    Height = 49
    Align = alTop
    Caption = #1042#1099#1089#1086#1090#1072' '#1089#1090#1088#1086#1082#1080
    TabOrder = 4
    Visible = False
    object Label4: TLabel
      Left = 8
      Top = 21
      Width = 125
      Height = 13
      Caption = #1059#1082#1072#1078#1080#1090#1077' '#1074#1099#1089#1090#1086#1091' '#1089#1090#1088#1086#1082#1080':'
    end
    object spnRowHeight: TRzSpinEdit
      Left = 176
      Top = 16
      Width = 121
      Height = 21
      Increment = 10.000000000000000000
      Min = 10.000000000000000000
      Value = 20.000000000000000000
      TabOrder = 0
    end
  end
end
