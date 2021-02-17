program ReportModuleUsersToNotifySample;

uses
  Vcl.Forms,
  MainFRM in 'MainFRM.pas' {frmMain},
  EventStreamsRPCProxy in '..\commons\EventStreamsRPCProxy.pas',
  ReportsRPCProxy in 'ReportsRPCProxy.pas',
  sevenzip in 'sevenzip.pas',
  PdfFrame in '..\commons\pdfFrame\PdfFrame.pas' {framePDF: TFrame},
  AuthRPCProxy in 'AuthRPCProxy.pas',
  NotifyUsersFrm in 'NotifyUsersFrm.pas' {frmSelectUsers};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
