object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'DMSContainer - EventStreams :: Chat'
  ClientHeight = 512
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MemoChat: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 413
    Height = 434
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    ExplicitHeight = 450
  end
  object Panel1: TPanel
    Left = 0
    Top = 440
    Width = 419
    Height = 72
    Align = alBottom
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 1
    object Edit1: TEdit
      AlignWithMargins = True
      Left = 14
      Top = 14
      Width = 229
      Height = 44
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'Hello There!'
      OnKeyUp = Edit1KeyUp
      ExplicitHeight = 24
    end
    object btnSend: TButton
      AlignWithMargins = True
      Left = 330
      Top = 14
      Width = 75
      Height = 44
      Align = alRight
      Caption = #9993#65039
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnSendClick
      ExplicitHeight = 28
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 249
      Top = 14
      Width = 75
      Height = 44
      Align = alRight
      Caption = #55357#56576
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button1Click
      ExplicitHeight = 28
    end
  end
end