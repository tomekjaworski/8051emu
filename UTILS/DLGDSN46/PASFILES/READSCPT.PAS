{$A-,B-,E+,F-,G-,I+,N-,O-,P-,Q-,R-,S-,T-,V-,X+}

Unit ReadScpt;

Interface

uses Dos, Objects;

const
  MaxParam = 6;   {number of extra parameters}
Type
  {various types of controls which may be found in script file. -1 indicates
   end}
  RecType = (Dlg, Button, SText, CText, InputL, Labl, Histry, ILong, CheckB,
             RadioB, MultiCB, ListB, Memo, ScrollB, ComboB);
  {various types of validators for TInputLine}
  ValType = (Picture, Range, Filter, StringLookup, User);

  BlockType = record   {all controls have this standard data block}
    BaseObj,            {like TInputLine}
    Obj : PString;      {like PInputLine or PMyInputLine}
    X1, Y1, X2, Y2,     {the TRect}
    DefOptns, Optns,    {default and actual options for control}
    DefEvMsk, EvMsk,    {default and actual eventmask for control}
    HCtx,               {HelpCtx value}
    Grow : integer;     {GrowMode value}
    Param : array[1..MaxParam] of PString;    {possible the extra parameters}
    HelpCtxSym,         {like hcNoContext}
    FieldName,          {field name you chose for data record}
    VarName : PString;  {variable name you chose or 'Control'}
    end;

  ScriptRec = record  {the variant record for the various controls}
    MainBlock : BlockType;  {the fixed part for all controls}
    case Kind: RecType of
      Dlg:  (Palette, WinFlags : word;    {the dialog itself}
             DlgFuncName,        {like MakeDialog}
             KeyString,          {ID string for resource}
             Title : PString;);  {dialog title}
      Button:
            (CommandName,           {like cmOK}
             ButtonText : PString;  {like O~k~}
             CommandValue,          {word value for Command}
             Flags : word;);        {flags}
      SText, CText:               {static and colored text}
            (Attrib : word;
             Text : PString;);
      InputL:
            (StringLeng : word;     {AMaxLen parameter}
             ValPtrName : PString;  {like PPXPictureString}
             case ValKind : ValType of    {ValKind = -1 if no validator}
               Picture:
                  (AutoFill : Byte;
                   PictureString : PString;);
               Range:
                  (LowLim, UpLim : LongInt;
                   Transfer : word;);    {non-zero if voTransfer bit set}
               StringLookUp:
                  (List : PString;);
               Filter:
                  (CharSet : PString;     {like "['a'..'z', '0'..'9']" }
                   {following represents the actual character set}
                   ActualCharSet : array[0..7] of LongInt;
                  );
               User :
                  (ConstructorParams : PString;);
             );
      ILong:
            (LongLabelText : PString; {text of the label--not used in Pascal}
             LongStrLeng : word;      {AMaxlen parameter}
             LLim, ULim : LongInt;
             ILOptions : word;);
      LabL: (LabelText,
             LinkName : PString;);    {variable name of control to which
                                       label is linked, often just 'Control'}
      Histry:
            (HistoryID : word;
             HistoryLink : PString;); {variable name of control to which
                                       label is linked, often just 'Control'}

      CheckB, RadioB, MultiCB:
            (Items : word;         {number of labels}
             Mask : LongInt;
             LabelColl : PStringCollection;  {collection of labels}
             MCBFlags : word;      {multi checkbox flags}
             SelRange : byte;      {multi checkbox SelRange}
             States : PString;);   {multi checkbox States}
      ListB:
            (Columns : word;
             ScrollBar : PString;);   {variable name of scrollbar}
      Memo: (TextFieldName : PString; {the second DataRec fieldname required by TMemo}
             BufSize : word;          {size of buffer}
             VScroll, HScroll : PString;);   {variable name of scrollbars}
      ComboB:
            (Character : PString;     {Character that shows}
             cbxFlags : word;         {the combobox's flags}
             ComboLink : PString;     {variable name of linked TInputLine}
             ComboItems : word;       {Number of list items}
             ComboColl : PStringCollection;);  {the list items}
    end;
  PScriptRec = ^ScriptRec;

  BitFunction = function(W : word): string;

var
  P, Dialog : PScriptRec;
  ScriptColl : PCollection;
  Present : array[Dlg..ComboB] of boolean; {which types are present}

const
  ValidatorPresent : boolean = False;

procedure ChkIOerror(S : string);
{main script reading procedure}
procedure ReadScriptFile(FName : string);
{given a byte, word, longint, return the string hex equivalent}
function Hex2(B : Byte) : String;
function Hex4(W : word) : string;
function Hex8(L : LongInt) : string;
{compare two strings without regard to case}
function SameString(const S1, S2 : String) : Boolean;

{if the  filename has no extension, add the default extension}
function DefaultExt(const FName, DefExt : string) : string;

{functions use by OptionStr}
function GetWinFlagWords(W : word): string;
function GetEventWords(W : word): string;
function GetOptionWords(W : word): string;

{given default and actual options (or eventmask), come up with a source
 code phrase something like 'or ofFramed and not ofSelectable'.   Func is
 a function appropriate to the type of bits being looked at.
 It's known that Actual and Default are not equal on entry}
function OptionStr(Actual, Default : word; Func : BitFunction): string;

Implementation

Const
  VersionID = 'SCRIPT1';
  Tab = #9;

type
  PairType = array[0..1] of Char;   {reads two characters at once}

var
  Spair : PairType;
  LCh : Char absolute SPair;  {same address as SPair so LCh = Spair[0]}
  Chi, LineNo : integer;
  St : String;
  Inf : Text;
  L : LongInt;

function GetWinFlagWords(W : word): string;
const
  FlagArray : array[0..3] of String[7] =
       ('wfMove', 'wfGrow', 'wfClose', 'wfZoom');
var
  S : string;
  I : integer;
begin
S := '';
for I := 0 to 3 do
  begin
  if (W and 1 = 1) then
    S := S+FlagArray[I] + ' or ';
  W := W shr 1;
  end;
if Length(S) > 4 then Dec(S[0], 4);  {remove last ' or '}
GetWinFlagWords := S;
end;

function GetEventWords(W : word): string;
const
  FlagArray : array[0..15] of String[11] =
       ('evMouseDown', 'evMouseUp', 'evMouseMove', 'evMouseAuto',
        'evKeyDown', '$20', '$40', '$80', 'evCommand', 'evBroadcast',
        '$400', '$800', '$1000', '$2000', '$4000', '$8000');
var
  S : string;
  I : integer;
begin
S := '';
for I := 0 to 15 do
  begin
  if (W and 1 = 1) and (FlagArray[I] <> '') then
    S := S+FlagArray[I] + ' or ';
  W := W shr 1;
  end;
if Length(S) > 4 then Dec(S[0], 4);  {remove last ' or '}
GetEventWords := S;
end;

function GetOptionWords(W : word): string;
const
  FlagArray : array[0..15] of String[13] =
       ('ofSelectable', 'ofTopSelect', 'ofFirstClick', 'ofFramed',
        'ofPreProcess', 'ofPostProcess', 'ofBuffered', 'ofTileable',
        'ofCenterX', 'ofCenterY', 'ofValidate', '$800', 'ofVersion20',
        '$2000', '$4000', 'ofShoehorn');
var
  S : string;
  I : integer;
begin
S := '';
for I := 0 to 15 do
  begin
  if (W and 1 = 1) and (FlagArray[I] <> '') then
    S := S+FlagArray[I] + ' or ';
  W := W shr 1;
  end;
if Length(S) > 4 then Dec(S[0], 4);  {remove last ' or '}
GetOptionWords := S;
end;

function BitCount(W : word): integer;  {number of set bits in W}
var
  I, Count : integer;
begin
Count := 0;
for I := 0 to 15 do
  begin
  if W and 1 = 1 then
    Inc(Count);
  W := W shr 1;
  end;
BitCount := Count;
end;

function OptionStr(Actual, Default : word; Func : BitFunction): string;
{given default and actual options (or eventmask), come up with a source
 code phrase something like 'or ofFramed and not ofSelectable'.   Func is
 a function appropriate to the type of bits being looked at.
 It's known that Actual and Default are not equal on entry}
var
  S : string;
  NOTs, ORs, Diff : word;
begin
Diff := Actual xor Default;  {the bits that are different}
if BitCount(Diff) > 4 then
  begin   {this is too complex--output hex number}
  OptionStr := '$'+Hex4(Actual)+';';
  Exit;
  end;
NOTs := Diff and Default;  {the bits not in default}
ORs := Diff and Actual;    {the extra bits in actual}
S := '';
if NOTs <> 0 then
  if BitCount(NOTs) = 1 then
    S := ' and not ' + Func(NOTs)
  else
    S := ' and not(' + Func(NOTs) + ')';
if ORs <> 0 then
  S := S + ' or ' + Func(ORs);
OptionStr := S + ';';
end;

function DefaultExt(const FName, DefExt : string) : string;
{if no extension, add DefExt (which must contain the '.')}
var
  Dir : PathStr;
  Name : NameStr;
  Ext : ExtStr;
begin
FSplit(FName, Dir, Name, Ext);
if Ext = '' then Ext := DefExt;
DefaultExt := Dir+Name+Ext;
end;

function SameString(const S1, S2 : String) : Boolean;
var
  I : Integer;
begin
SameString := False;
if S1[0] <> S2[0] then Exit;
for I := 1 to Length(S1) do
  if UpCase(S1[I]) <> UpCase(S2[I]) then Exit;
SameString := True;
end;

function Hex2(B : Byte) : String;
Const
  HexArray : array[0..15] of char = '0123456789ABCDEF';
begin
Hex2[0] := #2;
Hex2[1] := HexArray[B shr 4];
Hex2[2] := HexArray[B and $F];
end;

function Hex4(W : word) : string;
begin
Hex4 := Hex2(Hi(W)) + Hex2(Lo(W));
end;

function Hex8(L : LongInt) : string;
begin
Hex8 := Hex4(LongRec(L).Hi)+Hex4(LongRec(L).Lo);
end;

function MyNewStr(const S: String): PString;
{like NewStr but never returns a Nil pointer}
var
  P: PString;
begin
if S = '' then
  begin
  GetMem(P, 1);  {kind of silly, but saves a lot of testing here}
  P^[0] := #0;
  end
else P := NewStr(S);
MyNewStr := P;
end;

PROCEDURE Error(const S : String);  {handle file read errors}
Var
  X : Integer;
  NewS : String;
  Ch : char;

  function Spaces(N : integer) : String;
  var
    S : string;
    I : integer;
  begin
  S := '';
  for I := 1 to N do
    S := S+' ';
  Spaces := S;
  end;

begin
Dec(St[0]);   {remove the ^M added by GetCh}
WriteLn(St);
X := Chi-1;
if X < 1 then X := 1;
Str(LineNo, NewS);
NewS := 'Line ' + NewS + ' Error, ' + S;
if X > Length(NewS) then
  WriteLn(Spaces(X-Length(NewS)-1), NewS, '^')
else
  WriteLn(Spaces(X-1), '^', NewS);
Close(Inf);
Halt(1);
end;

{-------------ChkIOerror}
Procedure ChkIOerror(S : string);
Var
  IOerr : Integer;
  S1 : string[20];
begin
IOerr := IOResult;
if IOerr <> 0 then
  begin
  if IOerr = 2 then Write('Can''t find '+S)
  else
    begin
    Str(IOerr, S1);
    Write('I/O Error ', S1, ' in file ', S);
    end;
  Halt(1);
  end;
end;

{-------------GetCh}
PROCEDURE GetCh;
{Return next character in LCh, next two characters in SPair}
begin
if Chi > Length(St) then
  begin      {need to read a line}
  if not Eof(Inf) then
    begin
    ReadLn(Inf,St);
    Inc(LineNo);
    St:=St+^M;  {Add EOL}
    Chi := 1;
    end
  else
    Error('Unexpected end of file');
  end;
word(SPair) := MemW[DSeg : Ofs(St[Chi])];      {LCh same as SPair[0]}
Inc(Chi);
end;

{-------------SkipWhiteSpace}
procedure SkipWhiteSpace;
begin
while (LCh in [' ', Tab, ^M]) do
  GetCh;
end;

function GetString : PString;   {read a quoted string and return pointer to
 result.  Never returns Nil}
var
  S : string;
begin
S := '';
SkipWhiteSpace;
if LCh <> '"' then
  Error('Quoted string expected');
GetCh;
while (LCh <> '"') or (SPair = '"+') do  {+ is continuation char}
  begin
  if SPair = '\"' then  {SPair has same address as LCh}
    begin
    S := S+'"';
    GetCh;        {use up the extra character}
    end
  else if SPair = '\\' then
    begin
    S := S + '\';
    GetCh;
    end
  else if SPair = '\n' then
    begin
    S := S + ^M;
    GetCh;
    end
  else if SPair = '"+' then
    begin
    GetCh;  {skip '"'}
    GetCh;  {skip '+'}
    SkipWhiteSpace;
    if LCh <> '"' then
      Error('Quoted string continuation expected');
    end
  else S := S+LCh;  {Normal case}
  GetCh;
  end;
GetCh;    {use up last "}
GetString := MyNewStr(S);  {GetString is never Nil}
end;

function GetNumber : LongInt;  {read a decimal number from script file}
var
  S : string[20];
  Code : integer;
  V : LongInt;
begin
S := '';
SkipWhiteSpace;
if LCh = '-' then
  begin
  S := '-';
  GetCh;
  end;
if not (LCh in ['0'..'9']) then
  Error('Number expected');
while LCh in ['0'..'9'] do
  begin
  S := S + LCh;
  GetCh;
  end;
Val(S, V, code);
if code <> 0 then
  Error('Numerical error');
GetNumber := V;
end;

procedure ReadLabel(P : PScriptRec);  {read variant part of label record}
begin
with P^ do
  begin
  LabelText := GetString;
  LinkName := GetString;
  end;
end;

procedure ReadStaticText(P : PScriptRec);
begin
with P^ do
  begin
  Attrib := GetNumber;
  Text := GetString;
  end;
end;

procedure ReadHistory(P : PScriptRec);
begin
with P^ do
  begin
  HistoryID := GetNumber;
  HistoryLink := GetString;
  end;
end;

procedure ReadInputLine(P : PScriptRec);
var
  I : integer;
begin
with P^ do
  begin
  StringLeng := GetNumber;
  ValKind:= ValType(GetNumber);
  ValPtrName := GetString;
  ValidatorPresent := ValidatorPresent or (ord(ValKind) <> -1);
  case ValKind of     {ValKind = -1 if no validator}
    Picture:
      begin
      AutoFill := GetNumber;
      PictureString := GetString;
      end;
    Range:
      begin
      LowLim := GetNumber;
      UpLim := GetNumber;
      Transfer := GetNumber;
      end;
    StringLookUp:
      List := GetString;
    Filter:
      begin
      Charset := GetString;
      for I := 0 to 7 do
        ActualCharSet[I] := GetNumber;
      end;
    User:
      ConstructorParams := GetString;
    end;
  end;
end;

procedure ReadInputLong(P : PScriptRec);
begin
with P^ do
  begin
  LongLabelText := GetString;
  LongStrLeng := GetNumber;
  LLim := GetNumber;
  ULim := GetNumber;
  ILOptions := GetNumber;
  end;
end;

procedure ReadListBox(P : PScriptRec);
begin
with P^ do
  begin
  Columns := GetNumber;
  ScrollBar := GetString;
  end;
end;

procedure ReadButton(P : PScriptRec);
begin
with P^ do
  begin
  CommandName := GetString;
  ButtonText := GetString;
  CommandValue := GetNumber;
  Flags := GetNumber;
  end;
end;

procedure ReadMemo(P : PScriptRec);
begin
with P^ do
  begin
  TextFieldName := GetString;
  BufSize := GetNumber;
  VScroll := GetString;
  HScroll := GetString;
  end;
end;

procedure ReadComboBox(P : PScriptRec);
var
  I : integer;
begin
with P^ do
  begin
  Character := GetString;
  cbxFlags := GetNumber;
  ComboLink := GetString;
  ComboItems := GetNumber;
  if ComboItems > 0 then
    begin
    New(ComboColl, Init(10,10));    {a collection of list items}
    for I := 0 to ComboItems-1 do        {insert from 1st to last, don't sort}
      ComboColl^.AtInsert(I, GetString);
    end;
  end;
end;

procedure ReadCheckRadio(P : PScriptRec);
var
  I : integer;
begin
with P^ do
  begin
  Items := GetNumber;
  Mask := GetNumber;
  if Items > 0 then
    begin
    New(LabelColl, Init(10,10));    {a collection of labels}
    for I := 0 to Items-1 do        {insert from 1st to last, don't sort}
      LabelColl^.AtInsert(I, GetString);
    end;
  if Kind = MultiCB then
    begin
    MCBFlags := GetNumber;
    SelRange := GetNumber;
    States := GetString;
    end;
  end;
end;

procedure ReadDialog(P : PScriptRec); {read the variant part of dialog record}
begin
with P^ do
  begin
  Palette := GetNumber;
  WinFlags := GetNumber;
  DlgFuncName := GetString;
  KeyString := GetString;
  Title := GetString;
  end;
end;

procedure ReadMainBlock(P : PScriptRec; ThisKind : RecType);
{read the non-variant part of the control's record}
var
  I : integer;
begin
with P^, MainBlock do
  begin
  Kind := ThisKind;
  BaseObj := GetString;
  Obj := GetString;
  X1 := GetNumber;
  Y1 := GetNumber;
  X2 := GetNumber;
  Y2 := GetNumber;
  DefOptns := GetNumber;
  Optns := GetNumber;
  DefEvMsk := GetNumber;
  EvMsk := GetNumber;
  HCtx := GetNumber;
  Grow := GetNumber;
  for I := 1 to MaxParam do
    Param[I] := GetString;
  HelpCtxSym := GetString;
  FieldName := GetString;
  VarName := GetString;
  end;
end;

Procedure ReadScriptFile(FName : string);
var
  ThisKind : RecType;
begin
FillChar(Present, Sizeof(Present), 0);
New(ScriptColl, Init(10,10));

{$I-}
Assign(Inf, FName);
Reset(Inf);
ChkIOError(FName);
{$I+}

ReadLn(Inf, St);
if St <> VersionID then
  begin
  WriteLn('File is not a valid script file');
  Close(Inf);
  Halt(1);
  end;
LineNo := 1;
St := '';  Chi := 999;  {get the reading started}
GetCh;
GetString;         {reserved--of no use here}
L := GetNumber;    {Field number--of no use here}

ThisKind := RecType(GetNumber);
if ThisKind <> Dlg then
  Error('First item is not TDialog type');
New(Dialog);            {'Dialog' will hold the dialog info}
ReadMainBlock(Dialog, ThisKind);
Present[Dlg] := True;
ReadDialog(Dialog);
SkipWhiteSpace;

ThisKind := RecType(GetNumber);   {find out what kind of control this is}
while (Ord(ThisKind) > 0) do  {-1 terminates}
  begin
  if not (ThisKind in [Button..ComboB]) then
     Error('Unrecognized control type');
  Present[ThisKind] := True;
  New(P);
  ReadMainBlock(P, ThisKind);
  with P^ do
    begin
    case ThisKind of   {read the variant part of the control's record}
      Button : ReadButton(P);
      InputL : ReadInputLine(P);
      LabL : ReadLabel(P);
      Histry : ReadHistory(P);
      ILong : ReadInputLong(P);
      CheckB, RadioB, MultiCB :
              ReadCheckRadio(P);
      ListB: ReadListBox(P);
      ScrollB :;   {already completely read}
      Memo: ReadMemo(P);
      SText, CText : ReadStaticText(P);
      ComboB: ReadComboBox(P);
      end;
    ScriptColl^.Insert(P);  {insert in the collection of controls}
    SkipWhiteSpace;
    end;
  ThisKind := RecType(GetNumber);
  end;

Close(Inf);
end;

end.

