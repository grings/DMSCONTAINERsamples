program EmailModuleSample;



uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  ConstsU in 'ConstsU.pas',
  Vcl.Themes,
  Vcl.Styles,
  EmailRPCProxy in '..\commons\EmailRPCProxy.pas',
  UtilsU in '..\commons\UtilsU.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Light');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
