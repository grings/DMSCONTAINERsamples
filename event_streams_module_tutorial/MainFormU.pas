unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, EventStreamsRPCProxy,
  System.Net.URLClient, JsonDataObjects, Vcl.ExtCtrls, Vcl.Samples.Spin;

type
  TMainForm = class(TForm)
    EditQueueName: TEdit;
    btnDequeue: TButton;
    btnFirst: TButton;
    btnLast: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    EditLastKnownID: TEdit;
    Label2: TLabel;
    btnDelQueue: TButton;
    Panel1: TPanel;
    btnSend: TButton;
    EditValue: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EditTimeout: TEdit;
    btnCount: TButton;
    chkUpdateKID: TCheckBox;
    btnHugeMessage: TButton;
    procedure btnDequeueClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnDelQueueClick(Sender: TObject);
    procedure btnCountClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnHugeMessageClick(Sender: TObject);
  private
    fPID: Cardinal;
    fStart: TDateTime;
    procedure Log(const Text: String);
    procedure LogStart(const Text: String);
    procedure LogEnd;
    procedure DequeueMessage(const QueueName, LastKnownID: String);
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

const
  DMS_SERVER_URL = 'https://localhost';
  DMS_USERNAME = 'user_event';
  DMS_PWD = 'pwd1';

implementation

{$R *.dfm}

uses
  System.UITypes, System.DateUtils, System.Net.HttpClient;

procedure ScrollToLastLine(Memo: TMemo);
begin
  SendMessage(Memo.Handle, EM_LINESCROLL, 0, Memo.Lines.Count);
end;

procedure TMainForm.btnCountClick(Sender: TObject);
var
  lJObj: TJsonObject;
  lProxy: TEventStreamsRPCProxy;
  lToken: string;
begin
  lProxy := TEventStreamsRPCProxy.Create(DMS_SERVER_URL + '/eventstreamsrpc');
  try
    lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
    lJObj := lProxy.Login(DMS_USERNAME, DMS_PWD);
    try
      lToken := lJObj.S['token'];
    finally
      lJObj.Free;
    end;

    lJObj := lProxy.GetQueueSize(lToken, EditQueueName.Text);
    try
      Memo1.Lines.Add(lJObj.ToJSON());
    finally
      lJObj.Free;
    end;
  finally
    lProxy.Free;
  end;
end;

procedure TMainForm.btnDelQueueClick(Sender: TObject);
var
  lJObj: TJsonObject;
  lProxy: TEventStreamsRPCProxy;
  lToken: string;
begin
  if MessageDlg('Are you sure?', mtConfirmation, mbYesNo, 0) <> mrYes then
    Exit;
  lProxy := TEventStreamsRPCProxy.Create(DMS_SERVER_URL + '/eventstreamsrpc');
  try
    lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
    lJObj := lProxy.Login(DMS_USERNAME, DMS_PWD);
    try
      lToken := lJObj.S['token'];
    finally
      lJObj.Free;
    end;
    lProxy.DeleteQueue(lToken, EditQueueName.Text);
    Memo1.Lines.Add('CLIENT >> Queue Deleted');
  finally
    lProxy.Free;
  end;
end;

procedure TMainForm.btnDequeueClick(Sender: TObject);
begin
  DequeueMessage(EditQueueName.Text, EditLastKnownID.Text);
end;

procedure TMainForm.btnFirstClick(Sender: TObject);
begin
  DequeueMessage(EditQueueName.Text, '__first__');
end;

procedure TMainForm.btnHugeMessageClick(Sender: TObject);
var
  lJObj: TJsonObject;
  lProxy: TEventStreamsRPCProxy;
  lToken: string;
