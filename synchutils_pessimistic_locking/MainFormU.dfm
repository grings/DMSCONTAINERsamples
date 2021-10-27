object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 521
  ClientWidth = 817
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 817
    Height = 57
    Align = alTop
    Caption = 'Panel1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 57
    Width = 817
    Height = 210
    Align = alClient
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'CUST_NO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CUSTOMER'
        Width = 78
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CONTACT_FIRST'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CONTACT_LAST'
        Width = 85
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PHONE_NO'
        Width = 84
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ADDRESS_LINE1'
        Width = 119
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ADDRESS_LINE2'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CITY'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STATE_PROVINCE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'COUNTRY'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'POSTAL_CODE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ON_HOLD'
        Visible = True
      end>
  end
  object Panel2: TPanel
    Left = 0
    Top = 267
    Width = 817
    Height = 254
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      817
      254)
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 47
      Height = 13
      Caption = 'CUST_NO'
      FocusControl = DBEdit1
    end
    object Label2: TLabel
      Left = 8
      Top = 80
      Width = 55
      Height = 13
      Caption = 'CUSTOMER'
      FocusControl = DBEdit2
    end
    object Label3: TLabel
      Left = 8
      Top = 120
      Width = 83
      Height = 13
      Caption = 'CONTACT_FIRST'
      FocusControl = DBEdit3
    end
    object Label4: TLabel
      Left = 8
      Top = 160
      Width = 78
      Height = 13
      Caption = 'CONTACT_LAST'
      FocusControl = DBEdit4
    end
    object Label5: TLabel
      Left = 8
      Top = 200
      Width = 55
      Height = 13
      Caption = 'PHONE_NO'
      FocusControl = DBEdit5
    end
    object Label6: TLabel
      Left = 264
      Top = 40
      Width = 80
      Height = 13
      Caption = 'ADDRESS_LINE1'
      FocusControl = DBEdit6
    end
    object Label7: TLabel
      Left = 264
      Top = 80
      Width = 80
      Height = 13
      Caption = 'ADDRESS_LINE2'
      FocusControl = DBEdit7
    end
    object Label8: TLabel
      Left = 264
      Top = 120
      Width = 23
      Height = 13
      Caption = 'CITY'
      FocusControl = DBEdit8
    end
    object Label9: TLabel
      Left = 264
      Top = 160
      Width = 88
      Height = 13
      Caption = 'STATE_PROVINCE'
      FocusControl = DBEdit9
    end
    object Label10: TLabel
      Left = 368
      Top = 160
      Width = 48
      Height = 13
      Caption = 'COUNTRY'
      FocusControl = DBEdit10
    end
    object Label11: TLabel
      Left = 264
      Top = 200
      Width = 72
      Height = 13
      Caption = 'POSTAL_CODE'
      FocusControl = DBEdit11
    end
    object Label12: TLabel
      Left = 430
      Top = 200
      Width = 48
      Height = 13
      Caption = 'ON_HOLD'
      FocusControl = DBEdit12
    end
    object DBNavigator1: TDBNavigator
      Left = 8
      Top = 6
      Width = 240
      Height = 25
      DataSource = DataSource1
      TabOrder = 0
    end
    object DBEdit1: TDBEdit
      Left = 8
      Top = 56
      Width = 55
      Height = 21
      DataField = 'CUST_NO'
      DataSource = DataSource1
      TabOrder = 1
    end
    object DBEdit2: TDBEdit
      Left = 8
      Top = 96
      Width = 250
      Height = 21
      DataField = 'CUSTOMER'
      DataSource = DataSource1
      TabOrder = 2
    end
    object DBEdit3: TDBEdit
      Left = 8
      Top = 136
      Width = 250
      Height = 21
      DataField = 'CONTACT_FIRST'
      DataSource = DataSource1
      TabOrder = 3
    end
    object DBEdit4: TDBEdit
      Left = 8
      Top = 176
      Width = 250
      Height = 21
      DataField = 'CONTACT_LAST'
      DataSource = DataSource1
      TabOrder = 4
    end
    object DBEdit5: TDBEdit
      Left = 8
      Top = 216
      Width = 250
      Height = 21
      DataField = 'PHONE_NO'
      DataSource = DataSource1
      TabOrder = 5
    end
    object DBEdit6: TDBEdit
      Left = 264
      Top = 56
      Width = 250
      Height = 21
      DataField = 'ADDRESS_LINE1'
      DataSource = DataSource1
      TabOrder = 6
    end
    object DBEdit7: TDBEdit
      Left = 264
      Top = 96
      Width = 250
      Height = 21
      DataField = 'ADDRESS_LINE2'
      DataSource = DataSource1
      TabOrder = 7
    end
    object DBEdit8: TDBEdit
      Left = 264
      Top = 136
      Width = 250
      Height = 21
      DataField = 'CITY'
      DataSource = DataSource1
      TabOrder = 8
    end
    object DBEdit9: TDBEdit
      Left = 264
      Top = 176
      Width = 88
      Height = 21
      DataField = 'STATE_PROVINCE'
      DataSource = DataSource1
      TabOrder = 9
    end
    object DBEdit10: TDBEdit
      Left = 368
      Top = 176
      Width = 146
      Height = 21
      DataField = 'COUNTRY'
      DataSource = DataSource1
      TabOrder = 10
    end
    object DBEdit11: TDBEdit
      Left = 264
      Top = 216
      Width = 160
      Height = 21
      DataField = 'POSTAL_CODE'
      DataSource = DataSource1
      TabOrder = 11
    end
    object DBEdit12: TDBEdit
      Left = 430
      Top = 216
      Width = 48
      Height = 21
      DataField = 'ON_HOLD'
      DataSource = DataSource1
      TabOrder = 12
    end
    object Panel3: TPanel
      Left = 544
      Top = 16
      Width = 257
      Height = 225
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Panel3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
      object lbLockTTL: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 202
        Width = 249
        Height = 19
        Align = alBottom
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 5
      end
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=employee'
      'User_Name=sysdba'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=localhost'
      'DriverID=FB')
    ConnectedStoredUsage = [auDesignTime]
    LoginPrompt = False
    Left = 56
    Top = 56
  end
  object FDQuery1: TFDQuery
    BeforeEdit = FDQuery1BeforeEdit
    AfterPost = FDQuery1AfterPost
    AfterCancel = FDQuery1AfterCancel
    AfterScroll = FDQuery1AfterScroll
    Connection = FDConnection1
    SQL.Strings = (
      'select * from customer order by cust_no')
    Left = 56
    Top = 120
    object FDQuery1CUST_NO: TFDAutoIncField
      FieldName = 'CUST_NO'
      Origin = 'CUST_NO'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery1CUSTOMER: TStringField
      FieldName = 'CUSTOMER'
      Origin = 'CUSTOMER'
      Required = True
      Size = 25
    end
    object FDQuery1CONTACT_FIRST: TStringField
      FieldName = 'CONTACT_FIRST'
      Origin = 'CONTACT_FIRST'
      Size = 15
    end
    object FDQuery1CONTACT_LAST: TStringField
      FieldName = 'CONTACT_LAST'
      Origin = 'CONTACT_LAST'
    end
    object FDQuery1PHONE_NO: TStringField
      FieldName = 'PHONE_NO'
      Origin = 'PHONE_NO'
    end
    object FDQuery1ADDRESS_LINE1: TStringField
      FieldName = 'ADDRESS_LINE1'
      Origin = 'ADDRESS_LINE1'
      Size = 30
    end
    object FDQuery1ADDRESS_LINE2: TStringField
      FieldName = 'ADDRESS_LINE2'
      Origin = 'ADDRESS_LINE2'
      Size = 30
    end
    object FDQuery1CITY: TStringField
      FieldName = 'CITY'
      Origin = 'CITY'
      Size = 25
    end
    object FDQuery1STATE_PROVINCE: TStringField
      FieldName = 'STATE_PROVINCE'
      Origin = 'STATE_PROVINCE'
      Size = 15
    end
    object FDQuery1COUNTRY: TStringField
      FieldName = 'COUNTRY'
      Origin = 'COUNTRY'
      Size = 15
    end
    object FDQuery1POSTAL_CODE: TStringField
      FieldName = 'POSTAL_CODE'
      Origin = 'POSTAL_CODE'
      Size = 12
    end
    object FDQuery1ON_HOLD: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'ON_HOLD'
      Origin = 'ON_HOLD'
      FixedChar = True
      Size = 1
    end
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 56
    Top = 198
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 168
    Top = 200
  end
  object tmrLockOwner: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmrLockOwnerTimer
    Left = 656
    Top = 112
  end
end
