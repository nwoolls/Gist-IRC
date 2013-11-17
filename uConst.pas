unit uConst;

interface

const
  DefaultTheme = 'mirc';

  //settings
  IdentificationSection = 'Identification';
  NickNameIdent = 'Nickname';
  AltNickIdent = 'AltNick';
  RealNameIdent = 'RealName';
  UserNameIdent = 'UserName';

  AppearanceSection = 'Appearance';
  ConnectionsSection = 'Connections';
  ThemeIdent = 'Theme';

function SettingsFilePath: string;

implementation

uses SHFolder, Windows, SysUtils;

function GetSpecialFolderPath(const AFolderID: Integer) : string;
const
 SHGFP_TYPE_CURRENT = 0;
var
 Path: array [0..MAX_PATH] of Char;
begin
 if SUCCEEDED(SHGetFolderPath(0, AFolderID, 0, SHGFP_TYPE_CURRENT, @Path[0])) then
   Result := Path
 else
   Result := '';
end;

function SettingsFilePath: string;
begin
  Result := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA) + '\Gist\settings.ini';
  if not DirectoryExists(ExtractFilePath(Result)) then
    ForceDirectories(ExtractFilePath(Result));
end;

end.
