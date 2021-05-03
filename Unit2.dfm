object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 360
  ClientWidth = 593
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 34
    Top = 165
    Width = 92
    Height = 13
    Caption = 'Enter the link here:'
  end
  object Label2: TLabel
    Left = 34
    Top = 101
    Width = 80
    Height = 13
    Caption = 'Enter login here:'
  end
  object Label3: TLabel
    Left = 449
    Top = 101
    Width = 104
    Height = 13
    Caption = 'Enter password here:'
  end
  object Label4: TLabel
    Left = 240
    Top = 211
    Width = 110
    Height = 13
    Caption = 'Enter book name here:'
  end
  object AuthBut: TButton
    Left = 264
    Top = 301
    Width = 75
    Height = 25
    Caption = 'Authorization'
    TabOrder = 0
    OnClick = AuthButClick
  end
  object GetBut: TButton
    Left = 478
    Top = 301
    Width = 75
    Height = 25
    Caption = 'Get'
    TabOrder = 1
    OnClick = GetButClick
  end
  object DownBut: TButton
    Left = 34
    Top = 301
    Width = 75
    Height = 25
    Caption = 'Download'
    TabOrder = 2
    OnClick = DownButClick
  end
  object LinkEd: TEdit
    Left = 34
    Top = 184
    Width = 519
    Height = 21
    TabOrder = 3
  end
  object ProgressBar1: TProgressBar
    Left = -4
    Top = 344
    Width = 597
    Height = 17
    TabOrder = 4
  end
  object logEd: TEdit
    Left = 34
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object pasEd: TEdit
    Left = 432
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object BookName: TEdit
    Left = 240
    Top = 232
    Width = 121
    Height = 21
    TabOrder = 7
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    HandleRedirects = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 128
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 96
  end
  object MainMenu1: TMainMenu
    object Help1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Info1: TMenuItem
      Caption = 'Help'
      object ReadMe1: TMenuItem
        Caption = 'ReadMe'
      end
    end
    object Info2: TMenuItem
      Caption = 'Info'
      OnClick = Info2Click
    end
  end
  object IdSMTP1: TIdSMTP
    SASLMechanisms = <>
    Left = 32
  end
  object IdMessage1: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 64
  end
end
