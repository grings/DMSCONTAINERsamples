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
    'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJETVNDb250YWluZXIiLCJleHAiOjQ3OD' +
    'g5MzM2MjksIm5iZiI6MTYzNTMzMzMyOSwiaWF0IjoxNjM1MzMzMzI5LCJpc2FweWtleSI6IjEiLCJ1c' +
    '2VyaWQiOiIxNzciLCJyb2xlcyI6ImV2ZW50X3JlYWRlcixldmVudF93cml0ZXIiLCJ1c2VybmFtZSI6' +
    'InVzZXJfZXZlbnQiLCJjb250ZXh0cyI6IiJ9.cg-VTq83-2EUExwpZ_nVcuekpFaR3aLCqqHfHixQH_' +
    'Vny3AtAxUd_o9rt66NXMig0bJTSnQwaYRfjSmTYqJAYg';

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
