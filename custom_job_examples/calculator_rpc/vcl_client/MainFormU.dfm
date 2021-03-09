object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnCalc: TButton
    Left = 24
    Top = 24
    Width = 129
    Height = 41
    Caption = 'Do Some Calc'
    TabOrder = 0
    OnClick = btnCalcClick
  end
end
