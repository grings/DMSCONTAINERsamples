unit Jobs.QuickStartJOBRPC.Job;

interface



uses DMSCommonsU, DMSCustomJob, DMSLoggingU;

type
  TQuickStartJOBRPC_Job = class(TCustomJob)
  protected
    procedure DoExecute; override;
  end;

implementation

uses
  System.SysUtils;

procedure TQuickStartJOBRPC_Job.DoExecute;
begin
  { write your own job code here }
  Log.Info('Hello! I''m going to play something amazing!!', JobName);

end;

initialization

Randomize;
TQuickStartJOBRPC_Job.ClassName;

end.
