object StoredReportNamesForm: TStoredReportNamesForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Stored Report Names'
  ClientHeight = 388
  ClientWidth = 725
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  PopupMode = pmExplicit
  Position = poMainFormCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 21
  object RzDialogButtons1: TRzDialogButtons
    Left = 0
    Top = 352
    Width = 725
    HotTrack = True
    OKDefault = False
    ShowDivider = True
    ShowGlyphs = True
    ShowOKButton = False
    Color = clWhite
    TabOrder = 1
    ExplicitTop = 349
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 725
    Height = 37
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object EditFilter: TEdit
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 636
      Height = 29
      Align = alClient
      TabOrder = 0
      TextHint = 'RegEx filter'
      OnKeyDown = EditFilterKeyDown
    end
    object btnDoFilter: TButton
      AlignWithMargins = True
      Left = 646
      Top = 4
      Width = 75
      Height = 29
      Align = alRight
      Caption = 'Filter'
      TabOrder = 1
      OnClick = btnDoFilterClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 37
    Width = 725
    Height = 315
    Align = alClient
    Caption = 'Panel2'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    ExplicitHeight = 312
    object ListBox1: TListBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 303
      Height = 307
      Align = alClient
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ItemHeight = 25
      ParentFont = False
      TabOrder = 0
      OnClick = ListBox1Click
      ExplicitHeight = 304
    end
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 320
      Top = 11
      Width = 394
      Height = 293
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alRight
      BorderStyle = bsNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      ExplicitHeight = 290
    end
  end
end
