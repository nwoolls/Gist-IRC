unit dmConnection;

interface

uses
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdCmdTCPClient, IdIRC, IdContext, ComCtrls, Contnrs,
  fChat;

type
  TConnectionData = class(TDataModule)
    IdIRC: TIdIRC;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure IdIRCChannelMode(ASender: TIdContext; const ANickname, AHost, AChannel, AMode, AParams: string);
    procedure IdIRCConnected(Sender: TObject);
    procedure IdIRCCTCPQuery(ASender: TIdContext; const ANickname, AHost, ATarget, ACommand, AParams: string);
    procedure IdIRCCTCPReply(ASender: TIdContext; const ANickname, AHost, ATarget, ACommand, AParams: string);
    procedure IdIRCDisconnected(Sender: TObject);
    procedure IdIRCJoin(ASender: TIdContext; const ANickname, AHost, AChannel: string);
    procedure IdIRCKick(ASender: TIdContext; const ANickname, AHost, AChannel, ATarget, AReason: string);
    procedure IdIRCMOTD(ASender: TIdContext; AMOTD: TStrings);
    procedure IdIRCNicknameChange(ASender: TIdContext; const AOldNickname, AHost, ANewNickname: string);
    procedure IdIRCNicknamesListReceived(ASender: TIdContext; const AChannel: string; ANicknameList: TStrings);
    procedure IdIRCNotice(ASender: TIdContext; const ANickname, AHost, ATarget, ANotice: string);
    procedure IdIRCPrivateMessage(ASender: TIdContext; const ANicknameFrom, AHost, ANicknameTo, AMessage: string);
    procedure IdIRCRaw(ASender: TIdContext; AIn: Boolean; const AMessage: string);
    procedure IdIRCServerError(ASender: TIdContext; AErrorCode: Integer; const AErrorMessage: string);
    procedure IdIRCServerUsersListReceived(ASender: TIdContext; AUsers: TStrings);
    procedure IdIRCServerVersion(ASender: TIdContext; const AVersion, AHost, AComments: string);
    procedure IdIRCTopic(ASender: TIdContext; const ANickname, AHost, AChannel, ATopic: string);
    procedure IdIRCPart(ASender: TIdContext; const ANickname, AHost, AChannel, APartMessage: string);
    procedure IdIRCQuit(ASender: TIdContext; const ANickname, AHost, AReason: string);
    procedure IdIRCServerWelcome(ASender: TIdContext; const AMsg: string);
    procedure IdIRCUserMode(ASender: TIdContext; const ANickname, AHost, AMode: string);
    procedure IdIRCISupport(ASender: TIdContext; AParameters: TStrings);
    procedure IdIRCMyInfo(ASender: TIdContext; const AServer, AVersion, AUserModes, AChanModes, AExtra: string);
    procedure IdIRCNicknameError(ASender: TIdContext; AError: Integer);
  private
    FLastNick: string;
    FServerNode: TTreeNode;
    FServerChat: TChatFrame;
    FChatTargets: TStrings;
    FChatFrames: TObjectList;
    FCycling: Boolean;
    FPort: Integer;
    FPassword: string;
    FJoinTopics: TStrings;
    FActiveChat: TChatFrame;
    FNetwork: string;
    FUsedServer: string;
    FServer: string;
    FNickHost: string;
    procedure AddNickToList(const ANewNick: string);
    procedure HandleCustomRawCommands(const ARawMessage: string);
    procedure SetPassword(const Value: string);
    procedure SetPort(const Value: Integer);
    procedure SetupReplies;
    function GetNicknameChannelSign(const AChannelChat: TChatFrame; const ANickname: string): string;
    procedure RemoveNickFromChannel(const AChatFrame: TChatFrame; const ANickname: string);
    procedure SetActiveChat(const Value: TChatFrame);
    procedure UpdateNicksFromModeChange(const AChannel, AModes: string);
    function GetUsedNickname: string;
    procedure RefreshTopicForChannel(const AChannel: string);
    function GetConnected: Boolean;
    procedure SetServer(const Value: string);
    procedure LoadSettings;
    procedure RemoveNickFromList(const ANickname: string);
  public
    procedure HandleChannelJoined(const AChannel: string; const AFocusChannel: Boolean);
    procedure HandleNickNamesList(const AChannel, ANickNames: string);    
    function OpenChatWithTarget(const ATarget: string; const AFocusTarget: Boolean): TChatFrame;

    procedure Connect;
    procedure Disconnect(const AReason: string = '');
    procedure Say(const ATarget, AText: string);           
    procedure Notice(const ATarget, AText: string);
    procedure Whois(const AMask: string; const ATarget: string = '');
    procedure Join(const AChannel: string; const AKey: string = ''); 
    procedure ListChannelNicknames(const AChannel: string; const ATarget: string = '');
    procedure Part(const AChannel: string; const AReason: string = '');
    procedure Cycle(const AChannel: string; const AReason: string = '');     
    procedure CTCPQuery(const ATarget, ACommand, AParameters: string);
    procedure SendRaw(const ALine: string);
    procedure Action(const ATarget, AMessage: string);
    procedure Query(const ATarget: string; const AMessage: string = '');
    procedure CloseWindow(const ATarget: string);
    procedure SetNickname(const ANickname: string);
    procedure Quit(const AReason: string);

    property ServerChat: TChatFrame read FServerChat;
    property ActiveChat: TChatFrame read FActiveChat write SetActiveChat;
    property ServerNode: TTreeNode read FServerNode;

    property Server: string read FServer write SetServer;
    property Port: Integer read FPort write SetPort;
    property Password: string read FPassword write SetPassword;
    property UsedNickname: string read GetUsedNickname;
    property Connected: Boolean read GetConnected;
    property Network: string read FNetwork;
    property UsedServer: string read FServer;
    property NickHost: string read FNickHost;
    
    function IsOp(const AChannelChat: TChatFrame; const ANickname: string): Boolean;
    function IsVoice(const AChannelChat: TChatFrame; const ANickname: string): Boolean;
  end;

