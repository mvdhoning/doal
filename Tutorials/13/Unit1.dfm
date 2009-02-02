object Form1: TForm1
  Left = 192
  Top = 114
  Width = 205
  Height = 186
  Caption = 'OpenAL #1'
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
    Enabled = False
    TabOrder = 0
    OnClick = PlayClick
  end
  object Stop: TButton
    Left = 48
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 1
    OnClick = StopClick
  end
  object Pause: TButton
    Left = 48
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Pause'
    Enabled = False
    TabOrder = 2
    OnClick = PauseClick
  end
  object SelectDevice: TComboBox
    Left = 8
    Top = 120
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'SelectDevice'
  end
  object SetDevice: TButton
    Left = 160
    Top = 120
    Width = 25
    Height = 21
    Caption = 'Ok'
    TabOrder = 4
    OnClick = SetDeviceClick
  end
end
