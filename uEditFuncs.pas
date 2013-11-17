unit uEditFuncs;

interface

uses Controls, Messages;

const
  EM_REDO = WM_USER + 84;
  EM_CANREDO = WM_USER + 85;
  EM_CANPASTE = WM_USER + 50;    
  EM_GETSELTEXT = WM_USER + 62;

function ControlWantsCut(const AControl: TWinControl): Boolean;
function ActiveControlWantsCut: Boolean;
function ControlWantsCopy(const AControl: TWinControl): Boolean;
function ActiveControlWantsCopy: Boolean;
function ControlWantsPaste(const AControl: TWinControl): Boolean;
function ActiveControlWantsPaste: Boolean;
function ControlWantsUndo(const AControl: TWinControl): Boolean;
function ActiveControlWantsUndo: Boolean;
function ControlWantsRedo(const AControl: TWinControl): Boolean;
function ActiveControlWantsRedo: Boolean;
function ControlWantsClear(const AControl: TWinControl): Boolean;
function ActiveControlWantsClear: Boolean;
function ControlWantsSelectAll(const AControl: TWinControl): Boolean;
function ActiveControlWantsSelectAll: Boolean;

procedure CutFromControl(const AControl: TWinControl);
procedure CutFromActiveControl;
procedure CopyFromControl(const AControl: TWinControl);
procedure CopyFromActiveControl;
procedure PasteIntoControl(const AControl: TWinControl);
procedure PasteIntoActiveControl;
procedure UndoInControl(const AControl: TWinControl);
procedure UndoInActiveControl;
procedure RedoInControl(const AControl: TWinControl);
procedure RedoInActiveControl;
procedure ClearInControl(const AControl: TWinControl);
procedure ClearInActiveControl;
procedure SelectAllInControl(const AControl: TWinControl);
procedure SelectAllInActiveControl;

function ControlHasSelection(const AControl: TWinControl): Boolean;
function ControlIsReadOnly(const AControl: TWinControl): Boolean;

function GetControlText(const AControl: TWinControl): string;
function GetActiveControlText: string;
function GetControlSelText(const AControl: TWinControl): string;
function GetControlTextLength(const AControl: TWinControl): Integer; 
function GetControlSelStart(const AControl: TWinControl): Integer;    
function GetControlSelLength(const AControl: TWinControl): Integer;

implementation

uses Windows, Clipbrd, StdCtrls, Forms, SysUtils, ComCtrls, Classes;

function GetControlTextLength(const AControl: TWinControl): Integer;
begin
  Result := AControl.Perform(WM_GETTEXTLENGTH, 0, 0);
end;

function GetControlTextBuf(const AControl: TWinControl; Buffer: PChar; BufSize: Integer): Integer;
begin
  Result := AControl.Perform(WM_GETTEXT, BufSize, Longint(Buffer));
end;

function GetControlLineLimit(const AControl: TWinControl): Integer;
begin
  Result := AControl.Perform(EM_GETLIMITTEXT, 0, 0);
end;

function GetControlText(const AControl: TWinControl): string;
var
  Len: Integer;
begin
  Len := GetControlTextLength(AControl);
  SetString(Result, PChar(nil), Len);
  if Len <> 0 then GetControlTextBuf(AControl, Pointer(Result), Len + 1);
end;

function GetActiveControlText: string;
begin
  Result := '';
  if Assigned(Screen.ActiveControl) then
    Result := GetControlText(Screen.ActiveControl);
end;

function SelectionIsValid(const ASelection: TSelection): Boolean;
begin
  Result := (ASelection.StartPos <= ASelection.EndPos) and
    (ASelection.StartPos > 0) and (ASelection.EndPos > 0) and
    (ASelection.StartPos < 65535) and (ASelection.EndPos < 65535);
end;

function GetControlSelStart(const AControl: TWinControl): Integer;
var
  Selection: TSelection;
begin
  SendMessage(AControl.Handle, EM_GETSEL, Longint(@Selection.StartPos), Longint(@Selection.EndPos));
  if SelectionIsValid(Selection) then
    Result := Selection.StartPos
  else
    Result := -1;
