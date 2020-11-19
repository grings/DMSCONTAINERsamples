unit UtilsU;

interface

uses
  System.UITypes;

type
  TAddressType = (MsgToList = 0, MsgCCList, MSgBCCList, MsgReplyToList);

function GetEmailAddesses: Boolean;
function EmailAddress(const Index: TAddressType): string;
function GetEmailAddessList(var Addresses: TArray<string>): Boolean;
function InvertColor(const Color: TColor): TColor;
function GetContrastingColor(Color: TColor): TColor;

implementation

uses
  Vcl.Dialogs, System.SysUtils, Winapi.Windows, Vcl.Graphics;

var
  gLastEmailAddesses: TArray<string> = ['', '', '', ''];

function InvertColor(const Color: TColor): TColor;
begin
  result := TColor(RGB(255 - GetRValue(Color), 255 - GetGValue(Color),
    255 - GetBValue(Color)));
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
    result := clBlack
  else
    result := clWhite;
end;

function EmailAddress(const Index: TAddressType): string;
begin
  result := gLastEmailAddesses[Ord(index)];
end;

function GetEmailAddesses: Boolean;
begin
  result := InputQuery('Recipient Email (use ; for multiple addresses)',
    ['To:', 'CC:', 'BCC:', 'ReplyTo:'], gLastEmailAddesses,
    function(const Values: array of string): Boolean
    begin
      gLastEmailAddesses[0] := Values[0];
      gLastEmailAddesses[1] := Values[1];
      gLastEmailAddesses[2] := Values[2];
      gLastEmailAddesses[3] := Values[3];
      result := True;
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

  result := InputQuery('Recipient List', lList, gLastEmailAddesses,
    function(const Values: array of string): Boolean
    var
      i: integer;
    begin
      for i := 0 to Length(lList) - 1 do
      begin
        lList[i] := Values[i];
      end;
      result := True;
    end);

  if result then
  begin
    Addresses := lList;
  end;
end;

end.
