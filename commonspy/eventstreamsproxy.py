#------------------------------------------------------------------
# Proxy Script Generated by Delphi Microservices Container 4.1.40
# Do not modify this code!
# Generated at: 2021-10-27 23:29:59
#------------------------------------------------------------------

import requests
import urllib3

urllib3.disable_warnings()

class EventStreamsRPCException(Exception):
    pass

class EventStreamsRPCProxy:
    def __init__(self, base_url):
        self.__id = 1
        self.base_url = base_url
        self.headers = {
            "content-type": "application/json",
            "accept": "application/json"
        }

    def __get_next_id(self):
        self.__id += 1
        return self.__id

    def __execute(self, req):
        isnotif = req.get("id") is None
        res = requests.post(self.base_url, json=req, headers=self.headers, verify=False)
        if res.status_code == 204:  # no content
            if isnotif:
              return None
            else:
              raise EventStreamsRPCException(0,"Protocol error for Notification")
        if res.headers["content-type"].lower().find("application/json") != 0:
            raise EventStreamsRPCException("Invalid ContentType in response: " + res.headers["content-type"])
        jres = res.json()
        if "error" in jres:
           raise EventStreamsRPCException(jres.get("error").get("message"))
        if not "result" in jres:
            raise EventStreamsRPCException(0,"Protocol error in JSON-RPC response - no result nor error node exists")
        return jres["result"]

    def __new_req(self, method, typ):
        req = dict(jsonrpc="2.0", method=method, params=[])
        if typ == "request":
           req["id"] = self.__get_next_id()
        return req
# end of library code

# Following methods are automatically generated

    def login(self, username, password):
        """
        Invokes [function Login(const UserName: string; const Password: string): TJsonObject]
        Returns the token (and others info) needed for other API calls.
        """
        req = self.__new_req("Login", "request")
        req["params"].append(username)
        req["params"].append(password)
        result = self.__execute(req)
        return result

    def refresh_token(self, token):
        """
        Invokes [function RefreshToken(const Token: string): TJsonObject]
        Extends the expiration time of a still-valid token. Clients must use the token returned instead of the previous one.
        """
        req = self.__new_req("RefreshToken", "request")
        req["params"].append(token)
        result = self.__execute(req)
        return result

    def enqueue_message(self, token, queuename, message):
        """
        Invokes [function EnqueueMessage(const Token: string; const QueueName: string; Message: TJsonObject): TJsonObject]
        Pushes a Message in a Queue
        """
        req = self.__new_req("EnqueueMessage", "request")
        req["params"].append(token)
        req["params"].append(queuename)
        req["params"].append(message)
        result = self.__execute(req)
        return result

    def enqueue_message_ttl(self, token, queuename, ttl, message):
        """
        Invokes [function EnqueueMessageTTL(const Token: string; const QueueName: string; const TTL: UInt64; Message: TJsonObject): TJsonObject]
        Pushes a Message in a Queue with a custom TTL in minutes
        """
        req = self.__new_req("EnqueueMessageTTL", "request")
        req["params"].append(token)
        req["params"].append(queuename)
        req["params"].append(ttl)
        req["params"].append(message)
        result = self.__execute(req)
        return result

    def enqueue_multiple_messages(self, token, messages):
        """
        Invokes [function EnqueueMultipleMessages(const Token: string; Messages: TJsonArray): TJsonObject]
        Atomically pushes multiple messages to multiple queues
        """
        req = self.__new_req("EnqueueMultipleMessages", "request")
        req["params"].append(token)
        req["params"].append(messages)
        result = self.__execute(req)
        return result

    def dequeue_multiple_message(self, token, queuename, lastknownid, maxmessagecount, timeoutsec):
        """
        Invokes [function DequeueMultipleMessage(const Token: string; const QueueName: string; LastKnownID: string; const MaxMessageCount: Integer; const TimeoutSec: Int64): TJsonObject]
        Dequeue one or more Messages from QueueName.
        LastKnownID can be "__last__" (get the last message), "__first__" (get the first message) or any 
        MessageID previously retrieved (get the first message with MessageID greater the LastKnownID).
        MaxMessageCount is the max number of messages that should be returned by the method.
        If no message is available, it waits for TimeoutSec, then returns.  
        Max allowed timeout is 10 minutes, min allowed timeout is 5 seconds
        """
        req = self.__new_req("DequeueMultipleMessage", "request")
        req["params"].append(token)
        req["params"].append(queuename)
        req["params"].append(lastknownid)
        req["params"].append(maxmessagecount)
        req["params"].append(timeoutsec)
        result = self.__execute(req)
        return result

    def dequeue_message(self, token, queuename, lastknownid, timeoutsec):
        """
        Invokes [function DequeueMessage(const Token: string; const QueueName: string; LastKnownID: string; const TimeoutSec: Int64): TJsonObject]
        Dequeue a single Message from QueueName.
        LastKnownID can be "__last__" (get the last message), "__first__" (get the first message) or any 
        MessageID previously retrieved (get the first message with MessageID greater the LastKnownID).
        MaxMessageCount is the max number of messages that should be returned by the method.
        If no message is available, it waits for TimeoutSec, then returns.  
        Max allowed timeout is 10 minutes, min allowed timeout is 5 seconds
        """
        req = self.__new_req("DequeueMessage", "request")
        req["params"].append(token)
        req["params"].append(queuename)
        req["params"].append(lastknownid)
        req["params"].append(timeoutsec)
        result = self.__execute(req)
        return result

    def get_next_message_by_timestamp(self, token, queuename, timestamp, isutc):
        """
        Invokes [function GetNextMessageByTimestamp(const Token: string; const QueueName: string; TimeStamp: TDateTime; IsUTC: Boolean): TJsonObject]
        Get the next message, after timestamp, from QueueName.
        If no message is available just returns, there is no wait nor timeout.  
        Usually called as first method to get the first LastKnownID
        """
        req = self.__new_req("GetNextMessageByTimestamp", "request")
        req["params"].append(token)
        req["params"].append(queuename)
        req["params"].append(timestamp)
        req["params"].append(isutc)
        result = self.__execute(req)
        return result

    def delete_queue(self, token, queuename) -> None:
        """
        Invokes [procedure DeleteQueue(const Token: string; const QueueName: string)]
        Deletes queue named "QueueName"
        """
        req = self.__new_req("DeleteQueue", "notification")
        req["params"].append(token)
        req["params"].append(queuename)
        result = self.__execute(req)
        return result

    def get_queues_info(self, token, namefilter):
        """
        Invokes [function GetQueuesInfo(const Token: string; const NameFilter: string): TJsonObject]
        Returns info about queues whose names starts with "NameFilter". 
        If "NameFilter" is empty, all queues are returned
        """
        req = self.__new_req("GetQueuesInfo", "request")
        req["params"].append(token)
        req["params"].append(namefilter)
        result = self.__execute(req)
        return result

    def get_queue_size(self, token, queuename):
        """
        Invokes [function GetQueueSize(const Token: string; const QueueName: string): TJsonObject]
        Returns the size (a.k.a. number of messages) of queue named "QueueName"
        """
        req = self.__new_req("GetQueueSize", "request")
        req["params"].append(token)
        req["params"].append(queuename)
        result = self.__execute(req)
        return result

# end of generated proxy