program APIKeySample;



uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  ExcelRPCProxy in 'ExcelRPCProxy.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Light');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
