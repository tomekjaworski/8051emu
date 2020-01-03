{$B-,X+,F+,O+}
Unit ComboBox;

(*---------------------------------------------------------------
                       TNoCaseStringCollection

TNoCaseStringCollection is a descendent of TStringCollection implementing
a list of Pascal strings sorted without regards to case.  It is used
by TCombo but is also useful wherever a caseless string collection is
required.

Only one method is overridden:

function Compare(Key1, Key2 : Pointer) : Integer; virtual;
    Provides the comparison change to implement caseless sorting.

When streaming TNoCaseStringCollection, be sure and register
RNoCaseStringCollection.


                           TCombo

TCombo is a control which may be attached to any TInputLine to
provide a drop down list of possible entries for the TInputLine.  In
action (and default appearance) it is similar to the THistory control
but differs in that the list of entries is supplied by the program rather
that from past entries to the TInputLine.

Incremental search is implemented in TCombo so that possible entries may be
selected by typing only the first 1 or 2 characters of the entry.  Selections
may also be made by double clicking with the mouse or by hiliting the entry
and pressing the Enter key.

TCombo may be attached to any TInputLine or descendent of TInputLine.  In
addition, the TInputLine may have a validator or even a THistory attached
(not sure that makes any sense).  Some variation in TCombo's appearance
can be achieved by changing its width and display character.  The activation
character (the keyboard character activating the drop down list) may also
be changed.

A Flags field allows variations in TCombo's action.

  cbxOnlyList
    If this bit is set, only items in the list are acceptable by the
    TInputLine.  In this mode, incremental search is implemented even when
    the drop down listbox is closed.  Or the space bar will allow toggling
    through the list.  (Shift space bar toggles in the reverse direction.)

    If this bit is not set, the TInputLine will accept any entry even if it
    is not in the list.

  cbxDisposesList
    If this bit is set, TCombo will dispose of the list in it's Done
    destructor effectively disposing of it when the dialog is closed.

  cbxNoTransfer
    If this bit is set, the transfer mechanism is disabled and DataSize
    returns 0.  This bit would probably be set if the list is fixed and
    defined at the time TCombo is constructed.

    If this bit is not set, the dialog transfer mechanism transfers a
    pointer to the desired list.  DataSize returns SizeOf(Pointer).


Fields:

    Flags : word;         {a combination of the cbxXXXX constants}
    ActivateCode : word;  {keycode to activate the drop down list,
                           default is kbDown}
    ShowChar : char;      {the character drawn. Default is #25, a thin arrow}
    ILink : PInputline;   {points to the TInputLine}
    ComboList : PSortedCollection;  {Points to the drop down list}

Methods:

constructor Init(var Bounds : TRect; ALink : PInputline; AFlags : word;
                              AStrings : PSItem);
    Bounds should have a height of 1 and a width of 1 or 3.  ALink points
    to the owning TInputLine, and AFlags is the desired combination of the
    cbxXXXX constants.

    The AStrings parameter allows you to define the list when the TCombo
    is constructed.  It consists of a series of calls to NewSItem in the
    same manner you would use to define the labels for TCheckBoxes or
    TRadioButtons.  (See the documentation for TCluster.Init.)  If you're
    planning on defining the list later either through the dialog transfer
    mechanism or by using NewList(), set AStrings to Nil.

    Init constructs a TCombo, setting ActivateCode to kbDown, ShowChar to
    #25, and ComboList to the list of strings defined by AStrings.

destructor Done; virtual;
    If cbxDisposesList is set, disposes of ComboList.  Calls the ancestor's
    Done destructor.

procedure ActivateChar(Ch : char); virtual;
    Allows changes to ShowChar, the character displayed.  If Ch is #25 or
    #31 (a down arrow) then ActivateCode is set to kbDown otherwise
    ActivatCode is set to Ch.

constructor Load(var S : TStream);
procedure Store(var S : TStream);
    The usual Load and Store routines.  Be sure to register both RCombo and
    RNoCaseStringCollection.

function DataSize: Word; virtual;
procedure GetData(var Rec); virtual;
procedure SetData(var Rec); virtual;
    The transfer methods.  If cbxNoTransfer is not set, DataSize returns
    Sizeof(Pointer) and Rec should be a pointer to a TNoCaseStringCollection.
    If cbxNoTransfer is set, then DataSize returns 0 and GetData, SetData
    do nothing.

procedure NewList(AList: PSortedCollection); virtual;
    Disposes of the current ComboList if it exists and assigns AList
    to ComboList.

procedure Update(Item : integer); virtual;
    Update is called whenever a selection is made in the combobox.
    TCombo.Update does nothing but you may need to override this method
    in cases where another field needs updating when a selection is made.

The following methods may require overriding for lists other than
TNoCaseStringCollection:

function InitListBox(var R : TRect; PSB : PScrollbar) : PListBox; virtual;
    Initializes a TStringListBox for TCombo.

function Equal(const S1, S2 : string; Count: Word): Boolean; virtual;
    Returns True if strings S1 and S2 match (without regards to case)
    for the first Count Characters.


Setting up a TCombo -- an example

var
  Dlg : PDialog;
  R : TRect;
  Combo : PCombo;
  MyInputLine : PInputLine;
   .......

R.Assign(6, 4, 27, 5);    {construct the TInputLine}
MyInputLine := New(PInputLine, Init(R, 19));
Dlg^.Insert(MyInputLine);

  R.Assign(27, 4, 28, 5);   {a 1 x 1 TCombo}
  Combo := New(PCombo, Init(R, PInputLine(MyInputLine),
                             cbxDisposesList or cbxNoTransfer,
    {Build a list to display}
    NewSItem('another item',
    NewSItem('Item 1',
    NewSItem('item 2', Nil)))));

  {change the displayed character from the default '' to a ''}
  PCombo(Combo)^.ActivateChar('');
  Dlg^.Insert(Combo);

-----------------------------------------------------------------*)

Interface
uses Objects, Drivers, Views, Dialogs, App, MinMax, StdDlg;

const
  cbxOnlyList = 1;       {Only items in list may be entered}
  cbxDisposesList = 2;   {TComboBox responsible for saving and disposing}
  cbxNoTransfer = 4;     {Disables transfer}

type
{TNoCaseStringCollection is a collection of strings ordered without regard
    to case }
  PNoCaseStringCollection = ^TNoCaseStringCollection;
  TNoCaseStringCollection = Object(TStringCollection)
    FUNCTION Compare(Key1, Key2 : Pointer) : Integer; virtual;
  end;

{TCombo is attached to an TInputline and allows a popup listbox from
 which choices can be made for the Inputline.}
  TCombo = Object(TView)
    Flags : word;
    ActivateCode : word;  {keycode to activate drop down list} {kbDown, }
    ShowChar : char;      {the character drawn}  {#25, #31, or '*'}
    ILink : PInputline;
    ComboList : PSortedCollection;

    constructor Init(var Bounds : TRect; ALink : PInputline; AFlags : word;
                         AStrings: PSItem);
    destructor Done; virtual;
    constructor Load(var S : TStream);
    procedure Store(var S : TStream);
    procedure ActivateChar(Ch : char); virtual;
    function DataSize: Word; virtual;
    procedure GetData(var Rec); virtual;
    function InitListBox(var R : TRect; PSB : PScrollbar) : PListBox; virtual;
    procedure NewList(AList: PSortedCollection); virtual;
    procedure SetData(var Rec); virtual;
    function MakeDialog(var PLB : PListBox): PDialog; virtual;
    function Equal(const S1, S2 : string; Count: Word): Boolean; virtual;
    procedure IncrementalSearch(var Event : TEvent); virtual;
    PROCEDURE HandleEvent(var Event : TEvent); virtual;
    procedure Update(Item : integer); virtual;
    procedure Draw; virtual;
    Function GetPalette : PPalette; virtual;
    procedure PutString(S : string); virtual;
    end;
  PCombo = ^TCombo;

{TListDialog is a popup window holder for a Listbox.  It is used by TCombo}
  TListDialog = Object(TDialog)
    Width : Integer;
    constructor Init(var Bounds : TRect);
    FUNCTION GetPalette : PPalette; virtual;
    PROCEDURE HandleEvent(var Event : TEvent); virtual;
    procedure SizeLimits(var Min, Max : TPoint); virtual;
    end;
  PListDialog = ^TListDialog;

{TStringListBox is a listbox holding a sorted collection of strings.
 Incremental search is implemented. }
  PStringListBox = ^TStringListBox;
  TStringListBox = object(TListBox)
    SearchPos: Word;
    MyCombo : PCombo;
    constructor Init(var Bounds: TRect; ANumCols: Word;
      AScrollBar: PScrollBar; ACombo : PCombo);
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure NewList(AList: PCollection); virtual;
  end;

const
  RCombo : TStreamRec = (
    ObjType: 712;
    VmtLink: Ofs(Typeof(TCombo)^);
    Load : @TCombo.Load;
    Store : @TCombo.Store);
  RNoCaseStringCollection : TStreamRec = (
    ObjType: 713;
    VmtLink: Ofs(Typeof(TNoCaseStringCollection)^);
    Load : @TNoCaseStringCollection.Load;
    Store : @TNoCaseStringCollection.Store);

Implementation

{----------------------TNoCaseStringCollection.Compare}
FUNCTION TNoCaseStringCollection.Compare(Key1, Key2 : Pointer) : Integer;
var
  I, Len1, Len2 : integer;
  Ch1, Ch2 : char;
begin
Len1 := Length(PString(Key1)^);
Len2 := Length(PString(Key2)^);
for I := 1 to IntMin(Len1, Len2) do
  begin
  Ch1 := UpCase(PString(Key1)^[I]);
  Ch2 := UpCase(PString(Key2)^[I]);
  if Ch1 < Ch2 then begin Compare := -1; Exit; end
  else if Ch1 > Ch2 then begin Compare := 1; Exit; end;
  end;

{if we get here, the strings match up to the length of the smaller}
if Len1 < Len2 then Compare := -1
else if Len1 > Len2 then Compare := 1
else Compare := 0;
end;

{---------------------------TStringListBox.Init}
constructor TStringListBox.Init(var Bounds: TRect; ANumCols: Word;
  AScrollBar: PScrollBar; ACombo : PCombo);
begin
  inherited Init(Bounds, ANumCols, AScrollBar);
  SearchPos := 0;
  MyCombo := ACombo;
  ShowCursor;
  SetCursor(1,0);
end;

{---------------------------TStringListBox.NewList}
procedure TStringListBox.NewList(AList: PCollection);
begin
  inherited NewList(AList);
  SearchPos := 0;
end;

{---------------------------TStringListBox.HandleEvent}
procedure TStringListBox.HandleEvent(var Event: TEvent);
var
  CurString, NewString: String;
  Value, OldPos, OldValue : Integer;

begin
if (Event.What = evMouseDown) and (Event.Double) then
  begin
  Event.What := evCommand;
  Event.Command := cmOK;
  PutEvent(Event);
  ClearEvent(Event);
  end
else
  begin
  OldValue := Focused;
  if Event.What = evKeyDown then
    case CtrlToArrow(Event.KeyCode) of
      kbUp, kbDown, kbPgDn, kbPgUp, kbHome, kbEnd, kbCtrlPgDn, kbCtrlPgUp:
        SearchPos := 0;
      kbEsc : Exit;
      end;
  if (Event.What <> evKeyDown) or (Event.CharCode <> ' ') then
    TListBox.HandleEvent(Event);
  if (OldValue <> Focused) then SearchPos := 0;
  if Assigned(List) and (Event.What = evKeyDown) then
    begin
    if (Event.CharCode <> #0) or (Event.KeyCode = kbLeft) then
      begin
      Value := Focused;
      if Value < Range then CurString := GetText(Value, 255)
      else CurString := '';
      OldPos := SearchPos;
      if (Event.KeyCode = kbBack) or (Event.KeyCode = kbLeft) then
        begin
        if SearchPos = 0 then Exit;
        Dec(SearchPos);
        CurString[0] := Char(SearchPos);
        end
      else
        begin
        Inc(SearchPos);
        CurString[0] := Char(SearchPos);
        CurString[SearchPos] := Event.CharCode;
        end;
      PSortedCollection(List)^.Search(@CurString, Value);
      if Value < Range then
        begin
        NewString := GetText(Value, 255);
        if MyCombo^.Equal(NewString, CurString, SearchPos) then
          begin
          if Value <> OldValue then
            begin
            FocusItem(Value);
            { Assumes ListControl will set the cursor to the first character }
            { of the sfFocused item }
            SetCursor(Cursor.X+SearchPos, Cursor.Y);
            end
          else SetCursor(Cursor.X+(SearchPos-OldPos), Cursor.Y);
          end
        else SearchPos := OldPos;
        end
      else SearchPos := OldPos;
      ClearEvent(Event);
      end;
    end;
  end;
end;

{---------------------------TListDialog.Init}
constructor TListDialog.Init(var Bounds : TRect);
begin
inherited Init(Bounds, '');
Width := Bounds.B.X - Bounds.A.X;
end;

{-----------------TListDialog.GetPalette}
FUNCTION TListDialog.GetPalette: PPalette;
begin
GetPalette := Nil;
end;

{-------------------TListDialog.HandleEvent}
PROCEDURE TListDialog.HandleEvent(var Event : TEvent);
begin
if (Event.What = evKeydown) and (Event.Charcode = #13) then
  begin
  EndModal(cmOK);
  ClearEvent(Event);
  end;
TDialog.HandleEvent(Event);
end;

{---------------------------TListDialog.SizeLimits}
procedure TListDialog.SizeLimits(var Min, Max : TPoint);
begin
inherited SizeLimits(Min, Max);
Min.X := IntMin(Min.X, Width);
Min.Y := 3;
end;

{-----------------TCombo.Init}
constructor TCombo.Init(var Bounds : TRect; ALink : PInputline; AFlags : word;
                            AStrings: PSItem);
var
  R : TRect;
  P: PSItem;
begin
TView.Init(Bounds);
Flags := AFlags;
ILink := ALink;

if Assigned(AStrings) then
  begin
  ComboList := New(PNoCaseStringCollection, Init(3,3));
  while Assigned(AStrings) do
    begin
    P := AStrings;
    ComboList^.Insert(AStrings^.Value);
    AStrings := AStrings^.Next;
    Dispose(P);
    end;
  end
else ComboList := Nil;

ShowChar := #25;      {a thin arrow}
ActivateCode := kbDown;  {a down arrow}
Options := Options or ofPreProcess;
EventMask := EventMask or evBroadcast;
end;

{-------------------TCombo.Done}
destructor TCombo.Done;
begin
if Assigned(ComboList) and (flags and cbxDisposesList <> 0) then
  Dispose(ComboList, Done);
inherited Done;
end;

{-------------------TCombo.Load}
constructor TCombo.Load(var S : TStream);
begin
inherited Load(S);
S.Read(Flags, Ofs(ILink) - Ofs(Flags));
GetPeerViewPtr(S, ILink);
ComboList := PSortedCollection(S.Get);
end;

{-------------------TCombo.Store}
procedure TCombo.Store(var S : TStream);
begin
inherited Store(S);
S.Write(Flags, Ofs(ILink) - Ofs(Flags));
PutPeerViewPtr(S, ILink);
S.Put(ComboList);
end;

{---------------------------TCombo.ActivateChar}
procedure TCombo.ActivateChar(Ch : char);
begin
ShowChar := Ch;
if Ch in [#25, #31] then ActivateCode := kbDown
else ActivateCode := word(Ch);
end;

{-------------------TCombo.DataSize}
function TCombo.DataSize: Word;
begin
if Flags and cbxNoTransfer <> 0 then
  DataSize := 0
else
  DataSize := SizeOf(ComboList);
end;

{-------------------TCombo.GetData}
procedure TCombo.GetData(var Rec);
begin
if Flags and cbxNoTransfer = 0  then
  PCollection(Rec) := ComboList;
end;

{-------------------TCombo.NewList}
procedure TCombo.NewList(AList: PSortedCollection);
begin
if Assigned(ComboList) then Dispose(ComboList, Done);
ComboList := AList;
if Assigned(AList) and (Flags and cbxOnlyList <> 0) then
  PutString(PString(AList^.At(0))^);
end;

{-------------------TCombo.SetData}
procedure TCombo.SetData(var Rec);
begin
if Flags and cbxNoTransfer = 0 then
  NewList(PSortedCollection(Rec));
end;

{-------------------TCombo.PutString}
procedure TCombo.PutString(S : string);
{puts the string to the TInputLine without overwriting any memory}
begin
with ILink^ do
  begin
  if Length(S) > MaxLen then
    S[0] := chr(MaxLen);
  Data^ := S;
  DrawView;
  end;
end;

{---------------------------TCombo.Equal}
function TCombo.Equal(const S1, S2: String; Count: Word): Boolean;
{caseless compare two strings for count characters}
var
  I: Word;
begin
  Equal := False;
  if (Length(S1) < Count) or (Length(S2) < Count) then Exit;
  for I := 1 to Count do
    if UpCase(S1[I]) <> UpCase(S2[I]) then Exit;
  Equal := True;
end;

{-------------------TCombo.IncrementalSearch}
procedure TCombo.IncrementalSearch(var Event : TEvent);
var
  CurString, NewString: String;
  Value, OldPos, OldValue, SearchPos : Integer;
begin
if Assigned(ComboList) then
  if (Event.CharCode <> #0) or (Event.KeyCode = kbLeft)
        or (Event.KeyCode = kbHome) then
    begin
    CurString := ILink^.Data^;
    SearchPos := ILink^.CurPos;
    OldPos := SearchPos;
    if (Event.KeyCode = kbBack) or (Event.KeyCode = kbLeft)
         or (Event.KeyCode = kbHome) then
      begin
      if SearchPos = 0 then Exit;
      if Event.Keycode = kbHome then SearchPos := 0
        else Dec(SearchPos);
      CurString[0] := Char(SearchPos);
      end
    else
      begin
      Inc(SearchPos);
      CurString[0] := Char(SearchPos);
      CurString[SearchPos] := Event.CharCode;
      end;
    if not ComboList^.Search(ILink^.Data, OldValue) then OldValue := -1;
    ComboList^.Search(@CurString, Value);
    if Value < ComboList^.Count then
      begin
      NewString :=  PString(ComboList^.At(Value))^;
      if Equal(NewString, CurString, SearchPos) then
        with ILink^ do
          begin
          if Value <> OldValue then
            begin
            PutString(NewString);
            SelectAll(True);
            SetCursor(Cursor.X+SearchPos, Cursor.Y);
            end
          else SetCursor(Cursor.X+(SearchPos-OldPos), Cursor.Y);
          end
      else SearchPos := OldPos;
      end
    else SearchPos := OldPos;
    ILink^.CurPos := SearchPos;
    end;
ClearEvent(Event);
end;

{-------------------TCombo.HandleEvent}
PROCEDURE TCombo.HandleEvent(var Event : TEvent);
var
  Value : integer;

  PROCEDURE PopUp;
  var
    Command : Word;
    Index : integer;
    Dlg : PView;
    PLB : PListBox;
  begin
  Dlg := Application^.ValidView(PListDialog(MakeDialog(PLB)));
  if Assigned (Dlg) then
    begin
    if Assigned(ComboList) then
      begin
      if not ComboList^.Search(ILink^.Data, Index) then
         Index := 0;
      end
    else Index := 0;
    PLB^.FocusItem(Index);
    Command := Owner^.ExecView(Dlg);
    if Assigned(ComboList) and (Command = cmOK) then
      begin
      Index := PLB^.Focused;
      ILink^.Data^ := PLB^.GetText(Index, ILink^.MaxLen);
      ILink^.SelectAll(False);    {nothing selected, drawview}
      Update(Index);
      end;
    Dispose(Dlg, Done);
    end;
  end;

begin
if (Owner^.Current = PView(ILink)) and (Event.What = evKeydown) then
  begin {PreProcess of chars going to our TInputLine}
  {the active key may be either a character key or a special key with
   charcode = 0}
  if ((Char(ActivateCode) <> #0) and (Event.CharCode = Char(ActivateCode)))
       or (Event.KeyCode = ActivateCode) then
    begin   {actvate by key}
    Popup;
    ClearEvent(Event);
    end
  else if (Flags and cbxOnlyList <> 0) then
    begin   {cbxOnlyList is set}
    Event.KeyCode := CtrlToArrow(Event.KeyCode);
    case Event.CharCode of
      ' ' :
         begin  {toggle to next or previous item in list}
         if Assigned(ComboList) then
           begin
           if not ComboList^.Search(ILink^.Data, Value) then Value := -1;
           if GetShiftState and (kbRightShift or kbLeftShift) <> 0 then
             Dec(Value) else Inc(Value);
           if Value < 0 then Value := ComboList^.Count-1
           else if Value >= ComboList^.Count then Value := 0;
           PutString(PString(ComboList^.At(Value))^);
           ILink^.SelectAll(False);
           end;
         ClearEvent(Event);
         end;
      ' '..#255 : IncrementalSearch(Event);
      else case Event.KeyCode of
           kbBack, kbLeft, kbHome : IncrementalSearch(Event);
           kbDel, kbEnd, kbIns, kbRight : ClearEvent(Event);
         end;
      end;
    end;
  end
else if (Event.What = evMouseDown) and (MouseInView(Event.Where)) then
    begin    {activate by mouse}
    ILink^.Select;
    Popup;
    ClearEvent(Event);
    end;
TView.HandleEvent(Event);
if (Flags and cbxOnlyList <> 0) then
  with ILink^ do    {make sure nothing is hilited}
    if SelEnd <> SelStart then
      begin
      SelEnd := SelStart;
      DrawView;
      end;
end;

{---------------------------TCombo.Update}
procedure TCombo.Update(Item : integer);
begin end;

{---------------------------TCombo.InitListBox}
function TCombo.InitListBox(var R : TRect; PSB : PScrollbar) : PListBox;
var
  Rslt : PStringListBox;
begin
Rslt := New(PStringListBox, Init(R, 1, PSB, @Self));
Rslt^.GrowMode := gfGrowHiX or gfGrowHiY;
Rslt^.NewList(ComboList);
InitListBox := Rslt;
end;

{-------------------TCombo.MakeDialog}
function TCombo.MakeDialog(var PLB : PListBox): PDialog;
var
  R, R1 : TRect;
  ScrollBar : PScrollBar;
  Dlg : PDialog;
  Ht : integer;
Begin
ILink^.GetBounds(R);  {get TInputLine's bounds}
Dec(R.A.X);           {figure bounds of popup dialog}
Inc(R.B.X, 2);
if Assigned(ComboList) then
  {Ht = no less than 3, no more than 9}
  Ht := IntMin(9, IntMax(ComboList^.Count+2, 3))
else Ht := 3;
R.B.Y := R.B.Y+Ht;
ILink^.Owner^.GetExtent(R1);
if R.B.Y >= R1.B.Y then   {check to see if bottom is in window}
  R.B.Y := R1.B.Y-1;
R.A.Y := R.B.Y - Ht;           {find top}
if R.A.Y <= R1.A.Y then   {see if top is too high}
  R.A.Y := R1.A.Y+1;

Dlg := New(PListDialog, Init(R));
Dlg^.Flags := Dlg^.Flags or wfGrow;

Dlg^.GetExtent(R);
R.Grow(-1, -1);
R1 := R;
R.A.X := R.B.X-1;
New(Scrollbar, Init(R));
Dlg^.Insert(ScrollBar);

Dec(R1.B.X);
PLB := InitListBox(R1, Scrollbar);
Dlg^.Insert(PLB);

MakeDialog := Dlg;
end;

{---------------------------TCombo.Draw}
procedure TCombo.Draw;
var
  B: TDrawBuffer;
begin
if Size.X = 1 then
  WriteChar(0, 0, ShowChar, 1, 1)
else
  begin
  MoveCStr(B, #222'~'+ShowChar+'~'#221, GetColor($0102));
  WriteLine(0, 0, Size.X, Size.Y, B);
  end;
end;


{-------------------TCombo.GetPalette}
FUNCTION TCombo.GetPalette: PPalette;
const
  Pal : String[2] = CHistory;
begin
GetPalette := @Pal;
end;

end.
