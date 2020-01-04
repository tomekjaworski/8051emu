Unit Nazwy;
interface
uses Procki, Textoolz, Zmienne, Stale, Symb;
const
      addrB              = $F0;
      addrACC            = $E0;
      addrPSW            = $D0;
      addrIP             = $B8;
      addrP3             = $B0;
      addrIE             = $A8;
      addrP2             = $A0;
      addrSCON           = $98;
      addrP1             = $90;
      addrTCON           = $88;
      addrP0             = $80;

      addrSBUF           = $99;
      addrTMOD           = $89;
      addrTL0            = $8A;
      addrTL1            = $8B;
      addrTH0            = $8C;
      addrTH1            = $8D;
      addrSP             = $81;
      addrDPL            = $82;
      addrDPH            = $83;
      addrPCON           = $87;


{Rejestr PSW}
      maskaC            = $80;
      maskaAC           = $40;
      maskaF0           = $20;
      maskaRS1          = $10;
      maskaRS0          = $08;
      maskaOV           = $04;
      maskaP            = $01;
      maskaRS0_RS1      = $18;
      maskaUNDEF        = $02;

      maskaPCON_SMOD    = $80;

      numerBituC        = 7;
      numerBituAC       = 6;
      numerBituF0       = 5;
      numerBituRS1      = 4;
      numerBituRS0      = 3;
      numerBituOV       = 2;
      numerBituP        = 0;

      addrR0            = $00;
      addrR1            = $01;
      addrR2            = $02;
      addrR3            = $03;
      addrR4            = $04;
      addrR5            = $05;
      addrR6            = $06;
      addrR7            = $07;

      maskaIE_EA        = $80;
      maskaIE_ES        = $10;
      maskaIE_ET1       = $08;
      maskaIE_EX1       = $04;
      maskaIE_ET0       = $02;
      maskaIE_EX0       = $01;

      maskaIP_PS        = $10;
      maskaIP_PT1       = $08;
      maskaIP_PX1       = $04;
      maskaIP_PT0       = $02;
      maskaIP_PX0       = $01;


      maskaSCON_TI      = $02;
      maskaSCON_RI      = $01;
      maskaSCON_TB8     = $08;
      maskaSCON_RB8     = $04;
      maskaSCON_REN     = $10;
      maskaSCON_SM2     = $20;
      maskaSCON_SM1     = $40;
      maskaSCON_SM0     = $80;
      maskaSCON_MODE    = $C0;

      maskaTCON_TF1     = $80;
      maskaTCON_TR1     = $40;
      maskaTCON_TF0     = $20;
      maskaTCON_TR0     = $10;
      maskaTCON_IT0     = $01;
      maskaTCON_IT1     = $04;
      maskaTCON_IE0     = $02;
      maskaTCON_IE1     = $08;

      maskaTMOD_GATE1   = $80;
      maskaTMOD_GATE0   = $08;
      maskaTMOD_CT1     = $40;
      maskaTMOD_CT0     = $04;
      maskaTMOD_M10_T1  = $30;
      maskaTMOD_M10_T0  = $03;

      maskaP3_INT0      = $04;
      maskaP3_INT1      = $08;
      maskaP3_T0        = $10;
      maskaP3_T1        = $20;

{const WewnetrzneAdresyRejestrow = [addrB, addrACC, addrPSW, addrIP, addrP3, addrIE, addrP2, addrSCON, addrP1,
addrTCON, addrP0, addrSBUF, addrTMOD, addrTL0, addrTL1, addrTH0, addrTH1,
addrSP, addrDPL, addrDPH, addrPCON];
}
const WewnetrzneAdresyRejestrow = [$80..$ff];

procedure DajNazweBitu(Kod:Byte; var n:string; SzukajWSymbolach:Boolean);
procedure DajNazweAdresu(Kod:Byte; var n:string);
function WyliczZRelokacji(Relok:ShortInt; DlugoscInstr:Byte):word;
Function DajAdresBanku:Byte;
Function DajNumerBanku:Byte;
Function DajDlugoscInstrukcji(Adres:Word):Byte;

implementation
uses Inst8051;

