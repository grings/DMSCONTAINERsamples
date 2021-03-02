unit AuthService;

interface

uses
  AuthRPCProxy, System.Net.URLClient, JsonDataObjects;

Type
  IAuthService = Interface
    ['{FB6983C2-578A-44AD-8D98-DC5957C8B029}']
    function CheckIsSSOAuth(AContextName: String; out ASSOData: TJsonObject): Boolean;
    procedure Logout;
    function Login(AUser, APWD: String): Boolean;
    procedure SaveUserData(AIDUserContext: Integer; ContextName: String; AUserData: TJsonObject);
  End;

  TAuthService = class(TInterfacedObject, IAuthService)
  private
    fAuthRPCProxy: TAuthRPCProxy;
    FToken: string;
    procedure SaveToken;
    function getTokenPathFile: String;
    function GetTokenByFile: String;
    procedure ValidateCertificateEvent(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
  public
    function CheckIsSSOAuth(AContextName: String; out ASSOData: TJsonObject): Boolean;
    function Login(AUser, APWD: String): Boolean;
    procedure SaveUserData(AIDUserContext: Integer; ContextName: String; AUserData: TJsonObject);
    procedure Logout;
    constructor Create;
    destructor Destroy; override;

  end;

implementation

uses
  System.IOUtils, System.SysUtils, MVCFramework.JSONRPC;

const
  SERVERNAME = 'localhost' { 172.31.3.225 };

  { TAuthService }

function TAuthService.CheckIsSSOAuth(AContextName: String; out ASSOData: TJsonObject): Boolean;
var
  lJResult: TJsonObject;
  lToken: String;
begin
  lToken := GetTokenByFile;

  if lToken = EmptyStr then
    Exit(False);

  try
    lJResult := fAuthRPCProxy.GetAllMyContextInfoByContextName(lToken, AContextName);
    try
      ASSOData := lJResult.Clone as TJsonObject;
    finally
      lJResult.Free;
    end;
  except
    Result := False;
  end;
end;

procedure TAuthService.SaveToken;
begin
  TFile.WriteAllText(getTokenPathFile, FToken, TEncoding.ASCII);
end;

procedure TAuthService.SaveUserData(AIDUserContext: Integer; ContextName: String; AUserData: TJsonObject);
begin
  fAuthRPCProxy.SetMyUserDataByContextName(FToken, ContextName, AUserData);
end;

function TAuthService.getTokenPathFile: String;
begin
  Result := TPath.Combine(TPath.GetHomePath(), 'sso.dat');
end;

constructor TAuthService.Create;
begin
  fAuthRPCProxy := TAuthRPCProxy.Create('https://' + SERVERNAME + '/authrpc');
  fAuthRPCProxy.RPCExecutor.SetOnValidateServerCertificate(ValidateCertificateEvent);

  FToken := GetTokenByFile;
end;

destructor TAuthService.Destroy;
begin
  fAuthRPCProxy.Free;
  inherited;
end;

function TAuthService.GetTokenByFile: String;
begin
  Result := '';
  if TFile.Exists(getTokenPathFile) then
    Result := TFile.ReadAllText(getTokenPathFile);

end;

procedure TAuthService.Logout;
begin
  FToken := EmptyStr;
  if TFile.Exists(getTokenPathFile) then
    TFile.Delete(getTokenPathFile);

end;

function TAuthService.Login(AUser, APWD: String): Boolean;
var
  lJObj: TJsonObject;
begin
  lJObj := fAuthRPCProxy.Login(AUser, APWD);
  try
    FToken := lJObj.S['token'];
    SaveToken;
    Result := not FToken.IsEmpty;
  finally
    lJObj.Free;
  end;
end;

procedure TAuthService.ValidateCertificateEvent(const Sender: TObject; const ARequest: TURLRequest;
  const Certificate: TCertificate; var Accepted: Boolean);
begin
  Accepted := True;
end;

end.
