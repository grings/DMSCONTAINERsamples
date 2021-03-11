unit Jobs.QuickStart2.Job;

interface

uses DMSCommonsU, DMSCustomJob, DMSLoggingU;

type
  TQuickStart2Job = class(TCustomJob)
  protected
    procedure DoExecute; override;
  end;

implementation

uses
  System.SysUtils;

procedure TQuickStart2Job.DoExecute;
begin
  { write your own job code here }
  Log.Info('Hello! I''m going to play something amazing!!', JobName);
end;

initialization


TQuickStart2Job.ClassName;

end.
