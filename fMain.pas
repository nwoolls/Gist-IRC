unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Menus, Contnrs, dmConnection, fInput,
  fChat, ActnList, uIRCRichEdit, AppEvnts, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, IdComponent,
  IdCustomTCPServer, IdIdentServer, IdContext;

const
  WM_CHANNELJOINED = WM_USER + 1;
  WM_SETTOPICTEXT = WM_USER + 3;
  WM_NICKNAMESLIST = WM_USER + 4;
  WM_SETAPPCAPTION = WM_USER + 5;
  WM_NICKSINUSE = WM_USER + 6;
  WM_ADDNICK = WM_USER + 7;
  WM_REMOVENICK = WM_USER + 8;
  WM_PAINTCHANNELS = WM_USER + 9;
  WM_ENABLEIDENT = WM_USER + 10;
  WM_DISABLEIDENT = WM_USER + 11;
  WM_FOCUSINPUT = WM_USER + 12;
  WM_AFTERSHOWN = WM_USER + 13;
  WM_AUTOJOIN = WM_USER + 14;
  WM_AUTOJOINDONE = WM_USER + 15;

type

  TMainForm = class(TForm)
    ChannelTree: TTreeView;
    CenterPanel: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    NicknameList: TListView;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    View1: TMenuItem;
    Help1: TMenuItem;
    InputFrame: TInputFrame;
    ActionList: TActionList;
    NewServerAction: TAction;
    NewServer1: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    IdAntiFreeze: TIdAntiFreeze;
    ools1: TMenuItem;
    OptionsAction: TAction;
    AboutAction: TAction;
    ThemeItem: TMenuItem;
    EditActions: TActionList;
    Options1: TMenuItem;
    About1: TMenuItem;
    CutAction: TAction;
    Cut1: TMenuItem;
    UndoAction: TAction;
    RedoAction: TAction;
    CopyAction: TAction;
    PasteAction: TAction;
    SelectAllAction: TAction;
    DeleteAction: TAction;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    About2: TMenuItem;
    N1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N2: TMenuItem;
    NicknamePopup: TPopupMenu;
    NicknameActions: TActionList;
    WhoisAction: TAction;
    Whois1: TMenuItem;
    QueryAction: TAction;
    Query1: TMenuItem;
    ExitAction: TAction;
    N3: TMenuItem;
    Exit1: TMenuItem;
    CaptionTimer: TTimer;
    RawCommands1: TMenuItem;
    RawAction: TAction;
    EditPopup: TPopupMenu;
    Undo2: TMenuItem;
    Redo2: TMenuItem;
    N4: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    Delete2: TMenuItem;
    N5: TMenuItem;
    SelectAll1: TMenuItem;
    asdf1: TMenuItem;
    IdIdentServer: TIdIdentServer;
    ChannelPopup: TPopupMenu;
    ServerPopup: TPopupMenu;
    ChannelActions: TActionList;
    ServerActions: TActionList;
    JoinAction: TAction;
    PartAction: TAction;
    AutoJoinAction: TAction;
    Join1: TMenuItem;
    Part1: TMenuItem;
    N6: TMenuItem;
    AutoJoin1: TMenuItem;
    ConnectAction: TAction;
    DisconnectAction: TAction;
    AutoConnectAction: TAction;
    Connect1: TMenuItem;
    Delete3: TMenuItem;
    N7: TMenuItem;
    AutoConnect1: TMenuItem;
    CloseChannelAction: TAction;
    CloseServerAction: TAction;
    Close1: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    Close2: TMenuItem;
    QueryPopup: TPopupMenu;
    QueryActions: TActionList;
    WhoisQueryAction: TAction;
    CloseQueryAction: TAction;
    Whois2: TMenuItem;
    N10: TMenuItem;
    CloseQueryAction1: TMenuItem;
    qwert1: TMenuItem;
    procedure AboutActionExecute(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure ApplicationEventsMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure asdf1Click(Sender: TObject);
    procedure AutoConnectActionExecute(Sender: TObject);
    procedure AutoConnectActionUpdate(Sender: TObject);
    procedure AutoJoinActionExecute(Sender: TObject);
    procedure AutoJoinActionUpdate(Sender: TObject);
    procedure CaptionTimerTimer(Sender: TObject);
    procedure ChannelTreeChange(Sender: TObject; Node: TTreeNode);
    procedure ChannelTreeCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
    procedure ChannelTreeCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ChannelTreeDblClick(Sender: TObject);
    procedure ChannelTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ChannelTreeDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ChannelTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CloseChannelActionExecute(Sender: TObject);
    procedure CloseQueryActionExecute(Sender: TObject);
    procedure CloseServerActionExecute(Sender: TObject);
    procedure ConnectActionExecute(Sender: TObject);
    procedure CopyActionExecute(Sender: TObject);
    procedure CopyActionUpdate(Sender: TObject);
    procedure CutActionExecute(Sender: TObject);
    procedure CutActionUpdate(Sender: TObject);
    procedure DeleteActionExecute(Sender: TObject);
    procedure DeleteActionUpdate(Sender: TObject);
    procedure DisconnectActionExecute(Sender: TObject);
    procedure ExitActionExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IdIdentServerIdentQuery(AContext: TIdContext; AServerPort, AClientPort: Word);
    procedure JoinActionExecute(Sender: TObject);
    procedure NewServerActionExecute(Sender: TObject);
    procedure NicknameListCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure NicknameListDblClick(Sender: TObject);
    procedure NicknamePopupPopup(Sender: TObject);
    procedure OptionsActionExecute(Sender: TObject);
    procedure PartActionExecute(Sender: TObject);
    procedure PasteActionExecute(Sender: TObject);
    procedure PasteActionUpdate(Sender: TObject);
    procedure QueryActionExecute(Sender: TObject);
    procedure qwert1Click(Sender: TObject);
    procedure RawActionExecute(Sender: TObject);
    procedure RedoActionExecute(Sender: TObject);
    procedure RedoActionUpdate(Sender: TObject);
    procedure SelectAllActionExecute(Sender: TObject);
    procedure SelectAllActionUpdate(Sender: TObject);
    procedure UndoActionExecute(Sender: TObject);
    procedure UndoActionUpdate(Sender: TObject);
    procedure WhoisActionExecute(Sender: TObject);
    procedure WhoisQueryActionExecute(Sender: TObject);
  private
    FConnections: TObjectList;
    FTopicEdit: TIRCRichEdit;
    FTheme: TStrings;
    FCurrentTheme: string;
    FIdentCount: Integer;
    FFormShown: Boolean;
    FAutoJoining: TStrings;
    procedure SpamLines(const ACount: Integer; const ARawCommand: string);
    procedure AutoSizeTopicEdit;
    procedure SetChatFrameFontSizes(const AFontSize: Integer);
    procedure SetTopicFontSize(const AFontSize: Integer);
    procedure RefreshForSelectedNode(const ANode: TTreeNode);
    procedure AutoJoinForServer(const AConnection: TConnectionData);
    procedure SetTopicText(const ATopic: string);
    procedure ReloadServerChatContents;
    procedure SetAppCaption;
    procedure NewServerWindow;
    function GetActiveConnection: TConnectionData;
    procedure WmChannelJoined(var Message: TMessage); message WM_CHANNELJOINED;
    procedure WmSetTopicText(var Message: TMessage); message WM_SETTOPICTEXT;
    procedure WmNicknamesList(var Message: TMessage); message WM_NICKNAMESLIST;
    procedure WmSetAppCaption(var Message: TMessage); message WM_SETAPPCAPTION;
    procedure WmNicksInUse(var Message: TMessage); message WM_NICKSINUSE;
    procedure WmAddNick(var Message: TMessage); message WM_ADDNICK;       
    procedure WmRemoveNick(var Message: TMessage); message WM_REMOVENICK;
    procedure WmPaintChannels(var Message: TMessage); message WM_PAINTCHANNELS;
    procedure WmEnableIdent(var Message: TMessage); message WM_ENABLEIDENT;
    procedure WmDisableIdent(var Message: TMessage); message WM_DISABLEIDENT;
    procedure WmFocusInput(var Message: TMessage); message WM_FOCUSINPUT;
    procedure WmAfterShown(var Message: TMessage); message WM_AFTERSHOWN;
    procedure WmAutoJoin(var Message: TMessage); message WM_AUTOJOIN;
    function GlobalGetAtom(const AAtom: Integer): string;
    function GetActiveTarget: string;
    function GetActiveChatFrame: TChatFrame;
    procedure CreateTopicEdit;
    procedure TopicEditURLClick(Sender: TObject; const URL: string);
    procedure SetupThemeColors;
    function HtmlToColor(const AHtmlColor: string): TColor;
    function GetCurrentTheme: string;
    procedure TopicEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TopicEditKeyPress(Sender: TObject; var Key: Char);   
    function FindServerNode(const AConnection: TConnectionData): TTreeNode;
    procedure PopulateThemes;
    procedure ThemeItemClick(Sender: TObject);
    procedure ReloadTheme;
    procedure LoadThemeFromFile;
    procedure SaveSettings;
    function SelectedNickname: string;
    function ChatFrameForNode(const ATreeNode: TTreeNode): TChatFrame;
    procedure SetFontSize(const AFontSize: Integer);
    procedure SaveConnections;
    procedure LoadConnections;
    procedure AutoConnectToServers;
    procedure LoadLayout;
    procedure SaveLayout;
    procedure LoadPosition;
    procedure SavePosition;
  public
    procedure Loaded; override;
    procedure RedrawWindow(const AHandle: THandle; const AChildren: Boolean);
    function FindChatNode(const AConnection: TConnectionData; const ATarget: string): TTreeNode;
    function CreateServerNode(const AConnection: TConnectionData): TTreeNode;
    function CreateChatNode(const AConnection: TConnectionData; const ATarget: string): TTreeNode;
    function CreateChatFrame(const ATreeNode: TTreeNode): TChatFrame;
    property ActiveConnection: TConnectionData read GetActiveConnection;
    property ActiveTarget: string read GetActiveTarget;
    property ActiveChatFrame: TChatFrame read GetActiveChatFrame;
    procedure PopulateNickList;
    property TopicEdit: TIRCRichEdit read FTopicEdit;
    property CurrentTheme: string read GetCurrentTheme; 
    procedure PopulateTopic;        
    procedure PopulateAppCaption;
    property Connections: TObjectList read FConnections;
  end;
  
var
  MainForm: TMainForm;

implementation

uses uNickNamesListParam, ShellAPI, uConst, fAbout, fOptions, IniFiles,
  uEditFuncs, uCommandHandler, uTokenizer, uIRCColors, Math, Clipbrd;

{$R *.dfm}

procedure TMainForm.AboutActionExecute(Sender: TObject);
var
  AboutForm: TAboutForm;
begin
  AboutForm := TAboutForm.Create(Self);
  try
    AboutForm.ShowModal;
  finally
    AboutForm.Free;
  end;
end;

procedure TMainForm.ApplicationEventsActivate(Sender: TObject);
begin
  if Assigned(ActiveChatFrame) and not (csDestroying in ComponentState) then
    ActiveChatFrame.MarkerDropped := False;
end;

procedure TMainForm.ApplicationEventsMessage(var Msg: tagMSG; var Handled: Boolean);
var
  MousePos: TPoint;
  MouseControl: TWinControl;
  Delta, Keys: Integer;
begin
  //mouse wheel scrolling for the control under the mouse
  if Msg.message = WM_MOUSEWHEEL then
  begin
    Keys := LoWord(Msg.wParam);

    if (Keys and MK_CONTROL = MK_CONTROL) then
    begin
      Delta := Short(HiWord(Msg.wParam));
      Delta := Delta div 120;
      SetFontSize(Font.Size + Delta);
    end else
    begin
      MousePos.X := Short(Word(Msg.lParam));
      MousePos.Y := Short(HiWord(Msg.lParam));

      MouseControl := FindVCLWindow(MousePos);
      if MouseControl = nil then
        Handled := True
      else
      if MouseControl.Handle <> Msg.hwnd then
      begin
        SendMessage(MouseControl.Handle, WM_MOUSEWHEEL, Msg.wParam, Msg.lParam);
        Handled := True;
      end;
    end;
  end;
end;

procedure TMainForm.SpamLines(const ACount: Integer; const ARawCommand: string);
var
  ChatFrame: TChatFrame;
  I: Integer;
begin
  ChatFrame := ActiveChatFrame;
  ChatFrame.ChatEdit.Perform(WM_SETREDRAW, 0, 0);
  ChatFrame.ChatEdit.Lines.BeginUpdate;
  try
    for I := 0 to ACount - 1 do
      ChatFrame.AddIRCLine(ARawCommand, 'test', 'test@test.com', 'test', 'test', False, '', '', '', True);
    ChatFrame.DropMarker;
    ChatFrame.MarkerLine := ChatFrame.ChatEdit.Lines.Count - 1;
  finally
    ChatFrame.ChatEdit.Perform(WM_SETREDRAW, 1, 0);
    ChatFrame.ChatEdit.Lines.EndUpdate;
  end;
end;  

procedure TMainForm.qwert1Click(Sender: TObject);
var
  ChatFrame: TChatFrame;
  I: Integer;
begin
  ChatFrame := ActiveChatFrame;
  ChatFrame.ChatEdit.Perform(WM_SETREDRAW, 0, 0);
  ChatFrame.ChatEdit.Lines.BeginUpdate;
  try
//    for I := 0 to ACount - 1 do
//      ChatFrame.AddIRCLine(ARawCommand, 'test', 'test@test.com', 'test', 'test', False, '', '', '', True);
    ChatFrame.DropMarker;
    ChatFrame.MarkerLine := ChatFrame.ChatEdit.Lines.Count - 1;
  finally
    ChatFrame.ChatEdit.Perform(WM_SETREDRAW, 1, 0);
    ChatFrame.ChatEdit.Lines.EndUpdate;
  end;
  //SpamLines(1, 'RAWIN');
end;

procedure TMainForm.asdf1Click(Sender: TObject);
begin
  SpamLines(1, 'JOIN');
end;

procedure TMainForm.AutoConnectActionExecute(Sender: TObject);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    IniFile.WriteBool('AutoConnect', ChannelTree.Selected.Text, AutoConnectAction.Checked);
  finally
    IniFile.Free;
  end;
end;

procedure TMainForm.AutoConnectActionUpdate(Sender: TObject);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    AutoConnectAction.Checked := IniFile.ReadBool('AutoConnect', ChannelTree.Selected.Text, False);
  finally
    IniFile.Free;
  end;
end;

procedure TMainForm.AutoJoinActionExecute(Sender: TObject);
var
  IniFile: TIniFile;
  Channels: TStrings;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  Channels := TStringList.Create;
  try
    Channels.CommaText := IniFile.ReadString('AutoJoin', ChannelTree.Selected.Parent.Text, '');
    if AutoJoinAction.Checked then
      Channels.Add(ChannelTree.Selected.Text)
    else
      Channels.Delete(Channels.IndexOf(ChannelTree.Selected.Text));
    IniFile.WriteString('AutoJoin', ChannelTree.Selected.Parent.Text, Channels.CommaText);
  finally
    IniFile.Free;
    Channels.Free;
  end;
end;

procedure TMainForm.AutoJoinActionUpdate(Sender: TObject);
var
  IniFile: TIniFile;
  Channels: TStrings;
begin
  if ChannelTree.Selected.Level = 0 then
    Exit;

  IniFile := TIniFile.Create(SettingsFilePath);
  Channels := TStringList.Create;
  try
    Channels.CommaText := IniFile.ReadString('AutoJoin', ChannelTree.Selected.Parent.Text, '');
    AutoJoinAction.Checked := Channels.IndexOf(ChannelTree.Selected.Text) >= 0;
  finally
    IniFile.Free;
    Channels.Free;
  end;
end;

procedure TMainForm.AutoSizeTopicEdit;
begin
  TopicEdit.Height := Canvas.TextHeight('dummy') * 2; //set the height to 2 time font height - fit 2 lines end;
end;

procedure TMainForm.SetTopicFontSize(const AFontSize: Integer);
begin
  TopicEdit.SelectAll;
  TopicEdit.SelAttributes.Size := AFontSize;
  TopicEdit.SelStart := 0;
  AutoSizeTopicEdit;
end;

procedure TMainForm.SetChatFrameFontSizes(const AFontSize: Integer);
var
  I: Integer;
begin
  for I := 0 to CenterPanel.ControlCount - 1 do
    if CenterPanel.Controls[I] is TChatFrame  then
    begin
      TChatFrame(CenterPanel.Controls[I]).ChatEdit.SelectAll;
      TChatFrame(CenterPanel.Controls[I]).ChatEdit.SelAttributes.Size := AFontSize;
      TChatFrame(CenterPanel.Controls[I]).RecreateMarkerLine;
      TChatFrame(CenterPanel.Controls[I]).ChatEdit.SelStart := 0;
      TChatFrame(CenterPanel.Controls[I]).ChatEdit.SelStart := Length(TChatFrame(CenterPanel.Controls[I]).ChatEdit.Text);
    end;
end;

procedure TMainForm.SetFontSize(const AFontSize: Integer);
begin
  Perform(WM_SETREDRAW, 0, 0);
  try
    Font.Size := AFontSize;
    ChannelTree.Font.Size := AFontSize;
    InputFrame.InputEdit.Font.Size := AFontSize;
    NicknameList.Font.Size := AFontSize;

    SetTopicFontSize(AFontSize);

    SetChatFrameFontSizes(AFontSize);
  finally
    Perform(WM_SETREDRAW, 1, 0);
    RedrawWindow(Handle, True);
  end;
end;

procedure TMainForm.CaptionTimerTimer(Sender: TObject);
begin
  SetAppCaption;
end;

procedure TMainForm.RefreshForSelectedNode(const ANode: TTreeNode);
var
  ChatFrame: TChatFrame;
  Connection: TConnectionData;
begin
  if ANode.Selected  then
  begin
    ChatFrame := ChatFrameForNode(ANode);
    if not Assigned(ChatFrame) then
      Exit;

    if ANode.Level = 0  then
      ChannelTree.PopupMenu := ServerPopup
    else if ANode.Text[1] = '#' then
      ChannelTree.PopupMenu := ChannelPopup
    else
      ChannelTree.PopupMenu := QueryPopup;

    //ChatFrame.ChatEdit.PopupMenu := ChannelTree.PopupMenu;
    Perform(WM_SETREDRAW, 0, 0);
    try
      if ANode.Level = 1  then
        Connection := TConnectionData(ANode.Parent.Data)
      else
        Connection := TConnectionData(ANode.Data);
      ChatFrame.MarkerDropped := False;
      Connection.ActiveChat := ChatFrame;
      ChatFrame.BringToFront;
      PopulateNickList;
      PopulateTopic;
      PopulateAppCaption;
      Exit;
    finally
      //Perform(WM_SETREDRAW, 1, 0);
      //RedrawWindow(Handle, True);
    end;
  end;
end;

procedure TMainForm.ChannelTreeChange(Sender: TObject; Node: TTreeNode);
begin
  RefreshForSelectedNode(Node);
end;

procedure TMainForm.ChannelTreeCollapsing(Sender: TObject; Node: TTreeNode; var
    AllowCollapse: Boolean);
var
  HitTests: THitTests;
  Connection: TConnectionData;
  CursorPos: TPoint;
begin                                                                            
  CursorPos := ChannelTree.ScreenToClient(Mouse.CursorPos);
  HitTests := ChannelTree.GetHitTestInfoAt(CursorPos.X, CursorPos.Y);
  //double clicked?
  if (htOnLabel in HitTests) then
  begin
    Connection := TConnectionData(Node.Data);
    if not Connection.Connected then
    begin
      Connection.Connect;
      AllowCollapse := False;
    end;
  end;
end;

function TMainForm.ChatFrameForNode(const ATreeNode: TTreeNode): TChatFrame;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to CenterPanel.ControlCount - 1 do
    if (CenterPanel.Controls[I] is TChatFrame) and
      (TChatFrame(CenterPanel.Controls[I]).TreeNode = ATreeNode) then
    begin
      Result := TChatFrame(CenterPanel.Controls[I]);
      Exit;
    end;
end;

procedure TMainForm.ChannelTreeCustomDrawItem(Sender: TCustomTreeView; Node:
    TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  ChatFrame: TChatFrame;
begin
  ChatFrame := ChatFrameForNode(Node);
  if not Assigned(ChatFrame) then
    Exit;

  if Node.Selected then
  begin
    if ChannelTree.Focused then
    begin
      ChannelTree.Canvas.Brush.Color := clHighlight;
      ChannelTree.Canvas.Font.Color := clHighlightText;
    end else
    begin
      ChannelTree.Canvas.Brush.Color := clBtnFace;   
      ChannelTree.Canvas.Font.Color := clBtnText;
    end;
  end else
  begin
    ChannelTree.Canvas.Brush.Color := ChannelTree.Color;  
    if ChatFrame.MarkerDropped then
      ChannelTree.Canvas.Font.Color := $00FF8000
    else
      ChannelTree.Canvas.Font.Color := ChannelTree.Font.Color;
  end;
end;

procedure TMainForm.ChannelTreeDblClick(Sender: TObject);
begin
  if Assigned(ChannelTree.Selected) then
  begin
    if (ChannelTree.Selected.Level > 0) and (Length(ChannelTree.Selected.Text) > 0) then
    begin
      if ChannelTree.Selected.Text[1] = '#' then
        ActiveConnection.Join(ChannelTree.Selected.Text);
    end else if (ChannelTree.Selected.Level = 0) and (ChannelTree.Selected.Count = 0) then
      ActiveConnection.Connect;
  end;
end;

procedure TMainForm.ChannelTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
var
   TargetNode, Destination: TTreeNode;
   HT: THitTests;
begin
  if ChannelTree.Selected = nil then
    Exit;

  HT := ChannelTree.GetHitTestInfoAt(X, Y) ;
  TargetNode := ChannelTree.GetNodeAt(X, Y) ;
  if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent] <> HT) then
  begin
    if htOnIndent in HT then
      ChannelTree.Selected.MoveTo(TargetNode, naInsert)
    else
    begin
      Destination := TargetNode.GetNextSibling;
      if Destination = nil then
        ChannelTree.Selected.MoveTo(TargetNode, naAdd)
      else
        ChannelTree.Selected.MoveTo(Destination, naInsert);
    end;
  end;
