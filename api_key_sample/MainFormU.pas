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
  Vcl.Imaging.pngimage,
  FireDAC.Stan.StorageBin,
  FireDAC.Stan.StorageJSON,
  ExcelRPCProxy;

type
  TMainForm = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    btnSimpleWorksheet: TButton;
    RzPageControl1: TPageControl;
    tsData: TTabSheet;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    PrintDialog1: TPrintDialog;
    Panel6: TPanel;
    Image1: TImage;
    Label4: TLabel;
    dsCustomers: TFDMemTable;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    btnRawJSON: TButton;
    procedure btnSimpleWorksheetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRawJSONClick(Sender: TObject);
  private
    fProxy: TExcelRPCProxy;
    fToken: string;
    function DelphiDataTypeToExcel(const DataType: TFieldType): string;
    procedure ResetFolder;
    function Folder(aFolder: string): string;
    function GetEndPoint: string;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
    function GetJSONData(const WorkSheetName: string; const DataSet: TDataSet): TJDOJSONObject;
    procedure InternalGetJSONData(const WorkBook: TJSONObject; const WorkSheetName: string; const DataSet: TDataSet);
  public
    property Token: string read fToken;
  end;

var
  MainForm: TMainForm;

const
  SERVERNAME = 'localhost'; // } '172.31.3.225';

{
THIS IS THE API KEY USED BY ALL DMSCONTAINER CALL. IT MUST BE GENERATED
BY DMSADMIN, COPIED AND PASTED HERE. USING THE APIKEY YOU CAN AVOID TO DO
A LOGIN CALL. IF YOU CHANGE THE APIKEY FROM DMSADMIN NEED TO UPDATE IT HERE AS WELL.
}
const
  DMS_API_KEY = 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.' +
  'eyJpc3MiOiJETVNDb250YWluZXIiLCJleHAiOjMxNzM2MDYzMzks' +
  'Im5iZiI6MTU5NjgwNjAzOSwiaWF0IjoxNTk2ODA2MDM5LCJ1c2Vy' +
  'aWQiOiIxIiwicm9sZXMiOiJzZW5kZXIiLCJjb250ZXh0cyI6IiIs' +
  'ImlzYXB5a2V5IjoiMSIsInVzZXJuYW1lIjoidXNlcl9zZW5kZXIifQ.' +
  'eOXgqBVHtJDr_DjKcxQp5QzZK8wzXY72tKO_NE7r2YSi1Fac8abuFBy' +
  'MDyjjpI1jE8bMh7rVUJ2Wslwk4hsScw';

implementation

uses
  LoggerPro.GlobalLogger,
  Winapi.ShellAPI,
  System.IOUtils,
  MVCFramework.Commons,
  MVCFramework.DataSet.Utils,
  Vcl.Printers,
  MVCFramework.JSONRPC,
  System.TypInfo,
  FontAwesomeU,
  FontAwesomeCodes;

{$R *.dfm}


function TMainForm.Folder(aFolder: string): string;
begin
  Result := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), aFolder);
end;

