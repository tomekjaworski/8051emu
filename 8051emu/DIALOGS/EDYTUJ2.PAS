var
  Wartosci : record
    Bit7 : Word;
    Bit6 : Word;
    Bit5 : Word;
    Bit4 : Word;
    Bit3 : Word;
    Bit2 : Word;
    Bit1 : Word;
    Bit0 : Word;
  end;

function MakeEdytujBitowaDlg : PDialog;
var
  Dlg : PDialog;
  R : TRect;
  Control : PView;
  NazwaAdresu : PColoredText;
  AdresAdresu : PColoredText;
  NazwaBitu7 : PStaticText;
  NazwaBitu6 : PStaticText;
  NazwaBitu5 : PStaticText;
  NazwaBitu4 : PStaticText;
  NazwaBitu2 : PStaticText;
  NazwaBitu3 : PStaticText;
  NazwaBitu0 : PStaticText;
  NazwaBitu1 : PStaticText;
  WartoscHEX : PColoredText;
  WartoscASCII : PColoredText;
  WartoscDEC : PColoredText;

begin
R.Assign(14, 5, 65, 18);
New(Dlg, Init(R, 'Edytuj warto˜†...'));
Dlg^.Options := Dlg^.Options or ofCenterX or ofCenterY;
Dlg^.Palette := dpBlueDialog;

R.Assign(2, 6, 7, 7);
Control := New(PCheckboxes, Init(R, 
  NewSItem(' ', Nil)));
Dlg^.Insert(Control);

R.Assign(8, 6, 13, 7);
Control := New(PCheckboxes, Init(R, 
  NewSItem(' ', Nil)));
Dlg^.Insert(Control);

R.Assign(14, 6, 19, 7);
Control := New(PCheckboxes, Init(R, 
  NewSItem(' ', Nil)));
Dlg^.Insert(Control);

R.Assign(20, 6, 25, 7);
Control := New(PCheckboxes, Init(R, 
  NewSItem(' ', Nil)));
Dlg^.Insert(Control);

R.Assign(26, 6, 31, 7);
Control := New(PCheckboxes, Init(R, 
  NewSItem(' ', Nil)));
Dlg^.Insert(Control);

R.Assign(32, 6, 37, 7);
Control := New(PCheckboxes, Init(R, 
  NewSItem(' ', Nil)));
Dlg^.Insert(Control);

R.Assign(38, 6, 43, 7);
Control := New(PCheckboxes, Init(R, 
  NewSItem(' ', Nil)));
Dlg^.Insert(Control);

R.Assign(44, 6, 49, 7);
Control := New(PCheckboxes, Init(R, 
  NewSItem(' ', Nil)));
Dlg^.Insert(Control);

R.Assign(2, 2, 10, 4);
Control := New(PStaticText, Init(R, 'Rejestr:'^M+
     '  Adres:'));
Dlg^.Insert(Control);

R.Assign(12, 2, 34, 3);
NazwaAdresu := New(PColoredText, Init(R, 'PSW', $5F));
Dlg^.Insert(NazwaAdresu);

R.Assign(12, 3, 34, 4);
AdresAdresu := New(PColoredText, Init(R, '0D0H', $5F));
Dlg^.Insert(AdresAdresu);

R.Assign(11, 2, 12, 4);
Control := New(PColoredText, Init(R, '', $5F));
Dlg^.Insert(Control);

R.Assign(34, 2, 35, 4);
Control := New(PColoredText, Init(R, '', $5F));
Dlg^.Insert(Control);

R.Assign(2, 8, 15, 9);
Control := New(PStaticText, Init(R, 'Szesnastkowo:'));
Dlg^.Insert(Control);

R.Assign(9, 9, 15, 10);
Control := New(PStaticText, Init(R, 'ASCII:'));
Dlg^.Insert(Control);

R.Assign(3, 10, 15, 11);
Control := New(PStaticText, Init(R, 'Dziesi©tnie:'));
Dlg^.Insert(Control);

R.Assign(2, 5, 7, 6);
NazwaBitu7 := New(PStaticText, Init(R, '---'));
Dlg^.Insert(NazwaBitu7);

R.Assign(8, 5, 13, 6);
NazwaBitu6 := New(PStaticText, Init(R, '---'));
Dlg^.Insert(NazwaBitu6);

R.Assign(14, 5, 19, 6);
NazwaBitu5 := New(PStaticText, Init(R, '---'));
Dlg^.Insert(NazwaBitu5);

R.Assign(20, 5, 25, 6);
NazwaBitu4 := New(PStaticText, Init(R, '---'));
Dlg^.Insert(NazwaBitu4);

R.Assign(32, 5, 37, 6);
NazwaBitu2 := New(PStaticText, Init(R, '---'));
Dlg^.Insert(NazwaBitu2);

R.Assign(26, 5, 31, 6);
NazwaBitu3 := New(PStaticText, Init(R, '---'));
Dlg^.Insert(NazwaBitu3);

R.Assign(44, 5, 49, 6);
NazwaBitu0 := New(PStaticText, Init(R, '---'));
Dlg^.Insert(NazwaBitu0);

R.Assign(38, 5, 43, 6);
NazwaBitu1 := New(PStaticText, Init(R, '---'));
Dlg^.Insert(NazwaBitu1);

R.Assign(16, 8, 21, 9);
WartoscHEX := New(PColoredText, Init(R, '41', $4F));
Dlg^.Insert(WartoscHEX);

R.Assign(16, 9, 21, 10);
WartoscASCII := New(PColoredText, Init(R, 'A', $4F));
Dlg^.Insert(WartoscASCII);

R.Assign(16, 10, 21, 11);
WartoscDEC := New(PColoredText, Init(R, '65', $4F));
Dlg^.Insert(WartoscDEC);

R.Assign(25, 9, 35, 11);
Control := New(PButton, Init(R, 'O~K~', cmOK, bfDefault));
Dlg^.Insert(Control);

R.Assign(38, 9, 48, 11);
Control := New(PButton, Init(R, '~A~nuluj', cmCancel, bfDefault));
Dlg^.Insert(Control);

Dlg^.SelectNext(False);
MakeEdytujBitowaDlg := Dlg;
end;
