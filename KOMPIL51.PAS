{$A+,B-,D+,E+,F+,G+,I-,L+,N+,O+,P+,Q-,R-,S+,T-,V+,X+,Y+}
{$M 65520,0,655360}
{$IFDEF DPMI}
{$DEFINE DLL}
{$ENDIF}

{$IFDEF DLL}
library Kompil51;
{$ENDIF}
uses {UseHDeb, }Crt, Dos, Textoolz, K_Zm, Gramat, Procki, Zmienne, K_Procki,
     Strings, K_Typy, K_Errs, Nazwy, MyCalc, IntelHex, Objects,
     Inst8051, Stale, Views;

Const MaxStosInclude = 32;

Type TMiejsceBledu = (mbPreprocesor, mbPrzejscie1, mbPrzejscie2);

type TElementStosuInclude = record
      Uchwyt:Text;
      Nazwa:PString;
      NumerLinii:Word;
     end;

Type PStosInclude = ^TStosInclude;
     TStosInclude = record
       Stos:array[1..MaxStosInclude] of TElementStosuInclude;
       Wskaznik:Byte;
     end;

Type PSourceLine = ^TSourceLine;
     TSourceLine = record
        NumerPliku:Byte; {Numer pliku zrodlowego}
        NumerLinii:Word;
        Linia:String;
     end;
Type PMakro = ^TMakro;
     TMakro = record
        Wskaznik:Pointer;
        IloscLinii:Word;
        NumerPliku:Byte;
        NumerLinii:Word;
        Parametry:Array[1..MaxParametrowMakra] of String[20];
        Nazwa:String;
     end;

Type PTablica = ^TTablica;
     TTablica = object(TCollection)
       procedure Error(Code, Info: Integer); virtual;
     end;

Type PTablicaKodow = ^TTablicaKodow;
     TTablicaKodow = array[1..111] of TWpisWTablicyInstrukcji;

procedure TTablica.Error(Code, Info:Integer);
begin
end;

var TablicaKodow:PTablicaKodow;

Procedure WczytajTabliceKodow;
var f:file;
    DummyByte:Byte;

begin
     TablicaKodow := new(PTablicaKodow);
     assign(f, 'opcodes.dat');
     reset(f, 1);
     BlockRead(f, DummyByte, 1);
     if DummyByte <> 111 then
     begin
          {Bˆ¥d}
     end;
     BlockRead(f, TablicaKodow^, 111*SizeOf(TWpisWTablicyInstrukcji));
     close(f);
end;


var linia,Instr:string;
    PlikWe:String;
    PlikWy:String;
    PlikSym:String;
    Prg:PPamiecROM;
    PlikPrg:File;
{    KodZrodlowy:text;}
    Symb:Text;
    DummyTest:Text;
    i:longint;
    UsuwajJednostkiLeksykalne:Boolean;
    DummyWord:Word;
{    OldIP:Word;}
    maxav,memav:longint;
{    NazwaEtykiety:TNazwaDanej;}
{    AdresEtykiety:PDana;}
    DummyLong:Longint;
    WczytujKolejnaLinie:Boolean;
    ListaPlikow:PTablica;
    ListaLinii:PTablica;
    StosInclude:PStosInclude;
    KoniecKOmpilacji:Boolean;
    ElementStosuInclude:TElementStosuInclude;
    SourceLine:PSourceLine;
    nLinia:Word;
    MiejsceBledu:TMiejsceBledu;
    Wpis:TWpisWtablicyInstrukcji;
    NazwaInstrukcji:TNazwaInstrukcji;
{makra}
    ListaMakr:PTablica;
    JestemWMakrze:Boolean;
    IloscLiniiMakra:Word;
    LiniaWywolaniaMakra:Word;
    Makro, MakroSzukane:PMakro;
{genereacja kodu}
    ZgodnosczPar1, ZgodnoscZPar2, ZgodnoscZPar3:Boolean;
    ZnalazlemMnemonik:Boolean;
    DlugoscInstrukcji:Byte;
    NumerParametru:Byte;
{dw, db}
    OstatnioBylTekst:Boolean;
    Element:String;
{$I PR.PAS}

    label KolejnaLinia1, KolejnaLinia2;

Function ZnajdzMakro(Nazwa:String):PMakro;
var m:Word;
begin
     Znajdzmakro := nil;
     Nazwa := Trim(UpperCase(Nazwa));
     for m := 0 to ListaMakr^.Count-1 do
     begin
          if Nazwa = PMakro(ListaMakr^.Items^[m])^.Nazwa then
          begin
               ZnajdzMakro := ListaMakr^.Items^[m];
               Exit;
          end;
     end;
