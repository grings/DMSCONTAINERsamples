unit WorkerU;

interface

uses
  System.Net.URLClient, EventStreamsRPCProxy;

type
  TWorker = class
  private
    fUserName: string;
    fPassword: string;
    fQueueName: string;
  protected
    fProxy: TEventStreamsRPCProxy;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
    function GetToken: string;
  public
    constructor Create(const UserName, Password, QueueName: string);
    destructor Destroy; override;
    procedure Execute;
  end;

implementation

uses
  MVCFramework.Console, JsonDataObjects, MVCFramework.Logger, System.SysUtils,
  System.Net.HttpClient;

{ TWorker }

constructor TWorker.Create(const UserName, Password, QueueName: string);
begin
  inherited Create;
  fUserName := UserName;
  fPassword := Password;
  fQueueName := QueueName;
  fProxy := TEventStreamsRPCProxy.Create('https://localhost/eventstreamsrpc');
  fProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
end;

destructor TWorker.Destroy;
begin
  fProxy.Free;
  inherited;
end;

procedure TWorker.Execute;
var
  lJObj: TJsonObject;
  lToken: string;
  lLastMgsID: string;
begin
  SaveColors;
  fProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
  lToken := GetToken;
  ResetConsole;

  lLastMgsID := '__last__';
  while True do
  begin
    try
      if lToken.IsEmpty then
      begin
        lToken := GetToken;
      end;

      lJObj := fProxy.DequeueMultipleMessage(lToken, fQueueName, lLastMgsID, 1, 60);
      try
        Log.Debug(lJObj.ToJSON(), 'es');
        if not lJObj.B['timeout'] then
        begin
          TextColor(Yellow);
          Writeln(lJObj.ToJSON);
          lLastMgsID := lJObj.S['messageid'];
        end
        else
        begin
          TextColor(Red);
          Writeln('No new messages...');
          Sleep(500);
        end;
      finally
        lJObj.Free;
      end;
    except
      on E: Exception do
      begin
        Writeln(E.ClassName + ': ' + E.Message);
        lToken := '';
        Sleep(1000);
      end;
    end;
  end;
end;

function TWorker.GetToken: string;
var
  lJObj: TJsonObject;
begin
  while True do
  begin
    try
      TextColor(White);
      write('Connecting to server...');
      lJObj := fProxy.Login(fUserName, fPassword);
      try
        Result := lJObj.S['token'];
        TextColor(Green);
        Writeln('OK');
      finally
        lJObj.Free;
      end;
      break;
    except
      on Ex: ENetHTTPClientException do
      begin
        TextColor(Red);
        Writeln('KO');
        Sleep(5000);
      end;
    end;
  end;
end;

procedure TWorker.OnValidateCert(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
end;

end.