implementation

uses fMain, Windows, Dialogs, Forms, uNickNamesListParam, uTokenizer, IniFiles,
  uStringUtils, uDateUtils, IdGlobal, StrUtils, uConst;

{$R *.dfm}   

{ TConnectionData }

procedure TConnectionData.DataModuleDestroy(Sender: TObject);
begin
  if IdIRC.Connected then
    try
      IdIRC.Disconnect;
    except
    end;

  FJoinTopics.Free;
  FChatFrames.Free;
  FChatTargets.Free;
  TTreeView(FServerNode.TreeView).Items.Delete(FServerNode);       
end;

procedure TConnectionData.Disconnect(const AReason: string = '');
begin
  IdIRC.Disconnect;
end;

procedure TConnectionData.HandleChannelJoined(const AChannel: string; const AFocusChannel: Boolean);
var
  ChannelChat: TChatFrame;
begin
  ChannelChat := OpenChatWithTarget(AChannel, AFocusChannel);

  ChannelChat.AddIRCLine('JOIN', IdIRC.UsedNickname, FNickHost, AChannel, '', True);

  if FJoinTopics.IndexOfName(AChannel) >= 0 then
    ChannelChat.Topic := FJoinTopics.Values[AChannel];
  if ChannelChat.Topic <> '' then
    MainForm.TopicEdit.SetIRCText(ChannelChat.Topic);

  FJoinTopics.Values[AChannel] := '';
end;  

function TConnectionData.OpenChatWithTarget(const ATarget: string; const AFocusTarget: Boolean): TChatFrame;
var
  Index: Integer;
  ChannelNode: TTreeNode;
begin
  Index := FChatTargets.IndexOf(ATarget);
  if Index = - 1  then
  begin
    ChannelNode := MainForm.CreateChatNode(Self, ATarget);
    Result := MainForm.CreateChatFrame(ChannelNode);
    ActiveChat := Result;               
    ChannelNode.Selected := True;
    FChatTargets.Add(ATarget);
    FChatFrames.Add(Result);
  end
  else
  begin
    Result := TChatFrame(FChatFrames[Index]);
    if AFocusTarget then
      MainForm.FindChatNode(Self, ATarget).Selected := True;
  end;
end;

procedure TConnectionData.Query(const ATarget: string; const AMessage: string = '');
begin
  OpenChatWithTarget(ATarget, True);

  if AMessage <> '' then
    Say(ATarget, AMessage);
end;

procedure TConnectionData.Quit(const AReason: string);
begin
  IdIRC.Disconnect(AReason);
end;

procedure TConnectionData.CloseWindow(const ATarget: string);
var
  Index: Integer;   
  ChatFrame: TChatFrame;
begin
  if ATarget = '' then
  begin
    if MainForm.Connections.Count > 1 then
    begin
      MainForm.Connections.Remove(Self);
    end;
  end else
  begin
    Index := FChatTargets.IndexOf(ATarget);
    if Index >= 0 then
    begin
      ChatFrame := TChatFrame(FChatFrames[Index]);
      FChatFrames.Extract(ChatFrame);
      FChatTargets.Delete(Index);
      ChatFrame.TreeNode.Free;
      if ActiveChat = ChatFrame then
        ActiveChat := FServerChat;
      ChatFrame.Free;
    end;
  end;
end;

procedure TConnectionData.HandleNickNamesList(const AChannel, ANickNames: string);
var
  Index: Integer;
