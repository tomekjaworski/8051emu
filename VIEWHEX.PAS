unit ViewHex;
interface
uses Drivers, Objects, Views, Crt, Stale, Textoolz, App, Ed, Zmienne;

procedure OknoHEX(Adres:Pointer; Dlugosc:Word; Tytul:String; ReDrawMsg:Word);
{BuforAlokowanyPrzezSystem = np. PamiecROM, PamiecRAM}

implementation
uses MsgBox;

type
  PHexViewer = ^THexViewer;
  THexViewer = object(TScroller)
    Bufor: Pointer;
    Dlugosc: Word;
    MaxLines: Integer;
    Adres:Word;
    Msg:Word;
    BuforAlokowany:Boolean;
    constructor Init(var Bounds:TRect; AVScrollBar: PScrollBar; Buf:Pointer; Bajtow:Word; ReDrawMsg:Word);
    destructor Done; virtual;
    procedure Draw; virtual;
    procedure HandleEvent(var Event:TEvent); virtual;
  end;

  PHexWindow = ^THexWindow;
  THexWindow = object(TWindow)
    Podglad: PHexViewer;
    constructor Init(var Bounds: TRect; Buforek:Pointer; Wielkosc:Word; Tytul:String; ReDrawMsg:Word);
    destructor Done; virtual;
    procedure SizeLimits(var Min, Max: TPoint); virtual;
    function GetPalette: PPalette; virtual;
    procedure RysujAdres;
    procedure HandleEvent(var Event:TEvent); virtual;
    procedure Draw; virtual;
  end;

const
  VWidth = 71;      { total width of view }
  HStart = 7;       { starting column of hex dump }
  CStart = 56;      { starting column of character dump }

type
  String2 = String[2];

  PBuforFFFE = ^TBuforFFFE;
  TBuforFFFE = array[0..$FFFE] of Byte;

procedure OknoHEX(Adres:Pointer; Dlugosc:Word; Tytul:String; ReDrawMsg:Word);
var Dlg:PHexWindow;
    R:TRect;
begin
     R.Assign(0,0,73,16);
     dlg := new(phexwindow, init(r, Adres, Dlugosc, Tytul, ReDrawMsg));
     dlg^.options := dlg^.options or ofcentered;
     Desktop^.insert(dlg);
end;


procedure THexViewer.HandleEvent(var Event:TEvent);
var Gdzie:TPoint;
    StaryAdres:Word;
    Bajt:Word;
begin
     inherited handleEvent(Event);
     if Event.What = evMouseDown then
     begin
          MakeLocal(Event.Where, Gdzie);
          StaryAdres := Adres;
          if Gdzie.X = CStart-2 then exit;
          if Gdzie.X < 5 then exit;
          Adres := (Delta.Y+Gdzie.y)*16;
          if Gdzie.X < CStart-2 then Inc(Adres, (Gdzie.X-6) div 3)
                                else Inc(Adres, Gdzie.X-CStart+1);
          if Adres > Dlugosc-1 then Adres := Dlugosc-1;

          draw;
     end;
     if Event.Double and (Adres = StaryAdres) then
     begin
          Bajt := PBuforFFFE(Bufor)^[Adres];
          EdycjaZwykla(Bajt, 1);
          PBuforFFFE(Bufor)^[Adres] := Bajt;
          Message(Desktop, evBroadcast, msg, nil);
     end;
     if (event.what = evbroadcast) and (event.command = msg) then Draw;
end;

procedure AddHexByte(B: Byte; P: Pointer);
const
  HexChars : array[0..15] of char = '0123456789ABCDEF';
type
  P2Char = ^T2Char;
  T2Char = array[0..1] of Char;
begin
  P2Char(P)^[0] := HexChars[ (B and $F0) shr 4 ];
  P2Char(P)^[1] := HexChars[ B and $0F ];
end;


{ THexViewer }

constructor THexViewer.Init(var Bounds:TRect; AVScrollBar: PScrollBar;
                            Buf:Pointer; Bajtow:Word; ReDrawMsg:Word);

