unit uCycleCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TCycleCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils, Windows, Forms;

{ TCycleCommandHandler }

function TCycleCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Channel, Reason: string;
begin
  Reason := '';

  if ATokenizer.HasMoreTokens then
    Channel := ATokenizer.NextToken
  else
    Channel := ATarget;

  if Channel[1] <> '#' then
    Channel := '#' + Channel;

  Reason := ATokenizer.NextToken;

  AConnection.Cycle(Channel, Reason);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/cycle', TCycleCommandHandler);
end.

