unit fIdentificationOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fOptionsBase, StdCtrls;

type
  TIdentificationOptionsFrame = class(TOptionsBaseFrame)
    Label1: TLabel;
    NickEdit: TEdit;
    Label2: TLabel;
    AltNickEdit: TEdit;
    Label3: TLabel;
    RealNameEdit: TEdit;
    Label4: TLabel;
    UserNameEdit: TEdit;
  public            
    function Save: Boolean; override;
    procedure Load; override;
  end;

implementation

uses IniFiles, uConst;

{$R *.dfm}

{ TIdentificationOptionsFrame }

procedure TIdentificationOptionsFrame.Load;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    NickEdit.Text := IniFile.ReadString(IdentificationSection, NickNameIdent, '');
    AltNickEdit.Text := IniFile.ReadString(IdentificationSection, AltNickIdent, '');
    RealNameEdit.Text := IniFile.ReadString(IdentificationSection, RealNameIdent, '');
    UserNameEdit.Text := IniFile.ReadString(IdentificationSection, UserNameIdent, '');
  finally
    IniFile.Free;
  end;
end;

function TIdentificationOptionsFrame.Save: Boolean;    
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(SettingsFilePath);
  try
    IniFile.WriteString(IdentificationSection, NickNameIdent, NickEdit.Text);
    IniFile.WriteString(IdentificationSection, AltNickIdent, AltNickEdit.Text);
    IniFile.WriteString(IdentificationSection, RealNameIdent, RealNameEdit.Text);
    IniFile.WriteString(IdentificationSection, UserNameIdent, UserNameEdit.Text);
  finally
    IniFile.Free;
  end;

  Result := True;
end;

end.

