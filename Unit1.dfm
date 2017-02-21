object Form1: TForm1
  Left = 295
  Top = 94
  Caption = 'Form1'
  ClientHeight = 288
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 113
    Width = 57
    Height = 25
    Caption = 'StartRec'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 71
    Top = 113
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = Button2Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 9
    Width = 361
    Height = 80
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = ListBox1DblClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 144
    Width = 358
    Height = 137
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
  object Button3: TButton
    Left = 291
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 4
    OnClick = Button3Click
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 95
    Width = 241
    Height = 17
    TabOrder = 5
  end
  object SaveDialog1: TSaveDialog
    Left = 328
    Top = 16
  end
  object DXAudioIn1: TDXAudioIn
    Latency = 100
    SamplesToRead = -1
    DeviceNumber = 0
    InBitsPerSample = 16
    InChannels = 1
    InSampleRate = 8000
    RecTime = -1
    EchoRecording = False
    FramesInBuffer = 24576
    PollingInterval = 10
    Left = 16
  end
  object SincFilter1: TSincFilter
    Input = DXAudioIn1
    FilterType = ftBandPass
    HighFreq = 4000
    KernelWidth = 32
    LowFreq = 300
    WindowType = fwBlackman
    Left = 48
  end
  object FLACOut1: TFLACOut
    Input = FastGainIndicator1
    ShareMode = 0
    BestModelSearch = False
    BlockSize = 4608
    CompressionLevel = -1
    EnableMidSideStereo = True
    EnableLooseMidSideStereo = False
    MaxLPCOrder = 0
    MaxResidualPartitionOrder = 0
    MinResidualPartitionOrder = 0
    QLPCoeffPrecision = 0
    QLPCoeffPrecisionSearch = False
    Verify = False
    Left = 112
  end
  object FastGainIndicator1: TFastGainIndicator
    Input = DXAudioIn1
    Interval = 100
    OnGainData = FastGainIndicator1GainData
    Left = 80
  end
end
