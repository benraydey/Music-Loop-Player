object frmAddSample: TfrmAddSample
  Left = 732
  Top = 221
  Anchors = [akLeft, akTop, akRight, akBottom]
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Add a Sample'
  ClientHeight = 397
  ClientWidth = 282
  Color = clGray
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  ScreenSnap = True
  SnapBuffer = 0
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMoods: TPanel
    Left = 0
    Top = 208
    Width = 281
    Height = 89
    BevelOuter = bvNone
    Color = 9211020
    TabOrder = 0
    object lblMoods: TLabel
      Left = 8
      Top = 12
      Width = 45
      Height = 13
      Caption = 'Moods'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Lucida Console'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object chk5: TCheckBox
      Tag = -1
      Left = 160
      Top = 8
      Width = 97
      Height = 17
      Hint = 'Select the combination of moods that best describe the sample'
      TabStop = False
      Caption = 'Electric'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = checkBoxClick
    end
    object chk1: TCheckBox
      Tag = 1
      Left = 72
      Top = 8
      Width = 81
      Height = 17
      Hint = 'Select the combination of moods that best describe the sample'
      TabStop = False
      Caption = 'Acoustic'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = checkBoxClick
    end
    object chk6: TCheckBox
      Tag = -2
      Left = 160
      Top = 25
      Width = 81
      Height = 17
      Hint = 'Select the combination of moods that best describe the sample'
      TabStop = False
      Caption = 'Distorted'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = checkBoxClick
    end
    object chk3: TCheckBox
      Tag = 3
      Left = 72
      Top = 44
      Width = 81
      Height = 17
      Hint = 'Select the combination of moods that best describe the sample'
      TabStop = False
      Caption = 'Happy'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = checkBoxClick
    end
    object chk7: TCheckBox
      Tag = -3
      Left = 160
      Top = 43
      Width = 81
      Height = 17
      Hint = 'Select the combination of moods that best describe the sample'
      TabStop = False
      Caption = 'Sad'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = checkBoxClick
    end
    object chk8: TCheckBox
      Tag = -4
      Left = 160
      Top = 61
      Width = 81
      Height = 17
      Hint = 'Select the combination of moods that best describe the sample'
      TabStop = False
      Caption = 'Intense'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = checkBoxClick
    end
    object chk4: TCheckBox
      Tag = 4
      Left = 72
      Top = 62
      Width = 80
      Height = 17
      Hint = 'Select the combination of moods that best describe the sample'
      TabStop = False
      Caption = 'Relaxed'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = checkBoxClick
    end
    object chk2: TCheckBox
      Tag = 2
      Left = 72
      Top = 26
      Width = 81
      Height = 17
      Hint = 'Select the combination of moods that best describe the sample'
      TabStop = False
      Caption = 'Clean'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = checkBoxClick
    end
  end
  object pnlInstrument: TPanel
    Left = 0
    Top = 304
    Width = 281
    Height = 49
    BevelOuter = bvNone
    Color = 9211020
    TabOrder = 1
    object lblInstrument: TLabel
      Left = 8
      Top = 18
      Width = 90
      Height = 13
      Caption = 'Instrument'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Lucida Console'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblErrorInstrument: TLabel
      Left = 232
      Top = 0
      Width = 42
      Height = 45
      Caption = '*Please select Instrument'
      Font.Charset = ANSI_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object cmbInstrument: TComboBox
      Left = 105
      Top = 14
      Width = 121
      Height = 19
      Hint = 'Select an instrument'
      Color = clSilver
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      ItemHeight = 11
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'Instrument'
      OnChange = cmbInstrumentChange
      Items.Strings = (
        'Ac Guitar'
        'Bass'
        'Beats'
        'Bell'
        'Drums'
        'Elec Guitar'
        'FX'
        'Glockenspiel'
        'Harmonica'
        'Keyboards'
        'Organ'
        'Percussion'
        'Piano'
        'Shaker'
        'Synth Bass'
        'Synth'
        'Tambourine'
        'Vocals')
    end
  end
  object pnlGenre: TPanel
    Left = 0
    Top = 168
    Width = 281
    Height = 33
    BevelOuter = bvNone
    Color = 9211020
    TabOrder = 2
    object lblGenre: TLabel
      Left = 8
      Top = 12
      Width = 45
      Height = 13
      Caption = 'Genre'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Lucida Console'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblErrorGenre: TLabel
      Left = 224
      Top = 0
      Width = 52
      Height = 30
      Caption = '*Please select Genre'
      Font.Charset = ANSI_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object cmbGenre: TComboBox
      Left = 104
      Top = 7
      Width = 118
      Height = 19
      Hint = 'Select a Genre'
      Color = clSilver
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      ItemHeight = 11
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'Genre'
      OnChange = cmbGenreChange
    end
  end
  object pnlSelectFile: TPanel
    Left = 0
    Top = 0
    Width = 281
    Height = 161
    BevelOuter = bvNone
    Color = clMedGray
    TabOrder = 3
    object lblSelectWaveFile: TLabel
      Left = 8
      Top = 4
      Width = 63
      Height = 26
      Caption = 'Select Sample'
      Font.Charset = ANSI_CHARSET
      Font.Color = 4727808
      Font.Height = -13
      Font.Name = 'Lucida Console'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object lblErrorFileName: TLabel
      Left = 115
      Top = 27
      Width = 65
      Height = 15
      Caption = '*File Not Found'
      Font.Charset = ANSI_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object lblTempo: TLabel
      Left = 8
      Top = 132
      Width = 45
      Height = 13
      Caption = 'Tempo'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Lucida Console'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblWaveFile: TLabel
      Left = 72
      Top = 40
      Width = 3
      Height = 15
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblBars: TLabel
      Left = 152
      Top = 132
      Width = 36
      Height = 13
      Caption = 'Bars'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Lucida Console'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblName: TLabel
      Left = 8
      Top = 92
      Width = 99
      Height = 13
      Caption = 'Sample Name'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Lucida Console'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblErrorSampleName: TLabel
      Left = 120
      Top = 112
      Width = 87
      Height = 15
      Caption = '*Please give a name'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGradientInactiveCaption
      Font.Height = -11
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object lblErrorNameTaken: TLabel
      Left = 120
      Top = 112
      Width = 88
      Height = 15
      Caption = '*Name already taken'
      Font.Charset = ANSI_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Arial Narrow'
      Font.Style = []
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object btnBrowse: TButton
      Left = 219
      Top = 8
      Width = 57
      Height = 22
      Hint = 'Browse and select a wave file to add to library'
      Caption = 'Browse'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMenuHighlight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnBrowseClick
    end
    object edtFileName: TEdit
      Left = 95
      Top = 8
      Width = 121
      Height = 21
      Color = clGradientInactiveCaption
      TabOrder = 0
    end
    object spnedtTempo: TSpinEdit
      Left = 80
      Top = 126
      Width = 49
      Height = 26
      Hint = 'Tempo of sample in beats per minute'
      Color = clScrollBar
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      MaxValue = 220
      MinValue = 40
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Value = 120
    end
    object btnPlaySample: TPanel
      Left = 16
      Top = 48
      Width = 49
      Height = 25
      Hint = 'Preview the sample'
      BevelOuter = bvNone
      Caption = '4'
      Color = clSilver
      Font.Charset = SYMBOL_CHARSET
      Font.Color = clGreen
      Font.Height = -27
      Font.Name = 'Webdings'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Visible = False
      OnClick = btnPlaySampleClick
    end
    object spnedtBars: TSpinEdit
      Left = 208
      Top = 126
      Width = 49
      Height = 26
      Hint = 'Length of sample in bars'
      Color = clScrollBar
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      MaxValue = 8
      MinValue = 1
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Value = 1
    end
    object edtSampleName: TEdit
      Left = 120
      Top = 88
      Width = 121
      Height = 23
      Hint = 'Give the sample a name'
      Color = clScrollBar
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial Narrow'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = 'New Sample'
      OnChange = edtSampleNameChange
    end
  end
  object btnAddSample: TButton
    Left = 24
    Top = 360
    Width = 113
    Height = 33
    Hint = 'Add the new sample to the library'
    Caption = 'Add Sample'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = btnAddSampleClick
  end
  object btnCancel: TButton
    Left = 160
    Top = 360
    Width = 97
    Height = 33
    Hint = 'Cancel'
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object dlgOpenFile: TOpenDialog
    Filter = 'Wave files (*.wav)|*.wav|'
    InitialDir = 'GetCurrentDir'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 248
    Top = 208
  end
  object waveStorage: TWaveStorage
    Left = 72
    Top = 112
  end
  object playerPreview: TALWavePlayer
    PumpPriority = 1
    Paused = True
    Loop = True
    ClockSource = csInternal
    PlaySegment.StopSample = 100
    PlaySegment.Enabled = False
    BufferSize = 8192
    OutputPin.SinkPins = (
      audioOutPreview.InputPin)
    Left = 24
    Top = 96
  end
  object audioOutPreview: TALAudioOut
    PumpPriority = 0
    Device.AlternativeDevices = <>
    Device.DeviceName = 'Default'
    InputPin.SourcePin = playerPreview.OutputPin
    Left = 24
    Top = 128
  end
end
