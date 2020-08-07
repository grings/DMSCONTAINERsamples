unit FontAwesomeU;

interface

{$R DelphiFontAwesomeResource.res DelphiFontAwesomeResource.rc}


uses
  Vcl.Forms,
  Vcl.DBGrids;

procedure InstallFont(const Form: TForm);

procedure SetColumnCaptionIcon(const aDBGrid: TDBGrid; const aColIndex: Integer;
  const FaIconName: Char);

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  Winapi.Messages,
  System.Classes;

procedure LoadFontFromRes(FontName: PWideChar);
var
  ResHandle: HRSRC;
  ResSize, NbFontAdded: Cardinal;
  ResAddr: HGLOBAL;
begin
  ResHandle := FindResource(HINSTANCE, FontName, RT_RCDATA);
  if ResHandle = 0 then
    RaiseLastOSError;
  ResAddr := LoadResource(HINSTANCE, ResHandle);
  if ResAddr = 0 then
    RaiseLastOSError;
  ResSize := SizeOfResource(HINSTANCE, ResHandle);
  if ResSize = 0 then
    RaiseLastOSError;
  if 0 = AddFontMemResourceEx(Pointer(ResAddr), ResSize, nil, @NbFontAdded) then
    RaiseLastOSError;
  // SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

procedure InstallFont(const Form: TForm);
begin
  if Screen.Fonts.IndexOf('FontAwesome') = -1 then
  begin
    LoadFontFromRes('fontawesome');
  end;
  Form.Font.Name := 'FontAwesome';
end;

procedure SetColumnCaptionIcon(const aDBGrid: TDBGrid; const aColIndex: Integer;
  const FaIconName: Char);
begin
  aDBGrid.TitleFont.Name := 'FontAwesome';
  if not aDBGrid.Columns.Items[aColIndex].Title.Caption.StartsWith(' ' + FaIconName) then
  begin
    aDBGrid.Columns.Items[aColIndex].Title.Caption := ' ' + FaIconName + ' ' + aDBGrid.Columns.Items[aColIndex]
      .Title.Caption;
  end;
end;

end.
