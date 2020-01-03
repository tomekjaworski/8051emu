Function GenerujPrzerwanie(Numer:Byte;ZnakazuUzytkownika:Boolean):Boolean;
var IE, IP:Byte;
    NoweInt:Byte;
begin
     GenerujPrzerwanie := False;
     ie := pamiecRAM[addrIE];
     ip := pamiecRAM[addrIP];

     if ie and maskaIE_EA = 0 then Exit;

     {sprawdzamy, czy dane przerwanie jest dozwolone}
     case Numer of
          gpINT0: if ie and maskaIE_EX0 = 0 then exit;
          gpINT1: if ie and maskaIE_EX1 = 0 then exit;
           gpTF0: if ie and maskaIE_ET0 = 0 then exit;
           gpTF1: if ie and maskaIE_ET1 = 0 then exit;
      gpRI, gpTI: if ie and maskaIE_ES  = 0 then exit;
     end;

     {teraz sprawdzimy priorytety}
     NoweInt := 0;
     case Numer of
          gpINT0: if ip and maskaIP_PX0 <> 0 then NoweInt := 1;
          gpINT1: if ip and maskaIP_PX1 <> 0 then NoweInt := 1;
           gpTF0: if ip and maskaIP_PT0 <> 0 then NoweInt := 1;
           gpTF1: if ip and maskaIP_PT1 <> 0 then NoweInt := 1;
      gpRI, gpTI: if ip and maskaIP_PS  <> 0 then NoweInt := 1;
     end;


     {Nowe przerwanie ma priorytet niski a wykonujamy juz jakies INT}
     if (NoweInt = 0) and (WykonywaneIntHi or WykonywaneIntLo) then Exit;
     {nowe przerwanie na prior. wysokim a wykonujemy juz wysokie}
     if (NoweInt = 1) and WykonywaneIntHi then exit;

     {Jak jestesmy tutaj, to mozemy wykonac przerwanie}
     Inc(IloscCykli, 2);
     if NoweInt = 0 then WykonywaneIntLo := True
                    else WykonywaneIntHi := True;

     {zapis PC}
     Inc(PamiecRAM[addrSP]);
     PamiecRAM[PamiecRAM[addrSP]] := Lo(PC);
     Inc(PamiecRAM[addrSP]);
     PamiecRAM[PamiecRAM[addrSP]] := Hi(PC);

     case Numer of
          gpINT0: begin
                       PC := $0003;
                  end;
          gpINT1: begin
                       PC := $0013;
                  end;
           gpTF0: begin
                       if Not ZNakazuUzytkownika
                          then PamiecRAM[addrTCON] := PamiecRAM[addrTCON] and (not Byte(maskaTCON_TF0));
                       PC := $000B;
                  end;
           gpTF1: begin
                       if Not ZNakazuUzytkownika
                          then PamiecRAM[addrTCON] := PamiecRAM[addrTCON] and (not Byte(maskaTCON_TF1));
                       PC := $001B;
                  end;
            gpRI: begin
                       PC := $0023;
                       if ZNakazuUzytkownika
                          then PamiecRAM[addrSCON] := PamiecRAM[addrSCON] or maskaSCON_RI;
                  end;
            gpTI: begin
                       if ZnakazuUzytkownika
                          then PamiecRAM[addrSCON] := PamiecRAM[addrSCON] or maskaSCON_TI;
                       PC := $0023;
                  end;
     end;
     generujPrzerwanie := True;
{     NaglaZmianaPC := True;}
end;

Procedure WjedzWPrzerwanie(Numer:Byte);
var IE, IP:Byte;
    NoweInt:Byte;
