object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'SSO::Configuration Provider Sample'
  ClientHeight = 341
  ClientWidth = 912
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    912
    341)
  PixelsPerInch = 96
  TextHeight = 13
  object btnGetContextData: TButton
    Left = 8
    Top = 8
    Width = 129
    Height = 57
    Caption = 'Get Context Data'
    TabOrder = 0
    OnClick = btnGetContextDataClick
  end
  object btnGetAllMyData: TButton
    Left = 8
    Top = 275
    Width = 129
    Height = 58
    Caption = 'All My Data'
    TabOrder = 1
    OnClick = btnGetAllMyDataClick
  end
  object MemoData: TMemo
    Left = 143
    Top = 8
    Width = 761
    Height = 325
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    WordWrap = False
  end
  object btnGetSystemData: TButton
    Left = 8
    Top = 71
    Width = 129
    Height = 57
    Caption = 'Get System Data'
    TabOrder = 3
    OnClick = btnGetSystemDataClick
  end
  object btnGetUserData: TButton
    Left = 8
    Top = 134
    Width = 129
    Height = 57
    Caption = 'Get User Data'
    TabOrder = 4
    OnClick = btnGetUserDataClick
  end
  object btnSetUserData: TButton
    Left = 8
    Top = 197
    Width = 129
    Height = 57
    Caption = 'Set User Data'
    TabOrder = 5
    OnClick = btnSetUserDataClick
  end
end
