unit uWhoisExCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TWhoisExCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TWhoisExCommandHandler }

function TWhoisExCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Mask: string;
begin
  if not ATokenizer.HasMoreTokens then
    Exit;

  Mask := ATokenizer.NextToken;

  AConnection.WhoIs(Mask, Mask);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/wii', TWhoisExCommandHandler);
end.

