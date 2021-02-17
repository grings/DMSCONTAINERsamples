object frmSelectUsers: TfrmSelectUsers
  Left = 0
  Top = 0
  Caption = 'Users to Notify'
  ClientHeight = 324
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object chklistUsers: TCheckListBox
    Left = 0
    Top = 0
    Width = 505
    Height = 283
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'FontAwesome'
    Font.Style = []
    ItemHeight = 27
    ParentFont = False
    TabOrder = 0
    ExplicitLeft = 1
    ExplicitTop = -127
    ExplicitWidth = 248
    ExplicitHeight = 358
  end
  object Panel1: TPanel
    Left = 0
    Top = 283
    Width = 505
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 289
    object Button1: TButton
      Left = 408
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object Button2: TButton
      Left = 312
      Top = 6
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 1
    end
  end
end
