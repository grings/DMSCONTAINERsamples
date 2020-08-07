program EmailModuleTutorial;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  EmailRPCProxy in 'EmailRPCProxy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
