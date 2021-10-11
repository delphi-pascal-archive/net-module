object main_form: Tmain_form
  Left = 0
  Top = 0
  Caption = #1055#1072#1088#1089#1080#1085#1075' '#1090#1077#1082#1089#1090#1072' '#1080#1079' WEB | net_module.pas'
  ClientHeight = 329
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object memo: TMemo
    Left = 0
    Top = 75
    Width = 497
    Height = 254
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitTop = 56
    ExplicitHeight = 279
  end
  object Button1: TButton
    Left = 0
    Top = 0
    Width = 497
    Height = 25
    Align = alTop
    Caption = #1055#1088#1086#1095#1080#1090#1072#1090#1100' basher.ru'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 0
    Top = 25
    Width = 497
    Height = 25
    Align = alTop
    Caption = #1055#1088#1086#1095#1080#1090#1072#1090#1100' bash.org.ru'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 0
    Top = 50
    Width = 497
    Height = 25
    Align = alTop
    Caption = #1055#1088#1086#1095#1080#1090#1072#1090#1100' anekdot.ru'
    TabOrder = 3
    OnClick = Button3Click
    ExplicitTop = 33
  end
  object IdCookieManager1: TIdCookieManager
    Left = 392
    Top = 168
  end
  object PopupMenu1: TPopupMenu
    Left = 168
    Top = 128
    object N1: TMenuItem
      Caption = #1062#1080#1090#1072#1090#1099
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #1057#1090#1072#1090#1091#1089#1099
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1072#1081#1090' basher.ru'
      OnClick = N3Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 208
    Top = 128
    object MenuItem1: TMenuItem
      Caption = 
        #1040#1085#1077#1082#1076#1086#1090', '#1080#1089#1090#1086#1088#1080#1103' '#1080' '#1072#1092#1086#1088#1080#1079#1084' '#1087#1086' '#1080#1090#1086#1075#1072#1084' '#1075#1086#1083#1086#1089#1086#1074#1072#1085#1080#1103' '#1079#1072' '#1087#1088#1086#1096#1077#1076#1096#1080#1081' '#1076#1077 +
        #1085#1100
      OnClick = MenuItem1Click
    end
    object MenuItem2: TMenuItem
      Caption = #1045#1078#1077#1076#1085#1077#1074#1085#1072#1103' '#1076#1077#1089#1103#1090#1082#1072' '#1072#1085#1077#1082#1076#1086#1090#1086#1074
      OnClick = MenuItem2Click
    end
    object MenuItem3: TMenuItem
      Caption = #1045#1078#1077#1076#1085#1077#1074#1085#1072#1103' '#1076#1077#1089#1103#1090#1082#1072' '#1080#1089#1090#1086#1088#1080#1081' '
      OnClick = MenuItem3Click
    end
    object N4: TMenuItem
      Caption = #1045#1078#1077#1076#1085#1077#1074#1085#1072#1103' '#1076#1077#1089#1103#1090#1082#1072' '#1072#1092#1086#1088#1080#1079#1084#1086#1074
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = #1045#1078#1077#1076#1085#1077#1074#1085#1072#1103' '#1076#1077#1089#1103#1090#1082#1072' '#1089#1090#1080#1096#1082#1086#1074' '
      OnClick = N5Click
    end
    object Google1: TMenuItem
      Caption = 
        #1045#1078#1077#1076#1085#1077#1074#1085#1086' '#1086#1073#1085#1086#1074#1083#1103#1077#1084#1072#1103' '#1087#1086#1076#1073#1086#1088#1082#1072' '#1083#1091#1095#1096#1080#1093' '#1072#1085#1077#1082#1076#1086#1090#1086#1074' '#1087#1086' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1072#1084' '#1075 +
        #1086#1083#1086#1089#1086#1074#1072#1085#1080#1081' '#1095#1080#1090#1072#1090#1077#1083#1077#1081' '#1044#1086#1073#1072#1074#1080#1090#1100' '#1074' Google'
      OnClick = Google1Click
    end
    object N6: TMenuItem
      Caption = #1051#1091#1095#1096#1080#1077' '#1072#1085#1077#1082#1076#1086#1090#1099' '#1087#1088#1086#1096#1083#1099#1093' '#1083#1077#1090
      OnClick = N6Click
    end
  end
end
