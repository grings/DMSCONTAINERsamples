program SSOModuleSampleApp1;





{$R *.dres}

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainFrm},
  AuthService in '..\AuthService.pas',
  LoginFormU in '..\..\commons\LoginFormU.pas' {LoginForm},
  FontAwesomeU in '..\..\commons\FontAwesomeU.pas',
  FontAwesomeCodes in '..\..\commons\FontAwesomeCodes.pas',
  AuthRPCProxy in '..\..\commons\AuthRPCProxy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
