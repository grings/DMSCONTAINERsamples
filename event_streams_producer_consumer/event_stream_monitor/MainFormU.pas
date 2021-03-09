unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls,
  EventStreamsRPCProxy, System.Net.URLClient, System.Threading, System.UITypes,
  System.Generics.Collections, ConsumerThreadU;

type
  TMainForm = class(TForm)
    sg: TStringGrid;
    Panel1: TPanel;
    btnStart: TButton;
    Label1: TLabel;
    Timer1: TTimer;
    procedure btnStartClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure sgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    fCellFontSize, fLastGoodFontSize: Integer;
    fTotalMessageCount : Integer;
    fTasks: TArray<TConsumerThread>;
    fQueue: TThreadedQueue<TPair<Integer, String>>;
    procedure UpdateCell(const Index: Integer; const Value: string);
  public
  end;

var
  MainForm: TMainForm;

implementation

uses
  JsonDataObjects, System.SyncObjs, UtilsU, GraphUtil, System.Math,
  MVCFramework.JSONRPC, MVCFramework.Logger;

{$R *.dfm}

const
  WORKER_THREAD_COUNT = 48;

procedure TMainForm.btnStartClick(Sender: TObject);
var
  lQueueName: string;
  lValues: TArray<string>;
begin
  btnStart.Enabled := False;
  lValues := ['user_event', 'pwd1', 'queue.test1'];
  if not InputQuery('DMSContainer :: EventStreams Monitor',
    ['UserName', 'Password', 'Queue Name'], lValues) then
  begin
    Application.Terminate;
    Exit;
  end;
  lQueueName := lValues[2];
  Label1.Caption := lQueueName;
  for var i := 0 to WORKER_THREAD_COUNT - 1 do
  begin
    fTasks[i] := TConsumerThread.Create(i, lQueueName, fQueue);
    fTasks[i].Start;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: Integer;
begin
  TInterlocked.Increment(GShutDown);
  for i := 0 to WORKER_THREAD_COUNT - 1 do
  begin
    if not Assigned(fTasks[i]) then
    begin
      Continue;
    end;
    fTasks[i].WaitFor;
    fTasks[i].Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SetLength(fTasks, WORKER_THREAD_COUNT);
  fQueue := TThreadedQueue<TPair<Integer, String>>.Create(20000,500000,1);
  fTotalMessageCount := 0;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  fQueue.DoShutDown;
  fQueue.Free;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  sg.DefaultColWidth := sg.ClientWidth div 8;
  sg.DefaultRowHeight := sg.ClientHeight div 6;
  fCellFontSize := sg.ClientHeight div 12;
  fLastGoodFontSize := fCellFontSize;
end;

function Brighten(AColor: TColor; ALuminanceToAdd: Word): TColor;
var
  H, S, L: Word;
begin
  ColorRGBToHLS(AColor, H, L, S);
  Result := ColorHLSToRGB(H, Min(255, L + ALuminanceToAdd), S);
end;

function DrawTextCentered(Canvas: TCanvas; const R: TRect; S: String): Integer;
var
  DrawRect: TRect;
  DrawFlags: Cardinal;
  DrawParams: TDrawTextParams;
begin
  DrawRect := R;
  DrawFlags := DT_END_ELLIPSIS or DT_NOPREFIX or DT_WORDBREAK or
    DT_EDITCONTROL or DT_CENTER;
  DrawText(Canvas.Handle, PChar(S), -1, DrawRect, DrawFlags or DT_CALCRECT);
  DrawRect.Right := R.Right;
  if DrawRect.Bottom < R.Bottom then
    OffsetRect(DrawRect, 0, (R.Bottom - DrawRect.Bottom) div 2)
  else
    DrawRect.Bottom := R.Bottom;
  ZeroMemory(@DrawParams, SizeOf(DrawParams));
  DrawParams.cbSize := SizeOf(DrawParams);
  DrawTextEx(Canvas.Handle, PChar(S), -1, DrawRect, DrawFlags, @DrawParams);
  Result := DrawParams.uiLengthDrawn;
end;

procedure TMainForm.sgDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  var lText := sg.Cells[ACol, ARow];
  var lMsgCount := lText.Substring(0, lText.IndexOf('|'));
  lText := lText.Substring(lText.Length - 7);
  sg.Canvas.Brush.Color := Brighten(TColor(StrToIntDef(lText, 0)), 20);
  var lRect: TRect := Rect;
  lRect.Inflate(-1, -1);
  sg.Canvas.FillRect(lRect);
  lRect.Inflate(-3, -3);

  sg.Canvas.Font.Size := fLastGoodFontSize;
  while sg.Canvas.TextWidth(lMsgCount) >= lRect.Width  do
  begin
    Dec(fLastGoodFontSize, 1);
    sg.Canvas.Font.Size := fLastGoodFontSize;
  end;
  sg.Canvas.Font.Color := InvertColor(sg.Canvas.Brush.Color);
  DrawTextCentered(sg.Canvas, lRect, lMsgCount);
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  lItem: TPair<Integer, String>;
  lCount: Integer;
begin
  if TInterlocked.Read(GShutDown) > 0 then
  begin
    Exit;
  end;
  lCount := 0;
  while fQueue.PopItem(lItem) = TWaitResult.wrSignaled do
  begin
    Inc(fTotalMessageCount);
    UpdateCell(lItem.Key, lItem.Value);
    Inc(lCount);
    if lCount > 5 then
    begin
      Break;
    end;
  end;
  Caption := 'Total Messages: ' + fTotalMessageCount.ToString;
end;

procedure TMainForm.UpdateCell(const Index: Integer; const Value: string);
var
  lRow: Integer;
  lCol: Integer;
begin
  lCol := index mod sg.ColCount;
  lRow := index div sg.ColCount;
  sg.Cells[lCol, lRow] := Value;
end;

end.
