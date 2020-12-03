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
  TForm3 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    procedure OnValidateCertificate(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}


uses
  CalculatorRPCProxy;

procedure TForm3.Button1Click(Sender: TObject);
var
  lProxy: TCalculatorRPCProxy;
begin
  lProxy := TCalculatorRPCProxy.Create('https://localhost/calculatorrpc');
  try
    lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCertificate);
    ShowMessage(lProxy.Sum(10, 40).ToString);
//    ShowMessage(lProxy.Diff(40, 30).ToString);
  finally
    lProxy.Free;
  end;
end;

procedure TForm3.OnValidateCertificate(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
end;

end.
