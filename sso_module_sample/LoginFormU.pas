unit LoginFormU;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.Themes,
  Vcl.Styles,
  Vcl.Imaging.pngimage;

type
  TLoginForm = class(TForm)
    edtUsername: TEdit;
    edtPassword: TEdit;
    Label1: TLabel;
    Image1: TImage;
    Shape1: TShape;
    Panel1: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    class function Execute(out UserName: String; out Password: String): Boolean;
  end;

implementation

{$R *.dfm}

// uses
// FontAwesomeU,
// FontAwesomeCodes;

{ TLoginForm }

class function TLoginForm.Execute(out UserName, Password: String): Boolean;
{$IFNDEF AUTO_LOGIN}
var
  lForm: TLoginForm;
{$ENDIF}
begin
{$IFDEF AUTO_LOGIN}
  UserName := 'user_admin';
  Password := 'pwd1';
  Result := True;
{$ELSE}
  lForm := TLoginForm.Create(nil);
  try
    Result := lForm.ShowModal = mrOk;
    if Result then
    begin
      UserName := lForm.edtUsername.Text;
      Password := lForm.edtPassword.Text;
    end;
  finally
    lForm.Free;
  end;
{$ENDIF}
end;

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  inherited;
  // InstallFont(Self);
  // OKBtn.Caption := fa_check_square + ' ' + OKBtn.Caption;
  // CancelBtn.Caption := fa_chevron_left + ' ' + CancelBtn.Caption;
  // Shape1.Pen.Color := StyleServices.GetStyleColor(scButtonPressed);
end;

end.
