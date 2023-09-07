unit StoredReportNamesFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, RzPanel,
  RzDlgBtn, ReportsRPCProxy, JsonDataObjects;

type
  TStoredReportNamesForm = class(TForm)
    RzDialogButtons1: TRzDialogButtons;
    Panel1: TPanel;
    EditFilter: TEdit;
    btnDoFilter: TButton;
    Panel2: TPanel;
    ListBox1: TListBox;
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure btnDoFilterClick(Sender: TObject);
    procedure EditFilterKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    fJSON: TJsonObject;
    fProxy: IReportsRPCProxy;
    fToken: String;
    procedure RefreshReportNames(const RegExFilter: String = '');
  public
    property Proxy: IReportsRPCProxy write fProxy;
    property Token: String write fToken;
  end;

implementation

{$R *.dfm}
{ TStoredReportNamesForm }

procedure TStoredReportNamesForm.btnDoFilterClick(Sender: TObject);
begin
  RefreshReportNames(EditFilter.Text);
end;

procedure TStoredReportNamesForm.EditFilterKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    btnDoFilter.Click;
    Key := 0;
  end;
end;

procedure TStoredReportNamesForm.FormDestroy(Sender: TObject);
begin
  fJSON.Free;
end;

procedure TStoredReportNamesForm.FormShow(Sender: TObject);
begin
  RefreshReportNames;
end;

procedure TStoredReportNamesForm.ListBox1Click(Sender: TObject);
begin
  Memo1.Lines.Text := fJSON.A['reports'].O[ListBox1.ItemIndex].O['meta'].S['description'];
end;

procedure TStoredReportNamesForm.RefreshReportNames(const RegExFilter: String);
var
  I: Integer;
begin
  FreeAndNil(fJSON);
  fJSON := fProxy.GetStoredReportNames(fToken,RegExFilter);
  ListBox1.Items.BeginUpdate;
  try
    ListBox1.Items.Clear;
    for I := 0 to fJSON.A['reports'].Count - 1 do
    begin
      ListBox1.Items.Add(fJSON.A['reports'].O[I].S['name']);
    end;
    if ListBox1.Items.Count > 0 then
    begin
      ListBox1.ItemIndex := 0;
      ListBox1Click(ListBox1);
    end;
  finally
    ListBox1.Items.EndUpdate;
  end;
end;

end.
