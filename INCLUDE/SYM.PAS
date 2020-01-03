procedure TDebugger.WczytajSymbole;
var dlg:PFileDialog;
    naz:FNameStr;
begin
     naz := Cfg.OstatniaNazwaPlikuSymboli;
     Dlg := New(PFileDialog, Init('*.SYM','Otw¢rz plik symboli...','Nazwa:',
                                  fdOpenButton, 100));
     Dlg^.HelpCtx := hcOknoWczytajSYM;
     if ExecuteDialog(Dlg, @Naz) = cmCancel then exit;
     Cfg.OstatniaNazwaPlikuSymboli := Naz;
     WczytajSymboleZDysku(Naz);
     Message(Desktop, evBroadcast, cmZmianaZawartosciTablicySymboli, nil);
end;

procedure TDebugger.ZapiszSymbole;
var dlg:PFileDialog;
    naz:FNameStr;
begin
     naz := Cfg.OstatniaNazwaPlikuSymboli;
     Dlg := New(PFileDialog, Init('*.SYM','Zapisz plik symboli...','Nazwa:',
                                  fdOpenButton, 100));
     Dlg^.HelpCtx := hcOknoZapiszSym;
     if ExecuteDialog(Dlg, @Naz) = cmCancel then exit;
     Cfg.OstatniaNazwaPlikuSymboli := Naz;
     ZapiszSymboleNaDysk(Naz);
     Message(Desktop, evBroadcast, cmZmianaZawartosciTablicySymboli, nil);
end;

procedure TDebugger.UsunWszystkieSymbole;
begin
     if MessageBox(#3'Czy usun¥† wszystkie symbole?', nil, mfConfirmation+mfYesButton+mfNoButton) = cmYes then
     begin
          IleSymboli := 0;
          Message(Desktop, evBroadcast, cmZmianaZawartosciTablicySymboli, nil);
     end;
end;

Procedure TDebugger.EdytorSymboli;
var Dlg:PEdytorSymboli;
begin
     Dlg := New(PEdytorSymboli, Init);
     ExecuteDialog(Dlg, nil);
     Message(Desktop, evBroadcast, cmZmianaZawartosciTablicySymboli, nil);
end;
