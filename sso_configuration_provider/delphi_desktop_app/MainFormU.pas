unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JsonDataObjects,
  System.IOUtils, System.Net.URLClient, AuthRPCProxy;

type
  TMainForm = class(TForm)
    btnGetContextData: TButton;
    btnGetAllMyData: TButton;
    MemoData: TMemo;
    btnGetSystemData: TButton;
    btnGetUserData: TButton;
    btnSetUserData: TButton;
    procedure btnGetContextDataClick(Sender: TObject);
    procedure btnGetAllMyDataClick(Sender: TObject);
    procedure btnGetSystemDataClick(Sender: TObject);
    procedure btnGetUserDataClick(Sender: TObject);
    procedure btnSetUserDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fAuthConf: IAuthRPCProxy;
    procedure OnValidateCertificate(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

{$R *.dfm}

implementation

{ TMainForm }

procedure TMainForm.btnGetAllMyDataClick(Sender: TObject);
begin
  var lToken: String;
  var lJObj := fAuthConf.Login('configuration1', 'pwd1');
  try
    lToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  var lJContexts := fAuthConf.GetAllMyContextInfoByContextName(lToken, 'contexts.erp.rome');
  try
    MemoData.Lines.Text := lJContexts.ToJSON(false);
  finally
    lJContexts.Free;
  end;
end;

procedure TMainForm.btnGetContextDataClick(Sender: TObject);
begin
  var lToken: String;
  var lJObj := fAuthConf.Login('configuration1', 'pwd1');
  try
    lToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  var lJContexts := fAuthConf.GetMyContextDataByContextName(lToken, 'contexts.erp.rome');
  try
    MemoData.Lines.Text := lJContexts.O['contextdata'].ToJSON(False);
  finally
    lJContexts.Free;
  end;
end;

procedure TMainForm.btnGetSystemDataClick(Sender: TObject);
begin
  var lToken: String;
  var lJObj := fAuthConf.Login('configuration1', 'pwd1');
  try
    lToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  var lJContexts := fAuthConf.GetMySystemDataByContextName(lToken, 'contexts.erp.rome');
  try
    MemoData.Lines.Text := lJContexts.O['systemdata'].ToJSON(False);
  finally
    lJContexts.Free;
  end;

end;

procedure TMainForm.btnGetUserDataClick(Sender: TObject);
begin
  var lToken: String;
  var lJObj := fAuthConf.Login('configuration1', 'pwd1');
  try
    lToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  var lJContexts := fAuthConf.GetMyUserDataByContextName(lToken, 'contexts.erp.rome');
  try
    MemoData.Lines.Text := lJContexts.O['userdata'].ToJSON(False);
  finally
    lJContexts.Free;
  end;
end;

procedure TMainForm.btnSetUserDataClick(Sender: TObject);
begin
  var lToken: String;
  var lJObj := fAuthConf.Login('configuration1', 'pwd1');
  try
    lToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  var lUserData := TJsonObject.Parse(MemoData.Lines.Text) as TJSONObject;
  try
    fAuthConf.SetMyUserDataByContextName(lToken, 'contexts.erp.rome', lUserData.Clone as TJSONObject);
    MemoData.Lines.Clear;
  finally
    lUserData.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fAuthConf := TAuthRPCProxy.Create('https://localhost/authrpc');
  fAuthConf.RPCExecutor.SetOnValidateServerCertificate(OnValidateCertificate);
end;

procedure TMainForm.OnValidateCertificate(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
end;

end.
