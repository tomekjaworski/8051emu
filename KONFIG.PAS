unit Konfig;
{Tutaj zawarte sҐ zmienne konfigurujҐce program, a takѕe
 procedury odpowiadajҐce za ich wczytywanie i zapisaywanie
}
interface
Uses Objects, Zmienne, Stale;
type PKonfiguracja = ^TKonfiguracja;
     TKonfiguracja = record
        UkryjAdresyWewnetrzne:Boolean; {Okno eydcji symboli. Jeѕeli jest
        warto† TRUE, to do listy nie dodawane sҐ symbole PSW, ACC, TH0...}
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
{ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ}
{ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ}
{Parametry konfigurowalne przez uzytkownika}
     Cfg.DodawajDoListySymboliAdresyWewnetrzne :=False;
     Cfg.OstatniaNazwaPlikuSymboli := '*.sym';
     Cfg.WielkoscPamieciROMBranaPodUwagePrzyZapisie := $FFFF;
     Cfg.WielkoscPamieciROMBranaPodUwagePrzyOdczycie := $FFFF;
     Cfg.WielkoscPamieciRAMBranaPodUwagePrzyZapisie := SizeOf(TPamiecRAM);
     Cfg.WielkoscPamieciRAMBranaPodUwagePrzyOdczycie := SizeOf(TPamiecRAM);
     Cfg.AnimacjaWTrybieSymulacji := TRUE;
     Cfg.TypProcesora := tp2051;
{ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ}
{ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ}
end.