begin
     ie := pamiecRAM[addrIE];
     ip := pamiecRAM[addrIP];

     if ie and maskaIE_EA = 0 then Exit;

     {sprawdzamy, czy dane przerwanie jest dozwolone}
     case Numer of
          gpINT0: if ie and maskaIE_EX0 = 0 then exit;
          gpINT1: if ie and maskaIE_EX1 = 0 then exit;
           gpTF0: if ie and maskaIE_ET0 = 0 then exit;
           gpTF1: if ie and maskaIE_ET1 = 0 then exit;
      gpRI, gpTI: if ie and maskaIE_ES  = 0 then exit;
     end;

     {teraz sprawdzimy priorytety}
     NoweInt := 0;
     case Numer of
          gpINT0: if ip and maskaIP_PX0 <> 0 then NoweInt := 1;
          gpINT1: if ip and maskaIP_PX1 <> 0 then NoweInt := 1;
           gpTF0: if ip and maskaIP_PT0 <> 0 then NoweInt := 1;
           gpTF1: if ip and maskaIP_PT1 <> 0 then NoweInt := 1;
      gpRI, gpTI: if ip and maskaIP_PS  <> 0 then NoweInt := 1;
     end;


     {Nowe przerwanie ma priorytet niski a wykonujamy juz jakies INT}
     if (NoweInt = 0) and (WykonywaneIntHi or WykonywaneIntLo) then Exit;
     {nowe przerwanie na prior. wysokim a wykonujemy juz wysokie}
     if (NoweInt = 1) and WykonywaneIntHi then exit;

     {Jak jestesmy tutaj, to mozemy wykonac przerwanie}
     Inc(IloscCykli, 2);
     if NoweInt = 0 then WykonywaneIntLo := True
                    else WykonywaneIntHi := True;

     {zapis PC}
     Inc(PamiecRAM[addrSP]);
     PamiecRAM[PamiecRAM[addrSP]] := Lo(PC);
     Inc(PamiecRAM[addrSP]);
     PamiecRAM[PamiecRAM[addrSP]] := Hi(PC);

     case Numer of
          gpINT0: begin
                       PC := $0003;
                  end;
          gpINT1: begin
                       PC := $0013;
                  end;
           gpTF0: begin
                       PC := $000B;
                  end;
           gpTF1: begin
                       PC := $001B;
                  end;
            gpRI: begin
                       PC := $0023;
                       PamiecRAM[addrSCON] := PamiecRAM[addrSCON] or maskaSCON_RI;
                  end;
            gpTI: begin
                       PamiecRAM[addrSCON] := PamiecRAM[addrSCON] or maskaSCON_TI;
                       PC := $0023;
                  end;
     end;
{     NaglaZmianaPC := True;}
end;

Procedure ZwiekszT0T1_IWygenerujOdpowiedniePrzerwania;
var Tcon, tmod, p3:Byte;
    Gate0, gate1, Ct0, Ct1,Int0, Int1, tr0, tr1, it0, it1:boolean;
    t0, t1:Boolean;
    Mode0, Mode1:Byte;
    ZwiekszDlaWejscia, ZwiekszDlaOscylatora:Boolean;
    TrybRS, SCon:Byte;

