unit uMeCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TMeCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TMeCommandHandler }

function TMeCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Line: string;
begin
  if not ATokenizer.HasMoreTokens then
    Exit;

  Line := ATokenizer.NextToken;
  while ATokenizer.HasMoreTokens do
    Line := Line + ' ' + ATokenizer.NextToken;
  
  AConnection.Action(ATarget, Line);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/me', TMeCommandHandler);
end.

