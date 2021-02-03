unit MainFormU;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ToolWin,
  Vcl.ComCtrls,
  JsonDataObjects,
  System.Net.URLClient,
  Vcl.ExtCtrls,
  ReportsRPCProxy,
  Vcl.FileCtrl,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Vcl.Grids,
  Vcl.DBGrids,
  FireDAC.Phys.FBDef,
  FireDAC.Phys,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  PdfiumCtrl,
  Vcl.Imaging.pngimage, FireDAC.Stan.StorageBin, FireDAC.Stan.StorageJSON;

type
  TMainForm = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    btnReport1: TButton;
    Splitter1: TSplitter;
    Panel3: TPanel;
    ListBox1: TListBox;
    RzPageControl1: TPageControl;
    tsPDFViewer: TTabSheet;
    tsData: TTabSheet;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    btnReport2: TButton;
    Panel5: TPanel;
    btnNext: TButton;
    btnPrev: TButton;
    btnTableHTML: TButton;
    btnScale: TButton;
    btnPrint: TButton;
    PrintDialog1: TPrintDialog;
    ScrollBar1: TScrollBar;
    Panel6: TPanel;
    Image1: TImage;
    Label4: TLabel;
    dsCustomers: TFDMemTable;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    btnTable: TButton;
    btnHTMLCustomers: TButton;
    Panel7: TPanel;
    dsCustomersBig: TFDMemTable;
    btnBig: TButton;
    btnFilters: TButton;
    btnLast: TButton;
    btnFirst: TButton;
    btnInvoces: TButton;
    btnOffLineInvoce: TButton;
    Panel8: TPanel;
    lbxAsyncReports: TListBox;
    Button1: TButton;
    procedure btnReport1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox1DblClick(Sender: TObject);
    procedure btnReport2Click(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnTableHTMLClick(Sender: TObject);
    procedure btnScaleClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure btnTableClick(Sender: TObject);
    procedure btnHTMLCustomersClick(Sender: TObject);
    procedure btnBigClick(Sender: TObject);
    procedure btnFiltersClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnInvocesClick(Sender: TObject);
    procedure btnOffLineInvoceClick(Sender: TObject);
    procedure lbxAsyncReportsDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure lbxAsyncReportsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    fPDFViewer: TPdfControl;
    fProxy: TReportsRPCProxy;
    fToken: string;
    FRepNo: Integer;
    FQueueName: string;
    procedure UpdateGUI;
    procedure ResetFolder;
    function Folder(aFolder: string): string;
    function GetEndPoint: string;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
    function GetJSONData: TJDOJSONObject;
    function GetJSONDataMulti(const aDataSet: TDataSet): TJDOJSONObject;
    procedure GenerateReport(const aModelFileName: string; const aFormat: string;
      aJSONData: TJDOJSONObject; const aOutputFileName: string; genAsync: Boolean = false);

    procedure RefreshList;
  public
    { Public declarations }
  end;

const
  MODEL01 = 'reports\Report01.docx';
  MODEL02 = 'reports\Report02.docx';
  MODEL03 = 'reports\Report03.docx';
  MODEL04 = 'reports\Report04.docx';
  MODEL05 = 'reports\Report05.docx';
  MODEL06 = 'reports\Report06.docx';
  MODEL07 = 'reports\Report07.docx';
  MODEL08 = 'reports\Report08.docx';
  MODEL09 = 'reports\Report09.docx';

var
  MainForm: TMainForm;

const
  SERVERNAME = 'localhost';

implementation

uses
  LoggerPro.GlobalLogger,
  Winapi.ShellAPI,
  UnZipUtilsU,
  System.IOUtils,
  MVCFramework.Commons,
  MVCFramework.DataSet.Utils,
  sevenzip,
  Vcl.Printers,
  System.Threading,
  MVCFramework.JSONRPC,
  PdfiumCore,
  System.TypInfo,
  FontAwesomeU,
  FontAwesomeCodes, EventStreamsRPCProxy;

{$R *.dfm}


function TMainForm.Folder(aFolder: string): string;
begin
  Result := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), aFolder);
end;

procedure TMainForm.btnPrevClick(Sender: TObject);
begin
  fPDFViewer.GotoPrevPage(true);
  UpdateGUI;
end;

