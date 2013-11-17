unit fInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, uTokenizer;

type
  TInputFrame = class(TFrame)
    InputEdit: TRichEdit;
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
  private
    FBackLog: TStrings;
    FBackLogIndex: Integer;
    FMatches: TStringList;
    FLastWord: string;
    procedure ParseCommand(const AInputText: string);
    procedure SendText(const AInputText: string);
    function HighOrderBitSet(theWord: Word): Boolean;
    procedure CompleteByTab;
    procedure ReplaceWordAtCursor(const ANewWord: string);
    function StripSignsFromName(const ANickname: string): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses uCommandHandler, fMain, StrUtils;

{$R *.dfm}

constructor TInputFrame.Create(AOwner: TComponent);
begin
  inherited;
  FLastWord := #0;
  FBackLogIndex := -1;
  FBackLog := TStringList.Create;
  FMatches := TStringList.Create;
end;

destructor TInputFrame.Destroy;
begin
  FBackLog.Free;
  FMatches.Free;
  inherited;
end;

procedure TInputFrame.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  InputText: string;
begin
 if ssShift in Shift then
    Exit;

  if InputEdit.Lines.Text <> '' then
  begin
    if Key = VK_RETURN then
    begin
      InputText := InputEdit.Text;
      FBackLog.Add(InputText);
      FBackLogIndex := FBackLog.Count;
      InputEdit.Text := '';
      Application.ProcessMessages;
      if InputText[1] = '/' then
      begin
        ParseCommand(InputText);
      end else
      begin
        SendText(InputText);
      end;
      Key := 0;
    end;
  end;

  if Key = VK_UP then
  begin
    if FBackLog.Count > 0 then
    begin
      Dec(FBackLogIndex);
      if FBackLogIndex < 0 then
        FBackLogIndex := FBackLog.Count - 1;
      InputEdit.Text := FBackLog[FBackLogIndex];  
      InputEdit.SelStart := Length(InputEdit.Text);
      InputEdit.SelLength := 0;
    end;
    Key := 0;
  end else if Key = VK_DOWN then
  begin
    if FBackLog.Count > 0 then
    begin
      Inc(FBackLogIndex);
      if FBackLogIndex > FBackLog.Count - 1 then
        FBackLogIndex := 0;
      InputEdit.Text := FBackLog[FBackLogIndex];
      InputEdit.SelStart := Length(InputEdit.Text);
      InputEdit.SelLength := 0;
    end;   
    Key := 0;
  end else if Key = VK_TAB then
  begin
    CompleteByTab;
  end;
end;   

function TInputFrame.StripSignsFromName(const ANickname: string): string;
begin
  Result := StringReplace(StringReplace(StringReplace(ANickname, '@', '', []), '+', '', []), ' ', '', []);
end;

procedure TInputFrame.CompleteByTab;
var
  I: Integer;
  TheWord: string;
  Tokenizer: TTokenizer;
  Nicknames: TStrings;
  NewWord, Nickname: string;
begin
  TheWord := '';
  Tokenizer := TTokenizer.Create(Copy(InputEdit.Text, 1, InputEdit.SelStart), ' ');
  try
    while Tokenizer.HasMoreTokens do
      TheWord := Tokenizer.NextToken;
  finally
    Tokenizer.Free;
  end;

  I := InputEdit.SelStart;
  while I <= Length(InputEdit.Text) - 1 do
  begin
    Inc(I);
    if InputEdit.Text[I] <> ' ' then
      TheWord := TheWord + InputEdit.Text[I]
    else
      Break;
  end;

  NewWord := '';
  if TheWord <> FLastWord then
  begin
    FMatches.Clear;
    Nicknames := MainForm.ActiveChatFrame.Nicknames;
    for I := 0 to Nicknames.Count - 1 do
    begin
      Nickname := StripSignsFromName(Nicknames[I]);
      if StartsText(TheWord, Nickname) then
      begin
        FMatches.Add(Nickname);
      end;
    end;
    if FMatches.Count > 0 then
    begin         
      FMatches.Sort;
      NewWord := FMatches[0];
    end;
  end else
  begin
    I := FMatches.IndexOf(FLastWord);
    Inc(I);
    if I > FMatches.Count - 1 then
      I := 0;
    NewWord := FMatches[I];
  end;
  if NewWord <> '' then
  begin
    ReplaceWordAtCursor(NewWord);
    FLastWord := NewWord;
  end;
end;

procedure TInputFrame.ReplaceWordAtCursor(const ANewWord: string);
var
  StartIndex, EndIndex: Integer;
begin
  StartIndex := InputEdit.SelStart;
  while (StartIndex > 0) and (InputEdit.Text[StartIndex] <> ' ') do
  begin
    StartIndex := StartIndex - 1;
  end;

  EndIndex := PosEx(' ', InputEdit.Text, InputEdit.SelStart);
  if EndIndex = 0 then
    EndIndex := InputEdit.SelStart
  else
    Dec(EndIndex);

  InputEdit.SelStart := StartIndex;
  InputEdit.SelLength := EndIndex - StartIndex;
  InputEdit.SelText := ANewWord;
end;

// Tests whether the high order bit of the given word is set.
function TInputFrame.HighOrderBitSet (theWord: Word): Boolean;
const
  HighOrderBit = 15;
type
  BitSet = set of 0..15;
begin
  Result := (HighOrderBit in BitSet(theWord));
end;

procedure TInputFrame.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if HighOrderBitSet(Word(GetKeyState(VK_SHIFT))) then
    Exit;

  if (Key in [#9, #13]) then
    Key := #0;
end;

procedure TInputFrame.ParseCommand(const AInputText: string);
var
  Tokenizer: TTokenizer;
  Command: string;
begin
  Tokenizer := TTokenizer.Create(AInputText, ' ');
  Command := Tokenizer.NextToken;
  TCommandHandlerFactory.GetInstance.HandleCommand(MainForm.ActiveConnection, Command,
    MainForm.ActiveTarget, Tokenizer);
end;  

procedure TInputFrame.SendText(const AInputText: string);
begin
  MainForm.ActiveConnection.Say(MainForm.ActiveTarget, AInputText);
end;

end.
