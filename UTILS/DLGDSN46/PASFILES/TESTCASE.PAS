{$X+}
program TestCase;

uses Dos, Memory, Objects, Drivers, Views, Menus, Dialogs, App, StdDlg,
     Editors, ColorTxt, InpLong, Validate, ComboBox;

Const
  cmTry = 150;
  cmButton = 151;

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
    end;

var
  MyApp: TMyApp;

procedure TMyApp.InitStatusLine;
var R: TRect;
begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine := New(PStatusLine, Init(R,
    NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt-X~ Exit', kbAltX, cmQuit,
      NewStatusKey('~F9~ Try dialog', kbF9, cmTry,
      nil)),
    nil)
  ));
end;

(*----Insert MakeDialog here----*)


procedure TMyApp.HandleEvent(var Event: TEvent);
begin
TApplication.HandleEvent(Event);

if (Event.What = evCommand) and (Event.Command = cmTry) then
  begin
  if Application^.ExecuteDialog(MakeDialog, @DataRec) = cmOk then
    begin
    {do something with data in DataRec}
    end;
  ClearEvent(Event);
  end;
end;

begin
  FillChar(DataRec, Sizeof(DataRec), 0);
  MyApp.Init;
  MyApp.Run;
  MyApp.Done;
end.

