unit uJoinCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TJoinCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TJoinCommandHandler }

function TJoinCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Channel, Key: string;
begin
  Key := '';

  Channel := ATokenizer.NextToken;
  if Channel = '' then
    Channel := ATarget;
  if Channel[1] <> '#' then
    Channel := '#' + Channel;

  Key := ATokenizer.NextToken;

  AConnection.Join(Channel, Key);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/join', TJoinCommandHandler);  
  TCommandHandlerFactory.GetInstance.RegisterClass('/j', TJoinCommandHandler);
end.

