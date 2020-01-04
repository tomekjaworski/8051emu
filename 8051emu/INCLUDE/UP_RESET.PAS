procedure TDebugger.ResetProcka;
begin
     PC := 0;
     PamiecRAM[addrACC ] := $00;
     PamiecRAM[addrB   ] := $00;
     PamiecRAM[addrPSW ] := $00;
     PamiecRAM[addrP3  ] := $FF;
     PamiecRAM[addrP1  ] := $FF;
     PamiecRAM[addrTCON] := $00;
     PamiecRAM[addrTMOD] := $00;
     PamiecRAM[addrSCON] := $00;
     PamiecRAM[addrTL0 ] := $00;
     PamiecRAM[addrTL1 ] := $00;
     PamiecRAM[addrTH0 ] := $00;
     PamiecRAM[addrTH1 ] := $00;
     PamiecRAM[addrDPL ] := $00;
     PamiecRAM[addrDPH ] := $00;
     PamiecRAM[addrSP  ] := $07;
     PamiecRAM[addrIP  ] := PamiecRAM[addrIP  ] and $E0;
     PamiecRAM[addrIE  ] := PamiecRAM[addrIE  ] and $60;
     PamiecRAM[addrPCON] := PamiecRAM[addrPCON] and $70;
     WykonywaneIntHi := False;
     WykonywaneIntLo := False;
     PoprzednieINT0 := True;
     PoprzednieINT1 := True;
     PoprzednieT0 := True;
     PoprzednieT1 := True;
{     NaglaZmianaPC := True;}
     ZerujCykle;
     Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
     if Assigned(OknoCPU)
        then if Assigned(OknoCPU^.PoleSledzeniaKodu)
                then OknoCPU^.PoleSledzeniaKodu^.UstawAdresOkienka(PC);
end;

Procedure TDebugger.ZerujCykle;
begin
     IloscCykli := $00000000;
     Message(Desktop, evBroadcast, cmZmianaIlosciCykli, nil);
end;