end;

procedure TMainForm.ChannelTreeDragOver(Sender, Source: TObject; X, Y: Integer;
    State: TDragState; var Accept: Boolean);                               
var
  TargetNode, SourceNode : TTreeNode;
begin
  TargetNode := ChannelTree.GetNodeAt(X,Y);
  SourceNode := ChannelTree.Selected;
  Accept := Assigned(TargetNode) and Assigned(SourceNode) and
    ((TargetNode.Level = 1) and (SourceNode.Parent = TargetNode.Parent));
end;

procedure TMainForm.ChannelTreeMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
var
  Node: TTreeNode;
begin
  //can't do this in MouseUp as MouseUp is triggered by started a drag op
  PostMessage(Handle, WM_FOCUSINPUT, 0, 0);

  Node := ChannelTree.GetNodeAt(X, Y);
  if Assigned(Node) then
    Node.Selected := True;
end;

procedure TMainForm.ConnectActionExecute(Sender: TObject);
begin
  ActiveConnection.Connect;
end;

procedure TMainForm.CopyActionExecute(Sender: TObject);
begin
  uEditFuncs.CopyFromActiveControl;
end;

procedure TMainForm.CopyActionUpdate(Sender: TObject);
begin
  CopyAction.Enabled := uEditFuncs.ActiveControlWantsCopy;
