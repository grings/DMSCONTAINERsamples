program SSOModuleSampleApp1;





{$R *.dres}

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainFrm},
  AuthService in '..\AuthService.pas',
  AuthRPCProxy in '..\AuthRPCProxy.pas',
  LoginFormU in '..\LoginFormU.pas' {LoginForm},
  FontAwesomeU in '..\..\commons\FontAwesomeU.pas',
  FontAwesomeCodes in '..\..\commons\FontAwesomeCodes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
