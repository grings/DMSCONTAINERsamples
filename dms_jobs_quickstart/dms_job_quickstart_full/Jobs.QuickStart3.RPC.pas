unit Jobs.QuickStart3.RPC;

interface


uses DMSCustomRPC;

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


  TJobQuickStart3RPC = class(TCustomRPC)
  public
    function Reverse(const value: string): string;
  end;

implementation

uses StrUtils, System.SysUtils;

function TJobQuickStart3RPC.Reverse(const value: string): string;
begin
  Result := ReverseString(value);
end;

initialization

TJobQuickStart3RPC.ClassName;

end.
