program event_streams_module_tutorial;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  EventStreamsRPCProxy in '..\commons\EventStreamsRPCProxy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
