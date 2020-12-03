unit Jobs.Calculator.RPC;

interface

uses
  DMSCustomRPC;

type
  TCalculatorRPC = class(TCustomRPC)
  public
    [DMSDoc('Returns the sum of two integers')]
    function Sum(const A, B: Integer): Integer;
    [DMSDoc('Returns the difference between two integers')]
    function Diff(const A, B: Integer): Integer;
  end;

implementation

{ TCalculatorRPC }

function TCalculatorRPC.Diff(const A, B: Integer): Integer;
begin
  Result := A - B;
end;

function TCalculatorRPC.Sum(const A, B: Integer): Integer;
begin
  Result := A + B;
end;

end.
