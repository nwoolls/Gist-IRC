object OptionsForm: TOptionsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Options'
  ClientHeight = 362
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    527
    362)
  PixelsPerInch = 96
  TextHeight = 13
  object CancelButton: TButton
    Left = 440
    Top = 328
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object OkButton: TButton
    Left = 360
    Top = 328
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = OkButtonClick
  end
  object PagesList: TListView
    AlignWithMargins = True
    Left = 12
    Top = 12
    Width = 177
    Height = 308
    Margins.Left = 12
    Margins.Top = 12
    Margins.Right = 0
    Margins.Bottom = 42
    Align = alLeft
    Columns = <
      item
        AutoSize = True
      end>
    HideSelection = False
    ReadOnly = True
    ShowColumnHeaders = False
    TabOrder = 3
    ViewStyle = vsReport
    OnChange = PagesListChange
  end
  object HolderPanel: TPanel
    AlignWithMargins = True
    Left = 201
    Top = 12
    Width = 314
    Height = 308
    Margins.Left = 12
    Margins.Top = 12
    Margins.Right = 12
    Margins.Bottom = 42
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
end