end;

procedure TMainForm.PopulateNickList;
var
  Nickname: string;
  I: Integer;
  ActiveChat: TChatFrame;
begin
  NicknameList.Items.BeginUpdate;
  try
    NicknameList.Items.Clear;
    ActiveChat := ActiveChatFrame;
    for I := 0 to ActiveChat.Nicknames.Count - 1 do
    begin
      Nickname := ActiveChat.Nicknames[I];
      if Nickname = '' then
        Continue;

      if (Nickname[1] <> '@') and (Nickname[1] <> '+') then
        Nickname := ' ' + Nickname;
      NicknameList.Items.Add.Caption := Nickname;
    end;
  finally
    NicknameList.Items.EndUpdate;
  end;

  //fornce nicknamelist scrollbars to update
  NicknameList.Width := NicknameList.Width + 1;
  NicknameList.Width := NicknameList.Width - 1;
end;

procedure TMainForm.PopulateTopic;
begin
  FTopicEdit.ReadOnly := not ActiveConnection.IsOp(ActiveChatFrame, ActiveConnection.UsedNickname);
  SetTopicText(ActiveChatFrame.Topic);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SavePosition;
  SaveLayout;
  SaveConnections;
  SaveSettings;
  FTheme.Free;
  FConnections.Free;
  FAutoJoining.Free;
