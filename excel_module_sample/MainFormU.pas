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
    btnAllTypes: TButton;
    btnAllTabs: TButton;
    PrintDialog1: TPrintDialog;
    Panel6: TPanel;
    Image1: TImage;
    Label4: TLabel;
    dsCustomers: TFDMemTable;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    btnThirdTab: TButton;
    TabSheet1: TTabSheet;
    DBGrid2: TDBGrid;
    dsAllTypes: TFDMemTable;
    DataSource2: TDataSource;
    dsAllTypesF_INTEGER: TIntegerField;
    dsAllTypesF_FLOAT: TFloatField;
    dsAllTypesF_BCD: TBCDField;
    dsAllTypesF_CURRENCY: TCurrencyField;
    dsAllTypesD_DATE: TDateField;
    dsAllTypesF_TIME: TTimeField;
    dsAllTypesF_DATETIME: TDateTimeField;
    dsAllTypesF_SQLTIMESTAMP: TSQLTimeStampField;
    dsAllTypesF_BOOLEAN: TBooleanField;
    dsAllTypesF_FORMULA: TStringField;
    dsAllFormattedFields: TFDMemTable;
    IntegerField1: TIntegerField;
    FloatField1: TFloatField;
    BCDField1: TBCDField;
    CurrencyField1: TCurrencyField;
    DateField1: TDateField;
    TimeField1: TTimeField;
    DateTimeField1: TDateTimeField;
    SQLTimeStampField1: TSQLTimeStampField;
    BooleanField1: TBooleanField;
    StringField1: TStringField;
    DataSource3: TDataSource;
    TabSheet2: TTabSheet;
    DBGrid3: TDBGrid;
    btnHuge: TButton;
    btnRawJSON: TButton;
    procedure btnSimpleWorksheetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAllTypesClick(Sender: TObject);
    procedure btnThirdTabClick(Sender: TObject);
    procedure btnAllTabsClick(Sender: TObject);
    procedure btnHugeClick(Sender: TObject);
    procedure btnRawJSONClick(Sender: TObject);
  private
    fProxy: TExcelRPCProxy;
    fToken: string;
    procedure LoadAllTypes;
    procedure EnsureLogin;
    function DelphiDataTypeToExcel(const DataType: TFieldType): string;
    procedure ResetFolder;
    function Folder(aFolder: string): string;
    function GetEndPoint: string;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
    function GetJSONData(const WorkSheetName: string; const DataSet: TDataSet): TJDOJSONObject;
    function GetWorkbookJSONData(const WorkSheetsName: array of string; const DataSets: array of TDataSet)
      : TJDOJSONObject;
    procedure InternalGetJSONData(const WorkBook: TJSONObject; const WorkSheetName: string; const DataSet: TDataSet);
  public
    property Token: string read fToken;
  end;

var
  MainForm: TMainForm;

const
  SERVERNAME = 'localhost'; // } '172.31.3.225';

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

procedure TMainForm.btnAllTabsClick(Sender: TObject);
var
  lJResp: TJSONObject;
  lOutputFileName: string;
begin
  ResetFolder;
  lOutputFileName := 'all_in_one_workbook.xlsx';
  EnsureLogin;
  lJResp := fProxy.ConvertToXLSX(Token, GetWorkbookJSONData(['Customers', 'All Types', 'All Types with Formatting'],
    [dsCustomers, dsAllTypes, dsAllFormattedFields]));
  try
    Base64StringToFile(lJResp.S['xlsx'], lOutputFileName);
  finally
    lJResp.Free;
  end;
  ShellExecute(0, PChar('open'), PChar(lOutputFileName), nil, nil, SW_SHOW);
end;

procedure TMainForm.btnAllTypesClick(Sender: TObject);
var
  lJResp: TJSONObject;
  lOutputFileName: string;
begin
  ResetFolder;
  lOutputFileName := 'alltypes.xlsx';
  EnsureLogin;
  lJResp := fProxy.ConvertToXLSX(Token, GetJSONData('All Types', dsAllTypes));
  try
    Base64StringToFile(lJResp.S['xlsx'], lOutputFileName);
  finally
    lJResp.Free;
  end;
  ShellExecute(0, PChar('open'), PChar(lOutputFileName), nil, nil, SW_SHOW);
end;

procedure TMainForm.btnHugeClick(Sender: TObject);
var
  lJResp: TJSONObject;
  lOutputFileName: string;
