unit PdfFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, PdfiumCtrl,
  Vcl.ComCtrls;

type
  TframePDF = class(TFrame)
    Panel5: TPanel;
    btnNext: TButton;
    btnPrev: TButton;
    btnScale: TButton;
    btnPrint: TButton;
    ScrollBar1: TScrollBar;
    btnLast: TButton;
    btnFirst: TButton;
    StatusBar1: TStatusBar;
    PrintDialog1: TPrintDialog;
    pnlGenReports: TPanel;
    Label2: TLabel;
    ListBox1: TListBox;
    procedure btnPrevClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnScaleClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
    fPDFViewer: TPdfControl;
    procedure UpdateGUI;
    procedure LoadFile(const FileName: string);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadDirectory(const Directory: string);
    procedure Clear;

    { Public declarations }

  end;

implementation

uses
  Vcl.printers, PdfiumCore, System.TypInfo, System.IOUtils;

{$R *.dfm}

{ TframePDF }

procedure TframePDF.btnFirstClick(Sender: TObject);
begin
  fPDFViewer.PageIndex := 0;
  UpdateGUI;
end;

procedure TframePDF.btnLastClick(Sender: TObject);
begin
  fPDFViewer.PageIndex := fPDFViewer.PageCount - 1;
  UpdateGUI;
end;

procedure TframePDF.btnNextClick(Sender: TObject);
begin
  fPDFViewer.GotoNextPage(true);
  UpdateGUI;
end;

procedure TframePDF.btnPrevClick(Sender: TObject);
begin
  fPDFViewer.GotoPrevPage(true);
  UpdateGUI;
end;

procedure TframePDF.btnPrintClick(Sender: TObject);
begin
  if PrintDialog1.Execute(Handle) then
  begin
    Printer.BeginDoc;
    try
      fPDFViewer.CurrentPage.Draw(Printer.Canvas.Handle, 0, 0, Printer.PageWidth,
        Printer.PageHeight, prNormal, [proAnnotations, proPrinting]);
    finally
      Printer.EndDoc;
    end;
  end;
end;

procedure TframePDF.btnScaleClick(Sender: TObject);
begin
  if fPDFViewer.ScaleMode = high(fPDFViewer.ScaleMode) then
    fPDFViewer.ScaleMode := low(fPDFViewer.ScaleMode)
  else
    fPDFViewer.ScaleMode := Succ(fPDFViewer.ScaleMode);
  UpdateGUI;
end;

procedure TframePDF.Clear;
begin
  fPDFViewer.Close;
  ListBox1.Clear;
  UpdateGUI;
end;

constructor TframePDF.Create(AOwner: TComponent);
begin
  inherited;
  fPDFViewer := TPdfControl.Create(self);
  fPDFViewer.Align := alClient;
  fPDFViewer.Parent := self;
  fPDFViewer.SendToBack; // put the control behind the buttons
  fPDFViewer.Color := clGray;
  fPDFViewer.ScaleMode := smFitWidth;
  fPDFViewer.PageColor := RGB(255, 255, 200);
  UpdateGUI;
end;

destructor TframePDF.Destroy;
begin
  fPDFViewer.Free;
  inherited;
end;

procedure TframePDF.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.ItemIndex >= 0 then

    LoadFile(ListBox1.Items.ValueFromIndex[ListBox1.ItemIndex]);
end;

procedure TframePDF.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  lr: TRect;
  ltxt: string;
begin
  lr := Rect;
  ltxt := ListBox1.items.names[index];
  ListBox1.Canvas.TextRect(lr, ltxt);
end;

procedure TframePDF.LoadDirectory(const Directory: string);
var
  lFiles: TArray<string>;
  lFile: string;
begin
  ListBox1.Items.Clear;
  lFiles := TDirectory.GetFiles(Directory, '*.pdf');
  for lFile in lFiles do
  begin
    ListBox1.Items.Values[TPath.GetFileName(lFile)] := (lFile);
  end;
  if ListBox1.Items.Count > 0 then
  begin
    ListBox1.ItemIndex := 0;
    ListBox1DblClick(ListBox1);
  end;

end;

procedure TframePDF.LoadFile(const FileName: string);
begin
  fPDFViewer.LoadFromFile(FileName, '', dloNormal);
  fPDFViewer.ZoomPercentage := 100;
  UpdateGUI;
end;

procedure TframePDF.ScrollBar1Change(Sender: TObject);
begin
  fPDFViewer.ZoomPercentage := ScrollBar1.Position;
  UpdateGUI;
end;

procedure TframePDF.UpdateGUI;
begin
  ScrollBar1.Position := fPDFViewer.ZoomPercentage;
  btnScale.Caption := 'Scale ' + GetEnumName(TypeInfo(TPdfControlScaleMode),
    Ord(fPDFViewer.ScaleMode));
  btnPrev.Enabled := fPDFViewer.PageIndex > 0;
  btnNext.Enabled := fPDFViewer.PageIndex < (fPDFViewer.PageCount - 1);
  btnLast.Enabled := (fPDFViewer.PageCount > 0) and
    (fPDFViewer.PageIndex <> (fPDFViewer.PageCount - 1));
  btnFirst.Enabled := fPDFViewer.PageIndex <> 0;
  StatusBar1.Panels[0].Text := Format('Page %d of %d',
    [fPDFViewer.PageIndex + 1, fPDFViewer.PageCount]);

end;

end.
