function MakeCiaglaPracaSymulatoraDlg : PDialog;
var
  Dlg : PDialog;
  R : TRect;
  Control : PView;

begin
R.Assign(12, 9, 68, 14);
New(Dlg, Init(R, 'Ci¥gˆa praca symulatora'));
Dlg^.Options := Dlg^.Options or ofCenterX or ofCenterY;
Dlg^.Palette := dpBlueDialog;
Dlg^.Flags := Dlg^.Flags and not(wfMove or wfClose);

R.Assign(3, 2, 54, 3);
Control := New(PStaticText, Init(R, 'Naci˜nij dowolny klawisz aby przerwa†'+
     ' symulacj©...'));
Dlg^.Insert(Control);

Dlg^.SelectNext(False);
MakeCiaglaPracaSymulatoraDlg := Dlg;
end;
