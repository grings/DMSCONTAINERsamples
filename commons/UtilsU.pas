unit UtilsU;

interface

uses
  System.UITypes, Winapi.Windows;

type
  TAddressType = (MsgToList = 0, MsgCCList, MSgBCCList, MsgReplyToList);

function GetEmailAddesses: Boolean;
function EmailAddress(const Index: TAddressType): string;
function GetEmailAddessList(var Addresses: TArray<string>): Boolean;
function InvertColor(const Color: TColor): TColor;
function GetContrastingColor(Color: TColor): TColor;
function ShellOpenFile(hWnd: hWnd; AFileName, AParams, ADefaultDir: string): integer;

implementation

uses
  Vcl.Dialogs, System.SysUtils, Vcl.Graphics, Winapi.ShellApi;

var
  gLastEmailAddesses: TArray<string> = ['', '', '', ''];

function InvertColor(const Color: TColor): TColor;
begin
  Result := TColor(RGB(255 - GetRValue(Color), 255 - GetGValue(Color), 255 - GetBValue(Color)));
end;

function GetContrastingColor(Color: TColor): TColor;
var
  r, g, b: double;
  i: integer;
begin
  Color := ColorToRGB(Color);
  r := GetRValue(Color);
  g := GetGValue(Color);
  b := GetBValue(Color);
  i := round(Sqrt(r * r * 0.241 + g * g * 0.691 + b * b * 0.068));
  if (i > 128) then // treshold seems good in wide range
    Result := clBlack
  else
    Result := clWhite;
end;

function EmailAddress(const Index: TAddressType): string;
begin
  Result := gLastEmailAddesses[Ord(index)];
end;

function GetEmailAddesses: Boolean;
begin
  Result := InputQuery('Recipient Email (use ; for multiple addresses)', ['To:', 'CC:', 'BCC:', 'ReplyTo:'],
    gLastEmailAddesses,
    function(const Values: array of string): Boolean
    begin
      gLastEmailAddesses[0] := Values[0];
      gLastEmailAddesses[1] := Values[1];
      gLastEmailAddesses[2] := Values[2];
      gLastEmailAddesses[3] := Values[3];
      Result := True;
    end);
end;

function GetEmailAddessList(var Addresses: TArray<string>): Boolean;
var
  lList: TArray<string>;
  i: integer;
begin
  SetLength(lList, Length(Addresses));
  for i := 0 to Length(lList) - 1 do
  begin
    lList[i] := 'Recipient #' + i.ToString;
  end;

  Result := InputQuery('Recipient List', lList, gLastEmailAddesses,
    function(const Values: array of string): Boolean
    var
      i: integer;
    begin
      for i := 0 to Length(lList) - 1 do
      begin
        lList[i] := Values[i];
      end;
      Result := True;
    end);

  if Result then
  begin
    Addresses := lList;
  end;
end;

function ShellOpenFile(hWnd: hWnd; AFileName, AParams, ADefaultDir: string): integer;
begin
  Result := ShellExecute(hWnd, 'open', pChar(AFileName), pChar(AParams), pChar(ADefaultDir), SW_SHOWDEFAULT);
  case Result of
    0:
      raise Exception.Create('The operating system is out of memory or resources.');
    ERROR_FILE_NOT_FOUND:
      raise Exception.Create('The specified file was not found.');
    ERROR_PATH_NOT_FOUND:
      raise Exception.Create('The specified path was not found.');
    ERROR_BAD_FORMAT:
      raise Exception.Create('The .EXE file is invalid (non-Win32 .EXE or error ' + 'in .EXE image).');
    SE_ERR_ACCESSDENIED:
      raise Exception.Create('The operating system denied access to the specified file.');
    SE_ERR_ASSOCINCOMPLETE:
      raise Exception.Create('The filename association is incomplete or invalid.');
    SE_ERR_DDEBUSY:
      raise Exception.Create('The DDE transaction could not be completed because ' +
        'other DDE transactions were being processed.');
    SE_ERR_DDEFAIL:
      raise Exception.Create('The DDE transaction failed.');
    SE_ERR_DDETIMEOUT:
      raise Exception.Create('The DDE transaction could not be completed because the ' + 'request timed out.');
    SE_ERR_DLLNOTFOUND:
      raise Exception.Create('The specified dynamic-link library was not found.');
    // SE_ERR_FNF: {the same as ERROR_PATH_NOT_FOUND}
    SE_ERR_NOASSOC:
      raise Exception.Create('There is no application associated with the given ' + 'filename extension.');
    SE_ERR_OOM:
      raise Exception.Create('There was not enough memory to complete the operation.');
    // SE_ERR_PNF: {the same as ERROR_PATH_NOT_FOUND}
    SE_ERR_SHARE:
      raise Exception.Create('A sharing violation occurred.');
  end;
end;

end.
