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
  System.Net.URLClient,
  JsonDataObjects;

type
  TMainForm = class(TForm)
    btnSendSimpleEmail: TButton;
    btnSendEmailWithAttachments: TButton;
    btnSendBulkMessages: TButton;
    chkIsTest: TCheckBox;
    btnSearchForMessage: TButton;
    Memo1: TMemo;
    procedure btnSendSimpleEmailClick(Sender: TObject);
    procedure btnSendEmailWithAttachmentsClick(Sender: TObject);
    procedure btnSendBulkMessagesClick(Sender: TObject);
    procedure btnSearchForMessageClick(Sender: TObject);
  private
    procedure ValidateCertificateEvent(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
    procedure FillWithAttachments(aMetaMessage: TJSONObject);
    function FileToBase64String(const aFileName: string): string;
  public
    { Public declarations }
  end;

const
  SERVERNAME = 'localhost';
  // SERVERNAME = '172.31.3.225';

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  EmailRPCProxy,
  System.NetEncoding,
  System.IOUtils;

procedure TMainForm.btnSearchForMessageClick(Sender: TObject);
var
  lMetaMessage: TJSONObject;
  lMessageData: TJSONObject;
  lRecipient: TJSONObject;
  lItem: TJSONObject;
  lDMS: IEmailRPCProxy;
  lJObj: TJSONObject;
  lToken: string;
  lJResp: TJSONObject;
  lJSON: TJSONObject;
begin
  lDMS := TEmailRPCProxy.Create('https://' + SERVERNAME + '/emailrpc');

  // by default the https certificate is self signed... let's igore the CA
  lDMS.RPCExecutor.SetOnValidateServerCertificate(ValidateCertificateEvent);

  lJObj := lDMS.Login('user_admin', 'pwd1');
  try
    lToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  lJSON := TJSONObject.Create;

  //lJSON.S['rql'] := 'in(status,["TO_SEND","ERROR"])';
  //lJSON.S['rql'] := 'contains(msgtolist,"@bittime.it")';
  lJResp := lDMS.GetMessagesByRQL(lToken, lJSON);
  try
    Memo1.Lines.Text := lJResp.ToJson(false);
  finally
    lJResp.Free;
  end;
end;

procedure TMainForm.btnSendBulkMessagesClick(Sender: TObject);
var
  lMetaMessage: TJSONObject;
  lMessageData: TJSONObject;
  lRecipient: TJSONObject;
  lItem: TJSONObject;
  lDMS: IEmailRPCProxy;
  lJObj: TJSONObject;
  lToken: string;
  lJResp: TJSONObject;
begin
  lDMS := TEmailRPCProxy.Create('https://' + SERVERNAME + '/emailrpc');

  // by default the https certificate is self signed... let's igore the CA
  lDMS.RPCExecutor.SetOnValidateServerCertificate(ValidateCertificateEvent);

  // login with default username/pwd for a user with a "sender" role
  lJObj := lDMS.Login('user_sender', 'pwd1');
  try
    lToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  // let's prepare the message template to send
  lMetaMessage := TJSONObject.Create;
  try
    lMetaMessage.S['msgsubject'] :=
      '{{meta.title}} - This message is for {{data.first_name}} {{data.last_name}}';
    lMetaMessage.S['msgbodyhtml'] := '<h3>Dear {{data.title}} {{data.first_name}} </h3>' +
      '<p>We are really glad to send this email to you, and we really appreciate a kind reply</p>' +
      '<p>This email is sent to {{data.title}}{{data.first_name}}{{data.last_name}}</p>';

    FillWithAttachments(lMetaMessage);

    lMessageData := TJSONObject.Create;
    try

      /// META - this section will be available to all the email.
      // Put here some general information that will be the same for all the messages
      lMessageData.O['meta'].S['title'] := 'THIS IS A DMSCONTAINER TEST';

      /// RECIPIENTS
      lRecipient := lMessageData.A['recipients'].AddObject;
      lRecipient.S['msgtolist'] := 'd.teti@bittime.it';
      // lRecipient.S['msgcclist'] := MSG_CC_LIST;
      // lRecipient.S['msgbcclist'] := MSG_BCC_LIST;
      lRecipient.I['refid'] := 1; // (optional)your client reference to this message

      lRecipient := lMessageData.A['recipients'].AddObject;
      lRecipient.S['msgtolist'] := 'daniele.teti@bittime.it';
      lRecipient.I['refid'] := 2; // (optional)your client reference to this message

      lRecipient := lMessageData.A['recipients'].AddObject;
      lRecipient.S['msgtolist'] := 'd.teti@delphistudio.es';
      lRecipient.I['refid'] := 3; // (optional)your client reference to this message

      /// ITEMS -- here we have to load all the "data" to produce the actual emails
      lItem := lMessageData.A['items'].AddObject;
      lItem.S['first_name'] := 'Giuseppe';
      lItem.S['last_name'] := 'Verdi';
      lItem.S['title'] := 'Mr.';

      lItem := lMessageData.A['items'].AddObject;
      lItem.S['first_name'] := 'Marie';
      lItem.S['last_name'] := 'Curie';
      lItem.S['title'] := 'Mrs.';

      lItem := lMessageData.A['items'].AddObject;
      lItem.S['first_name'] := 'Isaac';
      lItem.S['last_name'] := 'Asimov';
      lItem.S['title'] := 'Mr.';

    except
      lMessageData.Free;
      raise;
    end;
  except
    lMetaMessage.Free;
    raise;
  end;

  lJResp := lDMS.BulkSendMessages(lToken, lMetaMessage, lMessageData);
  try
    ShowMessage('Server Response: ' + sLineBreak + lJResp.ToJSON(false));
  finally
    lJResp.Free;
  end;
end;

procedure TMainForm.btnSendEmailWithAttachmentsClick(Sender: TObject);
var
  lDMS: IEmailRPCProxy;
  lJObj: TJSONObject;
  lJMsg: TJSONObject;
  lToken: string;
  lJResp: TJSONObject;
  lMessageID: Integer;
  lAttachments: TArray<string>;
  lAttachment: string;
  lJAttachment: TJSONObject;
begin
  lDMS := TEmailRPCProxy.Create('https://' + SERVERNAME + '/emailrpc');

  // by default the https certificate is self signed... let's igore the CA
  lDMS.RPCExecutor.SetOnValidateServerCertificate(ValidateCertificateEvent);

  // login with default username/pwd for a user with a "sender" role
  lJObj := lDMS.Login('user_sender', 'pwd1');
  try
    lToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  // let's prepare the message to send
  lJMsg := TJSONObject.Create;
  try
    lJMsg.S['msgbody'] := 'This is a text body! The message has been sent at ' + DateTimeToStr(Now);
    lJMsg.S['msgbodyhtml'] := 'This is an HTML body! The message has been sent at ' +
      DateTimeToStr(Now);
    lJMsg.S['msgsubject'] := 'DMSContainer \\ This is the subject';
    lJMsg.S['msgtolist'] := 'd.teti@bittime.it';
    lJMsg.S['msgcclist'] := 'd.teti@bittime.it;daniele@bittime.it';

    // Sending attachments can be slow, let's send one by one...

    // The first step is to create the message.
    // This message will not actually sent before the completition
    lJResp := lDMS.CreateMessage(lToken, lJMsg.Clone);
    try
      lMessageID := lJResp.I['messageid'];
    finally
      lJResp.Free;
    end;
  finally
    lJMsg.Free;
  end;

  // let's add all the attachments
  lAttachments := ['file1.png', 'file2.pdf'];
  for lAttachment in lAttachments do
  begin
    lJAttachment := TJSONObject.Create;
    try
      lJAttachment.S['filename'] := lAttachment;
      lJAttachment.S['filedata'] := FileToBase64String(lAttachment);
      lDMS.AddAttachmentToMessage(lToken, lMessageID, false, lJAttachment);
    except
      // no memory leaks in case of exception
      lJAttachment.Free;
      raise;
    end;
  end;

  lJResp := lDMS.CompleteMessage(lToken, lMessageID);
  try
    lMessageID := lJResp.I['messageid'];
  finally
    lJResp.Free;
  end;
  ShowMessage('Message enqueued with messageid = ' + lMessageID.ToString);

end;

procedure TMainForm.btnSendSimpleEmailClick(Sender: TObject);
var
  lDMS: IEmailRPCProxy;
  lJObj: TJSONObject;
  lJMsg: TJSONObject;
  lToken: string;
  lJResp: TJSONObject;
  lMessageID: Integer;
begin
  lDMS := TEmailRPCProxy.Create('https://' + SERVERNAME + '/emailrpc');

  // by default the https certificate is self signed... let's igore the CA
  lDMS.RPCExecutor.SetOnValidateServerCertificate(ValidateCertificateEvent);

  // login with default username/pwd for a user with a "sender" role
  lJObj := lDMS.Login('user_sender', 'pwd1');
  try
    lToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;

  // let's prepare the message to send
  lJMsg := TJSONObject.Create;
  lJMsg.S['msgbody'] := 'This is a text body! The message has been sent at ' + DateTimeToStr(Now);
  lJMsg.S['msgbodyhtml'] := 'This is an HTML body! The message has been sent at ' +
    DateTimeToStr(Now);
  lJMsg.S['msgsubject'] := 'DMSContainer \\ This is the subject';
  lJMsg.S['msgtolist'] := 'd.teti@bittime.it';
  lJMsg.B['istest'] := chkIsTest.Checked;
  // lJMsg.S['msgcclist'] := 'email1@domain.com;email2@domain.com etc';
  // lJMsg.S['msgbcclist'] := 'email1@domain.com;email2@domain.com etc';

  // Actually ask to DMSContainer to send the email.
  // No need to free lJMsg - it will be freed by proxy.
  lJResp := lDMS.SendMessage(lToken, lJMsg);
  try
    lMessageID := lJResp.I['messageid'];
  finally
    lJResp.Free;
  end;
  ShowMessage('Message enqueued with messageid = ' + lMessageID.ToString);
end;

function TMainForm.FileToBase64String(const aFileName: string): string;
begin
  Result := TNetEncoding.Base64.EncodeBytesToString(TFile.ReadAllBytes(aFileName));
end;

procedure TMainForm.FillWithAttachments(aMetaMessage: TJSONObject);
var
  lJSON: TJSONObject;
begin
  // Attachment template - will be attaced as pdf
  lJSON := aMetaMessage.A['attachments'].AddObject();
  lJSON.S['filename'] := 'Mr {{data.first_name}} {{data.last_name}}.pdf';
  lJSON.S['filedata'] := FileToBase64String('template_pdf_attachment.docx');
  lJSON.B['istemplate'] := true;

  // Another attachment, this time is not a template... just an attached file
  lJSON := aMetaMessage.A['attachments'].AddObject();
  lJSON.S['filename'] := 'Plain attachment.pdf';
  lJSON.S['filedata'] := FileToBase64String('plain_pdf_attachment.pdf');
  lJSON.B['istemplate'] := false;
end;

procedure TMainForm.ValidateCertificateEvent(const Sender: TObject; const ARequest: TURLRequest;
  const Certificate: TCertificate; var Accepted: Boolean);
begin
  Accepted := true;
end;

end.