begin
  Index := FChatTargets.IndexOf(AChannel);
  if Index >= 0 then
  begin
    TChatFrame(FChatFrames[Index]).Nicknames.Text := ANickNames;
    MainForm.PopulateNickList;
    MainForm.PopulateTopic; //update read-only property
  end;
end;

procedure TConnectionData.CTCPQuery(const ATarget, ACommand, AParameters: string);
begin
  IdIRC.CTCPQuery(ATarget, ACommand, AParameters);
  ActiveChat.AddIRCLine('CTCPQUERY', IdIRC.UsedNickname, '', ATarget, ACommand, True, AParameters);
end;

procedure TConnectionData.Cycle(const AChannel: string; const AReason: string = '');
begin
  FCycling := True;

  Part(AChannel, AReason);
  Join(AChannel);
end;

procedure TConnectionData.DataModuleCreate(Sender: TObject);
begin
  Randomize;

  FServer := 'irc.efnet.org';

  FChatFrames := TObjectList.Create;
  FChatTargets := TStringList.Create;
  FJoinTopics := TStringList.Create;
  Port := 6667;
  SetupReplies;

  FServerNode := MainForm.CreateServerNode(Self);
  FServerChat := MainForm.CreateChatFrame(FServerNode);    
  FServerNode.Selected := True;
  ActiveChat := FServerChat;
end;

procedure TConnectionData.LoadSettings;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    IdIRC.Nickname := IniFile.ReadString(IdentificationSection, NickNameIdent, 'User' + IntToStr(Random(100)));
    IdIRC.AltNickname := IniFile.ReadString(IdentificationSection, AltNickIdent, 'User' + IntToStr(Random(100)));
    IdIRC.RealName := IniFile.ReadString(IdentificationSection, RealNameIdent, IdIRC.Nickname);
    IdIRC.Username := IniFile.ReadString(IdentificationSection, UserNameIdent, IdIRC.Nickname);
  finally
    IniFile.Free;
  end;
end;

procedure TConnectionData.Notice(const ATarget, AText: string);
begin
  IdIRC.Notice(ATarget, AText);    
  MainForm.ActiveChatFrame.AddIRCLine('MYNOTICE', IdIRC.UsedNickname, '', ATarget, AText, True);
end;

procedure TConnectionData.SetupReplies;
var
  Theme: TStrings;
begin
  Theme := TStringList.Create;
  try
    Theme.LoadFromFile(ExtractFilePath(Application.ExeName) + MainForm.CurrentTheme + '.theme');
    IdIRC.Replies.Finger := '';
    IdIRC.Replies.Version := Theme.Values['VERSION'];
    IdIRC.Replies.UserInfo := IdIRC.Username;
    IdIRC.Replies.ClientInfo := '';
  finally
    Theme.Free;
  end;
end;

procedure TConnectionData.Action(const ATarget, AMessage: string);
var
  Index: Integer;
  ChannelChat: TChatFrame;
  Sign: string;
begin
  IdIRC.Action(ATarget, AMessage);
  Index := FChatTargets.IndexOf(ATarget);
  if Index >= 0 then
  begin
    ChannelChat := TChatFrame(FChatFrames[Index]);
    Sign := GetNicknameChannelSign(ChannelChat, IdIRC.UsedNickname);
    if Sign = '' then
      Sign := ' '; //for padding
    MainForm.ActiveChatFrame.AddIRCLine('ACTION', IdIRC.UsedNickname, '', ATarget, AMessage, True, '', Sign);
  end else
    MainForm.ActiveChatFrame.AddIRCLine('ACTION', IdIRC.UsedNickname, '', ATarget, AMessage, True);
end;

procedure TConnectionData.Connect;
begin

  try
    PostMessage(MainForm.Handle, WM_ENABLEIDENT, 0, 0);
  except
    on E:Exception do
      FServerChat.AddText(E.Message);
  end;

  FServerNode.Text := Server;

  FLastNick := '';
                     
  LoadSettings;
  IdIRC.Password := Password;
  IdIRC.Host := Server;
  IdIRC.Port := Port;
  IdIRC.Connect;
end;

procedure TConnectionData.IdIRCChannelMode(ASender: TIdContext; const
    ANickname, AHost, AChannel, AMode, AParams: string);
var
  Index: Integer;
  ChannelChat: TChatFrame;
begin
  Index := FChatTargets.IndexOf(AChannel);
  ChannelChat := TChatFrame(FChatFrames[Index]);
  UpdateNicksFromModeChange(AChannel, AMode);
  RefreshTopicForChannel(AChannel); //update read-only property
  ChannelChat.AddIRCLine('CHANMODE', ANickname, AHost, AChannel, Trim(AMode + ' ' + AParams),
    ANickname = IdIRC.UsedNickname, AParams);
end;