begin
     TCON := PamiecRAM[addrTCON];
     TMOD := PamiecRAM[addrTMOD];
     SCON := PamiecRAM[addrSCON];
     p3 := PamiecRAM[addrP3];
     tr0 := Boolean(TCON and maskaTCON_TR0);
     tr1 := Boolean(TCON and maskaTCON_TR1);
     Gate1 := Boolean(TMOD and maskaTMOD_GATE1);
     Gate0 := Boolean(TMOD and maskaTMOD_GATE0);
     Ct1 := Boolean(TMOD and maskaTMOD_CT1);
     Ct0 := Boolean(TMOD and maskaTMOD_CT0);
     Mode0 := TMOD and maskaTMOD_M10_T0;
     Mode1 := (TMOD and maskaTMOD_M10_T1) shr 4;
     t0 := Boolean(p3 and maskaP3_T0);
     t1 := Boolean(p3 and maskaP3_T1);
     int0 := Boolean(p3 and maskaP3_INT0);
     int1 := Boolean(p3 and maskaP3_INT1);
     it0 := Boolean(tcon and maskaTCON_IT0);
     it1 := Boolean(tcon and maskaTCON_IT1);

     TrybRS := (scon and maskaSCON_MODE) shr 6;

     {Testujemy pinty T0 i T1 na opadajace zbocze}
     if (not t0) and PoprzednieT0 then T0 := True
                                  else T0 := False;
     if (not t1) and PoprzednieT1 then T1 := True
                                  else T1 := False;
     {wartosci true/false daja informacje, czy wogole byl impuls na pinie}


     {Rozpatrujemy licznik T0}

     if Mode0 = 3 then
     begin
          {rozpatrujemy TH0}
          if tr1 then
          begin
               inc(PamiecRAM[addrTH0]);
               if PamiecRAM[addrTH0] = 0 {przepelnienie licznika}
                  then PamiecRAM[addrTCON] := PamiecRAM[addrTCON] or maskaTCON_TF1;
          end;
          if tr0 then
          begin
               ZwiekszDlaWejscia := ((not gate0) or int0) and t0 and ct0;
               ZwiekszDlaOscylatora := ((not gate0) or int0) and (not ct0);
               if ZwiekszDlawejscia or ZwiekszDlaOscylatora then
               begin
                    inc(PamiecRAM[addrTL0]);

                    if PamiecRAM[addrTL0] = 0
                       then PamiecRAM[addrTCON] := PamiecRAM[addrTCON] or maskaTCON_TF0;
               end;
          end;
     end {mode0 = 3} else
     begin
          ZwiekszDlaWejscia := ((not gate0) or int0) and t0 and ct0 and tr0;
          ZwiekszDlaOscylatora := ((not gate0) or int0) and (not ct0) and tr0;
          if ZwiekszDlaWejscia or ZwiekszDlaOscylatora then
          begin
               {tryb 0}
               if Mode0 = 0 then
               begin
                    {TL - 5 bitow, TH - 8 bitow}
                    inc(PamiecRAM[addrTL0]);
                    if PamiecRAM[addrTL0] and $1F {5 bitow} = 0 then
                    begin  {preskaler przepelniony}
                         inc(PamiecRAM[addrTH0]);
                         PamiecRAM[addrTL0] := 0;
                         if PamiecRAM[addrTH0] = 0 {przepelnienie licznika}
                            then PamiecRAM[addrTCON] := PamiecRAM[addrTCON] or maskaTCON_TF0;
                            {ustawilismy flage TCON.TF0}
                    end;
               end;
               {tryb 1}
               if Mode0 = 1 then
               begin
                    {TL - 8 bitow, TH - 8 bitow}
                    inc(PamiecRAM[addrTL0]);
                    if PamiecRAM[addrTL0] = 0 then
                    begin
                         inc(PamiecRAM[addrTH0]);
                         if PamiecRAM[addrTH0] = 0 {przepelnienie licznika}
                            then PamiecRAM[addrTCON] := PamiecRAM[addrTCON] or maskaTCON_TF0;
                                 {ustawilismy flage TCON.TF0}
                    end;
               end;
               {tryb 2}
               if Mode0 = 2 then
               begin
                    {TL - 8 bitow (liczy), TH - 8 bitow(wpisowe)}
                    inc(PamiecRAM[addrTL0]);
                    if PamiecRAM[addrTL0] = 0 then
                    begin
                         PamiecRAM[addrTCON] := PamiecRAM[addrTCON] or maskaTCON_TF0;
                         {ustawilismy flage TCON.TF0}
                         PamiecRAM[addrTL0] := PamiecRAM[addrTH0];
                    end;
               end;
          end;
     end; {mode0 <> 3}


     if (Mode1 <> 3) and (Mode0 <> 3) then {W trybie 3 T1 jest zatrzymany}
     begin
          {Rozpatrujemy licznik T1}
          ZwiekszDlaWejscia := ((not gate1) or int1) and t1 and ct1 and tr1;
          ZwiekszDlaOscylatora := ((not gate1) or int1) and (not ct1) and tr1;

          if ZwiekszDlaWejscia or ZwiekszDlaOscylatora then
          begin
               {tryb 0}
               if Mode1 = 0 then
               begin
                    {TL - 5 bitow, TH - 8 bitow}
                    inc(PamiecRAM[addrTL1]);
                    if PamiecRAM[addrTL1] and $1F {5 bitow} = 0 then
                    begin  {preskaler przepelniony}
                         inc(PamiecRAM[addrTH1]);
                         PamiecRAM[addrTL1] := 0;
                         if PamiecRAM[addrTH1] = 0 {przepelnienie licznika}
                            then PamiecRAM[addrTCON] := PamiecRAM[addrTCON] or maskaTCON_TF1;
                                 {ustawilismy flage TCON.TF1}
                    end;
               end;
               {tryb 1}
               if Mode1 = 1 then
               begin
                    {TL - 8 bitow, TH - 8 bitow}
                    inc(PamiecRAM[addrTL1]);
                    if PamiecRAM[addrTL1] = 0 then
                    begin
                         inc(PamiecRAM[addrTH1]);
                         if PamiecRAM[addrTH1] = 0 {przepelnienie licznika}
                            then PamiecRAM[addrTCON] := PamiecRAM[addrTCON] or maskaTCON_TF1;
                                 {ustawilismy flage TCON.TF1}
                    end;
               end;
               {tryb 2}
               if Mode1 = 2 then
               begin
                    {TL - 8 bitow (liczy), TH - 8 bitow(wpisowe)}
                    inc(PamiecRAM[addrTL1]);
                    if PamiecRAM[addrTL1] = 0 then
                    begin
                         PamiecRAM[addrTCON] := PamiecRAM[addrTCON] or maskaTCON_TF1;
                         {ustawilismy flage TCON.TF1}
                         PamiecRAM[addrTL1] := PamiecRAM[addrTH1];
                    end;
               end;
          end;
     end; {(Mode1 <> 3) and (Mode0 <> 3)}

     PoprzednieT0 := Boolean(p3 and maskaP3_T0);
     PoprzednieT1 := Boolean(p3 and maskaP3_T1);


