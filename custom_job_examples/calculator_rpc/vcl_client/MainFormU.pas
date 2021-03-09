unit MainFormU;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  System.Net.URLClient;

type
  TMainForm = class(TForm)
    btnCalc: TButton;
    procedure btnCalcClick(Sender: TObject);
  private
    procedure OnValidateCertificate(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}


uses
  CalculatorRPCProxy;

procedure TMainForm.btnCalcClick(Sender: TObject);
var
  lProxy: ICalculatorRPCProxy;
begin
  lProxy := TCalculatorRPCProxy.Create('https://localhost/calculatorrpc');
  lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCertificate);
  ShowMessage('15 + 23 = ' + lProxy.Sum(15, 23).ToString);
  ShowMessage('40 - 32 = ' + lProxy.Diff(40, 32).ToString);
end;

procedure TMainForm.OnValidateCertificate(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
end;

end.