procedure TMainForm.btnPrintClick(Sender: TObject);
begin
  if PrintDialog1.Execute(Handle) then
  begin
    Printer.BeginDoc;
    try
      fPDFViewer.CurrentPage.Draw(Printer.Canvas.Handle, 0, 0, Printer.PageWidth,
        Printer.PageHeight, prNormal, [proAnnotations, proPrinting]);
    finally
      Printer.EndDoc;
    end;
  end;
end;

procedure TMainForm.btnReport1Click(Sender: TObject);
var
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_pdf.zip');
  GenerateReport(Folder(MODEL01), 'pdf', GetJSONData, lReportFileName);
  RefreshList;
end;

procedure TMainForm.btnReport2Click(Sender: TObject);
var
  lArchive: I7zInArchive;
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_pdf.zip');
  GenerateReport(Folder(MODEL02), 'pdf', GetJSONDataMulti(dsCustomers),
    lReportFileName);
  lArchive := CreateInArchive(CLSID_CFormatZip);
  lArchive.OpenFile(lReportFileName);
  TDirectory.CreateDirectory(Folder('output_pdf'));
  lArchive.ExtractTo(Folder('output_pdf'));
  RefreshList;
end;

procedure TMainForm.btnScaleClick(Sender: TObject);
begin
  if fPDFViewer.ScaleMode = high(fPDFViewer.ScaleMode) then
    fPDFViewer.ScaleMode := low(fPDFViewer.ScaleMode)
  else
    fPDFViewer.ScaleMode := Succ(fPDFViewer.ScaleMode);
  UpdateGUI;
end;

procedure TMainForm.btnTableClick(Sender: TObject);
var
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_pdf.zip');
  GenerateReport(Folder(MODEL03), 'pdf', GetJSONDataMulti(dsCustomers), lReportFileName);
  RefreshList;
end;

