object InputFrame: TInputFrame
  Left = 0
  Top = 0
  Width = 383
  Height = 194
  TabOrder = 0
  object InputEdit: TRichEdit
    Left = 0
    Top = 0
    Width = 383
    Height = 194
    Align = alClient
    BorderStyle = bsNone
    HideSelection = False
    ParentColor = True
    ScrollBars = ssVertical
    TabOrder = 0
    WantTabs = True
    OnKeyDown = InputEditKeyDown
    OnKeyPress = InputEditKeyPress
  end
end
