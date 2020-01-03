{Substitutions and fills in file, skel.dat
  Area Fills
  @ZZ0    Form the dialog in constructor
  @ZZ1    Defined Control Names in Object Def.
  @ZZ2    Data record def
  @ZZ3    Load GetSubViewPtr
  @ZZ4    Store PutSubViewPtr

  Substitutions
  @XX0    Dialog's Pointer  (as  PMyDialog)
  @XX1    Dialog's Symbol   (as  TMyDialog)
  @XX2    Dialog's ancestor (usually TDialog)
  @XX3    Dialog's registration TStreamRec (as RMyDialog)
  @XX4    Unit name
  @XX5    'Control1'
  @XX6    uses clause items

}
{$A-,B-,E+,F-,G-,I+,N-,O-,P-,Q-,R-,S-,T-,V-,X+}
{$M 16384,5000,655360}

Program PasSrc2;

uses Dos, Objects, Drivers, Views, Dialogs,
     Editors, Validate, ReadScpt;

const
  NeedControl1 : boolean = False;
  cbxNoTransfer = 4;
var
  OutF : Text;
  S : String;

PROCEDURE Subst(I : Integer);   {make a substitution for @XXn.  I is the
  location of @XXn in S }
var
  N : Byte;
  St : String;
  Name : NameStr;
  Ext : ExtStr;
begin
N := Ord(S[I+3]) - Ord('0');  {get the substitution number}
Delete(S, I, 4);              {delete the @XXn }
case N of
  0 : Insert(Dialog^.MainBlock.Obj^, S, I);  {like PMyDialog}
  1 : begin
      St := Dialog^.MainBlock.Obj^;
      if St[1] in ['P', 'p'] then Delete(St,1,1);
      Insert('T', St, 1);
      Insert(St, S, I);
      end;
  2 : Insert(Dialog^.MainBlock.BaseObj^, S, I);  {like TDialog}
  3 : begin
      St := Dialog^.MainBlock.Obj^;
      if St[1] in ['P', 'p'] then Delete(St,1,1);
      Insert('R', St, 1);
      Insert(St, S, I);
      end;
  4 : begin   {unit name same as filename}
      FSplit(ParamStr(2), St, Name, Ext);
      Insert(Name, S, I);
      end;
  5 : if NeedControl1 then Insert(', Control1', S, I);
  6 : begin
      St := '';
      if Present[CText] then St := ', ColorTxt';
      if Present[ILong] then St := St+', InpLong';
      if Present[Memo] then St := St+', Editors';
      if Present[ComboB] then St := St+', ComboBox';
      if ValidatorPresent then St := St+', Validate';
      if St <> '' then Insert(St, S, I);
      end;
  end;
end;

function Positn(Pat, Src : String; I : Integer) : Integer;
{find the position of a substring in a string starting at the Ith char}
var
  N : Integer;
begin
if I < 1 then I := 1;
Delete(Src, 1, I-1);
N := Pos(Pat, Src);
if N = 0 then Positn := 0
  else Positn := N+I-1;
end;

FUNCTION Quoted(S : string) : string;
{If first char is '@' then removes the '@' and otherwise does nothing--
   assumes string is a variable name.
 else
   Puts single quotes around a string and doubles any internal single quotes}
var
  I : Integer;
begin
I := Pos('@', S);
if I = 1 then
  begin
  Quoted := Copy(S, 2, 255);
  Exit;
  end;
