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
    pnlDati: TPanel;
    pnlTool: TPanel;
    btnReport1: TButton;
    Splitter1: TSplitter;
    pnlGenReports: TPanel;
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
    btnTable2: TButton;
    btnScale: TButton;
    btnPrint: TButton;
    PrintDialog1: TPrintDialog;
    ScrollBar1: TScrollBar;
    Panel6: TPanel;
    Image1: TImage;
    Label4: TLabel;
    dsCustomers: TFDMemTable;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    btnTable1: TButton;
    btnCustomers: TButton;
    dsCustomersBig: TFDMemTable;
    btnBig: TButton;
    btnFilters: TButton;
    btnLast: TButton;
    btnFirst: TButton;
    btnInvoces: TButton;
    btnOffLineInvoce: TButton;
    pnlAsync: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lbxAsyncReportsToCreate: TListBox;
    TabSheet2: TTabSheet;
    lbxAsyReportsCreated: TListBox;
    TabSheet3: TTabSheet;
    lbxAsyncReportsDeleted: TListBox;
    TabSheet4: TTabSheet;
    lbxAll: TListBox;
    Splitter2: TSplitter;
    pnlCenter: TPanel;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    cbFormat: TComboBox;
    Label3: TLabel;
    btnInvoice: TButton;
    btnInvoice1: TButton;
    chkStoredReport: TCheckBox;
    btnShowStoredReports: TButton;
    procedure btnReport1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox1DblClick(Sender: TObject);
    procedure btnReport2Click(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnTable2Click(Sender: TObject);
    procedure btnScaleClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure btnTable1Click(Sender: TObject);
    procedure btnCustomersClick(Sender: TObject);
    procedure btnBigClick(Sender: TObject);
    procedure btnFiltersClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnInvocesClick(Sender: TObject);
    procedure btnOffLineInvoceClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure lbxAsyncReportsToCreateDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure lbxAsyReportsCreatedDblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbFormatChange(Sender: TObject);
    procedure btnInvoiceClick(Sender: TObject);
    procedure btnInvoice1Click(Sender: TObject);
    procedure btnShowStoredReportsClick(Sender: TObject);
  private
    fPDFViewer: TPdfControl;
    fProxy: IReportsRPCProxy;
    fToken: string;
    FQueueName: string;
    FAsyncReports: TStringList;
    FLastMgsID: string;
    FThrState: TThread;
    fOutputFormat: String;
    procedure UpdateGUI;
    procedure ResetFolder;
    function Folder(aFolder: string): string;
    function GetEndPoint: string;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
    function GetJSONData: TJDOJSONObject;
    function GetJSONDataMulti(const aDataSet: TDataSet): TJDOJSONObject;
    procedure GenerateReport(const aModelFileName: string; const aFormat: string;
      aJSONData: TJDOJSONObject; const aOutputFileName: string);

    procedure RefreshList(const LoadFirstDocument: Boolean = True);
    procedure LoadConf;
    procedure SaveConf;
    function GetQueueName: string;
    procedure SetQueueName(value: string);
    procedure SetOutputFormat(const Value: String);
    function GetOutputExt: String;
    property OutputFormat: String read fOutputFormat write SetOutputFormat;
    property OutputExt: String read GetOutputExt;
    function GetAsyncReportKey(const Data: string; Key: string): string;
    procedure AddReport(ReportName, Data: string);
    function StateToIcon(const State: string): string;
    procedure SetLastMgsID(const value: string);
    function GetLastMgsID: string;
    procedure BuildReportAsync();
    property QueueName: string read GetQueueName write SetQueueName;
    property LastMgsID: string read GetLastMgsID write SetLastMgsID;
    procedure SortList(lst: TSTrings);
    procedure RestartAsync(const LastMessage: string = '__first__');

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
  MODEL10 = 'reports\Invoice2.docx';
  MODEL11 = 'reports\Invoice1.docx';

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
  FontAwesomeCodes, EventStreamsRPCProxy, StoredReportNamesFormU;

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
  lReportFileName := Folder('output_' + OutputExt + '.zip');
  GenerateReport(Folder(MODEL01), OutputFormat, GetJSONData, lReportFileName);
  RefreshList;
end;

procedure TMainForm.btnReport2Click(Sender: TObject);
var
  lArchive: I7zInArchive;
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_' + OutputExt + '.zip');
  GenerateReport(Folder(MODEL02), OutputFormat, GetJSONDataMulti(dsCustomers),
    lReportFileName);
  lArchive := CreateInArchive(CLSID_CFormatZip);
  lArchive.OpenFile(lReportFileName);
  TDirectory.CreateDirectory(Folder('output_' + OutputExt));
  lArchive.ExtractTo(Folder('output_' + OutputExt));
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

procedure TMainForm.btnShowStoredReportsClick(Sender: TObject);
var
  lFrm: TStoredReportNamesForm;
begin
  lFrm := TStoredReportNamesForm.Create(self);
  try
    lFrm.Proxy := fProxy;
    lFrm.Token := fToken;
    lFrm.ShowModal;
  finally
    lFrm.Free;
  end;
end;

procedure TMainForm.btnTable1Click(Sender: TObject);
var
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_' + OutputExt + '.zip');
  GenerateReport(Folder(MODEL03), OutputFormat, GetJSONDataMulti(dsCustomers), lReportFileName);
  RefreshList;
end;

procedure TMainForm.btnTable2Click(Sender: TObject);
var
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_' + OutputExt + '.zip');
  GenerateReport(Folder(MODEL04), OutputFormat, GetJSONDataMulti(dsCustomers), lReportFileName);
  RefreshList;
end;

procedure TMainForm.BuildReportAsync;
begin
  TThread.CreateAnonymousThread(
    procedure
    var
      lJTemplateData: TJDOJSONObject;
      lJResp: TJsonObject;
      lModelFileName: string;
      lJData: TJsonObject;
      lRepName: string;
    begin
      System.TMonitor.Enter(Self);
      try

        lRepName := FormatDateTime('yyyy_mm_dd_hh_nn_ss_zzz', now);
        lModelFileName := Folder(MODEL02);

        lJTemplateData := TJDOJSONObject.Create;
        try
          lJTemplateData.S['template_data'] := FileToBase64String(lModelFileName);
        except
          lJTemplateData.Free;
          raise;

        end;
        TThread.Synchronize(nil,
          procedure
          begin
            lJData := GetJSONDataMulti(dsCustomers);
          end);
        lJData.O['meta'].S['title'] := 'Customer List ' + DateTimeToStr(now);
        lJResp := fProxy.GenerateMultipleReportAsync(fToken,
          TPath.GetFileNameWithoutExtension(lModelFileName) + '_' +
          lRepName, lJTemplateData,
          lJData, nil, 'pdf');
        try
          if not lJResp.IsNull('error') then
          begin
            raise Exception.Create(lJResp.O['error'].S['message']);
          end;
          QueueName := lJResp.S['queuename'];
        finally
          lJResp.Free;
        end;
      finally
        System.TMonitor.Exit(Self);
      end;
    end).Start;

end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  OutputFormat := 'pdf';
  BuildReportAsync;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  I: Integer;
begin
  OutputFormat := 'pdf';
  for I := 1 to 10 do
  begin
    BuildReportAsync;
  end;
end;

procedure TMainForm.cbFormatChange(Sender: TObject);
var
  lValue: string;
begin
  lValue := cbFormat.Items[cbFormat.ItemIndex];
  if not lValue.IsEmpty then
  begin
    OutputFormat := lValue.ToLower.Substring(0, lValue.IndexOf(' '));
  end;
end;

function SortDesc(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := -1 * CompareStr(List.Names[Index1], List.Names[Index2]);
end;

procedure TMainForm.SortList(lst: TSTrings);
begin

  with TStringList.Create do
  begin
    try
      Sorted := false;
      Text := lst.Text;
      CustomSort(SortDesc);
      lst.Text := Text;

    finally
      Free;
    end;
  end;

end;

procedure TMainForm.AddReport(ReportName, Data: string);

var
  lState: string;
begin
  System.TMonitor.Enter(FAsyncReports);
  try
    // lbxAsyncReports.Items.BeginUpdate;
    try
      // lbxAsyncReports.Items.BeginUpdate;
      FAsyncReports.Values[ReportName] := Data;
      // FAsyncReports.CustomSort(SortDesc);
      SortList(FAsyncReports);
      lbxAll.Items.Assign(FAsyncReports);

      lState := GetAsyncReportKey(Data, 'state');

      if lState = 'TO_CREATE' then
      begin
        lbxAsyncReportsToCreate.Items.Values[ReportName] := Data;
        SortList(lbxAsyncReportsToCreate.Items);
      end;
      if lState = 'CREATED' then
      begin
        lbxAsyncReportsToCreate.Items.Delete(
          lbxAsyncReportsToCreate.Items.IndexOfName(ReportName));
        lbxAsyReportsCreated.Items.BeginUpdate;
        lbxAsyReportsCreated.Items.Values[ReportName] := Data;
        SortList(lbxAsyReportsCreated.Items);
        lbxAsyReportsCreated.Items.EndUpdate;

      end;
      if lState = 'DELETED' then
      begin
        lbxAsyReportsCreated.Items.Delete(
          lbxAsyReportsCreated.Items.IndexOfName(ReportName));
        lbxAsyncReportsDeleted.Items.BeginUpdate;
        lbxAsyncReportsDeleted.Items.Values[ReportName] := Data;
        SortList(lbxAsyncReportsDeleted.Items);
        lbxAsyncReportsDeleted.Items.EndUpdate;

      end;

    finally
      // lbxAsyncReports.Items.EndUpdate;
    end;
  finally
    System.TMonitor.exit(FAsyncReports);
  end;

end;

procedure TMainForm.btnBigClick(Sender: TObject);
var
  lArchive: I7zInArchive;
  lReportFileName: string;
  I: Integer;
begin
  ResetFolder;
  lReportFileName := Folder('output_' + OutputExt + 'pdf.zip');

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

  GenerateReport(Folder(MODEL07), OutputFormat, GetJSONDataMulti(dsCustomersBig), lReportFileName);
  lArchive := CreateInArchive(CLSID_CFormatZip);
  lArchive.OpenFile(lReportFileName);
  TDirectory.CreateDirectory(Folder('output_' + OutputFormat));
  lArchive.ExtractTo(Folder('output_' + OutputFormat));
  RefreshList;
end;

procedure TMainForm.btnFiltersClick(Sender: TObject);
var
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_' + OutputExt + '.zip');
  GenerateReport(Folder(MODEL06), OutputFormat, GetJSONDataMulti(dsCustomers), lReportFileName);
  RefreshList;
end;

procedure TMainForm.btnFirstClick(Sender: TObject);
begin
  fPDFViewer.PageIndex := 0;
  UpdateGUI;
end;

procedure TMainForm.btnCustomersClick(Sender: TObject);
var
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_' + OutputExt + '.zip');
  GenerateReport(Folder(MODEL05), OutputFormat, GetJSONDataMulti(dsCustomers), lReportFileName);
  RefreshList;
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
  lReportFileName := Folder('output_' + OutputExt + '.zip');
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
  GenerateReport(Folder(MODEL08), OutputFormat, lJSON, lReportFileName);
  RefreshList;
end;

procedure TMainForm.btnInvoice1Click(Sender: TObject);
var
  lJSON: TJDOJSONObject;
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_' + OutputExt + '.zip');
  lJSON := TJDOJSONObject.ParseFromFile(Folder('invoice1.json')) as TJsonObject;
  GenerateReport(Folder(MODEL11), OutputFormat, lJSON, lReportFileName);
  RefreshList;
end;

procedure TMainForm.btnInvoiceClick(Sender: TObject);
var
  lJSON: TJDOJSONObject;
  lReportFileName: string;
begin
  ResetFolder;
  lReportFileName := Folder('output_' + OutputExt + '.zip');
  lJSON := TJDOJSONObject.ParseFromFile(Folder('invoice2.json')) as TJsonObject;
  GenerateReport(Folder(MODEL10), OutputFormat, lJSON, lReportFileName);
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
  lReportFileName := Folder('output_' + OutputExt + '.zip');
  lMemDataSet := TFDMemTable.Create(self);
  try
    lMemDataSet.LoadFromFile(Folder('invoice_offline_data.json'));
    lJSON := TJDOJSONObject.Create;
    lJSON.O['meta'].S['title'] := 'Offline Invoices';
    lJSON.A['items'].Add(lMemDataSet.AsJDOJSONArray());
    GenerateReport(Folder(MODEL09), OutputFormat, lJSON, lReportFileName);
    RefreshList;
  finally
    lMemDataSet.Free;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject;
var
  Action:
  TCloseAction);
begin
  try
    ResetFolder;
  except
    // do nothing
  end;
  fPDFViewer.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  lJSON: TJsonObject;
begin
  FAsyncReports := TStringList.Create;
  LoadConf;;
  dsCustomers.LoadFromFile(TPath.Combine(TPath.GetDirectoryName(ParamStr(0)),
    'customers.json'), sfJSON);
  InstallFont(self);
  PDFiumDllDir := TPath.GetDirectoryName(ParamStr(0));
  fPDFViewer := TPdfControl.Create(self);
  fPDFViewer.Align := alClient;
  fPDFViewer.Parent := Panel4;
  fPDFViewer.SendToBack; // put the control behind the buttons
  fPDFViewer.Color := clGray;
  fPDFViewer.ScaleMode := smZoom;
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
  cbFormat.ItemIndex := 0;
  cbFormatChange(cbFormat);
  RefreshList(false);
  btnFirst.Caption := fa_arrow_left;
  btnLast.Caption := fa_arrow_right;
  btnPrev.Caption := fa_arrow_circle_left;
  btnNext.Caption := fa_arrow_circle_right;
  btnTable1.Caption := fa_table + ' ' + btnTable1.Caption;
  btnPrint.Caption := fa_print;
  btnReport1.Caption := fa_files_o + ' ' + btnReport1.Caption;
  btnReport2.Caption := fa_file + ' ' + btnReport2.Caption;
  btnTable2.Caption := fa_table + ' ' + btnTable2.Caption;
  btnCustomers.Caption := fa_html5 + ' ' + btnCustomers.Caption;

  RestartAsync(LastMgsID);

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FThrState.Terminate;
  FAsyncReports.Free;
end;

procedure TMainForm.GenerateReport(const aModelFileName: string; const aFormat: string;
  aJSONData: TJDOJSONObject; const aOutputFileName: string);
var
  lJTemplateData: TJDOJSONObject;
  lJResp: TJsonObject;
  lArchive: I7zInArchive;
begin
  StatusBar1.Panels[1].Text := 'Using report template ' + TPath.GetFileName(aModelFileName);
  StatusBar1.Update;
  lJTemplateData := TJDOJSONObject.Create;
  lJTemplateData.S['template_data'] := FileToBase64String(aModelFileName);


  if chkStoredReport.Checked then
    lJResp := fProxy.GenerateMultipleReportByName(fToken, TPath.GetFileNameWithoutExtension(aModelFileName), aJSONData, aFormat)
  else
    lJResp := fProxy.GenerateMultipleReport(fToken, lJTemplateData, aJSONData, aFormat);
  try
    if not lJResp.IsNull('error') then
    begin
      raise Exception.Create(lJResp.O['error'].S['message']);
    end;
    Base64StringToFile(lJResp.S['zipfile'], aOutputFileName);
  finally
    lJResp.Free;
  end;
  // unzip the file
  lArchive := CreateInArchive(CLSID_CFormatZip);
  lArchive.OpenFile(aOutputFileName);
  TDirectory.CreateDirectory(Folder('output_' + OutputExt));
  lArchive.ExtractTo(Folder('output_' + OutputExt));
end;

function TMainForm.GetAsyncReportKey(const Data: string;
Key:
  string): string;
var
  outList, innerList: TStringList;
begin
  outList := TStringList.Create;
  try
    outList.Text := Data;
    if Key = 'name' then
      Result := outList.Names[0]

    else
    begin
      innerList := TStringList.Create;
      try
        innerList.StrictDelimiter := true;
        innerList.Delimiter := ',';
        innerList.CommaText := outList.ValueFromIndex[0];

        Result := innerList.Values[Key];

      finally
        innerList.Free;
      end;

    end;

  finally
    outList.Free;
  end;

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

function TMainForm.GetJSONDataMulti(
  const
  aDataSet:
  TDataSet): TJDOJSONObject;
begin
  Result := TJDOJSONObject.Create;
  try
    Result.O['meta'].S['title'] := 'Customer List';
    aDataSet.First;
    Result.A['items'].Add(aDataSet.AsJDOJSONArray);
  except
    Result.Free;
    raise;
  end;
end;

function TMainForm.GetLastMgsID: string;
begin
  System.TMonitor.Enter(self);
  try
    Result := FLastMgsID;
    if Result.IsEmpty then
      Result := '__last__';
  finally
    System.TMonitor.exit(self);
  end;

end;

function TMainForm.GetOutputExt: String;
begin
  if OutputFormat.StartsWith('pdf') then
  begin
    Result := 'pdf'
  end
  else
  begin
    Result := OutputFormat;
  end;
end;

function TMainForm.GetQueueName: string;
begin
  System.TMonitor.Enter(self);
  try
    Result := FQueueName;
  finally
    System.TMonitor.exit(self);
  end;
end;

procedure TMainForm.lbxAsyncReportsToCreateDrawItem(Control: TWinControl;
Index:
  Integer;
Rect:
  TRect;
State:
  TOwnerDrawState);
var
  lState, lName, Data: string;
begin
  System.TMonitor.Enter(FAsyncReports);
  try
    Data := TListBox(Control).Items[index];
    lState := GetAsyncReportKey(Data, 'state');

    lName := GetAsyncReportKey(Data, 'name');
    TListBox(Control).Canvas.TextOut(Rect.Left, Rect.Top, trim(StateToIcon(lState) + ' ' + lName));
  finally
    System.TMonitor.exit(FAsyncReports);
  end;

end;

procedure TMainForm.lbxAsyReportsCreatedDblClick(Sender: TObject);
begin
  var
  idx := TListBox(Sender).ItemIndex;
  if idx >= 0 then
  begin
    if GetAsyncReportKey(TListBox(Sender).Items[idx], 'state') <> 'CREATED' then
      exit;

    ResetFolder;
    var
    lReportFileName := Folder('output_pdf.zip');
    var
    lJResp := fProxy.GetAsyncReport(fToken, GetAsyncReportKey(
      TListBox(Sender).Items[idx], 'reportid'));
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

procedure TMainForm.ListBox1DblClick(Sender: TObject);
begin
  if OutputExt = 'pdf' then
  begin
    fPDFViewer.LoadFromFile(TPath.Combine(Folder('output_pdf'), ListBox1.Items[ListBox1.ItemIndex]),
      '', dloNormal);
    fPDFViewer.ZoomPercentage := 100;
    UpdateGUI;
    RzPageControl1.ActivePage := tsPDFViewer;
  end
  else
  begin
    ShellExecute(0, PChar('open'),
      PChar(
        Folder(TPath.Combine('output_' + OutputExt, ListBox1.Items[ListBox1.ItemIndex]))
      ), nil, nil, SW_SHOWMAXIMIZED);
  end;
end;

procedure TMainForm.OnValidateCert(
  const
  Sender:
  TObject;
const
  ARequest:
  TURLRequest;
const
  Certificate:
  TCertificate;
var
  Accepted:
  Boolean);
begin
  Accepted := true;
end;

procedure TMainForm.LoadConf;

begin
  with TStringList.Create do
  begin
    try
      if FileExists('reports.conf') then

        LoadFromFile('reports.conf');
      LastMgsID := Values['lastmsgid'];
      QueueName := Values['queuename'];

    finally
      Free;
    end;

  end;
end;

procedure TMainForm.SaveConf;
begin
  with TStringList.Create do
  begin
    try

      Values['queuename'] := QueueName;
      Values['lastmsgid'] := LastMgsID;
      SaveToFile('reports.conf');
    finally
      Free;
    end;

  end;

end;

procedure TMainForm.RefreshList(const LoadFirstDocument: Boolean);
var
  lFiles: TArray<string>;
  lFile: string;
  lExt: String;
begin
  lExt := OutputExt;
  ListBox1.Items.Clear;
  TDirectory.CreateDirectory(Folder('output_' + lExt));
  lFiles := TDirectory.GetFiles(Folder('output_' + lExt), '*.' + lExt);
  for lFile in lFiles do
  begin
    ListBox1.Items.Add(TPath.GetFileName(lFile));
  end;
  if lExt <> 'pdf' then
      fPDFViewer.Close;
  if not LoadFirstDocument then
    Exit;

  if ((ListBox1.Items.Count > 0) and (lExt = 'pdf')) or
     ((ListBox1.Items.Count = 1) and (lExt <> 'pdf')) then
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
  TDirectory.CreateDirectory(Folder('output_' + OutputExt));
  lFiles := TDirectory.GetFiles(Folder('output_' + OutputExt), '*.*');
  for lFile in lFiles do
  begin
    DeleteFile(lFile);
  end;
end;

procedure TMainForm.RestartAsync(const LastMessage: string);
begin
  if assigned(FThrState) then
  begin
    FThrState.Terminate;

    lbxAsyncReportsToCreate.Clear;
    lbxAsyReportsCreated.Clear;
    lbxAsyncReportsDeleted.Clear;
    FAsyncReports.Clear;
    lbxAll.Clear;
  end;
  LastMgsID := LastMessage;

  FThrState := TThread.CreateAnonymousThread(
    procedure
    var
      lJObjResp, lJObjMessage, lObjQueueItem: TJsonObject;
      lProxy: TEventStreamsRPCProxy;
      lQueueName: string;
    begin
      TThread.NameThreadForDebugging('QueueThread');

      lProxy := TEventStreamsRPCProxy.Create('https://' + SERVERNAME + '/eventstreamsrpc');
      try
        lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
        lProxy.RPCExecutor.SetOnReceiveResponse(
          procedure(ARequest, aResponse: IJSONRPCObject)
          begin
            Log.Debug('REQUEST: ' + sLineBreak + ARequest.ToString(false), 'trace');
          end);

        while true do
        begin
          if TThread.CheckTerminated then
          begin
            break;
          end;
          lQueueName := QueueName;
          if not lQueueName.IsEmpty then
          begin

            try
              lJObjResp := lProxy.
                DequeueMultipleMessage(fToken, lQueueName, LastMgsID, 1, 10);
              try
                if lJObjResp.A['data'].Count > 0 then
                begin
                  lObjQueueItem := lJObjResp.A['data'].O[0];
                  lJObjMessage := lObjQueueItem.O['message'];
                  if lJObjMessage.S['queuename'] = lQueueName then
                  begin

                    TThread.Synchronize(nil,
                      procedure
                      begin
                        AddReport(lJObjMessage.S['reportname'],
                          Format('reportid=%s,state=%s',
                          [lJObjMessage.S['reportid'], lJObjMessage.S['state']])
                          );

                      end);
                  end;
                  LastMgsID := lObjQueueItem.S['messageid'];
                end;

                // end;
              finally
                lJObjResp.Free;
              end;
            except
              on E: Exception do
              begin

                Sleep(1000);
              end;
            end;
          end;
          Sleep(400);
        end;
      finally
        lProxy.Free;
      end;
    end);
  FThrState.Start;
end;

procedure TMainForm.ScrollBar1Change(Sender: TObject);
begin
  fPDFViewer.ZoomPercentage := ScrollBar1.Position;
  UpdateGUI;
end;

procedure TMainForm.SetLastMgsID(const value: string);
begin
  System.TMonitor.Enter(self);
  try
    FLastMgsID := value;
    SaveConf;
  finally
    System.TMonitor.exit(self);
  end;

end;

procedure TMainForm.SetOutputFormat(const Value: String);
var
  I, lIdx: Integer;
  lFound: Boolean;
begin
  lFound := False;
  fOutputFormat := Value;
  lIdx := 0;
  for I := 0 to cbFormat.Items.Count-1 do
  begin
    if cbFormat.Items[I].StartsWith(Value + ' ') or (cbFormat.Items[I] = Value) then
    begin
      lIdx := I;
      lFound := True;
      Break;
    end;
  end;
  if not lFound then
  begin
    raise Exception.Create('Index Format not found');
  end;
  cbFormat.ItemIndex := lIdx;
  ListBox1.Clear;
end;

procedure TMainForm.SetQueueName(value: string);
begin
  System.TMonitor.Enter(self);
  try
    if value <> FQueueName then
    begin
      lbxAsyncReportsToCreate.Clear;
      lbxAsyReportsCreated.Clear;
      lbxAsyncReportsDeleted.Clear;
      FQueueName := value;
      SaveConf();
    end;
  finally
    System.TMonitor.exit(self);
  end;
end;

function TMainForm.StateToIcon(const State: string): string;
begin
  Result := '';
  if State = 'TO_CREATE' then
    Result := ''
  else
    if State = 'CREATED' then
    Result := ''
  else
    if State = 'DELETED' then
    Result := '';

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
