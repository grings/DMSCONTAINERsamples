object framePDF: TframePDF
  Left = 0
  Top = 0
  Width = 756
  Height = 377
  TabOrder = 0
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 756
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = -377
    ExplicitWidth = 871
    object btnNext: TButton
      AlignWithMargins = True
      Left = 597
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = '>>'
      TabOrder = 0
      OnClick = btnNextClick
      ExplicitLeft = 712
    end
    object btnPrev: TButton
      AlignWithMargins = True
      Left = 516
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = '<<'
      TabOrder = 1
      OnClick = btnPrevClick
      ExplicitLeft = 631
    end
    object btnScale: TButton
      AlignWithMargins = True
      Left = 259
      Top = 3
      Width = 170
      Height = 35
      Align = alRight
      Caption = 'Scale'
      TabOrder = 2
      OnClick = btnScaleClick
      ExplicitLeft = 374
    end
    object btnPrint: TButton
      AlignWithMargins = True
      Left = 211
      Top = 3
      Width = 42
      Height = 35
      Align = alRight
      Caption = 'X'
      TabOrder = 3
      OnClick = btnPrintClick
      ExplicitLeft = 326
    end
    object ScrollBar1: TScrollBar
      AlignWithMargins = True
      Left = 3
      Top = 10
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
      TabOrder = 4
      OnChange = ScrollBar1Change
      ExplicitTop = 7
    end
    object btnLast: TButton
      AlignWithMargins = True
      Left = 678
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = '>|'
      TabOrder = 5
      OnClick = btnLastClick
      ExplicitLeft = 793
    end
    object btnFirst: TButton
      AlignWithMargins = True
      Left = 435
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = '|<'
      TabOrder = 6
      OnClick = btnFirstClick
      ExplicitLeft = 550
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 358
    Width = 756
    Height = 19
    Panels = <
      item
        Width = 200
      end>
    ExplicitLeft = -526
    ExplicitWidth = 1282
  end
  object pnlGenReports: TPanel
    Left = 0
    Top = 41
    Width = 185
    Height = 317
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnlGenReports'
    TabOrder = 2
    ExplicitLeft = 1
    ExplicitTop = -181
    ExplicitHeight = 558
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
      Height = 296
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
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 416
    Top = 288
  end
end
