unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SynchUtilsRPCProxy,
  Vcl.ExtCtrls, System.DateUtils, Vcl.Mask;

type
  TMainForm = class(TForm)
    btnAcquireLock: TButton;
    btnTTL: TButton;
    Memo1: TMemo;
    btnReleaseLock: TButton;
    Timer1: TTimer;
    ListBox1: TListBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    btnGetLockData: TButton;
    btnManyLocks: TButton;
    Panel2: TPanel;
    edtLockIdentifier: TLabeledEdit;
    btnExtendLock: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAcquireLockClick(Sender: TObject);
    procedure btnTTLClick(Sender: TObject);
    procedure btnReleaseLockClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnGetLockDataClick(Sender: TObject);
    procedure btnManyLocksClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExtendLockClick(Sender: TObject);
  private
    fUserName, fPassword: String;
    fTerminated: Boolean;
    fBGThread: TThread;
    fProxy: ISynchUtilsRPCProxy;
    fToken: String;
    fLockHandle: String;
    function GetLockIdentifier: String;
    procedure StartBGThread;
    function HideToken(const Value: String): String;
  public

  end;

  TBGThread = class(TThread)
  protected
    fProc: TProc;
    fSecondsInterval: UInt32;
    procedure Execute; override;
  public
    constructor Create(const Proc: TProc; const SecondsInterval: UInt32 = 5);
  end;

var
  MainForm: TMainForm;

{$R *.dfm}

implementation

uses
  JsonDataObjects, MVCFramework.JSONRPC, System.Threading, System.RegularExpressions,
  LoggerProConfig, LoginFormU, System.Net.HttpClient;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fBGThread.Terminate;
  if WaitForSingleObject(fBGThread.Handle, 30000) = WAIT_TIMEOUT then
  begin
    ShowMessage('Cannot stop the background thread...');
  end
  else
  begin
    fBGThread.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fTerminated := False;
  fProxy := TSynchUtilsRPCProxy.Create('https://localhost/synchutilsrpc');
  fProxy.RPCExecutor.SetOnSendCommand(
    procedure (JSONRPC: IJSONRPCObject)
    begin
      var lValue := HideToken(JSONRPC.ToString(True));
      Log.Info('>> SEND | ' + HideToken(JSONRPC.ToString(True)), 'timer');
      Memo1.Lines.Add('>> SEND');
      Memo1.Lines.Add(lValue);
    end);
  fProxy.RPCExecutor.SetOnReceiveResponse(
    procedure (JSONRPC1: IJSONRPCObject; JSONRPC2: IJSONRPCObject)
    begin
      Memo1.Lines.Add('>> RESPONSE');
      Memo1.Lines.Add(JSONRPC2.ToString(True));
    end);

  fProxy.IgnoreInvalidCert;


  fToken := '';
  while TLoginForm.Execute(fUserName, fPassword) do
  begin
    try
      var lJSON := fProxy.Login(fUserName, fPassword);
      try
        fToken := lJSON.S['token'];
      finally
        lJSON.Free;
      end;
      Break;
    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
      end;
    end;
  end;
  if fToken.IsEmpty then
  begin
    Application.Terminate;
  end
  else
  begin
    Caption := Caption + ' [user: ' + fUserName + ']';
    StartBGThread;
  end;
end;

function TMainForm.GetLockIdentifier: String;
begin
  Result := String(edtLockIdentifier.Text).Trim;
end;

function TMainForm.HideToken(const Value: String): String;
begin
  Result := TRegEx.Replace(Value, '\["[a-z,A-Z,0-9,\.,_,\-]+",', '[<thetoken>,');
end;

procedure TMainForm.StartBGThread;
begin
  fBGThread := TBGThread.Create(procedure
  begin
    var lProxy: ISynchUtilsRPCProxy := TSynchUtilsRPCProxy.Create('https://localhost/synchutilsrpc');
    lProxy.RPCExecutor.ConfigureHTTPClient(
      procedure (HTTPClient: THTTPClient)
      begin
        HTTPClient.ConnectionTimeout := 10000;
        HTTPClient.SendTimeout := 10000;
      end);
    lProxy.RPCExecutor.SetOnSendCommand(
      procedure (JSONRPC: IJSONRPCObject)
      begin
        var lValue := HideToken(JSONRPC.ToString(True));
        Log.Info('>> SEND | ' + HideToken(JSONRPC.ToString(True)), 'timer');
      end);
    lProxy.RPCExecutor.SetOnReceiveResponse(
      procedure (JSONRPC1: IJSONRPCObject; JSONRPC2: IJSONRPCObject)
      begin
        Log.Info('>> RESPONSE | ' + JSONRPC2.ToString(True), 'timer');
      end);
    lProxy.IgnoreInvalidCert;
    try
      var lJ := lProxy.GetLocks(fToken);
      try
        TThread.Synchronize(nil,
          procedure
          begin
            ListBox1.Items.BeginUpdate;
            try
              ListBox1.Items.Clear;
              if lJ.A['locks'].Count = 0 then
              begin
                ListBox1.Items.Add('-- There aren''t locks --');
              end
              else
              begin
                ListBox1.Items.Add(Format('%-28s | %s', ['Lock Identifier', 'Expires In']));
                ListBox1.Items.Add(StringOfChar('-', 40));
                for var I := 0 to lJ.A['locks'].Count - 1 do
                begin
                  ListBox1.Items.Add(Format('%-28s | %5d sec',
                    [lJ.A['locks'][I].S['identifier'],
                    lJ.A['locks'][I].L['expires_in']]));
                end;
              end;
            finally
              ListBox1.Items.EndUpdate;
            end;
          end);
      finally
        lJ.Free;
      end;
    except
    end;
  end, 3);
