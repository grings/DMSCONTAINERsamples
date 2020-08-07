unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, AuthService, JsonDataObjects,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, Vcl.Imaging.pngimage, Vcl.ComCtrls, Vcl.Menus;

type
  TMainFrm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnAction: TButton;
    Image1: TImage;
    ActionList1: TActionList;
    acLogout: TAction;
    acLogin: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    tsContabilita: TTabSheet;
    Label2: TLabel;
    edtName: TEdit;
    edtSurname: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    lbRoles: TListBox;
    btnRefresh: TButton;
    Label5: TLabel;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRefreshClick(Sender: TObject);
    procedure acLogoutExecute(Sender: TObject);
    procedure acLoginExecute(Sender: TObject);
    procedure MenuContClick(Sender: TObject);
    procedure Main1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fAuthService: IAuthService;
    fJCustomValue: TJsonObject;
    fJAccountingValue: TJsonObject;
    fIsAuth: Boolean;
    fUserName: String;
    procedure CheckIsSSOAuth;
    procedure UpdateGUI;
    function Login: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFrm: TMainFrm;

const
  CONTEXT_NAME = 'APP1';

implementation

{$R *.dfm}


uses LoginFormU, FontAwesomeU, FontAwesomeCodes, System.UITypes;

procedure TMainFrm.acLoginExecute(Sender: TObject);
begin
  Login;
end;

procedure TMainFrm.acLogoutExecute(Sender: TObject);
begin
  fAuthService.Logout;
  CheckIsSSOAuth;
end;

procedure TMainFrm.btnLogoutClick(Sender: TObject);
begin
  fAuthService.Logout;
  CheckIsSSOAuth;
end;

procedure TMainFrm.btnRefreshClick(Sender: TObject);
begin
  CheckIsSSOAuth;
end;

procedure TMainFrm.Button1Click(Sender: TObject);
begin
  fAuthService.Login(fUserName, 'pwd1');
  CheckIsSSOAuth;
end;

procedure TMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fJCustomValue.Free;
  fJAccountingValue.Free;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  InstallFont(Self);
  fJCustomValue := TJsonObject.Create;
  fJAccountingValue := TJsonObject.Create;
  fAuthService := TAuthService.Create;
  CheckIsSSOAuth;
end;

procedure TMainFrm.FormShow(Sender: TObject);
begin
  if not fIsAuth then
  begin
    if not Login then
    begin
      Application.Terminate;
    end;
  end;
  btnRefresh.Caption := fa_refresh + ' ' + btnRefresh.Caption;
  Label5.Caption := fa_user;
end;

function TMainFrm.Login: Boolean;
var
  lUsername: string;
  lPassword: string;
begin
  Result := False;
  fIsAuth := False;
  while TLoginForm.Execute(lUsername, lPassword) do
  begin
    try
      if fAuthService.Login(lUsername, lPassword) then
      begin
        Result := True;
        if fAuthService.CheckIsSSOAuth(CONTEXT_NAME, fJCustomValue) then
        begin
          fIsAuth := True;
          fUserName := lUsername;
          UpdateGUI;
        end;
      end;
      if not fIsAuth then
      begin
        MessageDlg('Invalid or not authorized user', mtError, [mbOK], 0);
      end
      else
      begin
        Break;
      end;
    except
      on E: Exception do
      begin
        MessageDlg(E.message, mtError, [mbOK], 0);
        Continue;
      end;
    end;
  end;

end;

procedure TMainFrm.CheckIsSSOAuth;
begin
  fIsAuth := fAuthService.CheckIsSSOAuth(CONTEXT_NAME, fJCustomValue);
  UpdateGUI;
end;

procedure TMainFrm.Main1Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TMainFrm.MenuContClick(Sender: TObject);
begin
  tsContabilita.TabVisible := True;
  PageControl1.ActivePageIndex := 1;
end;

procedure TMainFrm.UpdateGUI;
var
  lARuoli: TJsonArray;
  I: Integer;
  lJSystemData: TJsonObject;
begin

  lbRoles.Items.Clear;
  if fIsAuth then
  begin
    lJSystemData := fJCustomValue.O['systemdata'];
    Label1.Caption := Format('Welcome %s %s ', [lJSystemData.S['nome'],
      lJSystemData.S['last_name']]);
    edtName.Text := lJSystemData.S['first_name'];
    edtSurname.Text := lJSystemData.S['last_name'];
    lARuoli := lJSystemData.A['roles'];
    btnAction.Action := acLogout;
    btnAction.Caption := fa_lock + ' ' + btnAction.Caption;
    for I := 0 to lARuoli.Count - 1 do
      lbRoles.AddItem(lARuoli[I].Value, nil);

  end
  else
  begin
    Label1.Caption := 'Login ';
    edtName.Text := EmptyStr;
    edtSurname.Text := EmptyStr;
    btnAction.Action := acLogin;
    btnAction.Caption := fa_user + ' ' + btnAction.Caption;
  end;

end;

end.
