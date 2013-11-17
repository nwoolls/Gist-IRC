unit uQuoteCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TQuoteCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TQuoteCommandHandler }

function TQuoteCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Line: string;
begin
  if not ATokenizer.HasMoreTokens then
    Exit;

  Line := ATokenizer.NextToken;
  while ATokenizer.HasMoreTokens do
    Line := Line + ' ' + ATokenizer.NextToken;
  
  AConnection.SendRaw(Line);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/quote', TQuoteCommandHandler);
end.