end;

procedure TMainForm.btnAcquireLockClick(Sender: TObject);
begin
  var lJSON := TJsonObject.Create;
  lJSON.S['reason'] := 'because I can';
  lJSON.DUtc['locked_since'] := Now();
  var lLockHandle := fProxy.TryAcquireLock(fToken, GetLockIdentifier, 60, lJSON);
  if lLockHandle <> 'error' then
  begin
    fLockHandle := lLockHandle; {let's save the lockhandle for subsequent calls}
    Log.Info('Lock Acquired', 'locks')
  end
  else
  begin
    Log.Info('Lock Not Acquired', 'locks');
    ShowMessage('Cannot acquire lock ' + GetLockIdentifier);
  end;
end;

procedure TMainForm.btnExtendLockClick(Sender: TObject);
begin
  if fProxy.ExtendLock(fToken, 30, fLockHandle) then
  begin
    ShowMessage('Lock Extended');
    Log.Info('Lock Extended', 'locks')
  end
  else
  begin
    Log.Info('Lock Not Extended', 'locks');
    ShowMessage('Cannot extend lock ' + GetLockIdentifier);
  end;
end;

procedure TMainForm.btnGetLockDataClick(Sender: TObject);
begin
  var lLockData := fProxy.GetLockData(fToken, GetLockIdentifier);
  try
    Log.Info('GetLockData [LOCKID: %s][DATA: %s]', [GetLockIdentifier, lLockData.ToJSON(True)], 'locks');
  finally
    lLockData.Free;
  end;
end;

procedure TMainForm.btnManyLocksClick(Sender: TObject);
begin
  var PID := GetCurrentProcessId;
  var LockIdentifier := 'lock_pid_' + PID.ToString + '_' + FormatDateTime('hh_nn_ss', Now) + '_';
  Log.Info('ANOTHER SHOT OF LOCKS! ' + LockIdentifier, 'timer');
  for var I := 1 to 10 do
  begin
    try
      var lockid := LockIdentifier + I.ToString;
      var lJSON := tjsonobject.Create;
      lJSON.D['lock_start'] := Now();
      if fProxy.TryAcquireLock(fToken, lockid, 5 + Random(30), lJSON) <> 'error' then
        Log.Info('Lock Acquired ' + lockid, 'timer')
      else
        Log.Info('Lock Not Acquired ' + lockid, 'timer');
    except
      on E: Exception do
      begin
        Log.Error('ERROR: ' + E.Message, 'timer');
      end;
    end;
  end;

end;

procedure TMainForm.btnReleaseLockClick(Sender: TObject);
begin
  var lLockReleased := fProxy.ReleaseLock(fToken, fLockHandle);
  try
    Log.Info('ReleaseLock: ' + lLockReleased.ToString
      (TUseBoolStrs.True), 'locks');
  except
    on E: Exception do
    begin
      Log.Info(E.Message, 'locks');
    end;
  end;
end;

procedure TMainForm.btnTTLClick(Sender: TObject);
var
  lLockExpiration: Int64;
begin
  try
    lLockExpiration := fProxy.GetLockExpiration(fToken, GetLockIdentifier);
    if lLockExpiration = -1 then
    begin
      Memo1.Lines.Add('GetLockExpiration: lock doesn''t exist');
      Log.Info('GetLockExpiration: lock doesn''t exist', 'locks');
    end
    else
    begin
      Memo1.Lines.Add('GetLockExpiration: ' + lLockExpiration.ToString + ' sec');
      Log.Info('GetLockExpiration: ' + lLockExpiration.ToString + ' sec', 'locks');
    end;
  except
    on E: Exception do
    begin
      Log.Info(E.Message, 'locks');
    end;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  if SecondOf(Now) < 5 then
  begin
    Log.Info('Refreshing token...', 'timer');
    var lJ := fProxy.RefreshToken(fToken);
    try
      fToken := lJ.S['token'];
    finally
      lJ.Free;
    end;
  end;
end;

{ TBGThread }

constructor TBGThread.Create(const Proc: TProc; const SecondsInterval: UInt32);
begin
  fProc := Proc;
  fSecondsInterval := SecondsInterval;
  inherited Create(False);
end;

procedure TBGThread.Execute;
begin
  inherited;
  var lLastRun: TDateTime := 0;
  while not Terminated do
  begin
    if SecondsBetween(lLastRun, Now) < fSecondsInterval then
    begin
      Sleep(600);
      Continue;
    end;
    lLastRun := Now;
    try
      fProc();
    except
      on E: Exception do
        Log.Error('BGThread: %s: %s', [E.ClassName, E.Message], 'bgthread');
    end;
  end; //while
end;

end.
