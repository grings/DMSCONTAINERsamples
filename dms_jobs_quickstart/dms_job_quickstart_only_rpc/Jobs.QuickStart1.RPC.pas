unit Jobs.QuickStart1.RPC;

interface


uses DMSCustomRPC;

// To publish this classjob add the following configuration
// in the "jobs" array in the "$(DMS_HOME)\conf\jobsmanager.json" file
//  {
//    "enabled" : true,
//    "jobname" : "jobquickstart1rpc",
//    "jobtype" : "class",
//    "rpcclass": "Jobs.QuickStart1.RPC.TJobQuickStart1RPC",
//    "rpcuri"  : "/jobquickstart1rpc"
//  }

type
  TJobQuickStart1RPC = class(TCustomAuthRPC)
  public
    function Echo(const value: string): string;
  end;

implementation



function TJobQuickStart1RPC.Echo(const value: string): string;
begin
  Result := value;
end;

initialization

TJobQuickStart1RPC.ClassName;

end.
