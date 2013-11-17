unit fChat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, uIRCRichEdit, Contnrs;

const
  WM_ADDTEXT = WM_USER + 100;

type
  TIRCParams = class
  public
    TimeStamp: TDateTime;
    RawCommand: string;
    Nickname: string;
    Host: string;
    Target: string;
    Text: string;
    IsMe: Boolean;
    Text2: string;
    Sign: string;
    Nickname2: string;
  end;

  TChatFrame = class(TFrame)
    procedure FrameResize(Sender: TObject);
  private
    FChatEdit: TIRCRichEdit;
    FTreeNode: TTreeNode;
    FNicknames: TStrings;
    FTopic: string;
    FTheme: TStrings;
    FMarkerLine: Integer;
    FMarkerDropped: Boolean;
    FIRCLines: TObjectList;
    procedure CheckAndDropMarker;
    procedure AddIRCLineToMemo(const AIRCParams: TIRCParams; const AMultiThreaded: Boolean = True);
    procedure CreateChatEdit;
    procedure SetTreeNode(const Value: TTreeNode);
    procedure ChatEditURLClick(Sender: TObject; const URL: string);
    procedure ChatEditMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetTopic(const Value: string);
    procedure WmAddText(var Message: TMessage); message WM_ADDTEXT;
    function GetMarkerCharCount: Integer;
    procedure DeleteMarker;
    procedure SetMarkerDropped(const Value: Boolean);
    procedure AddTextToMemo(const AIRCParams: TIRCParams; const AMultiThreaded: Boolean = True);
    procedure AddIRCLine(const AIRCParams: TIRCParams; const AMultiThreaded: Boolean = True); overload;
    procedure SetMarkerLine(const Value: Integer);
  public         
    procedure RecreateMarkerLine;
    procedure DropMarker;
    property MarkerLine: Integer read FMarkerLine write SetMarkerLine;
    procedure AddText(const AText: string);
    procedure AddStrings(const AStrings: TStrings);
    procedure AddIRCLine(const ARawCmd, ANickname, AHost, ATarget, AText: string; const AIsMe: Boolean; const AText2: string = ''; const ASign: string = ''; const ANickname2: string = ''; const AMultiThreaded: Boolean = True); overload;
    property TreeNode: TTreeNode read FTreeNode write SetTreeNode;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Nicknames: TStrings read FNicknames;
    property Topic: string read FTopic write SetTopic;
    property ChatEdit: TIRCRichEdit read FChatEdit;

    property MarkerDropped: Boolean read FMarkerDropped write SetMarkerDropped;

    procedure ReloadTheme;
  end;

implementation

uses ShellAPI, fMain, Clipbrd, IniFiles, StrUtils, Math;

{$R *.dfm}

{ TChatFrame }

const
  MarkerDelim = #1;
  ScrollBackLength = 300;

procedure TChatFrame.AddIRCLine(const ARawCmd, ANickname, AHost, ATarget,
    AText: string; const AIsMe: Boolean; const AText2: string = ''; const
    ASign: string = ''; const ANickname2: string = ''; const AMultiThreaded: Boolean = True);
var
  IRCParams: TIRCParams;
begin
  IRCParams := TIRCParams.Create;
  IRCParams.RawCommand := ARawCmd;
  IRCParams.Nickname := ANickname;
  IRCParams.Host := AHost;
  IRCParams.Target := ATarget;
  IRCParams.Text := AText;
  IRCParams.IsMe := AIsMe;
  IRCParams.Text2 := AText2;
  IRCParams.Sign := ASign;
  IRCParams.Nickname2 := ANickname2;
  AddIRCLine(IRCParams, AMultiThreaded);
end;

procedure TChatFrame.CheckAndDropMarker;
begin
  if ((MainForm.ActiveChatFrame <> Self) or
    (MainForm.WindowState = wsMinimized) or not MainForm.Active) then
  begin
    if not FMarkerDropped  then
    begin
      DropMarker;
      PostMessage(MainForm.Handle, WM_PAINTCHANNELS, 0, 0);        
      FMarkerLine := FIRCLines.Count - 1;
      FMarkerDropped := True;
    end;
  end
  else
    FMarkerDropped := False;
end;

procedure TChatFrame.AddIRCLine(const AIRCParams: TIRCParams; const AMultiThreaded: Boolean = True);
begin
  AIRCParams.TimeStamp := Now;

  AddIRCLineToMemo(AIRCParams, AMultiThreaded);
end;

procedure TChatFrame.AddStrings(const AStrings: TStrings);
var
  I: Integer;
begin
  for I := 0 to AStrings.Count - 1 do
    AddText(AStrings[I]);
end;

procedure TChatFrame.AddText(const AText: string);
begin
  AddIRCLine('TEXT', '', '', '', AText, False);
end;

procedure TChatFrame.AddIRCLineToMemo(const AIRCParams: TIRCParams; const AMultiThreaded: Boolean = True);
begin
  if AMultiThreaded then
  begin
    PostMessage(Handle, WM_ADDTEXT, Integer(AIRCParams), Integer(AMultiThreaded));
  end else
  begin
    AddTextToMemo(AIRCParams, AMultiThreaded);
  end;
