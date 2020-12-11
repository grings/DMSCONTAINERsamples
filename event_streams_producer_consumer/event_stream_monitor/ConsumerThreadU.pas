unit ConsumerThreadU;

interface

uses
  System.Classes, System.Generics.Collections, System.Net.URLClient,
  EventStreamsRPCProxy;

type
  TConsumerThread = class(TThread)
  private
    fQueue: TThreadedQueue<TPair<Integer, String>>;
    fIndex: Integer;
    fChannelQueue: string;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
    function GetToken(const Proxy: TEventStreamsRPCProxy): String;
  protected
    procedure Execute; override;
  public
    constructor Create(const Index: Integer; const QueueName: String;
      ChannelQueue: TThreadedQueue < TPair < Integer, String >> );
  end;

var
  GShutDown: Int64 = 0;

implementation

uses
  System.SyncObjs, JsonDataObjects,
  System.SysUtils, MVCFramework.Logger;

{ TConsumerThread }

constructor TConsumerThread.Create(const Index: Integer;
  const QueueName: String; ChannelQueue: TThreadedQueue < TPair < Integer,
  String >> );
begin
  inherited Create(True);
  fQueue := ChannelQueue;
  fIndex := Index;
  fChannelQueue := QueueName;
end;

procedure TConsumerThread.Execute;
var
  lProxy: TEventStreamsRPCProxy;
  lJObj: TJsonObject;
  lLastMgsID: string;
  lMsgCount: UInt64;
  lToken: string;
  lText: String;
  lItem: TPair<Integer, String>;
begin
  inherited;
  lMsgCount := 0;
  lProxy := TEventStreamsRPCProxy.Create('https://localhost/eventstreamsrpc');
  try
    lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
    lLastMgsID := '__last__';
    lToken := GetToken(lProxy);
    while TInterlocked.Read(GShutDown) = 0 do
    begin
      try
        lJObj := lProxy.DequeueMultipleMessage(lToken, fChannelQueue, lLastMgsID, 10, 5);
      except
        on E: Exception do
        begin
          if E.Message.Contains('-32004') then
          begin
            lToken := GetToken(lProxy);
          end;
          Sleep(1000);
          Continue;
        end;
      end;
      try
        if not lJObj.B['timeout'] then
        begin
          //Log.Debug(lJObj.ToJSON(), fIndex.ToString.PadLeft(4, '0'));
          Inc(lMsgCount, lJObj.A['data'].Count);
          lLastMgsID := lJObj.A['data'][lJObj.A['data'].Count-1].ObjectValue.S['messageid'];
          lText := lMsgCount.ToString + '|' + lLastMgsID;
          lItem := TPair<Integer, String>.Create(fIndex, lText);
          if fQueue.PushItem(lItem) <> TWaitResult.wrSignaled then
          begin
            raise Exception.Create('Cannot push message');
          end;
        end;
      finally
        lJObj.Free;
      end;
    end;
  finally
    lProxy.Free;
  end;

end;

function TConsumerThread.GetToken(const Proxy: TEventStreamsRPCProxy): String;
var
  lJObjLogin: TJsonObject;
begin
  Result := '';
  lJObjLogin := nil;
  try
    lJObjLogin := Proxy.Login('user_event', 'pwd1');
  except
  end;
  try
    Result := lJObjLogin.S['token'];
  finally
    lJObjLogin.Free;
  end;
end;

procedure TConsumerThread.OnValidateCert(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
end;

end.
