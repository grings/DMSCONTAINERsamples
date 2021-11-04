unit Jobs.QuickStart3.Job;

interface


uses DMSCommonsU, DMSCustomJob, DMSLoggingU;

type
  TJobQuickStart3Job = class(TCustomJob)
    protected
    procedure DoExecute; override;
    function GetConfigKeys: TArray<string>; override;
  end;

implementation

uses
  System.SysUtils;

procedure TJobQuickStart3Job.DoExecute;
begin
  { write your own job code here }
  Log.Info('Hello! I''m going to play something amazing!!', JobName);

end;

function TJobQuickStart3Job.GetConfigKeys: TArray<string>;
begin
  Result := [];
end;

initialization

TJobQuickStart3Job.ClassName;

end.
