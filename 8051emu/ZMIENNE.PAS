Unit Zmienne;
interface
Uses Crt, Dos, Strings, Textoolz, Procki, Stale;
type PPamiecROM = ^TPamiecROM;
     TPamiecROM = array[$0000..$FFFE] of byte;
     PPamiecRAM = ^TPamiecRAM;
     TPamiecRAM = array[0..$FE] of byte;
     TTypPamieci = (tpROM, tpRAM, tpBit);
     TTypDanych = (tdByte, tdWord, tdBit);
     TNazwaSymbolu = array[1..MaxNazwaSymbolu+1] of Char;
     TSymbol = record
             Nazwa:TNazwaSymbolu;
             Adres:Word;
             TypPamieci:TTypPamieci;
     end;
     PTablicaSymboli = ^TTablicaSymboli;
     TTablicaSymboli = array[1..MaxSymboli] of TSymbol;
var
   {disassembler}
    Pozycja:Word;

   {emulator/debbuger}
    PamiecRAM:TPamiecRAM;
    PamiecROM:PPamiecROM;
    IloscCykli:LongInt;
    PC:Word;
    Symbole:PTablicaSymboli;
    IleSymboli:Word;
    Pulapki:array[1..MaxPulapek] of Word;
    IlePulapek:Word;
{    NaglaZmianaPC:Boolean;}
    WykonywaneIntHi, WykonywaneIntLo:Boolean;
    PoprzednieT0, PoprzednieT1, PoprzednieINT0, PoprzednieINT1:Boolean;
{    NazwaPlikuSymboli:String;}

    Czestotliwosc:Longint; {w Hz}
    WpisDoSBUF:Boolean;

{edytor bitowy}
var  DummyByte1:Byte;


procedure ZwolnijPamieciProcka;
procedure AlokujPamieciProcka;

implementation
uses nazwy;
procedure AlokujPamieciProcka;
begin
     New(PamiecRom);
end;
procedure ZwolnijPamieciProcka;
begin
     if PamiecRom <> nil then Dispose(PamiecRom);
end;


end.
