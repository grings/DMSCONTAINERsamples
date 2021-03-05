program EventStreamsChat;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  EmojiSupportU in 'EmojiSupportU.pas',
  EventStreamsRPCProxy in '..\commons\EventStreamsRPCProxy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
