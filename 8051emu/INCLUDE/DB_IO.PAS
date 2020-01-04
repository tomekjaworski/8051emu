function OtworzEdytor(Plik:FNameStr;Widzialny:Boolean):PMyEditWindow;
var P:PWindow;
    R:TRect;
    Wyn:PMyEditWindow;
begin
     DeskTop^.GetExtent(R);
     P := New(PMyEditWindow, Init(R, Plik, wnNoNumber));
     if not Widzialny then P^.Hide;
     Wyn := PMyEditWindow(Application^.InsertWindow(P));
     wyn^.HelpCtx := hcOknoEdytoraASM;
     OtworzEdytor := wyn;
end;

procedure TDebugger.OtworzPlik;
var plk:FNameStr;
    d:PDialog;
begin
     Plk := '*.ASM';
     d := New(PFileDialog, Init('*.ASM', 'Otw¢rz plik','~N~azwa', fdOpenButton, 100));
     d^.HelpCtx := hcOknoOtworzASM;
     if ExecuteDialog(D, @plk) <> cmCancel
        then OtworzEdytor(plk, True);
end;


procedure TDebugger.NowyPlik;
begin
     Otworzedytor('', True);
end;

procedure TDebugger.ZmienKatalog;
begin
     ExecuteDialog(New(PChDirDialog, Init(cdNormal, 0)), nil);
end;
