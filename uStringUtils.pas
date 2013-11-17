unit uStringUtils;

interface

function DurationToStr(Miliseconds: Int64): string;

implementation 

uses SysUtils;

function DurationToStr(Miliseconds: Int64): string;
const
  AproxDaysPerMonth = 30;
  MonthsPerYear = 12;
var
  Y, Mo, D, H, M, S, Ms: Int64;
  YSt, MoSt, DSt, HSt, MSt, SSt: string;
begin         
  Ms := Miliseconds;

  if Ms >= MSecsPerSec then
  begin
    S := Ms div MSecsPerSec;
    SSt := 'second';
    if (S > 1) or (S = 0) then
      SSt := SSt + 's';
  end else
  begin        
    SSt := 'millisecond';
    if (Ms > 1) or (Ms = 0) then
      SSt := SSt + 's';
    Result := Format('%d %s', [Ms, SSt]);
    Exit;
  end;

  if S >= SecsPerMin then
  begin                       
    M := S div SecsPerMin;
    S := S mod SecsPerMin;
    MSt := 'minute';
    if (M > 1) or (M = 0) then
      MSt := MSt + 's';
  end else
  begin
    Result := Format('%d %s', [S, SSt]);
    Exit;
  end;

  if M >= MinsPerHour then
  begin
    H := M div MinsPerHour;
    M := M mod MinsPerHour;
    HSt := 'hour';
    if (H > 1) or (H = 0) then
      HSt := HSt + 's';
  end else
  begin
    Result := Format('%d %s, %d %s', [M, MSt, S, SSt]);
    Exit;
  end;

  if H >= HoursPerDay then
  begin
    D := H div HoursPerDay;
    H := H mod HoursPerDay;
    Dst := 'day';
    if (D > 1) or (D = 0) then
      Dst := Dst + 's';
  end else
  begin
    Result := Format('%d %s, %d %s, %d %s', [H, HSt, M, MSt, S, SSt]);
    Exit;
  end;

  if D >= AproxDaysPerMonth then
  begin
    Mo := D div AproxDaysPerMonth;
    D := D mod AproxDaysPerMonth;
    MoSt := 'month';
    if (Mo > 1) or (Mo = 0) then
      MoSt := MoSt + 's';
  end else
  begin
    Result := Format('%d %s, %d %s, %d %s, %d %s', [D, Dst, H, HSt, M, MSt, S, SSt]);
    Exit;
  end;

  if Mo >= MonthsPerYear then
  begin
    Y := Mo div MonthsPerYear;
    Mo := Mo mod MonthsPerYear;
    Yst := 'year';
    if (Y > 1) or (Y = 0) then
      Yst := Yst + 's';
  end else
  begin
    Result := Format('%d %s, %d %s, %d %s, %d %s, %d %s',
      [Mo, MoSt, D, Dst, H, HSt, M, MSt, S, SSt]);
    Exit;
  end;

  Result := Format('%d %s, %d %s, %d %s, %d %s, %d %s, %d %s', [Y, Yst, Mo, MoSt, D, Dst, H, HSt, M, MSt, S, SSt]);
end;

end.
