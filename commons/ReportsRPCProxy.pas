//------------------------------------------------------------------
// Proxy Unit Generated by Delphi Microservices Container 4.0.29
// Do not modify this unit!
// Generated at: 2021-03-11 10:08:16
//------------------------------------------------------------------
unit ReportsRPCProxy;

interface

uses
  System.SysUtils,
  System.Classes,
  MVCFramework.JSONRPC,
  MVCFramework.JSONRPC.Client,
  MVCFramework.Serializer.Commons,
  JsonDataObjects;

type
  IReportsRPCProxy = interface
  ['{705C3985-3B68-4131-89CA-92C0B239694B}']
    function RPCExecutor: IMVCJSONRPCExecutor;
    /// <summary>
    /// Invokes [function GenerateMultipleReport(const Token: string; const Template: TJsonObject; const ReportData: TJsonObject; const OutputFormat: string): TJsonObject]
    /// Generates report based on a docx template and a JSON structure. Generates one PDF file for each element in the "items" JSON property.
    /// </summary>
    function GenerateMultipleReport(const Token: string; const Template: TJsonObject; const ReportData: TJsonObject; const OutputFormat: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function GenerateMultipleReportAsync(const Token: string; const ReportName: string; const Template: TJsonObject; const ReportData: TJsonObject; const UserToNotify: TJsonArray; const OutputFormat: string): TJsonObject]
    /// Generates report asynchronously based on a docx template and a JSON structure. Generates one PDF file for each element in the "items" JSON property.
    /// </summary>
    function GenerateMultipleReportAsync(const Token: string; const ReportName: string; const Template: TJsonObject; const ReportData: TJsonObject; const UserToNotify: TJsonArray; const OutputFormat: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function GetAsyncReport(const Token: string; const ReportID: string): TJsonObject]
    /// Returns a report generated asychronously with GenerateMultipleReportAsync
    /// </summary>
    function GetAsyncReport(const Token: string; const ReportID: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function Login(const UserName: string; const Password: string): TJsonObject]
    /// Returns the JWT token which can be used to call all other methods.
    /// </summary>
    function Login(const UserName: string; const Password: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function RefreshToken(const Token: string): TJsonObject]
    /// Extends the expiration time of a still-valid token. Clients must use the token returned instead of the previous one.
    /// </summary>
    function RefreshToken(const Token: string): TJDOJsonObject;
  end;

  TReportsRPCProxy = class(TInterfacedObject, IReportsRPCProxy)
  protected
    fRPCExecutor: IMVCJSONRPCExecutor;
    function NewReqID: Int64;
  public
    function RPCExecutor: IMVCJSONRPCExecutor;
    constructor Create(const EndpointURL: String); virtual;
    /// <summary>
    /// Invokes [function GenerateMultipleReport(const Token: string; const Template: TJsonObject; const ReportData: TJsonObject; const OutputFormat: string): TJsonObject]
    /// Generates report based on a docx template and a JSON structure. Generates one PDF file for each element in the "items" JSON property.
    /// </summary>
    function GenerateMultipleReport(const Token: string; const Template: TJsonObject; const ReportData: TJsonObject; const OutputFormat: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function GenerateMultipleReportAsync(const Token: string; const ReportName: string; const Template: TJsonObject; const ReportData: TJsonObject; const UserToNotify: TJsonArray; const OutputFormat: string): TJsonObject]
    /// Generates report asynchronously based on a docx template and a JSON structure. Generates one PDF file for each element in the "items" JSON property.
    /// </summary>
    function GenerateMultipleReportAsync(const Token: string; const ReportName: string; const Template: TJsonObject; const ReportData: TJsonObject; const UserToNotify: TJsonArray; const OutputFormat: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function GetAsyncReport(const Token: string; const ReportID: string): TJsonObject]
    /// Returns a report generated asychronously with GenerateMultipleReportAsync
    /// </summary>
    function GetAsyncReport(const Token: string; const ReportID: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function Login(const UserName: string; const Password: string): TJsonObject]
    /// Returns the JWT token which can be used to call all other methods.
    /// </summary>
    function Login(const UserName: string; const Password: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function RefreshToken(const Token: string): TJsonObject]
    /// Extends the expiration time of a still-valid token. Clients must use the token returned instead of the previous one.
    /// </summary>
    function RefreshToken(const Token: string): TJDOJsonObject;
end;

implementation

uses
  System.Net.URLClient,
  System.RTTI;

constructor TReportsRPCProxy.Create(const EndpointURL: String);
begin
  inherited Create;
  fRPCExecutor := TMVCJSONRPCExecutor.Create(EndpointURL);
  fRPCExecutor.AddHTTPHeader(TNetHeader.Create('Accept-Encoding', 'gzip'));
  fRPCExecutor.AddHTTPHeader(TNetHeader.Create('User-Agent', 'dmscontainer-delphi-proxy'));

end;

function TReportsRPCProxy.NewReqID: Int64;
begin
  Result := 10000 + Random(10000000);
end;

function TReportsRPCProxy.RPCExecutor: IMVCJSONRPCExecutor;
begin
  Result := fRPCExecutor;
end;


function TReportsRPCProxy.GenerateMultipleReport(const Token: string; const Template: TJsonObject; const ReportData: TJsonObject; const OutputFormat: string): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'GenerateMultipleReport');
  lReq.Params.Add(Token);
  lReq.Params.Add(Template);
  lReq.Params.Add(ReportData);
  lReq.Params.Add(OutputFormat);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TReportsRPCProxy.GenerateMultipleReportAsync(const Token: string; const ReportName: string; const Template: TJsonObject; const ReportData: TJsonObject; const UserToNotify: TJsonArray; const OutputFormat: string): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'GenerateMultipleReportAsync');
  lReq.Params.Add(Token);
  lReq.Params.Add(ReportName);
  lReq.Params.Add(Template);
  lReq.Params.Add(ReportData);
  lReq.Params.Add(UserToNotify);
  lReq.Params.Add(OutputFormat);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TReportsRPCProxy.GetAsyncReport(const Token: string; const ReportID: string): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'GetAsyncReport');
  lReq.Params.Add(Token);
  lReq.Params.Add(ReportID);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TReportsRPCProxy.Login(const UserName: string; const Password: string): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'Login');
  lReq.Params.Add(UserName);
  lReq.Params.Add(Password);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TReportsRPCProxy.RefreshToken(const Token: string): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'RefreshToken');
  lReq.Params.Add(Token);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;

end.