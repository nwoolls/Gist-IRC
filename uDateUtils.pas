unit uDateUtils;

interface     

function DateTimeToUnix(dtDate: TDateTime): Longint;    
function UnixToDateTime(USec: Longint): TDateTime;

implementation

const
  UnixStartDate: TDateTime = 25569.0; // 01/01/1970

function DateTimeToUnix(dtDate: TDateTime): Longint;
begin
  Result := Round((dtDate - UnixStartDate) * 86400);
end;

function UnixToDateTime(USec: Longint): TDateTime;
begin
  Result := (Usec / 86400) + UnixStartDate;
end;

end.
