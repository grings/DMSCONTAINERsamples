unit Jobs.QuickStart3.RPC;

interface


uses
  DMSCustomRPC;

type
// To publish this classjob add the following configuration
// in the "jobs" array in the "$(DMS_HOME)\conf\jobsmanager.json" file
// 	{
// 		"enabled": true,
// 		"jobname": "jobquickstart3full",
// 		"schedule": "* * * * * *",
// 		"jobtype":"class",
// 		"jobclass":"Jobs.QuickStart3.Job.TJobQuickStart3Job",
// 		"rpcclass": "Jobs.QuickStart3.RPC.TJobQuickStart3RPC",
// 		"rpcuri"  : "/jobquickstart3rpc"
// 	}


  TJobQuickStart3RPC = class(TCustomAuthRPC)
  protected
    {must returns the config properties required by the job to works}
    function GetConfigKeys: TArray<string>; override;
  public
    function Reverse(const value: string): string;
    function GetPrivateData(const Token: String): String;
  end;

implementation

uses
  System.StrUtils,
  System.SysUtils,
  Jobs.QuickStart3.Job;

function TJobQuickStart3RPC.GetConfigKeys: TArray<string>;
begin
  //here the job must "declare" which configuration keys requires
  Result := ['prop1'];
end;

function TJobQuickStart3RPC.GetPrivateData(const Token: String): String;
begin
  //LoadToken method checks the token validity and load token user related info (username, userid, roles)
  //if token is not valid raises an exception
  LoadToken(Token);

  //if the user is not associated with the context accounting raises an exception.
  EnsureContext('accounting');

  //if needed we can load the configuration associated with the job
  //REMEMBER
  // The RPC class and the JOB class can share the same config file
  // but can read different set of properties
  var lJobConfiguration: String := '';
  var lConfig := GetJobConfig(); {this reads only the keys returnes by "GetConfigKeys"}
  try
    lJobConfiguration := lConfig.ToString;
  finally
    lConfig.Free;
  end;

  //At this point we are sure that the user is logged with a valid token and that it
  //is associated with the "accounting" context.
  Result := Format('Here''s your secret info: [LoggedUserName: %s],[LoggedUserID: %d],[UserRoles: %s][Job Config: %s]',
    [
      LoggedUserName,
      LoggedUserID,
      String.Join(',', LoggedUserRoles),
      lJobConfiguration
    ]);
end;

function TJobQuickStart3RPC.Reverse(const value: string): string;
begin
  {no authentication required for this method}
  Result := ReverseString(value);
end;

initialization

TJobQuickStart3RPC.ClassName;

end.
