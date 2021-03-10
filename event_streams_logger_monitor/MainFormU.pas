unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, EventStreamsRPCProxy, Vcl.StdCtrls,
  Vcl.ExtCtrls, System.Net.URLClient, JsonDataObjects, System.Threading,
  Vcl.ComCtrls,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids;

type
  TMainForm = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    EditQueueName: TEdit;
    btnStartStop: TButton;
    lvProcess: TListView;
    Splitter1: TSplitter;
    Panel1: TPanel;
    pcLogs: TPageControl;
    TabSheet1: TTabSheet;
    MemoMessage: TMemo;
    tsError: TTabSheet;
    DBGridError: TDBGrid;
    dsLogs: TFDMemTable;
    DataSource1: TDataSource;
    tsAll: TTabSheet;
    DBGridAll: TDBGrid;
    Panel4: TPanel;
    tsWarning: TTabSheet;
    tsInfo: TTabSheet;
    tsDebug: TTabSheet;
    DBGridDebug: TDBGrid;
    DBGridInfo: TDBGrid;
    DBGridWarning: TDBGrid;
    dsLogsid: TStringField;
    dsLogstimestamp: TStringField;
    dsLogstext: TStringField;
    dsLogstype: TStringField;
    dsLogstid: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure lvProcessSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure pcLogsChange(Sender: TObject);
    procedure DBGridAllDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
  private
    fProxy: IEventStreamsRPCProxy;
    fToken: string;
    fFilterId: string;
    fFilterType: string;
    fCurrentTask: ITask;
    function StartTask: ITask;
    procedure StopTask;
    procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
      const Certificate: TCertificate; var Accepted: Boolean);
    function MakeConsumer(const Token, QueueName: String): TProc;
    procedure Log(const Msg: String);
    procedure DequeueMessage(const QueueName, LastKnownID: String);
    procedure AddProcessItem(const info: TJsonObject);
    procedure PopulateDataSet(const Msg: TJsonObject);
    function BuildUniqueKey(const info: TJsonObject): string;
    procedure FilterDataset;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

const
  ENDPOINT = 'https://localhost/eventstreamsrpc';
  SYM_START = 'Start Monitor ▶';
  SYM_STOP = 'Stop Monitor ⏹';
  SHOW_ALL_INSTANCES = '<Show All Instances>';

implementation

{$R *.dfm}

uses System.SyncObjs, MVCFramework.Logger, System.TimeSpan;

var
  GShutDown: Int64 = 0;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  DequeueMessage(EditQueueName.Text, '__first__');
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  lListItem: TListItem;
begin
  if Assigned(fCurrentTask) then
  begin
    StopTask;
  end
  else
  begin
    fCurrentTask := StartTask();
    btnStartStop.Caption := SYM_STOP;
    lvProcess.Items.Clear;
    lListItem := lvProcess.Items.Add;
    lListItem.Caption := SHOW_ALL_INSTANCES;
  end;
end;

function TMainForm.BuildUniqueKey(const info: TJsonObject): string;
begin
  // username@computername(processname)[pid]
  Result := info.S['username'] + '@' + info.S['computername'] + '(' + info.S['processname'] + ')[' +
    info.I['pid'].ToString + ']';
end;

procedure TMainForm.FilterDataset;
var
  lFilter: string;
begin
  dsLogs.Filtered := False;
  if fFilterId <> '' then
    lFilter := fFilterId
  else
    lFilter := '1 = 1 ';

  dsLogs.Filter := lFilter + ' AND ' + fFilterType;
  dsLogs.Filtered := True;

end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  TInterlocked.Increment(GShutDown);
  StopTask;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  lJObj: TJsonObject;
begin
  fProxy := TEventStreamsRPCProxy.Create(ENDPOINT);
  fProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
  lJObj := fProxy.Login('user_event', 'pwd1');
  try
    fToken := lJObj.S['token'];
  finally
    lJObj.Free;
  end;
  btnStartStop.Caption := SYM_START;

  fFilterType := '1 = 1 ';
  fFilterId := '1 = 1 ';
end;


procedure AssignColumnSize(DBGridSrc, DBGridDest: TDBGrid);
var
  I: Integer;
begin
  for I := 0 to DBGridDest.Columns.Count-1 do
  begin
    DBGridDest.Columns[I].Width := DBGridSrc.Columns[I].Width;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  pcLogs.ActivePageIndex := 0;
  AssignColumnSize(DBGridDebug, DBGridInfo);
  AssignColumnSize(DBGridDebug, DBGridWarning);
  AssignColumnSize(DBGridDebug, DBGridError);
end;

procedure TMainForm.DBGridAllDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
var
  lCanvas: TCanvas;
begin
  lCanvas := (Sender as TDBGrid).Canvas;
  if dsLogs.FieldByName('type').AsString = 'DEBUG' then
    lCanvas.Brush.Color := clCream;
  if dsLogs.FieldByName('type').AsString = 'INFO' then
    lCanvas.Brush.Color := clHighlight;
  if dsLogs.FieldByName('type').AsString = 'WARNING' then
    lCanvas.Brush.Color := clYellow;
  if dsLogs.FieldByName('type').AsString = 'ERROR' then
  begin
    lCanvas.Brush.Color := clRed; // RGB($ff,$c0,$c0);
    lCanvas.Font.Color := clWhite; // RGB($ff,$c0,$c0);
  end;
  DBGridAll.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TMainForm.DequeueMessage(const QueueName, LastKnownID: String);
