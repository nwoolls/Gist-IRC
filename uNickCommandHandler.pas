unit uNickCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TNickCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TNickCommandHandler }

function TNickCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Nickname: string;
begin
  if not ATokenizer.HasMoreTokens then
    Exit;

  Nickname := ATokenizer.NextToken;

  AConnection.SetNickname(Nickname);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/nick', TNickCommandHandler);
end.