begin
  inherited Init(Bounds, nil, AVScrollBar);
  GrowMode := gfGrowHiX + gfGrowHiY;
  Options := Options or ofTileable;
  Adres := $000;

  Msg := ReDrawMsg;
  Bufor := Buf; Dlugosc := Bajtow;
  if (Bufor = nil) or (Dlugosc = 0) then
  begin
       Bufor := nil;
       Dlugosc := 0;
  end;
  MaxLines := Dlugosc div 16;
  if Dlugosc mod 16 > 0 then Inc(MaxLines);
  SetLimit(0, MaxLines);
end;

destructor THexViewer.Done;
begin
  inherited Done;
end;

procedure THexViewer.Draw;
var
  B: TDrawBuffer;
  S: String;
  C: Word;
  Offset: Word;
  x,y : Byte;
  i,bajt: Byte;
  L: Longint;
  BajtZaznaczony:Byte;
  KodHex:String[4];
begin
     C := GetColor(1);
     Kodhex := ' 00 ';
     for y := 0 to Size.Y-1 do
     begin
          FillChar(S[1], VWidth, 32);
          S[0] := Char(VWidth);
          MoveChar(B, #32, C, Size.X);
          Offset := (Delta.Y + Y) * 16;
          if (Delta.Y + Y) < MaxLines then
          begin
               L := (Delta.Y + Y) * 16{Offset};
               FormatStr(S, '%04x:', L);
               S[0] := Char(VWidth);
               i := HStart;
               for x := 0 to 15 do
               begin
                    if Offset + x < Dlugosc then
                    begin
                         bajt := PBuforFFFE(Bufor)^[Offset+x];
                         AddHexByte(Bajt, @S[i]);
{                         if Adres = Offset+X then AddHexByte(bajt, @KodHex[2]);}
                         S[CStart + x] := Char(Bajt);
                         Inc(i,3);
                    end;
               end;
          end;
          S[CStart - 1] := '³';
          MoveStr(B, S, C);
          if (Offset = Adres and $FFF0) then
          begin
               Bajt := PBuforFFFE(Bufor)^[Adres];
               AddHexByte(Bajt, @KodHex[2]);
               MoveStr(B[(Adres and $000F)*3 + 5], KodHex, White or Blue shl 4);
               MoveChar(B[Adres and $000F+3*16+7], Chr(Bajt), White or Blue shl 4, 1);
          end;
          WriteLine(0,Y,Size.X,1,B);
     end;
end;

{ THexWindow }
procedure THexWindow.HandleEvent(var Event:TEvent);
begin
     inherited HandleEvent(Event);
     if (event.what = evMouseDown) or (event.what = evKeyDown) then RysujAdres;
end;

Procedure THexWindow.RysujAdres;
var Adres:String[6];
    b:TDrawBuffer;
begin
     if Podglad = nil then exit;
     Adres := '[    ]';
     AddHexByte(Hi(Podglad^.Adres), @Adres[2]);
     AddHexByte(Lo(Podglad^.Adres), @Adres[4]);
     MoveStr(B, Adres, GetColor(3));
     WriteLine(2, Size.Y-1, 6, 1, B);
end;

procedure THexWindow.Draw;
begin
     inherited Draw;
     RysujAdres;
end;

constructor THexWindow.Init(var Bounds: TRect; Buforek:Pointer; Wielkosc:Word; Tytul:String; ReDrawMsg:Word);
var
  R: TRect;
  SB: PScrollBar;
begin
  inherited Init(Bounds, Tytul, wnNoNumber);
  GetExtent(R);
  SB := StandardScrollBar(sbVertical + sbHandleKeyboard);
  Insert(SB);
  Inc(R.A.X);  Inc(R.A.Y);
  Dec(R.B.X);  Dec(R.B.Y);
  Podglad := New(PHexViewer, Init(R, SB, Buforek, Wielkosc, ReDrawMsg));
  Insert(Podglad);
end;

destructor THexWindow.Done;
begin
  if Podglad <> nil then Dispose(Podglad, Done);
  inherited Done;
end;

procedure THexWindow.SizeLimits(var Min, Max: TPoint);
begin
  inherited SizeLimits(Min, Max);
  Max.X := 73;
end;

function THexWindow.GetPalette: PPalette;
const
  MyPal : String[Length(CGrayWindow)] = CCyanWindow;
begin
  GetPalette := @MyPal;
end;
end.