end;

function GetControlSelLength(const AControl: TWinControl): Integer;
var
  Selection: TSelection;
begin
  SendMessage(AControl.Handle, EM_GETSEL, Longint(@Selection.StartPos), Longint(@Selection.EndPos));
  if SelectionIsValid(Selection) then
    Result := Selection.EndPos - Selection.StartPos
  else
    Result := -1;
end;

function GetControlSelText(const AControl: TWinControl): string;
var
  P: PChar;
  SelStart, Len: Integer;
begin
  Result := '';
  SelStart := GetControlSelStart(AControl);
  Len := GetControlSelLength(AControl);
  if Len > 0 then
  begin
    SetString(Result, PChar(nil), Len);
    P := StrAlloc(GetControlTextLength(AControl) + 1);
    try
      GetControlTextBuf(AControl, P, StrBufSize(P));
      Move(P[SelStart], Pointer(Result)^, Len);
    finally
      StrDispose(P);
    end;
  end;
end;

function ActiveControlWantsSelectAll: Boolean;
begin
  Result := Assigned(Screen.ActiveControl) and
    ControlWantsSelectAll(Screen.ActiveControl);
end;

function ControlIsAnEdit(const AControl: TWinControl): Boolean;
begin
  Result := (GetControlLineLimit(AControl) > 0) or (AControl is TCustomEdit);
end;
                                      
function ControlWantsSelectAll(const AControl: TWinControl): Boolean;
var
  S: string;
begin
  Result := False;
  
  if not ControlIsAnEdit(AControl) then
    Result := False
  else
  begin  
    try
      S := GetControlText(AControl);
      Result := (S <> '') and (S <> GetControlSelText(AControl));
    except
      on E:EInvalidOperation do
      begin
        //Control '' has no parent window. -- random bug with the DX Ribbon and parented controls
      end;
    end;
  end;
end;

type
  TWinControlAccess = class(TWinControl);

function ControlIsReadOnly(const AControl: TWinControl): Boolean;
var
  Styles: LongInt;
begin
  Result := False;

  try
    Styles := GetWindowLong(AControl.Handle, GWL_STYLE);
    if Styles > 0 then
      Result := (Styles or ES_ReadOnly) = Styles;
  except
    on E:EInvalidOperation do
    begin
      //Control '' has no parent window. -- random bug with the DX Ribbon and parented controls
    end;
  end;
end;

function ActiveControlWantsCut: Boolean;
begin
  Result := Assigned(Screen.ActiveControl) and
    ControlWantsCut(Screen.ActiveControl);
end;

function ControlWantsCut(const AControl: TWinControl): Boolean;
begin
  Result := ControlHasSelection(AControl) and not ControlIsReadOnly(AControl);
end;     

function ActiveControlWantsCopy: Boolean;
begin
  Result := Assigned(Screen.ActiveControl) and
    ControlWantsCopy(Screen.ActiveControl);
end;

function ControlWantsCopy(const AControl: TWinControl): Boolean;
begin
  Result := ControlHasSelection(AControl);
end;               

function ActiveControlWantsPaste: Boolean;
begin
  Result := Assigned(Screen.ActiveControl) and ControlWantsPaste(Screen.ActiveControl);
end;       

function ControlWantsPaste(const AControl: TWinControl): Boolean;
begin       
  try
    Result := Clipboard.HasFormat(CF_TEXT) and not ControlIsReadOnly(AControl)
      and (ControlIsAnEdit(AControl) or ((AControl is TCustomRichEdit) and
      (SendMessage(AControl.Handle, EM_CANPASTE, 0, 0) > 0)));
  except
    on E:EInvalidOperation do
    begin
      //Control '' has no parent window. -- random bug with the DX Ribbon and parented controls
      Result := False;
    end;
  end;
end;            

function ActiveControlWantsUndo: Boolean;
begin
  Result := Assigned(Screen.ActiveControl) and ControlWantsUndo(Screen.ActiveControl);
end;

