object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'SynchUtils Module Sample'
  ClientHeight = 653
  ClientWidth = 952
  Color = clBtnFace
  Constraints.MinHeight = 350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 218
    Width = 952
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 450
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 224
    Width = 946
    Height = 426
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object ListBox1: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 49
    Width = 946
    Height = 166
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Consolas'
    Font.Style = []
    ItemHeight = 24
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 952
    Height = 46
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object btnAcquireLock: TButton
      AlignWithMargins = True
      Left = 194
      Top = 3
      Width = 113
      Height = 40
      Align = alLeft
      Caption = 'TryAcquireLock'
      TabOrder = 0
      OnClick = btnAcquireLockClick
    end
    object btnReleaseLock: TButton
      AlignWithMargins = True
      Left = 670
      Top = 3
      Width = 113
      Height = 40
      Align = alLeft
      Caption = 'ReleaseLock'
      TabOrder = 1
      OnClick = btnReleaseLockClick
      ExplicitLeft = 551
    end
    object btnTTL: TButton
      AlignWithMargins = True
      Left = 432
      Top = 3
      Width = 113
      Height = 40
      Align = alLeft
      Caption = 'GetLockExpiration'
      TabOrder = 2
      OnClick = btnTTLClick
      ExplicitLeft = 313
    end
    object btnGetLockData: TButton
      AlignWithMargins = True
      Left = 551
      Top = 3
      Width = 113
      Height = 40
      Align = alLeft
      Caption = 'GetLockData'
      TabOrder = 3
      OnClick = btnGetLockDataClick
      ExplicitLeft = 432
    end
    object btnManyLocks: TButton
      AlignWithMargins = True
      Left = 836
      Top = 3
      Width = 113
      Height = 40
      Align = alRight
      Caption = 'Many Locks'
      TabOrder = 4
      OnClick = btnManyLocksClick
    end
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 185
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 5
      object edtLockIdentifier: TLabeledEdit
        Left = 0
        Top = 17
        Width = 185
        Height = 21
        EditLabel.Width = 65
        EditLabel.Height = 13
        EditLabel.Caption = 'LockIdentifier'
        TabOrder = 0
        Text = 'lock1'
      end
    end
    object btnExtendLock: TButton
      AlignWithMargins = True
      Left = 313
      Top = 3
      Width = 113
      Height = 40
      Align = alLeft
      Caption = 'ExtendLock'
      TabOrder = 6
      OnClick = btnExtendLockClick
    end
  end
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 232
    Top = 80
  end
end
