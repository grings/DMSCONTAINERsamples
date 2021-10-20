object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Job Email Tutorial'
  ClientHeight = 498
  ClientWidth = 576
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    576
    498)
  PixelsPerInch = 96
  TextHeight = 13
  object btnSendSimpleEmail: TButton
    Left = 16
    Top = 16
    Width = 201
    Height = 57
    Caption = '1. Send a simple email'
    TabOrder = 0
    OnClick = btnSendSimpleEmailClick
  end
  object btnSendEmailWithAttachments: TButton
    Left = 16
    Top = 79
    Width = 201
    Height = 57
    Caption = '2. Send email with attachments'
    TabOrder = 1
    OnClick = btnSendEmailWithAttachmentsClick
  end
  object btnSendBulkMessages: TButton
    Left = 16
    Top = 142
    Width = 201
    Height = 57
    Caption = '3. Send bulk messages'
    TabOrder = 2
    OnClick = btnSendBulkMessagesClick
  end
  object chkIsTest: TCheckBox
    Left = 232
    Top = 36
    Width = 97
    Height = 17
    Caption = 'IsTest'
    TabOrder = 3
  end
  object btnSearchForMessage: TButton
    Left = 16
    Top = 205
    Width = 201
    Height = 52
    Caption = '4. Search for Messages'
    TabOrder = 4
    OnClick = btnSearchForMessageClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 263
    Width = 545
    Height = 218
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
  end
end