function ControlWantsUndo(const AControl: TWinControl): Boolean;
begin
  try
    Result := not ControlIsReadOnly(AControl) and (SendMessage(AControl.Handle, EM_CANUNDO, 0, 0) > 0);
  except
    on E:EInvalidOperation do
    begin
      //Control '' has no parent window. -- random bug with the DX Ribbon and parented controls
      Result := False;
    end;
  end;
end;

function ActiveControlWantsRedo: Boolean;
begin
  Result := Assigned(Screen.ActiveControl) and ControlWantsRedo(Screen.ActiveControl);
end;

function ControlWantsRedo(const AControl: TWinControl): Boolean;
begin       
  try
    Result := not ControlIsReadOnly(AControl) and (SendMessage(AControl.Handle, EM_CANREDO, 0, 0) > 0);
  except
    on E:EInvalidOperation do
    begin
      //Control '' has no parent window. -- random bug with the DX Ribbon and parented controls
      Result := False;
    end;
  end;
end;

function ActiveControlWantsClear: Boolean;
begin
  Result := Assigned(Screen.ActiveControl) and ControlWantsClear(Screen.ActiveControl);
end;

function ControlWantsClear(const AControl: TWinControl): Boolean;
begin
  Result := ControlHasSelection(AControl) and not ControlIsReadOnly(AControl);
end;

procedure CutFromActiveControl;
begin
  if Assigned(Screen.ActiveControl) then
    CutFromControl(Screen.ActiveControl);
end;

procedure CutFromControl(const AControl: TWinControl);
begin
  SendMessage(AControl.Handle, WM_CUT, 0, 0);
end;      

procedure CopyFromActiveControl;
begin
  if Assigned(Screen.ActiveControl) then
    CopyFromControl(Screen.ActiveControl);
end;

procedure CopyFromControl(const AControl: TWinControl);
begin
  SendMessage(AControl.Handle, WM_COPY, 0, 0);
end;    

procedure PasteIntoActiveControl;
begin
  if Assigned(Screen.ActiveControl) then
    PasteIntoControl(Screen.ActiveControl);
end;

procedure PasteIntoControl(const AControl: TWinControl);
begin
  SendMessage(AControl.Handle, WM_PASTE, 0, 0);
end;

procedure UndoInActiveControl;
begin
  if Assigned(Screen.ActiveControl) then
    UndoInControl(Screen.ActiveControl);
end;

procedure UndoInControl(const AControl: TWinControl);
begin
  SendMessage(AControl.Handle, WM_UNDO, 0, 0);
end;

procedure RedoInActiveControl;
begin
  if Assigned(Screen.ActiveControl) then
    RedoInControl(Screen.ActiveControl);
end;

procedure RedoInControl(const AControl: TWinControl);
begin
  SendMessage(AControl.Handle, EM_REDO, 0, 0);
end;

procedure ClearInActiveControl;
begin
  if Assigned(Screen.ActiveControl) then
    ClearInControl(Screen.ActiveControl);
end;

procedure ClearInControl(const AControl: TWinControl);
begin
  SendMessage(AControl.Handle, WM_CLEAR, 0, 0);
end;

procedure SelectAllInActiveControl;
begin
  if Assigned(Screen.ActiveControl) then
    SelectAllInControl(Screen.ActiveControl);
end;

procedure SelectAllInControl(const AControl: TWinControl);
begin
  SendMessage(AControl.Handle, EM_SETSEL, 0, -1);
end;

function ControlHasSelection(const AControl: TWinControl): Boolean;
var
  Selection: TSelection;
begin
  Result := False;

  if AControl <> nil then
  begin
    try
      if AControl is TCustomCombo then
        Result := TCustomCombo(AControl).SelLength > 0
      else if AControl is TCustomEdit then
        Result := TCustomEdit(AControl).SelLength > 0
      else
      begin
        if SendMessage(AControl.Handle, EM_GETSEL, Longint(@Selection.StartPos),
          Longint(@Selection.EndPos)) > 0 then
          Result := (Selection.EndPos - Selection.StartPos) > 0;
      end;
    except
      on E:EInvalidOperation do
      begin
        //Control '' has no parent window. -- random bug with the DX Ribbon and parented controls
      end;
    end;
  end;
end;

end.
