unit MainFRM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ReportsRPCProxy, JsonDataObjects, System.Net.URLClient, System.Actions,
  Vcl.ActnList, Vcl.Imaging.pngimage, System.IOUtils, FontAwesomeU,
  FontAwesomeCodes, PdfFrame, Vcl.CheckLst;

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
    btnShare: TButton;
    Splitter1: TSplitter;
    pnlUserShared: TPanel;
    CheckListBox1: TCheckListBox;
    Panel5: TPanel;
    Label6: TLabel;
    btnLogOut: TButton;
    actLogout: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actLoginExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure actGenAsyncReportExecute(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure btnShareClick(Sender: TObject);
    procedure GenterateReports(UsersToNotify: TJsonArray);
    procedure actLogoutExecute(Sender: TObject);

  private
    { Private declarations }
    fProxy: TReportsRPCProxy;
    FToken: string;
    FThrState: TThread;
    FUserName: string;
    FOutputDir: string;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
    procedure RestartAsync(const LastMessage: string = '__first__');
    procedure ResetFolder;
    procedure GetUsers;
    function GetSelectedUsers: TJsonArray;

  public
    { Public declarations }

  end;

var
  frmMain: TfrmMain;

const
  SERVERNAME = 'localhost';
  fa_pdf = Char($F1C1);
  fa_magic = Char($F0D0);

implementation

uses
  MVCFramework.Logger, MVCFramework.JSONRPC, EventStreamsRPCProxy, sevenzip,
  MVCFramework.Serializer.Commons, MVCFramework.Commons, System.character,
  AuthRPCProxy;

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

procedure TfrmMain.GenterateReports(UsersToNotify: TJsonArray);
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
      lJData, UsersToNotify, 'pdf');
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

procedure TfrmMain.actGenAsyncReportExecute(Sender: TObject);
begin
  GenterateReports(GetSelectedUsers);

end;

procedure TfrmMain.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  actLogin.Enabled := (edtUser.Text <> '') and
    (edtPassord.Text <> '');
  pnlLogin.Visible := FToken.IsEmpty;
  pnlCenter.Visible := not FToken.IsEmpty;
  if not FToken.IsEmpty then
    btnLogOut.Width := 130
  else
    btnLogOut.Width := 1;

  btnLogOut.Caption := 'Log out ' + FUserName;

end;

procedure TfrmMain.actLoginExecute(Sender: TObject);
var
  lJSON: TJsonObject;
begin

  FToken := '';
  FUserName := '';
  ListBox1.Clear;
  lJSON := fProxy.Login(edtUser.Text, edtPassord.Text);
  try
    FToken := lJSON.S['token'];
    FUserName := edtUser.Text;
    RestartAsync('__last__');
    FOutputDir := TPath.Combine(FOutputDir, FUserName+'_temp');
    ResetFolder();
  finally
    lJSON.Free;
  end;

end;

procedure TfrmMain.actLogoutExecute(Sender: TObject);
begin
  FToken := '';
  FThrState.Terminate;
  FThrState := nil;
end;

procedure TfrmMain.btnShareClick(Sender: TObject);
begin
  if pnlUserShared.Width = 1 then
  begin
    GetUsers;
    pnlUserShared.Width := 250;

  end
  else
    pnlUserShared.Width := 1
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  pnlUserShared.Width := 1;
  pnlLogin.Align := alClient;
  InstallFont(self);
  btnLogOut.Width := 1;
  fProxy := TReportsRPCProxy.Create('https://' + SERVERNAME + '/reportsrpc');
  fProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
  fProxy.RPCExecutor.SetOnReceiveResponse(
    procedure(ARequest, aResponse: IJSONRPCObject)
    begin
      Log.Debug('REQUEST: ' + sLineBreak + ARequest.ToString(false), 'trace');
      Log.Debug('RESPONSE: ' + sLineBreak + aResponse.ToString(false), 'trace');

    end);

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FThrState) then
    FThrState.Terminate;
  fProxy.Free;
end;

function TfrmMain.GetSelectedUsers: TJsonArray;
var
  i: Integer;
begin
  Result := TJsonArray.Create;
  if pnlUserShared.Width > 1 then
  begin
    for i := 0 to CheckListBox1.Count - 1 do
      if CheckListBox1.Checked[i] then
        Result.Add(CheckListBox1.Items[i]);

  end;
end;

procedure TfrmMain.GetUsers;
var
  lAuthProxy: TAuthRPCProxy;
  lJResp: TJsonObject;
  i: Integer;
begin
  lAuthProxy := TAuthRPCProxy.Create('https://' + SERVERNAME + '/authrpc');
  try
    lAuthProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
    lJResp := lAuthProxy.GetUsers(FToken, nil);
    if not lJResp.IsNull('error') then
    begin
      raise Exception.Create(lJResp.O['error'].S['message']);
    end;
    CheckListBox1.Clear;
    for i := 0 to lJResp.A['items'].Count - 1 do
    begin
      if FUserName <> lJResp.A['items'].O[i].S['username'] then

        CheckListBox1.Items.Add(lJResp.A['items'].O[i].S['username']);
    end;

  finally
    lAuthProxy.Free;
  end;

end;

procedure TfrmMain.ListBox1DblClick(Sender: TObject);
var
  idx: Integer;
begin
  System.TMonitor.Enter(ListBox1);
  try
    idx := TListBox(Sender).ItemIndex;
    if idx >= 0 then
    begin

      if not TListBox(Sender).Items[idx].Contains(fa_pdf) then
        exit;

      ResetFolder;
      var
      lReportFileName := TPath.Combine(FOutputDir, 'output_pdf.zip');
      var
      lJResp := fProxy.GetAsyncReport(FToken, ListBox1.Items.ValueFromIndex[idx]);
      try
        if lJResp.IsNull('error') then
        begin

          Base64StringToFile(lJResp.S['zipfile'], lReportFileName);
          var
          lArchive := CreateInArchive(CLSID_CFormatZip);
          lArchive.OpenFile(lReportFileName);
          TDirectory.CreateDirectory(FOutputDir);
          lArchive.ExtractTo(FOutputDir);
          framePDF1.LoadDirectory(FOutputDir);
        end;
      finally
        lJResp.Free;
      end;

    end;
  finally
    System.TMonitor.exit(ListBox1);
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
  TDirectory.CreateDirectory(FOutputDir);
  lFiles := TDirectory.GetFiles(FOutputDir, '*.pdf');
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

      i, idx: Integer;
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
                if not lJObjResp.IsNull('error') then
                begin
                  Log.Error(lJObjResp.ToJSON(), 'trace');
                end;

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
                        System.TMonitor.Enter(ListBox1);
                        try

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
                            idx := ListBox1.Items.IndexOfName(fa_pdf + ' ' + lJObjMessage.S['reportname']);
                            if idx >= 0 then
                              ListBox1.Items.Delete(idx);
                          end;
                        finally
                          System.TMonitor.exit(ListBox1);

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
                Log.Error(E.Message, 'trace');
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
