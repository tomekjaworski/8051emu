{* A TextToolz Turbo Pascal 7.0 library by Tomasz Jaworski              *}
{* Wersja 2.102.30                                                      *}
{*        XX.YY.ZZ                                                      *}
{* XX-Numer wersji; YY-Ilosc procek; ZZ-ewentualne zmiany               *}
{* Ostatnia zmiana: 30,9,2oo1                                           *}
{{$A+,B+,D+,E+,F-,G+,I+,L+,N+,O-,P+,Q+,R+,S+,T+,V+,X+,Y+}
{{$M 65520,0,655360}
unit textoolz;
interface
Uses Crt,Dos;

const SwpToRight   =  1;
      SwpToLeft    =  2;
      SwpToTop     =  3;
      SwpToBottom  =  4;

const clBlack         = #0;
      Black           = 0;
      clBlue          = #1;
      Blue            = 1;
      clGreen         = #2;
      Green           = 2;
      clCyan          = #3;
      Cyan            = 3;
      clRed           = #4;
      Red             = 4;
      clMagenta       = #5;
      Magenta         = 5;
      clBrown         = #6;
      Brown           = 6;
      clLightGray     = #7;
      LightGray       = 7;
      clDarkGray      = #8;
      DarkGray        = 8;
      clLightBlue     = #9;
      LightBlue       = 9;
      clLightGreen    = #10;
      LightGreen      = 10;
      clLightCyan     = #11;
      LightCyan       = 11;
      clLightRed      = #12;
      LightRed        = 12;
      clLightMagenta  = #13;
      LightMagenta    = 13;
      clYellow        = #14;
      Yellow          = 14;
      clWhite         = #15;
      White           = 15;

clNames:array[0..15] of String = ('Black','Blue','Green','Cyan',
                                  'Red','Magenta','Brown','LightGray',
                                  'DarkGray','LightBlue','LightGreen',
                                  'LightCyan','LightRed','LightMagenta',
                                  'Yellow','White');
clNames2:array[0..15] of String = ('B','Bl','G','C',
                                   'R','M','Br','LG',
                                   'DG','LBl','LG',
                                   'LC','LR','LM',
                                   'Y','W');
      kolory          = [0..15];
      z1 : array[1..26] of char =
           ('4','b','c','d','3','f','G','h','1','J','k','1','m','N','0','p','Q','r','5','7','U','v','w','X','y','2');
      z2 : array[1..26] of char =
           ('a','B','C','D','e','F','G','H','i','J','K','L','M','n','O','P','Q','R','$','T','u','V','w','X','Y','Z');
      z3 : array[1..26] of char =
           ('A','b','c','d','E','f','g','h','|','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');

Type  TZnak16 = array[1..16] of byte;
      TZnak14 = array[1..14] of byte;
      TZnak8  = array[1..8] of byte;
      TZnakiRamki = array[0..6] of char;
      Character = Array [1..32] Of Byte;
      TAnimowanyZnak = record
         Znak:Char;
         KolorZnaku:Byte;
         StopX,StopY:Byte;
         CurrX,CurrY:Integer;
         CzyJestNaMiejscu:Boolean;
      end;
Type ListaAnimowanychZnakow = array[1..1000] of TAnimowanyZnak;

const RamkaZnaki1 : TZnakiRamki = ('/','-','\','|','\','-','/');
      RamkaZnaki2 : TZnakiRamki = ('+','-','+','|','+','-','+');
      RamkaZnaki3 : TZnakiRamki = ('Ú','Ä','¿','³','À','Ä','Ù');
      RamkaZnaki4 : TZnakiRamki = ('É','Í','»','º','È','Í','¼');
      RamkaZnaki5 : TZnakiRamki = ('Õ','Í','¸','³','Ô','Í','¾');
      RamkaZnaki6 : TZnakiRamki = ('Ö','Ä','·','º','Ó','Ä','½');
      RamkaZnaki7 : TZnakiRamki = ('Ü','Ü','Ü','Û','ß','ß','ß');
      RamkaZnaki8 : TZnakiRamki = ('Û','ß','Û','Û','Û','Ü','Û');
      RamkaPusta  : TZnakiRamki = (' ',' ',' ',' ',' ',' ',' ');
{MyReadKey}
{const
     kbEsc      = $001B;  kbUp       = $4800;  kbDown     = $5000;
     kbLeft     = $4B00;  kbRight    = $4D00;  kbBack     = $0008;
     kbEnter    = $000D;  kbSpace    = $0020;  kbHome     = $4700;
     kbEnd      = $4F00;  kbPgUp     = $4900;  kbPgDn     = $5100;
     kbDel      = $5300;  kbIns      = $5200;  kbTab      = $0009;
     kbShiftTab = $0F00;  kbF1       = $3B00;  kbF2       = $3C00;
     kbF3       = $3D00;  kbF4       = $3E00;  kbF5       = $3F00;
     kbF6       = $4000;  kbF7       = $4100;  kbF8       = $4200;
     kbF9       = $4300;  kbF10      = $4400;  kbShiftIns = $5200;
     kbShiftDel = $5300;  kbCtrlR    = $0012;  kbCtrlF1   = $5E00;
}
{}
var  ScreenWidth,ScreenHeight:Byte;
     Pixel2Text:Array[0..255] Of Word;
     VScreen:Array[0..79,0..49] Of Byte;
     KursorWidzialny:Boolean;
type TTablica = Array [0..16382] of Word;

     TBufor1KB = array[1..1024*1] of byte;
     TBufor2KB = array[1..1024*2] of byte;
     TBufor3KB = array[1..1024*3] of byte;
     TBufor4KB = array[1..1024*4] of byte;

Procedure SetAllWhite;
function c0nv(s:string):string;
Procedure ClTextLn(txt:string);
Procedure ClText(txt:string);
Procedure ClTextXY(x,y:Word;txt:string;len:byte);
Procedure ClTextXYAutoLen(x,y:Word;txt:string);
Function UpperCase(s:string):String;
Function LowerCase(s:string):String;
procedure ShowFont(Font:Pointer);
Procedure CursorOn;
Procedure CursorOff;

procedure DajZnak(x,y:word;znak:char;kolorznaku,kolortla:byte);
procedure enable;
procedure disable;
Function Space(ile:byte):string;
Procedure OutTextXY(x,y:Word;txt:string;znak,tlo:byte);
function MyReadKey:Word; {zmiana z char na word}
Procedure Ramka(x1,y1,x2,y2:Byte;r:TZnakiRamki;kolortla,kolorznaku:byte);
Function DajPozycjeZnaku(Znak,wysokosc:Byte;Czcionka:pointer):pointer;
function GetROMFont(FontNo:Byte):pointer;
procedure toggleBit(var kod:byte;bit:byte);

procedure setBitOn (var kod:byte;bit:byte);
function isBitOn(kod,bit:byte):boolean;
Procedure MyDelay(IleMilisekund:Word);
Procedure SetBlinkOn;
Procedure SetBlinkOff;
Procedure Set25Lines;
Procedure Set50Lines;
Procedure PutPixelDirect(X,Y:Word;Col:Byte);
Procedure DumpScreen(IleZostawicLiniiNaDole:Word);
Procedure PutPixel(X,Y:Word;Col:Byte);

Procedure GetPal(PalNum:byte;Var R,G,B:byte);
Procedure RestorePal;
Procedure SavePal;
Procedure SetPal(PalNum,R,G,B:Byte);
procedure ClearPal;
Procedure FadeOut;
Procedure FadeIn;
Procedure WaitRetrace;
procedure pause(hs:longint);
Procedure DrawBig8(x,y:byte;txt:string;kolorznaku,kolortla:byte;znak:char;addr:pointer);

Procedure DrawBig16(x,y:byte;txt:string;kolorznaku,kolortla:byte;znak:char;addr:pointer);
Procedure DrawBig16ToBuffer(var Bufor:Pointer;x,y:byte;txt:string;kolorznaku,kolortla:byte;znak:char;addr:pointer);
procedure FlushKB;
procedure PrzegladajTextZPamieci(addr:pointer;textsize:word;KtoNapisal:String);
procedure ZapiszEkran;
procedure OdtworzEkran;
function TrimRight(const S: string): string;
function TrimLeft(const S: string): string;
function Trim(const S: string): string;
Procedure SetBackgroundColorBlack;

Procedure SetBackgroundColorWhite;
procedure DisplayCharWithClipping(x,y:Integer;znak:char;kolorznaku,kolortla:byte);
Procedure ClTextXYAutoLenWithNormalColor(x,y:Word;txt:string;kol:byte);
function SegmentVideo : Word;
FUNCTION WildComp(wild,name:string):boolean;
function KastracjaPliku(plik:String;Gdzie:Longint):Byte;
Function Potega(Podstawa:Word; Wykladnik:Byte):LongInt;
Function Int2Str(I:longint):String;
Function Str2Int(s:String):Longint;
function hex2decl(s:string):Longint;

function hex2decw(s:string):word;
function dec2hexl(w:LongInt):string;
function dec2hexw(w:word):string;
function dec2hexb(w:byte):string;
function bin2dec(str:string):word;
function dec2bin(w:word):string;
Function Max(wartosc1,wartosc2:longint):longint;
Function Min(wartosc1,wartosc2:longint):longint;
Procedure LoadUserFont(Bufor:Pointer;BajtowNaFonta:Byte);
procedure Sweap(Jak:Byte;Delej:Word);

function Select(Ch:Char;Low,Hi:Byte):boolean;
function IsLower(Ch:Char):boolean;
function IsUpper(Ch:Char):boolean;
function IsAlpha(Ch:Char):boolean;
function IsDigit(Ch:Char):boolean;
function IsAlnum(Ch:Char):boolean;
function IsAscii(Ch:Char):boolean;
function IsControl(Ch:Char):boolean;
function IsGraph(Ch:Char):boolean;
function IsPrint(Ch:Char):boolean;

function IsPunct(Ch:Char):boolean;
function IsBlank(Ch:Char):boolean;
function IsDigitH(Ch:Char):boolean;
function IsExtend(Ch:Char):boolean;
procedure PutPixelToBuffer(var buf:Pointer;x,y:Integer;pix:byte);
procedure DisplayCharWithClippingAndAttrib(x,y:integer;znak:char;Atrybut:Byte);
procedure FlushDisk;
Function LosowyZnakPoziomy:Char;
Function LosowyZnakPionowy:Char;
function bin2decB(str:string):word;

Function Kolor(Znak,Tlo:Byte):Byte;
procedure PrintText(X,Y,Color:integer;Buf:string);
procedure TextWindow(X,Y,LenX,LenY,C,TitleC:Integer;Title:string);
procedure TextBar(X,Y,LenX,LenY,Color:integer;Ch:char);
procedure PostawKursorXY(x,y:byte);
{function InputText(X,Y,Len:integer;var St:string):integer;}
function Key:integer;
Procedure ZamienZnaki(var S:string;co,naco:byte);
{procedure RestoreScreen(x,y,x1,y1:byte; var scr:pointer);
procedure SaveScreen(x,y,x1,y1:byte; var scr:pointer);}

Procedure ClTextXYWithBk(x,y:Word;txt:string;Tlo:Byte);
{function InputTextColored(X,Y,Len:integer;var St:string;Kolor:Byte):integer;}
Procedure Shadow(x,y,x1,y1:Byte);
procedure Beep(x:word);

Var CursorTop,CursorBottom:Byte;

implementation
var
    BuforEkranu:Pointer;
    SaveTable:Array [0..255] Of Record
                                      R,G,B:Byte;
                                End;
    KastracjaDummy:Byte;
    KastracjaNazwa:array[1..13] of char;
    KastracjaUchwyt:Word;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure ClTextLn(txt:string);
var znak:byte;
    i:Word;
begin
     for i := 1 to Ord(txt[0]) do begin
         znak := Ord(txt[i]);
         if znak in kolory
            then TextColor(Znak)
            else Write(Chr(znak));
     end;
     WriteLn;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure ClText(txt:string);
var znak:byte;
    i:Word;
begin
     for i := 1 to Ord(txt[0]) do begin
         znak := Ord(txt[i]);
         if znak in kolory
            then TextColor(Ord(znak))
            else Write(Chr(znak));
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure ClTextXY(x,y:Word;txt:string;len:byte);
var znak:byte;
    i:Word;
    Kolor:Byte;
    IleOdjac:Byte;
begin
     IleOdjac := 0;
     Kolor := 07;
     for i := 1 to len do begin
         znak := Ord(txt[i]);
         if znak in kolory
            then begin
                      Kolor := Ord(znak);
                      Inc(IleOdjac);
                 end
            else MemW[SegB800:(y*ScreenWidth+x+i-1-IleOdjac)*2] := Znak+256*kolor;
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function UpperCase(s:string):String;
Var i:Word;
Begin
     For i:=1 To Length(s) Do s[i]:=UpCase(s[i]);
     UpperCase:=s;
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function LowerCase(s:string):String;
Var i:Word;
Begin
     For i:=1 To Length(s) Do
         if s[i] in ['A'..'Z'] then s[i] := chr(ord(s[i])+32);
     LowerCase:=s;
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function c0nv(s:string):string;
var wy:string;
    i:byte;
    znak:char;
    z:string;
begin
wy := '';
if Random(3) = 1 then
begin
     c0nv := s;
     Exit;
end;
for i := 1 to ord(s[0]) do
    begin
         znak := UpCase(s[i]);
         case random(3) of
              0: z := z1;
              1: z := z2;
              2: z := z3;
         end;
         if not ((znak > 'Z') or (znak < 'A')) then znak := z[ord(znak)-ord('A')+1];
         wy := wy + znak;
    end;
c0nv := wy;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure ClTextXYAutoLen(x,y:Word;txt:string);
var znak:byte;
    i:Word;
    Kolor:Byte;
    IleOdjac:Byte;
begin
     IleOdjac := 0;
     Kolor := 07;
     for i := 1 to ord(txt[0]) do begin
         znak := Ord(txt[i]);
         if znak in kolory
            then begin
                      Kolor := Ord(znak);
                      Inc(IleOdjac);
                 end
            else MemW[SegB800:(y*ScreenWidth+x+i-1-IleOdjac)*2] := Znak+256*kolor;
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure ClTextXYAutoLenWithNormalColor(x,y:Word;txt:string;kol:byte);
var znak:byte;
    i:Word;
    Kolor:Byte;
    IleOdjac:Byte;
begin
     IleOdjac := 0;
     Kolor := kol;
     for i := 1 to ord(txt[0]) do begin
         znak := Ord(txt[i]);
         if znak in kolory
            then begin
                      Kolor := Ord(znak);
                      Inc(IleOdjac);
                 end
            else MemW[SegB800:(y*ScreenWidth+x+i-1-IleOdjac)*2] := Znak+256*kolor;
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure ShowFont(Font:Pointer);
begin
  asm
     push    ax
     push    bx
     push    cx
     push    dx
     push    es
     push    bp
     mov     ax, word ptr [Font+2]
     mov     es,ax
     mov     ax,word ptr [Font]
     mov     bp,ax
     mov     ax,01100h
     mov     bh,16
     mov     bl,0
     mov     cx,256
     mov     dx,0
     int     10h
     pop     bp
     pop     es
     pop     dx
     pop     cx
     pop     bx
     pop     ax
  end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure CursorOff;Assembler;
Asm
   mov ah,$03
   mov bh,$00
   int 10h
   mov CursorTop,ch
   mov CursorBottom,cl
   mov ah,$01
   mov cx,$2000
   int 10h
   mov KursorWidzialny,false
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure CursorOn;Assembler;
Asm
   mov ah,$01
   mov ch,CursorTop
   mov cl,CursorBottom
   int 10h
   mov KursorWidzialny,true;
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure OutTextXY(x,y:Word;txt:string;znak,tlo:byte);
var i:Word;
begin
for i := 1 to ord(txt[0]) do
    MemW[SegB800:(y*ScreenWidth+x+i-1)*2] := ord(txt[i])+$100*(znak+$10*tlo);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure enable;assembler;
asm;
    sti
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure disable;assembler;
asm;
    cli
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function Space(ile:byte):string;
Var
  zip : String;
Begin
{Ta matoda co˜ szfankuje}
{  FillChar(zip,ile+1,' ');
  zip[0] := Chr(ile);
  Space := Zip;}

Zip := '                                                                                                  ';
Zip := Copy(Zip,1,ile);
Space := Zip;
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure DisplayCharWithClipping(x,y:integer;znak:char;kolorznaku,kolortla:byte);
var x1,y1:integer;
begin
     x1 := ScreenWidth-1;
     y1 := ScreenHeight-1;
     if (x >= 0) and (x <= x1) and (y >= 0) and (y <= y1)
{     if (x in [0..79]) and (y in [0..49])}
        then MemW[SegB800:(y*ScreenWidth+x)*2] := ord(znak)+$100*(kolorznaku+$10*kolortla);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure DajZnak(x,y:word;znak:char;kolorznaku,kolortla:byte);
begin
     MemW[SegB800:(y*ScreenWidth+x)*2] := ord(znak)+$100*(kolorznaku+$10*kolortla);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function MyReadKey:Word;
var k1,k2:Char;
begin
     k1 := ReadKey; k2 := #0;
     if k1 = #0 then k2 := ReadKey;
     MyReadKey := (Ord(k2) shl 8) or Ord(k1);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure Ramka(x1,y1,x2,y2:Byte;r:TZnakiRamki;kolortla,kolorznaku:byte);
var  j,i:byte;
     Kolor:Word;

begin
     Kolor := $100*(kolorznaku+$10*kolortla);
     for i := x1 to x2 do
         for j := y1 to y2 do
             MemW[SegB800:(j*ScreenWidth+i)*2] := ord(' ')+kolor;
     For i := (x1+1) to (x2-1) do
     begin
          MemW[SegB800:(y1*ScreenWidth+i)*2] := ord(r[1])+kolor;
          MemW[SegB800:(y2*ScreenWidth+i)*2] := ord(r[5])+kolor;
     end;
     For i := (y1+1) to (y2-1) do
     begin
          MemW[SegB800:(i*ScreenWidth+x1)*2] := ord(r[3])+kolor;
          MemW[SegB800:(i*ScreenWidth+x2)*2] := ord(r[3])+kolor;
     end;
     MemW[SegB800:(y1*ScreenWidth+x1)*2] := ord(r[0])+kolor;
     MemW[SegB800:(y1*ScreenWidth+x2)*2] := ord(r[2])+kolor;
     MemW[SegB800:(y2*ScreenWidth+x1)*2] := ord(r[4])+kolor;
     MemW[SegB800:(y2*ScreenWidth+x2)*2] := ord(r[6])+kolor;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function isBitOn(kod,bit:byte):boolean;
begin
     isBitOn := ((kod shr bit) and 1) = 1
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure setBitOn (var kod:byte;bit:byte);
begin
     kod := kod or (1 shl bit)
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure toggleBit(var kod:byte;bit:byte);
begin
     kod := kod xor (1 shl bit)
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function GetROMFont(FontNo:Byte):pointer;
var Wynik:Pointer;
    r:registers;
begin
     Wynik := nil;
     r.ah := $11;
     r.al := $30;
     r.bh := FontNo;
     Intr($10,r);
     Wynik := Ptr(r.es,r.bp);
     GetROMFont := Wynik;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function DajPozycjeZnaku(Znak,wysokosc:Byte;Czcionka:pointer):pointer;
begin
     DajPozycjeZnaku := Ptr(Seg(Czcionka^),Ofs(Czcionka^)+znak*wysokosc);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure MyDelay(IleMilisekund:Word);Assembler;
Asm

   mov ax,$03e8
   mul IleMilisekund
   mov cx,dx
   mov dx,ax
   mov ah,$86
   int 15h
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure SetBlinkOn;Assembler;
Asm
   mov ax,1003h
   mov bl,01h
   int 10h
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure SetBlinkOff;Assembler;
Asm
   mov ax,1003h
   mov bl,00h
   int 10h
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure Set25Lines;
begin
     ScreenHeight := 25;
     TextMode(CO80);
     if not KursorWidzialny then CursorOff;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure Set50Lines;
begin
     ScreenHeight := 50;
     TextMode(CO80+Font8x8);
     if not KursorWidzialny then CursorOff;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure DumpScreen(IleZostawicLiniiNaDole:Word);Assembler;
Asm
   mov ax,$b800
   mov es,ax
   xor di,di
   lea si,VScreen
   lea dx,Pixel2Text
{   xor ax,ax}
   mov ax,IleZostawicLiniiNaDole
   mov cx,80*50
   sub cx,ax
@loop:
   mov al,ds:[si]
   inc si
   xor ah,ah
   add ax,ax
   mov bx,dx
   add bx,ax
   mov ax,ds:[bx]
   stosw
   dec cx
   jnz @loop
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure PutPixel(X,Y:Word;Col:Byte);assembler;
Asm
   lea di,VScreen
   mov ax,Y
   add di,X
   mov bx,ax
   shl ax,6
   shl bx,4
   add di,bx
   add di,ax
   mov al,Col
   mov ds:[di],al
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure PutPixelDirect(X,Y:Word;Col:Byte);assembler;
Asm
   mov ax,$b800
   mov es,ax

   mov di,X
   add di,di
   mov ax,Y
   mov bx,ax
   shl ax,7
   shl bx,5
   add ax,bx
   add di,ax


   lea bx,Pixel2Text
   mov al,Col
   xor ah,ah
   add ax,ax
   add bx,ax
   mov ax,ds:[bx]
   stosw
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure GetPal(PalNum:byte;Var R,G,B:byte);
Begin
     Port[$3C7]:=PalNum;
     R:=Port[$3C9];
     G:=Port[$3C9];
     B:=Port[$3C9];
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure SetPal(PalNum,R,G,B:Byte);assembler;
Asm
   mov dx, $03c8
   mov al, Palnum
   out dx, al
   inc dx
   mov al, R
   out dx, al
   mov al, G
   out dx, al
   mov al, B
   out dx, al
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure FadeOut;
Var I,II:Word;
    R,G,B:Byte;
Begin
     For I:=0 To 63 Do
         Begin
              For II:=0 To 255 Do
                  Begin
                       GetPal(II,R,G,B);
                       If (R>0) Then Dec(R);
                       If (G>0) Then Dec(G);
                       If (B>0) Then Dec(B);
                       SetPal(II,R,G,B);
                  End;
              WaitRetrace;
         End;
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure ClearPal;
Var I:Word;
Begin
     For I:=0 To 255 Do
     Begin
          SetPal(I,0,0,0);
     End;
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure FadeIn;
Var I,II:Word;
    R,G,B:Byte;
Begin
     For I:=0 To 63 Do
         Begin
              For II:=0 To 255 Do
                  Begin
                       GetPal(II,R,G,B);
                       If (R<SaveTable[II].R) Then Inc(R);
                       If (G<SaveTable[II].G) Then Inc(G);
                       If (B<SaveTable[II].B) Then Inc(B);
                       SetPal(II,R,G,B);
                  End;
              WaitRetrace;
         End;
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure SetAllWhite;
var i:integer;
begin
     For i := 0 to 255 do SetPal(i,255,255,255);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure SetBackgroundColorWhite;
begin
     SetPal(0,255,255,255);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure SetBackgroundColorBlack;
begin
     SetPal(0,0,0,0);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure RestorePal;
Var I:Word;
Begin
     For I:=0 To 255 Do SetPal(I,SaveTable[I].R,SaveTable[I].G,SaveTable[I].B);
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure SavePal;
Var I:Word;
Begin
     For I:=0 To 255 Do GetPal(I,SaveTable[I].R,SaveTable[I].G,SaveTable[I].B);
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure WaitRetrace; Assembler;
Asm
   mov dx,$03da
   @l1:
   in al,dx
   and al,$08
   jnz @l1
   @l2:
    in al,dx
   and al,$08
   jz @l2
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure pause(hs:longint); assembler;
asm
  {hs=17 ---> t=1sekunda}
  mov  es,seg0040
  mov  si,006ch
  mov  dx,word ptr es:[si+2]
  mov  ax,word ptr es:[si]
  add  ax,word ptr [hs]
  adc  dx,word ptr [hs+2]
  @@1:
  mov  bx,word ptr es:[si+2]
  cmp  word ptr es:[si+2],dx
  jl   @@1
  mov  cx,word ptr es:[si]
  cmp  word ptr es:[si],ax
  jl   @@1
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure DrawBig8(x,y:byte;txt:string;kolorznaku,kolortla:byte;znak:char;addr:pointer);
var poz:byte;
    GdzieZnak:Pointer;
    LiniaZnaku:Byte;
    Bit:Byte;
    Przesuniecie:Word;
begin
     for poz := 1 to ord(txt[0]) do
     begin
          GdzieZnak := DajPozycjeZnaku(Ord(txt[poz]),8,addr);

          for LiniaZnaku := 1 to 8 do
          begin
               Bit := 0;
               Przesuniecie := (y+liniaznaku-1)*ScreenWidth+x-1+(poz)*8;
               repeat
                     if ((TZnak8(GdzieZnak^)[LiniaZnaku] SHR Bit) AND 1) = 1
                        then MemW[SegB800:(Przesuniecie-bit)*2] := ord(znak)+
                                                                   256*(kolorznaku+$10*kolortla)
                        else MemW[SegB800:(przesuniecie-bit)*2] := ord(' ')+256*(kolorznaku+$10*kolortla);
                     inc(Bit);
               until Bit = 8;
          end;
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure DrawBig16(x,y:byte;txt:string;kolorznaku,kolortla:byte;znak:char;addr:pointer);
var poz:byte;
    GdzieZnak:Pointer;
    LiniaZnaku:Byte;
    Bit:Byte;
    Przesuniecie:Word;
begin
     for poz := 1 to ord(txt[0]) do
     begin
          GdzieZnak := DajPozycjeZnaku(Ord(txt[poz]),16,addr);

          for LiniaZnaku := 1 to 16 do
          begin
               Bit := 0;
               Przesuniecie := (y+liniaznaku-1)*ScreenWidth+x-1+(poz)*8;
               repeat
                     if ((TZnak16(GdzieZnak^)[LiniaZnaku] SHR Bit) AND 1) = 1
                        then MemW[SegB800:(Przesuniecie-bit)*2] := ord(znak)+
                                                                   256*(kolorznaku+$10*kolortla)
                        else MemW[SegB800:(przesuniecie-bit)*2] := ord(' ')+256*(kolorznaku+$10*kolortla);
                     inc(Bit);
               until Bit = 8;
          end;
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure DrawBig16ToBuffer(var Bufor:Pointer;x,y:byte;txt:string;kolorznaku,kolortla:byte;znak:char;addr:pointer);
var poz:byte;
    GdzieZnak:Pointer;
    LiniaZnaku:Byte;
    Bit:Byte;
    Przesuniecie:Word;
begin
     for poz := 1 to ord(txt[0]) do
     begin
          GdzieZnak := DajPozycjeZnaku(Ord(txt[poz]),16,addr);

          for LiniaZnaku := 1 to 16 do
          begin
               Bit := 0;
               Przesuniecie := (y+liniaznaku-1)*ScreenWidth+x-1+(poz)*8;
               repeat
                     if ((TZnak16(GdzieZnak^)[LiniaZnaku] SHR Bit) AND 1) = 1
                        then Mem[Seg(Bufor^):Ofs(Bufor^)+(Przesuniecie-bit)] := ord(znak)
                        else Mem[Seg(Bufor^):Ofs(Bufor^)+(Przesuniecie-bit)] := ord(' ');
                     inc(Bit);
               until Bit = 8;
          end;
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure flushkb; assembler;
asm
  mov ax,0c00h
  int 21h
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure PrzegladajTextZPamieci(addr:pointer;textsize:word;KtoNapisal:String);
Var Adresy:Pointer;
    IloscLinii:Longint;
    Adres:Longint;
    Gdzie,i,j:Word;
    Bufor:array[0..100] of CHar;
    Klawisz:Char;
    znak:Byte;
    PozycjaZnaku:Word;
begin
PozycjaZnaku := 0;
IloscLinii := 0;
While not (PozycjaZnaku>=TextSize) do
begin
{     BlockRead(PlikFile,znak,1);}
     znak := Byte(Ptr(Seg(Addr^),Ofs(Addr^)+PozycjaZnaku)^);
     Inc(PozycjaZnaku);
     if znak = 13 then
     begin
          znak := Byte(Ptr(Seg(Addr^),Ofs(Addr^)+PozycjaZnaku)^);
          Inc(PozycjaZnaku);
          if znak = 10 then Inc(IloscLinii);
     end;
end;
GetMem(Adresy,IloscLinii*SizeOf(LongInt));
Adres := 0;
Gdzie := 0;
TTablica(Adresy^)[Gdzie] := Adres;
PozycjaZnaku := 0;
While not(PozycjaZnaku>=TextSize) do
begin
     znak := Byte(Ptr(Seg(Addr^),Ofs(Addr^)+PozycjaZnaku)^);
     Inc(PozycjaZnaku);
     Inc(Adres);
     if znak = 13 then
     begin
          znak := Byte(Ptr(Seg(Addr^),Ofs(Addr^)+PozycjaZnaku)^);
          Inc(PozycjaZnaku);
          Inc(Adres);
          if znak = 10 then
          begin
               Inc(Gdzie);
               TTablica(Adresy^)[Gdzie] := Adres;
          end;
     end;
end;
Gdzie := 0;
TextColor(LightGray);
Ramka(0,0,79,21,RamkaZnaki4,Black,White);
Ramka(0,22,79,23,RamkaPusta,Red,White);
OutTextXY(0,22,'Castle Of The Winds Zin issue #0',White,Red);
OutTextXY(0,22,'Castle Of The Winds Zin issue',Black,Red);
OutTextXY(49,22,'coded by Commander Keen /AAOCG/',black,Red);
OutTextXY(2,23,'Text wyskrobal: ',black,Red);
OutTextXY(18,23,KtoNapisal,Yellow,Red);
repeat
      For i := 0 to 24-2-3 do
      begin
           if I+Gdzie+1 <= IloscLinii then
           begin
                PozycjaZnaku := TTablica(Adresy^)[Gdzie+i];

{                Seek(PlikFile,TTablica(Adresy^)[Gdzie+i]);}
                FillChar(Bufor,SizeOf(Bufor),#0);
                Move(Ptr(Seg(Addr^),Ofs(Addr^)+PozycjaZnaku)^,Bufor,TTablica(Adresy^)[Gdzie+i+1]-TTablica(Adresy^)[Gdzie+i]-2);
                For j := 1 to 78 do MemW[SegB800:((i+1)*ScreenWidth+j)*2] := $0720;
                ClTextXY(1,i+1,Bufor,TTablica(Adresy^)[Gdzie+i+1]-TTablica(Adresy^)[Gdzie+i]-2);
           end;
      end;

{      Klawisz := MyReadKey;}
      Klawisz := ReadKey;
      if Klawisz = #0 then Continue;
      if Klawisz = 'H' then
      begin
           if Gdzie > 0 then Dec(Gdzie);
      end;
      if Klawisz = 'P' then
      begin
           if Gdzie+i+1 < IloscLinii then inc(Gdzie);
      end;
Until Klawisz = #27;

FreeMem(Adresy,IloscLinii*SizeOf(Longint));
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure ZapiszEkran;
begin
     if BuforEkranu = nil then GetMem(BuforEkranu,ScreenHeight*ScreenWidth*2);
     Move(Ptr(SegB800,0)^,BuforEkranu^,ScreenWidth*ScreenHeight*2);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure OdtworzEkran;
begin
if not(BuforEkranu = nil) then
begin
     Move(BuforEkranu^,Ptr(SegB800,0)^,ScreenWidth*ScreenHeight*2);
{     FreeMem(BuforEkranu,25*80*2);}
end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function Trim(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] {<}= ' ') do Inc(I);
  if I > L then Trim := '' else
  begin
    while S[L] {<}= ' ' do Dec(L);
    Trim := Copy(S, I, L - I + 1);
  end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function TrimLeft(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] {<}= ' ') do Inc(I);
  TrimLeft := Copy(S, I, Maxint);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function TrimRight(const S: string): string;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] {<}= ' ') do Dec(I);
  TrimRight := Copy(S, 1, I);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function SegmentVideo : Word;
