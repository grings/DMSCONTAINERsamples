unit Jobs.QuickStart3.RPC;

interface


uses DMSCustomRPC;

type
  TJobQuickStartRPC = class(TCustomRPC)
  public
    function Reverse(const value: string): string;
  end;

implementation

uses StrUtils;

function TJobQuickStartRPC.Reverse(const value: string): string;
begin
  Result := ReverseString(value);
end;

initialization

TJobQuickStartRPC.ClassName;

end.
