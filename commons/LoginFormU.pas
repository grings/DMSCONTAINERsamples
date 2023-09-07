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
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    class function Execute(out UserName: String; out Password: String): Boolean;
  end;

implementation

{$R *.dfm}
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

procedure TLoginForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F9 then
  begin
    edtUsername.Text := 'user_admin';
    edtPassword.Text := 'pwd1';
    ModalResult := mrOk;
  end;
end;

end.