procedure TMainForm.OnValidateCert(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := true;
end;

procedure TMainForm.btnRawJSONClick(Sender: TObject);
var
  lJResp: TJSONObject;
  lOutputFileName: string;
  lJSONData: TJSONObject;
  lProxy: TExcelRPCProxy;
const
  JSON =
    '{ ' +
    '  "worksheets": [{' +
    '	"name": "My First Worksheet",' +
    '	"columns": [' +
    '		    {"title": "Product Name",  "type": "general"},' +
    '		    {"title": "Price", "type": "number", "format": "€ #,##0.00"}' +
    '            ],' +
    '	"data": [' +
    '                 ["Pizza Margherita", 5.00],' +
    '	        		    ["Pizza 4 Formaggi", 6.50],' +
    '		   	          ["Pizza Porcini e Salsiccia", 10.50]' +
    '		    ]' +
    '}]}';
begin
  lProxy := TExcelRPCProxy.Create(GetEndPoint);
  try
    lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
    lOutputFileName := 'raw_json.xlsx';
    lJSONData := TJSONObject.Parse(JSON) as TJSONObject;
    lJResp := fProxy.ConvertToXLSX(fToken, lJSONData);
    try
      { Base64StringToFile is declared in MVCFramework.Commons.pas }
      Base64StringToFile(lJResp.S['xlsx'], lOutputFileName);
    finally
      lJResp.Free;
    end;
  finally
    lProxy.Free;
  end;
  ShellExecute(0, PChar('open'), PChar(lOutputFileName), nil, nil, SW_SHOW);
end;

procedure TMainForm.btnSimpleWorksheetClick(Sender: TObject);
var
  lJResp: TJSONObject;
  lOutputFileName: string;
begin
  ResetFolder;
  lOutputFileName := 'customers.xlsx';
  lJResp := fProxy.ConvertToXLSX(Token, GetJSONData('Customers', dsCustomers));
  try
    Base64StringToFile(lJResp.S['xlsx'], lOutputFileName);
  finally
    lJResp.Free;
  end;
  ShellExecute(0, PChar('open'), PChar(lOutputFileName), nil, nil, SW_SHOW);
end;

function TMainForm.DelphiDataTypeToExcel(const DataType: TFieldType): string;
begin
  case DataType of
    ftString, ftFixedChar, ftWideString:
      Exit('text');
    ftSmallint, ftInteger, ftWord, ftCurrency, ftBCD, ftAutoInc, ftLargeint, ftLongWord, ftShortint, ftByte,
      TFieldType.ftFloat, TFieldType.ftSingle, ftFMTBcd:
      Exit('number');
    ftBoolean:
      Exit('boolean');
    ftDate:
      Exit('date');
    ftTime:
      Exit('time');
    ftDateTime:
      Exit('datetime');
    ftMemo:
      Exit('text');
    ftFmtMemo:
      Exit('text');
    ftGuid:
      Exit('text');
    ftTimeStamp:
      Exit('datetime');
    ftFixedWideChar:
      Exit('text');
    ftWideMemo:
      Exit('text');
  else
    Result := 'general';
  end;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    ResetFolder;
  except
    // do nothing
  end;
  fProxy.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  dsCustomers.LoadFromFile(TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'customers.json'), sfJSON);
  InstallFont(Self);
  ResetFolder;
  fProxy := TExcelRPCProxy.Create(GetEndPoint);
  fProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
  fProxy.RPCExecutor.SetOnReceiveResponse(
    procedure(ARequest, aResponse: IJSONRPCObject)
    begin
      Log.Debug('REQUEST: ' + sLineBreak + ARequest.ToString(False), 'trace');
    end);
  btnSimpleWorksheet.Caption := fa_files_o + ' ' + btnSimpleWorksheet.Caption;
  RzPageControl1.ActivePageIndex := 0;
  fToken := DMS_API_KEY;
end;

function TMainForm.GetEndPoint: string;
begin
  Result := 'https://' + SERVERNAME + '/excelrpc';
end;

function TMainForm.GetJSONData(const WorkSheetName: string; const DataSet: TDataSet): TJDOJSONObject;
begin
  Result := TJDOJSONObject.Create;
  try
    InternalGetJSONData(Result, WorkSheetName, DataSet);
    Result.SaveToFile('last.json');
  except
    Result.Free;
    raise;
  end;
end;

procedure TMainForm.InternalGetJSONData(const WorkBook: TJSONObject; const WorkSheetName: string;
const DataSet: TDataSet);
var
  lWorkSheets: TJsonArray;
  lWorkSheet: TJSONObject;
  I: Integer;
  lColumns: TJsonArray;
  lCol: TJSONObject;
begin
  DataSet.First;
  DataSet.DisableControls;
  try
    lWorkSheets := WorkBook.A['worksheets'];
    lWorkSheet := lWorkSheets.AddObject;
    lWorkSheet.S['name'] := WorkSheetName;
    lColumns := lWorkSheet.A['columns'];
    for I := 0 to DataSet.Fields.Count - 1 do
    begin
      lCol := lColumns.AddObject;
      lCol.S['title'] := DataSet.Fields[I].DisplayName;
      if DataSet.Fields[I].DisplayName.Equals('F_FORMULA') then
      begin
        lCol.S['type'] := 'formula';
        lCol.S['format'] := '#,###,##.00';
      end
      else
      begin
        lCol.S['type'] := DelphiDataTypeToExcel(DataSet.Fields[I].DataType);
      end;
      if DataSet.Fields[I] is TDateTimeField then
      begin
        lCol.S['format'] := TDateTimeField(DataSet.Fields[I]).DisplayFormat;
      end
      else if DataSet.Fields[I] is TNumericField then
      begin
        lCol.S['format'] := TNumericField(DataSet.Fields[I]).DisplayFormat;
      end;
    end;
    DataSet.First;
    lWorkSheet.A['data'] := DataSet.AsJSONArrayOfValues;
    DataSet.First;
  finally
    DataSet.EnableControls;
  end;
end;

procedure TMainForm.ResetFolder;
var
  lFiles: TArray<string>;
  lFile: string;
begin
  TDirectory.CreateDirectory(Folder('output_xslx'));
  lFiles := TDirectory.GetFiles(Folder('output_xslx'), '*.xslx');
  for lFile in lFiles do
  begin
    DeleteFile(lFile);
  end;
end;

end.
