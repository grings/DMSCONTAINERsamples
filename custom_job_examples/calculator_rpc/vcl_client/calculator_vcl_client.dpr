program calculator_vcl_client;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {Form3},
  CalculatorRPCProxy in 'CalculatorRPCProxy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
