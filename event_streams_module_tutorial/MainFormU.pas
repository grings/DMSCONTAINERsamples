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
    Label4: TLabel;
    EditTimeout: TEdit;
    btnCount: TButton;
    chkUpdateKID: TCheckBox;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    EditValue: TEdit;
    btnSend: TButton;
    GroupBox2: TGroupBox;
    btnHugeMessage: TButton;
    GroupBox3: TGroupBox;
    EditTTL: TEdit;
    Label6: TLabel;
    btnSendWithTTL: TButton;
    btnMultipleWithTTL: TButton;
    procedure btnDequeueClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnDelQueueClick(Sender: TObject);
    procedure btnCountClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnHugeMessageClick(Sender: TObject);
    procedure btnSendWithTTLClick(Sender: TObject);
    procedure btnMultipleWithTTLClick(Sender: TObject);
  private
    fPID: Cardinal;
    fStart: TDateTime;
    fLastLogin: TDateTime;
    fToken: string;
    fProxy: IEventStreamsRPCProxy;
    procedure EnsureLogin;
    procedure Log(const Text: String);
    procedure LogStart(const Text: String);
    procedure LogEnd;
    procedure DequeueMessage(const QueueName, LastKnownID: String);
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
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
begin
  EnsureLogin;
  lJObj := fProxy.GetQueueSize(fToken, EditQueueName.Text);
  try
    Memo1.Lines.Add(lJObj.ToJSON());
  finally
    lJObj.Free;
  end;
end;

procedure TMainForm.btnDelQueueClick(Sender: TObject);
begin
  if MessageDlg('Are you sure?', mtConfirmation, mbYesNo, 0) <> mrYes then
    Exit;
  EnsureLogin;
  fProxy.DeleteQueue(fToken, EditQueueName.Text);
  Memo1.Lines.Add('CLIENT >> Queue Deleted');
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
  lRes: TJsonObject;
begin
  LogStart('send huge message');
  try
    EnsureLogin;

    lJObj := TJsonObject.Create;
    try
      lJObj.S['timestamp'] := TimeToStr(now);
      lJObj.I['sender_pid'] := fPID;
      lJObj.S['text'] := StringOfChar('*', 1024 * 10);
      lRes := fProxy.EnqueueMessage(fToken, EditQueueName.Text, lJObj.Clone);
      try
        Log(lRes.ToJSON);
      finally
        lRes.Free;
      end;
    finally
      lJObj.Free;
    end;
  finally
    LogEnd;
  end;
end;

procedure TMainForm.btnLastClick(Sender: TObject);
begin
  DequeueMessage(EditQueueName.Text, '__last__');
end;

procedure TMainForm.btnSendClick(Sender: TObject);
var
  lJObj: TJsonObject;
  lRes: TJsonObject;
begin
  LogStart('send single message');
  try
    EnsureLogin;
    lJObj := TJsonObject.Create;
    try
      lJObj.S['timestamp'] := TimeToStr(now);
      lJObj.I['sender_pid'] := fPID;
      lJObj.I['value'] := StrToInt(EditValue.Text);
      lRes := fProxy.EnqueueMessage(fToken, EditQueueName.Text, lJObj.Clone);
      try
        Log(lRes.ToJSON);
      finally
        lRes.Free;
      end;
      EditValue.Text := (lJObj.I['value'] + 1).ToString;
    finally
      lJObj.Free;
    end;
  finally
    LogEnd;
  end;
end;

procedure TMainForm.btnSendWithTTLClick(Sender: TObject);
var
  lJObj: TJsonObject;
  lRes: TJsonObject;
begin
  LogStart('send single message with TTL');
  try
    EnsureLogin;
    lJObj := TJsonObject.Create;
    try
      lJObj.S['timestamp'] := TimeToStr(now);
      lJObj.I['sender_pid'] := fPID;
      lJObj.I['value'] := StrToInt(EditValue.Text);
      lRes := fProxy.EnqueueMessageTTL(fToken, EditQueueName.Text, StrToInt(EditTTL.Text), lJObj.Clone);
      try
        Log(lRes.ToJSON);
      finally
        lRes.Free;
      end;

      EditValue.Text := (lJObj.I['value'] + 1).ToString;
    finally
      lJObj.Free;
    end;
  finally
    LogEnd;
  end;
end;

procedure TMainForm.btnMultipleWithTTLClick(Sender: TObject);
var
  lJObj: TJsonObject;
  I, lStart: Integer;
  lMessages: TJsonArray;
  lRes: TJsonObject;
const
  MESSAGES_COUNT = 10;
begin
  LogStart('send multiple message with TTL');
  try
    EnsureLogin;
    lMessages := TJsonArray.Create;
    try
      lStart := StrToInt(EditValue.Text);
      for I := lStart to lStart + MESSAGES_COUNT do
      begin
        lJObj := lMessages.AddObject;
        lJObj.S['queue'] := 'queue.sample' + IntToStr(I - lStart);
        lJObj.I['ttl'] := I - lStart + 1; // ttl = 0 means "no custom ttl"
        lJObj.O['message'].S['timestamp'] := TimeToStr(now);
        lJObj.O['message'].I['sender_pid'] := fPID;
        lJObj.O['message'].I['value'] := I;
      end;
      EditValue.Text := IntToStr(lStart + MESSAGES_COUNT + 1);
      lRes := fProxy.EnqueueMultipleMessages(fToken, lMessages.Clone);
      try
        Log(lRes.ToJSON);
      finally
        lRes.Free;
      end;
    finally
      lMessages.Free;
    end;
  finally
    LogEnd;
  end;
end;

procedure TMainForm.DequeueMessage(const QueueName, LastKnownID: String);
var
  lLastMgsID: string;
  lJMessage: TJsonObject;
begin
  EnsureLogin;
  LogStart('Dequeue ' + LastKnownID);
  try
    lLastMgsID := LastKnownID;
    try
      lJMessage := fProxy.DequeueMultipleMessage(fToken, QueueName, lLastMgsID, 1, StrToInt(EditTimeout.Text));
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
end;

procedure TMainForm.EnsureLogin;
var
  lJObj: TJsonObject;
begin
  if not Assigned(fProxy) then
  begin
    fProxy := TEventStreamsRPCProxy.Create(DMS_SERVER_URL + '/eventstreamsrpc');
    fProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
  end;

  if MinutesBetween(now, fLastLogin) > 10 then
  begin
    lJObj := fProxy.Login(DMS_USERNAME, DMS_PWD);
    try
      fToken := lJObj.S['token'];
      fLastLogin := now;
    finally
      lJObj.Free;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fLastLogin := 0;
  fToken := '';
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

procedure TMainForm.OnValidateCert(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
end;

end.
