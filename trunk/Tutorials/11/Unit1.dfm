object Form1: TForm1
  Left = 192
  Top = 114
  Caption = 'OpenAL #11'
  ClientHeight = 125
  ClientWidth = 169
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Play: TButton
    Left = 48
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Play'
    TabOrder = 0
    OnClick = PlayClick
  end
  object Stop: TButton
    Left = 48
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = StopClick
  end
  object Pause: TButton
    Left = 48
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Pause'
    TabOrder = 2
    OnClick = PauseClick
  end
end
