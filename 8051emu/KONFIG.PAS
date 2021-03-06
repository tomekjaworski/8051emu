unit Konfig;
{Tutaj zawarte s� zmienne konfiguruj�ce program, a tak�e
 procedury odpowiadaj�ce za ich wczytywanie i zapisaywanie
}
interface
Uses Objects, Zmienne, Stale;
type PKonfiguracja = ^TKonfiguracja;
     TKonfiguracja = record
        UkryjAdresyWewnetrzne:Boolean; {Okno eydcji symboli. Je�eli jest
        warto�� TRUE, to do listy nie dodawane s� symbole PSW, ACC, TH0...}
        DodawajDoListySymboliAdresyWewnetrzne:Boolean;
        OstatniaNazwaPlikuSymboli:FNameStr;
        OstatniaNazwaPlikuROM:FNameStr;
        OstatniaNazwaPlikuRAM:FNameStr;
        WielkoscPamieciROMBranaPodUwagePrzyZapisie:Word;
        WielkoscPamieciROMBranaPodUwagePrzyOdczycie:Word;
        WielkoscPamieciRAMBranaPodUwagePrzyZapisie:Word;
        WielkoscPamieciRAMBranaPodUwagePrzyOdczycie:Word;
        AnimacjaWTrybieSymulacji:Boolean;

{kompilator}
        TypProcesora:TTypProcesora;
     end;
var Cfg:TKonfiguracja;
implementation
begin
     Cfg.UkryjAdresyWewnetrzne := False;
{��������������������������������������}
{��������������������������������������}
{Parametry konfigurowalne przez uzytkownika}
     Cfg.DodawajDoListySymboliAdresyWewnetrzne :=False;
     Cfg.OstatniaNazwaPlikuSymboli := '*.sym';
     Cfg.WielkoscPamieciROMBranaPodUwagePrzyZapisie := $FFFF;
     Cfg.WielkoscPamieciROMBranaPodUwagePrzyOdczycie := $FFFF;
     Cfg.WielkoscPamieciRAMBranaPodUwagePrzyZapisie := SizeOf(TPamiecRAM);
     Cfg.WielkoscPamieciRAMBranaPodUwagePrzyOdczycie := SizeOf(TPamiecRAM);
     Cfg.AnimacjaWTrybieSymulacji := TRUE;
     Cfg.TypProcesora := tp2051;
{��������������������������������������}
{��������������������������������������}
end.
