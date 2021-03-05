program SSOModuleSampleApp2;



{$R *.dres}

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainFrm},
  AuthService in '..\AuthService.pas',
  LoginFormU in '..\LoginFormU.pas' {LoginForm},
  FontAwesomeCodes in '..\..\commons\FontAwesomeCodes.pas',
  FontAwesomeU in '..\..\commons\FontAwesomeU.pas',
  AuthRPCProxy in '..\..\commons\AuthRPCProxy.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
