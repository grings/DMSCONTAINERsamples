//------------------------------------------------------------------
// Proxy Unit Generated by Delphi Microservices Container 4.0.26
// Do not modify this unit!
// Generated at: 2021-03-08 10:32:34
//------------------------------------------------------------------
unit EventStreamsRPCProxy;

interface

uses
  System.SysUtils,
  System.Classes,
  MVCFramework.JSONRPC,
  MVCFramework.JSONRPC.Client,
  MVCFramework.Serializer.Commons,
  JsonDataObjects;

type
  IEventStreamsRPCProxy = interface
  ['{D1BDB45E-9470-4EDF-B3BD-C4DBE64A5B29}']
    function RPCExecutor: IMVCJSONRPCExecutor;
    /// <summary>
    /// Invokes [function Login(const UserName: string; const Password: string): TJsonObject]
    /// Returns the token (and others info) needed for other API calls.
    /// </summary>
    function Login(const UserName: string; const Password: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function RefreshToken(const Token: string): TJsonObject]
    /// Extends the expiration time of a still-valid token. Clients must use the token returned instead of the previous one.
    /// </summary>
    function RefreshToken(const Token: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function EnqueueMessage(const Token: string; const QueueName: string; Message: TJsonObject): TJsonObject]
    /// Pushes a Message in a Queue
    /// </summary>
    function EnqueueMessage(const Token: string; const QueueName: string; Message: TJsonObject): TJDOJsonObject;
    /// <summary>
    /// Invokes [function EnqueueMessageTTL(const Token: string; const QueueName: string; const TTL: UInt64; Message: TJsonObject): TJsonObject]
    /// Pushes a Message in a Queue with a custom TTL in minutes
    /// </summary>
    function EnqueueMessageTTL(const Token: string; const QueueName: string; const TTL: UInt64; Message: TJsonObject): TJDOJsonObject;
    /// <summary>
    /// Invokes [function EnqueueMultipleMessages(const Token: string; Messages: TJsonArray): TJsonObject]
    /// Atomically pushes multiple messages to multiple queues
    /// </summary>
    function EnqueueMultipleMessages(const Token: string; Messages: TJsonArray): TJDOJsonObject;
    /// <summary>
    /// Invokes [function DequeueMultipleMessage(const Token: string; const QueueName: string; LastKnownID: string; const MaxMessageCount: Integer; const TimeoutSec: Int64): TJsonObject]
    /// Dequeue one or more Messages from QueueName.
    /// LastKnownID can be "__last__" (get the last message), "__first__" (get the first message) or any
    /// MessageID previously retrieved (get the first message with MessageID greater the LastKnownID).
    /// MaxMessageCount is the max number of messages that should be returned by the method.
    /// If no message is available, it waits for TimeoutSec, then returns.
    /// Max allowed timeout is 10 minutes, min allowed timeout is 5 seconds
    /// </summary>
    function DequeueMultipleMessage(const Token: string; const QueueName: string; LastKnownID: string; const MaxMessageCount: Integer; const TimeoutSec: Int64): TJDOJsonObject;
    /// <summary>
    /// Invokes [function DequeueMessage(const Token: string; const QueueName: string; LastKnownID: string; const TimeoutSec: Int64): TJsonObject]
    /// Dequeue a single Message from QueueName.
    /// LastKnownID can be "__last__" (get the last message), "__first__" (get the first message) or any
    /// MessageID previously retrieved (get the first message with MessageID greater the LastKnownID).
    /// MaxMessageCount is the max number of messages that should be returned by the method.
    /// If no message is available, it waits for TimeoutSec, then returns.
    /// Max allowed timeout is 10 minutes, min allowed timeout is 5 seconds
    /// </summary>
    function DequeueMessage(const Token: string; const QueueName: string; LastKnownID: string; const TimeoutSec: Int64): TJDOJsonObject;
    /// <summary>
    /// Invokes [function GetNextMessageByTimestamp(const Token: string; const QueueName: string; TimeStamp: TDateTime; IsUTC: Boolean): TJsonObject]
    /// Get the next message, after timestamp, from QueueName.
    /// If no message is available just returns, there is no wait nor timeout.
    /// Usually called as first method to get the first LastKnownID
    /// </summary>
    function GetNextMessageByTimestamp(const Token: string; const QueueName: string; TimeStamp: TDateTime; IsUTC: Boolean): TJDOJsonObject;
    /// <summary>
    /// Invokes [procedure DeleteQueue(const Token: string; const QueueName: string)]
    /// Deletes queue named "QueueName"
    /// </summary>
    procedure DeleteQueue(const Token: string; const QueueName: string);
    /// <summary>
    /// Invokes [function GetQueuesInfo(const Token: string; const NameFilter: string): TJsonObject]
    /// Returns info about queues whose names starts with "NameFilter".
    /// If "NameFilter" is empty, all queues are returned
    /// </summary>
    function GetQueuesInfo(const Token: string; const NameFilter: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function GetQueueSize(const Token: string; const QueueName: string): TJsonObject]
    /// Returns the size (a.k.a. number of messages) of queue named "QueueName"
    /// </summary>
    function GetQueueSize(const Token: string; const QueueName: string): TJDOJsonObject;
  end;

  TEventStreamsRPCProxy = class(TInterfacedObject, IEventStreamsRPCProxy)
  protected
    fRPCExecutor: IMVCJSONRPCExecutor;
    function NewReqID: Int64;
  public
    function RPCExecutor: IMVCJSONRPCExecutor;
    constructor Create(const EndpointURL: String); virtual;
    /// <summary>
    /// Invokes [function Login(const UserName: string; const Password: string): TJsonObject]
    /// Returns the token (and others info) needed for other API calls.
    /// </summary>
    function Login(const UserName: string; const Password: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function RefreshToken(const Token: string): TJsonObject]
    /// Extends the expiration time of a still-valid token. Clients must use the token returned instead of the previous one.
    /// </summary>
    function RefreshToken(const Token: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function EnqueueMessage(const Token: string; const QueueName: string; Message: TJsonObject): TJsonObject]
    /// Pushes a Message in a Queue
    /// </summary>
    function EnqueueMessage(const Token: string; const QueueName: string; Message: TJsonObject): TJDOJsonObject;
    /// <summary>
    /// Invokes [function EnqueueMessageTTL(const Token: string; const QueueName: string; const TTL: UInt64; Message: TJsonObject): TJsonObject]
    /// Pushes a Message in a Queue with a custom TTL in minutes
    /// </summary>
    function EnqueueMessageTTL(const Token: string; const QueueName: string; const TTL: UInt64; Message: TJsonObject): TJDOJsonObject;
    /// <summary>
    /// Invokes [function EnqueueMultipleMessages(const Token: string; Messages: TJsonArray): TJsonObject]
    /// Atomically pushes multiple messages to multiple queues
    /// </summary>
    function EnqueueMultipleMessages(const Token: string; Messages: TJsonArray): TJDOJsonObject;
    /// <summary>
    /// Invokes [function DequeueMultipleMessage(const Token: string; const QueueName: string; LastKnownID: string; const MaxMessageCount: Integer; const TimeoutSec: Int64): TJsonObject]
    /// Dequeue one or more Messages from QueueName.
    /// LastKnownID can be "__last__" (get the last message), "__first__" (get the first message) or any
    /// MessageID previously retrieved (get the first message with MessageID greater the LastKnownID).
    /// MaxMessageCount is the max number of messages that should be returned by the method.
    /// If no message is available, it waits for TimeoutSec, then returns.
    /// Max allowed timeout is 10 minutes, min allowed timeout is 5 seconds
    /// </summary>
    function DequeueMultipleMessage(const Token: string; const QueueName: string; LastKnownID: string; const MaxMessageCount: Integer; const TimeoutSec: Int64): TJDOJsonObject;
    /// <summary>
    /// Invokes [function DequeueMessage(const Token: string; const QueueName: string; LastKnownID: string; const TimeoutSec: Int64): TJsonObject]
    /// Dequeue a single Message from QueueName.
    /// LastKnownID can be "__last__" (get the last message), "__first__" (get the first message) or any
    /// MessageID previously retrieved (get the first message with MessageID greater the LastKnownID).
    /// MaxMessageCount is the max number of messages that should be returned by the method.
    /// If no message is available, it waits for TimeoutSec, then returns.
    /// Max allowed timeout is 10 minutes, min allowed timeout is 5 seconds
    /// </summary>
    function DequeueMessage(const Token: string; const QueueName: string; LastKnownID: string; const TimeoutSec: Int64): TJDOJsonObject;
    /// <summary>
    /// Invokes [function GetNextMessageByTimestamp(const Token: string; const QueueName: string; TimeStamp: TDateTime; IsUTC: Boolean): TJsonObject]
    /// Get the next message, after timestamp, from QueueName.
    /// If no message is available just returns, there is no wait nor timeout.
    /// Usually called as first method to get the first LastKnownID
    /// </summary>
    function GetNextMessageByTimestamp(const Token: string; const QueueName: string; TimeStamp: TDateTime; IsUTC: Boolean): TJDOJsonObject;
    /// <summary>
    /// Invokes [procedure DeleteQueue(const Token: string; const QueueName: string)]
    /// Deletes queue named "QueueName"
    /// </summary>
    procedure DeleteQueue(const Token: string; const QueueName: string);
    /// <summary>
    /// Invokes [function GetQueuesInfo(const Token: string; const NameFilter: string): TJsonObject]
    /// Returns info about queues whose names starts with "NameFilter".
    /// If "NameFilter" is empty, all queues are returned
    /// </summary>
    function GetQueuesInfo(const Token: string; const NameFilter: string): TJDOJsonObject;
    /// <summary>
    /// Invokes [function GetQueueSize(const Token: string; const QueueName: string): TJsonObject]
    /// Returns the size (a.k.a. number of messages) of queue named "QueueName"
    /// </summary>
    function GetQueueSize(const Token: string; const QueueName: string): TJDOJsonObject;
