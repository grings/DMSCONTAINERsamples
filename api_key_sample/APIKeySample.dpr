program APIKeySample;



{$R *.dres}

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  ExcelRPCProxy in '..\commons\ExcelRPCProxy.pas',
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
