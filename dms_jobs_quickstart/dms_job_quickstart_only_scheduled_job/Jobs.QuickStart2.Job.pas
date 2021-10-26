unit Jobs.QuickStart2.Job;

interface

uses DMSCommonsU, DMSCustomJob, DMSLoggingU;

type

// To publish this classjob add the following configuration
// in the "jobs" array in the "$(DMS_HOME)\conf\jobsmanager.json" file
//	{
//		"enabled": true,
//		"jobname": "jobquickstart1job",
//		"schedule": "* * * * * *",
//		"jobtype":"class",
//		"jobclass":"Jobs.QuickStart2.Job.TQuickStart2Job"
//	}


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
  Log.Info('Hello! I''m going to do amazing things!', JobName);
end;

initialization


TQuickStart2Job.ClassName;

end.