procedure TConnectionData.RefreshTopicForChannel(const AChannel: string);
var
  Index: Integer;
  ChannelChat: TChatFrame;
begin
  Index := FChatTargets.IndexOf(AChannel);
  ChannelChat := TChatFrame(FChatFrames[Index]);
  if MainForm.ActiveChatFrame = ChannelChat then
    MainForm.PopulateTopic;
end;

procedure TConnectionData.UpdateNicksFromModeChange(const AChannel, AModes: string);
const
  Modes: array[0..1] of Char = ('o', 'v');
  Signs: array[0..1] of Char = ('@', '+');
var
  I, NickIndex, ModeIndex: Integer;
  NickSigns: TStrings;
  Nicks: TStrings;
  Index: Integer;
  ChannelChat: TChatFrame;
  Tokenizer: TTokenizer;
  ModeFlags, ModeFlag, NickName, NewNick: string;
  IsPlus, IsUserMode: Boolean;
begin       
  Index := FChatTargets.IndexOf(AChannel);
  if Index >= 0 then
  begin
    ChannelChat := TChatFrame(FChatFrames[Index]);
    NickSigns := TStringList.Create;
    Nicks := TStringList.Create;
    Tokenizer := TTokenizer.Create(AModes, ' ');
    try
      ModeFlags := Tokenizer.NextToken;
      if Tokenizer.HasMoreTokens then
      begin
        while Tokenizer.HasMoreTokens do
          Nicks.Add(Tokenizer.NextToken);

        for I := 0 to Nicks.Count - 1 do
          NickSigns.Values[Nicks[I]] := GetNicknameChannelSign(ChannelChat, Nicks[I]);

        NickIndex := 0;

        IsPlus := True;
        for I := 1 to Length(ModeFlags) do
        begin
          if ModeFlags[I] = '+' then
            IsPlus := True
          else if ModeFlags[I] = '-' then
            IsPlus := False
          else
          begin
            ModeFlag := ModeFlags[I];
            IsUserMode := False;

            for ModeIndex := Low(Modes) to High(Modes) do
            begin
              if SameText(ModeFlag, Modes[ModeIndex]) then
              begin
                NickName := Nicks[NickIndex];
                Inc(NickIndex);

                if IsPlus then
                begin
                  if Pos(Signs[ModeIndex], NickSigns.Values[NickName]) = 0 then
                    NickSigns.Values[NickName] := Signs[ModeIndex]
                end
                else if Pos(Signs[ModeIndex], NickSigns.Values[NickName]) > 0 then
                  NickSigns.Values[NickName] := StringReplace(NickSigns.Values[NickName], '@', '', []);

                IsUserMode := True;
                Break;
              end;
            end;

            if not IsUserMode then
              Nicks.Delete(NickIndex);
          end;
        end;

        for I := 0 to Nicks.Count - 1 do
        begin
          NickName := Nicks[I];
          if NickName = '' then
            Continue;

          if Pos('@', NickSigns.Values[NickName]) > 0 then
            NewNick := '@' + NickName     
          else if Pos('+', NickSigns.Values[NickName]) > 0 then
            NewNick := '+' + NickName
          else
            NewNick := NickName;

          RemoveNickFromChannel(ChannelChat, NickName);
          ChannelChat.Nicknames.Add(NewNick);

          if ChannelChat = MainForm.ActiveChatFrame then
          begin
            RemoveNickFromList(Nickname);
            AddNickToList(NewNick);
          end;

        end;
      end;
    finally
      NickSigns.Free;
      Nicks.Free;
      Tokenizer.Free;
    end;
  end;
end;

procedure TConnectionData.IdIRCDisconnected(Sender: TObject);
begin
  FServerChat.AddText('Disconnected from server.');
  PostMessage(MainForm.Handle, WM_DISABLEIDENT, 0, 0);
end;

procedure TConnectionData.IdIRCJoin(ASender: TIdContext; const ANickname, AHost, AChannel: string);
var
  Index: Integer;
  ChannelChat: TChatFrame;
begin
  if (ANickname = IdIRC.UsedNickname) and not FCycling then
  begin
    //prevent deadlock
    FNickHost := AHost;
    PostMessage(MainForm.Handle, WM_CHANNELJOINED, Integer(Self), GlobalAddAtom(PChar(AChannel)));
  end else
  begin
    Index := FChatTargets.IndexOf(AChannel);   
    if Index = -1 then
      Exit;
    ChannelChat := TChatFrame(FChatFrames[Index]);
    ChannelChat.AddIRCLine('JOIN', ANickname, AHost, ACHannel, '', ANickname = IdIRC.UsedNickname);
    ChannelChat.Nicknames.Add(ANickname);
    if MainForm.ActiveChatFrame = ChannelChat then
      AddNickToList(ANickname);
  end;

  FCycling := False;
