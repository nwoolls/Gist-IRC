unit uSayCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TSayCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TSayCommandHandler }

function TSayCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Target, Line: string;
begin
  if not ATokenizer.HasMoreTokens then
    Exit;

  Target := ATokenizer.NextToken;
  
  Line := ATokenizer.NextToken;
  while ATokenizer.HasMoreTokens do
    Line := Line + ' ' + ATokenizer.NextToken;
  
  AConnection.Say(Target, Line);
end;

initialization                                                              
  TCommandHandlerFactory.GetInstance.RegisterClass('/say', TSayCommandHandler);
  TCommandHandlerFactory.GetInstance.RegisterClass('/msg', TSayCommandHandler);
end.

