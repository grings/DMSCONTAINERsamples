program EventStreamsMonitor;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  UtilsU in '..\..\commons\UtilsU.pas',
  EventStreamsRPCProxy in '..\..\commons\EventStreamsRPCProxy.pas',
  ConsumerThreadU in 'ConsumerThreadU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
