unit uIRCRichEdit;

interface

uses RichEditURL, Graphics;

type

  TIRCRichEdit = class(TRichEditURL)
  private
    procedure DoSetIRCText(const AText: string; const AAppend: Boolean);
    procedure SetSelBgColor(const AColor: TColor);
    function GetIRCColor(const AColorIndex: Integer; const ADefault: TColor): TColor;
  public
    procedure AddIRCText(const AText: string);
    procedure SetIRCText(const AText: string);
  end;

const
  IndentDelim = #4;

implementation

uses SysUtils, fMain, uIRCColors, RichEdit;

{ TIRCRichEdit }

procedure TIRCRichEdit.AddIRCText(const AText: string);
begin
  DoSetIRCText(AText, True);
end;

procedure TIRCRichEdit.SetSelBgColor(const AColor: TColor);
var
  Format: CHARFORMAT2;
begin
  FillChar(Format, SizeOf(Format), 0);
  with Format do
  begin
    cbSize := SizeOf(Format);
    dwMask := CFM_BACKCOLOR;
    crBackColor := AColor;
    Perform(EM_SETCHARFORMAT, SCF_SELECTION, Longint(@Format));
  end;
end;

function TIRCRichEdit.GetIRCColor(const AColorIndex: Integer; const ADefault: TColor): TColor;
begin
  if (AColorIndex >= Low(IRCColors)) and (AColorIndex <= High(IRCColors)) then
    Result := IRCColors[AColorIndex]
  else
    Result := ADefault;
end;

procedure TIRCRichEdit.DoSetIRCText(const AText: string; const AAppend: Boolean);
var
  I: Integer;
  TotalText, SoFar, FgColor, BgColor: string;
  InColor, FgRead, BgRead, CommaFound: Boolean;
  procedure AddTextSoFar;
  begin
    if SoFar <> '' then
    begin
      SelText := SoFar;
      TotalText := TotalText + SoFar;
      SoFar := '';
    end;
  end;
  procedure SetupStartingColor;
  begin
    FgRead := True;
    BgRead := True;
    if FgColor <> '' then
      SelAttributes.Color := GetIRCColor(StrToInt(FgColor), Font.Color);
    if BgColor <> '' then
      SetSelBgColor(GetIRCColor(StrToInt(BgColor), Color));
    FgColor := '';
    BgColor := '';
  end;
begin
  TotalText := '';

  if not AAppend then
    Clear;  

  SelStart := Length(Text);

  SelAttributes.Style := [];
  SelAttributes.Color := Font.Color;
  SetSelBgColor(Color);

  if AAppend and (Text <> '') then
  begin
    SelText := #13#10;
  end;

  Paragraph.LeftIndent := Paragraph.FirstIndent;

  InColor := False;
  SoFar := '';
  FgColor := '';
  BgColor := '';
  FgRead := False;
  BgRead := False;
  CommaFound := False;

  for I := 1 to Length(AText) do
  begin
    if AText[I] = IndentDelim then
    begin
      Paragraph.LeftIndent := Trunc(MainForm.Canvas.TextWidth(TotalText + SoFar) * 0.76);
    end else if AText[I] = BoldChar then
    begin
      AddTextSoFar;
      if fsBold in SelAttributes.Style then
        SelAttributes.Style := SelAttributes.Style - [fsBold]
      else
        SelAttributes.Style := SelAttributes.Style + [fsBold];
    end else if AText[I] = ItalicChar then
    begin
      AddTextSoFar;
      if fsItalic in SelAttributes.Style then
        SelAttributes.Style := SelAttributes.Style - [fsItalic]
      else
        SelAttributes.Style := SelAttributes.Style + [fsItalic];
    end else if AText[I] = UnderlineChar then
    begin
      AddTextSoFar;
      if fsUnderline in SelAttributes.Style then
        SelAttributes.Style := SelAttributes.Style - [fsUnderline]
      else
        SelAttributes.Style := SelAttributes.Style + [fsUnderline];
    end else if AText[I] = ClearChar then
    begin
      AddTextSoFar;
      SelAttributes.Style := [];
      SelAttributes.Color := Font.Color;
      SetSelBgColor(Color);
    end else if AText[I] = ColorChar then
    begin
      AddTextSoFar;
      InColor := True;
      FgColor := '';
      BgColor := '';
      FgRead := False;
      BgRead := False;
      CommaFound := False;
    end else
    begin
      if InColor and (not FgRead or not BgRead) then
      begin
        if not FgRead then
        begin
          if AText[I] = ',' then
          begin
            FgRead := True;
            CommaFound := True;
          end else if StrToIntDef(AText[I], -1) = -1 then
          begin
            SetupStartingColor;
            SoFar := SoFar + AText[I];
          end else
          begin
            FgColor := FgColor + AText[I];
            FgRead := Length(FgColor) >= 2;
          end;
        end else
        begin
          if AText[I] = ',' then
          begin
            CommaFound := True;
          end else if StrToIntDef(AText[I], -1) = -1 then
          begin
            SetupStartingColor;
            SoFar := SoFar + AText[I];
          end else if CommaFound then
          begin
            BgColor := BgColor + AText[I];
            BgRead := Length(BgColor) >= 2;
            if BgRead then
              SetupStartingColor;
          end else
          begin
            SoFar := SoFar + AText[I];
          end;
        end;
      end else
      begin
        FgColor := '';
        BgColor := '';
        SoFar := SoFar + AText[I];
      end;
      if (Length(SoFar) > 0) and (SoFar[Length(SoFar)] = IndentDelim) then
        Delete(SoFar, Length(SoFar), 1);
    end;
  end;
    
  AddTextSoFar;

  SelAttributes.Style := [];
  SelAttributes.Color := Font.Color;
  SetSelBgColor(Color);
end;

procedure TIRCRichEdit.SetIRCText(const AText: string);
begin
  DoSetIRCText(AText, False);
end;

end.