end;

procedure TChatFrame.WmAddText(var Message: TMessage);
begin
  AddTextToMemo(TIRCParams(Message.WParam), Boolean(Message.LParam));
end;

procedure TChatFrame.AddTextToMemo(const AIRCParams: TIRCParams; const AMultiThreaded: Boolean = True);
var
  FormatStr, Ident: string;
begin
  MainForm.Perform(WM_SETREDRAW, 0, 0);
  ChatEdit.Lines.BeginUpdate;
  try
//    if AMultiThreaded then
//      FIRCLines.Add(AIRCParams);

    if (SameText(AIRCParams.RawCommand, 'RAWIN') or SameText(AIRCParams.RawCommand, 'RAWOUT')) and
      not MainForm.RawAction.Checked then
      Exit;

    //only drop a marker if someone talks
    if (SameText(AIRCParams.RawCommand, 'PRIVMSG') or
      SameText(AIRCParams.RawCommand, 'CHANMSG') or
      SameText(AIRCParams.RawCommand, 'ACTION')) and AMultiThreaded then
      CheckAndDropMarker;

    FormatStr := '';
    if AIRCParams.IsMe  then
    begin
      Ident := Format('MY%s', [AIRCParams.RawCommand]);
      FormatStr := FTheme.Values[Ident];
    end;
    if FormatStr = ''  then
      FormatStr := FTheme.Values[AIRCParams.RawCommand];
    if FormatStr = ''  then
      FormatStr := Format('%s %s %s %s %s', [AIRCParams.RawCommand, AIRCParams.Nickname,
        AIRCParams.Host, AIRCParams.Target, AIRCParams.Text])
    else
    begin
      FormatStr := StringReplace(FormatStr, '$indent', IndentDelim, [rfReplaceAll, rfIgnoreCase]);
      FormatStr := StringReplace(FormatStr, '$nick2', AIRCParams.Nickname2, [rfReplaceAll, rfIgnoreCase]);
      FormatStr := StringReplace(FormatStr, '$nick', AIRCParams.Nickname, [rfReplaceAll, rfIgnoreCase]);
      FormatStr := StringReplace(FormatStr, '$sign', AIRCParams.Sign, [rfReplaceAll, rfIgnoreCase]);
      FormatStr := StringReplace(FormatStr, '$host', AIRCParams.Host, [rfReplaceAll, rfIgnoreCase]);
      FormatStr := StringReplace(FormatStr, '$target', AIRCParams.Target, [rfReplaceAll, rfIgnoreCase]);
      FormatStr := StringReplace(FormatStr, '$text2', AIRCParams.Text2, [rfReplaceAll, rfIgnoreCase]);
      FormatStr := StringReplace(FormatStr, '$text', AIRCParams.Text, [rfReplaceAll, rfIgnoreCase]);
      FormatStr := StringReplace(FormatStr, '$time', FormatDateTime(FTheme.Values['TIME'], AIRCParams.TimeStamp), [rfReplaceAll, rfIgnoreCase]);
      FormatStr := StringReplace(FormatStr, '$prompt', FTheme.Values['PROMPT'], [rfReplaceAll, rfIgnoreCase]);
      FormatStr := StringReplace(FormatStr, '$br', #13#10, [rfReplaceAll, rfIgnoreCase]);
    end;

    while FChatEdit.Lines.Count >= ScrollBackLength do
      FChatEdit.Lines.Delete(0);
    FChatEdit.AddIRCText(FormatStr);
  finally
    MainForm.Perform(WM_SETREDRAW, 1, 0);
    MainForm.RedrawWindow(MainForm.Handle, True);
    ChatEdit.Lines.EndUpdate;
  end;   
end;

constructor TChatFrame.Create(AOwner: TComponent);
begin
  inherited;
  FIRCLines := TObjectList.Create;
  FNicknames := TStringList.Create;
  FMarkerLine := -1;

  CreateChatEdit;
  
  FTheme := TStringList.Create;
  ReloadTheme;
end;   

procedure TChatFrame.CreateChatEdit;
begin
  FChatEdit := TIRCRichEdit.Create(Self);           
  FChatEdit.Parent := Self;
  FChatEdit.BorderStyle := bsNone;
  FChatEdit.Align := alClient;
  FChatEdit.HideSelection := False;
  FChatEdit.ParentColor := True;
  FChatEdit.ReadOnly := True;
  FChatEdit.ScrollBars := ssVertical;
  FChatEdit.OnURLClick := ChatEditURLClick;
  FChatEdit.OnMouseUp := ChatEditMouseUp;

  HideCaret(FChatEdit.Handle);
end;

procedure TChatFrame.ChatEditURLClick(Sender :TObject; const URL: string);
begin
  ShellExecute(Handle, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TChatFrame.ChatEditMouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
  FChatEdit.CopyToClipboard;
  FChatEdit.SelLength := 0;
  MainForm.InputFrame.InputEdit.SetFocus;
end;

destructor TChatFrame.Destroy;
begin
  FIRCLines.Free;
  FTheme.Free;
  FNicknames.Free;
  if not (csDestroying in ComponentState) then
    TTreeView(FTreeNode.TreeView).Items.Delete(FTreeNode);
  inherited;
end;

procedure TChatFrame.DropMarker;
begin
  if FMarkerLine >= 0 then
    DeleteMarker;
  ChatEdit.AddIRCText(MarkerDelim + DupeString('-', GetMarkerCharCount) + MarkerDelim);
end;

procedure TChatFrame.DeleteMarker;
var
  I: Integer;
  Line: string;
begin
  for I := 0 to ChatEdit.Lines.Count - 1 do
  begin
    if Length(ChatEdit.Lines[I]) > 0 then
    begin
      Line := ChatEdit.Lines[I];
      if Line[1] = MarkerDelim then
      begin
        ChatEdit.Lines.Delete(I);
        if Line[Length(Line)] <> MarkerDelim then
        begin
          while Pos(MarkerDelim, ChatEdit.Lines[I]) = 0 do
          begin
            ChatEdit.Lines.Delete(I);
          end;   
          ChatEdit.Lines.Delete(I);
        end;
        Break;
      end;
    end;
  end;
end;

function TChatFrame.GetMarkerCharCount: Integer;
var
  MarkerWidth: Integer;
begin
  Result := 1;
  MarkerWidth := MainForm.Canvas.TextWidth(DupeString('-', Result)) + GetSystemMetrics(SM_CXVSCROLL);
  while MarkerWidth < Width do
  begin
    Inc(Result);    
    MarkerWidth := MainForm.Canvas.TextWidth(DupeString('-', Result)) + GetSystemMetrics(SM_CXVSCROLL);
  end;
  Dec(Result, 3);
end;

procedure TChatFrame.ReloadTheme;
var
  I, Count, StartIndex: Integer;
  IRCParams: TIRCParams;
begin          
  FTheme.LoadFromFile(ExtractFilePath(Application.ExeName) + MainForm.CurrentTheme + '.theme');

//  if FIRCLines.Count = 0 then
//    Exit;

  ChatEdit.Lines.BeginUpdate;
  try
    ChatEdit.Clear;
    ChatEdit.SelectAll;
    ChatEdit.SelAttributes.Color := ChatEdit.Font.Color;
    ChatEdit.SelLength := 0;

    I := FIRCLines.Count - 1;
    Count := 0;
    while (Count < ScrollBackLength) and (I > 0) do
    begin
      IRCParams := TIRCParams(FIRCLines[I]);
      if (not SameText(IRCParams.RawCommand, 'RAWIN') and
        not SameText(IRCParams.RawCommand, 'RAWOUT')) or
        MainForm.RawAction.Checked then
        Inc(Count);
      Dec(I);
    end;

    StartIndex := I;
    if I < 0 then
      Exit;

    for I := StartIndex to FIRCLines.Count - 1 do
    begin
      if I = FMarkerLine then
        DropMarker;
      AddIRCLineToMemo(TIRCParams(FIRCLines[I]), False);
    end;
  finally
    ChatEdit.Lines.EndUpdate;
  end;
end;

procedure TChatFrame.RecreateMarkerLine;
var
  I: Integer;
  Line: string;
begin
  if FMarkerLine >= 0  then
  begin
    for I := 0 to ChatEdit.Lines.Count - 1 do
    begin
      if Length(ChatEdit.Lines[I]) > 0  then
      begin
        Line := ChatEdit.Lines[I];
        if Line[1] = MarkerDelim  then
        begin
          MainForm.Perform(WM_SETREDRAW, 0, 0);
          ChatEdit.Lines.BeginUpdate;
          try
            ChatEdit.Lines.Delete(I);
            if Line[Length(Line)] <> MarkerDelim  then
            begin
              while Pos(MarkerDelim, ChatEdit.Lines[I]) = 0 do
              begin
                ChatEdit.Lines.Delete(I);
              end;
              ChatEdit.Lines.Delete(I);
            end;
            ChatEdit.Lines.Insert(I, MarkerDelim + DupeString('-', GetMarkerCharCount) + MarkerDelim);
            ChatEdit.SelStart := 0;
            ChatEdit.SelStart := Length(ChatEdit.Text);
            Break;
          finally
            MainForm.Perform(WM_SETREDRAW, 1, 0);
            MainForm.RedrawWindow(MainForm.Handle, True);
            ChatEdit.Lines.EndUpdate;
          end;
        end;
      end;
    end;
  end;
end;

procedure TChatFrame.FrameResize(Sender: TObject);
begin
  RecreateMarkerLine;
end;

procedure TChatFrame.SetMarkerDropped(const Value: Boolean);
begin
  FMarkerDropped := Value;
end;

procedure TChatFrame.SetMarkerLine(const Value: Integer);
begin
  FMarkerLine := Value;
end;

procedure TChatFrame.SetTopic(const Value: string);
begin
  FTopic := Value;
end;

procedure TChatFrame.SetTreeNode(const Value: TTreeNode);
begin
  FTreeNode := Value;
end;

end.
