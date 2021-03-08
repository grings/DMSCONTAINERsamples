program calculator_vcl_client;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  CalculatorRPCProxy in 'CalculatorRPCProxy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
