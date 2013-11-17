program Gist;

uses
  FastMM4,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  FastMove,
  FastCode,
  RtlVclOptimize,
  VCLFixPack,
  Forms,
  fMain in 'fMain.pas' {MainForm},
  dmConnection in 'dmConnection.pas' {ConnectionData: TDataModule},
  fInput in 'fInput.pas' {InputFrame: TFrame},
  uCommandHandler in 'uCommandHandler.pas',
  uServerCommandHandler in 'uServerCommandHandler.pas',
  uWhoisCommandHandler in 'uWhoisCommandHandler.pas',
  uJoinCommandHandler in 'uJoinCommandHandler.pas',
  uNamesCommandHandler in 'uNamesCommandHandler.pas',
  uPartCommandHandler in 'uPartCommandHandler.pas',
  RichEditURL in 'RichEditURL.pas',
  uCycleCommandHandler in 'uCycleCommandHandler.pas',
  uWhoisExCommandHandler in 'uWhoisExCommandHandler.pas',
  fChat in 'fChat.pas' {ChatFrame: TFrame},
  uNickNamesListParam in 'uNickNamesListParam.pas',
  IdIRC in 'IdIRC.pas',
  uCtcpCommandHandler in 'uCtcpCommandHandler.pas',
  uStringUtils in 'uStringUtils.pas',
  uDateUtils in 'uDateUtils.pas',
  uNickCommandHandler in 'uNickCommandHandler.pas',
  fChannels in 'fChannels.pas' {Channels},
  uQuoteCommandHandler in 'uQuoteCommandHandler.pas',
  uIRCRichEdit in 'uIRCRichEdit.pas',
  uMeCommandHandler in 'uMeCommandHandler.pas',
  uConst in 'uConst.pas',
  uQueryCommandHandler in 'uQueryCommandHandler.pas',
  uSayCommandHandler in 'uSayCommandHandler.pas',
  uCloseCommandHandler in 'uCloseCommandHandler.pas',
  fAbout in 'fAbout.pas' {AboutForm},
  fOptions in 'fOptions.pas' {OptionsForm},
  fOptionsBase in 'fOptionsBase.pas' {OptionsBaseFrame: TFrame},
  fIdentificationOptions in 'fIdentificationOptions.pas' {IdentificationOptionsFrame: TFrame},
  uDisconnectCommandHandler in 'uDisconnectCommandHandler.pas',
  uEditFuncs in 'uEditFuncs.pas',
  uTokenizer in 'uTokenizer.pas',
  uIRCColors in 'uIRCColors.pas',
  uNoticeCommandHandler in 'uNoticeCommandHandler.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Gist';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