begin
{$IFNDEF DPMI}
  If Mem[$0000:$0449] = 7 Then SegmentVideo := $B000
  Else SegmentVideo := $B800;
{$ELSE}
  SegmentVideo := SegB800;
{$ENDIF}
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
FUNCTION WildComp(wild,name:string):boolean;
BEGIN
   WildComp:=FALSE;
   if name = '' then exit;
   CASE wild[1] of
      '*' : BEGIN
              if name[1]='.' then exit;
              if length(wild)=1 then WildComp:=TRUE;
              if (length(wild) > 1) and (wild[2]='.') and (length(name) > 0)
              then WildComp:=WildComp(copy(wild,3,length(wild)-2),
                   copy(name,pos('.',name)+1,length(name)-pos('.',name)));
            END;

       '?': BEGIN
              if ord(wild[0])=1
                 then WildComp:=TRUE
                 else WildComp:=WildComp(copy(wild,2,length(wild)-1),
                                         copy(name,2,length(name)-1));
            END;

       ELSE if name[1] = wild[1]
                 then if length(wild) > 1
                      then WildComp:=WildComp(copy(wild,2,length(wild)-1),
                                              copy(name,2,length(name)-1))
                      else if (length(name)=1)
                           and (length(wild)=1)
                           then WildComp:=TRUE
                 else WildComp:=FALSE;
   END;
