unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, EventStreamsRPCProxy, Vcl.StdCtrls,
  Vcl.ExtCtrls, System.Net.URLClient, System.Threading;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    EditQueueName: TEdit;
    MemoMessage: TMemo;
    Panel3: TPanel;
    Timer1: TTimer;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    fProxy: TEventStreamsRPCProxy;
    fRunningTasks: TArray<ITask>;
    fLastTokenTimeStamp: TDateTime;
    fToken: string;
    function GetToken: String;
    function StartTask(const MessagesCount: Integer): Integer;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
    function MakeProducer(const MessagesCount: Integer;
      const Token, QueueName, MessageText: String): TProc;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

const
  ENDPOINT = 'https://localhost/eventstreamsrpc';

implementation

{$R *.dfm}

uses JsonDataObjects, System.SyncObjs, MVCFramework.Logger,
  System.TimeSpan, System.UITypes, System.DateUtils;

var
  GShutDown: Int64 = 0;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  (Sender as TControl).Tag := StartTask(10);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  (Sender as TControl).Tag := StartTask(100);
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  lJObj: TJsonObject;
  lToken: string;
begin
  if MessageDlg('Are you sure?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    lJObj := fProxy.Login('user_admin', 'pwd1');
    try
      lToken := lJObj.S['token'];
    finally
      lJObj.Free;
    end;
    fProxy.DeleteQueue(lToken, EditQueueName.Text);
  end;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  (Sender as TControl).Tag := StartTask(1);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  TInterlocked.Increment(GShutDown);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fLastTokenTimeStamp := 0;
  fProxy := TEventStreamsRPCProxy.Create(ENDPOINT);
  fProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
end;

function TMainForm.GetToken: String;
var
  lJObj: TJsonObject;
begin
  if MinutesBetween(Now, fLastTokenTimeStamp) > 5 then
  begin
    lJObj := fProxy.Login('user_event', 'pwd1');
    try
      fToken := lJObj.S['token'];
      fLastTokenTimeStamp := Now;
    finally
      lJObj.Free;
    end;
  end;
  Result := fToken;
end;

function TMainForm.MakeProducer(const MessagesCount: Integer;
  const Token, QueueName, MessageText: String): TProc;
var
  lJObj: TJsonObject;
  lJArr: TJsonArray;
begin
  lJObj := TJsonObject.Parse(MessageText) as TJsonObject;
  try
    // do nothing
  finally
    lJObj.Free;
  end;
  Result := procedure
    var
      lProxy: TEventStreamsRPCProxy;
      lJObj: TJsonObject;
    begin
      lProxy := TEventStreamsRPCProxy.Create(ENDPOINT);
      try
        lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);

        lJArr := TJsonArray.Create;
        try
          //var lItem := TJsonObject.Parse(MessageText) as TJsonObject;
          for var I := 1 to MessagesCount do
          begin
            lJObj := TJsonObject.Create;
            lJArr.Add(lJObj);
            lJObj.S['queue'] := QueueName;
            lJObj.O['message'] := TJsonObject.Parse(MessageText) as TJsonObject;
            lJObj.O['message'].I['msg_number'] := I;
          end;
          lProxy.EnqueueMultipleMessages(Token, lJArr.Clone);
        finally
          lJArr.Free;
        end;
      finally
        lProxy.Free;
      end;
    end;
end;

procedure TMainForm.OnValidateCert(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
end;

function TMainForm.StartTask(const MessagesCount: Integer): Integer;
var
  lProducer: TProc;
  lTask: ITask;
  lToken: String;
begin
  lToken := GetToken;
  lProducer := MakeProducer(MessagesCount, lToken, EditQueueName.Text,
    MemoMessage.Lines.Text);
  lTask := TTask.Run(lProducer);
  fRunningTasks := fRunningTasks + [lTask];
  Result := lTask.Id;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  var
  lRes := TTask.WaitForAny(fRunningTasks, TTimeSpan.FromMilliseconds(100));
  if lRes > -1 then
  begin
    Caption := 'Terminated ID: ' + fRunningTasks[lRes].Id.ToString;
    Delete(fRunningTasks, lRes, 1);
  end;
  Label1.Caption := 'Running Tasks: ' + Length(fRunningTasks).ToString;
end;

end.
