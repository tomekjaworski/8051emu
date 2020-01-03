var
  Zawartosc : record
    Wartosc : String[10];
  end;

function MakeEdytujDlg : PDialog;
var
  Dlg : PDialog;
  R : TRect;
  Control : PView;

begin
R.Assign(27, 7, 52, 15);
New(Dlg, Init(R, 'Edytuj...'));
Dlg^.Options := Dlg^.Options or ofCenterX or ofCenterY;
Dlg^.Palette := dpBlueDialog;

R.Assign(3, 3, 22, 4);
Control := New(PInputLine, Init(R, 10));
Dlg^.Insert(Control);

  R.Assign(2, 2, 22, 3);
  Dlg^.Insert(New(PLabel, Init(R, 'Podaj now¥ ~w~arto˜†:', Control)));

R.Assign(2, 5, 12, 7);
Control := New(PButton, Init(R, 'O~K~', cmOK, bfDefault));
Dlg^.Insert(Control);

R.Assign(13, 5, 23, 7);
Control := New(PButton, Init(R, '~A~nuluj', cmCancel, bfNormal));
Dlg^.Insert(Control);

Dlg^.SelectNext(False);
MakeEdytujDlg := Dlg;
end;
