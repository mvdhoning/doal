object Form1: TForm1
  Left = 192
  Top = 114
  Width = 332
  Height = 277
  Caption = 'OpenAL #6'
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 113
    Height = 89
    Caption = 'DING'
    TabOrder = 0
    object Play: TButton
      Left = 16
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Play'
      TabOrder = 0
      OnClick = PlayClick
    end
    object Stop: TButton
      Left = 16
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 1
      OnClick = StopClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 128
    Top = 8
    Width = 185
    Height = 225
    Caption = 'DING 2'
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 120
      Width = 28
      Height = 13
      Caption = 'xpos :'
    end
    object Label2: TLabel
      Left = 16
      Top = 144
      Width = 28
      Height = 13
      Caption = 'ypos :'
    end
    object Label3: TLabel
      Left = 16
      Top = 168
      Width = 28
      Height = 13
      Caption = 'zpos :'
    end
    object Pause2: TButton
      Left = 8
      Top = 80
      Width = 75
      Height = 25
      Caption = 'Pause'
      TabOrder = 0
      OnClick = Pause2Click
    end
    object Play2: TButton
      Left = 8
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Play'
      TabOrder = 1
      OnClick = Play2Click
    end
    object Stop2: TButton
      Left = 8
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 2
      OnClick = Stop2Click
    end
    object xpos: TEdit
      Left = 56
      Top = 112
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '0.0'
    end
    object ypos: TEdit
      Left = 56
      Top = 136
      Width = 121
      Height = 21
      TabOrder = 4
      Text = '0.0'
    end
    object zpos: TEdit
      Left = 56
      Top = 160
      Width = 121
      Height = 21
      TabOrder = 5
      Text = '0.0'
    end
    object Update2: TButton
      Left = 104
      Top = 184
      Width = 75
      Height = 25
      Caption = 'Update'
      TabOrder = 6
      OnClick = Update2Click
    end
  end
end
