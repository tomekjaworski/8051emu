unit k_zm; {Zmienne kompilatora}
interface
uses Crt, Dos, Textoolz, K_Typy, Stale;

var{ IloscAdresow:Word;
    Adresy:Pointer;}
    WielkoscKodu: Longint;
    TypProcka:TTypProcesora;
    IloscStalych:Word;
    ListaStalych:Pointer;
    JestBlad:Boolean;
    KodBledu:word;
    Ustawienia:TPrzelaczniki;
    IP:Word;
    OldIP:Word;
    Kalkulator:Tkalkulator;
    NieWykonujPrzeliczen:Boolean;
implementation


begin
{     Adresy := Nil;
     IloscAdresow := 0;}
     WielkoscKodu := 0;
     TypProcka := tp2051;
     IloscStalych := 0;
     ListaStalych := nil;
     NieWykonujPrzeliczen := False;
end.
