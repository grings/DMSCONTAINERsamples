program LogsProducerSample;

uses
  Vcl.Forms,
  EventStreamsRPCProxy in '..\..\commons\EventStreamsRPCProxy.pas',
  LoggerPro.DMSEventStreamsAppender in '..\..\commons\LoggerPro.DMSEventStreamsAppender.pas',
  LoggerProConfig in 'LoggerProConfig.pas',
  MainFormU in 'MainFormU.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
