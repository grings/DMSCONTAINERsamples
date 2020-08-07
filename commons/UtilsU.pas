unit UtilsU;

interface

type
  TAddressType = (MsgToList = 0, MsgCCList, MSgBCCList, MsgReplyToList);

function GetEmailAddesses: Boolean;
function EmailAddress(const Index: TAddressType): string;
function GetEmailAddessList(var Addresses: TArray<string>): Boolean;

implementation

uses
  Vcl.Dialogs, System.SysUtils;

var
  gLastEmailAddesses: TArray<string> = ['', '', '', ''];

function EmailAddress(const Index: TAddressType): string;
begin
  Result := gLastEmailAddesses[Ord(index)];
end;

function GetEmailAddesses: Boolean;
begin
  Result := InputQuery('Recipient Email (use ; for multiple addresses)',
    ['To:', 'CC:', 'BCC:', 'ReplyTo:'],
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
  I: Integer;
begin
  SetLength(lList, Length(Addresses));
  for I := 0 to Length(lList) - 1 do
  begin
    lList[I] := 'Recipient #' + I.ToString;
  end;

  Result := InputQuery('Recipient List', lList,
    gLastEmailAddesses,
    function(const Values: array of string): Boolean
    var
      I: Integer;
    begin
      for I := 0 to Length(lList) - 1 do
      begin
        lList[I] := Values[I];
      end;
      Result := True;
    end);

  if Result then
  begin
    Addresses := lList;
  end;
end;

end.
