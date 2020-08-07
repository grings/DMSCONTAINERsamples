unit UsersManagementU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, MVCFramework.JSONRPC.Client, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TUsersForm = class(TForm)
    btnCreateUsers: TButton;
    Panel1: TPanel;
    btnOK: TButton;
    btnGetUsers: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    mtUsers: TFDMemTable;
    btnUpdateUser: TButton;
    btnDeleteUser: TButton;
    btnSetSender: TButton;
    procedure btnCreateUsersClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGetUsersClick(Sender: TObject);
    procedure btnUpdateUserClick(Sender: TObject);
    procedure btnSetSenderClick(Sender: TObject);
    procedure btnDeleteUserClick(Sender: TObject);
  private
    fToken: String;
    fExecutor: IMVCJSONRPCExecutor;
    procedure CreateMemTableStructure;
  public
    constructor Create(const Token: String; const Executor: IMVCJSONRPCExecutor); reintroduce;
  end;

var
  UsersForm: TUsersForm;

implementation

uses
  MVCFramework.JSONRPC, JsonDataObjects, MVCFramework.DataSet.Utils;

{$R *.dfm}


procedure TUsersForm.btnCreateUsersClick(Sender: TObject);
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
  lRnd: String;
  lJSON: TJsonObject;
begin
  lRnd := IntToStr(10 + Random(90));

  lReq := TJSONRPCRequest.Create(12, 'createuser');
  lReq.Params.Add(fToken);
  lJSON := TJsonObject.Create;
  lJSON.S['username'] := 'user_sender' + lRnd;
  lJSON.S['pwd'] := 'pwd1';
  lJSON.S['roles'] := 'sender';
  lReq.Params.Add(lJSON);
  lResp := fExecutor.ExecuteRequest(lReq);
  ShowMessage('Created user ' + lJSON.S['username'] + ' with id ' + lResp.ResultAsJSONObject.I['userid'].ToString);

  lReq := TJSONRPCRequest.Create(23, 'createuser');
  lReq.Params.Add(fToken);
  lJSON := TJsonObject.Create;
  lJSON.S['username'] := 'user_monitor' + lRnd;
  lJSON.S['pwd'] := 'pwd1';
  lJSON.S['roles'] := 'monitor';
  lReq.Params.Add(lJSON);
  lResp := fExecutor.ExecuteRequest(lReq);
  ShowMessage('Created user ' + lJSON.S['username'] + ' with id ' + lResp.ResultAsJSONObject.I['userid'].ToString);

  lReq := TJSONRPCRequest.Create(34, 'createuser');
  lReq.Params.Add(fToken);
  lJSON := TJsonObject.Create;
  lJSON.S['username'] := 'user_admin' + lRnd;
  lJSON.S['pwd'] := 'pwd1';
  lJSON.S['roles'] := 'admin';
  lReq.Params.Add(lJSON);
  lResp := fExecutor.ExecuteRequest(lReq);
  ShowMessage('Created user ' + lJSON.S['username'] + ' with id ' + lResp.ResultAsJSONObject.I['userid'].ToString);
end;

procedure TUsersForm.btnDeleteUserClick(Sender: TObject);
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
  lUserID: Integer;
begin
  if mtUsers.RecordCount = 0 then
  begin
    raise Exception.Create('Select a user, please');
  end;
  lUserID := mtUsers.FieldByName('id').AsInteger;

  lReq := TJSONRPCRequest.Create(12, 'deleteuser');
  lReq.Params.Add(fToken);
  lReq.Params.Add(lUserID);
  lResp := fExecutor.ExecuteRequest(lReq);
  ShowMessage('User deleted, refresh list to check');
end;

procedure TUsersForm.btnGetUsersClick(Sender: TObject);
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
  lJSONParam: TJsonObject;
begin
  lReq := TJSONRPCRequest.Create(1234, 'getusers');
  lReq.Params.Add(fToken);
  lJSONParam := TJsonObject.Create;
  try
    lJSONParam.S['rql'] := '';
    lReq.Params.Add(lJSONParam);
  except
    lJSONParam.Free;
    raise;
  end;
  lResp := fExecutor.ExecuteRequest(lReq);
  mtUsers.Close;
  mtUsers.Open;
  mtUsers.LoadFromTValue(lResp.ResultAsJSONObject.A['items']);
end;

procedure TUsersForm.btnSetSenderClick(Sender: TObject);
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
  lJSON: TJsonObject;
  lUserID: Integer;
begin
  if mtUsers.Eof then
    raise Exception.Create('Select a user, please');
  lUserID := mtUsers.FieldByName('id').AsInteger;

  lReq := TJSONRPCRequest.Create(12, 'setusersender');
  lReq.Params.Add(fToken);
  lReq.Params.Add(lUserID);
  lJSON := TJsonObject.Create;
  lReq.Params.Add(lJSON);
  lJSON.S['senderaddress'] := 'd.teti@bittime.it';
  lJSON.S['smtphost'] := 'smtp.gmail.com';
  lJSON.I['smtpport'] := 587;
  lJSON.S['smtpusername'] := 'd.teti@bittime.it';
  lJSON.S['smtppassword'] := 'Dan13l1n0!';
  lJSON.B['smtpusessl'] := True;
  lJSON.S['smtpsslversion'] := 'TLSv1';
  lResp := fExecutor.ExecuteRequest(lReq);
  ShowMessage('Sender set for user, refresh list to check');
end;

procedure TUsersForm.btnUpdateUserClick(Sender: TObject);
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
  lJSON: TJsonObject;
  lUserID: Integer;
begin
  if mtUsers.Eof then
  begin
    raise Exception.Create('Please, select a user');
  end;
  lUserID := mtUsers.FieldByName('id').AsInteger;

  lReq := TJSONRPCRequest.Create(12, 'updateuser');
  lReq.Params.Add(fToken);
  lReq.Params.Add(lUserID);
  lJSON := TJsonObject.Create;
  lReq.Params.Add(lJSON);
  // only the field present in the json will be updated. You can also change only the pwd or the roles...
  lJSON.S['username'] := mtUsers.FieldByName('username').AsString + '_changed';
  lJSON.S['pwd'] := 'changed1';
  lJSON.S['roles'] := 'admin,monitor';
  lResp := fExecutor.ExecuteRequest(lReq);
  ShowMessage('User updated, refresh list to check');
end;

constructor TUsersForm.Create(const Token: String; const Executor: IMVCJSONRPCExecutor);
begin
  inherited Create(nil);
  fToken := Token;
  fExecutor := Executor;
end;

procedure TUsersForm.CreateMemTableStructure;
begin
  mtUsers.FieldDefs.Clear;
  mtUsers.FieldDefs.Add('id', ftInteger);
  mtUsers.FieldDefs.Add('username', ftString, 80);
  mtUsers.FieldDefs.Add('roles', ftString, 80);
  mtUsers.FieldDefs.Add('lastlogin', ftString, 30);
  mtUsers.FieldDefs.Add('createdat', ftDateTime);
  mtUsers.FieldDefs.Add('updatedat', ftDateTime);
  mtUsers.CreateDataSet;
end;

procedure TUsersForm.FormCreate(Sender: TObject);
begin
  CreateMemTableStructure;
end;

end.
