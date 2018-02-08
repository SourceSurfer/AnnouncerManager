object fmTemplates: TfmTemplates
  Left = 262
  Top = 86
  Width = 979
  Height = 563
  Caption = #1064#1072#1073#1083#1086#1085#1099' '#1079#1074#1091#1082#1086#1074#1099#1093' '#1089#1086#1086#1073#1097#1077#1085#1080#1081
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RzSplitter1: TRzSplitter
    Left = 0
    Top = 0
    Width = 971
    Height = 529
    Position = 205
    Percent = 21
    Align = alClient
    TabOrder = 0
    BarSize = (
      205
      0
      209
      529)
    UpperLeftControls = (
      st)
    LowerRightControls = (
      RzSplitter2)
    object st: TSqlTree
      Left = 0
      Top = 0
      Width = 205
      Height = 529
      Align = alClient
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoDrag, hoVisible]
      Header.Style = hsXPStyle
      NodeDataSize = 16
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnBeforeCellPaint = stBeforeCellPaint
      OnChange = stChange
      DataSet = DM.spTemplates
      ExpAll = True
      SqlCheckType = ctNone
      Columns = <
        item
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring]
          Position = 0
          Width = 200
        end>
    end
    object RzSplitter2: TRzSplitter
      Left = 0
      Top = 0
      Width = 762
      Height = 529
      Orientation = orVertical
      Position = 169
      Percent = 32
      Align = alClient
      TabOrder = 0
      BarSize = (
        0
        169
        762
        173)
      UpperLeftControls = (
        mmText)
      LowerRightControls = ()
      object mmText: TRzMemo
        Left = 0
        Top = 0
        Width = 762
        Height = 169
        Align = alClient
        TabOrder = 0
      end
    end
  end
end
