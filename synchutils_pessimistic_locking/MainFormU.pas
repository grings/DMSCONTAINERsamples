unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  SynchUtilsRPCProxy;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDQuery1CUST_NO: TFDAutoIncField;
    FDQuery1CUSTOMER: TStringField;
    FDQuery1CONTACT_FIRST: TStringField;
    FDQuery1CONTACT_LAST: TStringField;
    FDQuery1PHONE_NO: TStringField;
    FDQuery1ADDRESS_LINE1: TStringField;
    FDQuery1ADDRESS_LINE2: TStringField;
    FDQuery1CITY: TStringField;
    FDQuery1STATE_PROVINCE: TStringField;
    FDQuery1COUNTRY: TStringField;
    FDQuery1POSTAL_CODE: TStringField;
    FDQuery1ON_HOLD: TStringField;
    DataSource1: TDataSource;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    DBEdit6: TDBEdit;
    Label7: TLabel;
    DBEdit7: TDBEdit;
    Label8: TLabel;
    DBEdit8: TDBEdit;
    Label9: TLabel;
    DBEdit9: TDBEdit;
    Label10: TLabel;
    DBEdit10: TDBEdit;
    Label11: TLabel;
    DBEdit11: TDBEdit;
    Label12: TLabel;
    DBEdit12: TDBEdit;
    Panel3: TPanel;
    lbLockTTL: TLabel;
    tmrLockOwner: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FDQuery1AfterScroll(DataSet: TDataSet);
    procedure FDQuery1BeforeEdit(DataSet: TDataSet);
    procedure FDQuery1AfterPost(DataSet: TDataSet);
    procedure FDQuery1AfterCancel(DataSet: TDataSet);
    procedure tmrLockOwnerTimer(Sender: TObject);
  private
    fUserName, fPassword: String;
    fToken: String;
    fProxy: ISynchUtilsRPCProxy;
    fLockHandle: string;
    function GetLockName: String;
    procedure RefreshTheLockerUser;
    procedure ReleaseLock;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  Redis.Values, LoginFormU, JsonDataObjects;

{$R *.dfm}

procedure TMainForm.FDQuery1AfterCancel(DataSet: TDataSet);
begin
  ReleaseLock;
end;

procedure TMainForm.FDQuery1AfterPost(DataSet: TDataSet);
begin
  ReleaseLock;
end;

procedure TMainForm.FDQuery1AfterScroll(DataSet: TDataSet);
begin
  fLockHandle := '';
  RefreshTheLockerUser;
end;

procedure TMainForm.FDQuery1BeforeEdit(DataSet: TDataSet);
var
  lCurrKeyName: string;
begin
  var lJSON := TJSONObject.Create;
  lJSON.S['username'] := fUserName;
  fLockHandle := fProxy.TryAcquireLock(fToken, GetLockName, 8, lJSON);
  if fLockHandle = 'error' then
  begin
    fLockHandle := '';
    raise Exception.Create('Cannot acquire lock');
  end;
  RefreshTheLockerUser;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fProxy := TSynchUtilsRPCProxy.Create('https://localhost/synchutilsrpc');
  fProxy.IgnoreInvalidCert;
  while True do
  begin
    if not TLoginForm.Execute(fUserName, fPassword) then
    begin
      Application.Terminate;
      Exit;
    end;
    try
      var lJSON := fProxy.Login(fUserName, fPassword);
      try
        fToken := lJSON.S['token'];
        Break;
      finally
        lJSON.Free;
      end;
    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
      end;
    end;
  end;
  tmrLockOwner.Enabled := True;
  Panel1.Caption := 'USER NAME: ' + fUserName;
  FDQuery1.Open;
end;

function TMainForm.GetLockName: String;
begin
  Result := 'customers:editing:' + FDQuery1CUST_NO.AsString;
end;

procedure TMainForm.RefreshTheLockerUser;
var
  EditUser: string;
begin
  var lJSON := fProxy.GetLockData(fToken, GetLockName);
  try
    if lJSON.L['expires_in'] = -1 then
    begin
      if not fLockHandle.IsEmpty then
      begin
        fLockHandle := '';
        FDQuery1.Cancel;
      end;
      Panel3.Caption := 'No one is editing this record';
      lbLockTTL.Caption := '';
    end
    else
    begin
      Panel3.Caption := 'Currently editing by: ' + lJSON.O['lock_data'].S['username'];
      lbLockTTL.Caption := 'Record is locked for: ' + lJSON.L['expires_in'].ToString + ' sec';
    end;
  finally
    lJSON.Free;
  end;
end;

procedure TMainForm.ReleaseLock;
begin
  fProxy.ReleaseLock(fToken, fLockHandle);
  fLockHandle := '';
  RefreshTheLockerUser;
end;

procedure TMainForm.tmrLockOwnerTimer(Sender: TObject);
begin
  RefreshTheLockerUser;
end;

end.
