unit uPartCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TPartCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TPartCommandHandler }

function TPartCommandHandler.HandleCommand(const AConnection: TConnectionData;
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

  AConnection.Part(Channel, Reason);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/part', TPartCommandHandler);
end.

