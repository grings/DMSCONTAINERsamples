unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, EventStreamsRPCProxy, Vcl.StdCtrls,
  Vcl.ExtCtrls, System.Net.URLClient, System.Threading;

type
  TMainForm = class(TForm)
    Panel2: TPanel;
    MemoMessage: TMemo;
    Panel3: TPanel;
    Timer1: TTimer;
    EditQueueName: TEdit;
    btnStartStop: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
  private
    fProxy: TEventStreamsRPCProxy;
    fToken: string;
    fCurrentTask: ITask;
    function StartTask: ITask;
    procedure StopTask;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
    function MakeConsumer(const Token, QueueName: String): TProc;
    procedure Log(const Msg: String);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

const
  ENDPOINT = 'https://localhost/eventstreamsrpc';

  SYM_START = 'Start ▶';
  SYM_STOP = 'Stop ⏹';

implementation

{$R *.dfm}

uses JsonDataObjects, System.SyncObjs, MVCFramework.Logger, System.TimeSpan;

var
  GShutDown: Int64 = 0;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  if Assigned(fCurrentTask) then
  begin
    StopTask;
  end
  else
  begin
    fCurrentTask := StartTask();
    btnStartStop.Caption := SYM_STOP;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  TInterlocked.Increment(GShutDown);
  StopTask;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  lJObj: TJsonObject;
begin
  fProxy := TEventStreamsRPCProxy.Create(ENDPOINT);
  fProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
  lJObj := fProxy.Login('user_event', 'pwd1');
  try
    fToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;
  btnStartStop.Caption := SYM_START;
end;

procedure TMainForm.Log(const Msg: String);
var
  lStr: String;
begin
  lStr := Format('%s: %s', [DateTimeToStr(now), Msg]);
  TThread.Queue(nil,
    procedure
    begin
      MemoMessage.Lines.Add(lStr);
    end);
end;

function TMainForm.MakeConsumer(const Token, QueueName: String): TProc;
begin
  Result := procedure
    var
      lProxy: TEventStreamsRPCProxy;
      lJSON: TJsonObject;
      lLastKnownID: String;
    I: Integer;
    begin
      lProxy := TEventStreamsRPCProxy.Create(ENDPOINT);
      try
        lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
        lLastKnownID := '__last__';
        while TTask.CurrentTask.Status <> TTaskStatus.Canceled do
        begin
          try
            lJSON := lProxy.DequeueMultipleMessage(Token, QueueName,
              lLastKnownID, 10, 10);
            try
              if TTask.CurrentTask.Status = TTaskStatus.Canceled then
              begin
                Break;
              end;
              if lJSON.B['timeout'] then
              begin
                Log('Timeout');
              end
              else
              begin
                for I := 0 to lJSON.A['data'].Count-1 do
                begin
                  lLastKnownID := lJSON.A['data'][I].ObjectValue.S['messageid'];
                  Log(lJSON.A['data'][I].ObjectValue.ToJSON(true));
                end;
              end;
            finally
              lJSON.Free;
            end;
          except
            Sleep(1000);
          end;
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
  Accepted := true;
end;

function TMainForm.StartTask: ITask;
var
  lConsumer: TProc;
begin
  MemoMessage.Lines.Add('** CONSUMER START **');
  lConsumer := MakeConsumer(fToken, EditQueueName.Text);
  Result := TTask.Run(lConsumer);
end;

procedure TMainForm.StopTask;
begin
  if Assigned(fCurrentTask) then
  begin
    MemoMessage.Lines.Add('** CONSUMER STOP **');
    fCurrentTask.Cancel;
    while not(fCurrentTask.Status in [TTaskStatus.Completed,
      TTaskStatus.Canceled]) do
    begin
      Sleep(200);
      Application.ProcessMessages;
    end;
    fCurrentTask := nil;
  end;
  btnStartStop.Caption := SYM_START;
end;

end.
