object AboutForm: TAboutForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'About'
  ClientHeight = 151
  ClientWidth = 256
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 18
    Height = 13
    Caption = 'Gist'
    Transparent = True
  end
  object VersionLabel: TLabel
    Left = 16
    Top = 32
    Width = 54
    Height = 13
    Caption = 'Version 1.0'
    Transparent = True
  end
  object Label3: TLabel
    Left = 16
    Top = 48
    Width = 94
    Height = 13
    Caption = 'by Nathanial Woolls'
    Transparent = True
  end
  object UrlLabel: TLabel
    Left = 16
    Top = 64
    Width = 111
    Height = 13
    Cursor = crHandPoint
    Caption = 'http://www.gistirc.com'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    Transparent = True
    OnClick = UrlLabelClick
  end
  object Button1: TButton
    Left = 168
    Top = 112
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
end
