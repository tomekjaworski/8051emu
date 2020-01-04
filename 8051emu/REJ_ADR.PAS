unit rej_adr;
interface
uses textoolz, Stale;
Type
    TTypAdresu = (ta16, ta8);
    TBitRejestru = record
         Nazwa:String[6];
         Uzywany:Boolean;
    end;
    TRejestr = record
         Adres:Byte;
         Nazwa:String[6];
         OpisaneBity:Boolean;
         Bit0:TBitRejestru;
         Bit1:TBitRejestru;
         Bit2:TBitRejestru;
         Bit3:TBitRejestru;
         Bit4:TBitRejestru;
         Bit5:TBitRejestru;
         Bit6:TBitRejestru;
         Bit7:TBitRejestru;
    end;


var ListaRejestrow:array[1..MaxRejestrowWLiscieRejestrow] of TRejestr;
Function DajOpisRejestru(Adres:Byte; var Opis:Trejestr):Boolean;

{function Dec2BinB(b:byte):string;}

implementation

{function Dec2BinB(b:byte):string;
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
 }
Procedure InicjujRejestry;
begin
     with ListaRejestrow[1] do
     begin
          Adres := $D0;
          Nazwa := 'PSW';
          OpisaneBity := True;
          Bit0.Nazwa := 'P';
          Bit0.Uzywany := True;
          Bit1.Nazwa := '-';
          Bit1.Uzywany := True;
          Bit2.Nazwa := 'OV';
          Bit2.Uzywany := True;
          Bit3.Nazwa := 'RS0';
          Bit3.Uzywany := True;
          Bit4.Nazwa := 'RS1';
          Bit4.Uzywany := True;
          Bit5.Nazwa := 'F0';
          Bit5.Uzywany := True;
          Bit6.Nazwa := 'AC';
          Bit6.Uzywany := True;
          Bit7.Nazwa := 'CY';
          Bit7.Uzywany := True;
     end; {with ListaRejestrow[x]}


     with ListaRejestrow[2] do
     begin
          Adres := $89;
          Nazwa := 'TMOD';
          OpisaneBity := True;
          Bit0.Nazwa := 'M0';
          Bit0.Uzywany := True;
          Bit1.Nazwa := 'M1';
          Bit1.Uzywany := True;
          Bit2.Nazwa := 'C/T';
          Bit2.Uzywany := True;
          Bit3.Nazwa := 'GATE';
          Bit3.Uzywany := True;
          Bit4.Nazwa := 'M0';
          Bit4.Uzywany := True;
          Bit5.Nazwa := 'M1';
          Bit5.Uzywany := True;
          Bit6.Nazwa := 'C/T';
          Bit6.Uzywany := True;
          Bit7.Nazwa := 'GATE';
          Bit7.Uzywany := True;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[3] do
     begin
          Adres := $A8;
          Nazwa := 'IE';
          OpisaneBity := True;
          Bit0.Nazwa := 'EX0';
          Bit0.Uzywany := True;
          Bit1.Nazwa := 'ET0';
          Bit1.Uzywany := True;
          Bit2.Nazwa := 'EX1';
          Bit2.Uzywany := True;
          Bit3.Nazwa := 'ET1';
          Bit3.Uzywany := True;
          Bit4.Nazwa := 'ES';
          Bit4.Uzywany := True;
          Bit5.Nazwa := '';
          Bit5.Uzywany := False;
          Bit6.Nazwa := '';
          Bit6.Uzywany := False;
          Bit7.Nazwa := 'EA';
          Bit7.Uzywany := True;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[4] do
     begin
          Adres := $B8;
          Nazwa := 'IP';
          OpisaneBity := True;
          Bit0.Nazwa := 'PX0';
          Bit0.Uzywany := True;
          Bit1.Nazwa := 'PT0';
          Bit1.Uzywany := True;
          Bit2.Nazwa := 'PX1';
          Bit2.Uzywany := True;
          Bit3.Nazwa := 'PT1';
          Bit3.Uzywany := True;
          Bit4.Nazwa := 'PS';
          Bit4.Uzywany := True;
          Bit5.Nazwa := '';
          Bit5.Uzywany := False;
          Bit6.Nazwa := '';
          Bit6.Uzywany := False;
          Bit7.Nazwa := '';
          Bit7.Uzywany := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[5] do
     begin
          Adres := $98;
          Nazwa := 'SCON';
          OpisaneBity := True;
          Bit0.Nazwa := 'RI';
          Bit0.Uzywany := True;
          Bit1.Nazwa := 'TI';
          Bit1.Uzywany := True;
          Bit2.Nazwa := 'RB8';
          Bit2.Uzywany := True;
          Bit3.Nazwa := 'TB8';
          Bit3.Uzywany := True;
          Bit4.Nazwa := 'REN';
          Bit4.Uzywany := True;
          Bit5.Nazwa := 'SM2';
          Bit5.Uzywany := True;
          Bit6.Nazwa := 'SM1';
          Bit6.Uzywany := True;
          Bit7.Nazwa := 'SM0';
          Bit7.Uzywany := True;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[6] do
     begin
          Adres := $88;
          Nazwa := 'TCON';
          OpisaneBity := True;
          Bit0.Nazwa := 'IT0';
          Bit0.Uzywany := True;
          Bit1.Nazwa := 'IE0';
          Bit1.Uzywany := True;
          Bit2.Nazwa := 'IT1';
          Bit2.Uzywany := True;
          Bit3.Nazwa := 'IE1';
          Bit3.Uzywany := True;
          Bit4.Nazwa := 'TR0';
          Bit4.Uzywany := True;
          Bit5.Nazwa := 'TF0';
          Bit5.Uzywany := True;
          Bit6.Nazwa := 'TR1';
          Bit6.Uzywany := True;
          Bit7.Nazwa := 'TF1';
          Bit7.Uzywany := True;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[7] do
     begin
          Adres := $87;
          Nazwa := 'PCON';
          OpisaneBity := True;
          Bit0.Nazwa := 'IDL';
          Bit0.Uzywany := True;
          Bit1.Nazwa := 'PD';
          Bit1.Uzywany := True;
          Bit2.Nazwa := 'GF0';
          Bit2.Uzywany := True;
          Bit3.Nazwa := 'GF1';
          Bit3.Uzywany := True;
          Bit4.Nazwa := '';
          Bit4.Uzywany := False;
          Bit5.Nazwa := '';
          Bit5.Uzywany := False;
          Bit6.Nazwa := '';
          Bit6.Uzywany := False;
          Bit7.Nazwa := 'SMOD';
          Bit7.Uzywany := True;
     end; {with ListaRejestrow[x]}

     with ListaRejestrow[8] do
     begin
          Adres := $E0;
          Nazwa := 'ACC';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}

     with ListaRejestrow[9] do
     begin
          Adres := $F0;
          Nazwa := 'B';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[10] do
     begin
          Adres := $B0;
          Nazwa := 'P3';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[11] do
     begin
          Adres := $A0;
          Nazwa := 'P2';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[12] do
     begin
          Adres := $90;
          Nazwa := 'P1';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[13] do
     begin
          Adres := $80;
          Nazwa := 'P0';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[14] do
     begin
          Adres := $81;
          Nazwa := 'SP';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[15] do
     begin
          Adres := $82;
          Nazwa := 'DPL';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[16] do
     begin
          Adres := $83;
          Nazwa := 'DPH';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[17] do
     begin
          Adres := $99;
          Nazwa := 'SBUF';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[18] do
     begin
          Adres := $8A;
          Nazwa := 'TL0';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[19] do
     begin
          Adres := $8B;
          Nazwa := 'TL1';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[20] do
     begin
          Adres := $8C;
          Nazwa := 'TH0';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}
     with ListaRejestrow[21] do
     begin
          Adres := $8D;
          Nazwa := 'TH1';
          OpisaneBity := False;
     end; {with ListaRejestrow[x]}

