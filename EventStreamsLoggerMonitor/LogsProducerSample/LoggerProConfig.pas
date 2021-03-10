unit LoggerProConfig;

interface

uses
  LoggerPro;

function Log: ILogWriter;

implementation

uses
  LoggerPro.DMSEventStreamsAppender, LoggerPro.RedisAppender, Redis.Client, WinApi.Windows,
  EventStreamsRPCProxy, System.Net.URLClient;

const
  DMSCONTAINER_API_KEY =
    'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJETVNDb250YWluZXIiLCJleHAiO'+
    'jQ3Njg5NjgzMDcsIm5iZiI6MTYxNTM2ODAwNywiaWF0IjoxNjE1MzY4MDA3LCJ1c2VyaWQiOiIx'+
    'NzciLCJyb2xlcyI6ImV2ZW50X3JlYWRlcixldmVudF93cml0ZXIiLCJjb250ZXh0cyI6IiIsImlz'+
    'YXB5a2V5IjoiMSIsInVzZXJuYW1lIjoidXNlcl9ldmVudCJ9.D7TfJWRPcLuAYJ96CthJv1uCopG'+
    'Qv1vuBcRlYiEhnYz_73TjbNBZ8QeZ38xsw2yAVXjDAJBIv22B8aRQcYK8Zw';

var
  _Log: ILogWriter;
  _Events: TLoggerProEventsHandler;
  DMSProxy: TEventStreamsRPCProxy;

type
  TAllowSelfSignedCertificates = class
  public
    class procedure OnValidateCertificate(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
  end;

function Log: ILogWriter;
begin
  Result := _Log;
end;

{ TAllowSelfSignedCertificates }

class procedure TAllowSelfSignedCertificates.OnValidateCertificate(
  const Sender: TObject; const ARequest: TURLRequest;
  const Certificate: TCertificate; var Accepted: Boolean);
begin
  Accepted := True; // just for demo! Check your certificates in production!
end;

initialization

_Events := TLoggerProEventsHandler.Create;
_Events.OnAppenderError :=
    procedure(const AppenderClassName: string; const aFailedLogItem: TLogItem; const Reason: TLogErrorReason;
    var Action: TLogErrorAction)
  begin
    Action := TLogErrorAction.SkipNewest;
    WinApi.Windows.Beep(800, 500);
  end;

DefaultLoggerProAppenderQueueSize := 10;

DMSProxy := TEventStreamsRPCProxy.Create('https://localhost/eventstreamsrpc');
DMSProxy.RPCExecutor.SetOnValidateServerCertificate(TAllowSelfSignedCertificates.OnValidateCertificate);

_Log := BuildLogWriter([TLoggerProDMSContainerAppender.Create(DMSProxy, DMSCONTAINER_API_KEY,
  'logs.' + TLoggerProDMSContainerAppender.GetModuleBaseName,
     dmsatByTag         {es logs.dmscontaineresappendersample.tag1}
  // dmsatByType        {es logs.dmscontaineresappendersample.debug}
  // dmsatByTagThenType {es logs.dmscontaineresappendersample.tag1.debug}
  // dmsatByTypeThenTag {es logs.dmscontaineresappendersample.debug.tag1}
  )], _Events);

finalization

_Log := nil;
_Events.Free;

end.