end;  

procedure TmainForm.LoadConnections;
var
  I, J: Integer;
  Servers, Targets: TStrings;
  IniFile: TIniFile;
  Connection: TConnectionData;
begin                   
  IniFile := TIniFile.Create(SettingsFilePath);
  Servers := TStringList.Create;
  Targets := TStringList.Create;
  try
    IniFile.ReadSection(ConnectionsSection, Servers);
    for I := 0 to Servers.Count - 1 do
    begin
      NewServerWindow;
      Connection := ActiveConnection;
      Connection.Server := Servers[I];
      Connection.ServerNode.Text := Servers[I];
      Connection.Port := IniFile.ReadInteger(Servers[I], 'Port', 6667);
      Targets.CommaText := IniFile.ReadString(ConnectionsSection, Servers[I], '');

      for J := 0 to Targets.Count - 1 do
      begin
        Connection.OpenChatWithTarget(Targets[J], False);
      end;
    end;
  finally
    Servers.Free;
    Targets.Free; 
    IniFile.Free;
  end;

  if ChannelTree.Items.Count = 0 then
     NewServerWindow;

  ChannelTree.Items[0].Selected := True;
end;

procedure TMainForm.Loaded;
begin
  inherited;
  LoadPosition;
end;

procedure TMainForm.SaveConnections;
var
  I, J: Integer;
  IniFile: TIniFile;
  Server, Target: string;
  Targets: TStrings;
  ServerNode, TargetNode: TTreeNode;
  Connection: TConnectionData;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  Targets := TStringList.Create;
  try
    IniFile.EraseSection(ConnectionsSection);
    for I := 0 to ChannelTree.Items.Count - 1 do
    begin
      if ChannelTree.Items[I].Level = 0 then
      begin
        ServerNode := ChannelTree.Items[I];
        Connection := TConnectionData(ServerNode.Data);
        if Connection.Server <> '' then
        begin
          Targets.Clear;
          Server := ServerNode.Text;
          for J := 0 to ServerNode.Count - 1 do
          begin
            TargetNode := ServerNode.Item[J];
            Target := TargetNode.Text;
            Targets.Add(Target);
          end;
          IniFile.WriteString(ConnectionsSection, Connection.UsedServer, Targets.CommaText);
          IniFile.WriteInteger(Server, 'Port', Connection.Port);
        end;
      end;
    end;
  finally
    IniFile.Free;
    Targets.Free;
  end;
