unit Jobs.QuickStart3.Job;

interface


uses DMSCommonsU, DMSCustomJob, DMSLoggingU;

type
  TJobQuickStartJob = class(TCustomJob)
  protected
    procedure DoExecute; override;
  end;

implementation

uses
  System.SysUtils;

procedure TJobQuickStartJob.DoExecute;
begin
  { write your own job code here }
  Log.Info('Hello! I''m going to play something amazing!!', JobName);

end;

initialization

TJobQuickStartJob.ClassName;

end.
