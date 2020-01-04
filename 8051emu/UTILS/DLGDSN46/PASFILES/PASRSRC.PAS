{$A-,B-,E+,F-,G-,I+,N-,O-,P-,Q-,R-,S-,T-,V-,X+}
{$M 16384,5000,655360}

Program ScriptToResource;

uses Dos, Memory, Objects, Drivers, Views, Dialogs,
     Editors, ColorTxt, InpLong, Validate, ReadScpt, ComboBox;

var
  Dlg : PDialog;     {holds the dialog as it's constructed and controls added}
  Control : PView;
  HScrollBar : PScrollBar;

procedure Error(const S : string);
begin
WriteLn(S);
Halt(1);
end;

procedure DoOptionsEtc(P : PView; S : PScriptRec);
begin
with S^, MainBlock, P^ do
  begin
  Options := Optns;
  EventMask := EvMsk;
  HelpCtx := HCtx;
  GrowMode := Grow;
  end;
end;

procedure DoButton(P : PScriptRec);
var
  R : TRect;
begin
with P^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  Control := New(PButton, Init(R, ButtonText^, CommandValue, Flags));
  if Control <> Nil then
    begin
    DoOptionsEtc(Control, P);
    Dlg^.Insert(Control);
    end
  else
    Error('Cannot construct TButton');
  end;
end;

procedure DoListBox(P : PScriptRec);
var
  R : TRect;
begin
with P^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  if ScrollBar^ <> '' then
    Control := New(PListBox, Init(R, Columns, PScrollBar(Control)))
  else Control := New(PListBox, Init(R, Columns, Nil));
  if Control <> Nil then
    begin
    DoOptionsEtc(Control, P);
    Dlg^.Insert(Control);
    end
  else
    Error('Cannot construct TListBox');
  end;
end;

procedure DoCheckRadio(P : PScriptRec);
var
  R : TRect;
  LastItem : PSItem;
  I : integer;

begin
with P^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  LastItem := Nil;
  for I := Items-1 downto 0 do  {this has to be done backwards}
    LastItem := NewSItem(PString(LabelColl^.At(I))^, LastItem);
  case Kind of
    CheckB:
      Control := New(PCheckBoxes, Init(R, LastItem));
    RadioB:
      Control := New(PRadioButtons, Init(R, LastItem));
    MultiCB:
      Control := New(PMultiCheckBoxes, Init(R, LastItem, SelRange,
                 MCBFlags, States^));
    end;
  if Control <> Nil then
    begin
    DoOptionsEtc(Control, P);
    PCluster(Control)^.SetButtonState(not Mask, False);
    Dlg^.Insert(Control);
    end
  else
  case Kind of
    CheckB:
      Error('Cannot construct TCheckBoxes');
    RadioB:
      Error('Cannot construct TRadioButtons');
    MultiCB:
      Error('Cannot construct TMultiCheckBoxes');
    end;
  end;
end;

procedure DoInputLong(P : PScriptRec);
var
  R : TRect;
begin
with P^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  Control := New(PInputLong, Init(R, LongStrLeng, LLim, ULim, ILOptions));
  if Control <> Nil then
    begin
    DoOptionsEtc(Control, P);
    Dlg^.Insert(Control);
    end
  else
    Error('Cannot construct TInputLong');
  end;
end;

procedure DoStaticText(P : PScriptRec);
var
  R : TRect;
begin
with P^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  case Kind of
    SText :
      Control := New(PStaticText, Init(R, Text^));
    CText :
      Control := New(PColoredText, Init(R, Text^, Attrib));
    end;
  if Control <> Nil then
    begin
    DoOptionsEtc(Control, P);
    Dlg^.Insert(Control);
    end
  else
    Error('Cannot construct '+BaseObj^);
  end;
end;

procedure DoMemo(P : PScriptRec);
var
  R : TRect;
  Vbar, Hbar : PScrollBar;
begin
with P^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  if VScroll^ <> '' then VBar := PScrollBar(Control)
    else VBar := Nil;
  if HScroll^ <> '' then HBar := HScrollBar
    else HBar := Nil;

  Control := New(PMemo, Init(R, Hbar, Vbar, Nil, BufSize));
  if Control <> Nil then
    begin
    DoOptionsEtc(Control, P);
    Dlg^.Insert(Control);
    end
  else
    Error('Cannot construct TMemo');
  end;
end;

procedure DoLabel(P : PScriptRec);
var
  R : TRect;
  Labl : PLabel;
begin
with P^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  Labl := New(PLabel, Init(R, LabelText^, Control));
  if Labl <> Nil then
    begin
    DoOptionsEtc(Labl, P);
    Dlg^.Insert(Labl);
    end
  else
    Error('Cannot construct TLabel');
  end;
end;

procedure DoScrollBar(P : PScriptRec);
var
  R : TRect;
  Tmp : PScrollBar;
begin
with P^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  Tmp := New(PScrollBar, Init(R));
  if Tmp <> Nil then
    begin
    DoOptionsEtc(Tmp, P);
    Dlg^.Insert(Tmp);
    if SameString(VarName^, 'Control1') then
      HScrollBar := Tmp     {probably a horizontal scrollbar for TMemo}
    else Control := Tmp;
    end
  else
    Error('Cannot construct TScrollBar');
  end;
end;

procedure DoHistory(P : PScriptRec);
var
  R : TRect;
  History : PHistory;
begin
with P^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  History := New(PHistory, Init(R, PInputLine(Control), HistoryID));
  if History <> Nil then
    begin
    DoOptionsEtc(History, P);
    Dlg^.Insert(History);
    end
  else
    Error('Cannot construct THistory');
  end;
end;

procedure DoComboBox(P : PScriptRec);
var
  R : TRect;
  Combo : PCombo;
  Coll : PNoCaseStringCollection;
  I : integer;
begin
with P^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  Combo := New(PCombo, Init(R, PInputLine(Control), cbxFlags, Nil));
  if Combo <> Nil then
    begin
    if (Length(Character^) > 0) and (Character^[1] <> #25) then
      Combo^.ActivateChar(Character^[1]);
    if (ComboItems > 0) and (cbxFlags and cbxNoTransfer <> 0) then
      begin
      New(Coll, Init(5, 5));
      for I := 0 to ComboItems-1 do
        Coll^.Insert(NewStr(PString(ComboColl^.At(I))^));
      Combo^.NewList(Coll);
      end;
    DoOptionsEtc(Combo, P);
    Dlg^.Insert(Combo);
    end
  else
    Error('Cannot construct THistory');
  end;
end;

procedure DoInputLine(P : PScriptRec);
var
  R : TRect;
  Val : PValidator;
begin
with P^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  Control := New(PInputLine, Init(R, StringLeng));
  if Control <> Nil then
    begin
    DoOptionsEtc(Control, P);
    Dlg^.Insert(Control);
   if ValKind in [Picture..User] then
      begin
      Val := Nil;
      case ValKind of
        Picture:
           Val := New(PPXPictureValidator, Init(PictureString^, AutoFill <> 0));
        Range:
           begin
           Val := New(PRangeValidator, Init(LowLim, UpLim));
           if (Val <> Nil) and (Transfer <> 0) then
             Val^.Options := voTransfer;
           end;
        Filter:
           Val := New(PFilterValidator, Init(TCharSet(ActualCharSet)));
        StringLookup:
           Val := New(PStringLookupValidator, Init(Nil));
        User : Error('Can''t construct user defined validator');
        end;
      if Val <> Nil then PInputLine(Control)^.Validator := Val
      else Error('Cannot construct Validator');
      end;
    end
  else
    Error('Cannot construct TInputLine');
  end;
end;

procedure DoDialog;
var
  R : TRect;
begin
with Dialog^, MainBlock do
  begin
  R.Assign(X1, Y1, X2, Y2);
  Dlg := New(PDialog, Init(R, Title^));
  if Dlg <> Nil then
    begin
    DoOptionsEtc(Dlg, Dialog);
    Dlg^.Palette := Dialog^.Palette;
    Dlg^.Flags := Dialog^.WinFlags;
    end
  else
    Error('Cannot construct Dialog');
  end;
end;

procedure MakeResource;
  procedure DoControls(P : PScriptRec); far;
  begin
  case P^.Kind of
    Button: DoButton(P);
    InputL: DoInputLine(P);
    Labl: DoLabel(P);
    Histry: DoHistory(P);
    ILong: DoInputLong(P);
    CheckB, RadioB, MultiCB:
           DoCheckRadio(P);
    ListB: DoListBox(P);
    ScrollB: DoScrollBar(P);
    Memo:  DoMemo(P);
    CText, SText: DoStaticText(P);
    ComboB : DoComboBox(P);
    end;
  end;

begin
DoDialog;
ScriptColl^.ForEach(@DoControls);
Dlg^.SelectNext(False);
end;

procedure WriteResource;
var
  Strm, StrmBKP : PBufStream;
  Rsrc : TResourceFile;
  FileNameBKP, S : PathStr;
  Name : NameStr;
  Ext : ExtStr;
  F : File;
  IOR, Value : Word;
  Check1 : Array[1..4] of char;
  Check2 : Array[1..2] of char absolute Check1;

begin
MakeResource;   {dialog is now in 'Dlg'}

S :=  DefaultExt( ParamStr(2), '.REZ');
if FSearch(S, '') <> '' then
  begin
  {$I-}
  Assign(F, S);
  Reset(F,1);
  if IOResult <> 0 then
      Error('Could not open '+S);
  BlockRead(F, Check1, Sizeof(Check1));
  {EXE files start with 'MZ'}
  if Check2 = 'MZ' then     {Check2 has same address as Check1}
    begin       {an EXE file}
    Seek(F, $18);
    BlockRead(F, Value, Sizeof(Value));
    Close(F);
{$ifdef DPMI}
    if Value < $40 then
      Error('Can''t write resource to old type EXE file');
{$else}
    if Value >= $40 then
      Error('Can''t write resource to new type EXE file (DPMI or Windows)');
{$endif}
    end
  else
    begin
    Close(F);
    if Check1 <> 'FBPR' then {REZ files start with 'FBPR'}
      Error('File exists but is not a resource or EXE file');
    end;

  {Back up the existing file}
  FSplit(S, FileNameBKP, Name, Ext);
  FileNameBKP := FileNameBKP + Name + '.BKP';
  Assign(F, FileNameBKP);
  Erase(F);         {Erase any backup file already existing}
  IOR := IOResult;  {reset any error}
  Assign(F, S);
  Rename(F, FileNameBKP);   {now the old file is a backup file}
  {$I+}
  New(StrmBKP, Init(FileNameBKP, stOpen, 512));
  New(Strm, Init(S, stCreate, 512));
  StrmBKP^.Seek(0);
  Strm^.CopyFrom(StrmBKP^, StrmBKP^.GetSize);   {copy the old file}
  Dispose(StrmBKP, Done);
  end
else
  New(Strm, Init(S, stCreate, 512)); {file doesn't exist, start a new one}
Strm^.Seek(0);
Rsrc.Init(Strm);
Rsrc.Put(Dlg, ParamStr(3));  {put resource in with proper ID string}
if Strm^.Status <> stOK then
   begin
   WriteLn('Stream Error, Status = ', Strm^.Status,
       ^M^J'ErrorInfo = ', Strm^.ErrorInfo, ' ($'+Hex4(Strm^.ErrorInfo)+')');
   Halt(1);
   end;

Rsrc.Done;   {disposes of Strm also}

Dispose(Dlg, Done);
end;

function HeapFunc(Size : word) : integer; far;
begin
if Size > 0 then
  begin
  WriteLn('Out of memory');
  Halt(1);
  end;
end;

begin
HeapError := @HeapFunc;

RegisterDialogs;
RegisterType(RFrame);
RegisterType(RScrollbar);
RegisterType(RInputLong);
RegisterType(RColoredText);
RegisterEditors;
RegisterValidate;
RegisterType(RCombo);
RegisterType(RNoCaseStringCollection);

if ParamCount < 3 then
  begin
  WriteLn('Usage:  pasrsrc <script filename> <RezFilename> <RezID> [error filename]');
  Halt(1);
  end;
if ParamCount >= 4 then
  begin   {redirect output to error file}
  Assign(OutPut, ParamStr(4));   {the error file}
  ReWrite(Output);
  end;
{$I-}

ReadScriptFile( DefaultExt (ParamStr(1), '.SCP'));  {ParamStr(1) is script file}

WriteReSource;
end.