end;

procedure TMainForm.SaveSettings;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    IniFile.WriteString(AppearanceSection, ThemeIdent, FCurrentTheme);
  finally
    IniFile.Free;
  end;
end;

function TMainForm.GetActiveChatFrame: TChatFrame;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to CenterPanel.ControlCount - 1 do
    if (CenterPanel.Controls[I] is TChatFrame) and
      (TChatFrame(CenterPanel.Controls[I]).TreeNode = ChannelTree.Selected) then
    begin
      Result := TChatFrame(CenterPanel.Controls[I]);
      Exit;
    end;
end;

function TMainForm.GetActiveConnection: TConnectionData;
begin
  Result := nil;
  if Assigned(ChannelTree.Selected) then
  begin
    if ChannelTree.Selected.Level = 0 then
      Result := TConnectionData(ChannelTree.Selected.Data)
    else
      Result := TConnectionData(ChannelTree.Selected.Parent.Data);
  end;
end;

function TMainForm.GetActiveTarget: string;
begin
  Result := '';
  if Assigned(ChannelTree.Selected) and
    (ChannelTree.Selected.Level > 0) then
    Result := ChannelTree.Selected.Text;
end;

function TMainForm.GetCurrentTheme: string;
begin
  Result := FCurrentTheme;
end;

procedure TMainForm.WmAddNick(var Message: TMessage);
var
  ItemCaption: string;
begin
  ItemCaption := GlobalGetAtom(Message.WParam);
  if ItemCaption = '' then
    Exit;
    
  if (ItemCaption[1] <> '@') and (ItemCaption[1] <> '+') then
    ItemCaption := ' '+ ItemCaption;
  NicknameList.Items.Add.Caption := ItemCaption;
  NicknameList.AlphaSort;
end;

procedure TMainForm.WmAfterShown(var Message: TMessage);
begin
  Application.ProcessMessages;
  AutoConnectToServers;
end;

procedure TMainForm.AutoJoinForServer(const AConnection: TConnectionData);
var
  IniFile: TIniFile;
  Channels: TStrings;
  I: Integer;
  ChannelNode: TTreeNode;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  Channels := TStringList.Create;
  try
    Channels.CommaText := IniFile.ReadString('AutoJoin', AConnection.Server, '');
    for I := 0 to AConnection.ServerNode.Count - 1 do
    begin
      ChannelNode := AConnection.ServerNode.Item[I];
      if Channels.IndexOf(ChannelNode.Text) >= 0  then
      begin
        AConnection.Join(ChannelNode.Text);
        FAutoJoining.Add(ChannelNode.Text);
        Sleep(25);
        Application.ProcessMessages;
      end;
    end;
  finally
    IniFile.Free;
    Channels.Free;
  end;
end;

procedure TMainForm.WmAutoJoin(var Message: TMessage);
var
  Connection: TConnectionData;
begin                                    
  Connection := TConnectionData(Message.WParam);

  AutoJoinForServer(Connection);
end;

procedure TMainForm.WmChannelJoined(var Message: TMessage);
var
  Index: Integer;
  Channel: string;
  Connection: TConnectionData;
begin
  Connection := TConnectionData(Message.WParam);
  Channel := GlobalGetAtom(Message.LParam);

  Connection.HandleChannelJoined(Channel, FAutoJoining.IndexOf(Channel) = -1);
  Index := FAutoJoining.IndexOf(Channel);
  if Index >= 0 then
    FAutoJoining.Delete(Index);
end;

procedure TMainForm.WmDisableIdent(var Message: TMessage);
begin
  FIdentCount := Max(0, FIdentCount - 1);
  if FIdentCount = 0 then
    IdIdentServer.Active := False;
end;

procedure TMainForm.WmEnableIdent(var Message: TMessage);
begin
  if FIdentCount = 0 then
    IdIdentServer.Active := True;
  Inc(FIdentCount);
end;

procedure TMainForm.WmFocusInput(var Message: TMessage);
begin
  InputFrame.InputEdit.SetFocus;
end;

procedure TMainForm.WmNicknamesList(var Message: TMessage);
var
  Param: TNickNamesListParam;
begin
  Param := TNickNamesListParam(Message.WParam);

  Param.Connection.HandleNickNamesList(Param.Channel, Param.NickNames);

  Param.Free;
end;

procedure TMainForm.WmNicksInUse(var Message: TMessage);
begin
  InputFrame.InputEdit.Text := '/nick ';
  InputFrame.InputEdit.SelStart := Length(MainForm.InputFrame.InputEdit.Text);
end;

procedure TMainForm.WmPaintChannels(var Message: TMessage);
begin
  ChannelTree.Refresh;
end;

procedure TMainForm.WmRemoveNick(var Message: TMessage);
var
  Nickname: string;
  Item: TListItem;
begin
  Nickname := GlobalGetAtom(Message.WParam);
  Item := NicknameList.FindCaption(0, '@' + Nickname, False, True, False);
  if Assigned(Item) then
    Item.Free
  else
  begin
    Item := NicknameList.FindCaption(0, '+' + Nickname, False, True, False);
    if Assigned(Item) then
      Item.Free
    else
    begin
      Item := NicknameList.FindCaption(0, ' ' + Nickname, False, True, False);
      if Assigned(Item) then
        Item.Free;
    end;
  end;
