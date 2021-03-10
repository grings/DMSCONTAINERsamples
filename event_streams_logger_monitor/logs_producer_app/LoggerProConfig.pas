unit LoggerProConfig;

interface

uses
  LoggerPro;

function Log: ILogWriter;

implementation

uses
  LoggerPro.DMSEventStreamsAppender,
  EventStreamsRPCProxy, System.Net.URLClient;

const
  DMSCONTAINER_API_KEY =
    'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJETVNDb250YWluZXIiLCJleHAiOjQ3NjkwMDcwNjMsIm5iZiI6MTYxNTQ' +
    'wNjc2MywiaWF0IjoxNjE1NDA2NzYzLCJ1c2VyaWQiOiIxNzciLCJyb2xlcyI6ImV2ZW50X3JlYWRlcixldmVudF93cml0ZXIiLCJjb25' +
    '0ZXh0cyI6IiIsImlzYXB5a2V5IjoiMSIsInVzZXJuYW1lIjoidXNlcl9ldmVudCJ9.bLxhcQpGDJeale0hIsKxFbx645aW2IDHyCd4lh4' +
    'VoK7NmVesCOFWCaxgnrUzFt8d4n8ajr6DAOFDEoZLZv4Sdg';

var
  _Log: ILogWriter;
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

DefaultLoggerProAppenderQueueSize := 10;

DMSProxy := TEventStreamsRPCProxy.Create('https://localhost/eventstreamsrpc');
DMSProxy.RPCExecutor.SetOnValidateServerCertificate(TAllowSelfSignedCertificates.OnValidateCertificate);

_Log := BuildLogWriter([TLoggerProDMSContainerAppender.Create(DMSProxy, DMSCONTAINER_API_KEY,
  'logs.' + TLoggerProDMSContainerAppender.GetModuleBaseName,
     dmsatByTag         {es logs.dmscontaineresappendersample.tag1}
  // dmsatByType        {es logs.dmscontaineresappendersample.debug}
  // dmsatByTagThenType {es logs.dmscontaineresappendersample.tag1.debug}
  // dmsatByTypeThenTag {es logs.dmscontaineresappendersample.debug.tag1}
  )]);

finalization

_Log := nil;

end.