begin
  lProxy := TEventStreamsRPCProxy.Create(DMS_SERVER_URL + '/eventstreamsrpc');
  try
    lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
    lJObj := lProxy.Login(DMS_USERNAME, DMS_PWD);
    try
      lToken := lJObj.S['token'];
    finally
      lJObj.Free;
    end;

    lJObj := TJsonObject.Create;
    try
      lJObj.S['timestamp'] := TimeToStr(now);
      lJObj.I['sender_pid'] := fPID;
      lJObj.S['text'] := StringOfChar('*', 1024 * 10);
      lProxy.EnqueueMessage(lToken, EditQueueName.Text, lJObj.Clone);
    finally
      lJObj.Free;
    end;
  finally
    lProxy.Free;
  end;
end;

procedure TMainForm.btnLastClick(Sender: TObject);
begin
  DequeueMessage(EditQueueName.Text, '__last__');
end;

procedure TMainForm.btnSendClick(Sender: TObject);
var
  lJObj: TJsonObject;
  lProxy: TEventStreamsRPCProxy;
  lToken: string;
begin
  lProxy := TEventStreamsRPCProxy.Create(DMS_SERVER_URL + '/eventstreamsrpc');
  try
    lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
    lJObj := lProxy.Login(DMS_USERNAME, DMS_PWD);
    try
      lToken := lJObj.S['token'];
    finally
      lJObj.Free;
    end;

    lJObj := TJsonObject.Create;
    try
      lJObj.S['timestamp'] := TimeToStr(now);
      lJObj.I['sender_pid'] := fPID;
      lJObj.I['value'] := StrToInt(EditValue.Text);
      lProxy.EnqueueMessage(lToken, EditQueueName.Text, lJObj.Clone);
      EditValue.Text := (lJObj.I['value'] + 1).ToString;
    finally
      lJObj.Free;
    end;
  finally
    lProxy.Free;
  end;
end;

procedure TMainForm.DequeueMessage(const QueueName, LastKnownID: String);
var
  lProxy: TEventStreamsRPCProxy;
  lJObj: TJsonObject;
  lLastMgsID: string;
  lToken: string;
  lJMessage: TJsonObject;
begin
  lProxy := TEventStreamsRPCProxy.Create(DMS_SERVER_URL + '/eventstreamsrpc');
  try
    lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
    lJObj := lProxy.Login(DMS_USERNAME, DMS_PWD);
    try
      lToken := lJObj.S['token'];
    finally
      lJObj.Free;
    end;
    LogStart('Dequeue ' + LastKnownID);
    try
      lLastMgsID := LastKnownID;
      try
        lJMessage := lProxy.DequeueMultipleMessage(lToken, QueueName, lLastMgsID, 1,
          StrToInt(EditTimeout.Text));
        try
          if lJMessage.B['timeout'] then
          begin
            Memo1.Lines.Add(lJMessage.ToJSON);
          end
          else
          begin
            if chkUpdateKID.Checked then
            begin
              EditLastKnownID.Text := lJMessage.A['data'][0].S['messageid'];
            end;
            Memo1.Lines.Add(lJMessage.ToJSON());
          end;
        finally
          lJMessage.Free;
        end;
      except
        on E: Exception do
        begin
          Memo1.Lines.Add(E.Message);
        end;
      end;
      ScrollToLastLine(Memo1);
    finally
      LogEnd;
    end;
  finally
    lProxy.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fPID := GetCurrentProcessId;
  Caption := 'EventStreams Module :: Tutorial (PID ' + fPID.ToString + ')';
end;

procedure TMainForm.Log(const Text: String);
begin
  Memo1.Lines.Add(Text);
end;

procedure TMainForm.LogEnd;
begin
  Log(TimeToStr(now) + ': END - Elapsed ' + MilliSecondsBetween(now, fStart).ToString + 'ms');
end;

procedure TMainForm.LogStart(const Text: String);
begin
  fStart := now;
  Log(TimeToStr(fStart) + ': START -> ' + Text);
end;

procedure TMainForm.OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
  const Certificate: TCertificate; var Accepted: Boolean);
begin
  Accepted := True;
end;

end.
