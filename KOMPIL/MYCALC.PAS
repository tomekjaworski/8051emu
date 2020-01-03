unit MyCalc;
interface
uses textoolz, k_errs;
const HexStr     : string[16] = '0123456789ABCDEF';
      IloscOperacji = 27;
      MaxParametrow = 50;

    Prior  : Array [1..IloscOperacji] of string =
      ('||','&&','^^','~','=','<','>','==','>=','=>','<=','=<',
      '<>','><','\','|','!','+','-','*','>>','<<','&','%','^','/',':');
    Znaki  : Set of Char = ['+','-','*','/','^','=','|','\','&','%','#','~','>','<',':','!'];
    UnarySigns: Set of Char = ['+','-','~','!'];

const
     ZaDuzoNawiasow = 'Zbyt du¾o nawias¢w zamykaj¥cych - )';
     ZlaIloscNawiasow = 'Ilo˜† nawias¢w zamykaj¥cych i otwieraj¥cych nie jest taka sama';
     ZlaLiczba = 'Zˆa warto˜† liczbowa';
     ZlyZnak = 'Nierozpoznany znak';
     BladMnozenia = 'Przepeˆnienie przy mno¾eniu';
     ZaDuzeLiczbyOr = 'Zbyt du¾e liczby do operacji OR - |';
     ZaDuzeLiczbyAnd = 'Zbyt du¾e liczby do operacji AND - &';
     ZaDuzeLub0Mod = 'Zbyt du¾e liczby do operacji MOD lub pr¢ba dzielenie przez 0 - %';
     ZaDuzeLiczbyXor = 'Zbyt du¾e liczby do operacji XOR - \';
     ZaDuzeLiczbyNot = 'Zbyt du¾e liczby do operacji NOT';
     DzieleniePrzez0 = 'Dzielenie przez 0';
     PrzepelnieniePotegi = 'Przepeˆnienie przy podnoszeniu do pot©gi';
     BladSilni = 'Nie mo¾na wyliczy† silni z liczby uˆamkowej';
     PrzepelnienieSilni = 'Przepeˆnienie podczas wyliczania silni';
     NieRozpoznanePolecenie = 'Nie rozpoznane polecenie =X. Powinno by† ==, =>, =< a nie ';
     LipnePolecenie = 'Nierozpoznane polecenie';
     ZlaIloscParametrowIF = 'Zˆe u¾ycie instrukcji IF. Zˆa ilo˜† parametr¢w';
     ZlyIdentyfikator = 'Nierozpoznany identyfikator';
     LipnaFunkcja = 'Nieznana funkcja';
     LipneWyrazenie = 'Program natrafiˆ na bˆ©dne wyra¾enie';

type
{    PZmienne = ^TZmienne;
    TZmienne = Array[1..10] of String;}
    PDzialanie = ^TDzialanie;
    TParametry = Array[1..MaxParametrow] of PDzialanie;
    PParametry = ^TParametry;
    TCoToJest = (BlokLiczbowy,Nawias,Wartosc,Funkcja,Znak);
    TDzialanie = Record
      Wlasciciel: PDzialanie;
      Nazwa: String;
      CoToJest: TCoToJest;
      case TCotoJest of
       BlokLiczbowy: (Lewo,prawo:PDzialanie);
       Funkcja: (IleParams:Byte; params:PParametry);
    end;

Type PListaWskaznikowDoZwolnienia = ^TListaWskaznikowDoZwolnienia;
     TListaWskaznikowDoZwolnienia = array[1..512] of
     record
         Ptr:Pointer;
         Dlugosc:Word;
     end;


Type PMyCalc = ^TMyCalc;
     TMyCalc = object{(TObject)}
     private
             R:String;
             Dz:PDzialanie;
{             Zmienne:PZmienne;}
             Wyn:LongInt;
             lista:PListaWskaznikowDoZwolnienia;
             iloscwskaznikow:word;
             Function PrzeliczDrzewo(Drzewo:PDzialanie):Longint;
             function DajDrzewo(Dzialanie:String):PDzialanie;
             function DajWartoscFunkcji(P:PDzialanie):longint;

             function DajWartoscBloku(Blok: String): longint;
             Function DajPrzelicznik(N: Integer;S:String):Longint;
             procedure ObslozZnak(CiagZnaku : String;var NaszElement,OstatniaWartosc,Wejscie,GdzieJestesmy:PDzialanie);
             Procedure ObslozWartosc(ciagnawiasu:String;var jakinawias:TCoToJest; var OstatniaWartosc,Dzialanie,
                                     GdzieJestem:PDzialanie);
             procedure WezElement( St : String; var Start : Integer; var O : String;var Tp : TCoToJest);
             function CzyPriorytet(Odniesienie,Testowany:String) : Boolean;

     public
{             CzyBlad: Boolean;}

             WystapilBlad:Boolean;
             OpisBledu:String;
             WystapilyNawiasy:Boolean;
{             IloscZmiennych:Integer;}
             constructor Create;
             destructor Destroy; {override;}
             procedure UstawRownanie(Rown:String);
             function PobierzRownanie:String;
             procedure Kalkuluj;
             function Wynik:longint;
             procedure DajBlad(Opis:String); virtual;
             Function ObslugaZmiennej(var Zm:String;var Wart:longint):Boolean; virtual;
{             procedure DodajParametr(Zm:String);}

end;

function Silnia(ile:integer):longint;
function Potega(Podst,Wykl:longint):longint;

implementation

function Silnia(ile : integer) : longint;
var wart:longint;
    i:integer;
begin
     wart := 1;
     for i := 1 to ile do wart := wart * i;
     Silnia := wart;
end;

function Potega(Podst,Wykl:longint):longint;
var wyniczek,StaraPodstawa:longint;
begin
     StaraPodstawa := Podst;
     Podst := Abs(Podst);
     if Podst = 0
        then wyniczek := 0
        else
        begin
             wyniczek := Trunc(exp(ln(Podst) * wykl));
             if (StaraPodstawa < 0) and ((Trunc(wykl) mod 2) = 1)
                then wyniczek := wyniczek * (-1);
        end;
        Potega := wyniczek;
end;

constructor TMyCalc.Create;
begin
{     inherited Create;}
{     New(Dz);}
{     New(Zmienne);}
     New(lista);
     WystapilBlad:=False;
     WystapilBlad:=False;
     OpisBledu:='';
     WystapilyNawiasy:=False;
{     IloscZmiennych := 0;}
     IloscWskaznikow := 0;
end;

destructor TMyCalc.Destroy;
var i:word;
begin
{     inherited Destroy;}
     for i := 1 to IloscWskaznikow do
         FreeMem(lista^[i].ptr, lista^[i].Dlugosc);
{     Dispose(Dz);}
{     Dispose(Zmienne);}
     Dispose(lista);
     IloscWskaznikow := 0;
end;

procedure TMyCalc.UstawRownanie(Rown:String);
var IleNawiasow,I:Integer;
begin
     R:=Trim(Rown);
     WystapilyNawiasy := False;
     WystapilBlad := False;
     IleNawiasow := 0;
{     for i := 1 to ord(R[0]) do
     begin
          if R[i] = ' ' then Delete(R,i,1);
     end;}
     For I := 1 to Length(r) do
         begin
              if r[I] = '('
                 then Inc(ilenawiasow);
              if R[I] = ')'
                 then Dec(ilenawiasow);
              if ilenawiasow < 0 then
                 begin
                      DajBlad(ZaDuzoNawiasow);
                      Exit;
                 end;
         end; {for}
     if ilenawiasow > 0 then
     begin
          DajBlad(ZlaIloscNawiasow);
          Exit;
     end;
     Dz := DajDrzewo(R);
end;

function TMyCalc.PobierzRownanie:String;
begin
     PobierzRownanie := R;
end;

procedure TMyCalc.Kalkuluj;
begin
     wyn := PrzeliczDrzewo(Dz);
end;

function TMyCalc.Wynik:Longint;
begin
     Wynik := wyn;
end;

Function TMyCalc.PrzeliczDrzewo(Drzewo:PDzialanie):longint;
var Wyniczek,Parametr:Longint;
    blad:Integer;
begin
     PrzeliczDrzewo:=0;
     if WystapilBlad then Exit;
     if drzewo=Nil then Exit;
     if (Drzewo^.CoToJest=Funkcja) then
     begin
          Wyniczek:=DajWartoscFunkcji(drzewo);
          PrzeliczDrzewo := Wyniczek;
          Exit;
     end;
     if (Drzewo^.CotoJest=Wartosc) then
     begin
          Val(Drzewo^.nazwa,Wyniczek,blad);
          if blad>0 then DajBlad(ZlaLiczba);
          PrzeliczDrzewo:=Wyniczek;
          Exit;
     end;
     if (drzewo^.CoToJest=BlokLiczbowy) then
     begin
          Wyniczek := DajWartoscBloku(drzewo^.nazwa);
          PrzeliczDrzewo := wyniczek; Exit;
     end;
     if (drzewo^.cotojest=Znak) then
     begin
          if (Length(drzewo^.Nazwa) > 2) or (drzewo^.nazwa = #0) then
          begin
               DajBlad(ZlyZnak);
               Exit;
          end;
          if Drzewo^.Prawo = nil then
          begin
               PrzeliczDrzewo := PrzeliczDrzewo(Drzewo^.Lewo);
               Exit;
          end;
          Wyniczek:=PrzeliczDrzewo(Drzewo^.Lewo);
          parametr:=PrzeliczDrzewo(Drzewo^.Prawo);
          if Wystapilblad then Exit;
          if Length(Drzewo^.nazwa) = 1 then
          begin
               Case drzewo^.nazwa[1] of
                '+' : Wyniczek:=Wyniczek+parametr;
                '-' : Wyniczek:=Wyniczek-parametr;
                '*' : if (Wyniczek= 0) or (parametr=0)
                         then wyniczek := 0
                         else if (Abs(Wyniczek) > 1)
                                 then if (1e38/Abs(Wyniczek) < Abs(parametr))
                                         then DajBlad(BladMnozenia)
                                         else Wyniczek:=Wyniczek*parametr
                                 else if (Abs(Wyniczek) <= $7FFFFFFF) and (Abs(parametr) <= $7FFFFFFF)
                                         then Wyniczek:=Wyniczek*parametr
                                         else dajblad(BladMnozenia);
                '|' : if (Abs(wyniczek) <= $7FFFFFFF) and (Abs(parametr) <= $7FFFFFFF)
                         then wyniczek := Trunc(wyniczek) or Trunc(parametr)
                         else Dajblad(ZaDuzeLiczbyOr);
                '&' : if (Abs(wyniczek) <= $7FFFFFFF) and (Abs(Parametr) <= $7FFFFFFF)
                         then Wyniczek := Trunc(wyniczek) and Trunc(Parametr)
                         else Dajblad(ZaDuzeLiczbyAnd);
                '%' : if (Abs(wyniczek) <= $7FFFFFFF) and (Abs(Parametr) <= $7FFFFFFF) and (Trunc(parametr) <> 0)
                         then Wyniczek := Trunc(wyniczek) mod Trunc(Parametr)
                         else dajblad(ZaDuzeLub0Mod);
                '\' : if (Abs(wyniczek) <= $7FFFFFFF) and (Abs(Parametr) <= $7FFFFFFF)
                         then wyniczek := Trunc(wyniczek) xor Trunc(Parametr)
                         else Dajblad(ZaDuzeLiczbyXor);
                '~' : if (Abs(parametr) <= $7FFFFFFF)
                         then wyniczek := not Trunc(parametr)
                         else Dajblad(ZaDuzeLiczbyNot);
                '/' : if parametr<>0
                         then wyniczek:=wyniczek div parametr
                         else dajblad(DzieleniePrzez0);
                '^' : if Abs(parametr) > 30 then
                      begin
                           DajBlad(PrzepelnieniePotegi);
                           Exit;
                      end
                      else wyniczek := Potega(wyniczek,parametr);
                '>' : wyniczek:=byte(wyniczek>Parametr);
                '<' : wyniczek:=byte(wyniczek<Parametr);
                '=' : wyniczek:= byte(wyniczek=parametr);
                '!' : if (Abs(Parametr) <= $20) then
                      begin
                           if (int(Parametr)=Parametr)
                              then wyniczek := Silnia(Trunc(parametr))
                              else DajBlad(BladSilni);
                      end
                      else DajBlad(PrzepelnienieSilni);
                else DajBlad(ZlyZnak);
               end; {drzewo^.nazwa[1]}
          end{Length(Drzewo^.nazwa) = 1}
          else
              Case drzewo^.nazwa[1] of
               '=': case drzewo^.nazwa[2] of
                     '=': wyniczek := Byte(wyniczek=parametr);
                     '>': wyniczek := Byte(wyniczek>=parametr);
                     '<': wyniczek := Byte(wyniczek<=parametr);
                     else DajBlad(NieRozpoznanePolecenie+drzewo^.nazwa[2]);
                    end;
               '&': if drzewo^.nazwa[2] = '&'
                       then wyniczek := Byte((wyniczek<>0) and (parametr<>0))
                       else dajblad('Polecenie powino mie† posta† &&, a nie '+Drzewo^.nazwa);
               '|': if Drzewo^.nazwa[2] = '|'
                       then wyniczek := Byte((wyniczek<>0) or (parametr<>0))
                       else dajblad('Polecenie powino mie† posta† ||, a nie '+Drzewo^.nazwa);
               '^': if Drzewo^.nazwa[2] = '^'
                       then wyniczek := Byte((wyniczek<>0) xor (parametr<>0))
                       else dajblad('Polecenie powino mie† posta† ^^, a nie '+Drzewo^.nazwa);
               '>': if Drzewo^.nazwa[2] = '<'
                       then wyniczek := Byte(wyniczek<>parametr)
                       else if Drzewo^.Nazwa[2] = '='
                               then wyniczek := Byte(wyniczek>=parametr)
                               else if (Drzewo^.nazwa[2] = '>') and (Abs(wyniczek) <= $7FFFFFFF)
                                       and (Abs(parametr) < $7FFFFFFF)
                                       then wyniczek := Trunc(wyniczek) shr Trunc(parametr)
                                       else dajblad('Nie rozpoznane polecenie '+Drzewo^.nazwa);
               '<': if Drzewo^.Nazwa[2] = '>'
                       then wyniczek := Byte(wyniczek<>parametr)
                       else if Drzewo^.Nazwa[2] = '='
                               then wyniczek := Byte(wyniczek<=Parametr)
                               else if (Drzewo^.Nazwa[2] = '<') and (Abs(wyniczek) <= $7FFFFFFF)
                                       and (Abs(Parametr) < $7FFFFFFF)
                                       then wyniczek := Trunc(wyniczek) shl Trunc(Parametr)
                                       else Dajblad('Nie rozpoznane polecenie '+Drzewo^.nazwa);
               else Dajblad(LipnePolecenie+' '+Drzewo^.nazwa);
              end; {drzewo^.nazwa[1]}
          PrzeliczDrzewo:=wyniczek;
     end; {(drzewo^.cotojest=Znak)}
end;

Function TMyCalc.DajWartoscFunkcji(P: PDzialanie) : Longint;
var i:Integer;
    wyniczek,param1,param2:longint;
    Funkcja: String;
begin
     funkcja := UpperCase(P^.nazwa);
     DajWartoscFunkcji := 0;
     {**** Instrukcja IF}
     if funkcja='IF' then
     begin
          if (P^.IleParams < 2) or (P^.IleParams > 3) then
          begin
               DajBlad(ZlaIloscParametrowIF);
               Exit;
          end;
          wyniczek := 0;
          param1 := PrzeliczDrzewo(P^.Params^[1]);
          if WystapilBlad then Exit;
          if (P^.IleParams = 2) then
          begin
               if param1 <> 0
                  then wyniczek := PrzeliczDrzewo(P^.Params^[2])
          end
          else
              if param1 <> 0
                 then wyniczek := PrzeliczDrzewo(P^.Params^[2])
                 else wyniczek := PrzeliczDrzewo(P^.Params^[3]);
          DajWartoscFunkcji := wyniczek; Exit
     end; {if}
{****** Instrukcja Max}
     if funkcja = 'MAX' then
     begin
          if (P^.IleParams < 2) or (P^.IleParams > 3) then
          begin
               DajBlad('Zˆe u¾ycie instrukcji MAX. Zˆa ilo˜† parametr¢w');
               Exit;
          end;
          param1 := PrzeliczDrzewo(P^.Params^[1]);
          if WystapilBlad then Exit;
          param2 := PrzeliczDrzewo(P^.Params^[2]);
          if wystapilBlad then Exit;
          if param1>param2
             then DajWartoscFunkcji := param1
             else DajWartoscFunkcji := param2;
          Exit;
     end;{max}
{****** Instrukcja Min}
     if funkcja = 'MIN' then
     begin
          if P^.IleParams <> 2 then
          begin
               DajBlad('Zˆe u¾ycie instrukcji MIN. Zˆa ilo˜† parametr¢w');
               Exit;
          end;
          param1 := PrzeliczDrzewo(P^.Params^[1]);
          if WystapilBlad then Exit;
          param2 := PrzeliczDrzewo(P^.Params^[2]);
          if WystapilBlad then Exit;
          if param1>param2
             then DajWartoscFunkcji := param2
             else DajWartoscFunkcji := param1;
          Exit;
     end; {min}

{****** Instrukcja Srednia}
     if funkcja = 'SREDNIA' then
     begin
          if (P^.IleParams < 1) or (P^.IleParams > MaxParametrow) then
             begin
                  DajBlad('Zˆe u¾ycie instrukcji SREDNIA. Z¾a ilo˜† parametr¢w');
                  Exit;
             end;
          wyniczek := 0;
          for i := 1 to p^.IleParams do
          begin
               wyniczek:=wyniczek + PrzeliczDrzewo(P^.Params^[i]);
               if WystapilBlad then Exit;
          end;
          DajWartoscFunkcji :=wyniczek div p^.IleParams;
          Exit;
     end;
{****** Instrukcja Srednia}
     if funkcja = 'SUMA' then
     begin
          if (P^.IleParams < 1) or (P^.IleParams > MaxParametrow) then
          begin
               DajBlad('Zˆe u¾ycie instrukcji SREDNIA. Zˆa ilo˜† parametr¢w');
               Exit;
          end;
          wyniczek := 0;
          for i := 1 to p^.IleParams do
          begin
               wyniczek:=wyniczek + PrzeliczDrzewo(P^.Params^[i]);
               if WystapilBlad then Exit;
          end;
          DajWartoscFunkcji :=wyniczek;
          Exit;
     end;

{****** Instrukcja SHR}
     if funkcja = 'SHR' then
     begin
          if P^.IleParams <> 2 then
          begin
               DajBlad('Zˆe u¾ycie instrukcji SHR. Zˆa ilo˜† parametr¢w');
               Exit;
          end;
          wyniczek := PrzeliczDrzewo(P^.Params^[1]);
          param1 := PrzeliczDrzewo(P^.Params^[2]);
          if (Abs(wyniczek) <= $7FFFFFFF) and (Abs(param1) < $7FFFFFFF)
             then wyniczek := Trunc(wyniczek) shr Trunc(param1)
             else DajBlad('Zˆe u¾ycie instrukcji SHR. Parametry s¥ zbyt du¾e');
          DajWartoscFunkcji :=wyniczek;
          Exit;
     end;

{****** Instrukcja SHL}
     if funkcja = 'SHL' then
     begin
          if P^.IleParams <> 2 then
          begin
               DajBlad('Zˆe u¾ycie instrukcji SHL. Zˆa ilo˜† parametr¢w');
               Exit;
          end;
          wyniczek := PrzeliczDrzewo(P^.Params^[1]);
          param1 := PrzeliczDrzewo(P^.Params^[2]);
          if (Abs(wyniczek) <= $7FFFFFFF) and (Abs(param1) < $7FFFFFFF)
             then wyniczek := Trunc(wyniczek) shl Trunc(param1)
             else DajBlad('Zˆe u¾ycie instrukcji SHL. Parametry s¥ zbyt du¾e');
          DajWartoscFunkcji :=wyniczek;
          Exit;
     end;
{****** Instrukcja AND}
     if funkcja = 'AND' then
     begin
          if P^.IleParams <> 2 then
          begin
               DajBlad('Zˆe u¾ycie instrukcji AND. Zˆa ilo˜† parametr¢w');
               Exit;
          end;
          wyniczek := PrzeliczDrzewo(P^.Params^[1]);
          param1 := PrzeliczDrzewo(P^.Params^[2]);
          if (Abs(wyniczek) <= $7FFFFFFF) and (Abs(param1) < $7FFFFFFF)
             then wyniczek := Trunc(wyniczek) and Trunc(param1)
             else DajBlad('Zˆe u¾ycie instrukcji AND. Parametry s¥ zbyt du¾e');

          DajWartoscFunkcji :=wyniczek;
          Exit;
     end;
{****** Instrukcja XOR}
     if funkcja = 'XOR' then
     begin
          if P^.IleParams <> 2 then
          begin
               DajBlad('Zˆe u¾ycie instrukcji XOR. Zˆa ilo˜† parametr¢w');
               Exit;
          end;
          wyniczek := PrzeliczDrzewo(P^.Params^[1]);
          param1 := PrzeliczDrzewo(P^.Params^[2]);
          if (Abs(wyniczek) <= $7FFFFFFF) and (Abs(param1) < $7FFFFFFF)
             then wyniczek := Trunc(wyniczek) xor Trunc(param1)
             else DajBlad('Zˆe u¾ycie instrukcji XOR. Parametry s¥ zbyt du¾e');
          DajWartoscFunkcji :=wyniczek;
          Exit;
     end;
{****** Instrukcja MOD}
     if funkcja = 'MOD' then
     begin
          if P^.IleParams <> 2 then
          begin
               DajBlad('Zˆe u¾ycie instrukcji MOD. Zˆa ilo˜† parametr¢w');
               Exit;
          end;
          wyniczek := PrzeliczDrzewo(P^.Params^[1]);
          param1 := PrzeliczDrzewo(P^.Params^[2]);
          if Trunc(param1)=0 then
          begin
               DajBlad('Zˆe u¾ycie instrukcji MOD. Pr¢ba dzielenie przez 0');
               Exit;
          end;
          if (Abs(wyniczek) <= $7FFFFFFF) and (Abs(param1) < $7FFFFFFF)
             then wyniczek := Trunc(wyniczek) mod Trunc(param1)
             else DajBlad('Zˆe u¾ycie instrukcji MOD. Parametry s¥ zbyt du¾e');
          DajWartoscFunkcji :=wyniczek;
          Exit;
     end;
{****** Instrukcja OR}
     if funkcja = 'OR' then
     begin
          if P^.IleParams <> 2 then
          begin
               DajBlad('Zˆe u¾ycie instrukcji OR. Zˆa ilo˜† parametr¢w');
               Exit;
          end;
          wyniczek := PrzeliczDrzewo(P^.Params^[1]);
          param1 := PrzeliczDrzewo(P^.Params^[2]);
          if (Abs(wyniczek) <= $7FFFFFFF) and (Abs(param1) < $7FFFFFFF)
             then wyniczek := Trunc(wyniczek) or Trunc(param1)
             else DajBlad('Zˆe u¾ycie instrukcji OR. Parametry s¥ zbyt du¾e');
          DajWartoscFunkcji :=wyniczek;
          Exit;
     end;

     if P^.IleParams = 1 then
     begin
          wyniczek := PrzeliczDrzewo(P^.Params^[1]);
          if not WystapilBlad then
          begin
               If funkcja='ABS' then
               begin
                    dajwartoscfunkcji := Abs(wyniczek);
                    Exit
               end;
               If funkcja='NOT' then
               begin
                    dajwartoscfunkcji:= not Trunc(wyniczek);
                    Exit;
               end;
               If funkcja='RANDOM' then
               begin
                    dajwartoscfunkcji:=Random(Trunc(wyniczek));
                    Exit
               end;
               If funkcja='ZNAK' then
               begin
                    if wyniczek = 0
                       then dajwartoscfunkcji:=0
                       else if wyniczek < 0
                               then dajwartoscfunkcji := -1
                               else dajwartoscfunkcji := 1;
                    Exit
               end;
          end; {not CzyBlad}
     end; { P^.IleParams = 1}
     DajBlad(LipnaFunkcja);
end; {dajwartoœæ funkcji}

procedure TMyCalc.DajBlad(Opis:String);
begin
     OpisBledu:=Opis;
     WystapilBlad:=True
end;

function TMyCalc.CzyPriorytet(Odniesienie,Testowany:String):Boolean;
var i : Byte;
begin
    i:=1;
    While  (not (Odniesienie=Prior[i])) and (not (Testowany=Prior[i])) and (i<=IloscOperacji) do
    begin
         Inc(i);
    end;
    CzyPriorytet:=Odniesienie=Prior[i];
end;

procedure TMyCalc.WezElement( St : String; var Start : Integer; var O : String;var Tp : TCoToJest);
var I,L   : Integer;
    S,S1  : String;
    B: Boolean;
begin
     St := UpperCase(St);
     O:=Copy(St,Start,250);
     if O[1]='(' then Tp:=Nawias
        else if (O[1]>='0') and (O[1]<='9') or {(O[1] = '$') or} (O[1] = '.')
                then Tp:=Wartosc
                else if ((O[1]>='A') and (O[1]<='Z') or (O[1] in ['@', '$', '_']))
                        then Tp:=BlokLiczbowy
                        else if O[1] in Znaki then
                             begin
                                  S:=O[1];
                                  if (O[2] in Znaki) and not (O[1] in UnarySigns)
                                                     and not (O[2] in UnarySigns)
                                  then S:=S+O[2];
                                  O:=S;
                                  Tp:=Znak;
                                  Inc(Start, Length(S));
                                  Exit;
                             end
                             else begin
                                       DajBlad(LipneWyrazenie);
                                       Exit;
                             end;
     L:=1;
     S:='';
     Case Tp of
       Nawias : begin
                     i:=1;
                     S:=O[1];
                     repeat
                           Inc(L);
                           S:= s + o[l];
                           Inc(i,Ord(O[L]='(')-ord(O[L]=')'));
                     until ((i=0) and (O[L]=')')) or (L>Length(O));
                     Inc(Start, Length(S));
                end;
      Wartosc : begin
                     B := True;
                     repeat
                           s := s + o[l];
                           B := B and (O[L] in ['0'..'9','E','.']);
                           if B and (L < Length(O)) and (O[L] = 'E') and (O[L+1] in ['+','-'])
                                and (S[1] >= '0') and (S[1] <= '9') then
                           begin
                                S := S + O[L+1];
                                Inc(L);
                           end;
                           Inc(L);
                     until not (O[L] in ['0'..'9','X','A'..'F','H','O','.']) or (L>Length(O));
                     Inc(Start, Length(S));
                     if S[1] = '.' then Insert('0', S, 1);
                     if Pos('.', S) = 0
                     then if S[Length(S)] = 'H' then
                          begin
                               S := '@H'+Copy(S, 1, Length(S)-1);
                               tp := BlokLiczbowy;
                          end else {if S[1] = '$' then
                                   begin
                                        S := '@H'+Copy(S, 2, Length(S)-1);
                                        tp := blokLiczbowy;
                                   end
                                   else}
                                       if (S[Length(S)] = 'B') and (S[2] in ['0'..'1']) then
                                       begin
                                            S := '@B'+Copy(S, 1, Length(S)-1);
                                            tp := blokliczbowy;
                                       end
                                       else
                                           if S[Length(S)] = 'O' then
                                           begin
                                                S := '@O'+Copy(S, 1, Length(S)-1);
                                                tp := blokliczbowy;
                                           end
                                           else
                                               if (S[1] = '0') and (Length(S) > 1) then
                                               begin
                                                    tp := blokliczbowy;
                                                    case S[2] of
                                                     'X': S := '@H'+Copy(S,3,255);
                                                     'B': S := '@B'+Copy(S,3,255);
                                                     else S := '@O'+Copy(S,2,255);
                                                    end;
                                               end;
                end;
 BlokLiczbowy : begin
                     repeat
                           s := s+o[l];
                           Inc(L);
                           if (O[L]='(') and (L <= Length(O)) then
                           begin
                                I := L;
                                WezElement(O,L,S1,Tp);
                                L := I;
                                S:=S+S1;
                                Tp:=Funkcja;
                           end;
                     until (O[L] in Znaki) or (Tp=Funkcja) or (L>length(O));
                     Inc(Start, Length(S));
                end;
     end; {koniec case}
     O:=S;
     WystapilBlad:=False;
end; {WezElement}
{******************************************}

Procedure TMyCalc.ObslozWartosc(ciagnawiasu:String;var jakinawias:TCoToJest; var OstatniaWartosc,Dzialanie,
                                GdzieJestem:PDzialanie);
var Q,Parametr: String;
    nawiasy,I:Integer;
begin
     if jakinawias=Nawias then
     begin
          ciagnawiasu := Copy(CiagNawiasu,2,length(CiagNawiasu));
          ciagnawiasu:= Copy(ciagnawiasu,1,length(ciagNawiasu)-1);
          Dzialanie:=DajDrzewo(Ciagnawiasu);
     end
     else if jakinawias=Funkcja then
          begin
               New(Dzialanie);
               inc(IloscWskaznikow);
               Lista^[IloscWskaznikow].ptr := Dzialanie;
               Lista^[IloscWskaznikow].Dlugosc := SizeOf(Dzialanie^);

               Dzialanie^.Wlasciciel := OstatniaWartosc;
               Dzialanie^.nazwa := Copy(CiagNawiasu,1,Pos('(',CiagNawiasu)-1);
               dzialanie^.Cotojest := JakiNawias;

               New(dzialanie^.Params);
               inc(IloscWskaznikow);
               Lista^[IloscWskaznikow].ptr := dzialanie^.Params;
               Lista^[IloscWskaznikow].Dlugosc := SizeOf(dzialanie^.Params^);

               dzialanie^.IleParams := 0;
               dzialanie^.Params^[1] := nil;
               Q := Copy(ciagnawiasu,Pos('(',ciagnawiasu) + 1,200);
               Dec(Q[0]);
               I := 1;
               Nawiasy := 0;
               While (I <= Length(Q)) do
               begin
                    Parametr := '';
                    While (I <= Length(Q)) and (Q[I] <> ',') do
                    begin
                         parametr:=parametr+Q[I];
                         if Q[I] = '('
                            then Inc(nawiasy)
                            else if Q[I] = ')'
                                    then Dec(nawiasy);
                         if Nawiasy < 0 then
                         begin
                              DajBlad(ZaDuzoNawiasow);
                              Exit;
                         end;
                         Inc(I);
                    end;
                    if nawiasy <> 0 then
                    begin
                         WystapilBlad := True;
                         DajBlad(ZlaIloscNawiasow);
                         Exit;
                    end;
                    Inc(Dzialanie^.IleParams); Inc(I);
                    Dzialanie^.Params^[dzialanie^.IleParams] := DajDrzewo(parametr);
               end;
          end
          else
              begin
                   New(dzialanie);
                   inc(IloscWskaznikow);
                   Lista^[IloscWskaznikow].ptr := dzialanie;
                   Lista^[IloscWskaznikow].Dlugosc := SizeOf(dzialanie^);

                   dzialanie^.wlasciciel:=OstatniaWartosc;
                   dzialanie^.Lewo:=Nil;
                   dzialanie^.Prawo:=Nil;
                   dzialanie^.Nazwa:=Ciagnawiasu;
                   dzialanie^.CoToJest:=JakiNawias;
                   WystapilyNawiasy := WystapilyNawiasy or (jakiNawias = Blokliczbowy);
              end;
     if OstatniaWartosc<>Nil
        then OstatniaWartosc^.Prawo:=dzialanie;
     GdzieJestem:=dzialanie;
end; {oblozwartosc}

procedure TMyCalc.ObslozZnak(CiagZnaku : String;var NaszElement,OstatniaWartosc,Wejscie,GdzieJestesmy:PDzialanie);
var Temp:PDzialanie;
label kolo;
begin
     New(Naszelement);
     inc(IloscWskaznikow);
     Lista^[IloscWskaznikow].ptr := Naszelement;
     Lista^[IloscWskaznikow].Dlugosc := SizeOf(Naszelement^);

     NaszElement^.nazwa:=CiagZnaku;
     NaszElement^.CoToJest:=Znak;
     Temp:=OstatniaWartosc;
     Kolo:
          if temp=Nil then
          begin
               Wejscie:=NaszElement;
               NaszElement^.Lewo:=GdzieJestesmy;
               NaszElement^.Prawo:=Nil;
               NaszElement^.Wlasciciel:=Nil;
          end else
          begin
               if CzyPriorytet(CiagZnaku,temp^.nazwa) then
               begin
                    While (temp <> Nil) and CzyPriorytet(CiagZnaku,temp^.nazwa)
                          do temp:=temp^.Wlasciciel;
                    gdziejestesmy:=temp;
                    if temp=Nil
                       then gdziejestesmy:=Wejscie;
                    GoTo Kolo;
               end else
               begin
                    NaszElement^.Wlasciciel:=temp;
                    NaszElement^.Lewo:=temp^.Prawo;
                    NaszElement^.Prawo:=Nil;
                    Temp^.Prawo:=NaszElement;
               end;
         end;
     OstatniaWartosc:=NaszElement;
     gdziejestesmy:=NaszElement;
end; {ObslozZnak}


function TMyCalc.DajDrzewo(Dzialanie : String) : PDzialanie;
var OstWart,we,dummy,GdzieJestem: PDzialanie;
    Elem:String;
    CoTo:TCoToJest;
    pozycja:Integer;
begin
     if WystapilBlad then Exit;
     pozycja:=1;
     we:=Nil;
     GdzieJestem:=Nil;
     ostwart:=Nil;
     DajDrzewo:=Nil;
     repeat
           WezElement(Dzialanie,pozycja,elem,coto);
           if not WystapilBlad
              then if coto=Znak
                      then ObslozZnak(Elem,dummy,Ostwart,we,GdzieJestem)
                      else ObslozWartosc(elem,coto,OstWart,dummy,GdzieJestem);
           DajDrzewo:=we;
     until (Pozycja>Length(dzialanie)) or WystapilBlad;
     if (we=nil) and not WystapilBlad then DajDrzewo:=GdzieJestem;
end;

Function TMyCalc.DajPrzelicznik(N: Integer;S:String):Longint;
 var I: Integer;
     C: Char;
     K,M: LongInt;
     l:longint;
begin
     L := 0; M := 1;
     for I := 0 to Length(s)-1 do
     begin
          C := S[Length(s)-I];
          if (C>='0') and (C<='9')
             then K := Ord(C)-48
             else if (C>='A') and (C<='F')
                     then K := ord(C)-55
                     else begin
                               Wystapilblad := True;
                               Exit;
                          end;
          if K > N - 1 then begin Wystapilblad := True; Exit; end;
          L := L + K * M;
          M := M * N;
     end;
     DajPrzelicznik := l;
end;

function TMyCalc.DajWartoscBloku(Blok: String): Longint;
var znak:Char;
    liczba:LongInt;
    i:integer;
    x:longint;
begin
     blok:=UpperCase(blok);
     {************************}
{     for i := 1 to IloscZmiennych do
     begin
          if blok = Zmienne^[i] then
          begin}
{               ObslugaZmiennej(blok,x);}
{               DajWartoscBloku := x;
               Exit;
          end;
     end;}
     {************************}
     if (blok[1] = '@') and (length(blok) > 2) and (blok[2] in ['H','B','O']) then
     begin
          znak := UpCase(blok[2]);
          Delete(blok, 1, 2);
          case znak of
            'H': liczba := DajPrzelicznik(16,blok);
            'B': liczba := DajPrzelicznik(2,blok);
            'O': liczba := DajPrzelicznik(8,blok);
          end;
          DajWartoscBloku := Liczba;
     end else
     begin
          if not ObslugaZmiennej(blok,x) then
          begin
{               blad := True;}
               DajBlad(ZlyIdentyfikator+' '+blok);
          end else DajWartoscBloku := x;
     end;
end;

Function TMyCalc.ObslugaZmiennej(var Zm:String;var Wart:longint):Boolean;
begin
     Wart := 0;
     ObslugaZmiennej := False;
end;
{
procedure TMyCalc.DodajParametr(Zm:String);
begin
     inc(IloscZmiennych);
     Zmienne^[IloscZmiennych] := UpperCase(zm);
end;
}
end.