end;

procedure TConnectionData.IdIRCKick(ASender: TIdContext; const ANickname,
    AHost, AChannel, ATarget, AReason: string);
var
  Index: Integer;
begin
  Index := FChatTargets.IndexOf(AChannel);       
  if Index = -1 then
    Exit;
  TChatFrame(FChatFrames[Index]).AddIRCLine('KICK', ANickname, AHost, AChannel, AReason,
    ANickname = IdIRC.UsedNickname, '', '@', ATarget);
end;

procedure TConnectionData.IdIRCMOTD(ASender: TIdContext; AMOTD: TStrings);
begin
  FServerChat.AddStrings(AMOTD);
end;

procedure TConnectionData.IdIRCNicknamesListReceived(ASender: TIdContext; const
    AChannel: string; ANicknameList: TStrings);
var
  Param: TNickNamesListParam;
begin
  Param := TNickNamesListParam.Create;
  Param.Connection := Self;
  Param.Channel := AChannel;
  Param.NickNames := ANicknameList.Text;

  PostMessage(MainForm.Handle, WM_NICKNAMESLIST, Cardinal(Param), 0);
end;

procedure TConnectionData.IdIRCNotice(ASender: TIdContext; const ANickname,
    AHost, ATarget, ANotice: string);
var
  Nick: string;
begin
  if AHost = '' then
  begin
    //efnet doesn't send a "nick" with this
    if ANickname = '' then
      Nick := Server
    else
      Nick := ANickname;

    ServerChat.AddIRCLine('SERVERNOTICE', Nick, AHost, ATarget, ANotice, False);
  end else
    ActiveChat.AddIRCLine('NOTICE', ANickname, AHost, ATarget, ANotice, False);
end;

procedure TConnectionData.IdIRCPart(ASender: TIdContext; const ANickname,
    AHost, AChannel, APartMessage: string);
var
  Index: Integer;
  ChannelChat: TChatFrame;
begin
  Index := FChatTargets.IndexOf(AChannel);
  if Index = -1 then
    Exit;
  ChannelChat := TChatFrame(FChatFrames[Index]);
  ChannelChat.AddIRCLine('PART', ANickname, AHost, ACHannel, '', ANickname = IdIRC.UsedNickname);
  RemoveNickFromChannel(ChannelChat, ANickname);
  if ChannelChat = MainForm.ActiveChatFrame then
    RemoveNickFromList(ANickname);
end;

procedure TConnectionData.IdIRCPrivateMessage(ASender: TIdContext; const
    ANicknameFrom, AHost, ANicknameTo, AMessage: string);
var
  Sign: string;
  Index: Integer;
  ChannelChat: TChatFrame;
begin
  if ANicknameTo = IdIRC.UsedNickname then
  begin
    Index := FChatTargets.IndexOf(ANicknameFrom);
    if Index >= 0 then
    begin
      ChannelChat := TChatFrame(FChatFrames[Index]);
      ChannelChat.AddIRCLine('CHANMSG', ANicknameFrom, AHost, ANicknameTo, AMessage,
        ANicknameFrom = IdIRC.UsedNickname, '', Sign);
    end else   
      ActiveChat.AddIRCLine('PRIVMSG', ANicknameFrom, AHost, ANicknameTo, AMessage, False);
  end else
  begin
    Index := FChatTargets.IndexOf(ANicknameTo);
    if Index = -1 then
      Exit;
    ChannelChat := TChatFrame(FChatFrames[Index]);
    Sign := GetNicknameChannelSign(ChannelChat, ANicknameFrom);
    ChannelChat.AddIRCLine('CHANMSG', ANicknameFrom, AHost, ANicknameTo, AMessage,
      ANicknameFrom = IdIRC.UsedNickname, '', Sign);
  end;
end;

function TConnectionData.GetConnected: Boolean;
begin
  Result := IdIRC.Connected;
end;

function TConnectionData.GetNicknameChannelSign(const AChannelChat: TChatFrame; const ANickname: string): string;
begin
  if IsOp(AChannelChat, ANickname) then
    Result := '@'
  else if IsVoice(AChannelChat, ANickname) then
    Result := '+'
  else
    Result := '';
end;

function TConnectionData.GetUsedNickname: string;
begin
  Result := IdIRC.UsedNickname;
end;

function TConnectionData.IsOp(const AChannelChat: TChatFrame; const ANickname: string): Boolean;
begin
  Result := AChannelChat.Nicknames.IndexOf('@' + ANickname) >= 0;
end;

function TConnectionData.IsVoice(const AChannelChat: TChatFrame; const ANickname: string): Boolean;
begin
  Result := AChannelChat.Nicknames.IndexOf('+' + ANickname) >= 0;
end;

