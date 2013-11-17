unit uWhoisCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TWhoisCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TWhoisCommandHandler }

function TWhoisCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Mask, Target: string;
begin
  if not ATokenizer.HasMoreTokens then
    Exit;

  Mask := ATokenizer.NextToken;
  Target := ATokenizer.NextToken;

  AConnection.WhoIs(Mask, Target);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/whois', TWhoisCommandHandler);   
  TCommandHandlerFactory.GetInstance.RegisterClass('/wi', TWhoisCommandHandler);
end.

