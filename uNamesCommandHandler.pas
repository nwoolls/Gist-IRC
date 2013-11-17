unit uNamesCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TNamesCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TNamesCommandHandler }

function TNamesCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Channel: string;
begin
  if not ATokenizer.HasMoreTokens then
    Exit;

  Channel := ATokenizer.NextToken;

  AConnection.ListChannelNicknames(Channel);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/names', TNamesCommandHandler);
end.

