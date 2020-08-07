program raw_login;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  JsonDataObjects in '..\..\..\commons\JsonDataObjects.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
