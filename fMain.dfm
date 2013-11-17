object MainForm: TMainForm
  Left = 0
  Top = 0
  Action = AboutAction
  ActiveControl = InputFrame.InputEdit
  Caption = 'About'
  ClientHeight = 540
  ClientWidth = 618
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Consolas'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDefault
  OnActivate = FormActivate
  OnClick = AboutActionExecute
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Splitter1: TSplitter
    Left = 150
    Top = 0
    Height = 540
    AutoSnap = False
    ResizeStyle = rsUpdate
    ExplicitLeft = 312
    ExplicitTop = 136
    ExplicitHeight = 100
  end
  object Splitter2: TSplitter
    Left = 465
    Top = 0
    Height = 540
    Align = alRight
    AutoSnap = False
    ResizeStyle = rsUpdate
    ExplicitLeft = 129
    ExplicitHeight = 346
  end
  object ChannelTree: TTreeView
    Left = 0
    Top = 0
    Width = 150
    Height = 540
    Align = alLeft
    BorderStyle = bsNone
    DragMode = dmAutomatic
    HideSelection = False
    Indent = 19
    ReadOnly = True
    ShowLines = False
    TabOrder = 1
    OnChange = ChannelTreeChange
    OnCollapsing = ChannelTreeCollapsing
    OnCustomDrawItem = ChannelTreeCustomDrawItem
    OnDblClick = ChannelTreeDblClick
    OnDragDrop = ChannelTreeDragDrop
    OnDragOver = ChannelTreeDragOver
    OnExpanding = ChannelTreeCollapsing
    OnMouseDown = ChannelTreeMouseDown
  end
  object CenterPanel: TPanel
    Left = 153
    Top = 0
    Width = 312
    Height = 540
    Align = alClient
    BevelOuter = bvNone
    FullRepaint = False
    ParentBackground = False
    TabOrder = 2
    object Splitter3: TSplitter
      Left = 0
      Top = 467
      Width = 312
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
      ResizeStyle = rsUpdate
      ExplicitLeft = -8
      ExplicitTop = 134
      ExplicitWidth = 394
    end
    inline InputFrame: TInputFrame
      Left = 0
      Top = 470
      Width = 312
      Height = 70
      Align = alBottom
      TabOrder = 0
      ExplicitTop = 470
      ExplicitWidth = 312
      ExplicitHeight = 70
      inherited InputEdit: TRichEdit
        Width = 312
        Height = 70
        PopupMenu = EditPopup
        ExplicitWidth = 312
        ExplicitHeight = 70
      end
    end
  end
  object NicknameList: TListView
    Left = 468
    Top = 0
    Width = 150
    Height = 540
    Align = alRight
    BorderStyle = bsNone
    Columns = <
      item
        AutoSize = True
      end>
    HideSelection = False
    ReadOnly = True
    PopupMenu = NicknamePopup
    ShowColumnHeaders = False
    SortType = stData
    TabOrder = 0
    ViewStyle = vsReport
    OnCompare = NicknameListCompare
    OnDblClick = NicknameListDblClick
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    Left = 8
    Top = 8
    object File1: TMenuItem
      Caption = '&File'
      object NewServer1: TMenuItem
        Action = NewServerAction
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = ExitAction
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object Undo1: TMenuItem
        Action = UndoAction
      end
      object Redo1: TMenuItem
        Action = RedoAction
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Cut1: TMenuItem
        Action = CutAction
      end
      object Copy1: TMenuItem
        Action = CopyAction
      end
      object Paste1: TMenuItem
        Action = PasteAction
      end
      object Delete1: TMenuItem
        Action = DeleteAction
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object About2: TMenuItem
        Action = SelectAllAction
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object ThemeItem: TMenuItem
        Caption = 'Theme'
      end
      object RawCommands1: TMenuItem
        Action = RawAction
        AutoCheck = True
      end
    end
    object ools1: TMenuItem
      Caption = '&Tools'
      object Options1: TMenuItem
        Action = OptionsAction
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Action = AboutAction
      end
    end
    object asdf1: TMenuItem
      Caption = 'asdf'
      OnClick = asdf1Click
    end
    object qwert1: TMenuItem
      Caption = 'qwert'
      OnClick = qwert1Click
    end
  end
  object ActionList: TActionList
    Left = 40
    Top = 8
    object NewServerAction: TAction
      Caption = 'New Server'
      ShortCut = 16462
      OnExecute = NewServerActionExecute
    end
    object OptionsAction: TAction
      Caption = 'Options'
      OnExecute = OptionsActionExecute
    end
    object AboutAction: TAction
      Caption = 'About'
      OnExecute = AboutActionExecute
    end
    object ExitAction: TAction
      Caption = 'Exit'
      OnExecute = ExitActionExecute
    end
    object RawAction: TAction
      AutoCheck = True
      Caption = 'Raw'
      OnExecute = RawActionExecute
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnActivate = ApplicationEventsActivate
    OnMessage = ApplicationEventsMessage
    Left = 8
    Top = 40
  end
  object IdAntiFreeze: TIdAntiFreeze
    Left = 40
    Top = 40
  end
  object EditActions: TActionList
    Left = 72
    Top = 8
    object UndoAction: TAction
      Caption = 'Undo'
      ShortCut = 16474
      OnExecute = UndoActionExecute
      OnUpdate = UndoActionUpdate
    end
    object RedoAction: TAction
      Caption = 'Redo'
      ShortCut = 24666
      OnExecute = RedoActionExecute
      OnUpdate = RedoActionUpdate
    end
    object CutAction: TAction
      Caption = 'Cut'
      ShortCut = 16472
      OnExecute = CutActionExecute
      OnUpdate = CutActionUpdate
    end
    object CopyAction: TAction
      Caption = 'Copy'
      ShortCut = 16451
      OnExecute = CopyActionExecute
      OnUpdate = CopyActionUpdate
    end
    object PasteAction: TAction
      Caption = 'Paste'
      ShortCut = 16470
      OnExecute = PasteActionExecute
      OnUpdate = PasteActionUpdate
    end
    object SelectAllAction: TAction
      Caption = 'Select All'
      ShortCut = 16449
      OnExecute = SelectAllActionExecute
      OnUpdate = SelectAllActionUpdate
    end
    object DeleteAction: TAction
      Caption = 'Delete'
      ShortCut = 46
      OnExecute = DeleteActionExecute
      OnUpdate = DeleteActionUpdate
    end
  end
  object NicknamePopup: TPopupMenu
    OnPopup = NicknamePopupPopup
    Left = 472
    Top = 8
    object Whois1: TMenuItem
      Action = WhoisAction
    end
    object Query1: TMenuItem
      Action = QueryAction
    end
  end
  object NicknameActions: TActionList
    Left = 504
    Top = 8
    object WhoisAction: TAction
      Caption = 'Whois'
      OnExecute = WhoisActionExecute
    end
    object QueryAction: TAction
      Caption = 'Query'
      OnExecute = QueryActionExecute
    end
  end
  object CaptionTimer: TTimer
    Interval = 60000
    OnTimer = CaptionTimerTimer
    Left = 72
    Top = 40
  end
  object EditPopup: TPopupMenu
    Left = 8
    Top = 72
    object Undo2: TMenuItem
      Action = UndoAction
    end
    object Redo2: TMenuItem
      Action = RedoAction
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Cut2: TMenuItem
      Action = CutAction
    end
    object Copy2: TMenuItem
      Action = CopyAction
    end
    object Paste2: TMenuItem
      Action = PasteAction
    end
    object Delete2: TMenuItem
      Action = DeleteAction
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object SelectAll1: TMenuItem
      Action = SelectAllAction
    end
  end
  object IdIdentServer: TIdIdentServer
    Bindings = <>
    OnIdentQuery = IdIdentServerIdentQuery
    Left = 40
    Top = 72
  end
  object ChannelPopup: TPopupMenu
    Left = 8
    Top = 104
    object Join1: TMenuItem
      Action = JoinAction
    end
    object Part1: TMenuItem
      Action = PartAction
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object AutoJoin1: TMenuItem
      Action = AutoJoinAction
      AutoCheck = True
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object Close1: TMenuItem
      Action = CloseChannelAction
    end
  end
  object ServerPopup: TPopupMenu
    Left = 8
    Top = 136
    object Connect1: TMenuItem
      Action = ConnectAction
    end
    object Delete3: TMenuItem
      Action = DisconnectAction
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object AutoConnect1: TMenuItem
      Action = AutoConnectAction
      AutoCheck = True
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object Close2: TMenuItem
      Action = CloseServerAction
    end
  end
  object ChannelActions: TActionList
    Left = 40
    Top = 104
    object JoinAction: TAction
      Caption = 'Join'
      OnExecute = JoinActionExecute
    end
    object PartAction: TAction
      Caption = 'Part'
      OnExecute = PartActionExecute
    end
    object AutoJoinAction: TAction
      AutoCheck = True
      Caption = 'Auto-Join'
      OnExecute = AutoJoinActionExecute
      OnUpdate = AutoJoinActionUpdate
    end
    object CloseChannelAction: TAction
      Caption = 'Close'
      OnExecute = CloseChannelActionExecute
    end
  end
  object ServerActions: TActionList
    Left = 40
    Top = 136
    object ConnectAction: TAction
      Caption = 'Connect'
      OnExecute = ConnectActionExecute
    end
    object DisconnectAction: TAction
      Caption = 'Disconnect'
      OnExecute = DisconnectActionExecute
    end
    object AutoConnectAction: TAction
      AutoCheck = True
      Caption = 'Auto-Connect'
      OnExecute = AutoConnectActionExecute
      OnUpdate = AutoConnectActionUpdate
    end
    object CloseServerAction: TAction
      Caption = 'Close'
      OnExecute = CloseServerActionExecute
    end
  end
  object QueryPopup: TPopupMenu
    Left = 8
    Top = 168
    object Whois2: TMenuItem
      Action = WhoisQueryAction
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object CloseQueryAction1: TMenuItem
      Action = CloseQueryAction
    end
  end
  object QueryActions: TActionList
    Left = 40
    Top = 168
    object WhoisQueryAction: TAction
      Caption = 'Whois'
      OnExecute = WhoisQueryActionExecute
    end
    object CloseQueryAction: TAction
      Caption = 'Close'
      OnExecute = CloseQueryActionExecute
    end
  end
end
