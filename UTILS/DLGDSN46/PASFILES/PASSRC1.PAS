{$A-,B-,E+,F-,G-,I+,N-,O-,P-,Q-,R-,S-,T-,V-,X+}
{$M 16384,5000,655360}

Program PasSrc1;

uses Dos, Objects, Dialogs, ReadScpt;

const
  NeedControl1 : boolean = False;
  cbxNoTransfer = 4;

var
  P : PScriptRec;
  Outf : Text;
  DlgName : string[50];  {holds dialog's variable name for easy reference}

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
  WriteLn(OutF, Rf^, '^.HelpCtx := ', H, ';' );
end;

procedure WriteButton(P : PScriptRec); {write code for TButton}
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
      if Flags and 1 <> 0 then S := 'bfDefault or ';
      if Flags and 2 <> 0 then S := S+'bfLeftJust or ';
      if Flags and 4 <> 0 then S := S+'bfBroadcast or ';
      if Flags and 8 <> 0 then S := S+'bfGrabFocus or ';
      Dec(S[0], 4);  {remove extra ' or '}
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
  WriteLn(OutF, DlgName, '^.Insert(', VarName^, ');');
  end;
end;

procedure WriteInputLong(P : PScriptRec);  {code for TInputLong}
begin
with P^, MainBlock do
  begin
  RDotAssign(P);
  WriteLn(OutF,
         VarName^, ' := New('+Obj^+', Init(R, ', LongStrLeng,
         ', ', LLim, ', ', ULim,  ', ', ILOptions, '));' );
  WriteHelpCtx(VarName, HelpCtxSym^, HCtx);
  DoOpEvent(P, VarName^);
  WriteLn(OutF, DlgName, '^.Insert(', VarName^, ');');
  end;
end;

procedure WriteInputLine(P : PScriptRec); {code for TInputLine}
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
  WriteLn(OutF, DlgName, '^.Insert(', VarName^, ');');

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
  WriteLn(OutF, DlgName, '^.Insert(', VarName^, ');');
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
  WriteLn(OutF, DlgName, '^.Insert(', VarName^, ');');
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
      if cbxFlags and 2 <> 0 then S := S+'cbxDisposesList or '; {!!!}
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
  WriteLn(OutF, '  ', DlgName, '^.Insert(', VarName^, ');');
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
  WriteLn(OutF, DlgName, '^.Insert(', VarName^, ');');
  end;
end;

procedure WriteCheckRadio(P : PScriptRec);
var
  I : integer;

  function MCBFlagString(Flags : word) : string;
  var
    S : string[30];
  begin
  if Flags = $101 then S := 'cfOneBit'
  else if Flags = $203 then S := 'cfTwoBits'
  else if Flags = $40F then S := 'cfFourBits'
  else if Flags = $8FF then S := 'cfEightBits'
  else S := '$'+Hex4(Flags);
  MCBFlagString := S;
  end;

begin
with P^, MainBlock do
  begin
  RDotAssign(P);
  Write(OutF,
         VarName^, ' := New('+Obj^+', Init(R, ');
  for I := 0 to Items-1 do
    Write(OutF, ^M^J'  NewSItem(', Quoted(PString(LabelColl^.At(I))^), ',');
  Write(OutF, ' Nil)');
  for I := 1 to Items-1 do
    Write(OutF, ')');
  if Kind = MultiCB then
    Write(OutF, ', ', SelRange, ', ', MCBFlagString(MCBFlags), ', ', Quoted(States^));
  WriteLn(OutF, '));');
  if Mask <> -1 then
    WriteLn(OutF, 'PCluster('+VarName^+')^.SetButtonState($', Hex8(not Mask), ', False);');
  WriteHelpCtx(VarName, HelpCtxSym^, HCtx);
  DoOpEvent(P, VarName^);
  WriteLn(OutF, DlgName, '^.Insert(', VarName^, ');');
  end;
end;

procedure WriteHistory(P : PScriptRec);
begin
with P^, MainBlock do
  begin
  Write(OutF, '  ');
  RDotAssign(P);
  WriteLn(OutF, '  ', DlgName, '^.Insert(New(PHistory, Init(R, PInputline(',
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
  WriteLn(OutF, DlgName, '^.Insert(', VarName^, ');');
  end;
end;

procedure WriteLabel(P : PScriptRec);
begin
with P^, MainBlock do
  begin
  Write(OutF, '  ');
  RDotAssign(P);
  WriteLn(OutF, '  ', DlgName, '^.Insert(New('+Obj^+', Init(R, '+
          Quoted(LabelText^)+', ', LinkName^, ')));' );
  end;
end;

procedure WriteSource;
var
  First : boolean;
  S : string[30];
  I : integer;

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
    ComboB: WriteCombo(P);  {!!}
    end;
  WriteLn(OutF);
  end;

  procedure DoVars(P : PScriptRec); far;
  begin
  with P^, MainBlock do
    if (VarName^ <> '') and not SameString(VarName^, 'Control')
        and not SameString(VarName^, 'Control1') then
      WriteLn(OutF, '  ', VarName^, ' : ', Obj^, ';');
  end;

  procedure DoFields(P : PScriptRec); far;
  var
    S : string[15];

    procedure ChkFirst;
    begin
    if First then  {at least one fieldname to output}
      begin
      WriteLn(OutF, 'var'^M^J'  ', Dialog^.MainBlock.FieldName^, ' : record');
      First := False;
      end;
    end;

  begin
  with P^, MainBlock do
    if FieldName^ <> '' then
      begin
      ChkFirst;
      if (Kind = ComboB) then    {!!}
        begin
        if (cbxFlags and cbxNoTransfer = 0) then {!!}
          WriteLn(OutF, '    ', FieldName^, ' : PStringCollection;');
        if SameString(VarName^, 'Control1') then NeedControl1 := True;
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
            NeedControl1 := NeedControl1 or (HScroll^ <> '');
            end;
          end;
        end;
      end
    else if SameString(Obj^, 'POptionButton') then
      begin            {it's a special, fieldname is in parameter 3}
      ChkFirst;
      WriteLn(OutF, '    ', Param[3]^, ' : OptionRec;');
      end;
  end;

begin
with Dialog^, MainBlock do
  begin
  DlgName := VarName^;

  if FieldName^ <> '' then   {No fieldname, no DataRec}
    begin
    if Present[ListB] then
      WriteLn(OutF, 'type'^M^J+
       '  TListBoxRec = record    {<-- omit if TListBoxRec is defined elsewhere}'^M^J+
       '    PS : PStringCollection;'^M^J+
       '    Selection : Integer;'^M^J+
       '    end;'^M^J);

    First := True;
    ScriptColl^.ForEach(@DoFields);
    if not First then   {if First still set, there is no data record}
      WriteLn(OutF, '  end;'^M^J);
    end;

  WriteLn(Outf, 'function ', DlgFuncName^, ' : ', Obj^, ';');
  Write(Outf, 'var'^M^J'  ', DlgName, ' : ', Obj^, ';'^M^J'  R : TRect;'^M^J'  '+
             'Control');
  if NeedControl1 then
    WriteLn(OutF, ', Control1 : PView;')
  else WriteLn(OutF, ' : PView;');

  ScriptColl^.ForEach(@DoVars);

  WriteLn(OutF, ^M^J'begin');
  RDotAssign(Dialog);
  WriteLn(Outf, 'New(', DlgName, ', Init(R, ', Quoted(Title^), '));');
  DoOpEvent(Dialog, DlgName);
  WriteHelpCtx(VarName, HelpCtxSym^, HCtx);
  if Palette <> dpGrayDialog then
    begin
    if Palette = dpBlueDialog then S := 'dpBlueDialog'
      else S := 'dpCyanDialog';
    WriteLn(Outf, VarName^, '^.Palette := ', S, ';');
    end;

  if WinFlags <> 5 then
    WriteLn(Outf, VarName^, '^.Flags := ', VarName^, '^.Flags',
                  OptionStr(WinFlags, 5, GetWinFlagWords));
  WriteLn(OutF);

  ScriptColl^.ForEach(@DoControls);   {all the controls in dialog}

  S := DlgFuncName^;
  I := Pos('.', S);  {remove 'TMyApp.' from 'TMyApp.MakeDialog'}
  if I > 0 then Delete(S, 1, I);
  WriteLn(Outf, DlgName, '^.SelectNext(False);'^M^J, S, ' := ',
                DlgName, ';'^M^J'end;');
  end;
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

if ParamCount < 2 then
  begin
  WriteLn('Usage:  passrc1 <script filename> <source filename> [error filename]');
  Halt(1);
  end;
if ParamCount >= 3 then
  begin   {redirect output to error file}
  Assign(OutPut, ParamStr(3));   {the error file}
  ReWrite(Output);
  end;
{$I-}

ReadScriptFile( DefaultExt (ParamStr(1), '.SCP'));  {ParamStr(1) is script file}

Assign(OutF, DefaultExt (ParamStr(2), '.SRC'));    {ParamStr(2) is output source file}
Rewrite(OutF);
ChkIOError(DefaultExt (ParamStr(2), '.SRC'));

WriteSource;
Close(Outf);
end.
