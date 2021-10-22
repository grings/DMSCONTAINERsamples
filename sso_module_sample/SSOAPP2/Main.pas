unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, AuthService, JsonDataObjects,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, Vcl.Imaging.pngimage, Vcl.Samples.Spin,
  Vcl.CheckLst, Vcl.Buttons, Vcl.Mask;

type
  TMainFrm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    ActionList1: TActionList;
    acLogout: TAction;
    acChangeUser: TAction;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    edtName: TEdit;
    Label3: TLabel;
    edtSurname: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox2: TGroupBox;
    btnRefresh: TButton;
    edtAge: TEdit;
    edtFolderDef: TLabeledEdit;
    SpeedButton1: TSpeedButton;
    edtDateFormat: TLabeledEdit;
    rgNotifications: TRadioGroup;
    CheckListBox1: TCheckListBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    FileOpenDialog1: TFileOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acChangeUserExecute(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fAuthService: IAuthService;
    fJSSOData: TJsonObject;
    fIsAuth: Boolean;
    fUserName: String;
    fUserContextID: Integer;
    function IsSSOAuth: Boolean;
    procedure UpdateGUI;
    function Login: Boolean;
    function GetUIDataAsJSONObject: TJsonObject;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainFrm: TMainFrm;

const
  CONTEXT_NAME = 'APP2';

implementation

{$R *.dfm}


uses LoginFormU, FontAwesomeU, FontAwesomeCodes, System.UITypes;

procedure TMainFrm.acChangeUserExecute(Sender: TObject);
begin
  fAuthService.Logout;
  if not IsSSOAuth then
  begin
    ShowMessage('Not Authorized');
  end;
end;

procedure TMainFrm.btnLogoutClick(Sender: TObject);
begin
  fAuthService.Logout;
  if not IsSSOAuth then
  begin
    ShowMessage('Not Authorized');
  end;
end;

procedure TMainFrm.btnRefreshClick(Sender: TObject);
var
  lJSONUserData: TJsonObject;
begin
  lJSONUserData := GetUIDataAsJSONObject;
  fAuthService.SaveUserData(fUserContextID, CONTEXT_NAME, lJSONUserData);
end;

procedure TMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fJSSOData.Free;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  InstallFont(Self);
  fAuthService := TAuthService.Create;
  fIsAuth := IsSSOAuth;
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

function TMainFrm.GetUIDataAsJSONObject: TJsonObject;
var
  I: Integer;
begin
  Result := TJsonObject.Create;
  Result.S['userfolder'] := edtFolderDef.Text;
  Result.S['dateformat'] := edtDateFormat.Text;
  Result.B['usenotifications'] := rgNotifications.ItemIndex = 0;
  for I := 0 to CheckListBox1.Items.Count - 1 do
  begin
    if CheckListBox1.Checked[I] then
    begin
      Result.A['knownlanguages'].Add(CheckListBox1.Items[I]);
    end;
  end;
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
        if fAuthService.CheckIsSSOAuth(CONTEXT_NAME, fJSSOData) then
        begin
          Result := True;
          fIsAuth := True;
          fUserName := lUsername;
          fUserContextID := fJSSOData.I['id'];
          UpdateGUI;
        end;
      end;

      if not fIsAuth then
      begin
        MessageDlg('Invalid or not authorized user for context ' + CONTEXT_NAME, mtError, [mbOK], 0);
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

procedure TMainFrm.SpeedButton1Click(Sender: TObject);
begin
  FileOpenDialog1.Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
  if FileOpenDialog1.Execute then
  begin
    edtFolderDef.Text := FileOpenDialog1.FileName;
  end;
end;

function TMainFrm.IsSSOAuth: Boolean;
begin
  fIsAuth := fAuthService.CheckIsSSOAuth(CONTEXT_NAME, fJSSOData);
  Result := fIsAuth;
  UpdateGUI;
end;

procedure TMainFrm.UpdateGUI;
var
  lJSystemData, lJUserData: TJsonObject;
  I: Integer;
  lLanguages: TJsonArray;
begin
  if fIsAuth then
  begin
    fUserContextID := fJSSOData.I['id'];
    lJSystemData := fJSSOData.O['systemdata'];
    Label1.Caption := Format('Welcome %s %s ', [lJSystemData.S['first_name'], fJSSOData.S['last_name']]);
    edtName.Text := lJSystemData.S['first_name'];
    edtSurname.Text := lJSystemData.S['last_name'];
    edtAge.Text := lJSystemData.I['age'].ToString;

    lJUserData := fJSSOData.O['userdata'].Clone as TJsonObject;
    try
      if Assigned(lJUserData) then
      begin
        edtFolderDef.Text := lJUserData.S['userfolder'];
        edtDateFormat.Text := lJUserData.S['dateformat'];
        if lJUserData.B['usenotifications'] then
          rgNotifications.ItemIndex := 0
        else
          rgNotifications.ItemIndex := 1;

        lLanguages := lJUserData.A['knownlanguages'];
        for I := 0 to lLanguages.Count - 1 do
        begin
          if CheckListBox1.Items.IndexOf(lLanguages.S[I]) > -1 then
          begin
            CheckListBox1.Checked[CheckListBox1.Items.IndexOf(lLanguages.S[I])] := True;
          end;
        end;
      end;
    finally
      lJUserData.Free;
    end;
  end
  else
  begin
    Label1.Caption := 'USER NOT LOGGED ';
    edtName.Text := EmptyStr;
    edtSurname.Text := EmptyStr;
    edtAge.Text := EmptyStr;
  end;

end;

end.