var
  lLastMgsID: string;
  lJMessage: TJsonObject;
begin
  lLastMgsID := LastKnownID;
  try
    lJMessage := fProxy.DequeueMultipleMessage(fToken, QueueName, lLastMgsID, 1, 10);
    try
      if lJMessage.B['timeout'] then
      begin
        Log('Timeout');
      end
      else
      begin
        begin
          // EditLastKnownID.Text := lJMessage.A['data'][0].S['messageid'];
        end;
        Log(lJMessage.ToJSON());
      end;
    finally
      lJMessage.Free;
    end;
  except
    on E: Exception do
    begin
      Log(E.Message);
    end;
  end;
end;

procedure TMainForm.Log(const Msg: String);
var
  lStr: String;
begin
  lStr := Format('%s: %s', [DateTimeToStr(now), Msg]);
  TThread.Queue(nil,
    procedure
    begin
      MemoMessage.Lines.Add(lStr);
      if MemoMessage.Lines.Count > 5000 then
      begin
        MemoMessage.Lines.Clear; //it's just a demo :-)
      end;
    end);
end;

procedure TMainForm.lvProcessSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Item.Caption = SHOW_ALL_INSTANCES then
    fFilterId := ''
  else
    fFilterId := 'id = ' + QuotedStr(Item.Caption) + '';

  FilterDataset;
end;

procedure TMainForm.AddProcessItem(const info: TJsonObject);
var
  lListItem: TListItem;
  lid: string;
begin
  lid := BuildUniqueKey(info);
  lListItem := lvProcess.FindCaption(0, lid, False, True, True);
  if not Assigned(lListItem) then
  begin
    lListItem := lvProcess.Items.Add;
    lListItem.Caption := lid;
  end;

end;

function TMainForm.MakeConsumer(const Token, QueueName: String): TProc;
begin
  Result := procedure
    var
      lProxy: TEventStreamsRPCProxy;
      lJSON: TJsonObject;
      lLastKnownID: String;
      I: Integer;
    begin
      lProxy := TEventStreamsRPCProxy.Create(ENDPOINT);
      try
        lProxy.RPCExecutor.SetOnValidateServerCertificate(OnValidateCert);
        lLastKnownID := '__last__';
        while (TTask.CurrentTask.Status <> TTaskStatus.Canceled) do
        begin
          try
            lJSON := lProxy.DequeueMultipleMessage(Token, QueueName, lLastKnownID, 20, 10);
            try
              if TTask.CurrentTask.Status = TTaskStatus.Canceled then
              begin
                Break;
              end;
              if lJSON.B['timeout'] then
              begin
                Log('Timeout');
              end
              else
              begin
                for I := 0 to lJSON.A['data'].Count - 1 do
                begin
                  lLastKnownID := lJSON.A['data'][I].ObjectValue.S['messageid'];
                  Log(lJSON.A['data'][I].ObjectValue.ToJSON(True));

                  TThread.Synchronize(nil,
                    Procedure
                    begin
                      AddProcessItem(lJSON.A['data'][I].ObjectValue.O['message'].O['info']);
                      PopulateDataSet(lJSON.A['data'][I].ObjectValue.O['message']);
                    end);
                end;
              end;
            finally
              lJSON.Free;
            end;
          except
            Sleep(1000);
          end;
        end;
      finally
        lProxy.Free;
      end;
    end;
end;

procedure TMainForm.OnValidateCert(const Sender: TObject; const ARequest: TURLRequest;
const Certificate: TCertificate; var Accepted: Boolean);
begin
  Accepted := True;
end;

procedure TMainForm.pcLogsChange(Sender: TObject);
begin

  case pcLogs.ActivePageIndex of
    1:
      fFilterType := 'type = ' + QuotedStr('DEBUG') + '';
    2:
      fFilterType := 'type = ' + QuotedStr('INFO') + '';
    3:
      fFilterType := 'type = ' + QuotedStr('WARNING') + '';
    4:
      fFilterType := 'type = ' + QuotedStr('ERROR') + '';
  else
    fFilterType := '1 = 1 ';
  end;

  FilterDataset;
end;

procedure TMainForm.PopulateDataSet(const Msg: TJsonObject);
begin
  with dsLogs do
  begin
    Open;
    Append;
    Fields[0].AsString := BuildUniqueKey(Msg.O['info']);
    Fields[1].AsString := Msg.S['timestamp'];
    Fields[2].AsString := Msg.S['text'];
    Fields[3].AsString := Msg.S['type'];
    Fields[4].AsInteger := Msg.I['tid'];
    Post;
  end;
end;

function TMainForm.StartTask: ITask;
var
  lConsumer: TProc;
begin
  MemoMessage.Lines.Add('** CONSUMER START **');
  lConsumer := MakeConsumer(fToken, EditQueueName.Text);
  Result := TTask.Run(lConsumer);
end;

procedure TMainForm.StopTask;
begin
  if Assigned(fCurrentTask) then
  begin
    MemoMessage.Lines.Add('** CONSUMER STOP **');
    fCurrentTask.Cancel;
    while not(fCurrentTask.Status in [TTaskStatus.Completed, TTaskStatus.Canceled]) do
    begin
      Sleep(200);
      Application.ProcessMessages;
    end;
    fCurrentTask := nil;
  end;
  btnStartStop.Caption := SYM_START;
end;

end.
