Unit Gramat; {Gramatyka kompilatora}
interface
uses Crt, Dos, Strings, Textoolz, Zmienne, Procki, Nazwy, Symb, Stale;
const tokens:array[1..5] of char = (' ',{'+','-','*','/','%','<','>','#',}','{,'!','@','.',{'$',}{'^','?','=','[','(',')',']'}
                                        ,'''','"',';');
const
     MaxKomplikacjaLinii = 64;


Type TNazwaDanej = array[1..MaxNazwaSymbolu+1] of char;
                                      {+1 na Chr(0) }
     PDana = ^TDana;
     TDana = record
              Nazwa:TNazwaDanej;
              Typ:TTypDanych;
              TypPamieci:TTypPamieci;
{              case Byte of
                 0:(Adres:Word);}
{                 1:(}Wartosc:Longint{);}
     end;
     TAdresy = array[1..60] of PDana;
     PAdresy = ^TAdresy;
     TParserStack = array[1..MaxKomplikacjaLinii] of string;
     PParserStack = ^TParserStack;

Function PierwszeSlowo(s:string):String;
Function DrugieSlowo(s:string):String;
Function UsunPierwszeSlowo(s:string):String;
procedure Parser(s:string);
{Function ZnajdzDana(n:TNazwaDanej):PDana;
procedure DajNazweDanej(Nazwa:String;var n:TNazwaDanej);}
Function ZnajdzStala(naz:String):PDana;
{procedure DajNazweStalej(Nazwa:String;var n:TNazwaDanej);}
function hex2decl(s:string):Longint;
function bin2dec(str:string;IlePozycji:Byte):longint;
{procedure DodajDana(Nazwa:String;Typ:TDataType;Gdzie:Word);}
procedure DodajStala(Nazwa:String;Typ:TTypDanych;Gdzie:Word;TypPamieci:TTypPamieci);

var ParserStack:PParserStack;
    ParserStackPtr:Word;
    ParserStackDummy:TParserStack;

implementation
uses k_zm;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
function bin2dec(str:string;IlePozycji:Byte):longint;
var sum:longint;
    waga:longint;
    i:byte;
begin
     Sum := 0; waga := 1;
     for i := IlePozycji downto 1 do
     begin
          Sum := sum + (Ord(str[i])-48)*waga;
          waga := waga * 2;
     end;
     Bin2Dec := Sum;
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
Function PierwszeSlowo(s:string):String;
var p:byte;
begin
     p := pos(' ',s);
     if p = 0 then
     begin
          PierwszeSlowo := s;
          Exit;
     end else
     begin
          PierwszeSlowo := Copy(s,1,p-1);
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function DrugieSlowo(s:string):String;
var p:byte;
begin
     p := pos(' ',s);
     if p = 0 then
     begin
          DrugieSlowo := '';
          Exit;
     end else
     begin
          s := Trim(Copy(s,p+1,length(s)));
          p := pos(' ',s);
          if p = 0 then
          begin
               DrugieSlowo := s;
               Exit;
          end else
          begin
               DrugieSlowo := Copy(s,1,p-1);
          end;
          DrugieSlowo := Copy(s,1,p-1);
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function UsunPierwszeSlowo(s:string):String;
var p:byte;
begin
     p := Pos(' ',s);
     if p = 0 then
     begin
          UsunPierwszeSlowo := '';
          exit;
     end else
     begin
          UsunPierwszeSlowo := Trim(Copy(s,p,length(s)));
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{procedure DajNazweDanej(Nazwa:String;var n:TNazwaDanej);
begin
     if Nazwa = ':' then
     begin
{          Blad(errNiewlasciwaNazwaDanej,Nazwa,'','');}
{     end;
     Nazwa := UpperCase(Nazwa);
     FillChar(n,SizeOf(TNazwaDanej),#0);
     if Ord(Nazwa[0]) > MaxNazwaSymbolu
        then Move(Nazwa[1],n,MaxNazwaSymbolu)
        else Move(Nazwa[1],n,Ord(Nazwa[0]));
end;}
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{Function ZnajdzDana(n:TNazwaDanej):PDana;
var i:word;
    NazwaZListy:TNazwaDanej;
    pt:PDana;
begin
     ZnajdzDana:= nil;
     if Ord(n[1]) = 0 then Exit;
     for i := 1 to IloscAdresow do
     begin
          NazwaZListy := PAdresy(Adresy)^[i]^.Nazwa;
          if strcomp(@n,@NazwaZListy) = 0 then
          begin
{               pt := PAdresy(Adresy)^[i];
               if pt^.TypPamieci = Typpamieci then
               begin}
{                    ZnajdzDana := PAdresy(Adresy)^[i];
                    Exit;
{               end;}
{          end;
     end;
end;}
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
{procedure DodajDana(Nazwa:String;Typ:TDataType;Gdzie:Word);
var ptr:PDana;
    dummy:pointer;
begin
     new(ptr);
     FillChar(Ptr^,SizeOf(TDana),#0);
     if Ord(Nazwa[0]) > MaxNazwaSymbolu
        then Move(Nazwa[1],ptr^.Nazwa,MaxNazwaSymbolu)
        else if Nazwa[Ord(Nazwa[0])]=':'
                then Move(Nazwa[1],Ptr^.Nazwa,Ord(Nazwa[0])-1)
                else Move(Nazwa[1],Ptr^.Nazwa,Ord(Nazwa[0]));
     Ptr^.Adres := Gdzie;
     Ptr^.Typ:=Typ;
     if IloscAdresow = 0 then
     begin
          Inc(IloscAdresow);
          GetMem(Adresy,SizeOf(PDana)*IloscAdresow);
          PAdresy(Adresy)^[1] := ptr;
     end else
     begin
          Inc(IloscAdresow);
          GetMem(Dummy,SizeOf(PDana)*IloscAdresow);
          move(Adresy^,Dummy^,SizeOf(PDana)*(IloscAdresow-1));
          FreeMem(Adresy,SizeOf(PDana)*(IloscAdresow-1));
          Adresy := Dummy;
          PAdresy(Adresy)^[IloscAdresow] := Ptr;
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure Parser(s:string);
var scan_ptr,item_count:integer;
    parse_more,collect_it,inc_before,Inc_after:boolean;
    more_char:boolean;
    scan_char,start_char,stop_char:char;
    next_char:char;
    i:byte;
begin

     ParserStackPtr := 0;
     for i := 1 to MaxKomplikacjaLinii do ParserStack^[i] := '';

     if s[0] <> #0 then
     begin
          scan_ptr := 1;
          parse_more := True;
          ParserStackPtr := 1;
          ParserStack^[1] := '';
          collect_it := false;
          inc_before := False;
          Inc_After := False;
     end else parse_more := false;

     while parse_more do
     begin
          scan_char := s[scan_ptr];
          if (pos(scan_char,tokens) = 0) and (scan_ptr <= ord(s[0]))
             then collect_it := true;
          if scan_ptr > ord(s[0]) then
          begin
               parse_more := false;
               scan_char := #0;
          end;
          if scan_char in [' ',#9] then
          begin
               {je¾eli znak to spacja, to sprawd«, czy element na stosie}
               {jest pusty. Jak nie, ustaw flage dodawania przed        }
              if ParserStack^[ParserStackPtr] <> '' then inc_before := True;
          end;
          if scan_char in [{'+','-','*','/','%','<','>',{'#',}',',{'!',}{'@',{'.',{'$',}{'^','?','=',}';'] then
          begin
               collect_it := true;

               if ParserStack^[ParserStackPtr][1] <> scan_char then
               begin
                    if ParserStack^[ParserStackPtr] <> '' then inc_before := true;
               end;

               if scan_ptr+1 <= Ord(s[0]) then next_char := s[scan_ptr+1]
                                                else next_char := #0;
               if (pos(next_char,tokens) = 0) and (next_char <> #0) then
               begin
                    inc_after := true;
               end;
          end;
          if scan_char in ['[','(','''','"'] then
          begin
               {jezeli znak jest ogranicznikiem tekstu, lub nawiasem, to sprawd«}
               {czy jest pusty element na stosie i sprawd« ilo˜† nawiasow       }
               {lub ogranicznikow (czy sa parzyste)                             }
               collect_it := false;
{               if '' <> ParserStack^[ParserStackPtr] then
               begin
                    inc(ParserStackPtr);
                    ParserStack^[ParserStackPtr] := '';
               end;
}
               start_char := scan_char;
               if scan_char = '('
                  then stop_char := ')'
                  else if scan_char = '['
                          then stop_char := ']'
                          else stop_char := scan_char;
               item_count := 0;
               more_char := True;

               while more_char do
               begin
                    ParserStack^[ParserStackPtr] := ParserStack^[ParserStackPtr] + scan_char;
                    if start_char <> stop_char then
                    begin
                         if scan_char=start_char
                            then inc(Item_Count)
                            else if scan_char = stop_char
                                    then dec(item_count);
                    end else
                    begin
                         if item_count > 0 then
                         begin
                              if scan_char = stop_char then Dec(Item_count);
                         end else item_count := 1;
                    end;
                    if (item_count = 0) or (ord(s[0]) < scan_ptr)
                       then more_char := false
                       else
                    begin
                         Inc(scan_ptr);
                         scan_char := s[scan_ptr];
                    end;
               end; {enddo}
               if scan_ptr > Ord(s[0]) then WriteLn('Przekroczono limit: ',s)
               else begin
                    next_char := s[scan_ptr+1];
                    if (pos(next_char,tokens) = 0) and (next_char <> #0)
                       then inc_after := true;
               end;
          end;{end case}

          if inc_before then
          begin
               inc(ParserStackPtr);
               ParserStack^[ParserStackPtr] := '';
               inc_before := false;
          end;
          if collect_it then
          begin
               ParserStack^[ParserStackPtr] := ParserStack^[ParserStackPtr] + scan_char;
               collect_it := false;
          end;
          if inc_after then
          begin
               inc(ParserStackPtr);
               ParserStack^[ParserStackPtr] := '';
               inc_after := false;
          end;
          inc(scan_ptr);
     end;

end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure DajNazweStalej(Nazwa:String;var n:TNazwaDanej);
begin
     Nazwa := UpperCase(Nazwa);
     FillChar(n,SizeOf(TNazwaDanej),#0);
     if Ord(Nazwa[0]) > MaxNazwaSymbolu
        then Move(Nazwa[1],n,MaxNazwaSymbolu)
        else if Nazwa[Ord(Nazwa[0])]=':'
                then Move(Nazwa[1],n,Ord(Nazwa[0])-1)
                else Move(Nazwa[1],n,Ord(Nazwa[0]));
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
Function ZnajdzStala(naz:String):PDana;
var i:word;
    NazwaZListy:TNazwaDanej;
    pt:PDana;
    n:TnazwaDanej;
begin
     dajnazweStalej(naz,n);
     ZnajdzStala:= nil;
     if Ord(n[1]) = 0 then Exit;
     for i := 1 to IloscStalych do
     begin
          NazwaZListy := PAdresy(ListaStalych)^[i]^.Nazwa;
          if strcomp(@n,@NazwaZListy) = 0 then
          begin
{               pt := PAdresy(Adresy)^[i];
               if pt^.TypPamieci = Typpamieci then
               begin}
                    ZnajdzStala := PAdresy(ListaStalych)^[i];
                    Exit;
{               end;}
          end;
     end;
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure DodajStala(Nazwa:String;Typ:TTypDanych;Gdzie:Word;TypPamieci:TTypPamieci);
var ptr:PDana;
    dummy:pointer;
begin
     new(ptr);
     FillChar(Ptr^,SizeOf(TDana),#0);
     if Ord(Nazwa[0]) > MaxNazwaSymbolu
        then Move(Nazwa[1],ptr^.Nazwa,MaxNazwaSymbolu)
        else if Nazwa[Ord(Nazwa[0])]=':'
                then Move(Nazwa[1],Ptr^.Nazwa,Ord(Nazwa[0])-1)
                else Move(Nazwa[1],Ptr^.Nazwa,Ord(Nazwa[0]));
{     Ptr^.Adres := Gdzie;}
     Ptr^.Wartosc := Gdzie;
     Ptr^.Typ:=Typ;
     Ptr^.TypPamieci := TypPamieci;
     if IloscStalych = 0 then
     begin
          Inc(IloscStalych);
          GetMem(ListaStalych, SizeOf(PDana)*IloscStalych);
          PAdresy(ListaStalych)^[1] := ptr;
     end else
     begin
          Inc(IloscStalych);
          GetMem(Dummy,SizeOf(PDana)*IloscStalych);
          move(ListaStalych^,Dummy^,SizeOf(PDana)*(IloscStalych-1));
          FreeMem(ListaStalych,SizeOf(PDana)*(IloscStalych-1));
          ListaStalych := Dummy;
          PAdresy(listaStalych)^[IloscStalych] := Ptr;
     end;
end;

end.