END;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function KastracjaPliku(plik:String;Gdzie:Longint):Byte;
begin
     FillChar(KastracjaNazwa,13,#0);
     Move(Ptr(Seg(Plik),Ofs(Plik)+1)^,KastracjaNazwa,Length(Plik));
     asm;
	mov	dx,offset KastracjaNazwa
	mov	al,2
	mov	ah,3dh
	int	21h
	jnc	@PlikOtwarty
        mov     ax,1
        jmp     @Koniec
     @PlikOtwarty:
	mov	KastracjaUchwyt,ax

	mov	ah,42h
	mov	bx,KastracjaUchwyt
	mov	al,0
	mov	cx,word ptr [gdzie+2]
	mov	dx,word ptr [gdzie]
	int	21h
	jnc	@UstawilemWskaznik
        mov     ax,2
        jmp     @Koniec
     @UstawilemWskaznik:

	mov	ah,40h
	mov	bx,KastracjaUchwyt
	mov	cx,0
	mov	dx,offset KastracjaUchwyt
	int	21h
        jnc     @UcialemPlik
        mov     ax,3
        jmp     @Koniec
     @UcialemPlik:

	mov	ah,0dh
	int	21h

	mov	bx,KastracjaUchwyt
	mov	ah,3eh
	int	21h
	jnc	@ZamknalemPlik
        mov     ax,4
        jmp     @Koniec
     @ZamknalemPlik:

     @Koniec:
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function Potega(Podstawa:Word; Wykladnik:Byte):LongInt;assembler;
Asm
   mov ax,1
   xor dx,dx
   mov cl,Wykladnik
   xor ch,ch
   cmp cx,0
   jz @Ende
@repeat:
   mul Podstawa
   loop @repeat
@Ende:
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function Int2Str(I:longint):String;
Var s:String;
Begin
     Str(i,s);
     Int2Str:=s;
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function Str2Int(s:String):Longint;
Var i,Code:Integer;
Begin
     Val(s,i,Code);
     Str2Int:=i;
End;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function dec2bin(w:word):string;
var   waga:word;
      str:string[16];
      i:byte;
begin
     str:='0000000000000000';
     i:=16;
     repeat
           dec(i);
           waga:=1 shl i;
           if w and waga <> 0 then str[16-i]:='1'
     until i=0;
     dec2bin:=str
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function bin2dec(str:string):word;
var waga,sum:word;
    i:byte;
begin
     i:=0;
     sum:=0;
     repeat
           inc(i);
           waga:=1 shl (16-i);
           sum:=sum+(ord(str[i])-48)*waga
     until i=16;
     bin2dec:=sum
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function dec2hexb(w:byte):string;
const znak:array[0..15] of char
=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var s:string;
begin
     s:='00';
     s[1]:=znak[(w and $00F0) shr 4];
     s[2]:=znak[w and $000F];
     dec2hexb:=s
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function dec2hexw(w:word):string;
const znak:array[0..15] of char
=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var s:string;
begin
     s:='0000';
     s[1]:=znak[(w and $F000) shr 12];
     s[2]:=znak[(w and $0F00) shr 8];
     s[3]:=znak[(w and $00F0) shr 4];
     s[4]:=znak[w and $000F];
     dec2hexw:=s
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function dec2hexl(w:LongInt):string;
const znak:array[0..15] of char
=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var s:string;
begin
     s:='00000000';
     s[1]:=znak[(w and $F0000000) shr 28];
     s[2]:=znak[(w and $0F000000) shr 24];
     s[3]:=znak[(w and $00F00000) shr 20];
     s[4]:=znak[(w and $000F0000) shr 16];
     s[5]:=znak[(w and $0000F000) shr 12];
     s[6]:=znak[(w and $00000F00) shr 8];
     s[7]:=znak[(w and $000000F0) shr 4];
     s[8]:=znak[ w and $0000000F];
     dec2hexl:=s
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function hex2decw(s:string):word;
const znak:array[0..15] of char
=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var w,waga:word;
    k:integer;
    c:byte;
begin
     w:=0;
     for c:=4 downto 1 do
         begin
          k:=-1;
          repeat inc(k) until (k>15)or(s[c]=znak[k]);
          waga:=1 shl ((4-c)*4);
          if k<16 then w:=w+k*waga
         end;
     hex2decw:=w
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function hex2decl(s:string):Longint;
const znak:array[0..15] of char
=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var w:longint;
    i:byte;
    j:byte;
    waga:longint;
begin
     w:=0;
     for i := 8 downto 1 do
     begin
        waga := 1;
        for j := 1 to 8-i do waga := waga * $10;
        w := w+waga*(Pos(s[i],znak)-1);
     end;
     hex2decl := w;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function Min(wartosc1,wartosc2:longint):longint;
begin
     Min := wartosc1;
     if wartosc2 < wartosc1 then Min := Wartosc2;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function Max(wartosc1,wartosc2:longint):longint;
begin
     Max := wartosc1;
     if wartosc2 > wartosc1 then Max := Wartosc2;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure LoadUserFont(Bufor:Pointer;BajtowNaFonta:Byte);
var Reg:Registers;
begin
  Reg.AH := $11;
  Reg.AL := $10;
  Reg.ES := Seg(Bufor^);
  Reg.BP := Ofs(Bufor^);
  Reg.BH := BajtowNaFonta;
  Reg.BL := 0;
  Reg.CX := 256;
  Reg.DX := 0;
  Intr($10, Reg);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure Sweap(Jak:Byte;Delej:Word);
var Bak:array[0..80] of Word;
    Znak:Word;
    Kolor,Bajt:Byte;
    i,j:word;
begin
     case Jak of
       SwpToRight:
       begin
            for j := 0 to ScreenWidth-1 do
            begin
                 for i := 0 to ScreenHeight-1 do
                 begin
                      Znak := MemW[SegB800:(ScreenWidth*i+j)*2];
                      Bak[i] := Znak;
                      Kolor := Hi(Znak);
                      Bajt := Ord(UpCase(Char(Lo(Znak))));

{                      Kolor := kolor or $08;}
                      Kolor := White;

                      Znak := Kolor*$100 + Bajt;
                      MemW[SegB800:(ScreenWidth*i+j)*2] := Znak;
                 end;
                 MyDelay(Delej);
                 for i := 0 to ScreenHeight-1 do
                     MemW[SegB800:(ScreenWidth*i+j)*2] := Bak[i];
            end;
       end; {SwpToRight}
       SwpToLeft:
       begin
            for j := ScreenWidth-1 downto 0 do
            begin
                 for i := 0 to ScreenHeight-1 do
                 begin
                      Znak := MemW[SegB800:(ScreenWidth*i+j)*2];
                      Bak[i] := Znak;
                      Kolor := Hi(Znak);
                      Bajt := Ord(UpCase(Char(Lo(Znak))));

{                      Kolor := kolor or $08;}
                      Kolor := White;

                      Znak := Kolor*$100 + Bajt;
                      MemW[SegB800:(ScreenWidth*i+j)*2] := Znak;
                 end;
                 MyDelay(Delej);
                 for i := 0 to ScreenHeight-1 do
                     MemW[SegB800:(ScreenWidth*i+j)*2] := Bak[i];
            end;
       end; {SwpToLeft}
       SwpToBottom:
       begin
            for i := 0 to ScreenHeight-1 do
            begin
                 for j := 0 to ScreenWidth-1 do
                 begin
                      Znak := MemW[SegB800:(ScreenWidth*i+j)*2];
                      Bak[j] := Znak;
                      Kolor := Hi(Znak);
                      Bajt := Ord(UpCase(Char(Lo(Znak))));

{                      Kolor := kolor or $08;}
                      Kolor := White;

                      Znak := Kolor*$100 + Bajt;
                      MemW[SegB800:(ScreenWidth*i+j)*2] := Znak;
                 end;
                 MyDelay(Delej);
                 for j := 0 to ScreenWidth-1 do
                     MemW[SegB800:(ScreenWidth*i+j)*2] := Bak[j];
            end;
       end; {SwpToBottom}
       SwpToTop:
       begin
            for i := ScreenHeight-1 downto 0 do
            begin
                 for j := 0 to ScreenWidth-1 do
                 begin
                      Znak := MemW[SegB800:(ScreenWidth*i+j)*2];
                      Bak[j] := Znak;
                      Kolor := Hi(Znak);
                      Bajt := Ord(UpCase(Char(Lo(Znak))));

{                      Kolor := kolor or $08;}
                      Kolor := White;

                      Znak := Kolor*$100 + Bajt;
                      MemW[SegB800:(ScreenWidth*i+j)*2] := Znak;
                 end;
                 MyDelay(Delej);
                 for j := 0 to ScreenWidth-1 do
                     MemW[SegB800:(ScreenWidth*i+j)*2] := Bak[j];
            end;
       end; {SwpToTop}
     end; {case}


end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function Select(Ch:Char;Low,Hi:Byte):boolean;
begin
     if (Ord(Ch) >= Low) and (Ord(Ch) <= Hi)
        then Select := true
        else Select := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsLower(Ch:Char):boolean;
begin
     if Select(Ch,ord('a'),ord('z'))
        then IsLower := true
        else IsLower := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsUpper(Ch:Char):boolean;
begin
     If Select(Ch,ord('A'),ord('Z'))
        then IsUpper := true
        else IsUpper := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsAlpha(Ch:Char):boolean;
begin
     If IsLower(Ch) or IsUpper(Ch)
        then IsAlpha := true
        else IsAlpha := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsDigit(Ch:Char):boolean;
begin
     if Select(Ch,ord('0'),ord('9'))
        then IsDigit := true
        else IsDigit := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsAlnum(Ch:Char):boolean;
begin
     if IsAlpha(Ch) or IsDigit(Ch) or (Ch = ' ')
     then isAlnum := true
     else IsAlnum := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsAscii(Ch:Char):boolean;
begin
     If Select(Ch,0,127)
        then IsAscii := true
        else IsAscii := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsControl(Ch:Char):boolean;
begin
     if Select(Ch,0,31) or(ord(Ch) = 127)
     then  IsControl := true
     else IsControl := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsGraph(Ch:Char):boolean;
begin
     if Select(Ch,33,126) or Select(Ch,128,254)
        then IsGraph:= true
        else IsGraph:= false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsPrint(Ch:Char):boolean;
begin
     if IsGraph(Ch) or (Ch = ' ')
        then IsPrint := true
        else IsPrint := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsBlank(Ch:Char):boolean;
begin
     if (Ch = ' ') or (Ch = Chr(09)) or (Ch = Chr(10)) or
        (Ch = Chr(13)) or (Ch = Chr(12)) or (Ch = Chr(05))
        then IsBlank := true
        else IsBlank := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsPunct(Ch:Char):boolean;
begin
     if IsControl(Ch) or IsBlank(Ch)
        then IsPunct := true
        else IsPunct := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsDigitH(Ch:Char):boolean;
begin
     if IsDigit(Ch) or Select(Ch,ord('A'),ord('F'))
        then IsDigitH := true
        else IsDigitH := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function IsExtend(Ch:Char):boolean;
begin
     if Select(Ch,128,255)
        then IsExtend := true
        else IsExtend := false;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure DisplayCharWithClippingAndAttrib(x,y:integer;znak:char;Atrybut:Byte);
var x1,y1:integer;
begin
     x1 := ScreenWidth-1;
     y1 := ScreenHeight-1;
     if (x >= 0) and (x <= x1) and (y >= 0) and (y <= y1)
{     if (x in [0..79]) and (y in [0..49])}
        then MemW[SegB800:(y*ScreenWidth+x)*2] := ord(znak)+$100*Atrybut;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure PutPixelToBuffer(var buf:Pointer;x,y:Integer;pix:byte);
var kod:Word;
begin
     if Buf = nil then Exit;
     if pix in [0,32] then exit;
     kod := Pixel2Text[Pix];
     Byte(Pointer(Longint(Buf)+(y*ScreenWidth+x)*2)^) := Lo(Kod);
     Byte(Pointer(Longint(Buf)+(y*ScreenWidth+x)*2+1)^) := Hi(Kod);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure FlushDisk;
begin
     asm;
         mov ah,0dh
         int 21h
     end;
end;

{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function LosowyZnakPoziomy:Char;
var x:integer;
begin
LosowyZnakPoziomy := 'Ä';
x := Random(7);
if x = 2 then LosowyZnakPoziomy := 'ú'
   else if x = 6 then LosowyZnakPoziomy := '‚'
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function LosowyZnakPionowy:Char;
var x:integer;
begin
LosowyZnakPionowy := '³';
x := Random(7);
if x = 2 then LosowyZnakPionowy := 'ú'
   else if x = 6 then LosowyZnakPionowy := 'ƒ'
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function bin2decB(str:string):word;
var waga,sum:word;
    i:byte;
begin
     i:=0;
     sum:=0;
     repeat
           inc(i);
           waga:=1 shl (8-i);
           sum:=sum+(ord(str[i])-48)*waga
     until i=8;
     bin2decB:=sum
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function Kolor(Znak,Tlo:Byte):Byte;
begin
     Kolor := (Tlo shl 4) or znak;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure PrintText(X,Y,Color:integer;Buf:string);
var i:byte;
begin
     for i := 1 to ord(buf[0]) do
     begin
          if x+i-1 > 79 then exit;
          Mem[SegB800:(y*80+x+i-1)*2] := ord(Buf[i]);
          Mem[SegB800:(y*80+x+i-1)*2+1] := Color;
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure TextWindow(X,Y,LenX,LenY,C,TitleC:Integer;Title:string);
var i,j:byte;
    Obcinamy:Boolean;
    MaxX:Byte;
begin
     Obcinamy := false;
     maxx := min(x+lenx-1,79);
     if maxx <> x+lenx-1 then obcinamy := true;
     for i := x to maxx do
         for j := y to y+LenY-1 do
             MemW[SegB800:(j*80+i)*2] := ord(' ')+$100*Byte(c);
     For i := x to maxx do
     begin
          MemW[SegB800:((j)*80+i)*2] := ord(ramkaznaki4[1])+$100*Byte(c);
          MemW[SegB800:((j-leny+1)*80+i)*2] := ord(ramkaznaki4[5])+$100*Byte(c);
     end;
     For i := y to y+leny-1 do
     begin
          if not obcinamy then MemW[SegB800:(i*80+x+lenx-1)*2] := ord(ramkaznaki4[3])+$100*Byte(c);
          MemW[SegB800:(i*80+x)*2] := ord(ramkaznaki4[3])+$100*Byte(c);
     end;
     MemW[SegB800:(y*80+(x))*2] := ord(ramkaznaki4[0])+$100*Byte(c);
     MemW[SegB800:((y+leny-1)*80+x)*2] := ord(ramkaznaki4[4])+$100*Byte(c);
     if Not obcinamy then
     begin
          MemW[SegB800:(y*80+(x)+lenx-1)*2] := ord(ramkaznaki4[2])+$100*Byte(c);
          MemW[SegB800:((y+leny-1)*80+x+lenx-1)*2] := ord(ramkaznaki4[6])+$100*Byte(c);
     end;

     PrintText(x+(lenx - ord(title[0])) div 2,y,TitleC,Title);
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure TextBar(X,Y,LenX,LenY,Color:integer;Ch:char);
var i,j:byte;
    maxx:byte;
begin
     maxx := Min(79,x+LenX-1);
     for i := x to MaxX do
         for j := y to y+Leny-1 do
         begin
                Mem[SegB800:(j*80+i)*2] := Ord(Ch);
                Mem[SegB800:(j*80+i)*2+1] := Color;
         end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure PostawKursorXY(x,y:byte); assembler;
asm;
    push   si
    push   di
    mov    ah,02
    xor    bh,bh
    mov    dh,y
    mov    dl,x
    int    10h
    pop    di
    pop    si
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{function InputText(X,Y,Len:integer;var St:string):integer;
var Kolor:byte;
    PierwszyZnakOkienka:Byte;
    kl:Word;
    PozycjaWOkienku:Byte;
    dispst:string;
begin
     InputText := 0;
     PierwszyZnakOkienka := 1;
     PozycjaWOkienku := 0;
     Kolor := Mem[SegB800:(y*80+x)*2+1];
     TextBar(x,y,len,1,Kolor,' ');
     kl := 0;
     While not ((kl = kbEnter) or (kl = kbEsc)) do
     begin
          if PierwszyZnakOkienka+len > ord(st[0])
             then dispst := st + ' '
             else dispst := st;
          PrintText(X,Y,kolor,Copy(dispst,PierwszyZnakOkienka,len));
          PostawKursorXY(x+PozycjaWOkienku,y);
          kl := MyReadKey;

          if kl = kbBack then
          begin
               Delete(st,PozycjaWOkienku+PierwszyZnakOkienka-1,1);
               if PozycjaWOkienku > 0
                  then Dec(PozycjaWOkienku)
                  else if PierwszyZnakOkienka > 1
                          then Dec(PierwszyZnakOkienka);
               Continue;
          end;

          if (kl = kbEsc) or (kl = kbEnter) then Continue;


          case kl of
               kbLeft: begin
                            if PozycjaWOkienku > 0
                               then Dec(PozycjaWOkienku)
                               else if PierwszyZnakOkienka > 1
                                       then Dec(PierwszyZnakOkienka);
                       end;
               kbRight:begin
                            if PozycjaWOkienku < Len-1
                               then Inc(PozycjaWOkienku)
                               else if PierwszyZnakOkienka+len-1 < ord(st[0])
                                       then Inc(PierwszyZnakOkienka);
                       end;
               kbHome:begin
                           PozycjaWOkienku := 0;
                           PierwszyZnakOkienka := 1;
                      end;
               kbEnd:begin
                           PozycjaWOkienku := 0;
                           if ord(st[0]) >= len then
                           begin
                                PierwszyZnakOkienka := ord(st[0])-len+2;
                                PozycjaWOkienku := len-1;
                           end else
                           begin
                                PozycjaWOkienku := ord(st[0]);
                           end;
                      end;
               kbDel: begin
                           Delete(st,PozycjaWOkienku+PierwszyZnakOkienka,1);
                      end;
                      else
                      if hi(kl) = 0 then
                         begin
                              Insert(Chr(Lo(kl)),st,PozycjaWOkienku+PierwszyZnakOkienka);
                              if PozycjaWOkienku < Len-1
                                 then Inc(PozycjaWOkienku)
                                 else if PierwszyZnakOkienka+len-1 < 255
                                         then Inc(PierwszyZnakOkienka);
                         end;
          end; {case}
{     end; {while..do}
{     if kl = kbEnter then InputText := Ord(st[0]);
     if kl=kbEsc then InputText := -1;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{function InputTextColored(X,Y,Len:integer;var St:string;Kolor:Byte):integer;
var PierwszyZnakOkienka:Byte;
    kl:Word;
    PozycjaWOkienku:Byte;
    dispst:string;
    JuzBylJakisKlawisz:Boolean;
begin
     InputTextColored := 0;
     JuzBylJakisKlawisz := False;
     PierwszyZnakOkienka := 1;
     PozycjaWOkienku := 0;
     TextBar(x,y,len,1,Kolor,' ');
     kl := 0;
     While not ((kl = kbEnter) or (kl = kbEsc)) do
     begin
          if PierwszyZnakOkienka+len > ord(st[0])
             then dispst := st + ' '
             else dispst := st;
          TextBar(x,y,len,1,kolor,' ');
          PrintText(X,Y,kolor,Copy(dispst,PierwszyZnakOkienka,len));
          PostawKursorXY(x+PozycjaWOkienku,y);
          kl := MyReadKey;

          if kl = kbBack then
          begin
               JuzBylJakisKlawisz := True;
               Delete(st,PozycjaWOkienku+PierwszyZnakOkienka-1,1);
               if PozycjaWOkienku > 0
                  then Dec(PozycjaWOkienku)
                  else if PierwszyZnakOkienka > 1
                          then Dec(PierwszyZnakOkienka);
               Continue;
          end;

          if (kl = kbEsc) or (kl = kbEnter) then Continue;

          case kl of
               kbleft: begin
                            JuzBylJakisKlawisz := True;
                            if PozycjaWOkienku > 0
                               then Dec(PozycjaWOkienku)
                               else if PierwszyZnakOkienka > 1
                                       then Dec(PierwszyZnakOkienka);
                       end;
               kbright:begin
                            JuzBylJakisKlawisz := True;
                            if PozycjaWOkienku < Len-1
                               then Inc(PozycjaWOkienku)
                               else if PierwszyZnakOkienka+len-1 < ord(st[0])
                                       then Inc(PierwszyZnakOkienka);
                       end;
                kbhome:begin
                            JuzBylJakisKlawisz := True;
                            PozycjaWOkienku := 0;
                            PierwszyZnakOkienka := 1;
                       end;
                 kbend:begin
                            JuzBylJakisKlawisz := True;
                            PozycjaWOkienku := 0;
                            if ord(st[0]) >= len then
                            begin
                                 PierwszyZnakOkienka := ord(st[0])-len+2;
                                 PozycjaWOkienku := len-1;
                            end else
                            begin
                                 PozycjaWOkienku := ord(st[0]);
                            end;
                       end;
                 kbDel:begin
                            JuzBylJakisKlawisz := True;
                            Delete(st,PozycjaWOkienku+PierwszyZnakOkienka,1);
                       end;
                       else
                       if hi(kl) = 0 then
                          begin
                               if (not JuzBylJakisKlawisz) then
                               begin
                                    st := '';
                                    JuzBylJakisKlawisz := True;
                               end;
                               Insert(chr(lo(kl)),st,PozycjaWOkienku+PierwszyZnakOkienka);
                               if PozycjaWOkienku < Len-1
                                  then Inc(PozycjaWOkienku)
                                  else if PierwszyZnakOkienka+len-1 < 255
                                          then Inc(PierwszyZnakOkienka);
                          end;
          end; {case}
{     end; {while..do}
{     if kl = kbEnter then InputTextColored := Ord(st[0]);
     if kl=kbEsc then InputTextColored := -1;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function Key:integer; assembler;
asm;
    xor    ah,ah
    int    16h
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure ZamienZnaki(var S:string;co,naco:byte);assembler;
asm;
    push  es
    push  si
    push  cx

    mov   si,word ptr [s+2]
    mov   es,si
    mov   si,word ptr [s]
    xor   cx,cx
    mov   cl,byte ptr es:[si]

@Petla:
    inc   si
    mov   al,co
    cmp   byte ptr es:[si],al
    jne   @Dalej

    mov   al,naco
    mov   byte ptr es:[si],al
@Dalej:
    loop  @petla
    pop   cx
    pop   si
    pop   es
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{procedure SaveScreen(x,y,x1,y1:byte; var scr:pointer);
var dl,i:byte;
begin
     if scr <> nil then exit;
     x1 := min(x1,79);
     y1 := min(y1,24);
     GetMem(scr,(x1-x+1)*(y1-y+1)*2);
     dl := (x1-x+1)*2;
{     if x+dl > 79 then dl := 79-x-dl;
     dl := dl * 2;}
{     for i := y to y1 do
     begin
          move(Ptr(SegB800,(i*80+x)*2)^,Pointer(LongInt(scr)+(i-1)*dl)^,dl);
     end;
end;}
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{procedure RestoreScreen(x,y,x1,y1:byte; var scr:pointer);
var dl,i:byte;
begin
     if scr = nil then exit;
     x1 := min(x1,79);
     y1 := min(y1,24);
     dl := (x1-x+1)*2;
{     if x+dl > 79 then dl := 79-x-dl;
     dl := dl * 2;}
{     for i := y to y1 do
     begin
          move(Pointer(LongInt(scr)+(i-1)*dl)^, Ptr(SegB800,(i*80+x)*2)^ ,dl);
     end;
     FreeMem(scr,(x1-x+1)*(y1-y+1)*2);
end;}
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure ClTextXYWithBk(x,y:Word;txt:string;Tlo:Byte);
var znak:byte;
    i:Word;
    Kolor:Byte;
    IleOdjac:Byte;
begin
     IleOdjac := 0;
     Kolor := 07;
     for i := 1 to ord(txt[0]) do begin
         znak := Ord(txt[i]);
         if znak in kolory
            then begin
                      Kolor := Ord(znak);
                      Inc(IleOdjac);
                 end
            else MemW[SegB800:(y*ScreenWidth+x+i-1-IleOdjac)*2] := Znak+$100*((tlo shl 4) or kolor);
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Procedure Shadow(x,y,x1,y1:Byte);
Var i: Integer;
    k:byte;
    Cien1,cien2:Boolean;
begin
     Cien1 := True; Cien2 := True;
     if x1+1 > 79 then
     begin
          Cien1 := False;
          cien2 := false;
     end else if x1+2 > 79 then cien2 := false;
     k := (Black shl 4) or DarkGray;
     for i := y+1 to y1 do
     begin
          if cien1 then Mem[SegB800:(i*80+x1+1)*2+1] := k;
          if cien2 then Mem[SegB800:(i*80+x1+2)*2+1] := k;
     end;
     if y1 <= 24 then
     begin
          for i := x+2 to min(x1,79) do
          begin
               Mem[SegB800:(y1*80+i)*2+1] := k;
          end;
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure Beep(x:word);
begin
     Sound(x);
     MyDelay(100);
     NoSound;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Var ZnakJakiPixel:Byte;

begin
CursorTop := 6;
CursorBottom := 7;
BuforEkranu := nil;
ScreenWidth := 80;
ScreenHeight := 25;
KursorWidzialny := True;

For ZnakJakiPixel:=0 To 255 Do       {Û²±°#@½Ý*;:+-,. }
Begin
     Case ZnakJakiPixel Mod 16 Of       {Char}   {Color}
          00:pixel2text[ZnakJakiPixel]:=ord(' ')+256*{ZnakJakiPixel}0;
          01:pixel2text[ZnakJakiPixel]:=ord('.')+256*{ZnakJakiPixel}1;
          02:pixel2text[ZnakJakiPixel]:=ord(',')+256*{ZnakJakiPixel}2;
          03:pixel2text[ZnakJakiPixel]:=ord('-')+256*{ZnakJakiPixel}3;
          04:pixel2text[ZnakJakiPixel]:=ord('+')+256*{ZnakJakiPixel}4;
          05:pixel2text[ZnakJakiPixel]:=ord(':')+256*{ZnakJakiPixel}5;
          06:pixel2text[ZnakJakiPixel]:=ord(';')+256*{ZnakJakiPixel}6;
          07:pixel2text[ZnakJakiPixel]:=ord('*')+256*{ZnakJakiPixel}7;
          08:pixel2text[ZnakJakiPixel]:=ord('Ý')+256*{ZnakJakiPixel}8;
          09:pixel2text[ZnakJakiPixel]:=ord('½')+256*{ZnakJakiPixel}9;
          10:pixel2text[ZnakJakiPixel]:=ord('@')+256*{ZnakJakiPixel}10;
          11:pixel2text[ZnakJakiPixel]:=ord('#')+256*{ZnakJakiPixel}11;
          12:pixel2text[ZnakJakiPixel]:=ord('°')+256*{ZnakJakiPixel}12;
          13:pixel2text[ZnakJakiPixel]:=ord('±')+256*{ZnakJakiPixel}13;
          14:pixel2text[ZnakJakiPixel]:=ord('²')+256*{ZnakJakiPixel}14;
          15:pixel2text[ZnakJakiPixel]:=ord('Û')+256*{ZnakJakiPixel}15;
{}
{          00:pixel2text[ZnakJakiPixel]:=ord(' ')+256*(ZnakJakiPixel div 16)+256*16*0;
          01:pixel2text[ZnakJakiPixel]:=ord('.')+256*(ZnakJakiPixel div 16)+256*16*0;
          02:pixel2text[ZnakJakiPixel]:=ord(',')+256*(ZnakJakiPixel div 16)+256*16*0;
          03:pixel2text[ZnakJakiPixel]:=ord('-')+256*(ZnakJakiPixel div 16)+256*16*0;
          04:pixel2text[ZnakJakiPixel]:=ord('+')+256*(ZnakJakiPixel div 16)+256*16*0;
          05:pixel2text[ZnakJakiPixel]:=ord(':')+256*(ZnakJakiPixel div 16)+256*16*0;
          06:pixel2text[ZnakJakiPixel]:=ord(';')+256*(ZnakJakiPixel div 16)+256*16*0;
          07:pixel2text[ZnakJakiPixel]:=ord('*')+256*(ZnakJakiPixel div 16)+256*16*0;
          08:pixel2text[ZnakJakiPixel]:=ord('Ý')+256*(ZnakJakiPixel div 16)+256*16*0;
          09:pixel2text[ZnakJakiPixel]:=ord('½')+256*(ZnakJakiPixel div 16)+256*16*0;
          10:pixel2text[ZnakJakiPixel]:=ord('@')+256*(ZnakJakiPixel div 16)+256*16*0;
          11:pixel2text[ZnakJakiPixel]:=ord('#')+256*(ZnakJakiPixel div 16)+256*16*0;
          12:pixel2text[ZnakJakiPixel]:=ord('°')+256*(ZnakJakiPixel div 14)+256*16*0;
          13:pixel2text[ZnakJakiPixel]:=ord('±')+256*(ZnakJakiPixel div 16)+256*16*0;
          14:pixel2text[ZnakJakiPixel]:=ord('²')+256*(ZnakJakiPixel div 16)+256*16*0;
          15:pixel2text[ZnakJakiPixel]:=ord('Û')+256*(ZnakJakiPixel div 16)+256*16*0;
{}
         End;
End;

end.
