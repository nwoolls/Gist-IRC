unit uQueryCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TQueryCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TQueryCommandHandler }

function TQueryCommandHandler.HandleCommand(const AConnection: TConnectionData;
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
  
  AConnection.Query(Target, Line);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/query', TQueryCommandHandler);    
  TCommandHandlerFactory.GetInstance.RegisterClass('/q', TQueryCommandHandler);
end.

