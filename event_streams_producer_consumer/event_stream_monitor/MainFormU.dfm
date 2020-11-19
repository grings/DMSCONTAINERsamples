object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Queue Monitor'
  ClientHeight = 660
  ClientWidth = 814
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object sg: TStringGrid
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 808
    Height = 613
    Align = alClient
    BorderStyle = bsNone
    ColCount = 8
    DefaultColWidth = 100
    DefaultRowHeight = 100
    FixedCols = 0
    RowCount = 6
    FixedRows = 0
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = sgDrawCell
    ExplicitWidth = 812
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 814
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 818
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 706
      Height = 41
      Align = alClient
      Alignment = taCenter
      Caption = 'Click to start consuming queue -->'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 369
      ExplicitHeight = 29
    end
    object btnStart: TButton
      AlignWithMargins = True
      Left = 709
      Top = 3
      Width = 102
      Height = 35
      Align = alRight
      Caption = '&Start'
      TabOrder = 0
      OnClick = btnStartClick
      ExplicitLeft = 713
    end
  end
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 400
    Top = 336
  end
end
