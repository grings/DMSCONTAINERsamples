object framePDF: TframePDF
  Left = 0
  Top = 0
  Width = 768
  Height = 377
  TabOrder = 0
  object StatusBar1: TStatusBar
    Left = 0
    Top = 358
    Width = 768
    Height = 19
    Panels = <
      item
        Width = 200
      end>
    ExplicitWidth = 756
  end
  object pnlGenReports: TPanel
    Left = 0
    Top = 43
    Width = 185
    Height = 315
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnlGenReports'
    TabOrder = 1
    ExplicitTop = 41
    ExplicitHeight = 317
    object Label2: TLabel
      Left = 0
      Top = 0
      Width = 185
      Height = 21
      Align = alTop
      Alignment = taCenter
      Caption = 'Report Generated'
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'FontAwesome'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      ExplicitWidth = 147
    end
    object ListBox1: TListBox
      Left = 0
      Top = 21
      Width = 185
      Height = 294
      Style = lbOwnerDrawFixed
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'FontAwesome'
      Font.Style = []
      ItemHeight = 21
      ParentFont = False
      TabOrder = 0
      OnDblClick = ListBox1DblClick
      OnDrawItem = ListBox1DrawItem
      ExplicitHeight = 296
    end
  end
  object FlowPanel1: TFlowPanel
    Left = 0
    Top = 0
    Width = 768
    Height = 43
    Align = alTop
    AutoSize = True
    TabOrder = 2
    object ScrollBar1: TScrollBar
      AlignWithMargins = True
      Left = 4
      Top = 11
      Width = 155
      Height = 21
      Margins.Top = 10
      Margins.Right = 50
      Margins.Bottom = 10
      Align = alClient
      Max = 300
      Min = 20
      PageSize = 0
      Position = 20
      TabOrder = 0
      OnChange = ScrollBar1Change
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 212
      Top = 4
      Width = 42
      Height = 35
      Align = alRight
      Caption = 'X'
      TabOrder = 1
      OnClick = btnPrintClick
    end
    object btnScale: TButton
      AlignWithMargins = True
      Left = 260
      Top = 4
      Width = 170
      Height = 35
      Align = alRight
      Caption = 'Scale'
      TabOrder = 2
      OnClick = btnScaleClick
    end
    object btnLast: TButton
      AlignWithMargins = True
      Left = 436
      Top = 4
      Width = 75
      Height = 35
      Align = alRight
      Caption = '|<'
      TabOrder = 3
      OnClick = btnFirstClick
    end
    object btnPrev: TButton
      AlignWithMargins = True
      Left = 517
      Top = 4
      Width = 75
      Height = 35
      Align = alRight
      Caption = '<<'
      TabOrder = 4
      OnClick = btnPrevClick
    end
    object btnNext: TButton
      AlignWithMargins = True
      Left = 598
      Top = 4
      Width = 75
      Height = 35
      Align = alRight
      Caption = '>>'
      TabOrder = 5
      OnClick = btnNextClick
    end
    object btnFirst: TButton
      AlignWithMargins = True
      Left = 679
      Top = 4
      Width = 75
      Height = 35
      Align = alRight
      Caption = '>|'
      TabOrder = 6
      OnClick = btnLastClick
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 416
    Top = 288
  end
end