procedure TConnectionData.IdIRCQuit(ASender: TIdContext; const ANickname,
    AHost, AReason: string);
var
  I: Integer;
  ChannelChat: TChatFrame;
begin
  if ANickname = IdIRC.UsedNickname then                                        
  begin

  end else                       
  begin
    for I := 0 to FChatFrames.Count - 1 do
    begin
      ChannelChat := TChatFrame(FChatFrames[I]);
      if (ChannelChat.Nicknames.IndexOf(ANickname) >= 0) or
        (ChannelChat.Nicknames.IndexOf('@' + ANickname) >= 0) or
        (ChannelChat.Nicknames.IndexOf('+' + ANickname) >= 0) then
      begin
        ChannelChat.AddIRCLine('QUIT', ANickname, AHost, '', AReason, ANickname = IdIRC.UsedNickname);
        RemoveNickFromChannel(ChannelChat, ANickname); 
        if ChannelChat = MainForm.ActiveChatFrame then
          RemoveNickFromList(ANickname);
      end;
    end;
  end;
end;  

procedure TConnectionData.IdIRCCTCPQuery(ASender: TIdContext; const ANickname,
    AHost, ATarget, ACommand, AParams: string);
var
  Sign: string;
  Index: Integer;
  ChannelChat: TChatFrame;
begin
  if SameText(ACommand, 'ACTION') then
  begin
    if ATarget = IdIRC.UsedNickname then
    begin
      ActiveChat.AddIRCLine('ACTION', ANickname, AHost, ATarget, AParams, ANickname = IdIRC.UsedNickname);
    end else
    begin
      Index := FChatTargets.IndexOf(ATarget);
      if Index = -1 then
        Exit;
      ChannelChat := TChatFrame(FChatFrames[Index]);
      Sign := GetNicknameChannelSign(ChannelChat, ANickname);
      ChannelChat.AddIRCLine('ACTION', ANickname, AHost, ATarget, AParams, ANickname = IdIRC.UsedNickname, '', Sign);
    end;
  end else
    ActiveChat.AddIRCLine('CTCPQUERY', ANickname, AHost, ATarget, ACommand, False, AParams);
end;

procedure TConnectionData.IdIRCCTCPReply(ASender: TIdContext; const ANickname,
    AHost, ATarget, ACommand, AParams: string);
begin
  ActiveChat.AddIRCLine('CTCPREPLY', ANickname, AHost, ATarget, ACommand, True, AParams);
end;

procedure TConnectionData.IdIRCRaw(ASender: TIdContext; AIn: Boolean; const AMessage: string);
var
  Prefix, Text: string;
begin
  Prefix := '';
  if IdIRC.SenderNick <> '' then
    Prefix := Format(':%s', [IdIRC.SenderNick]);
  if IdIRC.SenderHost <> '' then
    Prefix := Prefix + Format('!%s', [IdIRC.SenderHost]);
  if Prefix <> '' then
    Prefix := Prefix + ' ';

  Text := Prefix + AMessage;
  
  if AIn then
    FServerChat.AddIRCLine('RAWIN', '', '', '', Text, False)
  else
    FServerChat.AddIRCLine('RAWOUT', '', '', '', Text, False);

  HandleCustomRawCommands(AMessage);
end;       

procedure TConnectionData.HandleCustomRawCommands(const ARawMessage: string);
var
  RawCmd, Target, Nick, Host, Text, Text2: string;
  Tokenizer: TTokenizer;
begin
  Tokenizer := TTokenizer.Create(ARawMessage, ' ');
  RawCmd := Tokenizer.NextToken;
  if SameText(RawCmd, '307') then
  begin
    Target := Tokenizer.NextToken;
    Nick := Tokenizer.NextToken;
    Text := Tokenizer.NextToken;
    Delete(Text, 1, 1);
    while Tokenizer.HasMoreTokens do
      Text := Text + ' '+ Tokenizer.NextToken;
    ActiveChat.AddIRCLine(RawCmd, Nick, '', Target, Text, Target = Nick);
  end
  else if SameText(RawCmd, '311') then
  begin
    Target := Tokenizer.NextToken;
    Nick := Tokenizer.NextToken;
    Host := Tokenizer.NextToken + '@'+ Tokenizer.NextToken;
    Tokenizer.NextToken;
    Text := Tokenizer.NextToken;
    Delete(Text, 1, 1);
    ActiveChat.AddIRCLine(RawCmd, Nick, Host, Target, Text, Target = Nick);
  end
  else if SameText(RawCmd, '312') then
  begin
    Target := Tokenizer.NextToken;
    Nick := Tokenizer.NextToken;
    Text := Tokenizer.NextToken;
    Text2 := Tokenizer.NextToken;
    Delete(Text2, 1, 1);
    while Tokenizer.HasMoreTokens do
      Text2 := Text2 + ' '+ Tokenizer.NextToken;
    ActiveChat.AddIRCLine(RawCmd, Nick, '', Target, Text, Target = Nick, Text2);
  end
  else if SameText(RawCmd, '317') then
  begin
    Target := Tokenizer.NextToken;
    Nick := Tokenizer.NextToken;
    Text := DurationToStr(StrToInt(Tokenizer.NextToken) * 1000);
    Text2 := DateToStr(UnixToDateTime(StrToInt(Tokenizer.NextToken)));
    ActiveChat.AddIRCLine(RawCmd, Nick, '', Target, Text, Target = Nick, Text2);
  end
  else if SameText(RawCmd, '318') then
  begin
    Target := Tokenizer.NextToken;
    Nick := Tokenizer.NextToken;
    ActiveChat.AddIRCLine(RawCmd, Nick, '', Target, '', Target = Nick);
  end
  else if SameText(RawCmd, '319') then
  begin
    Target := Tokenizer.NextToken;
    Nick := Tokenizer.NextToken;
    Text := Tokenizer.NextToken;
    Delete(Text, 1, 1);
    while Tokenizer.HasMoreTokens do
      Text := Text + ' '+ Tokenizer.NextToken;
    ActiveChat.AddIRCLine(RawCmd, Nick, '', Target, Text, Target = Nick);
  end;
