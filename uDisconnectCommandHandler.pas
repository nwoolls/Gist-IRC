unit uDisconnectCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TDisconnectCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TDisconnectCommandHandler }

function TDisconnectCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
begin
  AConnection.Quit(ATokenizer.NextToken);
end;

initialization
  TCommandHandlerFactory.GetInstance.RegisterClass('/disconnect', TDisconnectCommandHandler);   
  TCommandHandlerFactory.GetInstance.RegisterClass('/quit', TDisconnectCommandHandler);
end.

