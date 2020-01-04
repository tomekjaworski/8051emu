const FlagaAktywna = (Cyan shl 4) or White;
      FlagaNieaktywna = (Cyan shl 4) or Black;
      FlagaAktywnaBlue = (Blue shl 4) or White;

procedure TOknoSledzenia.UstawWartosciMonitoraRejestrow;
var WartSP:Byte;
    temp: string;
begin
     RejestrACC^.SetTitle(Dec2HexB(PamiecRAM[addrACC]), False);
     NumerBanku^.SetTitle(Int2Str(DajNumerBanku), False);
     RejestrB^.SetTitle(Dec2HexB(PamiecRAM[addrB]), False);
     RejestrDPTR^.SetTitle(Dec2HexW((PamiecRAM[addrDPH] shl 8) or PamiecRAM[addrDPL]), False);
     RejestrPC^.SetTitle(Dec2HexW(PC), False);
     RejestrR0^.SetTitle(Dec2HexB(PamiecRAM[DajAdresBanku+addrR0]), False);
     RejestrR1^.SetTitle(Dec2HexB(PamiecRAM[DajAdresBanku+addrR1]), False);
     RejestrR2^.SetTitle(Dec2HexB(PamiecRAM[DajAdresBanku+addrR2]), False);
     RejestrR3^.SetTitle(Dec2HexB(PamiecRAM[DajAdresBanku+addrR3]), False);
     RejestrR4^.SetTitle(Dec2HexB(PamiecRAM[DajAdresBanku+addrR4]), False);
     RejestrR5^.SetTitle(Dec2HexB(PamiecRAM[DajAdresBanku+addrR5]), False);
     RejestrR6^.SetTitle(Dec2HexB(PamiecRAM[DajAdresBanku+addrR6]), False);
     RejestrR7^.SetTitle(Dec2HexB(PamiecRAM[DajAdresBanku+addrR7]), False);
     PortP1^.SetTitle(Dec2HexB(PamiecRAM[addrP1]), False);
     PortP3^.SetTitle(Dec2HexB(PamiecRAM[addrP3]), False);
     WartSP := PamiecRAM[addrSP];
     RejestrSP^.SetTitle(Dec2HexB(WartSP), False);
     WartoscSP^.SetTitle(Dec2HexB(PamiecRAM[WartSP]), False);
     WartoscSP1^.SetTitle(Dec2HexB(PamiecRAM[WartSP-1]), False);
     WartoscSP2^.SetTitle(Dec2HexB(PamiecRAM[WartSP-2]), False);
     WartoscSP3^.SetTitle(Dec2HexB(PamiecRAM[WartSP-3]), False);
     WartoscSP4^.SetTitle(Dec2HexB(PamiecRAM[WartSP-4]), False);
     WartoscSP5^.SetTitle(Dec2HexB(PamiecRAM[WartSP-5]), False);
     WartoscSP6^.SetTitle(Dec2HexB(PamiecRAM[WartSP-6]), False);
     WartoscSP7^.SetTitle(Dec2HexB(PamiecRAM[WartSP-7]), False);
     WartoscSP8^.SetTitle(Dec2HexB(PamiecRAM[WartSP-8]), False);
     WartoscSP9^.SetTitle(Dec2HexB(PamiecRAM[WartSP-9]), False);

     RejestrSCON^.SetTitle(Dec2HexB(PamiecRAM[addrSCON]), False);
     RejestrTCON^.SetTitle(Dec2HexB(PamiecRAM[addrTCON]), False);
     RejestrPCON^.SetTitle(Dec2HexB(PamiecRAM[addrPCON]), False);
     RejestrTMOD^.SetTitle(Dec2HexB(PamiecRAM[addrTMOD]), False);
     RejestrSBUF^.SetTitle(Dec2HexB(PamiecRAM[addrSBUF]), False);
     RejestrIP^.SetTitle(Dec2HexB(PamiecRAM[addrIP]), False);
     RejestrIE^.SetTitle(Dec2HexB(PamiecRAM[addrIE]), False);
     str(IloscCykli, temp);
     LiczbaCykli^.SetTitle(temp, False);

     WartoscLicznikaT0^.SetTitle(Dec2HexW((PamiecRAM[addrTH0] shl 8) or PamiecRAM[addrTL0]), False);
     WartoscLicznikaT1^.SetTitle(Dec2HexW((PamiecRAM[addrTH1] shl 8) or PamiecRAM[addrTL1]), False);

     if PamiecRAM[addrPSW] and maskaC <> 0 then
     begin
          FlagaCY^.SetColor(FlagaAktywna, False);
          FlagaCY^.SetTitle('CY', False);
     end else
     begin
          FlagaCY^.SetColor(FlagaNieaktywna, False);
          FlagaCY^.SetTitle('cy', False);
     end;

     if PamiecRAM[addrPSW] and maskaAC <> 0 then
     begin
          FlagaAC^.SetColor(FlagaAktywna, False);
          FlagaAC^.SetTitle('AC', False);
     end else
     begin
          FlagaAC^.SetColor(FlagaNieaktywna, False);
          FlagaAC^.SetTitle('ac', False);
     end;
     if PamiecRAM[addrPSW] and maskaRS0 <> 0 then
     begin
          FlagaRS0^.SetColor(FlagaAktywna, False);
          FlagaRS0^.SetTitle('RS0', False);
     end else
     begin
          FlagaRS0^.SetColor(FlagaNieaktywna, False);
          FlagaRs0^.SetTitle('rs0', False);
     end;
     if PamiecRAM[addrPSW] and maskaRS1 <> 0 then
     begin
          FlagaRS1^.SetColor(FlagaAktywna, False);
          FlagaRS1^.SetTitle('RS1', False);
     end else
     begin
          FlagaRS1^.SetColor(FlagaNieaktywna, False);
          FlagaRs1^.SetTitle('rs1', False);
     end;
     if PamiecRAM[addrPSW] and maskaP <> 0 then
     begin
          FlagaP^.SetColor(FlagaAktywna, False);
          FlagaP^.SetTitle('P', False);
     end else
     begin
          FlagaP^.SetColor(FlagaNieaktywna, False);
          FlagaP^.SetTitle('p', False);
     end;
     if PamiecRAM[addrPSW] and maskaF0 <> 0 then
     begin
          FlagaF0^.SetColor(FlagaAktywna, False);
          FlagaF0^.SetTitle('F0', False);
     end else
     begin
          FlagaF0^.SetColor(FlagaNieaktywna, False);
          FlagaF0^.SetTitle('f0', False);
     end;
     if PamiecRAM[addrPSW] and maskaOV <> 0 then
     begin
          FlagaOV^.SetColor(FlagaAktywna, False);
          FlagaOV^.SetTitle('OV', False);
     end else
     begin
          FlagaOV^.SetColor(FlagaNieaktywna, False);
          FlagaOV^.SetTitle('ov', False);
     end;
     if PamiecRAM[addrPSW] and maskaUNDEF <> 0 then
     begin
          FlagaUNDEF^.SetColor(FlagaAktywna, False);
          FlagaUNDEF^.SetTitle('þþþþ', False);
     end else
     begin
          FlagaUNDEF^.SetColor(FlagaNieaktywna, False);
          FlagaUNDEF^.SetTitle('----', False);
     end;

     if WykonywaneIntHi then
     begin
          PoziomHI^.SetColor(FlagaAktywnaBlue, False);
          PoziomHI^.SetTitle('HI', False);
     end else
     begin
          PoziomHI^.SetColor(FlagaNieaktywna, False);
          PoziomHI^.SetTitle('hi', False);
     end;

     if WykonywaneIntLo then
     begin
          PoziomLO^.SetColor(FlagaAktywnaBlue, False);
          PoziomLO^.SetTitle('LO', False);
     end else
     begin
          PoziomLO^.SetColor(FlagaNieaktywna, False);
          PoziomLO^.SetTitle('lo', False);
     end;


end;