end;
{$ifdef DLL}
Procedure UruchomKompilator(var Wymiana:TWymianaZKompilatorem); export;
begin
     FillChar(Wymiana, SizeOf(TWymianaZKompilatorem), #0);
     Wymiana.OpisBledu := 'ssssssss';
     Wymiana.LiniaBledu := 6;
     WriteLn(SizeOf(TWymianaZKompilatorem));
     readln;
end;

exports UruchomKompilator index 1;
{$ENDIF}

begin
     {}
     Ustawienia := [pAllowMOVX];
     maxav := MaxAvail;
     MemAv := MemAvail;
     ClrScr;
     TextColor(Yellow);
     Write('Kompilator AT89CX051');
     TextColor(Cyan);
     Write(' Wersja 2.00 (c) 2001-2002 Tomasz Jaworski');
     TextColor(LightGray);
     WriteLn;
     {}
     PlikWe := 'TEST.asm';
     PlikWe := UpperCase(PlikWe);
     PlikWy := PlikWe; UstawRozszerzenie(PlikWy, 'BIN');
     PlikSym := PlikWy; UstawRozszerzenie(PlikSym, 'SYM');


     if not FileExists(PlikWe) then
     begin
          WriteLn('Brak pliku «r¢dˆowego ',PliKWe);
          halt;
     end;
     New(prg);
     FillChar(Prg^, SizeOf(TPamiecROM)-6, #0);
     WielkoscKodu := 0;
     IP := 0; {wskaznik instrukcji}
     JestBlad := False;
     KodBledu := 0;


     WczytujKolejnaLinie := True;
     {************************************************************}
     {************************************************************}
     {************************************************************}
     {************************************************************}
     {************************************************************}
     {************************************************************}

     ListaPlikow := New(PTablica, Init(5, 2));
     ListaLinii := New(PTablica, Init(50, 50));
     ListaMakr := New(PTablica, Init(5, 2));


     WriteLn('Inicjowanie standardowych staˆych');
     WstawStandardoweStale;
     New(ParserStack);
     New(StosInclude); StosInclude^.Wskaznik := 0;

     Inc(StosInclude^.Wskaznik);
     Assign(StosInclude^.Stos[1].Uchwyt, PlikWe);
     Reset(StosInclude^.Stos[1].Uchwyt);
     StosInclude^.Stos[1].Nazwa := NewStr(PlikWe);
     StosInclude^.Stos[1].NumerLinii := 0;
     ListaPlikow^.Insert(NewStr(PlikWe));

     WczytajTabliceKodow;

     WriteLn('Uruchamianie preprocesora...');

     KoniecKompilacji := False;
     JestemWMakrze := False;
     IloscLiniiMakra := 0;
     LiniaWywolaniaMakra := 0;
     MiejsceBledu := mbPreprocesor;

     while not KoniecKompilacji do
     begin
          if JestBlad then Break;

          if StosInclude^.Wskaznik = 0 then
          begin
               KoniecKompilacji := True;
               continue;
          end;
          if Eof(StosInclude^.Stos[StosInclude^.Wskaznik].Uchwyt) then
          begin
               ZdejmijZeStosuInclude(ElementStosuInclude);
               ZwolnijElementStosuInclude(ElementStosuInclude);
               Continue;
          end;

          if WczytujKolejnaLinie then
          begin
               ReadLn(StosInclude^.Stos[StosInclude^.Wskaznik].Uchwyt, Linia);
               Inc(StosInclude^.Stos[StosInclude^.Wskaznik].NumerLinii);

               Linia := TrimAll(Linia);
               If Linia = '' then Continue;
               if Linia[1] in [';', '*'] then Continue;
               {Tutaj ma miejsce ci©¾ka praca kompilatora, czyli...
                Analizator Syntaktyczny :>}
               Parser(Linia);

               For i := 1 to ParserStackPtr
                   do ParserStack^[i] := TrimAll(ParserStack^[i]);
               UsuwajJednostkiLeksykalne := false;

               For i := 1 to ParserStackPtr do
               begin
                    if ParserStack^[i] = ';' then UsuwajJednostkiLeksykalne := True;
                    if usuwajjednostkiLeksykalne then
                    begin
                         ParserStack^[i] := '';
                         Dec(parserStackPtr);
                    end;
               end;
          end;
          WczytujKolejnaLinie := True;
          {
          format linii:
                 ETYKIETA: MNEMONIK PAR1, PAR2, PAR3 ;KOMENTARZ
          }
          Instr := Uppercase(ParserStack^[1]);

          if (Instr = 'INCLUDE') then
          begin
               if not AlokujElementStosuInclude(ElementStosuInclude, ParserStack^[2])
                  then Continue;
               PolozNaStosInclude(ElementStosuInclude);
               ListaPlikow^.Insert(NewStr(ParserStack^[2]));
               Continue;
          end;

{          if (Instr = 'ENDM') or (Instr = 'MACEND') or (Instr = 'ENDMAC') then
          begin
               if not JestemWMakrze then
               begin
                    GenerujBlad(errMakroNieRozpoczete);
                    Continue;
               end;
               JestemWMakrze := False;
               Makro^.IloscLinii := IloscLiniiMakra;
          end;

          Instr := Uppercase(ParserStack^[2]);
          if (Instr = 'MACRO') then
          begin
               if JestemWMakrze then
               begin
                    GenerujBlad(errBrakKoncaMakra);
                    Continue;
               end;
               JestemWMakrze := True;
               IloscLiniiMakra := 0;
               Makro := AlokujMakro(StosInclude^.Wskaznik,
                                    StosInclude^.Stos[StosInclude^.Wskaznik].NumerLinii,
                                    0,
                                    UpperCase(ParserStack^[1]),
                                    nil);
               ListaMakr^.Insert(Makro);
               if (ParserStackPtr-1) div 2 > MaxParametrowMakra then
               begin
                    GenerujBlad(errZbytDuzoParametrowMakra);
                    Continue;
               end;
               for i := 1 to (ParserStackPtr - 1) div 2 do
               begin
                    Makro^.Parametry[i] := UpperCase(Trim(ParserStack^[(i-1)*2+3]));
               end;
          end;

}
          instr := '';

{          MakroSzukane := nil;
          if UpperCase(ParserStack^[2]) <> 'MACRO'
             then MakroSzukane := ZnajdzMakro(ParserStack^[1]);
          if Assigned(MakroSzukane) then
          begin
               WriteLn('gggg');
          end;
 }
          for i := 1 to ParserStackPtr do Instr := Instr+ParserStack^[i]+' ';
          SourceLine := AlokujLinie(StosInclude^.Wskaznik,
                                    StosInclude^.Stos[StosInclude^.Wskaznik].NumerLinii,
                                    Trim(Instr));
{          if JestemWMakrze and (IloscLiniiMakra = 0) then
          begin
               Makro^.Wskaznik := SourceLine;
          end;
          if JestemWMakrze then Inc(IloscLiniiMakra);}
          ListaLinii^.Insert(SourceLine);
     end; {preprocesor}
     ListaLinii^.Insert(AlokujLinie(0,0,''));
     if JestemWMakrze then GenerujBlad(errBrakKoncaMakra);

{****************************************************************}
 {**************************************************************}
  {************************************************************}

     if not JestBlad then
     begin
          WriteLn('Pierwsze przej˜cie kompilatora');
          MiejsceBledu := mbPrzejscie1;
     end;
     WczytujKolejnaLinie := True;

     for nLinia := 0 to ListaLinii^.Count-1 do
     begin
          if JestBlad then break;

          if WczytujKolejnaLinie then
          begin

               SourceLine := PSourceLine(ListaLinii^.Items^[nLinia]);
               Linia := SourceLine^.Linia;
               {Tutaj ma miejsce ci©¾ka praca kompilatora, czyli...
                Analizator Syntaktyczny :>}
{          WriteLn(Linia);}

               Parser(Linia);

               For i := 1 to ParserStackPtr
                   do ParserStack^[i] := TrimAll(ParserStack^[i]);
               UsuwajJednostkiLeksykalne := false;
          end {if WczytujKolejneLinie}
          else Dec(nLinia);
          WczytujKolejnaLinie := True;
          Instr := UpperCase(ParserStack^[1]);

          if Instr[ord(Instr[0])] = ':' then
          begin
               if ZnajdzStala(Instr) <> nil then
               begin
                    GenerujBlad(errTakaEtykietaJuzIstnieje);
                    Continue;
               end;
               DodajStala(Instr, tdWord, IP, tpRom);
               for i := 2 to MaxKomplikacjaLinii do
                   ParserStack^[i-1] := ParserStack^[i];
               Dec(ParserStackPtr);
               WczytujKolejnaLinie := False;
               Continue;
          end;

{          if (Instr = 'ENDM') or (Instr = 'MACEND') or (Instr = 'ENDMAC') then
          begin
               JestemWMakrze := False;
               Continue;
          end;

          if (UpperCase(ParserStack^[2]) = 'MACRO') then
          begin
               JestemWMakrze := True;
               Continue;
          end;

          if JestemWMakrze then Continue;
}
          if Instr = 'ORG' then
          begin
               if not KalkulujWartosc(ParserStack^[2], DummyWord) then
               begin
                    GenerujBlad(errNiewlasciwaWartosc);
                    Continue;
               end;
               if DummyWord < IP then
               begin
                    GenerujBlad(errCofniecieAdresow);
                    Continue;
               end;
               IP := DummyWord;
               Continue;
          end;

          if (Instr = 'OUTPUTFILE') then
          begin
               if FileExists(ParserStack^[2]) then
               begin
                    PlikWy := UpperCase(ParserStack^[2]);
                    Continue;
               end else
               begin
                    Assign(DummyTest, ParserStack^[2]);
                    ReWrite(Dummytest);
                    if IOResult = 0 then
                    begin
                         PlikWy := UpperCase(ParserStack^[2]);
                         Close(DummyTest);
                    end else generujBlad(errNiewlasciwaNazwaPliku);
                    Continue;
               end;
          end;
          if (Instr = 'SYMBOLFILE') then
          begin
               if FileExists(ParserStack^[2]) then
               begin
                    PlikSym := UpperCase(ParserStack^[2]);
                    Continue;
               end else
               begin
                    Assign(DummyTest, ParserStack^[2]);
                    ReWrite(Dummytest);
                    if IOResult = 0 then
                    begin
                         PlikSym := UpperCase(ParserStack^[2]);
                         Close(DummyTest);
                    end else generujBlad(errNiewlasciwaNazwaPliku);
                    Continue;
               end;
          end;
          if (Instr = 'NOMATH') then
          begin
               NieWykonujPrzeliczen := True;
               Continue;
          end;
          if (Instr = 'INCLUDE') then
          begin
               continue;
          end;
          if (Instr = 'CPU') then
          begin
               Instr := Uppercase(ParserStack^[2]);
               if Instr = 'TYPE' then
               begin
                    Instr := UpperCase(ParserStack^[3]);
                    if (Instr = '2051') or (Instr = '20') or (Instr = '2KB') then
                    begin
                         TypProcka := tp2051;
                         Continue;
                    end;
                    if (Instr = '4051') or (Instr = '40') or (Instr = '4KB') then
                    begin
                         TypProcka := tp4051;
                         Continue;
                    end;
                    if (Instr = '1051') or (Instr = '10') or (Instr = '1KB') then
                    begin
                         TypProcka := tp1051;
                         Continue;
                    end;
                    generujBlad(errNiewlasciwyTypProcka);
                    Continue;
               end;
               if Instr = 'CRYSTAL' then
               begin
                    GenerujBlad(errBrakImplementacji);
                    Continue;
               end;
               generujBlad(errNiewlasciwaDyrektywaKompilatora);
               Continue;
          end; {CPU}

          {stala      equ    wartosc}
          if (UpperCase(ParserStack^[2]) = 'RAMEQU') or
             (UpperCase(ParserStack^[2]) = 'EQUEAM') then
          begin
               if KalkulujWartosc(ParserStack^[3], DummyWord) then
               begin
                    if ZnajdzStala(Instr) <> nil then
                    begin
                         GenerujBlad(errTakaStalaJuzIstnieje);
                         Continue;
                    end;
                    DodajStala(Instr, tdByte, DummyWord, tpRAM);
                    Continue;
               end else GenerujBlad(errNiewlasciwaWartosc);
          end;

          if (UpperCase(ParserStack^[2]) = 'ROMEQU') or
             (UpperCase(ParserStack^[2]) = 'EQUROM') or
             (UpperCase(ParserStack^[2]) = 'EQU') then
          begin
               if KalkulujWartosc(ParserStack^[3], DummyWord) then
               begin
                    if ZnajdzStala(Instr) <> nil then
                    begin
                         GenerujBlad(errTakaStalaJuzIstnieje);
                         Continue;
                    end;
                    DodajStala(Instr, tdWord, DummyWord, tpROM);
                    Continue;
               end else GenerujBlad(errNiewlasciwaWartosc);
          end;

          if (UpperCase(ParserStack^[2]) = 'BIT') then
          begin
               if CzyZgodnosc(ParserStack^[3], tprBit) then
               begin
                    if ZnajdzStala(Instr) <> nil then
                    begin
                         GenerujBlad(errTakaNazwaBituJuzIstnieje);
                         Continue;
                    end;
                    DummyWord := DajAdresBitu(ParserStack^[3]);
                    DodajStala(Instr, tdByte, DummyWord, tpBIT);
                    Continue;
               end else
               begin
                    GenerujBlad(errBladBitu);
                    Continue;
               end;
          end;
          if (UpperCase(ParserStack^[2]) = 'DB') or (UpperCase(ParserStack^[1]) = 'DB') then
          begin
               if UpperCase(ParserStack^[2]) = 'DB' then
               begin
                    if ZnajdzStala(Instr) <> nil then
                    begin
                         GenerujBlad(errTakaEtykietaJuzIstnieje);
                         Continue;
                    end;
                    DodajStala(Instr, tdWord, IP, tpRom);
                    DummyWord := 3;
               end
               else DummyWord := 2;
               OstatnioBylTekst := False;
               for i := DummyWord to ParserStackPtr do
               begin
                    Element := ParserStack^[i];
                    if Element = '' then Continue;
                    if Element = ',' then Continue;
                    if Element[1] in ['''','"'] then
                    begin
                         if not OstatnioBylTekst then Element := Copy(Element,2,Length(Element));
                         Dec(Element[0]);
                         Inc(IP,Ord(Element[0]));
                         OstatnioBylTekst := True;
                         Continue;
                    end;
                    Inc(IP);
                    OstatnioBylTekst := False;
               end;
               Continue;
          end;
          if (UpperCase(ParserStack^[2]) = 'DW') or (UpperCase(ParserStack^[1]) = 'DW') then
          begin
               if UpperCase(ParserStack^[2]) = 'DW' then
               begin
                    if ZnajdzStala(Instr) <> nil then
                    begin
                         GenerujBlad(errTakaEtykietaJuzIstnieje);
                         Continue;
                    end;
                    DodajStala(Instr, tdWord, IP, tpRom);
                    DummyWord := 3;
               end
               else DummyWord := 2;
               for i := DummyWord to ParserStackPtr do
               begin
                    Element := ParserStack^[i];
                    if Element = '' then Continue;
                    if Element = ',' then Continue;
                    if Element[1] in ['''','"'] then
                    begin
                         GenerujBlad(errNiewlasciwaWartosc);
                         Exit;
                    end;
                    Inc(IP,2);
               end;
               Continue;
          end;
          {interpretacja instrukcji/parametrow}
          if (Instr = '') then Continue; {Tu nast¥pi skok, gdy po definicji
          etykiety nie nast¥pi ¾adna instrukcja}

          ZnalazlemMnemonik := False;
          for i := 1 to 111 do
          begin
               Wpis := TablicaKodow^[i];
               if Length(Instr) > MaxNazwaInstrukcji then break;
               FillChar(NazwaInstrukcji, SizeOf(TNazwaInstrukcji), #0);
               Move(Instr[1], NazwaInstrukcji, Length(Instr));
               if StrComp(@NazwaInstrukcji, @Wpis.Nazwa) = 0 then
               begin
                    ZnalazlemMnemonik := True;
{                    Inc(IP);}
                    {Sprawdzenie, czy ilo˜† parametr¢w jest OK}
                    if Wpis.IloscPar = 0 then
                    begin
                         if ParserStack^[2] <> '' then
                         begin
                              GenerujBlad(errNiewlasciwaIloscParametrow);
                              Break;
                         end;
                    end else
                    begin
                         if ParserStack^[1+Wpis.IloscPar*2] <> '' then
                         begin
                              GenerujBlad(errNiewlasciwaIloscParametrow);
                              Break;
                         end;
                    end;
                    {teraz sprawdzamy, czy dla podanej kombinacji
                     parametr¢w, te s¥ poprawne.}
                    ZgodnoscZPar1 := CzyZgodnosc(ParserStack^[2], Wpis.Par[1]);
                    ZgodnoscZPar2 := CzyZgodnosc(ParserStack^[4], Wpis.Par[2]);
                    ZgodnoscZPar3 := CzyZgodnosc(ParserStack^[6], Wpis.Par[3]);

                    {teraz rozpatrzymy jeden specyficzny przypadek}
                    if not ZgodnoscZPar1 then
                    begin
                         if Wpis.Par[1] = tprAB then
                         begin
                              GenerujBlad(errSpodziewanyAB);
                              Goto KolejnaLinia1;
                         end;
                    end;

                    if Wpis.MoznaZaufac then
                    begin
                         if Wpis.Par[1] in [tprCode8, tprCode11, tprCode16, tprData16]
                            then ZgodnoscZPar1 := True;
                         if Wpis.Par[2] in [tprCode8, tprCode11, tprCode16, tprData16]
                            then ZgodnoscZPar2 := True;
                         if Wpis.Par[3] in [tprCode8, tprCode11, tprCode16, tprData16]
                            then ZgodnoscZPar3 := True;
                    end;

                    if ZgodnoscZPar1 and ZgodnoscZPar2 and ZgodnoscZPar3 then
                    begin
                         Inc(IP, 1+DajWielkoscParametrow(Wpis.Par[1],
                                                         Wpis.Par[2],
                                                         Wpis.Par[3]));
                         Goto KolejnaLinia1;
                    end;
               end;
          end; {for}
          if ZnalazlemMnemonik then
          begin
               generujBlad(errBrakZgodnosciParametrow);
               Continue;
          end;
          GenerujBlad(errBladSkladni);
          Continue;

          KolejnaLinia1:
     end; {pierwsze przejscie}

{****************************************************************}
 {**************************************************************}
  {************************************************************}
     IP := $0000;
     if not JestBlad then
     begin
          WriteLn('Drugie przej˜cie kompilatora');
          MiejsceBledu := mbPrzejscie2;
     end;
     WczytujKolejnaLinie := True;

     for nLinia := 0 to ListaLinii^.Count-1 do
     begin
          if JestBlad then break;

          if WczytujKolejnaLinie then
          begin
               SourceLine := PSourceLine(ListaLinii^.Items^[nLinia]);
               Linia := SourceLine^.Linia;
               {Tutaj ma miejsce ci©¾ka praca kompilatora, czyli...
                Analizator Syntaktyczny :>}
               Parser(Linia);

               For i := 1 to ParserStackPtr
                   do ParserStack^[i] := TrimAll(ParserStack^[i]);
               UsuwajJednostkiLeksykalne := false;

          end {if WczytujKolejneLinie}
          else Dec(nLinia);
          WczytujKolejnaLinie := True;
          Instr := UpperCase(ParserStack^[1]);

          if Instr[ord(Instr[0])] = ':' then
          begin
               for i := 2 to MaxKomplikacjaLinii do
                   ParserStack^[i-1] := ParserStack^[i];
               Dec(ParserStackPtr);
               WczytujKolejnaLinie := False;
               Continue;
          end;

 {         if (Instr = 'ENDM') or (Instr = 'MACEND') or (Instr = 'ENDMAC') then
          begin
               JestemWMakrze := False;
               Continue;
          end;
          if (UpperCase(ParserStack^[2]) = 'MACRO') then
          begin
               JestemWMakrze := True;
               Continue;
          end;
          if JestemWMakrze then Continue;
}
          if Instr = 'ORG' then
          begin
               KalkulujWartosc(ParserStack^[2], DummyWord);
               IP := DummyWord;
               Continue;
          end;

          if (Instr = 'OUTPUTFILE') then Continue;
          if (Instr = 'SYMBOLFILE') then Continue;
          if (Instr = 'NOMATH') then Continue;
          if (Instr = 'INCLUDE') then continue;
          if (Instr = 'CPU') then Continue;
          if (UpperCase(ParserStack^[2]) = 'EQU') then Continue;
          if (UpperCase(ParserStack^[2]) = 'RAMEQU') then Continue;
          if (UpperCase(ParserStack^[2]) = 'ROMEQU') then Continue;
          if (UpperCase(ParserStack^[2]) = 'EQURAM') then Continue;
          if (UpperCase(ParserStack^[2]) = 'EQUROM') then Continue;
          if (UpperCase(ParserStack^[2]) = 'BIT') then Continue;


          if (UpperCase(ParserStack^[1]) = 'DB') or (UpperCase(ParserStack^[2]) = 'DB') then
          begin
               if UpperCase(ParserStack^[2]) = 'DB'
                  then DummyWord := 3
                  else DummyWord := 2;
               OstatnioBylTekst := False;
               for i := DummyWord to ParserStackPtr do
               begin
                    Element := ParserStack^[i];
                    if Element = '' then Continue;
                    if Element = ',' then Continue;
                    if Element[1] in ['''','"'] then
                    begin
                         if not OstatnioBylTekst then Element := Copy(Element,2,Length(Element));
                         Dec(Element[0]);

                         Move(Element[1], Prg^[IP], Length(Element));
                         Inc(IP,Ord(Element[0]));
                         OstatnioBylTekst := True;
                         Continue;
                    end;
                    KalkulujWartosc(Element, DummyWord);
                    Prg^[IP] := DummyWord;

                    Inc(IP);
                    OstatnioBylTekst := False;
               end;
               Continue;
          end;
          if (UpperCase(ParserStack^[2]) = 'DW') or (UpperCase(ParserStack^[1]) = 'DW') then
          begin
               if UpperCase(ParserStack^[2]) = 'DW'
                  then DummyWord := 3
                  else DummyWord := 2;
               for i := DummyWord to ParserStackPtr do
               begin
                    Element := ParserStack^[i];
                    if Element = '' then Continue;
                    if Element = ',' then Continue;
                    if Element[1] in ['''','"'] then
                    begin
                         GenerujBlad(errNiewlasciwaWartosc);
                         Exit;
                    end;
                    KalkulujWartosc(Element, DummyWord);
                    Prg^[IP] := Hi(DummyWord);
                    Prg^[IP+1] := Lo(DummyWord);
                    Inc(IP,2);
               end;
               Continue;
          end;
          {interpretacja instrukcji/parametrow}
          if (Instr = '') then Continue; {Tu nast¥pi skok, gdy po definicji
          etykiety nie nast¥pi ¾adna instrukcja}

          ZnalazlemMnemonik := False;
          for i := 1 to 111 do
          begin
               Wpis := TablicaKodow^[i];
               if Length(Instr) > MaxNazwaInstrukcji then break;
               FillChar(NazwaInstrukcji, SizeOf(TNazwaInstrukcji), #0);
               Move(Instr[1], NazwaInstrukcji, Length(Instr));
               if StrComp(@NazwaInstrukcji, @Wpis.Nazwa) = 0 then
               begin
                    ZnalazlemMnemonik := True;
                    {Sprawdzenie, czy ilo˜† parametr¢w jest OK}
                    if Wpis.IloscPar = 0 then
                    begin
                         if ParserStack^[2] <> '' then
                         begin
                              GenerujBlad(errNiewlasciwaIloscParametrow);
                              Break;
                         end;
                    end else
                    begin
                         if ParserStack^[1+Wpis.IloscPar*2] <> '' then
                         begin
                              GenerujBlad(errNiewlasciwaIloscParametrow);
                              Break;
                         end;
                    end;
                    {teraz sprawdzamy, czy dla podanej kombinacji
                     parametr¢w, te s¥ poprawne.}
                    ZgodnoscZPar1 := CzyZgodnosc(ParserStack^[2], Wpis.Par[1]);
                    ZgodnoscZPar2 := CzyZgodnosc(ParserStack^[4], Wpis.Par[2]);
                    ZgodnoscZPar3 := CzyZgodnosc(ParserStack^[6], Wpis.Par[3]);

                    if ZgodnoscZPar1 and ZgodnoscZPar2 and ZgodnoscZPar3 then
                    begin
                         {Tutaj ma miejsce generacja kodu i sprawdzanie
                          pewnych szczeg¢ˆ¢w}
                         DlugoscInstrukcji := DajWielkoscParametrow(Wpis.Par[1],
                                                                    Wpis.Par[2],
                                                                    Wpis.Par[3])+1;
                         OldIP := IP; {OldIP}
                         Prg^[IP] := Wpis.OpKod;
                         Inc(IP);


                         for NumerParametru := 1 to 3 do
                         begin
                              if not (Wpis.Par[NumerParametru] in [tprNieznany, tprACC, tprPtrADPTR, tprPtrAPC, tprDPTR,
                                                                   tprC, tprAB, tprPtrDPTR]) then
                              begin
                                   case Wpis.Par[NumerParametru] of
                                    tprCode11:
                                    begin
                                         if not KalkulujWartosc(ParserStack^[NumerParametru*2], DummyWord) then
                                         begin
                                              GenerujBlad(errEtykietaNieOdnaleziona);
                                              goto KolejnaLinia2;
                                         end;
                                         if DummyWord and $F800 <> 0 then
                                         begin
                                              GenerujBlad(errEtykietaPozaZakresemAdresowania);
                                              Goto KolejnaLinia2;
                                         end;
                                         Prg^[OldIP] := ((Hi(DummyWord) shl 5) and $E0) or Prg^[OldIP];
                                         Prg^[IP] := Lo(DummyWord);
                                    end;
                                    tprCode16:
                                    begin
                                         if not KalkulujWartosc(ParserStack^[NumerParametru*2], DummyWord) then
                                         begin
                                              GenerujBlad(errEtykietaNieOdnaleziona);
                                              goto KolejnaLinia2;
                                         end;
                                         Prg^[IP] := Hi(DummyWord);
                                         Prg^[IP+1] := Lo(DummyWord);
                                    end;
                                    tprRi:
                                    begin
                                         Prg^[OldIP] := Prg^[OldIP] and $FE;
                                         Prg^[OldIP] := Prg^[OldIP] or DajIZRi(ParserStack^[NumerParametru*2]);
                                    end;
                                    tprRn:
                                    begin
                                         Prg^[OldIP] := Prg^[OldIP] and $F8;
                                         Prg^[OldIP] := Prg^[OldIP] or DajnZRn(ParserStack^[NumerParametru*2]);
                                    end;
                                    tprRamAddr:
                                    begin
                                         KalkulujWartosc(ParserStack^[NumerParametru*2], DummyWord);
                                         Prg^[IP] := DummyWord;
                                    end;
                                    tprBit:
                                    begin
                                         Prg^[IP] := DajAdresBitu(ParserStack^[NumerParametru*2]);
                                    end;
                                    tprCode8:
                                    begin
                                         if not KalkulujWartosc(ParserStack^[NumerParametru*2], DummyWord) then
                                         begin
                                              GenerujBlad(errEtykietaNieOdnaleziona);
                                              goto KolejnaLinia2;
                                         end;
                                         DummyLong := DummyWord;
                                         Dec(DummyLong, DlugoscInstrukcji);
                                         Dec(DummyLong, OldIP);
                                         if (DummyLong < -128) or (DummyLong > 127) then
                                         begin
                                              generujBlad(errEtykietaPozaZakresemAdresowania);
                                              Goto KolejnaLinia2;
                                         end;
                                         Prg^[IP] := DummyLong;
                                    end;
                                    tprData8:
                                    begin
                                         KalkulujWartosc(ParserStack^[NumerParametru*2], DummyWord);
                                         Prg^[IP] := DummyWord;
                                    end;
                                    tprData16:
                                    begin
                                         KalkulujWartosc(ParserStack^[NumerParametru*2], DummyWord);
                                         Prg^[IP] := Hi(DummyWord);
                                         Prg^[IP+1] := Lo(DummyWord);
                                    end;
                                    tprNegBit:
                                    begin
                                         Prg^[IP] := DajAdresBitu(ParserStack^[NumerParametru*2]);
                                    end;
                                   end;
                              end;
                              Inc(IP, DajWielkoscParametrow(Wpis.Par[NumerParametru],
                                                            tprNieznany,tprNieznany));
                         end; {for numerparametru}
                         goto KolejnaLinia2;
                    end;{ zgodnosc}
               end;
          end; {for}
          if ZnalazlemMnemonik then
          begin
               generujBlad(errBrakZgodnosciParametrow);
               Continue;
          end;
          GenerujBlad(errBladSkladni);
          Continue;

          KolejnaLinia2:
     end; {pierwsze przejscie}


     Dispose(ParserStack);
     {Zapisywanie programu}
     Assign(PlikPrg, PlikWy);
     Rewrite(PlikPrg, 1);
     BlockWrite(PlikPrg, prg^, min(SizeOf(TPamiecROM),IP));
     Close(PlikPrg);

     WriteLn('Generacja pliku HEX');
     UstawRozszerzenie(PlikWy, 'HEX');
     ZapiszBuforJakoHEX(Prg, IP, PlikWy, False);
     {Zapisywanie symboli}
     Assign(Symb, PlikSym);
     ReWrite(Symb);
     for i := 1 to IloscStalych do
     begin
          writeln(Symb, Byte(PAdresy(ListaStalych)^[i]^.typPamieci),' ',
                        PAdresy(ListaStalych)^[i]^.Wartosc,' ',
                        StrPas(@PAdresy(ListaStalych)^[i]^.nazwa));
          Freemem(PAdresy(ListaStalych)^[i], SizeOf(TDana));
     end;
     FreeMem(ListaStalych, IloscStalych*4);
     Close(Symb);
     Dispose(prg);
     WriteLn('Ilo˜† staˆych.................: ',IloscStalych);
     WriteLn('Wielko˜† kodu.................: ',IP);
     WriteLn('Ilo˜† rzeczywistych linii kodu: ', ListaLinii^.Count);
     WriteLn('Ilo˜† makr....................: ', ListaMakr^.Count);
     Write('Typ platformy docelowej.........: ');
     IloscStalych := 0;
     if TypProcka = tp1051 then
     begin
          WriteLn('AT89C1051 (1KB Flash)');
          if IP > 1024 then WriteLn('Przekroczona wielko˜† kodu dla tego procka');
     end;
     if TypProcka = tp2051 then
     begin
          WriteLn('AT89C2051 (2KB Flash)');
          if IP > 2*1024 then WriteLn('Przekroczona wielko˜† kodu dla tego procka');
     end;
     if TypProcka = tp4051 then
     begin
          WriteLn('AT89C4051 (4KB Flash)');
          if IP > 4*1024 then WriteLn('Przekroczona wielko˜† kodu dla tego procka');
     end;
     if JestBlad then
     begin
          if MiejsceBledu = mbPreProcesor then
          begin
               writeLn('Bˆ¥d (',KodBledu,
                       ') Linia: ', StosInclude^.Stos[StosInclude^.Wskaznik].NumerLinii,
                       ', Plik: ',StosInclude^.Stos[StosInclude^.Wskaznik].Nazwa^,
                       ', ',ErrArray[KodBledu]^);
          end;
          if MiejsceBledu in [mbPrzejscie1, mbPrzejscie2] then
          begin
               writeLn('Bˆ¥d (',KodBledu,
                       ') Linia: ', SourceLine^.NumerLinii,
                       ', Plik: ',PString(ListaPlikow^.Items^[SourceLine^.NumerPliku-1])^,
                       ', ',ErrArray[KodBledu]^);
          end;
     end;

     for i := 1 to StosInclude^.Wskaznik do
          ZwolnijElementStosuInclude(StosInclude^.Stos[i]);
     Dispose(StosInclude);

     for i := 1 to ListaPlikow^.Count do
     begin
          DisposeStr(ListaPlikow^.Items^[0]);
          ListaPlikow^.AtDelete(0);
     end;
     Dispose(ListaPlikow, Done);

     for i := 1 to ListaLinii^.Count do
     begin
          ZwolnijLinie(PSourceLine(ListaLinii^.Items^[0]));
          ListaLinii^.AtDelete(0);
     end;
     Dispose(ListaLinii, Done);

     for i := 1 to ListaMakr^.Count do
     begin
          ZwolnijMakro(PMakro(ListaMakr^.Items^[0]));
          ListaMakr^.AtDelete(0);
     end;
     Dispose(ListaMakr, Done);
     Dispose(TablicaKodow);

     WriteLn(MemAvail,'   ', MemAv);
     WriteLn('---------------------');
     WriteLn(MaxAvail,'   ', MaxAv);

end.
