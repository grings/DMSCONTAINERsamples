unit UnZipUtilsU;

interface

const
  SHCONTCH_NOPROGRESSBOX = 4;
  SHCONTCH_AUTORENAME = 8;
  SHCONTCH_RESPONDYESTOALL = 16;
  SHCONTF_INCLUDEHIDDEN = 128;
  SHCONTF_FOLDERS = 32;
  SHCONTF_NONFOLDERS = 64;

function ShellUnzip(zipfile, targetfolder: string; flags: Integer = SHCONTCH_RESPONDYESTOALL;
  filter: string = ''): boolean;

implementation

uses
  Comobj,
  Windows,
  Tlhelp32;

function ShellUnzip(zipfile, targetfolder: string; flags: Integer = SHCONTCH_RESPONDYESTOALL;
  filter: string = ''): boolean;
var
  shellobj: variant;
  srcfldr, destfldr: variant;
  shellfldritems: variant;
  ZipFileV, TargetFldrV: variant;
begin
  Result := False;
  shellobj := CreateOleObject('Shell.Application');

  ZipFileV := zipfile;
  srcfldr := shellobj.NameSpace(ZipFileV);

  TargetFldrV := targetfolder;
  destfldr := shellobj.NameSpace(TargetFldrV);

  shellfldritems := srcfldr.Items;
  if (filter <> '') then
    shellfldritems.filter(SHCONTF_INCLUDEHIDDEN or SHCONTF_NONFOLDERS or SHCONTF_FOLDERS, filter);

  destfldr.CopyHere(shellfldritems, flags { SHCONTCH_NOPROGRESSBOX or SHCONTCH_RESPONDYESTOALL } );
end;

end.
