{A demo program for reading Pascal TDialog resources.  This program
 registers all the objects which are standard in Dialog Design.  If
 you use other controls, be sure to register them (see TMyApp.Init).
 If you get "Stream Error, Status = -5", you forgot to register something.

 Attempting to read C++ resources or non TDialog resources will probably
 result in a crash.
}

{$X+}
program ReadRsrc;

uses Dos, Memory, Objects, Drivers, Views, Menus, Dialogs, App,
     MsgBox, StdDlg, DlgSubs, Editors, InpLong, ColorTxt, Validate, ComboBox;

Const
  cmTry = 150;

type
  TListboxRec = record
    PS : PStringCollection;
    Focused : Integer;
    end;

  TMyApp = object(TApplication)
    Filename : PathStr;
    ListBox : TListBoxRec;

    constructor Init;
    FUNCTION GetFileName : Word;
    FUNCTION MakeDialog : PDialog;
    PROCEDURE OutOfMemory; virtual;
    procedure InitStatusLine; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
    end;

var
  MyApp: TMyApp;

procedure DefaultExtension(Ext : ExtStr; var Filename : OpenString);
var
  D : DirStr;
  N : NameStr;
  E : ExtStr;
begin
FSplit(FileName, D, N, E);
if E = '' then E := Ext;
FileName := D+N+E;
end;

constructor TMyApp.Init;
var
  R : Trect;
begin
TApplication.Init;

RegisterDialogs;
RegisterType(RFrame);
RegisterType(RScrollbar);
RegisterType(RInputLong);
RegisterType(RColoredText);
RegisterEditors;
RegisterValidate;
RegisterType(RCombo);
RegisterType(RNoCaseStringCollection);
end;

procedure TMyApp.InitStatusLine;
var R: TRect;
begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine := New(PStatusLine, Init(R,
    NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt-X~ Exit', kbAltX, cmQuit,
      NewStatusKey('~F9~ Load resource file', kbF9, cmTry,
      nil)),
    nil)
  ));
end;

PROCEDURE TMyApp.OutOfMemory;
begin
Messagebox('Insufficient memory for this operation', Nil, mfOKbutton);
end;

FUNCTION TMyApp.GetFileName : Word;
var
  Command : Word;
  Exists : Boolean;
begin
FileName := '*.REZ';
repeat
  Command := ExecuteDialog(New(PFileDialog,
        Init('*.REZ', 'Select resource file', '~N~ame', fdOKbutton, 100)),
        @FileName);
  GetFileName := Command;
  if Command <> cmCancel then
      DefaultExtension('.REZ', FileName)
  else Exit;
  Exists := FileExists(Filename);
  if not Exists then
    Messagebox('Can''t find '+Filename, Nil, mfOKbutton);
until Exists;
end;

function TMyApp.MakeDialog : PDialog;
var
  Dlg : PDialog;
  R : TRect;
  Control : PView;

begin
R.Assign(16, 3, 61, 19);
New(Dlg, Init(R, 'Resource Selection'));

R.Assign(27, 3, 28, 14);
Control := New(PScrollBar, Init(R));
Dlg^.Insert(Control);

R.Assign(5, 3, 27, 14);
Control := New(PListBox, Init(R, 1, PScrollbar(Control)));
Dlg^.Insert(Control);

  R.Assign(4, 2, 14, 3);
  Dlg^.Insert(New(PLabel, Init(R, '~R~esources', Control)));

R.Assign(31, 3, 42, 5);
Control := New(PButton, Init(R, '~D~isplay', cmOK, bfDefault));
Dlg^.Insert(Control);

R.Assign(31, 6, 42, 8);
Control := New(PButton, Init(R, 'Cancel', cmCancel, bfNormal));
Dlg^.Insert(Control);

Dlg^.SelectNext(False);
MakeDialog := Dlg;
end;

procedure StreamError(Status, ErrorInfo : Integer);
var
  Params : array[0..2] of LongInt;
  S : string[10];
begin
Params[0] := Status;
Params[1] := ErrorInfo;
S := Hex4(ErrorInfo);
Params[2] := LongInt(@S);
Messagebox('Stream Error'^M^J'Status = %d'^M^J'ErrorInfo = %d ($%s)', @Params,
                 mfOKButton or mfError);
end;

procedure TMyApp.HandleEvent(var Event: TEvent);
var
  Command : Word;
  I : Integer;
  Strm : PBufStream;
  Rsrc : PResourceFile;
  PS : PString;
  Obj : PObject;
begin
TApplication.HandleEvent(Event);

if (Event.What = evCommand) and (Event.Command = cmTry) then
  begin
  if GetFileName <> cmCancel then
    begin
    New(Strm, Init(Filename, stOpen, 512));
    New(Rsrc, Init(Strm));
    if Rsrc^.Count = 0 then
      Messagebox(Filename+' is not a Resource file', Nil, mfOKbutton)
    else
      begin
      New(Listbox.PS, Init(5,10));
      for I := 0 to Rsrc^.Count-1 do
        Listbox.PS^.Insert(NewStr(Rsrc^.Keyat(I)));
      Listbox.Focused := 0;
      repeat
        Command := ExecuteDialog(MakeDialog, @ListBox);
        if Command = cmOK then
          begin
          PS := PString(Listbox.PS^.At(Listbox.Focused));
          Obj := Rsrc^.Get(PS^);   {get the resource}
          with Rsrc^.Stream^ do
            if Status <> stOK then
              StreamError(Status, ErrorInfo)
          else if Typeof(Obj^) <> Typeof(TDialog) then
            begin
            Messagebox(PS^+' is not a TDialog', Nil, mfOKbutton);
            Dispose(Obj, Done);
            end
          else
            ExecuteDialog(PDialog(Obj), Nil); {execute the dialog resource}
          end;
        until Command <> cmOK;
      Dispose(Listbox.PS, Done);
      end;
    Dispose(Rsrc, Done);
    end;
  ClearEvent(Event);
  end;
end;

begin
  MyApp.Init;
  MyApp.Run;
  MyApp.Done;
end.

