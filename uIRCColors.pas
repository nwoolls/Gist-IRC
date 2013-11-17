unit uIRCColors;

interface                                      

uses Graphics;

const
  ColorChar = '';
  BoldChar = '';
  ClearChar = '';
  ItalicChar = #$1D;
  UnderlineChar = #$1F;
  IrcColors: array[0..15] of TColor = (
    clWhite,
    clBlack,
    clNavy,
    clGreen,
    clRed,
    clMaroon,
    clPurple,
    clOlive,
    clYellow,
    clLime,
    clTeal,
    clAqua,
    clBlue,
    clFuchsia,
    clGray,
    clLtGray
  );

type
  TIRCTextStyle = record
    CharCode: Char;
    FontStyle: TFontStyle;
  end;

const
  IRCTextStyles: array[0..2] of TIRCTextStyle = (
    (CharCode: BoldChar; FontStyle: fsBold),   
    (CharCode: ItalicChar; FontStyle: fsItalic),
    (CharCode: UnderlineChar; FontStyle: fsUnderline)
  );

function StripBackgroundColors(const AText: string): string;   
function StripForegroundColors(const AText: string): string;  
function StripSpecialChars(const AText: string): string;

implementation 

uses SysUtils;

function StripSpecialChars(const AText: string): string;
var
  I: Integer;
begin
  Result := StringReplace(AText, ClearChar, '', [rfReplaceAll]);
  Result := StringReplace(Result, ColorChar, '', [rfReplaceAll]);
  for I := Low(IRCTextStyles) to High(IRCTextStyles) do
    Result := StringReplace(Result, IRCTextStyles[I].CharCode, '', [rfReplaceAll]);
end;

function StripBackgroundColors(const AText: string): string;
var
  I, J: Integer;
begin
  Result := AText;
  for I := High(IrcColors) downto Low(IrcColors) do
  begin
    for J := High(IrcColors) downto Low(IrcColors) do
    begin
      Result := StringReplace(Result, Format(ColorChar + '%s,%s', [Format('%.*d', [2, I]), Format('%.*d', [2, J])]), '', [rfReplaceAll]);
      Result := StringReplace(Result, Format(ColorChar + '%d,%d', [I, J]), '', [rfReplaceAll]);
    end;
  end;
end;

function StripForegroundColors(const AText: string): string;
var
  I: Integer;
begin
  Result := AText;
  for I := High(IrcColors) downto Low(IrcColors) do
  begin
    Result := StringReplace(Result, Format(ColorChar + '%s', [Format('%.*d', [2, I])]), '', [rfReplaceAll]);
    Result := StringReplace(Result, Format(ColorChar + '%d', [I]), '', [rfReplaceAll]);
  end;
end;

end.