procedure DajNazweBitu(Kod:Byte; var n:string; SzukajWSymbolach:Boolean);
var Addr, Bit:Byte;
begin
     if kod in [$00..$7F] then
     begin
          bit := kod mod 8;
          addr := $20 + kod div 8;
     end else
     begin
          Addr := Kod and $F8;
          Bit := Kod and $07;
     end;
     case addr of
        addrB: n := 'B.'+Int2Str(Bit);
        addrACC: n := 'ACC.'+Int2Str(Bit);
        addrP0: n := 'P0.'+Int2Str(Bit);
        addrP1: n := 'P1.'+Int2Str(Bit);
        addrP2: n := 'P2.'+Int2Str(Bit);
        addrP3: n := 'P3.'+Int2Str(Bit);
        addrPSW:begin
                     n := 'PSW.';
                     case bit of
                        0: n := n + 'P';
                        1: n := n + '-';
                        2: n := n + 'OV';
                        3: n := n + 'RS0';
                        4: n := n + 'RS1';
                        5: n := n + 'F0';
                        6: n := n + 'AC';
                        7: n := n + 'CY';
                     end;
                end;
        addrIP:begin
                     n := 'IP.';
                     case bit of
                        0: n := n + 'PX0';
                        1: n := n + 'PT0';
                        2: n := n + 'PX1';
                        3: n := n + 'PT1';
                        4: n := n + 'PS';
                        5: n := n + '-';
                        6: n := n + '-';
                        7: n := n + '-';
                     end;
                end;
        addrIE:begin
                     n := 'IE.';
                     case bit of
                        0: n := n + 'EX0';
                        1: n := n + 'ET0';
                        2: n := n + 'EX1';
                        3: n := n + 'ET1';
                        4: n := n + 'ES';
                        5: n := n + '-';
                        6: n := n + '-';
                        7: n := n + 'EA';
                     end;
                end;
        addrSCON:begin
                     n := 'SCON.';
                     case bit of
                        0: n := n + 'RI';
                        1: n := n + 'TI';
                        2: n := n + 'RB8';
                        3: n := n + 'TB8';
                        4: n := n + 'REN';
                        5: n := n + 'SM2';
                        6: n := n + 'SM1';
                        7: n := n + 'SM0';
                     end;
                end;
        addrTCON:begin
                     n := 'TCON.';
                     case bit of
                        0: n := n + 'IT0';
                        1: n := n + 'IE0';
                        2: n := n + 'IT1';
                        3: n := n + 'IE1';
                        4: n := n + 'TR0';
                        5: n := n + 'TF0';
                        6: n := n + 'TR1';
                        7: n := n + 'TF1';
                     end;
                 end;
        addrTMOD:begin
                     n := 'TMOD.';
                     case bit of
                        0: n := n + 'M0';
                        1: n := n + 'M1';
                        2: n := n + 'C/T';
                        3: n := n + 'GATE';
                        4: n := n + 'M0';
                        5: n := n + 'M1';
                        6: n := n + 'C/T';
                        7: n := n + 'GATE';
                     end;
                end;
        else begin
                  n := Dec2hexBH(Addr)+'.'+Int2Str(Bit);
             end;
     end;
end;
Procedure DajNazweAdresu(Kod:Byte; var n:String);
begin
     n := '';
     case Kod of
          addrB      : n := 'B';
          addrACC    : n := 'ACC';
          addrPSW    : n := 'PSW';
          addrIP     : n := 'IP';
          addrP3     : n := 'P3';
          addrIE     : n := 'IE';
          addrSCON   : n := 'SCON';
          addrP1     : n := 'P1';
          addrTCON   : n := 'TCON';
          addrSBUF   : n := 'SBUF';
          addrTMOD   : n := 'TMOD';
          addrTL0    : n := 'TL0';
          addrTL1    : n := 'TL1';
          addrTH0    : n := 'TH0';
          addrTH1    : n := 'TH1';
          addrSP     : n := 'SP';
          addrDPL    : n := 'DPL';
          addrDPH    : n := 'DPH';
          addrPCON   : n := 'PCON';
          else n := {Dec2HexBH(Kod)} ZnajdzSymbolRAM(Kod);
     end;{case}
end;
function WyliczZRelokacji(Relok:ShortInt; DlugoscInstr:Byte):word;
var wyn:word;
begin
     wyn := Pozycja; {gdzie jest disassembler, czyli adres TEJ
                      instrukcji}
     inc(wyn,DlugoscInstr);
     wyn := wyn + Relok;
     WyliczZRelokacji := Wyn;
end;

Function DajAdresBanku:Byte;
begin
     DajAdresBanku := $08*((PamiecRAM[addrPSW] and maskaRS0_RS1) shr 3);
end;

Function DajNumerBanku:Byte;
begin
     DajNumerBanku := (PamiecRAM[addrPSW] and maskaRS0_RS1) shr 3;
end;

Function DajDlugoscInstrukcji(Adres:Word):Byte;
begin
     DajDlugoscInstrukcji := 1;
     if Adres = $FFFF then exit;
     DajDlugoscInstrukcji := Instrukcje[PamiecROM^[Adres]].Bajtow;
end;


end.
