object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'DMSContainer - EventStreams :: Logger Monitor'
  ClientHeight = 540
  ClientWidth = 1373
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 42
    Width = 1373
    Height = 478
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 457
    object Splitter1: TSplitter
      Left = 329
      Top = 1
      Height = 476
      ExplicitLeft = 408
      ExplicitTop = 144
      ExplicitHeight = 100
    end
    object lvProcess: TListView
      Left = 1
      Top = 1
      Width = 328
      Height = 476
      Align = alLeft
      Columns = <
        item
          AutoSize = True
          Caption = 'Instances'
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Items.ItemData = {
        051A0000000100000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF000000
        0000}
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = lvProcessSelectItem
      ExplicitHeight = 455
    end
    object Panel1: TPanel
      Left = 332
      Top = 1
      Width = 1040
      Height = 476
      Align = alClient
      Caption = 'Panel1'
      TabOrder = 1
      ExplicitHeight = 455
      object pcLogs: TPageControl
        Left = 1
        Top = 1
        Width = 1038
        Height = 474
        ActivePage = tsAll
        Align = alClient
        TabOrder = 0
        OnChange = pcLogsChange
        ExplicitHeight = 453
        object tsAll: TTabSheet
          Caption = 'All'
          object DBGridAll: TDBGrid
            Left = 0
            Top = 0
            Width = 1030
            Height = 446
            Align = alClient
            DataSource = DataSource1
            Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = DBGridAllDrawColumnCell
            Columns = <
              item
                Expanded = False
                FieldName = 'id'
                Title.Caption = 'ID'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Width = 295
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'timestamp'
                Title.Caption = 'TIMESTAMP'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Width = 192
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'text'
                Title.Caption = 'TEXT'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'type'
                Title.Caption = 'TYPE'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Width = 164
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'tid'
                Title.Caption = 'TID'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end>
          end
        end
        object tsDebug: TTabSheet
          Caption = 'Debug'
          ImageIndex = 5
          object DBGridDebug: TDBGrid
            Left = 0
            Top = 0
            Width = 1030
            Height = 446
            Align = alClient
            DataSource = DataSource1
            Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'id'
                Title.Caption = 'ID'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Width = 250
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'timestamp'
                Title.Caption = 'TIMESTAMP'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Width = 200
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'text'
                Title.Caption = 'TEXT'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Width = 640
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'tid'
                Title.Caption = 'TID'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end>
          end
        end
        object tsInfo: TTabSheet
          Caption = 'Info'
          ImageIndex = 4
          object DBGridInfo: TDBGrid
            Left = 0
            Top = 0
            Width = 1030
            Height = 446
            Align = alClient
            DataSource = DataSource1
            Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'id'
                Title.Caption = 'ID'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Width = 91
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'timestamp'
                Title.Caption = 'TIMESTAMP'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'text'
                Title.Caption = 'TEXT'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'tid'
                Title.Caption = 'TID'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end>
          end
        end
        object tsWarning: TTabSheet
          Caption = 'Warning'
          ImageIndex = 3
          object DBGridWarning: TDBGrid
            Left = 0
            Top = 0
            Width = 1030
            Height = 446
            Align = alClient
            DataSource = DataSource1
            Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'id'
                Title.Caption = 'ID'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'timestamp'
                Title.Caption = 'TIMESTAMP'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'text'
                Title.Caption = 'TEXT'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'tid'
                Title.Caption = 'TID'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end>
          end
        end
        object tsError: TTabSheet
          Caption = 'Error'
          ImageIndex = 1
          object DBGridError: TDBGrid
            Left = 0
            Top = 0
            Width = 1030
            Height = 446
            Align = alClient
            DataSource = DataSource1
            Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'id'
                Title.Caption = 'ID'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'timestamp'
                Title.Caption = 'TIMESTAMP'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'text'
                Title.Caption = 'TEXT'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'tid'
                Title.Caption = 'TID'
                Title.Font.Charset = DEFAULT_CHARSET
                Title.Font.Color = clWindowText
                Title.Font.Height = -16
                Title.Font.Name = 'Tahoma'
                Title.Font.Style = []
                Visible = True
              end>
          end
        end
        object TabSheet1: TTabSheet
          Caption = 'Text Log'
          object MemoMessage: TMemo
            Left = 0
            Top = 0
            Width = 1030
            Height = 446
            Align = alClient
            BevelInner = bvLowered
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = clInactiveCaption
            Ctl3D = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Consolas'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
          end
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 1373
    Height = 42
    Align = alTop
    TabOrder = 1
    object EditQueueName: TEdit
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 1153
      Height = 30
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'logs.logsproducersample.monitor'
      ExplicitWidth = 1244
      ExplicitHeight = 27
    end
    object btnStartStop: TButton
      AlignWithMargins = True
      Left = 1168
      Top = 5
      Width = 200
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      Caption = #9654#65039
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 520
    Width = 1373
    Height = 20
    Align = alBottom
    TabOrder = 2
  end
  object dsLogs: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 400
    Top = 208
    object dsLogsid: TStringField
      DisplayWidth = 33
      FieldName = 'id'
      Size = 80
    end
    object dsLogstimestamp: TStringField
      DisplayWidth = 50
      FieldName = 'timestamp'
      Size = 50
    end
    object dsLogstext: TStringField
      DisplayWidth = 80
      FieldName = 'text'
      Size = 1000
    end
    object dsLogstype: TStringField
      DisplayWidth = 50
      FieldName = 'type'
      Size = 50
    end
    object dsLogstid: TIntegerField
      DisplayWidth = 10
      FieldName = 'tid'
    end
  end
  object DataSource1: TDataSource
    DataSet = dsLogs
    Left = 496
    Top = 240
  end
end
