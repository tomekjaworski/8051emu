{$F+,O+,X+}
Unit ColorTxt;

{
       Portions  Copyright (c) 1992 Borland International

TColoredText is a descendent of TStaticText designed to allow the writing
of colored text when color monitors are used.  With a monochrome or BW
monitor, TColoredText acts the same as TStaticText.

TColoredText is used in exactly the same way as TStaticText except that
the constructor has an extra Byte parameter specifying the attribute
desired.  (Do not use a 0 attribute, black on black).

Modified by Tomasz Jaworski 12,03,2000
}

Interface
uses Objects, Drivers, Views, Dialogs, App;

type
  PColoredText = ^TColoredText;
  TColoredText = object(TStaticText)
    Attr : Byte;
{Dodane}
    Command:Word;
{************}
    constructor Init(var Bounds: TRect; const AText: String; Attribute : Byte; {******}ACommand:Word{*******});
    constructor Load(var S: TStream);
    function GetTheColor : byte; virtual;
    procedure Draw; virtual;
    procedure Store(var S: TStream);
{Dodane}
    procedure HandleEvent(var event:TEvent); virtual;
    Procedure SetTitle(ATitle:String; RedrawNow:Boolean);
    procedure SetColor(Cl:Byte; redrawNow:Boolean);
{*************}
  end;

const
  RColoredText: TStreamRec = (
     ObjType: 611;
     VmtLink: Ofs(TypeOf(TColoredText)^);
     Load:    @TColoredText.Load;
     Store:   @TColoredText.Store
  );

Implementation

constructor TColoredText.Init(var Bounds: TRect; const AText: String;
                                  Attribute : Byte; ACommand:Word);
begin
     TStaticText.Init(Bounds, AText);
     Attr := Attribute;
     Command := ACommand;
{ to dodaˆem}
{     Options := Options or (ofSelectable + ofFirstClick + ofPreProcess + ofPostProcess);
{     EventMask := EventMask or (evKeyDown or evCommand);}
{     EventMask := EventMask or evBroadcast;}
{***************}
end;

Procedure TColoredText.SetTitle(ATitle:String; RedrawNow:Boolean);
begin
     DisposeStr(text);
     Text := NewStr(ATitle);
     if not RedrawNow then exit;
     Draw;
end;

Procedure TColoredText.SetColor(Cl:Byte; RedrawNow:Boolean);
begin
     Attr := Cl;
     if not RedrawNow then exit;
     Draw;
end;

constructor TColoredText.Load(var S: TStream);
begin
     TStaticText.Load(S);
     S.Read(Attr, Sizeof(Attr));
end;

procedure TColoredText.HandleEvent(var Event:TEvent);
var e:TEvent;
    Klik:TRect;
    Mysz: TPoint;
begin
     inherited HandleEvent(Event);
     GetExtent(Klik);
{     Inc(Klik.A.X);
     Dec(klik.B.X);
     Dec(klik.B.Y);}
     case Event.What of
          evMouseDown:
          begin
               MakeLocal(Event.Where, Mysz);
               if (not Klik.Contains(Mysz)) or (EventMask and evCommand = 0)
                  or (Command = 0) then
               begin
                    ClearEvent(Event);
                    exit;
               end;
               E.What := evCommand;
               E.Command := Command;
               E.InfoPtr := @Self;
               PutEvent(E);
               ClearEvent(event);
          end;
     end;
end;

procedure TColoredText.Store(var S: TStream);
begin
     TStaticText.Store(S);
     S.Write(Attr, Sizeof(Attr));
end;

function TColoredText.GetTheColor : byte;
begin
     if AppPalette = apColor
        then GetTheColor := Attr
        else GetTheColor := GetColor(1);
end;

procedure TColoredText.Draw;
{Largely taken from Borland's TStaticText.Draw}
var
  Color: Byte;
  Center: Boolean;
  I, J, L, P, Y: Integer;
  B: TDrawBuffer;
  S: String;
begin
  Color := GetTheColor;
  GetText(S);
  L := Length(S);
  P := 1;
  Y := 0;
  Center := False;
  while Y < Size.Y do
  begin
    MoveChar(B, ' ', Color, Size.X);
    if P <= L then
    begin
      if S[P] = #3 then
      begin
        Center := True;
        Inc(P);
      end;
      I := P;
      repeat
        J := P;
        while (P <= L) and (S[P] = ' ') do Inc(P);
        while (P <= L) and (S[P] <> ' ') and (S[P] <> #13) do Inc(P);
      until (P > L) or (P >= I + Size.X) or (S[P] = #13);
      if P > I + Size.X then
        if J > I then P := J else P := I + Size.X;
      if Center then J := (Size.X - P + I) div 2 else J := 0;
      MoveBuf(B[J], S[I], Color, P - I);
      while (P <= L) and (S[P] = ' ') do Inc(P);
      if (P <= L) and (S[P] = #13) then
      begin
        Center := False;
        Inc(P);
        if (P <= L) and (S[P] = #10) then Inc(P);
      end;
    end;
    WriteLine(0, Y, Size.X, 1, B);
    Inc(Y);
  end;
end;

begin
     RegisterType(RColoredText);
end.
