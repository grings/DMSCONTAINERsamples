unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Vcl.StdCtrls;

type
  TMainForm = class(TForm)
    Button1: TButton;
    NetHTTPClient1: TNetHTTPClient;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure NetHTTPClient1ValidateServerCertificate(const Sender: TObject;
      const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}


uses JsonDataObjects;

function NewReq(const MethodName: String): TJsonObject;
var
  lJSON: TJsonObject;
begin
  lJSON := TJsonObject.Create;
  lJSON.S['jsonrpc'] := '2.0';
  lJSON.I['id'] := 1000 + Random(100000);
  lJSON.S['method'] := MethodName;
  Result := lJSON;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  lJSON: TJsonObject;
begin
  var lBody := TStringStream.Create;
  try
    lJSON := NewReq('login');
    try
      lJSON.A['params'].Add('user_sender');
      lJSON.A['params'].Add('pwd1');
      lBody.WriteString(lJSON.ToJSON());
      lBody.Position := 0;
    finally
      lJSON.Free;
    end;
    var lResp: IHTTPResponse := NetHTTPClient1.Post('https://localhost/emailrpc', lBody, nil, [
          TNetHeader.Create('accept', 'application/json'),
          TNetHeader.Create('content-type', 'application/json')
        ]);
    var lJResp := TJsonObject.Parse(lResp.ContentAsString()) as TJsonObject;
    try
      if lJResp.Contains('error') then
      begin
        Memo1.Lines.Text := lJResp.O['error'].ToJSON(False);
      end
      else
      begin
        Memo1.Lines.Text := lJResp.O['result'].ToJSON(False);
      end;
    finally
      lJResp.Free;
    end;
  finally
    lBody.Free;
  end;
end;

procedure TMainForm.NetHTTPClient1ValidateServerCertificate(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
end;

end.
