object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Event Stream Module Tutorial'
  ClientHeight = 493
  ClientWidth = 773
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    773
    493)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 4
    Width = 62
    Height = 13
    Caption = 'Queue Name'
  end
  object Label2: TLabel
    Left = 8
    Top = 50
    Width = 69
    Height = 13
    Caption = 'Last Known ID'
  end
  object Label4: TLabel
    Left = 652
    Top = 4
    Width = 111
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Dequeue Timeout [sec]'
    ExplicitLeft = 715
  end
  object EditQueueName: TEdit
    Left = 8
    Top = 23
    Width = 189
    Height = 21
    TabOrder = 0
    Text = 'queue.test1'
  end
  object btnDequeue: TButton
    Left = 203
    Top = 67
    Width = 189
    Height = 25
    Caption = 'Dequeue Next Message'
    TabOrder = 1
    OnClick = btnDequeueClick
  end
  object btnFirst: TButton
    Left = 203
    Top = 21
    Width = 189
    Height = 25
    Caption = 'Dequeue __first__ Message'
    TabOrder = 2
    OnClick = btnFirstClick
  end
  object btnLast: TButton
    Left = 398
    Top = 21
    Width = 189
    Height = 25
    Caption = 'Dequeue __last__ Message'
    TabOrder = 3
    OnClick = btnLastClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 144
    Width = 757
    Height = 279
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object EditLastKnownID: TEdit
    Left = 8
    Top = 69
    Width = 189
    Height = 21
    TabOrder = 5
  end
  object btnDelQueue: TButton
    Left = 652
    Top = 82
    Width = 113
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Delete Queue'
    TabOrder = 6
    OnClick = btnDelQueueClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 430
    Width = 773
    Height = 63
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 7
    object Label3: TLabel
      Left = 9
      Top = 10
      Width = 71
      Height = 13
      Caption = 'Message Value'
    end
    object btnSend: TButton
      Left = 136
      Top = 27
      Width = 178
      Height = 25
      Caption = 'Send Message'
      TabOrder = 0
      OnClick = btnSendClick
    end
    object EditValue: TEdit
      Left = 9
      Top = 29
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 1
      Text = '1'
    end
    object btnHugeMessage: TButton
      Left = 320
      Top = 27
      Width = 178
      Height = 25
      Caption = 'Send Huge Message'
      TabOrder = 2
      OnClick = btnHugeMessageClick
    end
  end
  object EditTimeout: TEdit
    Left = 652
    Top = 23
    Width = 113
    Height = 21
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    NumbersOnly = True
    TabOrder = 8
    Text = '10'
  end
  object btnCount: TButton
    Left = 652
    Top = 113
    Width = 113
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Queue Size'
    TabOrder = 9
    OnClick = btnCountClick
  end
  object chkUpdateKID: TCheckBox
    Left = 398
    Top = 71
    Width = 179
    Height = 17
    Caption = 'Update LKID'
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
end
