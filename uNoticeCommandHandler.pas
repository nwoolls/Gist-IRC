unit uNoticeCommandHandler;

interface

uses uCommandHandler, uTokenizer, dmConnection;

type
  TNoticeCommandHandler = class(TCommandHandler)
    function HandleCommand(const AConnection: TConnectionData; const ATarget: string; const ATokenizer: TTokenizer): string; override;
  end;

implementation

uses SysUtils;

{ TNoticeCommandHandler }

function TNoticeCommandHandler.HandleCommand(const AConnection: TConnectionData;
    const ATarget: string; const ATokenizer: TTokenizer): string;
var
  Target, Line: string;
begin
  if not ATokenizer.HasMoreTokens then
    Exit;

  Target := ATokenizer.NextToken;
  
  Line := ATokenizer.NextToken;
  while ATokenizer.HasMoreTokens do
    Line := Line + ' ' + ATokenizer.NextToken;
  
  AConnection.Notice(Target, Line);
end;

initialization                                                              
  TCommandHandlerFactory.GetInstance.RegisterClass('/notice', TNoticeCommandHandler);
end.