end;

implementation

uses
  System.Net.URLClient,
  System.RTTI;

constructor TEventStreamsRPCProxy.Create(const EndpointURL: String);
begin
  inherited Create;
  fRPCExecutor := TMVCJSONRPCExecutor.Create(EndpointURL);
  fRPCExecutor.AddHTTPHeader(TNetHeader.Create('Accept-Encoding', 'gzip'));
  fRPCExecutor.AddHTTPHeader(TNetHeader.Create('User-Agent', 'dmscontainer-delphi-proxy'));

end;

function TEventStreamsRPCProxy.NewReqID: Int64;
begin
  Result := 10000 + Random(10000000);
end;

function TEventStreamsRPCProxy.RPCExecutor: IMVCJSONRPCExecutor;
begin
  Result := fRPCExecutor;
end;


function TEventStreamsRPCProxy.Login(const UserName: string; const Password: string): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'Login');
  lReq.Params.Add(UserName);
  lReq.Params.Add(Password);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TEventStreamsRPCProxy.RefreshToken(const Token: string): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'RefreshToken');
  lReq.Params.Add(Token);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TEventStreamsRPCProxy.EnqueueMessage(const Token: string; const QueueName: string; Message: TJsonObject): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'EnqueueMessage');
  lReq.Params.Add(Token);
  lReq.Params.Add(QueueName);
  lReq.Params.Add(Message);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TEventStreamsRPCProxy.EnqueueMessageTTL(const Token: string; const QueueName: string; const TTL: UInt64; Message: TJsonObject): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'EnqueueMessageTTL');
  lReq.Params.Add(Token);
  lReq.Params.Add(QueueName);
  lReq.Params.Add(TTL, TJSONRPCParamDataType.pdtLongInteger);
  lReq.Params.Add(Message);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TEventStreamsRPCProxy.EnqueueMultipleMessages(const Token: string; Messages: TJsonArray): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'EnqueueMultipleMessages');
  lReq.Params.Add(Token);
  lReq.Params.Add(Messages);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TEventStreamsRPCProxy.DequeueMultipleMessage(const Token: string; const QueueName: string; LastKnownID: string; const MaxMessageCount: Integer; const TimeoutSec: Int64): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'DequeueMultipleMessage');
  lReq.Params.Add(Token);
  lReq.Params.Add(QueueName);
  lReq.Params.Add(LastKnownID);
  lReq.Params.Add(MaxMessageCount);
  lReq.Params.Add(TimeoutSec, TJSONRPCParamDataType.pdtLongInteger);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TEventStreamsRPCProxy.DequeueMessage(const Token: string; const QueueName: string; LastKnownID: string; const TimeoutSec: Int64): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'DequeueMessage');
  lReq.Params.Add(Token);
  lReq.Params.Add(QueueName);
  lReq.Params.Add(LastKnownID);
  lReq.Params.Add(TimeoutSec, TJSONRPCParamDataType.pdtLongInteger);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TEventStreamsRPCProxy.GetNextMessageByTimestamp(const Token: string; const QueueName: string; TimeStamp: TDateTime; IsUTC: Boolean): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'GetNextMessageByTimestamp');
  lReq.Params.Add(Token);
  lReq.Params.Add(QueueName);
  lReq.Params.Add(TimeStamp);
  lReq.Params.Add(IsUTC);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


procedure TEventStreamsRPCProxy.DeleteQueue(const Token: string; const QueueName: string);
var
  lNotification: IJSONRPCNotification;
begin
  lNotification := TJSONRPCNotification.Create('DeleteQueue');
  lNotification.Params.Add(Token);
  lNotification.Params.Add(QueueName);
  fRPCExecutor.ExecuteNotification(lNotification);
end;


function TEventStreamsRPCProxy.GetQueuesInfo(const Token: string; const NameFilter: string): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'GetQueuesInfo');
  lReq.Params.Add(Token);
  lReq.Params.Add(NameFilter);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;


function TEventStreamsRPCProxy.GetQueueSize(const Token: string; const QueueName: string): TJDOJsonObject;
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
begin
  lReq := TJSONRPCRequest.Create(NewReqID, 'GetQueueSize');
  lReq.Params.Add(Token);
  lReq.Params.Add(QueueName);
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  Result := lResp.ResultAsJSONObject.Clone as TJDOJsonObject; //TJsonObject
end;

end.
