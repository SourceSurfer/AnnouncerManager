object fmCheckinTemplEdit: TfmCheckinTemplEdit
  Left = 281
  Top = 128
  BorderStyle = bsDialog
  ClientHeight = 215
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 142
    Height = 16
    Caption = #1050#1083#1072#1089#1089' '#1086#1073#1089#1083#1091#1078#1080#1074#1072#1085#1080#1103': '
  end
  object Label2: TLabel
    Left = 368
    Top = 8
    Width = 40
    Height = 16
    Caption = #1071#1079#1099#1082': '
  end
  object Label3: TLabel
    Left = 8
    Top = 48
    Width = 104
    Height = 16
    Caption = #1058#1077#1082#1089#1090' '#1096#1072#1073#1083#1086#1085#1072': '
  end
  object cbxServClass: TComboBox
    Left = 152
    Top = 8
    Width = 201
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 0
  end
  object cbxLang: TComboBox
    Left = 416
    Top = 8
    Width = 201
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 1
  end
  object mmText: TMemo
    Left = 8
    Top = 72
    Width = 609
    Height = 89
    TabOrder = 2
    OnChange = mmTextChange
  end
  object btSave: TBitBtn
    Left = 8
    Top = 176
    Width = 121
    Height = 33
    Action = acSave
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 3
    Glyph.Data = {
      36090000424D3609000000000000360000002800000030000000100000000100
      1800000000000009000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFEFBFBBE89897C45458558589E79799572748F686A8C
      66678A6467896467824B4B783F3E783E3D9B706FF3EEEEFFFFFFFFFFFFD7D7D7
      898989818181A1A1A1A1A1A19B9B9B9898989797979797978D8D8D7F7F7F7A7A
      7A838383E4E4E4FFFFFFFFFFFFF7E6E6844A4A612D2D7F5D5D8A6B6C7E616378
      5758765457735255704D50682F2E5A2929632A2AAE9696FFFFFFE3A1A1E89B9C
      B56C6CC0ADADD3C8C8DDC5C7EDEEF3E5ECF3DBE2EAD4E0ECB876768C42418B3E
      3C8A3E3CCEBDBDFFFFFFE1E2E2C2C2C2C4C4C49E9E9EECECECD8D8D8F1F1F1FA
      FAFAF3F3F3F3F3F3C9C9C99090907B7B7B8B8B8B999B9BFFFFFFF6E2E2D67979
      E58989834141DAD8D8BBA7A8DBC4C7E5EDF3D7DFE7CCD4E1BDBBC89A3E3C6226
      26832D2A5D2120FFFFFFDC8183EEA9AAB66E6EBBA6A6655555956969EBE5E8E8
      EAEFDDE0E6D6DEE7B47373894140893D3B883D3BD3C3C3FFFFFFC7C6C6CECECE
      C5C5C5A3A3A3B2B2B28A8A8ADBDBDBFAFAFAF0F0F0F1F1F1C6C6C68E8E8E7A7A
      7A8989899DA2A2FFFFFFEFC7C8DB7C7DE89192894848B3AFAF351818A4797AEF
      F3F7DADDE3D0D6DEC0BBC5953C39612525802C29622928FFFFFFDF8788F7B2B3
      BC7474BFA9A92325252F1E1EECE9EAF6F8FBE8EAEEE1EAF1B776758A41408A3E
      3C883D3BD2C3C3FFFFFFCBCBCBD2D2D2CACACAABABAB828282242424C7C7C7FF
      FFFFF6F6F6F7F7F7CACACA8E8E8E7B7B7B8989899DA2A2FFFFFFF0CCCCE18182
      F39C9D8E4D4DAEACAC000000574747FFFFFFE9EBF0DDE1E8CCC7CE953C396226
      25812D2A612827FFFFFFE18A8BFEBCBDC0797AAC9695AFB0B0ADA9A9EBE9E9EE
      EDEEE3E2E5DDE1E6AF6F6F823C3A8F44428A403ED2C3C3FFFFFFCBCBCBD7D7D7
      D0D0D0989898C8C8C8A6A6A6E1E1E1F3F3F3EEEEEEEFEFEFC3C3C38888887C7C
      7C8F8F8F9DA2A2FFFFFFEFCBCCE78788FEA8A9854646C3C1C1A7A8A8B9B7B7EF
      EEEEE6E6E8D9DCE1C6C1C68B36345D2323873330622928FFFFFFE38C8DFFC5C7
      E3A4A9905A5EA56E73A36D71935D618F585C8C55588A525584494C7C4042A053
      508F4744D2C3C3FFFFFFCBCBCBDCDCDCE1E1E19A9A9AA0A0A0A6A6A698989893
      93939090908E8E8E8A8A8A8282828989899696969DA2A2FFFFFFEFCBCBEC8C8D
      FFB6B8B47074814C4F935C5F8B55587D4649794345763F42723A3D6A3032682B
      2B943D3B652C2BFFFFFFE28B8CFFC5C7D77B61D67759D17154CE6D50CA694CC6
      6547C26043C05C3EBC5838BB604EB9696A934B4AD2C2C2FFFFFFCBCBCBE2E2E2
      BEBEBEA7A7A7A7A7A7A4A4A4A1A1A19F9F9F9C9C9C999999969696969696A7A7
      A79B9B9B9DA2A2FFFFFFEFCBCBEF9091F5A09CC75C44C85C47C35741BE523CB9
      4E37B44932B0442EAD412AA83D25A84C45A04948682F2EFFFFFFE79397DA8369
      E5C9B8EAD7CDE9D5CBE6D0C5E4CCC1E1C8BBDFC5B6DCC0B2DDC2B3CB8C6DBA5F
      51985353D2C2C2FFFFFFCDCDCDC2C2C2BFBFBFE5E5E5E4E4E4E1E1E1DFDFDFDD
      DDDDDBDBDBD8D8D8D7D7D7CCCCCC959595A4A4A49DA2A2FFFFFFEFCBCBE98686
      C6725BE8D6CDE4D1C8E1CCC3DEC7BDDBC1B7D7BCAFD4B7AAD0B1A3D2B3A3AE55
      3AA74C496A3131FFFFFFE89499D27655F7F3EFF7EAE0EED3BFEDD3C0ECD0BDE9
      CDB9E8CBB7E7C8B2E7DFD8CF9A7FBF61509D595AD1C2C2FFFFFFCDCDCDB9B9B9
      CCCCCCFFFFFFE6E6E6E6E6E6E4E4E4E2E2E2E1E1E1DFDFDFE5E5E5DFDFDF9393
      93ABABAB9DA2A2FFFFFFEFCBCBE78382C16F56FFFFFFEDD0BDE9C7B1E7C5AEE5
      C1ABE2BEA6E1BBA3DFB9A3DFD5D0B1593CB153516C3332FFFFFFE89499D37859
      F6EEE9FBF2ECF6E4D9F4E2D6F1DFD2EFDACEECD7C9EAD3C4EAE1DCD09A7FC568
      58A25E60D1C2C2FFFFFFCDCDCDBABABACBCBCBFEFEFEF0F0F0EFEFEFEDEDEDEA
      EAEAE8E8E8E5E5E5E8E8E8DEDEDE969696B2B2B29DA2A2FFFFFFEFCBCBE78383
      C27157FFFFFFF6E4DAF2DDD0EFD8CBECD4C5E9CEBFE6C9BAE2C7B7E2D7D1B25A
      3EBB5C5A6F3535FFFFFFE89499D37859F7EEE9FBF2EBF6E5DAF4E3D7F2DFD2EF
      DBCEEDD7CAEBD3C4EDE6E0D19C82CA705FA86466D1C2C2FFFFFFCDCDCDBABABA
      CBCBCBFEFEFEF0F0F0EFEFEFEDEDEDEBEBEBE8E8E8E6E6E6E9E9E9E1E1E19999
      99B9B9B99DA2A2FFFFFFEFCBCBE78383C27157FFFFFFF6E4D9F3DFD2EFD9CBED
      D5C6E9CFC0E7CABBE3C8B8E6DED8B35C41C46765723838FFFFFFE89499D37859
      F7EFEAF8EAE0F2D7C4F3DAC9F2D8C7F0D5C3EED3C0ECCEBAF0E9E4D39F85D87C
      6BB26F71D1C1C2FFFFFFCDCDCDBABABACBCBCBFEFEFEE7E7E7E9E9E9E8E8E8E6
      E6E6E6E6E6E2E2E2E9E9E9E3E3E39E9E9EC7C7C79DA3A3FFFFFFEFCBCBE78383
      C27157FFFFFFF0D5C3EFCFBBEFD0BDEDCDB9EAC9B4E8C5AFE6C4AFEAE4E0B65F
      44D87876773C3CFFFFFFE89499D37859F6EDE7FDF8F5FBF2ECFBF3EDFBF2ECF8
      EDE7F4E8E1F1E3DBF4F1F0D7A48AB362549B6164D1C2C2FFFFFFCDCDCDBABABA
      CACACAFFFFFFF7F7F7F8F8F8F8F8F8F5F5F5F3F3F3F0F0F0F1F1F1E8E8E88B8B
      8BA3A3A39DA4A3FFFFFFEFCBCBE78383C27157FFFFFFFAF1ECFAF0E9FAF0EAF8
      EDE6F3E6DEF0E0D7ECDBD2F0EBE8B35E43B16261703A3AFFFFFFE69691D47A5C
      FBFAF9FBEFE5F2D6C2F4DAC6F4DAC7F4DAC7F3D9C5F1D4BFFAFDFCE4B19B533A
      3113090CD3C1C1FFFFFFCECECEBCBCBCD0D0D0FFFFFFE8E8E8E9E9E9EAEAEAEA
      EAEAE9E9E9E6E6E6F2F2F2F7F7F7797979121212929798FFFFFFEDC9C4E88882
      C4755CFFFFFFF2D5C0EFCEB6F0CFB8F0CFB8F0CFB8EECCB3EECEB8FBFFFFB567
      4E1F29282A0B0BFFFFFFF8A9E3C76D43C87A53CC8464CD8768CD8767CD8767CD
      8767CC8567CC8465CC8261C0673CD48376AC8182F3EFEFFFFFFFC4C5C5ADADAD
      9A9A9AAAAAAAADADADADADADADADADADADADADADADACACACAAAAAAA1A1A1A8A8
      A8A3A3A3E2E5E3FFFFFFFEEDFBE881ADAD5027BE6F55C0765FC07761C07760C0
      7760C07760BE755EBD725ABC6E53B14E2FBF6E6EB49A99FFFFFF}
    NumGlyphs = 3
  end
  object btCancel: TBitBtn
    Left = 136
    Top = 176
    Width = 121
    Height = 33
    Action = acCancel
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    Glyph.Data = {
      36090000424D3609000000000000360000002800000030000000100000000100
      1800000000000009000000000000000000000000000000000000FFFFFFEDD3C1
      C17545FBF6F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFE0E0E09F9F9FF9F9F9FFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8CDC1
      B16341FAF5F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFEED6C4B4520EAB4403C17037FDFAF8FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9CEBEF4DCC8E6E6E6848485
      7B7B7B9A9A9AFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFDDDDDDE8E7E7ECD7CEA13A0E952C01B15C36FDF9F7FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3C7BAEFD0BBBC580CBA5308
      AE4500AB4402D29469FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF6
      F3D1864D993708BB5D188C8A868787877B7B7B7B7B7BB6B6B6FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9ACACAC7272728E8C8CAC4009A73903
      992D00962C00C68361FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAF5
      F3C47244812104AD440BC05B0CD27321B14901AE4701B4581DEED5C4FFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFE7B994B96A409E3600A8470FE2B187908F8CA0A0A1
      7E7E7E7C7C7C8A8A8AE1E1E1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD0D0D09898
      987070707F7F7FC9C7C7B1470EC558119D3100992E00A1421AE9D0C4FFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFE0AC8DA75737862000932F07DEA582D78A4CD17528
      C7681AAF4700AE4600AF4B05F0DACAFFFFFFFFFFFFF6E3D4D4A385AC46079F37
      00AA4910EAB98FFFFFFFAEB2B5A4A4A49797977C7C7C7A7A7A7F7F7FE5E5E5FF
      FFFFFFFFFFECECECBFBFBF7C7C7C6F6F6F818181D0D3D6FFFFFFCD733BC35B15
      B74E0D9B2D00992D009C3204EBD5CAFFFFFFFFFFFFF3DED1CA957E982D038720
      00953107E2AD8BFFFFFFFDF8F4DB9154D58134BC5A0FAF4600AC4602B25314F0
      DCCDF0DDD1BE5F1DA53F04A23A00AD4B0FE7B58BFFFFFFFFFFFFFAFAFAB5B5B5
      ABABAB8C8C8C7B7B7B7B7B7B868686E6E6E6E8E8E88F8F8F7777777272728282
      82CDCDCDFFFFFFFFFFFFFCF6F2D07D47C9661EAA40089B2D00982D009E3C0FEC
      D7CDECD8CFAB47149027028B2300983307DFA783FFFFFFFFFFFFFFFFFFFEFDFB
      DB9253D07D32B54F04B14800AD4806AE4A08AB4809AA4100A73E00AF4C0FE8BB
      94FFFFFFFFFFFFFFFFFFFFFFFFFDFDFDB5B5B5A9A9A98383837D7D7D7E7E7E80
      80807E7E7E777777767676838383D1D1D1FFFFFFFFFFFFFFFFFFFFFFFFFEFCFB
      D17D45C3631DA135029D2F00972F03993204952F059429009126009A3406E2AD
      8CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDF8F4DD975AC2661CB14900B14800AE
      4500AE4600AA4200B04D0EE7B58BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FAFAFAB9B9B99696967E7E7E7D7D7D7B7B7B7C7C7C797979838383CDCDCDFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF6F3D3824BB14C0F9D30009D2F0099
      2D00992D00942A009C3506DFA783FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFC26217B24B00B24A00B04800AE4600B7530FEBC29FFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9292927F7F7F7E7E7E7D
      7D7D7B7B7B878787D6D6D6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB2480E9D32009E31009C2F00992D00A33A07E5B698FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDAA885B54D02B54D00B34B00B1
      4900AF4700B7520BEBC19EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFC1C1C18181818181817F7F7F7E7E7E7C7C7C868686D5D5D5FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD09C85A13502A234009F32009D
      30009B2E00A53A06E5B697FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      D8A27BB75001B85000B54D00B95305BA5A11B44D03AD4500B24E09E7B58CFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBDBDBD8383838383838080808686868D
      8D8D8282827A7A7A828282CDCDCDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      CE957BA43600A53600A23300A63902A84008A13301992C009F3504DFA783FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFDBA984B95201BB5200B84F00C05D0DC96B1CD9
      A885C06727B8540AAF4600B34D09E8BA93FFFFFFFFFFFFFFFFFFFFFFFFC2C2C2
      8484848585858282828E8E8E999999C4C4C49797978888887B7B7B828282D0D0
      D0FFFFFFFFFFFFFFFFFFFFFFFFD19D84A63800A93800A53500AF4306B9510FCE
      9A7EAF4D19A53A049B2D00A03504E2AD8BFFFFFFFFFFFFFFFFFFD8A27ABB5401
      BE5600BC5300C96A18CF7628DBA984FFFFFFF2DDCDD99661BC5A0FAF4701B34C
      07E7B58BFFFFFFFEFEFEBBBDC0858585888888858585989898A1A1A1C2C2C2FF
      FFFFE8E8E8B8B8B88D8D8D7D7D7D818181CDCDCDFFFFFFFEFEFDCE927AA93A00
      AC3C00A93900B9500CC15C17D29D84FFFFFFEED7C9CE8357AA3F079B2F00A033
      03DFA783FFFFFFFFFFFFB54D01BE5700C45C04D27725D17A2CD8A37DFFFFFFFF
      FFFFFFFFFFFFFFFFE1B08AC5661DB34F07B44D05EBBA8FFFFFFF7A838A898888
      8D8D8DA3A3A3A5A5A5BEBEBEFFFFFFFFFFFFFFFFFFFFFFFFC9C9C99797978383
      83828282D0D4D6FFFFFFA12B00AD3D00B34201C45D14C4601ACE967CFFFFFFFF
      FFFFFFFFFFFFFFFFD9A282B44C0FA03503A03402E2AD8BFFFFFFEDD5C4BB5A0F
      CB762ECE7528DBA984FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDF9F6D68B
      4EB8560FB6530BE3AE83EAE5E2888B8CA4A4A4A1A1A1C2C2C2FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFBFBFBB1B1B18A8A8A878787C8C8C7ECDCD4A93E0D
      BC5B1AC05B17D29D84FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF8F6CA75
      41A53C07A23A05D99970FFFFFFEFDACAB55817D8A17BFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFDF8F4EBC8ADC57D4CEAC5A9FFFFFFE3E5E6
      8B8B8BBCBCBCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFA
      FADADADAA6A6A6D7D9DBFFFFFFEBD3CAA13F10CD947BFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF6F3E5BEA7B66944E2BDA8}
    NumGlyphs = 3
  end
  object acList: TActionList
    Left = 304
    Top = 104
    object acSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ShortCut = 16397
      OnExecute = acSaveExecute
    end
    object acCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      Hint = #1054#1090#1084#1077#1085#1072
      ShortCut = 27
      OnExecute = acCancelExecute
    end
  end
end