end; {InicjujRejestry}

Function DajOpisRejestru(Adres:Byte; var Opis:Trejestr):Boolean;
var i:word;
begin
     DajOpisRejestru := False;
     Opis.Bit0.Nazwa := '';
     Opis.Bit0.Uzywany := true;
     Opis.Bit1.Nazwa := '';
     Opis.Bit1.Uzywany := true;
     Opis.Bit2.Nazwa := '';
     Opis.Bit2.Uzywany := true;
     Opis.Bit3.Nazwa := '';
     Opis.Bit3.Uzywany := true;
     Opis.Bit4.Nazwa := '';
     Opis.Bit4.Uzywany := true;
     Opis.Bit5.Nazwa := '';
     Opis.Bit5.Uzywany := true;
     Opis.Bit6.Nazwa := '';
     Opis.Bit6.Uzywany := true;
     Opis.Bit7.Nazwa := '';
     Opis.Bit7.Uzywany := true;
     OPis.OpisaneBity := False;
     for i := 1 to MaxRejestrowWLiscieRejestrow do
     begin
          if Adres = ListaRejestrow[i].Adres then
          begin
               Opis := ListaRejestrow[i];
               DajOpisRejestru := True;
               if not Opis.OpisaneBity then
               begin
                    Opis.Bit0.Nazwa := '';
                    Opis.Bit0.Uzywany := true;
                    Opis.Bit1.Nazwa := '';
                    Opis.Bit1.Uzywany := true;
                    Opis.Bit2.Nazwa := '';
                    Opis.Bit2.Uzywany := true;
                    Opis.Bit3.Nazwa := '';
                    Opis.Bit3.Uzywany := true;
                    Opis.Bit4.Nazwa := '';
                    Opis.Bit4.Uzywany := true;
                    Opis.Bit5.Nazwa := '';
                    Opis.Bit5.Uzywany := true;
                    Opis.Bit6.Nazwa := '';
                    Opis.Bit6.Uzywany := true;
                    Opis.Bit7.Nazwa := '';
                    Opis.Bit7.Uzywany := true;
                    Exit;
               end;
          end;
     end;
end;

begin
     InicjujRejestry;
end.
