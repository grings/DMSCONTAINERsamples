﻿unit MainFRM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ReportsRPCProxy, JsonDataObjects, System.Net.URLClient, System.Actions,
  Vcl.ActnList, Vcl.Imaging.pngimage, System.IOUtils, FontAwesomeU,
  FontAwesomeCodes, PdfFrame;

type
  TfrmMain = class(TForm)
    pnlLogin: TPanel;
    Label1: TLabel;
    edtUser: TEdit;
    edtPassord: TEdit;
    btnLogin: TButton;
    ActionList1: TActionList;
    actLogin: TAction;
    pnlCenter: TPanel;
    Panel2: TPanel;
    Panel1: TPanel;
    Label4: TLabel;
    Image1: TImage;
    actGenAsyncReport: TAction;
    framePDF1: TframePDF;
    Label2: TLabel;
    Panel4: TPanel;
    ListBox1: TListBox;
    Label3: TLabel;
    Panel3: TPanel;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actLoginExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure actGenAsyncReportExecute(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);

  private
    { Private declarations }
    fProxy: TReportsRPCProxy;
    FToken: string;
    FThrState: TThread;
    FUserName: string;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
    function GetJSONData: TJDOJSONObject;
    procedure RestartAsync(const LastMessage: string = '__first__');
    procedure ResetFolder;

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

const
  SERVERNAME = 'localhost';
  fa_pdf = Char($F1C1);
  fa_magic = Char($F0D0);
  OUTPUT_DIR = 'output_pdf';

implementation

uses
  MVCFramework.Logger, MVCFramework.JSONRPC, EventStreamsRPCProxy, sevenzip,
  MVCFramework.Serializer.Commons, MVCFramework.Commons, System.character;

{$R *.dfm}


function FileToBase64String(const FileName: string): string;
var
  lTemplateFileB64: TStringStream;
  lTemplateFile: TFileStream;
begin
  lTemplateFileB64 := TStringStream.Create;
  try
    lTemplateFile := TFileStream.Create(FileName, fmOpenRead);
    try
      TMVCSerializerHelper.EncodeStream(lTemplateFile, lTemplateFileB64);
    finally
      lTemplateFile.Free;
    end;
    Result := lTemplateFileB64.DataString;
  finally
    lTemplateFileB64.Free;
  end;
end;

procedure TfrmMain.actGenAsyncReportExecute(Sender: TObject);
var
  lJTemplateData: TJDOJSONObject;
  lJResp: TJsonObject;
  lArchive: I7zInArchive;
  lModelFileName: string;
  lJData: TJsonObject;
  lRepName: string;
begin
  System.TMonitor.Enter(fProxy);
  try

    lRepName := FormatDateTime('yyyy_mm_dd_hh_nn_ss_zzz', now);
    lModelFileName := 'Report02.docx';

    lJTemplateData := TJDOJSONObject.Create;
    try
      lJTemplateData.S['template_data'] := FileToBase64String(lModelFileName);
    except
      lJTemplateData.Free;
      raise;

    end;
    lJData := TJsonObject.Parse(TFile.ReadAllText('data.json')) as TJsonObject;
    lJData.O['meta'].S['title'] := 'Customer List ' + DateTimeToStr(now);
    lJResp := fProxy.GenerateMultipleReportAsync(FToken,

      FUserName + '_' +
      lRepName, lJTemplateData,
      lJData, 'pdf');
    try
      if not lJResp.IsNull('error') then
      begin
        raise Exception.Create(lJResp.O['error'].S['message']);
      end

    finally
      lJResp.Free;
    end;
  finally
    System.TMonitor.exit(fProxy);
  end;

end;

procedure TfrmMain.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  actLogin.Enabled := (edtUser.Text <> '') and
    (edtPassord.Text <> '');
  pnlLogin.Visible := FToken.IsEmpty;
  pnlCenter.Visible := not FToken.IsEmpty;
end;

procedure TfrmMain.actLoginExecute(Sender: TObject);
var
  lJSON: TJsonObject;