{  it0:=boolean(tcon and 1);   { 0-poziom, 1-zbocze }
{  it1:=boolean(tcon and 4);}
  if it0 then   { reakcja na zbocze opadaj¥ce INT0 }
  begin
    if PoprzednieInt0 and (not int0)
       then PamiecRAM[addrTCON] := PamiecRAM[addrTCON] or maskaTCON_IE0{ IE0=1 }
       else PamiecRAM[addrTCON] := PamiecRAM[addrTCON] and (not maskaTCON_IE0);  { IE0=0 }
  end else      { reakcja na niski poziom INT0 }
    if not int0
       then PamiecRAM[addrTCON]:=PamiecRAM[addrTCON] or maskaTCON_IE0 { IE0=1 }
       else PamiecRAM[addrTCON]:=PamiecRAM[addrTCON] and (not maskaTCON_IE0);  { IE0=0 }

  if it1 then   { reakcja na zbocze opadaj¹ce INT1 }
  begin
    if PoprzednieInt1 and (not int1)
       then PamiecRAM[addrTCON]:=PamiecRAM[addrTCON] or maskaTCON_IE1 { IE1=1 }
       else PamiecRAM[addrTCON]:=PamiecRAM[addrTCON] and (not maskaTCON_IE1);  { IE1=0 }
  end else      { reakcja na niski poziom INT1 }
    if not int1
       then PamiecRAM[addrTCON]:=PamiecRAM[addrTCON] or maskaTCON_IE1 { IE1=1 }
       else PamiecRAM[addrTCON]:=PamiecRAM[addrTCON] and (not maskaTCON_IE1);  { IE1=0 }
  PoprzednieInt0 := int0;
  PoprzednieInt1 := int1;

{  if WpisDoSBUF then
  begin
       WpisDoSBUF := False;
       WyjsciowySBUF := PamiecRAM[addrSBUF];

       case TrybRS of
         0: begin
                 BitSEND := True;
                 PozostaloCykli := 7;
            end; {tryb 0}
{         1: begin
            end; {tryb 1}
{         2: begin
                 BitSEND := true;
                 if (PamiecRAM[addrPCON] and maskaPCON_SMOD) <> 0
                    then PozostaloCykli := 52 div 2-1
                    else PozostaloCykli := 52;
            end; {tryb 2}
{         3: begin
            end; {tryb 3}
{       end {case}
{  end; {if WpisDoSBUF}


{  if BitSEND then
  begin
       if PozostaloCykli = 0 then
       begin
            case TrybRS of
                 0: WpiszWyslanyBajtDoListy(False);
                 2: WpiszWyslanyBajtDoListy(True);
            end;
            BitSEND := False;
            WyjsciowySBUF := 0;
       end else Dec(PozostaloCykli);
  end;



  {Generacja przerwaä}
  TCON := PamiecRAM[addrTCON];
  if (tcon and maskaTCON_IE0) <> 0 then   { IE0 }
     if GenerujPrzerwanie(gpINT0,False) then
     begin
          if (tcon and maskaTCON_IT0) <> 0 then
             PamiecRAM[addrTCON] := tcon xor maskaTCON_IE0;
          Exit;
     end;
  if (tcon and maskaTCON_TF0) <> 0 then   { TF0 }
     if GenerujPrzerwanie(gpTF0,False) then
     begin
          Exit;
     end;
  if (tcon and maskaTCON_IE1) <> 0 then   { IE1 }
     if GenerujPrzerwanie(gpINT0,False) then
     begin
          if (tcon and maskaTCON_IT1) <> 0 then
             PamiecRAM[addrTCON] := tcon xor maskaTCON_IE1;
          Exit;
     end;
  if (tcon and maskaTCON_TF1) <> 0 then   { TF1 }
     if GenerujPrzerwanie(gpTF1,False) then
     begin
          Exit;
     end;
  if (pamiecRAM[addrSCON] and maskaSCON_TI) <> 0 { TI w SCON }
     then if GenerujPrzerwanie(gpTI,False)
             then Exit;
  if (pamiecRAM[addrSCON] and maskaSCON_RI) <> 0 { RI w SCON }
     then if GenerujPrzerwanie(gpRI,False)
             then Exit;

end;
