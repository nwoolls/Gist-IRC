unit uTokenizer;

interface

type

  TTokenizer = class(TObject)
  private
    FSource, FDelimeter: string;
    FPos: Integer;
  public
    { ASource is your source text
      ADelimeter is a string of one or more chars treated as individual delimeters
      e.g. TTokenizer.Create('This, is a test', ', ') would tokenize into 'This' 'is' 'a' and 'test' }
    constructor Create(const ASource, ADelimeter: string); virtual;
    function HasMoreTokens: Boolean;
    function NextToken: string;
    function PeekToken: string;
    procedure Reset;
    procedure SkipToken;
  end;

implementation

{ TTokenizer }

constructor TTokenizer.Create(const ASource, ADelimeter: string);
begin
  FSource := ASource;
  FDelimeter := ADelimeter;
  FPos := 1;
end;

function TTokenizer.HasMoreTokens: Boolean;
begin
  Result := FPos <= Length(FSource);
end;

function TTokenizer.NextToken: string;
var
  I, EndP: Integer;
begin
  EndP := 0;
  Result := '';
  for I := FPos to Length(FSource) do
  begin
    if Pos(FSource[I], FDelimeter) > 0 then
    begin
      EndP := I;
      Break;
    end;
    EndP := I + 1;
  end;
  if EndP > 0 then
  begin
    Result := Copy(FSource, FPos, EndP - FPos); 
    FPos := EndP + 1;
    while (FPos < Length(FSource)) and
      (Pos(FSource[FPos], FDelimeter) > 0) do
      Inc(FPos);
  end;
end;

function TTokenizer.PeekToken: string;
var
  I, EndP: Integer;
begin
  EndP := 0;
  Result := '';
  for I := FPos to Length(FSource) do
  begin
    if Pos(FSource[I], FDelimeter) > 0 then
    begin
      EndP := I;
      Break;
    end;
    EndP := I + 1;
  end;
  if EndP > 0 then
    Result := Copy(FSource, FPos, EndP - FPos);
end;

procedure TTokenizer.Reset;
begin
  FPos := 1;
end;

procedure TTokenizer.SkipToken;
begin
  NextToken;
end;

end.