procedure TMainForm.btnTableHTMLClick(Sender: TObject);
var
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_html.zip');
  GenerateReport(Folder(MODEL04), 'html', GetJSONDataMulti(dsCustomers), lReportFileName);
  ShellExecute(0, PChar('open'), PChar(Folder('output_html\0.html')), nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  lJTemplateData: TJDOJSONObject;
  lJResp: TJsonObject;
  lArchive: I7zInArchive;
  lModelFileName: string;
begin
  FQueueName:= '';
  lModelFileName := Folder(MODEL02);
  lJTemplateData := TJDOJSONObject.Create;
  lJTemplateData.S['template_data'] := FileToBase64String(lModelFileName);

  lJResp := fProxy.GenerateMultipleReportAsync(fToken,

    TPath.GetFileNameWithoutExtension(lModelFileName) + '_' +
    FRepNo.ToString.PadLeft(2, '0'), lJTemplateData,
    GetJSONDataMulti(dsCustomers), 'pdf');
  try
    if not lJResp.IsNull('error') then
    begin
      raise Exception.Create(lJResp.O['error'].S['message']);
    end;
    FQueueName:= lJResp.s['queuename'];
   FRepNo:= FRepNo+1;
  finally
    lJResp.Free;
  end;

end;

procedure TMainForm.btnBigClick(Sender: TObject);
var
  lArchive: I7zInArchive;
  lReportFileName: string;
  I: Integer;
begin
  ResetFolder;
  lReportFileName := Folder('output_pdf.zip');

  dsCustomers.DisableControls;
  try
    dsCustomersBig.EmptyDataSet;
    for I := 1 to 100 do
    begin
      dsCustomers.First;
      dsCustomersBig.AppendData(dsCustomers.Data);
    end;
  finally
    dsCustomers.EnableControls;
  end;

  GenerateReport(Folder(MODEL07), 'pdf', GetJSONDataMulti(dsCustomersBig), lReportFileName);
  lArchive := CreateInArchive(CLSID_CFormatZip);
  lArchive.OpenFile(lReportFileName);
  TDirectory.CreateDirectory(Folder('output_pdf'));
  lArchive.ExtractTo(Folder('output_pdf'));
  RefreshList;
end;

procedure TMainForm.btnFiltersClick(Sender: TObject);
var
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_pdf.zip');
  GenerateReport(Folder(MODEL06), 'pdf', GetJSONDataMulti(dsCustomers), lReportFileName);
  RefreshList;
end;

procedure TMainForm.btnFirstClick(Sender: TObject);
begin
  fPDFViewer.PageIndex := 0;
  UpdateGUI;
end;

procedure TMainForm.btnHTMLCustomersClick(Sender: TObject);
var
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_html.zip');
  GenerateReport(Folder(MODEL05), 'html', GetJSONDataMulti(dsCustomers), lReportFileName);
  ShellExecute(0, PChar('open'), PChar(Folder('output_html\0.html')), nil, nil, SW_SHOWMAXIMIZED);
end;

procedure TMainForm.btnInvocesClick(Sender: TObject);
var
  lJSON: TJsonObject;
  I: Integer;
  lReportFileName: string;
  lCustomerList: TJsonArray;
  lInvoceRows: TJsonArray;
begin
  ResetFolder;
  lReportFileName := Folder('output_pdf.zip');
  lJSON := GetJSONDataMulti(dsCustomers);
  lCustomerList := lJSON.A['items'].Items[0].ArrayValue;

  for I := 0 to lCustomerList.Count - 1 do
  begin
    lInvoceRows := lCustomerList.Items[I].ObjectValue.A['rows'];
    if Random(10) > 3 then
      lInvoceRows.Add
        (TJsonObject.Parse(Format('{"product":"Pizza Margherita","price":10.00,"quantity":%d}',
        [1 + Random(10)])) as TJsonObject);
    if Random(10) > 3 then
      lInvoceRows.Add
        (TJsonObject.Parse(Format('{"product":"Spaghetti Carbonara","price":12.00,"quantity":%d}',
        [1 + Random(10)])) as TJsonObject);
    if Random(10) > 3 then
      lInvoceRows.Add
        (TJsonObject.Parse(Format('{"product":"Bucatini Amatriciana","price":11.00,"quantity":%d}',
        [1 + Random(4)])) as TJsonObject);
    if Random(10) > 3 then
      lInvoceRows.Add(TJsonObject.Parse(Format('{"product":"Tiramisù","price":5.00,"quantity":%d}',
        [1 + Random(4)])) as TJsonObject);
  end;
  GenerateReport(Folder(MODEL08), 'pdf', lJSON, lReportFileName);
  RefreshList;
end;

procedure TMainForm.btnLastClick(Sender: TObject);
begin
  fPDFViewer.PageIndex := fPDFViewer.PageCount - 1;
  UpdateGUI;
end;

procedure TMainForm.btnNextClick(Sender: TObject);
begin
  fPDFViewer.GotoNextPage(true);
  UpdateGUI;
end;

procedure TMainForm.btnOffLineInvoceClick(Sender: TObject);
var
  lJSON: TJDOJSONObject;
  lReportFileName: string;
  lMemDataSet: TFDMemTable;
begin
  ResetFolder;
  lReportFileName := Folder('output_pdf.zip');
  lMemDataSet := TFDMemTable.Create(self);
  try
    lMemDataSet.LoadFromFile(Folder('invoice_offline_data.json'));
    lJSON := TJDOJSONObject.Create;
    lJSON.O['meta'].S['title'] := 'Offline Invoices';
    lJSON.A['items'].Add(lMemDataSet.AsJDOJSONArray());
    GenerateReport(Folder(MODEL09), 'pdf', lJSON, lReportFileName);
    RefreshList;
  finally
    lMemDataSet.Free;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    ResetFolder;
  except
    // do nothing
  end;
  fPDFViewer.Free;
  fProxy.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  lJSON: TJsonObject;
begin
  dsCustomers.LoadFromFile(TPath.Combine(TPath.GetDirectoryName(ParamStr(0)),
    'customers.json'), sfJSON);
  InstallFont(self);
  PDFiumDllDir := TPath.GetDirectoryName(ParamStr(0));
  fPDFViewer := TPdfControl.Create(self);
  fPDFViewer.Align := alClient;
  fPDFViewer.Parent := Panel4;
  fPDFViewer.SendToBack; // put the control behind the buttons
  fPDFViewer.Color := clGray;
  fPDFViewer.ScaleMode := smFitWidth;
  fPDFViewer.PageColor := RGB(255, 255, 200);
  UpdateGUI;
  ResetFolder;

  fProxy := TReportsRPCProxy.Create(GetEndPoint);
  fProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
  fProxy.RPCExecutor.SetOnReceiveResponse(
    procedure(ARequest, aResponse: IJSONRPCObject)
    begin
      Log.Debug('REQUEST: ' + sLineBreak + ARequest.ToString(false), 'trace');
    end);
  lJSON := fProxy.Login('user_admin', 'pwd1');
  try
    fToken := lJSON.S['token'];
  finally
    lJSON.Free;
  end;
  RefreshList;
  btnFirst.Caption := fa_arrow_left;
  btnLast.Caption := fa_arrow_right;
  btnPrev.Caption := fa_arrow_circle_left;
  btnNext.Caption := fa_arrow_circle_right;
  btnTable.Caption := fa_table + ' ' + btnTable.Caption;
  btnPrint.Caption := fa_print;
  btnReport1.Caption := fa_files_o + ' ' + btnReport1.Caption;
  btnReport2.Caption := fa_file + ' ' + btnReport2.Caption;
  btnTableHTML.Caption := fa_table + ' ' + btnTableHTML.Caption;
  btnHTMLCustomers.Caption := fa_html5 + ' ' + btnHTMLCustomers.Caption;

  TThread.CreateAnonymousThread(
    procedure
    var
      lJObj: TJsonObject;
      lLastMgsID: string;
      I: Integer;
      lProxy: TEventStreamsRPCProxy;

    begin

      lProxy := TEventStreamsRPCProxy.Create('https://' + SERVERNAME + '/eventstreamsrpc');
      try
        lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
        lProxy.RPCExecutor.SetOnReceiveResponse(
          procedure(ARequest, aResponse: IJSONRPCObject)
          begin
            Log.Debug('REQUEST: ' + sLineBreak + ARequest.ToString(false), 'trace');
          end);

        lLastMgsID := '__first__';
        while true do
        begin
          if not FQueueName.IsEmpty then
          begin
            try
              lJObj := lProxy.
                DequeueMultipleMessage(fToken, FQueueName, lLastMgsID, 1, 10);
              try
                if lJObj.A['data'].Count > 0 then
                begin
                  if lJObj.A['data'].O[0].O['message'].S['state'] = 'CREATED' then
                  begin
                    if lJObj.A['data'].O[0].O['message'].S['queuename'] = FQueueName then
                    begin

                      TThread.Synchronize(nil,
                        procedure
                        begin

                          lbxAsyncReports.Items.AddPair(
                            lJObj.A['data'].O[0].O['message'].S['reportname'],
                            lJObj.A['data'].O[0].O['message'].S['reportid']
                            );
                        end);
                    end;
                  end;
                  lLastMgsID := lJObj.A['data'].O[0].S['messageid'];
                end;

                // end;
              finally
                lJObj.Free;
              end;
            except
              on E: Exception do
              begin

                Sleep(1000);
              end;
            end;
          end;
          Sleep(500);
        end;
      finally
        lProxy.Free;
      end;
    end).Start;

end;

procedure TMainForm.GenerateReport(const aModelFileName: string; const aFormat: string;
aJSONData: TJDOJSONObject; const aOutputFileName: string; genAsync: Boolean);
var
  lJTemplateData: TJDOJSONObject;
  lJResp: TJsonObject;
  lArchive: I7zInArchive;
begin
  lJTemplateData := TJDOJSONObject.Create;
  lJTemplateData.S['template_data'] := FileToBase64String(aModelFileName);
  if genAsync then
  begin

    lJResp := fProxy.GenerateMultipleReportAsync(fToken,

      TPath.GetFileNameWithoutExtension(aModelFileName) + '_' +
      FRepNo.ToString.PadLeft(2, '0'), lJTemplateData, aJSONData, aFormat);
  end
  else
    lJResp := fProxy.GenerateMultipleReport(fToken, lJTemplateData, aJSONData, aFormat);
  try
    if not lJResp.IsNull('error') then
    begin
      raise Exception.Create(lJResp.O['error'].S['message']);
    end;
    if not genAsync then
      Base64StringToFile(lJResp.S['zipfile'], aOutputFileName);
  finally
    lJResp.Free;
  end;
  // unzip the file
  if not genAsync then
  begin
    lArchive := CreateInArchive(CLSID_CFormatZip);
    lArchive.OpenFile(aOutputFileName);
    TDirectory.CreateDirectory(Folder('output_' + aFormat));
    lArchive.ExtractTo(Folder('output_' + aFormat));
  end;
  FRepNo := FRepNo + 1;
end;

function TMainForm.GetEndPoint: string;
begin
  Result := 'https://' + SERVERNAME + '/reportsrpc';
end;

function TMainForm.GetJSONData: TJDOJSONObject;
begin
  dsCustomers.First;
  Result := TJDOJSONObject.Create;
  try
    Result.O['meta'].S['title'] := 'Customer List';
    dsCustomers.First;
    Result.A['items'] := dsCustomers.AsJDOJSONArray;
  except
    Result.Free;
    raise;
  end;
end;

function TMainForm.GetJSONDataMulti(const aDataSet: TDataSet): TJDOJSONObject;
begin
  Result := TJDOJSONObject.Create;
  try
    Result.O['meta'].S['title'] := 'Customer List n.' + FRepNo.ToString.PadLeft(2, ' ');
    aDataSet.First;
    Result.A['items'].Add(aDataSet.AsJDOJSONArray);
  except
    Result.Free;
    raise;
  end;
end;

procedure TMainForm.lbxAsyncReportsDblClick(Sender: TObject);
begin
  var
  idx := lbxAsyncReports.ItemIndex;
  if idx >= 0 then
  begin
    ResetFolder;
    var
    lReportFileName := Folder('output_pdf.zip');
    var
    lJResp := fProxy.GetAsyncReport(fToken, lbxAsyncReports.Items.ValueFromIndex[idx]);
    try
      if lJResp.IsNull('error') then
      begin
        Base64StringToFile(lJResp.S['zipfile'], lReportFileName);
        var
        lArchive := CreateInArchive(CLSID_CFormatZip);
        lArchive.OpenFile(lReportFileName);
        TDirectory.CreateDirectory(Folder('output_pdf'));
        lArchive.ExtractTo(Folder('output_pdf'));
        RefreshList;
      end;
    finally
      lJResp.Free;
    end;

  end;
end;

procedure TMainForm.lbxAsyncReportsDrawItem(Control: TWinControl;
Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin

  lbxAsyncReports.Canvas.TextOut(Rect.Left, Rect.Top, lbxAsyncReports.Items.Names[index]);

end;

procedure TMainForm.ListBox1DblClick(Sender: TObject);
begin
  fPDFViewer.LoadFromFile(TPath.Combine(Folder('output_pdf'), ListBox1.Items[ListBox1.ItemIndex]),
    '', dloNormal);
  fPDFViewer.ZoomPercentage := 100;
  UpdateGUI;
  RzPageControl1.ActivePage := tsPDFViewer;
end;

procedure TMainForm.OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
const Certificate: TCertificate; var Accepted: Boolean);
begin
  Accepted := true;
end;

procedure TMainForm.RefreshList;
var
  lFiles: TArray<string>;
  lFile: string;
begin
  ListBox1.Items.Clear;
  lFiles := TDirectory.GetFiles(Folder('output_pdf'), '*.pdf');
  for lFile in lFiles do
  begin
    ListBox1.Items.Add(TPath.GetFileName(lFile));
  end;
  if ListBox1.Items.Count > 0 then
  begin
    ListBox1.ItemIndex := 0;
    ListBox1DblClick(ListBox1);
  end;
end;

procedure TMainForm.ResetFolder;
var
  lFiles: TArray<string>;
  lFile: string;
begin
  fPDFViewer.Close;
  TDirectory.CreateDirectory(Folder('output_pdf'));
  lFiles := TDirectory.GetFiles(Folder('output_pdf'), '*.pdf');
  for lFile in lFiles do
  begin
    DeleteFile(lFile);
  end;
end;

procedure TMainForm.ScrollBar1Change(Sender: TObject);
begin
  fPDFViewer.ZoomPercentage := ScrollBar1.Position;
  UpdateGUI;
end;

procedure TMainForm.UpdateGUI;
begin
  ScrollBar1.Position := fPDFViewer.ZoomPercentage;
  btnScale.Caption := 'Scale ' + GetEnumName(TypeInfo(TPdfControlScaleMode),
    Ord(fPDFViewer.ScaleMode));
  btnPrev.Enabled := fPDFViewer.PageIndex > 0;
  btnNext.Enabled := fPDFViewer.PageIndex < (fPDFViewer.PageCount - 1);
  btnLast.Enabled := (fPDFViewer.PageCount > 0) and
    (fPDFViewer.PageIndex <> (fPDFViewer.PageCount - 1));
  btnFirst.Enabled := fPDFViewer.PageIndex <> 0;
  StatusBar1.Panels[0].Text := Format('Page %d of %d',
    [fPDFViewer.PageIndex + 1, fPDFViewer.PageCount]);
end;

end.