end;

procedure TConnectionData.AddNickToList(const ANewNick: string);
begin
  PostMessage(MainForm.Handle, WM_ADDNICK, GlobalAddAtom(PChar(ANewNick)), 0);
end;

procedure TConnectionData.IdIRCConnected(Sender: TObject);
begin
  FServerChat.AddText('Connected to server...');
end;

procedure TConnectionData.IdIRCNicknameChange(ASender: TIdContext; const
    AOldNickname, AHost, ANewNickname: string);
var
  I: Integer;
  ChannelChat: TChatFrame;
  NewNick: string;
begin
  for I := 0 to FChatFrames.Count - 1 do
  begin
    ChannelChat := TChatFrame(FChatFrames[I]);
    if (ChannelChat.Nicknames.IndexOf(AOldNickname) >= 0) or
      (ChannelChat.Nicknames.IndexOf('@' + AOldNickname) >= 0) or
      (ChannelChat.Nicknames.IndexOf('+' + AOldNickname) >= 0) then
    begin
      ChannelChat.AddIRCLine('NICK', AOldNickname, '', '', '', ANewNickname = IdIRC.UsedNickname,
        '', '', ANewNickname);
      NewNick := GetNicknameChannelSign(ChannelChat, AOldNickname) + ANewNickname;
      RemoveNickFromChannel(ChannelChat, AOldNickname);
      ChannelChat.Nicknames.Add(NewNick);
      if ChannelChat = MainForm.ActiveChatFrame then
      begin
        RemoveNickFromList(AOldNickname);
        AddNickToList(NewNick);
      end;
    end;
  end;
  if ANewNickname = IdIRC.UsedNickname then
    MainForm.PopulateAppCaption;
end; 

procedure TConnectionData.RemoveNickFromList(const ANickname: string);
begin
  PostMessage(MainForm.Handle, WM_REMOVENICK, GlobalAddAtom(PChar(ANickname)), 0);
end;

procedure TConnectionData.RemoveNickFromChannel(const AChatFrame: TChatFrame; const ANickname: string);
var
  Index: Integer;
begin
  Index := AChatFrame.Nicknames.IndexOf('@' + ANickname);
  if Index >= 0 then
    AChatFrame.Nicknames.Delete(Index)
  else
  begin
    Index := AChatFrame.Nicknames.IndexOf('+' + ANickname);
    if Index >= 0 then
      AChatFrame.Nicknames.Delete(Index)
    else
    begin
      Index := AChatFrame.Nicknames.IndexOf(ANickname);
      if Index >= 0 then
        AChatFrame.Nicknames.Delete(Index)
    end;
  end;
end;

procedure TConnectionData.IdIRCServerError(ASender: TIdContext; AErrorCode:
    Integer; const AErrorMessage: string);
begin
  FServerChat.AddText(AErrorMessage);
end;

procedure TConnectionData.IdIRCServerUsersListReceived(ASender: TIdContext;
    AUsers: TStrings);
begin
  FServerChat.AddStrings(AUsers);
end;

procedure TConnectionData.IdIRCServerVersion(ASender: TIdContext; const
    AVersion, AHost, AComments: string);
