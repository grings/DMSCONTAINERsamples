unit EmojiSupportU;

interface

uses
  Vcl.StdCtrls, Winapi.Windows, System.Classes;

type
  TEdit = class(Vcl.StdCtrls.TEdit)
  protected
    procedure PaintWindow(DC: HDC); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Vcl.Direct2D, Winapi.D2D1;

const
  D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT = 4;

constructor TEdit.Create(AOwner: TComponent);
begin
  inherited;
  DoubleBuffered := True;
end;

procedure TEdit.PaintWindow(DC: HDC);
var
  c: TDirect2DCanvas;
  r: D2D_RECT_F;
begin
  // Default drawing when focused. Otherwise do the custom draw.
  if Focused then
  begin
    inherited;
    Exit;
  end;

  c := TDirect2DCanvas.Create(DC, ClientRect);
  c.BeginDraw;
  try

    r.left := ClientRect.left;
    r.top := ClientRect.top;
    r.right := ClientRect.right;
    r.bottom := ClientRect.bottom;

    // Basic font properties
    c.Font.Assign(Font);
    // Brush determines the font color.
    c.Brush.Color := Font.Color;

    c.RenderTarget.DrawText(
      PWideChar(Text), Length(Text), c.Font.Handle, r, c.Brush.Handle,
      D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT);
  finally
    c.EndDraw;
    c.Free;
  end;
end;

end.
