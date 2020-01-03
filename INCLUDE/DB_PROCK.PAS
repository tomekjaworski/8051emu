procedure TDebugger.Kalendarz;
var k:PCalendarWindow;
begin
     k := New(PCalendarWindow, Init);
     k^.HelpCtx := hcOknoKalendarz;
     InsertWindow(k);
end;

procedure TDebugger.Kalkulator;
var Dlg:PDialog;
begin
     Dlg := New(PCalculator, Init);
     Dlg^.HelpCtx := hcOknoKalkulator;
     InsertWindow(Dlg);
end;

procedure TDebugger.TabelaASCII;
var Dlg:PDialog;
begin
     Dlg := PDialog(New(PASCIIChart, Init));
     Dlg^.HelpCtx := hcOknoTabelaAscii;
     InsertWindow(Dlg);
end;

procedure TDebugger.OutOfMemory;
begin
     MessageBox('Zbyt maˆo pami©ci, aby wykona† t¥ operacj©.', nil, mfError + mfOKButton);
end;

procedure TDebugger.PokazSchowek;
begin
     if not Assigned(Schoweczek) then exit;
     Schoweczek^.Select;
     Schoweczek^.Show;
end;
