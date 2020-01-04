unit k_procki;
interface
uses Crt, Dos, Textoolz, Zmienne, Procki, Strings, Nazwy, K_Errs, Gramat,
     Inst8051;

function TrimAll(const S: string): string;
Function KalkulujWartosc(Co:String;var Wyn:Word):Boolean;
Function DajAdresBitu(naz:string):Byte;
procedure WstawStandardoweStale;
Procedure generujBlad(Kod:Word);
Function DajNZRn(r:String):Byte;
Function DajIZRi(r:String):Byte;
Procedure usunSpacje(var s:string);
Function CzyZgodnosc(p:String;MaByc:TTypParametru):Boolean;
Function DajWielkoscParametrow_DlugoscParametru(p:TTypParametru):Byte;
Function DajWielkoscParametrow(p1,p2,p3:TTypParametru):Byte;

implementation
uses k_zm, k_typy;

Function CzyZgodnosc(p:String;MaByc:TTypParametru):Boolean;
var i:byte;
    n:TNazwaDanej;
    dummy:word;
    poz:byte;
    Wyn:Boolean;
begin
     CzyZgodnosc := False;
     p := TrimAll(UpperCase(p));
     for i := 1 to Length(p) do
         if p[i] = ' ' then Delete(p, i, 1);

     case MaByc of
        tprACC: begin
                     if (p = 'ACC') or (p = 'A')
                        then CzyZgodnosc := true;
                end;
         tprRn: begin
                     if (p[0] = #2) and (p[1] = 'R') and (p[2] in ['0'..'7'])
                        then CzyZgodnosc := true;
                end;
         tprRi: begin
                     if (p[0] = #3) and (p[1] = '@') and (p[2] = 'R') and (p[3] in ['0'..'1'])
                        then CzyZgodnosc := true;
                end;
    tprRamAddr: begin
                     if p[1] = '#' then Exit;
                     CzyZgodnosc := KalkulujWartosc(p,Dummy);
                end;
     tprData8, tprData16:
                begin
                     if p[1] = '#' then
                     begin
                          Delete(p,1,1);
                          if KalkulujWartosc(p,dummy)
                             then CzyZgodnosc := true;
                     end;
                end;
         tprAB: begin
                     if p = 'AB' then CzyZgodnosc := true;
                end;
       tprDPTR: begin
                     if p = 'DPTR' then CzyZgodnosc := True;
                end;
   tprPtrADPTR: begin
                     if (p = '@A+DPTR') or (p = '[A+DPTR]') then CzyZgodnosc := True;
                end;
      tprPtrAPC: begin
                     if (p = '@A+PC') or (p = '[A+PC]') then CzyZgodnosc := True;
                end;
     tprPtrDPTR: begin
                     if (p = '@DPTR') or (p = '[DPTR]') then CzyZgodnosc := True;
                end;
           tprC: begin
                     if p = 'C' then CzyZgodnosc := True;
                end;
         tprBit: begin
                     if p[1] in ['/','!'] then exit;
                     poz := Pos('.',p);
                     if poz = 0 {numer bitu, 00h - 7Fh} then
                     begin
                          Wyn := KalkulujWartosc(p, dummy);
                          CzyZgodnosc := Wyn{ and (Dummy >= $00)
                                             and (Dummy <= $7F)}
                     end else
                     begin
                          Wyn := KalkulujWartosc(copy(p, 1, poz-1), dummy);
                          wyn := wyn and ((Dummy >= $20) and (Dummy <= $2F) or
                                         ((Dummy and $F0 >= $80) and (Dummy and $F0 <= $F0)
                                          and (Dummy and $8 in [0, 8])));
                          wyn := wyn and KalkulujWartosc(copy(p, poz+1, ord(p[0])), dummy);
                          CzyZgodnosc := Wyn and (Dummy >= 0)
                                             and (Dummy <= 7);
                     end;

                end;
      tprNegBit: begin
                     if p[1] in ['/','!'] then
                     begin
                          Delete(p,1,1);
                          if CzyZgodnosc(p, tprBit)
                             then CzyZgodnosc := True;
                     end;
                end;
    tprNieznany: begin
                     if p = '' then CzyZgodnosc := True;
                end;
     tprCode8, tprCode11, tprCode16:
                begin
                     if KalkulujWartosc(p,dummy)
                        then CzyZgodnosc := true;
                end;
     end;
end;


Procedure usunSpacje(var s:string);
var i:byte;
begin
     for i := 1 to ord(s[0]) do
         if s[i] = ' ' then Delete(s, i,1);
end;


Procedure generujBlad(Kod:Word);
begin
     if jestBlad then exit;
     jestBlad := true;
     KodBledu := Kod;
end;

function TrimAll(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  if I > L then TrimAll := '' else
  begin
    while S[L] <= ' ' do Dec(L);
    TrimAll := Copy(S, I, L - I + 1);
  end;
end;

Function KalkulujWartosc(Co:String;var Wyn:Word):Boolean;
var Wynik:longint;
    n:TNazwaDanej;
    p:PDana;
begin
     if co[1] = '#' then Delete(co,1,1);

     if not NieWykonujPrzeliczen then
     begin
          Kalkulator.Create;
          Kalkulator.UstawRownanie(Co);
          Kalkulator.Kalkuluj;
          Wyn := Kalkulator.Wynik;

          KalkulujWartosc := not Kalkulator.WystapilBlad;

          Kalkulator.Destroy;
     end else
     begin
          Wyn := 0;
          KalkulujWartosc := False;
          if Konwersja32Norm(co, wynik) then
          begin
               Wyn := Wynik;
               KalkulujWartosc := true;
               Exit;
          end;
          if co = '$' then
          begin
               wyn := OldIP;
               KalkulujWartosc := True;
               exit;
          end;
          {to nie jest liczba, wiec moze stala ?}
          p := ZnajdzStala(co);
          if p = nil then exit;
          Wyn := p^.Wartosc;
          KalkulujWartosc := True;
     end;
end;

Function DajAdresBitu(naz:string):Byte;
var p:byte;
    w:word;
    adres,bit:string;
    a,b:byte;
begin
     Naz := UpperCase(Naz);
     DajAdresBitu := 0;
     if naz[1] in ['!', '/'] then Delete(naz, 1, 1);
     p := pos('.',naz);
     if p = 0 then {wartosc bezwzgledna}
     begin
          KalkulujWartosc(naz,w);
          DajAdresBitu := w;
          Exit;
          {tu ka¾dy bit rejestr¢w SFR ma swoj¥ wag©}
     end;
     Adres := TrimAll(Copy(naz,1,p-1));
     Bit := TrimAll(Copy(naz,p+1,ord(naz[0])));
     KalkulujWartosc(Adres,w); a := w;
     KalkulujWartosc(Bit,w); b := w;
     b := b and $07;
     if a in [$20..$2f] then {blok 16-bitowy po banku rejestrow RB3}
     begin
          Dec(a,$20);
          a := a shl 3;
          a := a + b;
          DajAdresBitu := a;
     end else
     begin
          {format AAAAABBB }
          if (A and $07) <> 0 then
          begin
               GenerujBlad(errNiewlasciweAdresowanieBitowe);
               Exit;
          end;
          a := a and $F8;
          a := a or b;
          DajAdresBitu := a;
     end;
end;

procedure WstawStandardoweStale;
begin
     {rejestry}
     DodajStala('ACC',tdByte,addrACC,tpRam);
     DodajStala('B',tdByte,addrB,tpRam);
     DodajStala('PSW',tdByte,addrPSW,tpRam);
     DodajStala('IP',tdByte,addrIP,tpRam);
     DodajStala('P3',tdByte,addrP3,tpRam);
     DodajStala('IE',tdByte,addrIE,tpRam);
     DodajStala('SCON',tdByte,addrSCON,tpRam);
     DodajStala('SBUF',tdByte,addrSBUF,tpRam);
     DodajStala('P1',tdByte,addrP1,tpRam);
     DodajStala('TCON',tdByte,addrTCON,tpRam);
     DodajStala('SP',tdByte,addrSP,tpRam);
     DodajStala('DPL',tdByte,addrDPL,tpRam);
     DodajStala('DPH',tdByte,addrDPH,tpRam);
     DodajStala('TL0',tdByte,addrTL0,tpRam);
     DodajStala('TL1',tdByte,addrTL1,tpRam);
     DodajStala('TH0',tdByte,addrTH0,tpRam);
     DodajStala('TH1',tdByte,addrTH1,tpRam);
     DodajStala('PCON',tdByte,addrPCON,tpRam);
     DodajStala('TMOD',tdByte,addrTMOD,tpRam);
     {bity}
     DodajStala('TF1',tdByte,addrTCON or 7,tpBit);
     DodajStala('TR1',tdByte,addrTCON or 6,tpRam);
     DodajStala('TF0',tdByte,addrTCON or 5,tpRam);
     DodajStala('TR0',tdByte,addrTCON or 4,tpRam);
     DodajStala('IE1',tdByte,addrTCON or 3,tpRam);
     DodajStala('IT1',tdByte,addrTCON or 2,tpRam);
     DodajStala('IE0',tdByte,addrTCON or 1,tpRam);
     DodajStala('IT0',tdByte,addrTCON or 0,tpRam);

     DodajStala('EA', tdByte,addrIE or 7,tpRam);
     DodajStala('ES', tdByte,addrIE or 4,tpRam);
     DodajStala('ET1',tdByte,addrIE or 3,tpRam);
     DodajStala('EX1',tdByte,addrIE or 2,tpRam);
     DodajStala('ET0',tdByte,addrIE or 1,tpRam);
     DodajStala('EX0',tdByte,addrIE or 0,tpRam);

     DodajStala('PS', tdByte,addrIP or 4,tpRam);
     DodajStala('PT1',tdByte,addrIP or 3,tpRam);
     DodajStala('PX1',tdByte,addrIP or 2,tpRam);
     DodajStala('PT0',tdByte,addrIP or 1,tpRam);
     DodajStala('PX0',tdByte,addrIP or 0,tpRam);

     DodajStala('CY', tdByte,addrPSW or 7,tpRam);
     DodajStala('AC', tdByte,addrPSW or 6,tpRam);
     DodajStala('F0', tdByte,addrPSW or 5,tpRam);
     DodajStala('RS1',tdByte,addrPSW or 4,tpRam);
     DodajStala('RS0',tdByte,addrPSW or 3,tpRam);
     DodajStala('OV', tdByte,addrPSW or 2,tpRam);
     DodajStala('F1', tdByte,addrPSW or 1,tpRam);
     DodajStala('P',  tdByte,addrPSW or 0,tpRam);
end;

Function DajNZRn(r:String):Byte;
begin
     r := UpperCase(TrimAll(R));
     DajNZRn := (Ord(r[2])-48) and $07;
end;

Function DajIZRi(r:String):Byte;
begin
     r := UpperCase(TrimAll(R));
     DajIZRi := (Ord(r[3])-48) and $01;
end;

Function DajWielkoscParametrow_DlugoscParametru(p:TTypParametru):Byte;
begin
     case p of
       tprNieznany: DajWielkoscParametrow_DlugoscParametru := 0;
            tprACC: DajWielkoscParametrow_DlugoscParametru := 0;
             tprRi: DajWielkoscParametrow_DlugoscParametru := 0;
             tprRn: DajWielkoscParametrow_DlugoscParametru := 0;
       tprPtrADPTR: DajWielkoscParametrow_DlugoscParametru := 0;
         tprPtrAPC: DajWielkoscParametrow_DlugoscParametru := 0;
           tprDPTR: DajWielkoscParametrow_DlugoscParametru := 0;
              tprC: DajWielkoscParametrow_DlugoscParametru := 0;
             tprAB: DajWielkoscParametrow_DlugoscParametru := 0;
        tprPtrDPTR: DajWielkoscParametrow_DlugoscParametru := 0;
         tprNegBit: DajWielkoscParametrow_DlugoscParametru := 1;
         tprCode11: DajWielkoscParametrow_DlugoscParametru := 1;
        tprRamAddr: DajWielkoscParametrow_DlugoscParametru := 1;
            tprBit: DajWielkoscParametrow_DlugoscParametru := 1;
          tprCode8: DajWielkoscParametrow_DlugoscParametru := 1;
          tprData8: DajWielkoscParametrow_DlugoscParametru := 1;
         tprData16: DajWielkoscParametrow_DlugoscParametru := 2;
         tprCode16: DajWielkoscParametrow_DlugoscParametru := 2;
     end;
end;

Function DajWielkoscParametrow(p1,p2,p3:TTypParametru):Byte;
begin
     DajWielkoscParametrow := DajWielkoscParametrow_DlugoscParametru(p1)+
                              DajWielkoscParametrow_DlugoscParametru(p2)+
                              DajWielkoscParametrow_DlugoscParametru(p3);
end;



end.
