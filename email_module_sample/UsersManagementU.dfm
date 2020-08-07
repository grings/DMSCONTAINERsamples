object UsersForm: TUsersForm
  Left = 0
  Top = 0
  Caption = 'Users Management'
  ClientHeight = 459
  ClientWidth = 941
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    941
    459)
  PixelsPerInch = 96
  TextHeight = 13
  object btnCreateUsers: TButton
    Left = 8
    Top = 8
    Width = 89
    Height = 25
    Caption = 'Create Users'
    TabOrder = 0
    OnClick = btnCreateUsersClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 418
    Width = 941
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnOK: TButton
      AlignWithMargins = True
      Left = 826
      Top = 4
      Width = 111
      Height = 33
      Align = alRight
      Caption = 'Close'
      ModalResult = 1
      TabOrder = 0
    end
  end
  object btnGetUsers: TButton
    Left = 8
    Top = 39
    Width = 89
    Height = 25
    Caption = 'Get Users'
    TabOrder = 2
    OnClick = btnGetUsersClick
  end
  object DBGrid1: TDBGrid
    Left = 103
    Top = 8
    Width = 830
    Height = 404
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnUpdateUser: TButton
    Left = 8
    Top = 70
    Width = 89
    Height = 25
    Caption = 'Update User'
    TabOrder = 4
    OnClick = btnUpdateUserClick
  end
  object btnDeleteUser: TButton
    Left = 8
    Top = 101
    Width = 89
    Height = 25
    Caption = 'Delete User'
    TabOrder = 5
    OnClick = btnDeleteUserClick
  end
  object btnSetSender: TButton
    Left = 8
    Top = 132
    Width = 89
    Height = 25
    Caption = 'Set Sender'
    TabOrder = 6
    OnClick = btnSetSenderClick
  end
  object DataSource1: TDataSource
    DataSet = mtUsers
    Left = 464
    Top = 232
  end
  object mtUsers: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 392
    Top = 232
  end
end
