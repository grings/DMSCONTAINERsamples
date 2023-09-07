program ExcelModuleSample;



{$R *.dres}

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  ExcelRPCProxy in '..\commons\ExcelRPCProxy.pas',
  UtilsU in '..\commons\UtilsU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Light');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
