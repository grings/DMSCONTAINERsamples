program synchutils_exclusive_lock_sample;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  SynchUtilsRPCProxy in '..\commons\SynchUtilsRPCProxy.pas',
  LoggerProConfig in '..\commons\LoggerProConfig.pas',
  LoginFormU in '..\commons\LoginFormU.pas' {LoginForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