begin
  ResetFolder;
  lOutputFileName := 'huge_all_in_one_workbook.xlsx';
  EnsureLogin;
  lJResp := fProxy.ConvertToXLSX(Token, GetWorkbookJSONData(['Customers0', 'All Types0', 'All Types with Formatting0',
    'Customers1', 'All Types1', 'All Types with Formatting1', 'Customers2', 'All Types2', 'All Types with Formatting2',
    'Customers3', 'All Types3', 'All Types with Formatting3', 'Customers4', 'All Types4', 'All Types with Formatting4'],
    [dsCustomers, dsAllTypes, dsAllFormattedFields, dsCustomers, dsAllTypes, dsAllFormattedFields, dsCustomers,
    dsAllTypes, dsAllFormattedFields, dsCustomers, dsAllTypes, dsAllFormattedFields, dsCustomers, dsAllTypes,
    dsAllFormattedFields]));
  try
    Base64StringToFile(lJResp.S['xlsx'], lOutputFileName);
  finally
    lJResp.Free;
  end;
  ShellExecute(0, PChar('open'), PChar(lOutputFileName), nil, nil, SW_SHOW);
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
  lToken: string;
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
    lJResp := fProxy.Login('user_sender', 'pwd1');
    try
      lToken := lJResp.S['token'];
    finally
      lJResp.Free;
    end;
    lOutputFileName := 'raw_json.xlsx';
    lJSONData := TJSONObject.Parse(JSON) as TJSONObject;
    lJResp := fProxy.ConvertToXLSX(lToken, lJSONData);
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
  EnsureLogin;
  lJResp := fProxy.ConvertToXLSX(Token, GetJSONData('Customers', dsCustomers));
  try
    Base64StringToFile(lJResp.S['xlsx'], lOutputFileName);
  finally
    lJResp.Free;
  end;
  ShellExecute(0, PChar('open'), PChar(lOutputFileName), nil, nil, SW_SHOW);
end;

procedure TMainForm.btnThirdTabClick(Sender: TObject);
var
  lJResp: TJSONObject;
  lOutputFileName: string;
begin
  ResetFolder;
  lOutputFileName := 'alltypeswithformatting.xlsx';
  EnsureLogin;
  lJResp := fProxy.ConvertToXLSX(Token, GetJSONData('All Types with Formatting', dsAllFormattedFields));
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

procedure TMainForm.EnsureLogin;
var
  lJObj: TJSONObject;
begin
  if not fToken.IsEmpty then
  begin
    Exit;
  end;
  lJObj := fProxy.Login('user_sender', 'pwd1');
  try
    fToken := lJObj.S['token'];
  finally
    lJObj.Free;
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
  LoadAllTypes;
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
  btnAllTypes.Caption := fa_files_o + ' ' + btnAllTypes.Caption;
  btnThirdTab.Caption := fa_files_o + ' ' + btnThirdTab.Caption;
  btnAllTabs.Caption := fa_puzzle_piece + ' ' + btnAllTabs.Caption;
  btnHuge.Caption := fa_truck + ' ' + btnHuge.Caption;
  RzPageControl1.ActivePageIndex := 0;
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

function TMainForm.GetWorkbookJSONData(const WorkSheetsName: array of string; const DataSets: array of TDataSet)
  : TJDOJSONObject;
var
  lDS: TDataSet;
  I: Integer;
begin
  Result := TJSONObject.Create;
  try
    I := 0;
    for lDS in DataSets do
    begin
      InternalGetJSONData(Result, WorkSheetsName[I], lDS);
      inc(I);
    end;
    Result.SaveToFile('workbook.json', False);
  except
    Result.Free;
    raise;
  end;
end;

procedure TMainForm.LoadAllTypes;
var
  I: Integer;
begin
  dsAllTypes.Close;
  dsAllFormattedFields.Close;
  dsAllTypes.CreateDataSet;
  dsAllFormattedFields.CreateDataSet;
  dsAllTypes.DisableControls;
  dsAllFormattedFields.DisableControls;
  try
    for I := 1 to 5000 do
    begin
      dsAllTypes.AppendRecord([I, Random(I * 10000) / 10, Random(I * 10000) / 10, Random(100000) / 1000,
        EncodeDate(1900 + I mod 200, (I mod 12) + 1, (I mod 28) + 1), EncodeTime(I mod 24, I mod 60, I mod 60, 0),
        EncodeDate(1900 + I mod 200, (I mod 12) + 1, (I mod 28) + 1) + EncodeTime(I mod 24, I mod 60, I mod 60, 0),
        EncodeDate(1900 + I mod 200, (I mod 12) + 1, (I mod 28) + 1) + EncodeTime(I mod 24, I mod 60, I mod 60, 0),
        Random(10) < 5, Format('=Sum(A%d,B%d)', [I + 1, I + 1])]);
      dsAllFormattedFields.AppendRecord([I, Random(I * 10000) / 10, Random(I * 10000) / 10, Random(100000) / 1000,
        EncodeDate(1900 + I mod 200, (I mod 12) + 1, (I mod 28) + 1), EncodeTime(I mod 24, I mod 60, I mod 60, 0),
        EncodeDate(1900 + I mod 200, (I mod 12) + 1, (I mod 28) + 1) + EncodeTime(I mod 24, I mod 60, I mod 60, 0),
        EncodeDate(1900 + I mod 200, (I mod 12) + 1, (I mod 28) + 1) + EncodeTime(I mod 24, I mod 60, I mod 60, 0),
        Random(10) < 5, Format('=Sum(A%d,B%d)', [I + 1, I + 1])]);
    end;
    dsAllTypes.First;
    dsAllFormattedFields.First;
  finally
    dsAllTypes.EnableControls;
    dsAllFormattedFields.EnableControls;
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
