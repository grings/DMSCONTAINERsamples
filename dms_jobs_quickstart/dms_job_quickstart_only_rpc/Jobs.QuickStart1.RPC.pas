unit Jobs.QuickStart1.RPC;

interface


uses DMSCustomRPC;

Type

  TJobQuickStartRPC = class(TCustomRPC)
  public
    function Echo(const value: string): string;
  end;

implementation



function TJobQuickStartRPC.Echo(const value: string): string;
begin
  result := value;
end;

initialization

TJobQuickStartRPC.ClassName;

end.
