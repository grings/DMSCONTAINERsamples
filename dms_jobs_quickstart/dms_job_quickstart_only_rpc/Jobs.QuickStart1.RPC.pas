unit Jobs.QuickStart1.RPC;

interface


uses DMSCustomRPC;

Type

  TJobQuickStart1RPC = class(TCustomRPC)
  public
    function Echo(const value: string): string;
  end;

implementation



function TJobQuickStart1RPC.Echo(const value: string): string;
begin
  result := value;
end;

initialization

TJobQuickStart1RPC.ClassName;

end.
