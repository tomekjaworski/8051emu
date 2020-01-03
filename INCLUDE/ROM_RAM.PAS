procedure TDebugger.ZapiszZawartoscPamieciROM;
var Dlg:PFileDialog;
    Naz:FNameStr;
begin
     naz := Cfg.OstatniaNazwaPlikuROM;
     Dlg := New(PFileDialog, Init('*.HEX','Zapisz pami©† ROM...','Nazwa:',
                                  fdOpenButton, 100));
     Dlg^.HelpCtx := hcOknoZapiszROM;
     if ExecuteDialog(Dlg, @Naz) = cmCancel then exit;
     Cfg.OstatniaNazwaPlikuROM := Naz;

     if UpperCase(DajRozszerzenieZNazwy(Naz)) = '.HEX'
        then ZapiszBuforJakoHEX(PamiecROM, Cfg.WielkoscPamieciROMBranaPodUwagePrzyZapisie, naz, true)
        else ZapiszBuforJakoBIN(PamiecROM, Cfg.WielkoscPamieciROMBranaPodUwagePrzyZapisie, Naz, True);
end;

procedure TDebugger.ZapiszZawartoscPamieciRAM;
var Dlg:PFileDialog;
    Naz:FNameStr;
begin
     naz := Cfg.OstatniaNazwaPlikuRAM;
     Dlg := New(PFileDialog, Init('*.HEX','Zapisz pami©† RAM...','Nazwa:',
                                  fdOpenButton, 100));
     Dlg^.HelpCtx := hcOknoZapiszRAM;
     if ExecuteDialog(Dlg, @Naz) = cmCancel then exit;
     Cfg.OstatniaNazwaPlikuRAM := Naz;

     if UpperCase(DajRozszerzenieZNazwy(Naz)) = '.HEX'
        then ZapiszBuforJakoHEX(@PamiecRAM, Cfg.WielkoscPamieciRAMBranaPodUwagePrzyZapisie, naz, True)
        else ZapiszBuforJakoBIN(@PamiecRAM, Cfg.WielkoscPamieciRAMBranaPodUwagePrzyZapisie, Naz, True);

end;

procedure TDebugger.WczytajZawartoscPamieciROM;
var Dlg:PFileDialog;
    Naz:FNameStr;
    sym:String;
    D:DirStr;
    N:NameStr;
    E:ExtStr;
begin
     naz := Cfg.OstatniaNazwaPlikuROM;
     Dlg := New(PFileDialog, Init('*.HEX','Wczytaj pami©† ROM...','Nazwa:',
                                  fdOpenButton, 100));
     Dlg^.HelpCtx := hcOknoWczytajROM;
     if ExecuteDialog(Dlg, @Naz) = cmCancel then exit;
     Cfg.OstatniaNazwaPlikuROM := Naz;

     if UpperCase(DajRozszerzenieZNazwy(Naz)) = '.HEX'
        then WczytajBuforJakoHEX(PamiecROM, Cfg.WielkoscPamieciROMBranaPodUwagePrzyOdczycie, naz)
        else WczytajBuforJakoBIN(PamiecROM, Cfg.WielkoscPamieciROMBranaPodUwagePrzyOdczycie, Naz);

     FSplit(Naz, d, n, e);
     Sym := d+n+'.SYM';

     if FileExists(Sym) then
     begin
          if MessageBox(#3'Znalazˆem plik '+Sym+#13+
                        #3'Czy te¾ wczyta†?', nil, mfConfirmation + mfYesNoButton) = cmYes
          then WczytajSymboleZDysku(Sym);
     end;

     Message(Desktop, evBroadcast, cmZmianaZawartosciROM, nil);
     if MessageBox('Czy wykona† reset procka?', nil, mfConfirmation+mfYesNoButton) = cmNo
        then exit;
     ResetProcka;
     OtworzOknoCPU(False);
end;

procedure TDebugger.WczytajZawartoscPamieciRAM;
var Dlg:PFileDialog;
    Naz:FNameStr;
begin
     naz := Cfg.OstatniaNazwaPlikuRAM;
     Dlg := New(PFileDialog, Init('*.HEX','Wczytaj pami©† RAM...','Nazwa:',
                                  fdOpenButton, 100));
     Dlg^.HelpCtx := hcOknoWczytajRAM;
     if ExecuteDialog(Dlg, @Naz) = cmCancel then exit;
     Cfg.OstatniaNazwaPlikuRAM := Naz;

     if UpperCase(DajRozszerzenieZNazwy(Naz)) = '.HEX'
        then WczytajBuforJakoHEX(PamiecROM, Cfg.WielkoscPamieciRAMBranaPodUwagePrzyOdczycie, naz)
        else WczytajBuforJakoBIN(PamiecROM, Cfg.WielkoscPamieciRAMBranaPodUwagePrzyOdczycie, Naz);

     Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
     if MessageBox('Czy wykona† reset procka?', nil, mfConfirmation+mfYesNoButton) = cmNo
        then exit;
     ResetProcka;
end;

procedure TDebugger.WyczyscZawartoscPamieciRAM;
begin
     FillChar(PamiecRAM, SizeOf(TPamiecRAM), #0);
     Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
end;

procedure TDebugger.WyczyscZawartoscPamieciROM;
begin
     FillChar(PamiecROM^, SizeOf(TPamiecROM), #0);
     Message(Desktop, evBroadcast, cmZmianaZawartosciROM, nil);
end;

procedure TDebugger.EdytujROM;
begin
     OknoHEX(PamiecROM, SizeOf(TPamiecROM), 'Pami©† ROM', cmZmianaZawartosciROM);
end;
procedure TDebugger.EdytujRAM;
begin
     OknoHEX(@PamiecRAM, SizeOf(TPamiecRAM), 'Pami©† RAM', cmZmianaZawartosciRAM);
end;
