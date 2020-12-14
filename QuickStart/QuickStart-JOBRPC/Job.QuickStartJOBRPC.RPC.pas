unit Job.QuickStartJOBRPC.RPC;

interface


uses DMSCustomRPC;

Type

  TJobQuickStartJOBRPC_RPC = class(TCustomRPC)
  public
    function Reverse(const value: string): string;
  end;

implementation
uses StrUtils;



function TJobQuickStartJOBRPC_RPC.Reverse(const value: string): string;
begin
  result := ReverseString(value);
end;

initialization

TJobQuickStartJOBRPC_RPC.ClassName;

end.
