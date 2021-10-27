// JCL_DEBUG_EXPERT_INSERTJDBG OFF
program pessimistic_locking;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  SynchUtilsRPCProxy in '..\commons\SynchUtilsRPCProxy.pas',
  LoginFormU in '..\commons\LoginFormU.pas' {LoginForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
