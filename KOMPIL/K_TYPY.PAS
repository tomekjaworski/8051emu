unit k_typy;
interface
uses K_procki, Textoolz, Procki, Zmienne, MyCalc, Inst8051;

type PKalkulator = ^TKalkulator;
     TKalkulator = object(TMyCalc)
       Function ObslugaZmiennej(var Zm:String;var Wart:longint):Boolean; virtual;
     end;


{Opis: tpACC - A         tpRn - R1-R7      tpRi - @R0 @R1 tpDirect - 12H
       tpData - #12h     tpAB - AB         tpDPTR - DPTR  tpADPTR - @A+DPTR
       tpAPC - @A+PC     tpDPTRptr - @DPTR tpC - C        tpBit - 2Fh.1
       tpNegBit - /2Fh.1 tpAddr - 01234H

       Zamiast negacji (/) mo¾na zastosowa† ! (z C/C++)
}
implementation
uses gramat,k_zm;

Function TKalkulator.ObslugaZmiennej(var Zm:String;var Wart:longint):Boolean;
var ptr:PDana;
begin
     if zm = '$' then
     begin
          Wart := OldIP;
          ObslugaZmiennej := True;
          Exit;
     end;
     ptr := ZnajdzStala(zm);
     if ptr = nil then
     begin
          Wart := 0;
          ObslugaZmiennej := False;
          Exit;
     end;
     Wart := ptr^.Wartosc;
     ObslugaZmiennej := True;
end;

end.
