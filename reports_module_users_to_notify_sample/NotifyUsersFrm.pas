unit NotifyUsersFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.CheckLst,
  JsonDataObjects;

type
  TfrmSelectUsers = class(TForm)
    chklistUsers: TCheckListBox;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmSelectUsers: TfrmSelectUsers;

implementation

{$R *.dfm}

end.
