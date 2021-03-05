program ReportModuleUsersToNotifySample;

uses
  Vcl.Forms,
  MainFRM in 'MainFRM.pas' {frmMain},
  EventStreamsRPCProxy in '..\commons\EventStreamsRPCProxy.pas',
  sevenzip in 'sevenzip.pas',
  PdfFrame in '..\commons\pdfFrame\PdfFrame.pas' {framePDF: TFrame},
  NotifyUsersFrm in 'NotifyUsersFrm.pas' {frmSelectUsers},
  AuthRPCProxy in '..\commons\AuthRPCProxy.pas',
  ReportsRPCProxy in '..\commons\ReportsRPCProxy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
