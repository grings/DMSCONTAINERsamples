program sso_configuration_provider_sample;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  AuthRPCProxy in '..\..\commons\AuthRPCProxy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
