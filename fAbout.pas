unit fAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TAboutForm = class(TForm)
    Label1: TLabel;
    VersionLabel: TLabel;
    Label3: TLabel;
    Button1: TButton;
    UrlLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure UrlLabelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses ShellAPI;

{$R *.dfm}



function GetVersion(const ExePath: string; out Major, Minor, Release,
  Build: Word): Boolean;
var
  Info: PVSFixedFileInfo;
  InfoSize: Cardinal;
  nHwnd: DWORD;
  BufferSize: DWORD;
  Buffer: Pointer;
begin
  Major := 0;
  Minor := 0;
  Release := 0;
  Build := 0;
  BufferSize := GetFileVersionInfoSize(PChar(ExePath), nHWnd); {Get buffer size}
  Result := True;
  if BufferSize <> 0 then
  begin {if zero, there is no version info}
    GetMem(Buffer, BufferSize); {allocate buffer memory}
    try
      if GetFileVersionInfo(PChar(ExePath), nHWnd, BufferSize, Buffer) then
      begin
        {got version info}
        if VerQueryValue(Buffer, '\', Pointer(Info), InfoSize) then
        begin
          {got root block version information}
          Major := HiWord(Info^.dwFileVersionMS); {extract major version}
          Minor := LoWord(Info^.dwFileVersionMS); {extract minor version}
          Release := HiWord(Info^.dwFileVersionLS); {extract release version}
          Build := LoWord(Info^.dwFileVersionLS); {extract build version}
        end
        else
        begin
          Result := False; {no root block version info}
        end;
      end
      else
      begin
        Result := False; {couldn't extract version info}
      end;
    finally
      FreeMem(Buffer, BufferSize); {release buffer memory}
    end;
  end
  else
  begin
    Result := False; {no version info at all in the file}
  end;
end;

//returns -1 if ExePath1 is a lower version than ExePath2, 0 if they are of
//equal version, 1 if ExePath1 is a higher version than ExePath2

function CompareVersions(ExePath1, ExePath2: string): Integer;
var
  Major1, Major2, Minor1, Minor2, Release1, Release2, Build1, Build2: Word;
begin
  Result := 0;
  if FileExists(ExePath1) and FileExists(ExePath2) then
  begin
    if GetVersion(ExePath1, Major1, Minor1, Release1, Build1) then
    begin
      if GetVersion(ExePath2, Major2, Minor2, Release2, Build2) then
      begin
        if (Major1 > Major2) or
          ((Major1 = Major2) and (Minor1 > Minor2)) or
          ((Major1 = Major2) and (Minor1 = Minor2) and (Release1 > Release2)) or
          ((Major1 = Major2) and (Minor1 = Minor2) and (Release1 = Release2) and
          (Build1 > Build2)) then
          Result := 1
        else if (Major1 = Major2) and (Minor1 = Minor2) and
          (Release1 = Release2) and (Build1 = Build2) then
          Result := 0
        else
          Result := -1;
      end;
    end;
  end;
end;

function GetVersionString(const ExePath: string): string;
var
  Major, Minor, Release, Build: Word;
begin
  Result := '1.0.0 (Build 0)';
  if FileExists(ExePath) then
  begin
    if GetVersion(ExePath, Major, Minor, Release, Build) then
      Result := IntToStr(Major) + '.' + IntToStr(Minor) + '.' +
        IntToStr(Release) + ' (Build ' + IntToStr(Build) + ')';
  end;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  VersionLabel.Caption := GetVersionString(Application.ExeName);
end;

procedure TAboutForm.UrlLabelClick(Sender: TObject);
begin
  ShellExecute(Handle, 'OPEN', PChar(TLabel(Sender).Caption), nil, nil, SW_SHOWNORMAL);
end;

end.
