program EventStreamsChat;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  EventStreamsRPCProxy in 'EventStreamsRPCProxy.pas',
  EmojiSupportU in 'EmojiSupportU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
