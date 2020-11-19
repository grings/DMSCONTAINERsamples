program EventStreamsWorker;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils,
  System.IOUtils,
  MVCFramework.Console,
  WorkerU in 'WorkerU.pas',
  EventStreamsRPCProxy in '..\commons\EventStreamsRPCProxy.pas';

procedure Logo;
begin
  TextColor(DarkGreen);
  WriteLn('');
  WriteLn('  ______                   _     _____  _                                     ');
  WriteLn(' |  ____|                 | |   / ____|| |                                    ');
  WriteLn(' | |__ __   __ ___  _ __  | |_ | (___  | |_  _ __  ___   __ _  _ __ ___   ___ ');
  WriteLn(' |  __|\ \ / // _ \| ''_ \ | __| \___ \ | __|| ''__|/ _ \ / _` || ''_ ` _ \ / ');
  TextColor(Green);
  WriteLn(' | |____\ V /|  __/| | | || |_  ____) || |_ | |  |  __/| (_| || | | | | |\__ \');
  WriteLn(' |______|\_/  \___||_| |_| \__||_____/  \__||_|   \___| \__,_||_| |_| |_||___/');
  WriteLn('                                                                              ');
  WriteLn('                                                                              ');
end;

var
  lWorker: TWorker;

begin
  Logo;
  try
    if ParamCount <> 3 then
    begin
      WriteLn('USAGE: ' + TPath.GetFileName(ParamStr(0)) + ' <username> <password> <queuename>');
      if DebugHook <> 0 then
        readln;
      Exit;
    end;
    lWorker := TWorker.Create(ParamStr(1), ParamStr(2), ParamStr(3));
    try
      TextColor(Red);
      WriteLn('Worker Started... (username: ', ParamStr(1), ')');
      TextColor(Green);
      lWorker.Execute;
    finally
      lWorker.Free;
    end;
  except
    on E: Exception do
    begin
      WriteLn(E.ClassName, ': ', E.Message);
      readln;
    end;
  end;

end.
