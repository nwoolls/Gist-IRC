unit uCtcpCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TCtcpCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TCtcpCommandHandler }

function TCtcpCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Target, Command, Parameters: string;
begin
  Parameters := '';

  Target := ATokenizer.NextToken;
  Command := ATokenizer.NextToken;
  Parameters := ATokenizer.NextToken;

  AConnection.CTCPQuery(Target, Command, Parameters);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/ctcp', TCtcpCommandHandler);
end.

