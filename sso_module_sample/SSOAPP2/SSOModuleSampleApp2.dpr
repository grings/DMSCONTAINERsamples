program SSOModuleSampleApp2;



{$R *.dres}

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainFrm},
  AuthRPCProxy in '..\AuthRPCProxy.pas',
  AuthService in '..\AuthService.pas',
  LoginFormU in '..\LoginFormU.pas' {LoginForm},
  FontAwesomeCodes in '..\..\commons\FontAwesomeCodes.pas',
  FontAwesomeU in '..\..\commons\FontAwesomeU.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
