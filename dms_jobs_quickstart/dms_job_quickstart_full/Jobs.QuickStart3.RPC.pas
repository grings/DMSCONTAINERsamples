unit Jobs.QuickStart3.RPC;

interface


uses DMSCustomRPC;

type
  TJobQuickStart3RPC = class(TCustomRPC)
  public
    function Reverse(const value: string): string;
  end;

implementation

uses StrUtils;

function TJobQuickStart3RPC.Reverse(const value: string): string;
begin
  Result := ReverseString(value);
end;

initialization

TJobQuickStart3RPC.ClassName;

end.