end;

procedure TMainForm.SetAppCaption;
var
  Connection: TConnectionData;
  Target: string;
  S: string;
begin
  Connection := ActiveConnection;
  if not Connection.Connected  then
  begin
    Caption := 'Gist';
    Exit;
  end;

  Target := ActiveTarget;
  if Target = ''  then
    S := FTheme.Values['SERVERTITLE'] 
  else
    S := FTheme.Values['CHANTITLE'];

  if S = ''  then
  begin
    if Target = ''  then
      S := '%s @ %s / %s:%d'
    else
      S := '%s @ %s / %s';
  end;

  S := 'Gist - ' + S;
  S := StringReplace(S, '$nickname', Connection.UsedNickname, [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '$network', Connection.Network, [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '$server', Connection.UsedServer, [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '$port', IntToStr(Connection.Port), [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '$target', Target, [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '$time', FormatDateTime(FTheme.Values['TIME'], Now), [rfReplaceAll, rfIgnoreCase]);

  S := StripBackgroundColors(S);
  S := StripForegroundColors(S);
  S := StripSpecialChars(S);

  Caption := S;
  Application.Title := Caption;
end;

procedure TMainForm.WmSetAppCaption(var Message: TMessage);
begin
  SetAppCaption;
end;

procedure TMainForm.SetTopicText(const ATopic: string);
begin
  FTopicEdit.SetIRCText(ATopic);
  FTopicEdit.SelStart := 0;
end;

procedure TMainForm.WmSetTopicText(var Message: TMessage);
var
  Topic: string;
begin
  Topic := GlobalGetAtom(Message.WParam);

  SetTopicText(Topic);
end;

function TMainForm.GlobalGetAtom(const AAtom: Integer): string;
var
  Str: PChar;
begin
  Result := '';
  GetMem(Str, 255);
  try
    if GlobalGetAtomName(AAtom, Str, 255) > 0  then
      Result := Str;
    GlobalDeleteAtom(AAtom);
  finally
    FreeMem(Str);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FAutoJoining := TStringList.Create;

  ChannelTree.DoubleBuffered := True;
  NicknameList.DoubleBuffered := True;

  if Screen.Fonts.IndexOf('Consolas') >= 0 then
  begin
    Font.Name := 'Consolas';
    Font.Size := Font.Size + 1;
  end else
    Font.Name := 'Courier New';

  FConnections := TObjectList.Create;
  
  FTheme := TStringList.Create;

  PopulateThemes;
  LoadThemeFromFile;

  CreateTopicEdit;

  SetupThemeColors;

  LoadConnections;

  LoadLayout;
end;

procedure TMainForm.LoadLayout;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    ChannelTree.Width := IniFile.ReadInteger('Layout', 'ChannelTreeWidth', ChannelTree.Width);
    NicknameList.Width := IniFile.ReadInteger('Layout', 'NicknameListWidth', NicknameList.Width);
    InputFrame.Height := IniFile.ReadInteger('Layout', 'InputEditHeight', InputFrame.Height);
  finally
    IniFile.Free;
  end;
end;

procedure TMainForm.LoadPosition;
var
  IniFile: TIniFile;
  SomeState: TWindowState;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    Left := IniFile.ReadInteger('Position', 'Left', Left);
    Top := IniFile.ReadInteger('Position', 'Top', Top);
    Height := IniFile.ReadInteger('Position', 'Height', Height);
    Width := IniFile.ReadInteger('Position', 'Width', Width);

    SomeState := TWindowState(IniFile.ReadInteger('Position', 'WindowState', Integer(WindowState)));
    if SomeState <> wsMinimized then
      WindowState := SomeState;
  finally
    IniFile.Free;
  end;
end;     

procedure TMainForm.SavePosition;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    IniFile.WriteInteger('Position', 'WindowState', Integer(WindowState));
    if WindowState <> wsMaximized then
    begin
      IniFile.WriteInteger('Position', 'Left', Left);
      IniFile.WriteInteger('Position', 'Top', Top);
      IniFile.WriteInteger('Position', 'Height', Height);
      IniFile.WriteInteger('Position', 'Width', Width);
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TMainForm.SaveLayout;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    IniFile.WriteInteger('Layout', 'ChannelTreeWidth', ChannelTree.Width);
    IniFile.WriteInteger('Layout', 'NicknameListWidth', NicknameList.Width);
    IniFile.WriteInteger('Layout', 'InputEditHeight', InputFrame.Height);
  finally
    IniFile.Free;
  end;
end;

procedure TMainForm.AutoConnectToServers;
var
  Connection: TConnectionData;
  ServerName: string;
  I: Integer;
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    for I := 0 to ChannelTree.Items.Count - 1 do
    begin
      if ChannelTree.Items[I].Level = 0 then
      begin
        ServerName := ChannelTree.Items[I].Text;
        if IniFile.ReadBool('AutoConnect', ServerName, False) then
        begin
          Connection := TConnectionData(ChannelTree.Items[I].Data);
          Connection.Connect;
        end;
      end;
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TMainForm.CloseChannelActionExecute(Sender: TObject);
begin
  ActiveConnection.Part(ActiveTarget);
  ActiveConnection.CloseWindow(ActiveTarget);
end;

procedure TMainForm.CloseQueryActionExecute(Sender: TObject);
begin
  ActiveConnection.CloseWindow(ActiveTarget);
end;

procedure TMainForm.CloseServerActionExecute(Sender: TObject);
begin
  if ActiveConnection.Connected then
    ActiveConnection.Disconnect;
  ActiveConnection.CloseWindow(ActiveTarget);
end;

procedure TMainForm.LoadThemeFromFile;
begin
  FTheme.LoadFromFile(ExtractFilePath(Application.ExeName) + CurrentTheme + '.theme');
end;

procedure TMainForm.RedrawWindow(const AHandle: THandle; const AChildren: Boolean);
var
  Flags: Cardinal;
begin
  Flags := RDW_ERASE or RDW_FRAME or RDW_INVALIDATE;
  if AChildren then
    Flags := Flags or RDW_ALLCHILDREN;
  Windows.RedrawWindow(AHandle, nil, 0, Flags);
end;

procedure TMainForm.ReloadTheme;
var
  I: Integer;
  ChatFrame: TChatFrame;
begin
  Screen.Cursor := crHourglass;
  Application.ProcessMessages;
  Perform(WM_SETREDRAW, 0, 0);
  try
    LoadThemeFromFile;
    SetupThemeColors;
    SetAppCaption;
    PopulateTopic;
    for I := 0 to CenterPanel.ControlCount - 1 do
    begin
      if CenterPanel.Controls[I] is TChatFrame then
      begin
        ChatFrame := TChatFrame(CenterPanel.Controls[I]);
        ChatFrame.ReloadTheme;
      end;
    end;
  finally
    Perform(WM_SETREDRAW, 1, 0);
    RedrawWindow(Handle, True);
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.PopulateThemes;
var
  SearchResult: TSearchRec;
  NewItem: TMenuItem;
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    FCurrentTheme := IniFile.ReadString(AppearanceSection, ThemeIdent, DefaultTheme);
  finally
    IniFile.Free;
  end;

  if FindFirst('*.theme', faAnyFile, SearchResult) = 0 then
  begin
    repeat
      NewItem := TMenuItem.Create(MainMenu);
      ThemeItem.Add(NewItem);
      NewItem.Caption := ChangeFileExt(SearchResult.Name, '');
      NewItem.OnClick := ThemeItemClick;
      NewItem.Checked := SameText(NewItem.Caption, FCurrentTheme);
      NewItem.RadioItem := True;
    until FindNext(SearchResult) <> 0;

    FindClose(SearchResult);
  end;
end;       

procedure TMainForm.ThemeItemClick(Sender: TObject);
begin
  FCurrentTheme := TMenuItem(Sender).Caption;
  TMenuItem(Sender).Checked := True;
  ReloadTheme;
end;

function TMainForm.HtmlToColor(const AHtmlColor: string): TColor;
begin
  Result := StringToColor('$' + Copy(AHtmlColor, 6, 2) + Copy(AHtmlColor, 4, 2) + Copy(AHtmlColor, 2, 2));
end;

procedure TMainForm.SetupThemeColors;
var
  I: Integer;
  ChatFrame: TChatFrame;
begin
  ChannelTree.Color := HtmlToColor(FTheme.Values['LISTCOLOR']);
  ChannelTree.Font.Color := HtmlToColor(FTheme.Values['LISTTEXTCOLOR']);
  NicknameList.Color := ChannelTree.Color;
  NicknameList.Font.Color := ChannelTree.Font.Color;
  TopicEdit.Color := HtmlToColor(FTheme.Values['TOPICCOLOR']);
  TopicEdit.Font.Color := HtmlToColor(FTheme.Values['TOPICTEXTCOLOR']);
  for I := 0 to CenterPanel.ControlCount - 1 do
  begin
    if CenterPanel.Controls[I] is TChatFrame then
    begin
      ChatFrame := TChatFrame(CenterPanel.Controls[I]);
      ChatFrame.ChatEdit.Color := HtmlToColor(FTheme.Values['CHATCOLOR']);
      ChatFrame.ChatEdit.Font.Color := HtmlToColor(FTheme.Values['CHATTEXTCOLOR']);
    end;
  end;
  InputFrame.InputEdit.Color := HtmlToColor(FTheme.Values['CHATCOLOR']);
  InputFrame.InputEdit.Font.Color := HtmlToColor(FTheme.Values['CHATTEXTCOLOR']);
end;    

function TMainForm.FindServerNode(const AConnection: TConnectionData): TTreeNode;      
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ChannelTree.Items.Count - 1 do
  begin
    if (ChannelTree.Items[I].Level = 0) and (ChannelTree.Items[I].Data = AConnection) then
    begin
      Result := ChannelTree.Items[I];
      Exit;
    end;
  end;
end;

function TMainForm.FindChatNode(const AConnection: TConnectionData; const ATarget: string): TTreeNode;
var
  I: Integer;
  ParentNode: TTreeNode;
begin
  Result := nil;
  ParentNode := FindServerNode(AConnection);
  for I := 0 to ParentNode.Count - 1 do
  begin
    if SameText(ParentNode.Item[I].Text, ATarget) then
    begin
      Result := ParentNode.Item[I];
      Exit;
    end;
  end;
end;

function TMainForm.CreateChatNode(const AConnection: TConnectionData; const ATarget: string): TTreeNode;
var
  ParentNode: TTreeNode;
begin
  Result := FindChatNode(AConnection, ATarget);
  if not Assigned(Result) then
  begin                      
    ParentNode := FindServerNode(AConnection);
    Result := ChannelTree.Items.AddChild(ParentNode, ATarget);
    Result.Data := AConnection;
  end;
end;

procedure TMainForm.CreateTopicEdit;
begin
  FTopicEdit := TIRCRichEdit.Create(Self);    
  FTopicEdit.Parent := CenterPanel;   
  AutoSizeTopicEdit;
  FTopicEdit.BorderStyle := bsNone;
  FTopicEdit.Align := alTop;
  FTopicEdit.HideSelection := False;
  FTopicEdit.Color := $00D0C8C6;
  FTopicEdit.OnURLClick := TopicEditURLClick;
  FTopicEdit.Color := HtmlToColor(FTheme.Values['TOPICCOLOR']);
  FTopicEdit.Font.Color := HtmlToColor(FTheme.Values['TOPICTEXTCOLOR']);
  FTopicEdit.OnKeyPress := TopicEditKeyPress;
  FTopicEdit.OnKeyDown := TopicEditKeyDown;
  FTopicEdit.PopupMenu := EditPopup;
end;

procedure TMainForm.TopicEditURLClick(Sender :TObject; const URL: string);
begin
  ShellExecute(Handle, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

function TMainForm.CreateChatFrame(const ATreeNode: TTreeNode): TChatFrame;
begin
  Result := TChatFrame.Create(nil);
  Result.TreeNode := ATreeNode;
  Result.Name := '';
  Result.Align := alClient;

  Result.Parent := CenterPanel; //has to come before setting font or font name will not work
  Result.ChatEdit.Color := HtmlToColor(FTheme.Values['CHATCOLOR']);
  Result.ChatEdit.Font.Color := HtmlToColor(FTheme.Values['CHATTEXTCOLOR']);
end;

procedure TMainForm.PopulateAppCaption;
begin
  PostMessage(Handle, WM_SETAPPCAPTION, 0, 0);
end;

function TMainForm.CreateServerNode(const AConnection: TConnectionData): TTreeNode;
begin
  Result := ChannelTree.Items.Add(nil, AConnection.Server); 
  Result.Data := AConnection;
end;

procedure TMainForm.CutActionExecute(Sender: TObject);
begin
  uEditFuncs.CutFromActiveControl;
end;

procedure TMainForm.CutActionUpdate(Sender: TObject);
begin
  CutAction.Enabled := uEditFuncs.ActiveControlWantsCut;
end;

procedure TMainForm.DeleteActionExecute(Sender: TObject);
begin
  uEditFuncs.ClearInActiveControl;
end;

procedure TMainForm.DeleteActionUpdate(Sender: TObject);
begin
  DeleteAction.Enabled := uEditFuncs.ActiveControlWantsClear;
end;

procedure TMainForm.DisconnectActionExecute(Sender: TObject);
begin
  ActiveConnection.Disconnect;
end;

procedure TMainForm.ExitActionExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  ActiveChatFrame.MarkerDropped := False;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if not FFormShown then
  begin
    FFormShown := True;
    PostMessage(Handle, WM_AFTERSHOWN, 0, 0);
  end;
end;

procedure TMainForm.IdIdentServerIdentQuery(AContext: TIdContext; AServerPort,
    AClientPort: Word);
begin
  IdIdentServer.ReplyIdent(AContext, AServerPort, AClientPort, 'UNIX', ActiveConnection.IdIRC.Username);
end;

procedure TMainForm.JoinActionExecute(Sender: TObject);
begin
  ActiveConnection.Join(ChannelTree.Selected.Text);
end;

procedure TMainForm.TopicEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not TopicEdit.ReadOnly and (Key = VK_RETURN) then
  begin
    ActiveConnection.IdIRC.SetChannelTopic(ActiveTarget, TopicEdit.Text);
    InputFrame.InputEdit.SetFocus;
  end;
end;

procedure TMainForm.TopicEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not TopicEdit.ReadOnly and (Key = #13) then
    Key := #0;
end;

procedure TMainForm.NewServerWindow;
var
  ConnectionData: TConnectionData;
begin                       
  Perform(WM_SETREDRAW, 0, 0);
  try
    ConnectionData := TConnectionData.Create(Self);
    FConnections.Add(ConnectionData);

    ConnectionData.ServerNode.Text := 'New Server';

    if Visible then
      InputFrame.InputEdit.SetFocus;
  finally
    Perform(WM_SETREDRAW, 1, 0);
    RedrawWindow(Handle, True);
  end;
end;

procedure TMainForm.NewServerActionExecute(Sender: TObject);
begin
  NewServerWindow;
end;

procedure TMainForm.NicknameListCompare(Sender: TObject; Item1, Item2:
    TListItem; Data: Integer; var Compare: Integer);
begin
  if (Item1.Caption[1] = '@') and (Item2.Caption[1] <> '@') then
    Compare := -1
  else if (Item1.Caption[1] = '+') and (Item2.Caption[1] <> '@') and (Item2.Caption[1] <> '+') then
    Compare := -1
  else if (Item2.Caption[1] = '@') and (Item1.Caption[1] <> '@') then
    Compare := 1
  else if (Item2.Caption[1] = '+') and (Item1.Caption[1] <> '@') and (Item1.Caption[1] <> '+') then
    Compare := 1
  else
    Compare := StrIComp(PChar(Item1.Caption), PChar(Item2.Caption));
end;

function TMainForm.SelectedNickname: string;
begin
  Result := StringReplace(StringReplace(StringReplace(NicknameList.Selected.Caption, '@', '', []), '+', '', []), ' ', '', []);
end;

procedure TMainForm.NicknameListDblClick(Sender: TObject);
begin
  if Assigned(NicknameList.Selected) then
    QueryAction.Execute;
end;

procedure TMainForm.NicknamePopupPopup(Sender: TObject);
begin
  if NicknameList.Selected = nil then
    Abort;
end;

procedure TMainForm.OptionsActionExecute(Sender: TObject);
var
  OptionsForm: TOptionsForm;
begin
  OptionsForm := TOptionsForm.Create(Self);
  try
    OptionsForm.ShowModal;
  finally
    OptionsForm.Free;
  end;
end;

procedure TMainForm.PartActionExecute(Sender: TObject);
begin
  ActiveConnection.Part(ChannelTree.Selected.Text);
end;

procedure TMainForm.PasteActionExecute(Sender: TObject);
begin
  if Assigned(Screen.ActiveControl) then
  begin
    if Screen.ActiveControl = InputFrame.InputEdit then
      InputFrame.InputEdit.SelText := Clipboard.AsText //so we don't get any formatting
    else
      SendMessage(Screen.ActiveControl.Handle, WM_PASTE, 0, 0);
  end;
end;

procedure TMainForm.PasteActionUpdate(Sender: TObject);
begin
  PasteAction.Enabled := uEditFuncs.ActiveControlWantsPaste;
end;

procedure TMainForm.QueryActionExecute(Sender: TObject);
begin
  ActiveConnection.Query(SelectedNickname);
  InputFrame.InputEdit.SetFocus;
end;

procedure TMainForm.ReloadServerChatContents;
var
  I: Integer;
  ChatFrame: TChatFrame;
begin                    
  Screen.Cursor := crHourglass; 
  Application.ProcessMessages;
  Perform(WM_SETREDRAW, 0, 0);
  try
    for I := 0 to CenterPanel.ControlCount - 1 do
    begin
      if CenterPanel.Controls[I] is TChatFrame  then
      begin
        ChatFrame := TChatFrame(CenterPanel.Controls[I]);
        if ChatFrame.TreeNode.Level = 0  then
          ChatFrame.ReloadTheme;
      end;
    end;
  finally
    Perform(WM_SETREDRAW, 1, 0);
    RedrawWindow(Handle, True);
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.RawActionExecute(Sender: TObject);
begin
  ReloadServerChatContents;
end;

procedure TMainForm.RedoActionExecute(Sender: TObject);
begin
  uEditFuncs.RedoInActiveControl;
end;

procedure TMainForm.RedoActionUpdate(Sender: TObject);
begin
  RedoAction.Enabled := uEditFuncs.ActiveControlWantsRedo;
end;

procedure TMainForm.SelectAllActionExecute(Sender: TObject);
begin
  SelectAllInActiveControl;
end;

procedure TMainForm.SelectAllActionUpdate(Sender: TObject);
begin
  SelectAllAction.Enabled := uEditFuncs.ActiveControlWantsSelectAll;
end;

procedure TMainForm.UndoActionExecute(Sender: TObject);
begin
  uEditFuncs.UndoInActiveControl;
end;

procedure TMainForm.UndoActionUpdate(Sender: TObject);
begin
  UndoAction.Enabled := uEditFuncs.ActiveControlWantsUndo;
end;

procedure TMainForm.WhoisActionExecute(Sender: TObject);
begin
  ActiveConnection.Whois(SelectedNickname, '');
end;

procedure TMainForm.WhoisQueryActionExecute(Sender: TObject);
begin
  ActiveConnection.Whois(ChannelTree.Selected.Text, '');
end;

end.
