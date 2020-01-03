Function CzyOtwarteOknoCPU:Boolean;
begin
     if Assigned(OknoCPU) then
     begin
          CzyOtwarteOknoCPU := True;
          exit;
     end else
     begin
          MessageBox(#3'Ta operacja nie mo¾e by† wykonana przy zamkni©tym oknie ˜ledzenia kodu mikroprocesora',
                     nil, mfError+mfOKButton);
          CzyOtwarteOknoCPU := False;
          exit;
     end;
end;

procedure TDebugger.OtworzOknoCPU(OstrzegajGdyOtwarte:Boolean);
begin
     if OstrzegajGdyOtwarte and Assigned(OknoCPU) then
     begin
          MessageBox(#3'Tylko jedno okno podgl¥du procka mo¾e by† otwarte.', nil, mfInformation+mfOKButton);
          exit;
     end;
     OknoCPU := New(POknoSledzenia, Init);
     InsertWindow(OknoCPU);
end;

procedure TDebugger.ProcesorKrok;
var AdresNastepnejInstrukcji:Word;
    Bajt:Byte;
    Instr:TInstrukcja;
    BuforInstr:TBuforInstr;
    i:Word;
    D:PDialog;
    KoniecPracyCiaglej:Boolean;
Label Przerwa;
begin
     if not CzyOtwarteOknoCPU then exit;
{     AdresnastepnejInstrukcji := {OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[OknoCPU^.PoleSledzeniaKOdu^.NumerLinii+1];}
     AdresNastepnejInstrukcji := PC;
     Inc(AdresNastepnejInstrukcji, DajDlugoscInstrukcji(AdresNastepnejInstrukcji));

     d := MakeCiaglaPracaSymulatoraDlg;
     InsertWindow(d);

     KoniecPracyCiaglej := False;
     repeat
           if PC = $FFFF then PC := 0;
           if AdresNastepnejInstrukcji <> PC then
           begin
                for i := 1 to IlePulapek do
                begin
                     if PC = Pulapki[i] then
                     begin
                          KoniecPracyCiaglej := True;
                          Goto Przerwa;
                     end;
                end;
           end else
           begin
                KoniecPracyCiaglej := True;
                Goto Przerwa;
           end;

           if Port[$60] = 1 then
           begin
                KoniecPracyCiaglej := True;
                goto przerwa;
           end;
           Bajt := PamiecROM^[PC];
           Instr := Instrukcje[bajt];

           if Longint(Longint(PC)+Longint(3)) > Longint($FFFE) then
           begin
                PC := 0;
                MessageBox(#3'Program u¾ytkownika przekroczyˆ maksymalny'#13+
                           #3'zakres adresowy (64kB). Wska«nik PC zostanie'#13+
                           #3'ustawiony na warto˜† 0000h',nil, mfError+mfOKButton);
                goto przerwa;
           end else
           begin
                move(PamiecROM^[PC], BuforInstr, 4);
           end;
           Instr.Run(Instr.OpKod, Instr.Bajtow, Instr.Cyk, BuforInstr);
           for i := 1 to Instr.cyk do ZwiekszT0T1_IWygenerujOdpowiedniePrzerwania;

     if par(PamiecRAM[addrACC])
        then PamiecRAM[addrPSW] := PamiecRAM[addrPSW] or maskaP
        else PamiecRAM[addrPSW] := PamiecRAM[addrPSW] and (not maskaP);

     if cfg.AnimacjaWTrybieSymulacji then
     begin
          if (PC < OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[1]) or
             (PC > OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[OknoCPU^.PoleSledzeniaKodu^.Size.Y])
             then OknoCPU^.PoleSledzeniaKodu^.UstawAdresOkienka(PC)
             else Message(Desktop, evBroadcast, cmZmianaZawartosciROM, nil);
          Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
     end;
     until KoniecPracyCiaglej;
przerwa:
     FlushKB;

     Dispose(d, Done);

     if (PC < OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[1]) or
        (PC > OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[OknoCPU^.PoleSledzeniaKodu^.Size.Y])
        then OknoCPU^.PoleSledzeniaKodu^.UstawAdresOkienka(PC);
     Message(Desktop, evBroadcast, cmZmianaZawartosciROM, nil);
     Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);


end;

procedure TDebugger.ProcesorSledz;
var Bajt:Byte;
    Instr:TInstrukcja;
    BuforInstr:TBuforInstr;
    i:byte;
begin
     if not CzyOtwarteOknoCPU then exit;
     if PC = $FFFF then PC := 0;

     Bajt := PamiecROM^[PC];
     Instr := Instrukcje[bajt];
     if Longint(Longint(PC)+Longint(3)) > Longint($FFFE) then
     begin
          PC := 0;
          Bajt := PamiecROM^[PC];
          Instr := Instrukcje[bajt];
     end else
     begin
          move(PamiecROM^[PC], BuforInstr, 4);
     end;
     Instr.Run(bajt, Instr.Bajtow, Instr.Cyk, BuforInstr);
     for i := 1 to Instr.cyk do ZwiekszT0T1_IWygenerujOdpowiedniePrzerwania;


     if par(PamiecRAM[addrACC])
        then PamiecRAM[addrPSW] := PamiecRAM[addrPSW] or maskaP
        else PamiecRAM[addrPSW] := PamiecRAM[addrPSW] and (not maskaP);

     if (PC < OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[1]) or
        (PC > OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[OknoCPU^.PoleSledzeniaKodu^.Size.Y])
        then OknoCPU^.PoleSledzeniaKodu^.UstawAdresOkienka(PC);
     Message(Desktop, evBroadcast, cmZmianaZawartosciROM, nil);
     Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
end;

procedure TDebugger.ProcesorUruchom;
var d:pdialog;
    KoniecPracyCiaglej:Boolean;
    Bajt:Byte;
    I:Word;
    Instr:TInstrukcja;
    BuforInstr:TBuforInstr;
Label Przerwa;
begin
     if not CzyOtwarteOknoCPU then exit;
     d := MakeCiaglaPracaSymulatoraDlg;
     InsertWindow(d);

     KoniecPracyCiaglej := False;
     repeat
           if PC = $FFFF then PC := 0;
           for i := 1 to IlePulapek do
           begin
                if PC = Pulapki[i] then
                begin
                     KoniecPracyCiaglej := True;
                     Goto Przerwa;
                end;
           end;
           if Port[$60] = 1 then
           begin
                KoniecPracyCiaglej := True;
                goto przerwa;
           end;
           Bajt := PamiecROM^[PC];
           Instr := Instrukcje[bajt];

           if Longint(Longint(PC)+Longint(3)) > Longint($FFFE) then
           begin
                PC := 0;
                MessageBox(#3'Program u¾ytkownika przekroczyˆ maksymalny'#13+
                           #3'zakres adresowy (64kB). Wska«nik PC zostanie'#13+
                           #3'ustawiony na warto˜† 0000h',nil, mfError+mfOKButton);
                goto przerwa;
           end else
           begin
                move(PamiecROM^[PC], BuforInstr, 4);
           end;
           Instr.Run(Instr.OpKod, Instr.Bajtow, Instr.Cyk, BuforInstr);
           for i := 1 to Instr.cyk do ZwiekszT0T1_IWygenerujOdpowiedniePrzerwania;

     if par(PamiecRAM[addrACC])
        then PamiecRAM[addrPSW] := PamiecRAM[addrPSW] or maskaP
        else PamiecRAM[addrPSW] := PamiecRAM[addrPSW] and (not maskaP);

     if cfg.AnimacjaWTrybieSymulacji then
     begin
          if (PC < OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[1]) or
             (PC > OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[OknoCPU^.PoleSledzeniaKodu^.Size.Y])
             then OknoCPU^.PoleSledzeniaKodu^.UstawAdresOkienka(PC)
             else Message(Desktop, evBroadcast, cmZmianaZawartosciROM, nil);
          Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
     end;
     until KoniecPracyCiaglej;
przerwa:
     FlushKB;

     Dispose(d, Done);

     if (PC < OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[1]) or
        (PC > OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[OknoCPU^.PoleSledzeniaKodu^.Size.Y])
        then OknoCPU^.PoleSledzeniaKodu^.UstawAdresOkienka(PC);
     Message(Desktop, evBroadcast, cmZmianaZawartosciROM, nil);
     Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
end;
