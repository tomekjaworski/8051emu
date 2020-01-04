{{$A+,B-,D+,E+,F+,G+,I+,L+,N+,O-,P+,Q-,R-,S+,T-,V+,X+,Y+}
{{$M 65520,0,655360}
unit procki;
interface
uses Crt, Dos, Textoolz, MsgBox;

function dec2hexbH(w:byte):string;
function dec2hexwH(w:word):string;
Function Parzystosc(b:byte):Boolean;
function par(x:byte):Boolean;
function Dec2BinB(b:byte):string;
procedure Wymien(var w1, w2:byte);
Function Hex2DecB(x:String):byte;
function FileExists(FileName:String):boolean;
Function DajKatalogZNazwy(n:String):String;
Function DajNazweZNazwy(n:String):String;
Function DajRozszerzenieZNazwy(n:String):String;
function DajInitPath:String;
Function Konwersja32Norm(s:string;var Wynik:Longint):Boolean;
Function Konwersja8VO(s:string;var Wynik:Word):Boolean;
Function Bin2DecL(l:string):Longint;
function Token(sep: string; var s: string): string;
Function UsunRozszerzeniePliku(n:String):String;
Function UstawRozszerzenie(var n:string; r:String):String;

implementation

Function Bin2DecL(l:string):Longint;
var w :Longint;
    i:byte;
    waga:longint;
begin
     w := 0;
     waga := 1;
     for i := 32 downto 1 do
     begin
          if l[i] = '1' then Inc(w, waga);
          waga := waga shl 1;
     end;
     Bin2DecL := W;
end;

function dec2hexbH(w:byte):string;
const znak:array[0..15] of char
=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var s:string;
begin
     s:='00';
     s[1]:=znak[(w and $00F0) shr 4];
     s[2]:=znak[w and $000F];
     dec2hexbh:=s+'H';
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function dec2hexwH(w:word):string;
const znak:array[0..15] of char
=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var s:string;
begin
     s:='0000';
     s[1]:=znak[(w and $F000) shr 12];
     s[2]:=znak[(w and $0F00) shr 8];
     s[3]:=znak[(w and $00F0) shr 4];
     s[4]:=znak[w and $000F];
     dec2hexwh:=s+'H';
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function Parzystosc(b:byte):Boolean;
var w:byte;
begin
     w := 0;
     if b and 1 <> 0 then Inc(w);
     if b and 2 <> 0 then Inc(w);
     if b and 4 <> 0 then Inc(w);
     if b and 8 <> 0 then Inc(w);
     if b and 16 <> 0 then Inc(w);
     if b and 32 <> 0 then Inc(w);
     if b and 64 <> 0 then Inc(w);
     if b and 128 <> 0 then Inc(w);
     parzystosc := False;
     if w mod 2 = 0 then parzystosc := True;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function par(x:byte):Boolean; assembler;
asm;
    xor  bx, bx
    xor  ax, ax
    mov  bl, x
    clc
    mov  cx,8
@KolejnyBit:
    shl bl, 1
    jnc @Dalej
    inc ax
@dalej:
    loop @KolejnyBit

    mov  bx,2
    div  bl
    cmp  ah,1
    mov  ax, true
    je   @Koniec
    mov  ax, false

@koniec:
end;

{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function Dec2BinB(b:byte):string;
var wynik:string[8];
begin
     Wynik := '00000000';

     if b and 1 <> 0 then Wynik[8] := '1';
     if b and 2 <> 0 then Wynik[7] := '1';
     if b and 4 <> 0 then Wynik[6] := '1';
     if b and 8 <> 0 then Wynik[5] := '1';
     if b and 16 <> 0 then Wynik[4] := '1';
     if b and 32 <> 0 then Wynik[3] := '1';
     if b and 64 <> 0 then Wynik[2] := '1';
     if b and 128 <> 0 then Wynik[1] := '1';
     Dec2BinB := Wynik;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure Wymien(var w1, w2:byte);
var temp:byte;
begin
     temp := w1;
     w1 := w2;
     w2 := temp;
end;

{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function Hex2DecB(x:String):byte;
const Hex : array[0..15] of char = ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var p:byte;
begin
     p := $00;
     p := p or ((Pos(x[Ord(x[0])-1], hex)-1) shl 4);
     p := p or (Pos(x[Ord(x[0])], hex)-1);
     Hex2DecB := p;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function FileExists(FileName:String):boolean;
var F:file;
    s:Byte;
begin
 {$I-}
 Assign(F, FileName);
 s := FileMode;
 FileMode := 0;
 Reset(F);
 Close(F);
 {$I+}
 FileExists := (IOResult=0) and (FileName <> '');
 FileMode := s;
end;

Function DajKatalogZNazwy(n:String):String;
var kat:DirStr;
    naz:NameStr;
    roz:ExtStr;
begin
     fsplit(n,kat,naz,roz);
     DajKatalogZNazwy := kat;
end;

Function DajNazweZNazwy(n:String):String;
var kat:DirStr;
    naz:NameStr;
    roz:ExtStr;
begin
     fsplit(n,kat,naz,roz);
     DajNazweZNazwy := naz+roz;
end;

Function UsunRozszerzeniePliku(n:String):String;
var kat:DirStr;
    naz:NameStr;
    roz:ExtStr;
begin
     fsplit(n,kat,naz,roz);
     UsunRozszerzeniePliku := kat+naz;
end;

Function UstawRozszerzenie(var n:string; r:String):String;
var kat:DirStr;
    naz:NameStr;
    roz:ExtStr;
begin
     n := Trim(UpperCase(n));
     fsplit(n,kat,naz,roz);
     if r[1] <> '.' then r := '.'+r;
     r := Copy(r, 1, 4);
     n := kat+naz+r;
end;

Function DajRozszerzenieZNazwy(n:String):String;
var kat:DirStr;
    naz:NameStr;
    roz:ExtStr;
begin
     fsplit(n,kat,naz,roz);
     DajRozszerzenieZNazwy := roz;
end;

function DajInitPath:String;
var p:PathStr;
    d:DirStr;
    n:NameStr;
    e:ExtStr;
begin
     p := FExpand(paramStr(0));
     FSplit(p,d,n,e);
     DajInitPath := d;
end;

Function Konwersja8VO(s:string;var Wynik:Word):Boolean;
var i:Word;
    gdzieblad:integer;
begin
     Wynik := 0;
     Konwersja8VO := False;
     s := UpperCase(Trim(s));
     for i := 1 to ord(s[0]) do
     begin
          if not (s[i] in['0'..'9','X','A'..'F','H','$']) then
          begin
               MessageBox('Bˆad konwersji liczby '''+s+''' przy '''+s[i]+'''', nil, mfError + mfOkButton);
               Exit;
          end;
     end;
     if (s[Ord(s[0])] = 'H') and (s[0] > #1)  then
     begin
          s := Copy(s,1,Length(s)-1);
          while ord(s[0]) < 8 do s := '0'+s;
          Wynik := Hex2DecL(s);
          Konwersja8Vo := True;
          Exit;
     end;
{     if (s[1] = '$') then
     begin
          s := Copy(s,2,Length(s));
          while ord(s[0]) < 8 do s := '0'+s;
          Wynik := Hex2Decl(s);
          Konwersja8VO := True;
          Exit;
     end;}
     if (s[2] = 'X') and (s[1] = '0') and (s[0] > #1) then
     begin
          s := Copy(s,3,Length(s));
          while ord(s[0]) < 8 do s := '0'+s;
          Wynik := Hex2DecL(s);
          Konwersja8VO := True;
          Exit;
     end;
     if (s[Ord(s[0])] = 'B') and (s[0] > #1)  then
     begin
          s := Copy(s,1,Length(s)-1);
          while ord(s[0]) < 16 do s := '0'+s;
          Wynik := Bin2Dec(s);
          Konwersja8VO := True;
          Exit;
     end;
     val(s,i,gdzieblad);
     if gdzieblad <> 0 then
     begin
          MessageBox('Bˆad konwersji liczby '''+s+'''', nil, mfError+mfOKButton);
          Konwersja8VO := False;
          Exit;
     end;
     Wynik := i;
     Konwersja8VO := True;
end;

Function Konwersja32Norm(s:string;var Wynik:Longint):Boolean;
var i:longint;
    gdzieblad:integer;
begin
     Wynik := 0;
     Konwersja32Norm := False;
     s := UpperCase(Trim(s));
     for i := 1 to ord(s[0]) do
     begin
          if not (s[i] in['0'..'9','X','A'..'F','H','$']) then
          begin
{               Komunikat('Bˆ¥d','Bˆad konwersji liczby '''+s+''' przy '''+s[i]+'''',[poOk]);}
               Exit;
          end;
     end;
     if (s[Ord(s[0])] = 'H') and (s[0] > #1) then
     begin
          s := Copy(s,1,Length(s)-1);
          while ord(s[0]) < 8 do s := '0'+s;
          Wynik := Hex2DecL(s);
          Konwersja32Norm := True;
          Exit;
     end;
{     if (s[1] = '$') and (s[0] > #1) then
     begin
          s := Copy(s,2,Length(s));
          while ord(s[0]) < 8 do s := '0'+s;
          Wynik := Hex2Decl(s);
          Konwersja32Norm := True;
          Exit;
     end;}
     if (s[2] = 'X') and (s[0] > #1)  and (s[1] = '0') then
     begin
          s := Copy(s,3,Length(s));
          while ord(s[0]) < 8 do s := '0'+s;
          Wynik := Hex2DecL(s);
          Konwersja32Norm := True;
          Exit;
     end;
     if (s[Ord(s[0])] = 'B') and (s[0] > #1) then
     begin
          s := Copy(s,1,Length(s)-1);
          while ord(s[0]) < 32 do s := '0'+s;
          Wynik := Bin2DecL(s);
          Konwersja32Norm := True;
          Exit;
     end;
     val(s,i,gdzieblad);
     if gdzieblad <> 0 then
     begin
{          Komunikat('Bˆ¥d','Bˆad konwersji liczby '''+s+'''',[poOk]);}
          Konwersja32Norm := False;
          Exit;
     end;
     Wynik := i;
     Konwersja32Norm := True;
end;

function Token(sep: string; var s: string): string;
     function isoneof(c, s: string): Boolean;
     var
        iTmp: integer;
     begin
          isoneof := False;
          for iTmp := 1 to Length(s) do
          begin
              if c = Copy(s, iTmp, 1) then
              begin
                   isoneof := True;
                   Exit;
              end;
          end;
     end;
var
   c, t: string;
begin
     if s = '' then
     begin
          Token := s;
          Exit;
     end;
     c := Copy(s, 1, 1);
     while isoneof(c, sep) do
     begin
          s := Copy(s, 2, Length(s) - 1);
          c := Copy(s, 1, 1);
     end;
     t := '';
     while (not isoneof(c, sep)) and (s <> '') do
     begin
          t := t + c;
          s := Copy(s, 2, length(s)-1);
          c := Copy(s, 1, 1);
     end;
     Token := t;
end;

end.