I := Pos('''', S);
while I > 0 do
  begin
  Insert('''', S, I);
  I := Positn('''', S, I+2);
  end;
Insert('''', S, 1);
Quoted := S+'''';
end;

procedure RDotAssign(P : PScriptRec);
begin
with P^.MainBlock do
  begin
  WriteLn(Outf, 'R.Assign(', X1, ', ', Y1, ', ', X2,', ', Y2, ');');
  end;
end;

procedure DoOpEvent(P : PScriptRec; const Sym : string);
var
  S : string;
begin
with P^.MainBlock do
  begin
  if DefOptns <> Optns then
    begin
    Write(Outf, Sym, '^.Options := ');
    S := OptionStr(Optns, DefOptns, GetOptionWords);
    if S[1] = '$' then
      WriteLn(OutF, S)
    else WriteLn(OutF, Sym, '^.Options', S);
    end;
  if DefEvMsk <> EvMsk then
    begin
    Write(Outf, Sym, '^.EventMask := ');
    S := OptionStr(EvMsk, DefEvMsk, GetEventWords);
    if S[1] = '$' then
      WriteLn(OutF, S)
    else WriteLn(OutF, Sym, '^.EventMask', S);
    end;
  end;
end;

PROCEDURE WriteHelpCtx(Rf : PString; H : String; Ctx : word);
Const
  NoContext : String[11] = 'hcNoContext';
begin
if (H = '') and (Ctx > 0) then
   Str(Ctx, H);
if (H <> '') and not SameString(H, NoContext) then
  if Rf <> Nil then
    WriteLn(OutF, Rf^, '^.HelpCtx := ', H, ';' )
  else WriteLn(OutF, 'HelpCtx := ', H, ';' )
end;

procedure WriteButton(P : PScriptRec);
var
  S : string[55];

  function FlagStr : string;
  var
    S : string[55];
  begin
  with P^ do
    begin
    S := '';
    if Flags = 0 then S := 'bfNormal'
    else
      begin
      if Flags and 1 <> 0 then S := 'bfDefault+';
      if Flags and 2 <> 0 then S := S+'bfLeftJust+';
      if Flags and 4 <> 0 then S := S+'bfBroadcast+';
      if Flags and 8 <> 0 then S := S+'bfGrabFocus+';
      Dec(S[0]);  {remove extra '+'}
      end;
    end;
  FlagStr := S;
  end;

begin
with P^, MainBlock do
  begin
  RDotAssign(P);
  if SameString(Obj^, 'POptionButton') then  {a special TOptionButton}
    WriteLn(OutF, VarName^, ' := New(', Obj^, ', Init(R, ', Param[1]^,
         ', '+Param[2]^+'));' )
  else
    begin   {regular button}
    if CommandName^ <> '' then S := CommandName^
      else Str(CommandValue, S);
    Write(OutF, VarName^, ' := New(', Obj^, ', Init(R, ',
         Quoted(ButtonText^), ', '+S+', ' );
    WriteLn(OutF, FlagStr+'));' );
    end;
  WriteHelpCtx(VarName, HelpCtxSym^, HCtx);
  DoOpEvent(P, VarName^);
  WriteLn(OutF, 'Insert(', VarName^, ');');
  end;
end;

procedure WriteInputLong(P : PScriptRec);
begin
with P^, MainBlock do
  begin
  RDotAssign(P);
  WriteLn(OutF,
         VarName^, ' := New('+Obj^+', Init(R, ', LongStrLeng,
         ', ', LLim, ', ', ULim,  ', ', ILOptions, '));' );
  WriteHelpCtx(VarName, HelpCtxSym^, HCtx);
  DoOpEvent(P, VarName^);
  WriteLn(OutF, 'Insert(', VarName^, ');');
  end;
end;

procedure WriteInputLine(P : PScriptRec);
var
  S : string;

  function DoubleInsideQuotes(St : string) : string;
  var
    I : integer;
  begin
  I := Pos('''', St);
  while I > 0 do
    begin
    Insert('''', St, I);
    I := Positn('''', St, I+2);
    end;
  DoubleInsideQuotes := St;
  end;

begin
with P^, MainBlock do
  begin
  RDotAssign(P);
  WriteLn(OutF,
         VarName^, ' := New('+Obj^+', Init(R, ', StringLeng, '));' );
  WriteHelpCtx(VarName, HelpCtxSym^, HCtx);
  DoOpEvent(P, VarName^);
  WriteLn(OutF, 'Insert(', VarName^, ');');

  if ValKind in [Picture..User] then
    begin
    Write(OutF, '  ', Obj^+'('+VarName^+')^.Validator := New(', ValPtrName^,
        ', Init');
    case ValKind of
      Picture:
         begin
         if AutoFill <> 0 then S := 'True' else S := 'False';
         {Note: PictureString may start with '@'}
         WriteLn(OutF, '(''', DoubleInsideQuotes(PictureString^), ''', ', S, '));');
         end;
      Range:
         begin
         WriteLn(OutF, '(', LowLim, ', ', UpLim, '));');
         if Transfer <> 0 then
           WriteLn(OutF, '  ',
               Obj^+'('+VarName^+')^.Validator^.Options := voTransfer;');
         end;
      Filter:
         begin
         S := CharSet^;
         if (Length(S) > 1) and (S[1] = '@') then
           Delete(S, 1, 1);
         WriteLn(OutF, '(', S, '));');
         end;
      StringLookup:
         WriteLn(OutF, '(', List^, '));');
      User:
         WriteLn(OutF, ConstructorParams^, ');');
      end;
    end;
  end;
end;

procedure WriteMemo(P : PScriptRec);
begin
with P^, MainBlock do
  begin
  RDotAssign(P);
  Write(OutF,
         VarName^, ' := New('+Obj^+', Init(R, ');
  if HScroll^ <> '' then
    Write(OutF, 'PScrollbar(Control1), ')
  else Write(OutF, 'Nil, ' );
  if VScroll^ <> '' then
    Write(OutF, 'PScrollbar(Control), ')
  else Write(OutF, 'Nil, ' );
  WriteLn(OutF, 'Nil, ', BufSize, '));');
  WriteHelpCtx(VarName, HelpCtxSym^, HCtx);
  DoOpEvent(P, VarName^);
  WriteLn(OutF, 'Insert(', VarName^, ');');
  end;
end;

procedure WriteListBox(P : PScriptRec);
begin
with P^, MainBlock do
  begin
  RDotAssign(P);
  Write(OutF,
         VarName^, ' := New('+Obj^+', Init(R, ', Columns);
  if Scrollbar^ <> '' then
    WriteLn(OutF, ', PScrollbar('+ScrollBar^+')));')
  else WriteLn(OutF, ', Nil));' );
  WriteHelpCtx(VarName, HelpCtxSym^, HCtx);
  DoOpEvent(P, VarName^);
  WriteLn(OutF, 'Insert(', VarName^, ');');
  end;
end;

procedure WriteCombo(P : PScriptRec);
var
  I : integer;

  function FlagStr : string;
  var
    S : string[55];
  begin
  with P^ do
    begin
    S := '';
    if cbxFlags = 0 then S := '0'
    else
      begin
      if cbxFlags and 1 <> 0 then S := 'cbxOnlyList or ';
      if cbxFlags and 2 <> 0 then S := S+'cbxDisposesList or ';
      if cbxFlags and 4 <> 0 then S := S+'cbxNoTransfer or ';
      Dec(S[0], 4);  {remove extra ' or '}
      end;
    end;
  FlagStr := S;
  end;

begin
with P^, MainBlock do
  begin
  Write(OutF, '  ');
  RDotAssign(P);
  Write(OutF, '  ',
         VarName^, ' := New('+Obj^+', Init(R, PInputLine(', ComboLink^,
                     '), ', FlagStr, ', ');
  if (ComboItems > 0) and (cbxFlags and cbxNoTransfer <> 0) then
    begin
    for I := 0 to ComboItems-1 do
      Write(OutF, ^M^J'    NewSItem(', Quoted(PString(ComboColl^.At(I))^), ',');
    Write(OutF, ' Nil)');
    for I := 1 to ComboItems-1 do
      Write(OutF, ')');
    WriteLn(OutF, '));');
    end
  else WriteLn(OutF, 'Nil));');

  if (Length(Character^) > 0) and (Character^[1] <> #25) then
    WriteLn(OutF, '  PCombo(', VarName^, ')^.ActivateChar(''', Character^[1],
                  ''');');
  WriteLn(OutF, '  ', 'Insert(', VarName^, ');');
  end;
end;

procedure WriteScrollBar(P : PScriptRec);
begin
with P^, MainBlock do
  begin
  RDotAssign(P);
  WriteLn(OutF,
         VarName^, ' := New('+Obj^+', Init(R));');
  WriteHelpCtx(VarName, HelpCtxSym^, HCtx);
  DoOpEvent(P, VarName^);
  WriteLn(OutF, 'Insert(', VarName^, ');');
  end;
end;

procedure WriteCheckRadio(P : PScriptRec);
var
  I : integer;
begin
with P^, MainBlock do
  begin
  RDotAssign(P);
  Write(OutF,
         VarName^, ' := New('+Obj^+', Init(R, ');
  for I := 0 to Items-1 do
    Write(OutF, ^M^J'  NewSItem(', Quoted(PString(LabelColl^.At(I))^), ',');
  Write(OutF, ' Nil)');
  for I := 1 to Items -1 do
    Write(OutF, ')');
  if Kind = MultiCB then
    Write(OutF, ', ', SelRange, ', ', MCBFlags, ', ', Quoted(States^));
  WriteLn(OutF, '));');
  if Mask <> -1 then
    WriteLn(OutF, 'PCluster('+VarName^+')^.SetButtonState($', Hex8(not Mask), ', False);');
  WriteHelpCtx(VarName, HelpCtxSym^, HCtx);
  DoOpEvent(P, VarName^);
  WriteLn(OutF, 'Insert(', VarName^, ');');
  end;
end;

procedure WriteHistory(P : PScriptRec);
begin
with P^, MainBlock do
  begin
  Write(OutF, '  ');
  RDotAssign(P);
  WriteLn(OutF, '  Insert(New(PHistory, Init(R, PInputline(',
                    HistoryLink^, '), ', HistoryID, ')));');
  end;
end;

procedure WriteStaticText(P : PScriptRec);
  procedure DoAtText;
  var
    S : string;
    I : integer;
  begin
  S := P^.Text^;
  I := Pos(^C, S);
  while I > 0 do
    begin
    Delete(S, I, 1);  {remove ^C's}
    I := Pos(^C, S);
    end;
  Delete(S, 1, 1);   {remove '@'}
  I := Pos(^M, S);
  while I > 0 do
    begin
    Delete(S, I, 1);  {remove ^M's}
    I := Pos(^M, S);
    end;
  Write(OutF, S);
  end;

  procedure DoText;  {split Text into short lines if it is long}
                     {convert single quotes to double}
  var
    I, Count, TextLeng : Integer;
    Ch : char;
    S : string[20];
  begin
  Write(OutF, '''');
  Count := 38;
  with P^ do
    begin
    I := 1;
    TextLeng := Length(Text^);
    while I <= TextLeng do
      begin
      Ch := Text^[I];
      if Ch = ^M then
         begin
         if I >= TextLeng then
            S := ''    {on the end}
         else S := '''^M+'^M^J'     ''';
         Count := 0;
         end
      else if Ch = '''' then
         S := ''''''    {one quote to two}
      else S := Ch;
      Write(OutF, S);
      Inc(Count, Length(S));
      if (Count >= 75) and (I < TextLeng) then
        begin
        Write(OutF, '''+'^M^J'     ''');
        Count := 5;
        end;
      Inc(I);
      end;
    end;
  Write(OutF, '''');
  end;

begin
with P^, MainBlock do
  begin
  RDotAssign(P);
  Write(OutF, VarName^, ' := New('+Obj^+', Init(R, ');
  if (Length(Text^) > 1) and ((Text^[1] = '@')
         or (Text^[2] = '@')) then    {could be ^C'@'}
    DoAtText
  else
    DoText;
  if Kind = SText then
    WriteLn(OutF, '));')
  else
    WriteLn(OutF, ', $', Hex2(Byte(Attrib)), '));');
  DoOpEvent(P, VarName^);
  WriteLn(OutF, 'Insert(', VarName^, ');');
  end;
end;

procedure WriteLabel(P : PScriptRec);
begin
with P^, MainBlock do
  begin
  Write(OutF, '  ');
  RDotAssign(P);
  WriteLn(OutF, '  Insert(New('+Obj^+', Init(R, '+
          Quoted(LabelText^)+', ', LinkName^, ')));' );
  end;
end;

procedure FormDialog;

  procedure DoControls(P : PScriptRec); far;
  begin
  case P^.Kind of
    Button: WriteButton(P);
    InputL: WriteInputLine(P);
    Labl: WriteLabel(P);
    Histry: WriteHistory(P);
    ILong: WriteInputLong(P);
    CheckB, RadioB, MultiCB:
           WriteCheckRadio(P);
    ListB: WriteListBox(P);
    ScrollB: WriteScrollBar(P);
    Memo:  WriteMemo(P);
    CText, SText: WriteStaticText(P);
    ComboB: WriteCombo(P);
    end;
  WriteLn(OutF);
  end;

begin
with Dialog^, MainBlock do
  begin
  RDotAssign(Dialog);
  WriteLn(Outf, 'inherited Init(R, ', Quoted(Title^), ');');

  if DefOptns <> Optns then
    begin
    Write(Outf, 'Options := ');
    S := OptionStr(Optns, DefOptns, GetOptionWords);
    if S[1] = '$' then
      WriteLn(OutF, S)
    else WriteLn(OutF, 'Options', S);
    end;
  if DefEvMsk <> EvMsk then
    begin
    Write(Outf, 'EventMask := ');
    S := OptionStr(EvMsk, DefEvMsk, GetEventWords);
    if S[1] = '$' then
      WriteLn(OutF, S)
    else WriteLn(OutF, 'EventMask', S);
    end;

  WriteHelpCtx(Nil, HelpCtxSym^, HCtx);
  if Palette <> dpGrayDialog then
    begin
    if Palette = dpBlueDialog then S := 'dpBlueDialog'
      else S := 'dpCyanDialog';
    WriteLn(Outf, 'Palette := ', S, ';');
    end;

  if WinFlags <> 5 then
    WriteLn(Outf, 'Flags := Flags',
                  OptionStr(WinFlags, 5, GetWinFlagWords));
  WriteLn(OutF);

  ScriptColl^.ForEach(@DoControls);
  end;
end;

procedure DoTheVars;
var
  DidSomething : boolean;

  procedure DoVars(P : PScriptRec); far;
  var
    Control1 : boolean;
  begin
  with P^, MainBlock do
    begin
    Control1 := SameString(VarName^, 'Control1');
    NeedControl1 := NeedControl1 or Control1;  {see if Control1 var will be needed}
    if (VarName^ <> '') and not SameString(VarName^, 'Control')
        and not Control1 then
      begin
      WriteLn(OutF, '    ', VarName^, ' : ', Obj^, ';');
      DidSomething := True;
      end;
    end;
  end;
begin
DidSomething := False;
ScriptColl^.ForEach(@DoVars);
if DidSomething then WriteLn(OutF);  {extra line}
end;

procedure SubViewPtr(Load : boolean);

  procedure DoVars(P : PScriptRec); far;
  begin
  with P^, MainBlock do
    if (VarName^ <> '') and not SameString(VarName^, 'Control')
            and not SameString(VarName^, 'Control1') then
        begin
        if Load then Write(OutF, 'GetSubViewPtr(S, ')
        else Write(OutF, 'PutSubViewPtr(S, ');
        WriteLn(OutF, VarName^, ');');
        end;
  end;
begin
ScriptColl^.ForEach(@DoVars);
end;

procedure DoDataRecord;
var
  First : boolean;

  procedure DoFields(P : PScriptRec); far;
  var
    S : string[15];
  begin
  with P^, MainBlock do
    if FieldName^ <> '' then
      begin
      if First then  {at least one fieldname to output}
        begin
        WriteLn(OutF, '  ', Dialog^.MainBlock.FieldName^, ' = record');
        First := False;
        end;
      if (Kind = ComboB) then
        begin
        if (cbxFlags and cbxNoTransfer = 0) then
          WriteLn(OutF, '    ', FieldName^, ' : PStringCollection;');
        end
      else
        begin
        Write(OutF, '    ', FieldName^);
        case Kind of
          CheckB, RadioB :
             WriteLn(OutF, ' : Word;');
          MultiCB, ILong :
             WriteLn(OutF, ' : LongInt;');
          InputL :
            begin
            if (ValKind = Range) and (Transfer <> 0) then
               WriteLn(OutF, ' : LongInt;')
            else
              begin
              Str(StringLeng, S);
              WriteLn(OutF, ' : String['+S+'];');
              end;
            end;
          ListB :
            WriteLn(OutF, ' : TListBoxRec;');
          Memo :
            begin
            WriteLn(OutF, ' : Word;');
            Str(BufSize, S);
            WriteLn(OutF, '    ', TextFieldName^, ' : Array[1..'+S+'] of Char;');
            end;
          end;
        end;
      end;
  end;

begin
with Dialog^, MainBlock do
  if FieldName^ <> '' then
    begin
    if Present[ListB] then  {make sure TListBoxRec is defined}
      WriteLn(OutF,
      '  TListBoxRec = record    {<-- omit if TListBoxRec is defined elsewhere}'^M^J+
      '    List: PCollection;'^M^J+
      '    Selection: Word;'^M^J+
      '  end;'^M^J);

    First := True;
    ScriptColl^.ForEach(@DoFields);
    if not First then    {if First still set, there is no data record}
      begin
      WriteLn(OutF, '    end;');
      WriteLn(OutF, '  P'+FieldName^, ' = ^', FieldName^, ';');
      end;
    end;
end;

function FindSkelDat: string;
{look for 'skel.dat' in the directory where this file was found}
var
  EXEName, Dir : PathStr;
  Ext : ExtStr;
  Name : NameStr;
begin
if Lo(DosVersion) >= 3 then EXEName := ParamStr(0)
else EXEName := FSearch('PASSRC2.EXE', GetEnv('PATH'));
FSplit(EXEName, Dir, Name, Ext);
if Dir[Length(Dir)] = '\' then Dec(Dir[0]);
FindSkelDat := FSearch('SKEL.DAT', Dir);
end;

function HeapFunc(Size : word) : integer; far;
begin
if Size > 0 then
  begin
  WriteLn('Out of memory');
  Halt(1);
  end;
end;

var
  I : Integer;
  Inf : Text;

begin
HeapError := @HeapFunc;

if ParamCount < 2 then
  begin
  WriteLn('Usage:  passrc2 <script filename> <source filename> [error filename]');
  Halt(1);
  end;
if ParamCount >= 3 then
  begin
  Assign(OutPut, ParamStr(3));   {the error file}
  ReWrite(Output);
  end;
{$I-}
S := FindSkelDat;  {find the data file, skel.dat}
if S = '' then
  begin
  Write('Can''t find skel.dat');
  Halt(1);
  end;
Assign(Inf, S);
Reset(Inf);
ChkIOError(S);

ReadScriptFile( DefaultExt (ParamStr(1), '.SCP'));  {ParamStr(1) is script file}

Assign(OutF, DefaultExt (ParamStr(2), '.PAS'));    {ParamStr(2) is output source file}
Rewrite(OutF);
ChkIOError(DefaultExt (ParamStr(2), '.PAS'));
{$I+}

while not Eof(Inf) do
  begin
  ReadLn(Inf, S);
  if S = '@ZZ0' then FormDialog
  else if S = '@ZZ1' then DoTheVars
  else if S = '@ZZ2' then DoDataRecord
  else if S = '@ZZ3' then SubViewPtr(True)
  else if S = '@ZZ4' then SubViewPtr(False)
  else
    begin
    I := Pos('@XX', S);
    while I > 0 do
      begin
      Subst(I);
      I := Pos('@XX', S);
      end;
    WriteLn(OutF, S)
    end;
  end;
Close(InF);
Close(OutF);
end.

