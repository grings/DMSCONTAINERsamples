unit MainFormU;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  MVCFramework.JSONRPC,
  MVCFramework.JSONRPC.Client,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Vcl.Grids,
  Vcl.ExtCtrls,
  System.Net.URLClient,
  JsonDataObjects,
  Vcl.DBGrids,
  MVCFramework.Commons,
  Vcl.Imaging.pngimage, EmailRPCProxy;

type
  TMainForm = class(TForm)
    mtMessages: TFDMemTable;
    DataSource1: TDataSource;
    mmToken: TMemo;
    RzDBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    edtRQL: TEdit;
    btnGetMessagesByRQL: TButton;
    Panel3: TPanel;
    btnStatus: TButton;
    btnGetMyMessages: TButton;
    Splitter1: TSplitter;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    btnLoginAsSender: TButton;
    btnLoginAsAdmin: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Panel4: TPanel;
    btnLoginAsMonitor: TButton;
    Button1: TButton;
    Label5: TLabel;
    btnRefreshToken: TButton;
    Panel5: TPanel;
    btnSend: TButton;
    btnSendMsgWithAttachments: TButton;
    Panel6: TPanel;
    btnSendBulkMessages: TButton;
    btnSendText: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnStatusClick(Sender: TObject);
    procedure btnGetMessagesByRQLClick(Sender: TObject);
    procedure btnSendMsgWithAttachmentsClick(Sender: TObject);
    procedure btnSendNewsletterClick(Sender: TObject);
    procedure btnLoginAsSenderClick(Sender: TObject);
    procedure btnLoginAsMonitorClick(Sender: TObject);
    procedure btnLoginAsAdminClick(Sender: TObject);
    procedure btnGetMyMessagesClick(Sender: TObject);
    procedure btnSendBulkMessagesClick(Sender: TObject);
    procedure edtRQLKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure mtMessagesAfterOpen(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRefreshTokenClick(Sender: TObject);
    procedure btnSendTextClick(Sender: TObject);
  private
    fRPCExecutor: IMVCJSONRPCExecutor;
    fToken: string;
    fEmailRPCProxy: IEmailRPCProxy;
    procedure FillWithAttachments(aMetaMessage: TJSONObject);
    procedure CreateMemTableStructure;
    procedure AdjustColumns;
    procedure ValidateCertificateEvent(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
    function ProcessTemplate(const Template: string; const VariablesName: array of string;
      const VariablesValue: array of string): string;
    procedure SetToken(const Value: string);
    function GetToken: string;
    property Token: string read GetToken write SetToken;
    { Private declarations }
  public

  end;

var
  MainForm: TMainForm;

const
  SERVERNAME = 'localhost' { 172.31.3.225 };

implementation

uses
  MVCFramework.DataSet.Utils,
  System.NetEncoding,
  System.UITypes,
  System.IOUtils,
  TemplateProU,
  ConstsU,
  RandomUtilsU,
  Soap.EncdDecd,
  System.DateUtils,
  UsersManagementU,
  FontAwesomeU, UtilsU;

{$R *.dfm}


procedure TMainForm.AdjustColumns;
var
  I: Integer;
begin
  for I := 0 to RzDBGrid1.Columns.Count - 1 do
  begin
    if RzDBGrid1.Columns[I].Width > 200 then
      RzDBGrid1.Columns[I].Width := 200;
  end;
end;

procedure TMainForm.btnGetMessagesByRQLClick(Sender: TObject);
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
  lJSONParam: TJSONObject;
begin
  lReq := TJSONRPCRequest.Create(1234, 'getmessagesbyrql');
  lReq.Params.Add(Token);
  lJSONParam := TJSONObject.Create;
  try
    lJSONParam.S['rql'] := edtRQL.Text;
    lReq.Params.Add(lJSONParam);
  except
    lJSONParam.Free;
    raise;
  end;
  lResp := fRPCExecutor.ExecuteRequest(lReq);
  mtMessages.Close;
  mtMessages.Open;
  mtMessages.LoadFromTValue(lResp.ResultAsJSONObject.A['items']);
end;

procedure TMainForm.btnGetMyMessagesClick(Sender: TObject);
var
  lResp: IJSONRPCResponse;
  lJSONParam: TJsonArray;
begin

  lJSONParam := TJsonArray.Create;
  try
    lJSONParam.Add('ERROR');
    lJSONParam.Add('TO_SEND');
    // lJSONParam.Add('SENT');
    lJSONParam.Add('NOT_COMPLETED');
  except
    lJSONParam.Free;
    raise;
  end;

  lResp := fEmailRPCProxy.GetMyMessages(Token, lJSONParam);
  mtMessages.Close;
  mtMessages.Open;
  mtMessages.LoadFromJSONArray(lResp.ResultAsJSONArray);


  // lReq := TJSONRPCRequest.Create(1234, 'getmymessages');
  // lReq.Params.Add(Token);
  // lJSONParam := TJsonArray.Create;
  // try
  // lJSONParam.Add('ERROR');
  // lJSONParam.Add('TO_SEND');
  // // lJSONParam.Add('SENT');
  // lJSONParam.Add('NOT_COMPLETED');
  // lReq.Params.Add(lJSONParam);
  // except
  // lJSONParam.Free;
  // raise;
  // end;
  // lResp := fRPCExecutor.ExecuteRequest(lReq);
  // mtMessages.Close;
  // mtMessages.Open;
  // mtMessages.LoadFromJSONArray(lResp.ResultAsJSONArray);

end;

procedure TMainForm.btnLoginAsAdminClick(Sender: TObject);
var
  lJObj: TJSONObject;
begin
  lJObj := fEmailRPCProxy.Login('user_admin', 'pwd1');
  try
    Token := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  // lReq := TJSONRPCRequest.Create(1234, 'login');
  // lReq.Params.Add('user_admin');
  // lReq.Params.Add('pwd1');
  // lResp := fRPCExecutor.ExecuteRequest(lReq);
  // Token := lResp.ResultAsJSONObject.S['token'];
end;

procedure TMainForm.btnLoginAsMonitorClick(Sender: TObject);
var
  lJObj: TJSONObject;
begin
  lJObj := fEmailRPCProxy.Login('user_monitor', 'pwd1');
  try
    Token := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  // lReq := TJSONRPCRequest.Create(1234, 'login');
  // lReq.Params.Add('user_monitor');
  // lReq.Params.Add('pwd1');
  // lResp := fRPCExecutor.ExecuteRequest(lReq);
  // Token := lResp.ResultAsJSONObject.S['token'];
end;

procedure TMainForm.btnLoginAsSenderClick(Sender: TObject);
var
  lJObj: TJSONObject;
begin
  lJObj := fEmailRPCProxy.Login('user_sender', 'pwd1');
  try
    Token := lJObj.S['token'];
  finally
    lJObj.Free;
  end;
end;

procedure TMainForm.btnRefreshTokenClick(Sender: TObject);
var
  lJSON: TJSONObject;
begin
  lJSON := fEmailRPCProxy.RefreshToken(Token);
  try
    Token := lJSON.S['token'];
    ShowMessage('Token refreshed');
  finally
    lJSON.Free;
  end;
end;

procedure TMainForm.btnSendBulkMessagesClick(Sender: TObject);
var
  lMetaMessage: TJSONObject;
  lMessageData: TJSONObject;
  lRecipient: TJSONObject;
  lItem: TJSONObject;
  lJObj: TJSONObject;
  lAddresses: TArray<string>;
  I: Integer;
  lWhere: string;
  lWhen: string;
begin
  SetLength(lAddresses, 1);
  if not GetEmailAddessList(lAddresses) then
    Exit;

  /// Let's prepare the metadata of the email message
  /// ////////////////////////////////////////////////////////
  lMetaMessage := TJSONObject.Create;
  try
    lMetaMessage.S['msgsubject'] :=
      '[DMSContainer Email TEST] {{meta.title}} - This email is for {{data.first_name}} {{data.last_name}}';
    lMetaMessage.S['msgbody'] := '';
    lMetaMessage.S['msgbodyhtml'] := TFile.ReadAllText('template.html', TEncoding.UTF8);
    lMetaMessage.S['msgnote'] := '';
    lMetaMessage.B['istest'] := false;
    FillWithAttachments(lMetaMessage);
  except
    lMetaMessage.Free;
    raise;
  end;

  /// Let's prepare the actual recipients data
  /// ////////////////////////////////////////////////////////
  lMessageData := TJSONObject.Create;
  try
    /// META
    lMessageData.O['meta'].S['title'] := '50∞ Anniversary';
    lMessageData.O['meta'].S['organization_name'] := '"Mushrooms and Onions Corp."';

    for I := 0 to Length(lAddresses) - 1 do
    begin
      /// RECIPIENTS
      lRecipient := lMessageData.A['recipients'].AddObject;
      lRecipient.S['msgtolist'] := lAddresses[I];
      lRecipient.S['msgreplytolist'] := 'idee.latenti@gmail.com';

      // Optionally set msgcclist and/or msgbcclist
      // lRecipient.S['msgcclist'] := 'john.doe@email.com';
      // lRecipient.S['msgbcclist'] := 'jane.doe@email.com';
      // lRecipient.S['msgreplytolist'] := 'peter@email.com';
      lRecipient.I['refid'] := I + 1;;
    end;

    lWhere := '1st May Plaza';
    lWhen := 'May, 1st ' + (yearof(Date) + 1).ToString;
    for I := 0 to Length(lAddresses) - 1 do
    begin
      /// ITEMS
      lItem := lMessageData.A['items'].AddObject;
      lItem.S['first_name'] := GetRndFirstName;
      lItem.S['last_name'] := GetRndLastName;
      lItem.S['celebration'] := '50∞ Anniversary of NoWhere';
      lItem.S['where'] := lWhere;
      lItem.S['when'] := lWhen;
    end;
  except
    lMessageData.Free;
    raise;
  end;

  lJObj := fEmailRPCProxy.BulkSendMessages(Token, lMetaMessage, lMessageData);
  try
    ShowMessage('Messages queued: ' + lJObj.A['messagesid'].ToJSON(false));
  finally
    lJObj.Free;
  end;
end;

procedure TMainForm.btnSendClick(Sender: TObject);
var
  lJSONParam: TJSONObject;
  lJObj: TJSONObject;
begin
  if not GetEmailAddesses then
    Exit;

  lJSONParam := TJSONObject.Create;
  try
    lJSONParam.S['msgbody'] := 'This is the message (TEXT+HTML) sent at ' + DateTimeToStr(Now) + ' (test ‡ËÈÏ∞‡ÚÁ)';
    lJSONParam.S['msgbodyhtml'] := 'This is the HTML message sent at ' + DateTimeToStr(Now) + ' (test ‡ËÈÏ∞‡ÚÁ)';
    lJSONParam.S['msgsubject'] := '[DMS EMAIL CLIENT TEST] This is the subject (test ‡ËÈÏ∞‡ÚÁ)';
    lJSONParam.S['msgtolist'] := EmailAddress(MsgToList);
    lJSONParam.S['msgcclist'] := EmailAddress(MsgCCList);
    lJSONParam.S['msgbcclist'] := EmailAddress(MsgBCCList);
    lJSONParam.S['msgreplytolist'] := EmailAddress(MsgReplyToList);
  except
    lJSONParam.Free;
    raise;
  end;

  lJObj := fEmailRPCProxy.SendMessage(Token, lJSONParam);
  try
    ShowMessage('Message queued with messageid = ' + lJObj.I['messageid'].ToString);
  finally
    lJObj.Free;
  end;
end;

procedure TMainForm.btnSendMsgWithAttachmentsClick(Sender: TObject);
var
  lJSONParam: TJSONObject;
  lMsgID: Integer;
  lAttachment: string;
  lAttachments: TArray<string>;
  lJObj: TJSONObject;
begin
  if not GetEmailAddesses then
    Exit;
  // create the message (not send) and get the messageid

  lJSONParam := TJSONObject.Create;
  try
    lJSONParam.S['msgbody'] := 'This message has some attachments';
    lJSONParam.S['msgbodyhtml'] := 'This message <span style="color: red">has</span> some attachments';
    lJSONParam.S['msgsubject'] := '[DMS EMAIL CLIENT TEST] This is the subject';
    lJSONParam.S['msgtolist'] := EmailAddress(MsgToList);
    lJSONParam.S['msgcclist'] := EmailAddress(MsgCCList);
    lJSONParam.S['msgbcclist'] := EmailAddress(MsgBCCList);
    lJSONParam.S['msgreplytolist'] := EmailAddress(MsgReplyToList);
  except
    lJSONParam.Free;
    raise;
  end;

  lJObj := fEmailRPCProxy.CreateMessage(Token, lJSONParam);
  try
    lMsgID := lJObj.I['messageid'];
  finally
    lJObj.Free;
  end;

  // let's add all the attachments
  lAttachments := ['file1.png', 'file2.pdf'];
  for lAttachment in lAttachments do
  begin
    // lReq := TJSONRPCRequest.Create(1234, 'addattachmenttomessage');
    // lReq.Params.Add(Token);
    // lReq.Params.Add(lMsgID);
    // lReq.Params.Add(false); // is not related
    lJSONParam := TJSONObject.Create;
    try
      lJSONParam.S['filename'] := lAttachment;
      lJSONParam.S['filedata'] := TNetEncoding.Base64.EncodeBytesToString(TFile.ReadAllBytes(lAttachment));
    except
      lJSONParam.Free;
      raise;
    end;
    lJObj := fEmailRPCProxy.AddAttachmentToMessage(Token, lMsgID, false, lJSONParam);
    try
      // do nothing
    finally
      lJObj.Free;
    end;
  end;

  // now, "complete" the message and let the job to send it.
  lJObj := fEmailRPCProxy.CompleteMessage(Token, lMsgID);
  try
    // do nothing
  finally
    lJObj.Free;
  end;
  ShowMessage('Message queued with messageid = ' + lMsgID.ToString);

  // create the message (not send) and get the messageid
  // lReq := TJSONRPCRequest.Create(1234, 'createmessage');
  // lReq.Params.Add(Token);
  // lJSONParam := TJSONObject.Create;
  // try
  // lJSONParam.S['msgbody'] := 'This message has some attachments';
  // lJSONParam.S['msgbodyhtml'] := 'This message <span style="color: red">has</span> some attachments';
  // lJSONParam.S['msgsubject'] := '[DMS EMAIL CLIENT TEST] This is the subject';
  // lJSONParam.S['msgtolist'] := MSG_TO_LIST;
  // lJSONParam.S['msgcclist'] := MSG_CC_LIST;
  // lJSONParam.S['msgbcclist'] := MSG_BCC_LIST;
  // except
  // lJSONParam.Free;
  // raise;
  // end;
  // lReq.Params.Add(lJSONParam);
  // lResp := fRPCExecutor.ExecuteRequest(lReq);
  // lMsgID := lResp.ResultAsJSONObject.I['messageid'];
  //
  // // let's add all the attachments
  // lAttachments := ['file1.png', 'file2.pdf'];
  // for lAttachment in lAttachments do
  // begin
  // lReq := TJSONRPCRequest.Create(1234, 'addattachmenttomessage');
  // lReq.Params.Add(Token);
  // lReq.Params.Add(lMsgID);
  // lReq.Params.Add(false); // is not related
  // lJSONParam := TJSONObject.Create;
  // try
  // lJSONParam.S['filename'] := lAttachment;
  // lJSONParam.S['filedata'] := TNetEncoding.Base64.EncodeBytesToString(TFile.ReadAllBytes(lAttachment));
  // lReq.Params.Add(lJSONParam);
  // except
  // lJSONParam.Free;
  // raise;
  // end;
  // fRPCExecutor.ExecuteRequest(lReq);
  // end;
  //
  // // now, "complete" the message and let the job to send it.
  // lReq := TJSONRPCRequest.Create(1234, 'completemessage');
  // lReq.Params.Add(Token);
  // lReq.Params.Add(lMsgID);
  // fRPCExecutor.ExecuteRequest(lReq);
  // ShowMessage('Message queued with messageid = ' + lMsgID.ToString);
end;

procedure TMainForm.btnSendNewsletterClick(Sender: TObject);
var
  lReq: IJSONRPCRequest;
  lResp: IJSONRPCResponse;
  lJSONParam: TJSONObject;
  lMsgID: Integer;
  lAttachment: string;
  lAttachments: TArray<string>;
  I: Integer;
  lCompanyName: string;
  lCompanyAddress: string;
  lSubject: string;
begin
  if MessageDlg('Now DMS will send 3 emails to the same email address to show how to send newsletter.' + sLineBreak +
    'Do you want to procedeed?', mtConfirmation, mbYesNo, 0) <> mrYes then
    Exit;

  for I := 1 to 3 do
  begin
    lSubject := 'A warm welcome from ' + GetRndFirstName() + ' from ' + GetRndCountry();
    lCompanyName := GetRndLastName() + ' Inc Corp.';
    lCompanyAddress := GetRndLastName() + ' street, ' + GetRndCountry();
    // create the message (not send) and get the messageid
    lReq := TJSONRPCRequest.Create(1234, 'createmessage');
    lJSONParam := TJSONObject.Create;
    try
      lJSONParam.S['msgbody'] := 'Your email client doesn''t support HTML';
      lJSONParam.S['msgbodyhtml'] := ProcessTemplate('newsletter_template\blitz_lightblue\index.html',
        ['SUBJECT', 'CUSTOMER_COMPANY_NAME', 'CUSTOMER_COMPANY_ADDRESS'], [lSubject, lCompanyName, lCompanyAddress]);
      lJSONParam.S['msgsubject'] := '[DMS EMAILS JOB TEST] This is a (fake) newsletter';
      lJSONParam.S['msgtolist'] := EmailAddress(MsgToList);
      lJSONParam.S['msgcclist'] := EmailAddress(MsgCCList);
      lJSONParam.S['msgbcclist'] := EmailAddress(MsgBCCList);
      // lJSONParam.S['msgfromaddress'] := MSG_SENDER;
      lReq.Params.Add(fToken);
      lReq.Params.Add(lJSONParam);
    except
      lJSONParam.Free;
      raise;
    end;
    lResp := fRPCExecutor.ExecuteRequest(lReq);
    lMsgID := lResp.ResultAsJSONObject.I['messageid'];

    // let's add all the attachments
    lAttachments := ['newsletter_template\blitz_lightblue\facebook.png', 'newsletter_template\blitz_lightblue\line.png',
      'newsletter_template\blitz_lightblue\twitter.png'];
    for lAttachment in lAttachments do
    begin
      lReq := TJSONRPCRequest.Create(1234, 'addattachmenttomessage');
      lReq.Params.Add(fToken);
      lReq.Params.Add(lMsgID);
      lReq.Params.Add(True); // is html related
      lJSONParam := TJSONObject.Create;
      try
        lJSONParam.I['messageid'] := lMsgID;
        lJSONParam.S['filename'] := TPath.GetFileName(lAttachment);
        lJSONParam.S['filedata'] := TNetEncoding.Base64.EncodeBytesToString(TFile.ReadAllBytes(lAttachment));
        lReq.Params.Add(lJSONParam);
      except
        lJSONParam.Free;
        raise;
      end;
      fRPCExecutor.ExecuteRequest(lReq);
    end;

    // now, "complete" the message and let the job to send it.
    lReq := TJSONRPCRequest.Create(1234, 'completemessage');
    lReq.Params.Add(fToken);
    lReq.Params.Add(lResp.ResultAsJSONObject.I['messageid']);
    fRPCExecutor.ExecuteRequest(lReq);
  end;
  ShowMessage('Just sent 3 messages to the DMS server');
end;

procedure TMainForm.btnSendTextClick(Sender: TObject);
var
  lJSONParam: TJSONObject;
  lJObj: TJSONObject;
begin
  if not GetEmailAddesses then
    Exit;

  lJSONParam := TJSONObject.Create;
  try
    lJSONParam.S['msgbody'] := 'This is the message (TEXT Only) sent at ' + DateTimeToStr(Now) + ' (test ‡ËÈÏ∞‡ÚÁ)';
    lJSONParam.S['msgsubject'] := '[DMS EMAIL CLIENT TEST] This is the subject (test ‡ËÈÏ∞‡ÚÁ)';
    lJSONParam.S['msgtolist'] := EmailAddress(MsgToList);
    lJSONParam.S['msgcclist'] := EmailAddress(MsgCCList);
    lJSONParam.S['msgbcclist'] := EmailAddress(MsgBCCList);
    lJSONParam.S['msgreplytolist'] := EmailAddress(MsgReplyToList);
  except
    lJSONParam.Free;
    raise;
  end;

  lJObj := fEmailRPCProxy.SendMessage(Token, lJSONParam);
  try
    ShowMessage('Message queued with messageid = ' + lJObj.I['messageid'].ToString);
  finally
    lJObj.Free;
  end;
end;

procedure TMainForm.btnStatusClick(Sender: TObject);
var
  lResp: IJSONRPCResponse;
  lJSONParam: TJsonArray;
begin
  lJSONParam := TJsonArray.Create;
  try
    lJSONParam.Add('ERROR');
    lJSONParam.Add('TO_SEND');
    lJSONParam.Add('NOT_COMPLETED');
  except
    lJSONParam.Free;
    raise;
  end;

  lResp := fEmailRPCProxy.GetMessagesByStatus(Token, lJSONParam);
  mtMessages.Close;
  mtMessages.Open;
  mtMessages.LoadFromJSONArray(lResp.ResultAsJSONArray);

  // lReq := TJSONRPCRequest.Create(1234, 'getmessagesbystatus');
  // lReq.Params.Add(Token);
  // lJSONParam := TJsonArray.Create;
  // try
  // lJSONParam.Add('ERROR');
  // lJSONParam.Add('TO_SEND');
  // // lJSONParam.Add('SENT');
  // lJSONParam.Add('NOT_COMPLETED');
  // lReq.Params.Add(lJSONParam);
  // except
  // lJSONParam.Free;
  // raise;
  // end;
  // lResp := fRPCExecutor.ExecuteRequest(lReq);
  // mtMessages.Close;
  // mtMessages.Open;
  // mtMessages.LoadFromJSONArray(lResp.ResultAsJSONArray);
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  lValues: TArray<string>;
  lJObj: TJSONObject;
begin
  lValues := ['', ''];
  // lReq := TJSONRPCRequest.Create(1234, 'login');
  if not InputQuery('Login', ['Username', 'Password'], lValues,
    function(const Values: array of string): Boolean
    begin
      Result := True;
    end) then
    Exit;

  lJObj := fEmailRPCProxy.Login(lValues[0], lValues[1]);
  try
    Token := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  // lReq.Params.Add(lValues[0]);
  // lReq.Params.Add(lValues[1]);
  // lResp := fRPCExecutor.ExecuteRequest(lReq);
  // Token := lResp.ResultAsJSONObject.S['token'];
end;

procedure TMainForm.CreateMemTableStructure;
begin
  mtMessages.FieldDefs.Clear;
  mtMessages.FieldDefs.Add('id', ftInteger);
  mtMessages.FieldDefs.Add('msgfromaddress', ftString, 2000);
  mtMessages.FieldDefs.Add('msgtolist', ftString, 2000);
  mtMessages.FieldDefs.Add('status', ftString, 30);
  mtMessages.FieldDefs.Add('createdat', ftDateTime);
  mtMessages.FieldDefs.Add('sentat', ftDateTime);
  mtMessages.FieldDefs.Add('retrycount', ftInteger);
  mtMessages.FieldDefs.Add('msgcclist', ftString, 2000);
  mtMessages.FieldDefs.Add('msgbcclist', ftString, 2000);
  mtMessages.FieldDefs.Add('msgsubject', ftString, 2000);
  mtMessages.FieldDefs.Add('smtphost', ftString, 30);
  mtMessages.FieldDefs.Add('smtpport', ftInteger);
  mtMessages.FieldDefs.Add('smtpusername', ftString, 30);
  mtMessages.FieldDefs.Add('smtpusessl', ftBoolean);
  mtMessages.FieldDefs.Add('smtpsslversion', ftString, 30);
  mtMessages.FieldDefs.Add('lasterror', ftString, 500);
  mtMessages.FieldDefs.Add('msgnote', ftString, 5000);
  mtMessages.CreateDataSet;

  mtMessages.FieldByName('msgfromaddress').DisplayWidth := 50;
  mtMessages.FieldByName('msgtolist').DisplayWidth := 50;
  mtMessages.FieldByName('msgcclist').DisplayWidth := 50;
  mtMessages.FieldByName('msgbcclist').DisplayWidth := 50;
  mtMessages.FieldByName('msgsubject').DisplayWidth := 50;
  AdjustColumns;
end;

procedure TMainForm.edtRQLKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnGetMessagesByRQLClick(self);
    Key := #0;
  end;
end;

procedure TMainForm.FillWithAttachments(aMetaMessage: TJSONObject);
var
  lJSON: TJSONObject;
begin
  // Modello invito
  lJSON := aMetaMessage.A['attachments'].AddObject();

  lJSON.S['filename'] := 'Invite Mr {{data.last_name}}.pdf';
  lJSON.S['filedata'] := FileToBase64String('template.docx');
  lJSON.B['istemplate'] := True;

  // Altro allegato non parametrico
  lJSON := aMetaMessage.A['attachments'].AddObject();
  lJSON.S['filename'] := 'Dressing Code for Mr {{data.first_name}} {{data.last_name}}.pdf';
  lJSON.S['filedata'] := FileToBase64String('non_template_attachment.pdf');
  lJSON.B['istemplate'] := false;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  fEmailRPCProxy.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fEmailRPCProxy := TEmailRPCProxy.Create('https://' + SERVERNAME + '/emailrpc');
  fEmailRPCProxy.RPCExecutor.SetOnValidateServerCertificate(ValidateCertificateEvent);
  InstallFont(self);

  fRPCExecutor := TMVCJSONRPCExecutor.Create('https://' + SERVERNAME + '/emailrpc');
  fRPCExecutor.SetOnValidateServerCertificate(ValidateCertificateEvent);

  CreateMemTableStructure;
  Caption := Caption + ' (Using ' + SERVERNAME + ')';
end;

function TMainForm.GetToken: string;
begin
  Result := fToken;
end;

procedure TMainForm.mtMessagesAfterOpen(DataSet: TDataSet);
begin
  AdjustColumns;
end;

function TMainForm.ProcessTemplate(const Template: string;
const VariablesName, VariablesValue: array of string): string;
var
  lTemplate: string;
  lTPro: TTemplateProEngine;
  I: Integer;
  lSS: TStringStream;
begin
  if Length(VariablesName) <> Length(VariablesValue) then
    raise Exception.Create('Variables name and variables value must have the same size');

  lTemplate := TFile.ReadAllText(Template, TEncoding.UTF8);
  lTPro := TTemplateProEngine.Create(TEncoding.UTF8);
  try
    for I := 0 to Length(VariablesName) - 1 do
    begin
      lTPro.SetVar(VariablesName[I], VariablesValue[I]);
    end;
    lSS := TStringStream.Create('', TEncoding.UTF8);
    try
      lTPro.Execute(lTemplate, lSS);
      Result := lSS.DataString;
    finally
      lSS.Free;
    end;
  finally
    lTPro.Free;
  end;
end;

procedure TMainForm.SetToken(const Value: string);
begin
  fToken := Value;
  mmToken.Lines.Text := fToken;
end;

procedure TMainForm.ValidateCertificateEvent(const Sender: TObject; const ARequest: TURLRequest;
const Certificate: TCertificate; var Accepted: Boolean);
begin
  Accepted := True;
end;

end.
