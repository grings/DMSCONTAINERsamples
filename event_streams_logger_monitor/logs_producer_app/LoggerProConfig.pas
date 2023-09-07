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
    'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJETVNDb250YWluZXIiLCJleHAiOj'+'Q4MjQ1MTc1NDYsIm5iZiI6MTY3MDkxNzI0NiwiaWF0IjoxNjcwOTE3MjQ2LCJpc2FweWtleSI6IjEiLCJ1c2VyaWQiOiIxNzY'+'iLCJyb2xlcyI6ImV2ZW50X3dyaXRlciIsInVzZXJuYW1lIjoidXNlcl9ldmVudF93cml0ZXIiLCJjb250ZXh0cyI6IiJ9._PO6HZNgW0Rv'+'PeJjxSX--GHXPlbInZTX5wk0c-J_YoLYPQhjuQgqEKYl9fR4getBnF9xFXNzVNYSB5KytT0gAA';

var
  _Log: ILogWriter;
  DMSProxy: TEventStreamsRPCProxy;

function Log: ILogWriter;
begin
  Result := _Log;
end;

initialization

DefaultLoggerProAppenderQueueSize := 10;

DMSProxy := TEventStreamsRPCProxy.Create('https://localhost/eventstreamsrpc');
DMSProxy.IgnoreInvalidCert;

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
