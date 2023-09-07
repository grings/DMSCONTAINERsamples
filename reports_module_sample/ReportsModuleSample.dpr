program ReportsModuleSample;





{$R *.dres}

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  UnZipUtilsU in 'UnZipUtilsU.pas',
  sevenzip in 'sevenzip.pas',
  ReportsRPCProxy in '..\commons\ReportsRPCProxy.pas',
  Vcl.Themes,
  Vcl.Styles,
  PdfiumCore in 'lib\PdfiumCore.pas',
  PdfiumCtrl in 'lib\PdfiumCtrl.pas',
  PdfiumLib in 'lib\PdfiumLib.pas',
  EventStreamsRPCProxy in '..\commons\EventStreamsRPCProxy.pas',
  StoredReportNamesFormU in 'StoredReportNamesFormU.pas' {StoredReportNamesForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Light');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
