object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'DMSContainer - EventStreams :: Chat'
  ClientHeight = 332
  ClientWidth = 627
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
  object Panel1: TPanel
    Left = 0
    Top = 227
    Width = 627
    Height = 64
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      AlignWithMargins = True
      Left = 399
      Top = 4
      Width = 109
      Height = 56
      Align = alRight
      Caption = #55357#56576' x 10'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
      ExplicitTop = 2
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 284
      Top = 4
      Width = 109
      Height = 56
      Align = alRight
      Caption = #55357#56576' x 100'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 189
      Height = 56
      Align = alLeft
      Caption = #10060' Delete Queue'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      AlignWithMargins = True
      Left = 514
      Top = 4
      Width = 109
      Height = 56
      Align = alRight
      Caption = #55357#56576' x 1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button4Click
      ExplicitTop = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 627
    Height = 227
    Align = alClient
    TabOrder = 1
    object MemoMessage: TMemo
      AlignWithMargins = True
      Left = 4
      Top = 31
      Width = 619
      Height = 192
      Align = alClient
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      Lines.Strings = (
        '{'
        '  "name":"Value"'
        '}')
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
    end
    object EditQueueName: TEdit
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 619
      Height = 21
      Align = alTop
      TabOrder = 1
      Text = 'queue.test1'
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 291
    Width = 627
    Height = 41
    Align = alBottom
    TabOrder = 2
    object Label1: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 619
      Height = 33
      Align = alClient
      Alignment = taCenter
      Caption = 'Label1'
      Layout = tlCenter
      ExplicitWidth = 31
      ExplicitHeight = 13
    end
  end
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 184
    Top = 80
  end
end
