unit uCloseCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TCloseCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TCloseCommandHandler }

function TCloseCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Target: string;
begin
  if ATokenizer.HasMoreTokens then
    Target := ATokenizer.NextToken
  else
    Target := ATarget;

  AConnection.CloseWindow(Target);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/close', TCloseCommandHandler);
end.

