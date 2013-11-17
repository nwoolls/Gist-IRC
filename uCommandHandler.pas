unit uCommandHandler;

interface

uses uTokenizer, Contnrs, Classes, dmConnection;

type
  TCommandHandler = class
  public
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; virtual; abstract;
  end;

  TCommandHandlerClass = class of TCommandHandler;

  TCommandHandlerFactory = class
  private
    FCommandList: TStrings;
    FClassList: TList;
    FObjectList: TObjectList;
    class var FInstance: TCommandHandlerFactory;
    function GetCommandHandler(const AClass: TCommandHandlerClass): TCommandHandler;
  public
    class function GetInstance: TCommandHandlerFactory;
    procedure RegisterClass(const ACommand: string; const AClass: TCommandHandlerClass);
    constructor Create; virtual;
    destructor Destroy; override;
    procedure HandleCommand(const AConnection: TConnectionData; const ACommand, ATarget: string; const ATokenizer: TTokenizer);
  end;

implementation

uses SysUtils;

{ TCommandHandlerFactory }

constructor TCommandHandlerFactory.Create;
begin
  //this is a singleton class and should be accessed via GetInstance
  if Assigned(TCommandHandlerFactory.FInstance) then
    raise Exception.Create('Use GetInstance to retrieve an instance of TCommandHandlerFactory.');
    
  FClassList := TList.Create;
  FObjectList := TObjectList.Create;
  FCommandList := TStringList.Create;
end;

destructor TCommandHandlerFactory.Destroy;
begin
  FCommandList.Free;
  FObjectList.Free;
  FClassList.Free;
  inherited;
end;

class function TCommandHandlerFactory.GetInstance: TCommandHandlerFactory;
begin
  if not Assigned(FInstance) then
    FInstance := TCommandHandlerFactory.Create;
  Result := FInstance;
end;

procedure TCommandHandlerFactory.HandleCommand(const AConnection:
    TConnectionData; const ACommand, ATarget: string; const ATokenizer: TTokenizer);
var
  I: Integer;
  Handler: TCommandHandler;
  Handled: Boolean;
  Line: string;
begin
  Handled := False;
  for I := 0 to FCommandList.Count - 1 do
  begin
    if SameText(FCommandList[I], ACommand) then
    begin
      Handler := GetCommandHandler(TCommandHandlerClass(FClassList[I]));

      Handler.HandleCommand(AConnection, ATarget, ATokenizer);
      Handled := True;
    end;
  end;
  if not Handled then
  begin
    Line := Copy(ACommand, 2, Length(ACommand) - 1);
    while ATokenizer.HasMoreTokens do
    begin
      Line := Line + ' ' + ATokenizer.NextToken;
    end;
    AConnection.SendRaw(Line);
  end;
end;    

function TCommandHandlerFactory.GetCommandHandler(const AClass: TCommandHandlerClass): TCommandHandler;
var
  I: Integer;
begin
  //try to find an object in our pool
  for I := 0 to FObjectList.Count - 1 do
  begin
    if TCommandHandler(FObjectList[I]) is AClass then
    begin
      Result := TCommandHandler(FObjectList[I]);
      Exit;
    end;
  end;

  //create our object and add it to our pool
  Result := AClass.Create;
  FObjectList.Add(Result);
end;

procedure TCommandHandlerFactory.RegisterClass(const ACommand: string; const AClass: TCommandHandlerClass);
begin
  FCommandList.Add(ACommand);
  FClassList.Add(AClass);
end;

initialization

finalization
  TCommandHandlerFactory.FInstance.Free;
end.
