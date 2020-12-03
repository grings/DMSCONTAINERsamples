// ***************************************************************************
//
// DMS Container
//
// Copyright (c) 2016-2020 bit Time Professionals
//
//
// ***************************************************************************
//
// Licensed under the Commercial License
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License asking to the software provider
//
// Unless agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// *************************************************************************** }

unit Jobs.Beeper.Job;

interface

uses
  DMSCommonsU,
  DMSCustomJob,
  DMSLoggingU;

type
  TBeepJob = class(TCustomJob)
  protected
    procedure DoExecute; override;
  end;

implementation

uses
  WinApi.Windows,
  System.SysUtils;

{ TBeepJob }

procedure TBeepJob.DoExecute;
begin
  Sleep(500);
  if Random(50) <= 1 then
    raise Exception.Create
      ('This is an Exception... do you see me in the log? [HINT Disable the job "Jobs.Beeper.Job.TBeepJob" to get rid of this exception]');
  Log.Info('Hello! I''m going to play something amazing!!', JobName);
  WinApi.Windows.Beep(440, 200);
  WinApi.Windows.Beep(440 * 2, 200);
  WinApi.Windows.Beep(440 * 3, 400);
end;

initialization

Randomize;
TBeepJob.ClassName;

end.
