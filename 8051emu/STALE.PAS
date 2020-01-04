unit Stale;
interface
Uses Objects, Dialogs;
const
     cmKompilacjaPlik            = 10000;
     cmKompilacjaStatus          = 10001;
     cmKompilacjaPlatforma       = 10002;
     cmKompilacjaIloscLinii      = 10003;
     cmKompilacjaNumerLinii      = 10004;
     cmKompilacjaWolnejPamieci   = 10005;
     cmKompilacjaStatusKoncowy   = 10006;

Type TWskazniki = array[cmKompilacjaPlik..cmKompilacjaStatusKoncowy] of Pointer;

Type TAktywneOkno = (aoKod, aoRejestry, aoFlagi, aoStos);
Type TTypProcesora = (tp1051, tp2051, tp4051, tpAutora);
     TPrzelacznik = (pAllowMOVX, pAllowCutHiByte);
     TPrzelaczniki = set of TPrzelacznik;

Type PWymianaZKompilatorem = ^TWymianaZKompilatorem;
     TWymianaZKompilatorem = record
       IloscMakr:Word;
       IloscLinii:Word;
       IloscPlikow:Word;

       JestBlad:Boolean;
       LiniaBledu:Word;
       PlikBledu:String;
       OpisBledu:FNameStr;
       KodBledu:Word;

       MaxWskaznikStosu:Word;
       IloscStalych:Word;
       WielkoscKodu:Word;

       TypProcka:TTypProcesora;
       PlikWy:String;
       PlikSym:String;
       PlikWe:String;
     end;
{$i include\8051HELP.PAS}
{debugger}
const
     PlikINI               = 'emux051.ini';
     SygnaturaDSKSize      = 21;
     SygnaturaDSK          : String[SygnaturaDSKSize] = 'EmuX051 Desktop File'#26;
     MaxPulapek            = 32;
     MaxSymboli            = 512;
     MaxNazwaSymbolu       = 19;
     MaxParametrowMakra    = 10;
     MaxStosInclude        = 32;

{Stale do procki generujPrzerwanie}
     gpINT0                = 0;
     gpInt1                = 1;
     gpTF0                 = 2;
     gpTF1                 = 3;
     gpTI                  = 4;
     gpRI                  = 5;

{stale kontrolek w oknie przegladania i sledzenia kodu.
 Odpowiadaja rejestrom po prawej stronie okna}
     cmRejestrACC          = 2000;
     cmRejestrB            = 2001;
     cmRejestrDPTR         = 2002;
     cmRejestrPC           = 2003;
     cmPortP1              = 2004;
     cmPortP3              = 2005;
     cmRejestrR0           = 2006;
     cmRejestrR1           = 2007;
     cmRejestrR2           = 2008;
     cmRejestrR3           = 2009;
     cmRejestrR4           = 2010;
     cmRejestrR5           = 2011;
     cmRejestrR6           = 2012;
     cmRejestrR7           = 2013;
     cmWartoscSP           = 2014;
     cmRejestrSP           = 2015;
     cmWartoscSP1          = 2021;
     cmWartoscSP2          = 2022;
     cmWartoscSP3          = 2023;
     cmWartoscSP4          = 2024;
     cmWartoscSP5          = 2025;
     cmWartoscSP6          = 2026;
     cmWartoscSP7          = 2027;
     cmWartoscSP8          = 2028;
     cmWartoscSP9          = 2029;
     cmRejestrSBUF         = 2030;
     cmRejestrSCON         = 2031;
     cmRejestrTCON         = 2032;
     cmWartoscLicznikaT0   = 2033;
     cmWartoscLicznikaT1   = 2034;
     cmFlagaAC             = 2035;
     cmFlagaCY             = 2036;
     cmFlagaP              = 2037;
     cmFlagaOV             = 2038;
     cmFlagaF0             = 2039;
     cmFlagaUNDEF          = 2040;
     cmFlagaRS0            = 2041;
     cmFlagaRS1            = 2042;
     cmRejestrPCON         = 2043;
     cmRejestrTMOD         = 2044;
     cmRejestrIP           = 2045;
     cmRejestrIE           = 2046;
     cmPoziomLO            = 2047;
     cmPoziomHI            = 2048;
     cmLiczbaCykli         = 2049;

{Ilosc rejestrow w unicie REJ_ADR.PAS}
const
     MaxRejestrowWLiscieRejestrow = 21;
{i w pliku nazwy.pas}
     IloscWewnetrznychAdresowRejestrow = 21;

{identyfikatory MENU}
const
     cmListaOkien          =       1000;
     cmOProgramie          =       1001;
     cmKoniec              =       1002;
     cmWczytajROM          =       1003;
     cmZapiszRom           =       1004;
     cmWyczyscROM          =       1005;
     cmWczytajRam          =       1006;
     cmZapiszRam           =       1007;
     cmWyczyscRam          =       1008;
     cmResetProcka         =       1009;
     cmProcekKrok          =       100;
     cmProcekSledz         =       101;
     cmProcekUruchom       =       102;
     cmZerujCykle          =       1010;
     cmDodajUsunPulapke    =       103;
     cmUsunWszystkiePulapki=       1011;
     cmINT0                =       104;
     cmINT1                =       105;
     cmT0                  =       106;
     cmT1                  =       107;
     cmRI                  =       108;
     cmTI                  =       109;
     cmWczytajSymbole      =       1012;
     cmEdytujSymbole       =       1013;
     cmZapiszSymbole       =       1014;
     cmUsunWszystkieSymbole=       1015;
     cmKalkulator          =       1016;
     cmTabelaASCII         =       1017;
     cmOtworzOknoCPU       =       1018;
     cmEdytujROM           =       1019;
     cmEdytujRAM           =       1020;
     cmPokazSchowek        =       1021;
     cmOstatnioOtwartePliki=       1022;
     cmKompiluj            =       110;
     cmTypProcka           =       1023;
     cmPlikDomyslny        =       1024;
     cmBrakPlikuDomyslnego =       1025;
     cmKalendarz           =       1026;

{identyfikatory kontrolek w okienku z symbolami}
     cmEdytujSymbol        =       110;
     cmDodajSymbol         =       111;
     cmUsunSymbol          =       112;



{komunikaty wewn©trzne programu}
     cmZmianaZawartosciRAM              =  10001;
     cmZmianaZawartosciROM              =  10002;
     cmZmianaZawartosciTablicySymboli   =  10003;
     cmZmianaIlosciCykli                =  10004;


implementation
end.

