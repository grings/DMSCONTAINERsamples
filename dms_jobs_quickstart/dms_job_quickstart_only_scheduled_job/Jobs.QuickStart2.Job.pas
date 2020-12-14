unit Jobs.QuickStart2.Job;

interface

uses DMSCommonsU, DMSCustomJob, DMSLoggingU;

type
  TQuickStartJob = class(TCustomJob)
  protected
    procedure DoExecute; override;
  end;

implementation

uses
  System.SysUtils;

procedure TQuickStartJob.DoExecute;
begin
  { write your own job code here }
  Log.Info('Hello! I''m going to play something amazing!!', JobName);

end;

initialization

Randomize;
TQuickStartJob.ClassName;

end.
