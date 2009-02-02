object Form1: TForm1
  Left = 196
  Top = 114
  Width = 633
  Height = 480
  Caption = 'Form1'
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
  object SongName: TLabel
    Left = 120
    Top = 8
    Width = 145
    Height = 20
    Caption = 'No Module loaded'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object NowPlaying: TLabel
    Left = 176
    Top = 288
    Width = 56
    Height = 13
    Caption = 'NowPlaying'
  end
  object np2: TLabel
    Left = 176
    Top = 304
    Width = 18
    Height = 13
    Caption = 'np2'
  end
  object Timer: TLabel
    Left = 80
    Top = 376
    Width = 26
    Height = 13
    Caption = 'Timer'
  end
  object np3: TLabel
    Left = 176
    Top = 320
    Width = 18
    Height = 13
    Caption = 'np3'
  end
  object np4: TLabel
    Left = 176
    Top = 336
    Width = 18
    Height = 13
    Caption = 'np4'
  end
  object ModType: TLabel
    Left = 312
    Top = 8
    Width = 45
    Height = 13
    Caption = 'ModType'
  end
  object Volume: TLabel
    Left = 264
    Top = 360
    Width = 35
    Height = 13
    Caption = 'Volume'
  end
  object Chan_Teller: TLabel
    Left = 408
    Top = 360
    Width = 57
    Height = 13
    Caption = 'Chan_Teller'
  end
  object Chan_Teller_Effect: TLabel
    Left = 408
    Top = 392
    Width = 91
    Height = 13
    Caption = 'Chan_Teller_Effect'
  end
  object LoadButton: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Open'
    TabOrder = 0
    OnClick = LoadButtonClick
  end
  object InstrumentGroup: TGroupBox
    Left = 8
    Top = 40
    Width = 185
    Height = 105
    Caption = 'Samples'
    TabOrder = 1
    object InstrumentList: TListBox
      Left = 2
      Top = 15
      Width = 181
      Height = 88
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object TrackOrderGroup: TGroupBox
    Left = 544
    Top = 40
    Width = 73
    Height = 105
    Caption = 'Track order'
    TabOrder = 2
    object TrackOrderList: TListBox
      Left = 2
      Top = 15
      Width = 69
      Height = 88
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnMouseDown = TrackOrderListMouseDown
    end
  end
  object TrackGroup: TGroupBox
    Left = 8
    Top = 152
    Width = 609
    Height = 105
    Caption = 'Track #0'
    TabOrder = 3
    object Splitter1: TSplitter
      Left = 161
      Top = 15
      Width = 3
      Height = 88
      Cursor = crHSplit
    end
    object Splitter2: TSplitter
      Left = 285
      Top = 15
      Width = 3
      Height = 88
      Cursor = crHSplit
    end
    object Splitter3: TSplitter
      Left = 409
      Top = 15
      Width = 3
      Height = 88
      Cursor = crHSplit
    end
    object TrackDataC1: TListBox
      Left = 2
      Top = 15
      Width = 159
      Height = 88
      Align = alLeft
      ItemHeight = 13
      TabOrder = 0
    end
    object TrackDataC2: TListBox
      Left = 164
      Top = 15
      Width = 121
      Height = 88
      Align = alLeft
      ItemHeight = 13
      TabOrder = 1
    end
    object TrackDataC3: TListBox
      Left = 288
      Top = 15
      Width = 121
      Height = 88
      Align = alLeft
      ItemHeight = 13
      TabOrder = 2
    end
    object TrackDataC4: TListBox
      Left = 412
      Top = 15
      Width = 195
      Height = 88
      Align = alClient
      ItemHeight = 13
      TabOrder = 3
    end
  end
  object PlaySampleButton: TButton
    Left = 200
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Play Sample'
    Enabled = False
    TabOrder = 4
    OnClick = PlaySampleButtonClick
  end
  object PlaySongButton: TButton
    Left = 64
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Play Song'
    TabOrder = 5
    OnClick = PlaySongButtonClick
  end
  object OpenDialog: TOpenDialog
    Filter = 'MOD|*.mod'
    Title = 'Open MOD file'
    Left = 88
    Top = 8
  end
  object ThreadedTimer1: TThreadedTimer
    OnTimer = Timer1Timer
    ThreadPriority = tpHigher
    Left = 16
    Top = 320
  end
end
