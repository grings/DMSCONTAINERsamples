object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Event Stream Module Tutorial'
  ClientHeight = 564
  ClientWidth = 975
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    975
    564)
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
    Left = 854
    Top = 4
    Width = 111
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Dequeue Timeout [sec]'
    ExplicitLeft = 715
  end
  object Label5: TLabel
    Left = 8
    Top = 125
    Width = 22
    Height = 13
    Caption = 'Logs'
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
    Width = 959
    Height = 258
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    ExplicitWidth = 752
  end
  object EditLastKnownID: TEdit
    Left = 8
    Top = 69
    Width = 189
    Height = 21
    TabOrder = 5
  end
  object btnDelQueue: TButton
    Left = 854
    Top = 82
    Width = 113
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Delete Queue'
    TabOrder = 6
    OnClick = btnDelQueueClick
    ExplicitLeft = 652
  end
  object Panel1: TPanel
    Left = 0
    Top = 408
    Width = 975
    Height = 156
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 7
    ExplicitLeft = 8
    ExplicitWidth = 768
    object GroupBox1: TGroupBox
      Left = 8
      Top = 16
      Width = 177
      Height = 113
      Caption = 'Single Message'
      TabOrder = 0
      object Label3: TLabel
        Left = 17
        Top = 26
        Width = 71
        Height = 13
        Caption = 'Message Value'
      end
      object EditValue: TEdit
        Left = 17
        Top = 45
        Width = 71
        Height = 21
        NumbersOnly = True
        TabOrder = 0
        Text = '1'
      end
      object btnSend: TButton
        Left = 17
        Top = 72
        Width = 138
        Height = 25
        Caption = 'Send Message'
        TabOrder = 1
        OnClick = btnSendClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 191
      Top = 16
      Width = 170
      Height = 113
      Caption = 'Single Huge Message'
      TabOrder = 1
      object btnHugeMessage: TButton
        Left = 16
        Top = 72
        Width = 138
        Height = 25
        Caption = 'Send Huge Message'
        TabOrder = 0
        OnClick = btnHugeMessageClick
      end
    end
    object GroupBox3: TGroupBox
      Left = 372
      Top = 16
      Width = 285
      Height = 113
      Caption = 'Messages with TTL'
      TabOrder = 2
      object Label6: TLabel
        Left = 13
        Top = 26
        Width = 44
        Height = 13
        Caption = 'TTL [min]'
      end
      object EditTTL: TEdit
        Left = 13
        Top = 45
        Width = 44
        Height = 21
        NumbersOnly = True
        TabOrder = 0
        Text = '1'
      end
      object btnSendWithTTL: TButton
        Left = 12
        Top = 72
        Width = 118
        Height = 25
        Caption = 'Send Single Message'
        TabOrder = 1
        OnClick = btnSendWithTTLClick
      end
      object btnMultipleWithTTL: TButton
        Left = 136
        Top = 72
        Width = 137
        Height = 25
        Caption = 'Send Multiple Messages'
        TabOrder = 2
        OnClick = btnMultipleWithTTLClick
      end
    end
  end
  object EditTimeout: TEdit
    Left = 854
    Top = 23
    Width = 113
    Height = 21
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    NumbersOnly = True
    TabOrder = 8
    Text = '10'
    ExplicitLeft = 652
  end
  object btnCount: TButton
    Left = 854
    Top = 113
    Width = 113
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Queue Size'
    TabOrder = 9
    OnClick = btnCountClick
    ExplicitLeft = 652
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