begin
  ResetFolder();
  FToken := '';
  FUserName := '';
  lJSON := fProxy.Login(edtUser.Text, edtPassord.Text);
  try
    FToken := lJSON.S['token'];
    FUserName := edtUser.Text;
    RestartAsync('__last__');
  finally
    lJSON.Free;
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  pnlLogin.Align := alClient;
  InstallFont(self);
  fProxy := TReportsRPCProxy.Create('https://' + SERVERNAME + '/reportsrpc');
  fProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
  fProxy.RPCExecutor.SetOnReceiveResponse(
    procedure(ARequest, aResponse: IJSONRPCObject)
    begin
      Log.Debug('REQUEST: ' + sLineBreak + ARequest.ToString(false), 'trace');
    end);
  ResetFolder;

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FThrState) then
    FThrState.Terminate;
  fProxy.Free;
end;

function TfrmMain.GetJSONData: TJDOJSONObject;
begin

end;

procedure TfrmMain.ListBox1DblClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := TListBox(Sender).ItemIndex;
  if idx >= 0 then
  begin

    if not TListBox(Sender).Items[idx].Contains(fa_pdf) then
      exit;

    ResetFolder;
    var
    lReportFileName := TPath.Combine(OUTPUT_DIR, 'output_pdf.zip');
    var
    lJResp := fProxy.GetAsyncReport(FToken, ListBox1.Items.ValueFromIndex[idx]);
    try
      if lJResp.IsNull('error') then
      begin

        Base64StringToFile(lJResp.S['zipfile'], lReportFileName);
        var
        lArchive := CreateInArchive(CLSID_CFormatZip);
        lArchive.OpenFile(lReportFileName);
        TDirectory.CreateDirectory(OUTPUT_DIR);
        lArchive.ExtractTo(OUTPUT_DIR);
        framePDF1.LoadDirectory(OUTPUT_DIR);
      end;
    finally
      lJResp.Free;
    end;

  end;
end;

procedure TfrmMain.OnValidateCert(const Sender: TObject;
const ARequest: TURLRequest; const Certificate: TCertificate;
var Accepted: Boolean);
begin
  Accepted := true;
end;

procedure TfrmMain.ResetFolder;
var
  lFiles: TArray<string>;
  lFile: string;
begin
  framePDF1.Clear;
  TDirectory.CreateDirectory(OUTPUT_DIR);
  lFiles := TDirectory.GetFiles(OUTPUT_DIR, '*.pdf');
  for lFile in lFiles do
  begin
    DeleteFile(lFile);
  end;

end;

procedure TfrmMain.RestartAsync(const LastMessage: string);
var
  lQueueName: string;
  lLastMgsID: string;
begin
  if Assigned(FThrState) then
  begin
    FThrState.Terminate;
  end;
  lLastMgsID := LastMessage;

  lQueueName := 'queues.jobs.reports.' + FUserName.ToLower;
  FThrState := TThread.CreateAnonymousThread(
    procedure
    var
      lJObjResp, lJObjMessage, lObjQueueItem: TJsonObject;

      I, idx: Integer;
      lProxy: TEventStreamsRPCProxy;

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
          if not lQueueName.IsEmpty then
          begin

            try
              lJObjResp := lProxy.
                DequeueMultipleMessage(FToken, lQueueName, lLastMgsID, 1, 10);
              try
                if lJObjResp.A['data'].Count > 0 then
                begin
                  lObjQueueItem := lJObjResp.A['data'].O[0];
                  lJObjMessage := lObjQueueItem.O['message'];
                  if lJObjMessage.S['queuename'] = lQueueName then
                  begin

                    TThread.Synchronize(nil,
                      procedure
                      var
                        lState: string;
                        litem: string;
                      begin
                        lState := lJObjMessage.S['state'];

                        if lState = 'TO_CREATE' then
                          ListBox1.Items.Values[fa_magic + lJObjMessage.S['reportname']] :=
                            lJObjMessage.S['reportid']

                        else
                          if lState = 'CREATED' then
                        begin
                          litem := format('%s=%s', [
                            fa_pdf + ' ' + lJObjMessage.S['reportname'],
                            lJObjMessage.S['reportid']]);
                          idx := ListBox1.Items.IndexOfName(fa_magic + lJObjMessage.S['reportname']);
                          if idx >= 0 then
                            ListBox1.Items[idx] := litem
                          else
                            ListBox1.Items.Add(litem);

                        end
                        else
                        begin
                          idx := ListBox1.Items.IndexOfName(fa_pdf + lJObjMessage.S['reportname']);
                          if idx >= 0 then
                            ListBox1.Items.Delete(idx);
                        end;

                      end);
                  end;
                  lLastMgsID := lObjQueueItem.S['messageid'];
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

end.