begin
  FServerChat.AddText(AVersion + #9 + AHost + #9 + AComments);
end;

procedure TConnectionData.IdIRCServerWelcome(ASender: TIdContext; const AMsg: string);
begin                        
  PostMessage(MainForm.Handle, WM_DISABLEIDENT, 0, 0);
  FServerChat.AddText(AMsg);
  MainForm.PopulateAppCaption;
  PostMessage(MainForm.Handle, WM_AUTOJOIN, Integer(Self), 0);
end;

procedure TConnectionData.IdIRCTopic(ASender: TIdContext; const ANickname,
    AHost, AChannel, ATopic: string);
var
  Index: Integer;
begin
  Index := FChatTargets.IndexOf(AChannel);
  if Index >= 0 then
  begin
    if AHost <> '' then // not an On-Join topic
      TChatFrame(FChatFrames[Index]).AddIRCLine('TOPIC', ANickname, AHost, AChannel, ATopic,
        ANickname = IdIRC.UsedNickname);
    TChatFrame(FChatFrames[Index]).Topic := ATopic;
    if SameText(MainForm.ActiveTarget, AChannel) then
      PostMessage(MainForm.Handle, WM_SETTOPICTEXT, GlobalAddAtom(PChar(ATopic)), 0);
  end else if AHost = '' then // this is an On-Join topic, haven't created channel frame yet (threaded)
  begin
    FJoinTopics.Values[AChannel] := ATopic;
  end;
end;

procedure TConnectionData.IdIRCUserMode(ASender: TIdContext; const ANickname,
    AHost, AMode: string);
var
  RealMode: string;
begin
  RealMode := AMode;
  if RealMode[1] = ':' then
    Delete(RealMode, 1, 1);
  ActiveChat.AddIRCLine('USERMODE', ANickname, AHost, '', RealMode, ANickname = IdIRC.UsedNickname);
end;

procedure TConnectionData.IdIRCISupport(ASender: TIdContext; AParameters: TStrings);
const
  NetworkDelim = 'NETWORK=';
var
  I: Integer;
begin
  for I := 0 to AParameters.Count - 1 do
  begin
    if StartsText(NetworkDelim, AParameters[I]) then
    begin
      FNetwork := Copy(AParameters[I], Length(NetworkDelim) + 1, Length(AParameters[I]));
      MainForm.PopulateAppCaption;
      Break;
    end;
  end;
end;

procedure TConnectionData.IdIRCMyInfo(ASender: TIdContext; const AServer,
    AVersion, AUserModes, AChanModes, AExtra: string);
begin
  FUsedServer := AServer;
  ServerNode.Text := AServer;
end;

procedure TConnectionData.IdIRCNicknameError(ASender: TIdContext; AError: Integer);
begin
  if (AError = 433) and (IdIRC.UsedNickname = IdIRC.AltNickname) then
  begin
    FServerChat.AddText('Nickname and alternate are already in use.');
    PostMessage(MainForm.Handle, WM_NICKSINUSE, 0, 0);
  end;
end;

procedure TConnectionData.Join(const AChannel: string; const AKey: string = '');
begin
  IdIRC.Join(AChannel, AKey);
end;

procedure TConnectionData.ListChannelNicknames(const AChannel: string; const ATarget: string = '');
begin
  IdIRC.ListChannelNicknames(AChannel, ATarget);
end;

procedure TConnectionData.Part(const AChannel: string; const AReason: string = '');
begin
  IdIRC.Part(AChannel, AReason);
end;

procedure TConnectionData.Say(const ATarget, AText: string);
var
  Index: Integer;
  ChannelChat: TChatFrame;
  Sign: string;
begin
  IdIRC.Say(ATarget, AText);
  Index := FChatTargets.IndexOf(ATarget);
  if Index >= 0 then
  begin
    ChannelChat := TChatFrame(FChatFrames[Index]);
    Sign := GetNicknameChannelSign(ChannelChat, IdIRC.UsedNickname);
    ChannelChat.AddIRCLine('CHANMSG', IdIRC.UsedNickname, '', ATarget, AText, True, '', Sign);
  end else
    MainForm.ActiveChatFrame.AddIRCLine('PRIVMSG', IdIRC.UsedNickname, '', ATarget, AText, True);
end;

procedure TConnectionData.SendRaw(const ALine: string);
begin
  IdIRC.Raw(ALine);
end;

procedure TConnectionData.SetActiveChat(const Value: TChatFrame);
begin
  FActiveChat := Value;
end;

procedure TConnectionData.SetNickname(const ANickname: string);
begin
  IdIRC.Nickname := ANickname;
end;

procedure TConnectionData.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TConnectionData.SetPort(const Value: Integer);
begin
  FPort := Value;
end;

procedure TConnectionData.SetServer(const Value: string);
begin
  FServer := Value;    
  if Assigned(FServerNode) then
    FServerNode.Text := Value;
end;

procedure TConnectionData.Whois(const AMask: string; const ATarget: string = '');
begin
  IdIRC.Whois(AMask, ATarget);
end;

end.
