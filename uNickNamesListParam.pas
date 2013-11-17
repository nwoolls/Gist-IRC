unit uNickNamesListParam;

interface

uses dmConnection;

type
  TNickNamesListParam = class(TObject)
  private
    FNickNames: string;
    FChannel: string;
    FConnection: TConnectionData;
    procedure SetChannel(const Value: string);
    procedure SetConnection(const Value: TConnectionData);
    procedure SetNickNames(const Value: string);
  public
    property Connection: TConnectionData read FConnection write SetConnection;
    property Channel: string read FChannel write SetChannel;
    property NickNames: string read FNickNames write SetNickNames;
  end;

implementation

{ TNickNamesListParam }

procedure TNickNamesListParam.SetChannel(const Value: string);
begin
  FChannel := Value;
end;

procedure TNickNamesListParam.SetConnection(const Value: TConnectionData);
begin
  FConnection := Value;
end;

procedure TNickNamesListParam.SetNickNames(const Value: string);
begin
  FNickNames := Value;
end;

end.
