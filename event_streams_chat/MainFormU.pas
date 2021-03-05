unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, EventStreamsRPCProxy, Vcl.StdCtrls,
  Vcl.ExtCtrls, System.Net.URLClient, EmojiSupportU, System.Threading;

type
  TMainForm = class(TForm)
    MemoChat: TMemo;
    Panel1: TPanel;
    Edit1: TEdit;
    btnSend: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSendClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    fUserName: string;
    fProxy: IEventStreamsRPCProxy;
    fToken: string;
    fReceiveTask: ITask;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}


uses JsonDataObjects, System.SyncObjs, MVCFramework.Logger;

var
  GShutDown: Int64 = 0;

procedure ScrollToLastLine(Memo: TMemo);
begin
  SendMessage(Memo.Handle, EM_LINESCROLL, 0, Memo.Lines.Count);
end;

procedure TMainForm.btnSendClick(Sender: TObject);
var
  lJObj: TJsonObject;
begin
  lJObj := TJsonObject.Create;
  try
    lJObj.S['text'] := Edit1.Text;
    fProxy.EnqueueMessage(fToken, 'queues.mychat', lJObj.Clone);
  finally
    lJObj.Free;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  lJObj: TJsonObject;
  I: Integer;
begin
  lJObj := TJsonObject.Create;
  try
    for I := 1 to 100 do
    begin
      lJObj.S['text'] := Format('%4d: %s', [I, Edit1.Text]);
      fProxy.EnqueueMessage(fToken, 'queues.mychat', lJObj.Clone);
    end;
  finally
    lJObj.Free;
  end;

end;

procedure TMainForm.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    btnSend.Click;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  TInterlocked.Increment(GShutDown);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  lJObj: TJsonObject;
begin
  fUserName := InputBox('User Name', 'Plese, write your user name', 'user_queue1');
  fProxy := TEventStreamsRPCProxy.Create('https://localhost/eventstreamsrpc');
  fProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
  lJObj := fProxy.Login(fUserName, 'pwd1');
  try
    fToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  fReceiveTask := TTask.Run(
    procedure
    var
      lProxy: TEventStreamsRPCProxy;
      lJObj: TJsonObject;
      lLastMgsID: string;
    begin
      lProxy := TEventStreamsRPCProxy.Create('https://localhost/eventstreamsrpc');
      try
        lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
        lLastMgsID := '__last__';
        while TInterlocked.Read(GShutDown) = 0 do
        begin
          try
            lJObj := lProxy.DequeueMessage(fToken, 'queues.mychat', lLastMgsID, 60);
          except
            Sleep(1000);
            Continue;
          end;
          try
            Log.Debug(lJObj.ToJSON(), 'es');
            if not lJObj.B['timeout'] then
            begin
              if lLastMgsID <> '__last__' then
              begin
                TThread.Synchronize(nil,
                  procedure
                  begin
                    MemoChat.Lines.Add(
                      lJObj.S['messageid'] + '|' +
                      lJObj.S['createdby'] + ': ' +
                      lJObj.O['message'].S['text']);
                    ScrollToLastLine(MemoChat);
                  end);
              end;
              lLastMgsID := lJObj.S['messageid'];
            end;
          finally
            lJObj.Free;
          end;
        end;
      finally
        lProxy.Free;
      end;
    end);
end;

procedure TMainForm.OnValidateCert(const Sender: TObject;
const ARequest: TURLRequest; const Certificate: TCertificate;
var Accepted: Boolean);
begin
  Accepted := True;
end;

end.
