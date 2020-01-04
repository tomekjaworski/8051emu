procedure TOknoSledzenia.Redraw;
begin
     inherited Redraw;
end;

procedure TOknoSledzenia.Draw;
begin
     inherited draw;
end;

procedure TOknoSledzenia.SizeLimits(var Min, Max:TPoint);
begin
     inherited SizeLimits(Min, Max);
     Min.X := Size.X;
end;

procedure TOknoSledzenia.HandleEvent(var Event: TEvent);
var KC:Word;

procedure BitEdt(adr:byte);
begin
     EdycjaBinarna(adr, PamiecRAM[adr], tpRAM);
end;
procedure EdycjaPC;
begin
     EdycjaZwykla(PC, 2{Word});
     OknoCPU^.PoleSledzeniaKodu^.UstawAdresOkienka(PC);
     Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
end;

procedure EdycjaWord(AdresHi, AdresLo:Byte);
var x:word;
begin
     x := (PamiecRAM[AdresHI] shl 8) or PamiecRAM[AdresLO];
     EdycjaZwykla(X, 2{Word});
     PamiecRAM[AdresHI] := Byte(x shr 8);
     PamiecRAM[AdresLO] := Byte(x);
     Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
end;

procedure GenPrzerw(Numer:Byte);
begin
     GenerujPrzerwanie(Numer, true);
     Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
end;

begin
     inherited HandleEvent(Event);
     if event.what = evcommand then
     begin
          case Event.Command of
            cmRejestrACC: BitEdt(addrACC);
            cmRejestrB: BitEdt(addrB);
            cmRejestrIE: BitEdt(addrIE);
            cmRejestrIP: BitEdt(addrIP);
            cmRejestrPC: EdycjaPC;
            cmRejestrDPTR: EdycjaWord(addrDPH, addrDPL);
            cmWartoscLicznikaT0: EdycjaWord(addrTH0, addrTL0);
            cmWartoscLicznikaT1: EdycjaWord(addrTH1, addrTL1);
            cmPortP1: BitEdt(addrP1);
            cmPortP3: BitEdt(addrP3);
            cmRejestrR0: BitEdt(addrR0+DajAdresBanku);
            cmRejestrR1: BitEdt(addrR1+DajAdresBanku);
            cmRejestrR2: BitEdt(addrR2+DajAdresBanku);
            cmRejestrR3: BitEdt(addrR3+DajAdresBanku);
            cmRejestrR4: BitEdt(addrR4+DajAdresBanku);
            cmRejestrR5: BitEdt(addrR5+DajAdresBanku);
            cmRejestrR6: BitEdt(addrR6+DajAdresBanku);
            cmRejestrR7: BitEdt(addrR7+DajAdresBanku);
            cmRejestrSP: BitEdt(addrSP);
            cmWartoscSP: EdycjaBinarna(PamiecRAM[addrSP], PamiecRAM[PamiecRAM[addrSP]], tpRAM);
            cmWartoscSP1: EdycjaBinarna(PamiecRAM[addrSP]-1, PamiecRAM[PamiecRAM[addrSP]-1], tpRAM);
            cmWartoscSP2: EdycjaBinarna(PamiecRAM[addrSP]-2, PamiecRAM[PamiecRAM[addrSP]-2], tpRAM);
            cmWartoscSP3: EdycjaBinarna(PamiecRAM[addrSP]-3, PamiecRAM[PamiecRAM[addrSP]-3], tpRAM);
            cmWartoscSP4: EdycjaBinarna(PamiecRAM[addrSP]-4, PamiecRAM[PamiecRAM[addrSP]-4], tpRAM);
            cmWartoscSP5: EdycjaBinarna(PamiecRAM[addrSP]-5, PamiecRAM[PamiecRAM[addrSP]-5], tpRAM);
            cmWartoscSP6: EdycjaBinarna(PamiecRAM[addrSP]-6, PamiecRAM[PamiecRAM[addrSP]-6], tpRAM);
            cmWartoscSP7: EdycjaBinarna(PamiecRAM[addrSP]-7, PamiecRAM[PamiecRAM[addrSP]-7], tpRAM);
            cmWartoscSP8: EdycjaBinarna(PamiecRAM[addrSP]-8, PamiecRAM[PamiecRAM[addrSP]-8], tpRAM);
            cmWartoscSP9: EdycjaBinarna(PamiecRAM[addrSP]-9, PamiecRAM[PamiecRAM[addrSP]-9], tpRAM);
            cmRejestrSCON: BitEdt(addrSCON);
            cmRejestrTCON: BitEdt(addrTCON);
            cmRejestrSBUF: BitEdt(addrSBUF);
            cmRejestrPCON: BitEdt(addrPCON);
            cmRejestrTMOD: BitEdt(addrTMOD);
            cmFlagaCY: begin
                            PamiecRAM[addrPSW] := PamiecRAM[addrPSW] xor maskaC;
                            Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
                       end;
            cmFlagaAC: begin
                            PamiecRAM[addrPSW] := PamiecRAM[addrPSW] xor maskaAC;
                            Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
                       end;
            cmFlagaOV: begin
                            PamiecRAM[addrPSW] := PamiecRAM[addrPSW] xor maskaOV;
                            Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
                       end;
            cmFlagaP: begin
                            PamiecRAM[addrPSW] := PamiecRAM[addrPSW] xor maskaP;
                            Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
                       end;
            cmFlagaF0: begin
                            PamiecRAM[addrPSW] := PamiecRAM[addrPSW] xor maskaF0;
                            Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
                       end;
            cmFlagaRS0: begin
                             PamiecRAM[addrPSW] := PamiecRAM[addrPSW] xor maskaRS0;
                             Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
                        end;
            cmFlagaRS1: begin
                             PamiecRAM[addrPSW] := PamiecRAM[addrPSW] xor maskaRS1;
                             Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
                        end;
            cmFlagaUNDEF: begin
                            PamiecRAM[addrPSW] := PamiecRAM[addrPSW] xor maskaUNDEF;
                            Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
                       end;
            cmINT0: GenPrzerw(gpINT0);
            cmINT1: GenPrzerw(gpINT1);
            cmT0: GenPrzerw(gpTF0);
            cmT1: GenPrzerw(gpTF1);
            cmRI: GenPrzerw(gpRI);
            cmTI: GenPrzerw(gpTI);

          end;

          ClearEvent(event);
     end;
     if event.what = evKeyDown then
     begin
          KC := Event.KeyCode;
          case KC of
               kbUp: PoleSledzeniaKodu^.Up;
               kbDown: PoleSledzeniaKodu^.Down;
               kbHome: PoleSledzeniaKodu^.Top;
               kbPgUp: PoleSledzeniaKodu^.PageUp;
               kbPgDn: PoleSledzeniaKodu^.PageDown;
          end;
     end;
     if event.what = evBroadcast then
     begin
          if Event.Command = cmZmianaZawartosciRAM then
          begin
               UstawWartosciMonitoraRejestrow;
               ReDraw;
          end;
          if (event.command = cmZmianaZawartosciROM) or
             (event.command = cmZmianaZawartosciTablicySymboli)
             then PoleSledzeniaKodu^.Draw;
     end;
end;
