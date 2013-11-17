unit uServerCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TServerCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TServerCommandHandler }

function TServerCommandHandler.HandleCommand(const AConnection:
    TConnectionData; const ATarget: string; const ATokenizer: TTokenizer):
    string;
var
  Host, Password: string;
  Port: Integer;
begin
  Port := 6667;

  Host := ATokenizer.NextToken;

  if ATokenizer.HasMoreTokens then
    Port := StrToInt(ATokenizer.NextToken);

  Password := ATokenizer.NextToken;

  AConnection.Disconnect;

  Sleep(100);

  if Host <> '' then
  begin    
    AConnection.Server := Host;
    AConnection.Port := Port;
    AConnection.Password := Password;      
  end;

  AConnection.Connect;
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/server', TServerCommandHandler); 
  TCommandHandlerFactory.GetInstance.RegisterClass('/connect', TServerCommandHandler);
end.
