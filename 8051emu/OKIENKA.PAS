unit Okienka;
interface
Uses Dialogs, Objects, Views, ColorTxt, App, Drivers, Stale;


function MakeAboutDlg:PDialog;
function MakeCiaglaPracaSymulatoraDlg:PDialog;
function MakeEdytujDlg:PDialog;
function MakeSzukajDlg: PDialog;
function MakeZastapDlg:PDialog;
function MakeWyborProckaDlg : PDialog;
{function MakeKompilacjaDlg(var Wskazniki:TWskazniki):PDialog;
{}

implementation
function MakeAboutDlg : PDialog;
var Dlg:PDialog;
    R:TRect;
    Control:PView;
    btnOk:PButton;
begin
     R.Assign(18, 6, 62, 17);
     New(Dlg, Init(R, 'O programie...'));
     Dlg^.Options := Dlg^.Options or ofCenterX or ofCenterY;
     Dlg^.HelpCtx := hcOknoAbout;

     R.Assign(2, 2, 42, 6);
     Control := New(PColoredText, Init(R,
             'Program uruchomieniowy mikroprocesor¢w'^M+
             'rodziny AT98Cx051'^M+
             ^M+
             'Autor: Tomasz Jaworski, 1999-2001', $1F, 0));
     Dlg^.Insert(Control);

     R.Assign(15, 8, 27, 10);
     btnOk := New(PButton, Init(R, '~O~k', cmOK, bfDefault));
     Dlg^.Insert(btnOk);

     Dlg^.SelectNext(False);
     MakeAboutDlg := Dlg;
end;

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

function MakeEdytujDlg : PDialog;
var
  Dlg : PDialog;
  R : TRect;
  Control : PView;

begin
     R.Assign(27, 7, 52, 15);
     New(Dlg, Init(R, 'Edytuj...'));
     Dlg^.Options := Dlg^.Options or ofCenterX or ofCenterY;
     Dlg^.HelpCtx := hcOknoEdycjaZwykla;
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

function MakeSzukajDlg: PDialog;
var D: PDialog;
    Control: PView;
    R: TRect;
begin
     R.Assign(0, 0, 38, 12);
     D := New(PDialog, Init(R, 'Szukaj'));
     D^.HelpCtx := hcOknoSzukaj;
     with D^ do
     begin
          Options := Options or ofCentered;
          R.Assign(3, 3, 32, 4);
          Control := New(PInputLine, Init(R, 80));
          Insert(Control);
          R.Assign(2, 2, 21, 3);
          Insert(New(PLabel, Init(R, 'Wyszukiwany ~t~ekst:', Control)));
          R.Assign(32, 3, 35, 4);
          Insert(New(PHistory, Init(R, PInputLine(Control), 10)));

          R.Assign(3, 5, 35, 7);
          Insert(New(PCheckBoxes, Init(R, NewSItem('~U~wzgl©dniaj wielko˜† liter',
                                          NewSItem('T~y~lko caˆe sˆowa', nil)))));

          R.Assign(14, 9, 24, 11);
          Insert(New(PButton, Init(R, '~O~k', cmOk, bfDefault)));
          Inc(R.A.X, 12); Inc(R.B.X, 12);
          Insert(New(PButton, Init(R, 'Anuluj', cmCancel, bfNormal)));

          SelectNext(False);
     end;
     MakeSzukajDlg := D;
end;

function MakeZastapDlg:PDialog;
var D:PDialog;
    Control:PView;
    R:TRect;
begin
     R.Assign(0, 0, 40, 16);
     D := New(PDialog, Init(R, 'Zast¥p'));
     D^.HelpCtx := hcOknoZastap;
     with D^ do
     begin
          Options := Options or ofCentered;
          R.Assign(3, 3, 34, 4);
          Control := New(PInputLine, Init(R, 80));
          Insert(Control);
          R.Assign(2, 2, 21, 3);
          Insert(New(PLabel, Init(R, 'Wyszukiwany ~t~ekst:', Control)));
          R.Assign(34, 3, 37, 4);
          Insert(New(PHistory, Init(R, PInputLine(Control), 10)));

          R.Assign(3, 6, 34, 7);
          Control := New(PInputLine, Init(R, 80));
          Insert(Control);
          R.Assign(2, 5, 14, 6);
          Insert(New(PLabel, Init(R, '~N~owy tekst:', Control)));
          R.Assign(34, 6, 37, 7);
          Insert(New(PHistory, Init(R, PInputLine(Control), 11)));

          R.Assign(3, 8, 37, 12);
          Insert(New(PCheckBoxes, Init(R, NewSItem('~U~wzgl©dniaj wielko˜† liter',
                                          NewSItem('T~y~lko caˆe sˆowa',
                                          NewSItem('~P~ytaj przed zast¥pieniem',
                                          NewSItem('Zast¥p ~w~szystko', nil)))))));

          R.Assign(17, 13, 27, 15);
          Insert(New(PButton, Init(R, '~O~k', cmOk, bfDefault)));
          R.Assign(28, 13, 38, 15);
          Insert(New(PButton, Init(R, 'Anuluj', cmCancel, bfNormal)));

          SelectNext(False);
     end;
     MakeZastapDlg := D;
end;

function MakeWyborProckaDlg:PDialog;
var Dlg:PDialog;
    R:TRect;
    Control:PView;
begin
     R.Assign(18, 5, 62, 17);
     New(Dlg, Init(R, 'Wyb¢r mikroprocesora'));
     Dlg^.Options := Dlg^.Options or ofCenterX or ofCenterY;
     Dlg^.HelpCtx := hcOknoWyborProcka;

     R.Assign(28, 3, 29, 10);
     Control := New(PScrollBar, Init(R));
     Dlg^.Insert(Control);

     R.Assign(4, 3, 28, 10);
     Control := New(PListBox, Init(R, 1, PScrollbar(Control)));
     Dlg^.Insert(Control);

     R.Assign(3, 2, 29, 3);
     Dlg^.Insert(New(PLabel, Init(R, 'Lista dost©pnych ~u~kˆad¢w:', Control)));

     R.Assign(32, 2, 42, 4);
     Control := New(PButton, Init(R, '~O~k', cmOK, bfDefault));
     Dlg^.Insert(Control);

     R.Assign(32, 5, 42, 7);
     Control := New(PButton, Init(R, 'Anuluj', cmOK, bfNormal));
     Dlg^.Insert(Control);

     Dlg^.SelectNext(False);
     MakeWyborProckaDlg := Dlg;
end;

function MakeKompilacjaDlg(var Wskazniki:TWskazniki):PDialog;
var Dlg : PDialog;
    R : TRect;
    Control : PView;
begin
     R.Assign(15, 6, 65, 17);
     New(Dlg, Init(R, 'Kompilacja'));
     Dlg^.Options := Dlg^.Options or ofCenterX or ofCenterY;
     Dlg^.Flags := Dlg^.Flags and not(wfMove or wfClose);

     R.Assign(3, 2, 9, 3);
     Control := New(PStaticText, Init(R, 'Plik:'));
     Dlg^.Insert(Control);

     R.Assign(10, 2, 23, 3);
     Control := New(PColoredText, Init(R, '12345678.123', $74, cmKompilacjaPlik));
     Wskazniki[cmKompilacjaPlik] := Control;
     Dlg^.Insert(Control);

     R.Assign(3, 3, 48, 4);
     Control := New(PColoredText, Init(R, 'Gotowe.', $70, cmKompilacjaStatus));
     Wskazniki[cmKompilacjaStatus] := Control;
     Dlg^.Insert(Control);

     R.Assign(3, 5, 14, 6);
     Control := New(PStaticText, Init(R, 'Platforma:'));
     Dlg^.Insert(Control);

     R.Assign(17, 5, 26, 6);
     Control := New(PColoredText, Init(R, 'AT89Cx051', $7E, cmKompilacjaPlatforma));
     Wskazniki[cmKompilacjaPlatforma] := Control;
     Dlg^.Insert(Control);

     R.Assign(3, 6, 18, 7);
     Control := New(PStaticText, Init(R, 'Wolnej pami©ci:'));
     Dlg^.Insert(Control);

     R.Assign(19, 6, 27, 7);
     Control := New(PColoredText, Init(R, '64000kB', $7E, cmKompilacjaWolnejPamieci));
     Wskazniki[cmKompilacjaWolnejPamieci] := Control;
     Dlg^.Insert(Control);

     R.Assign(30, 5, 42, 6);
     Control := New(PStaticText, Init(R, 'Numer linii:'));
     Dlg^.Insert(Control);

     R.Assign(30, 6, 42, 7);
     Control := New(PStaticText, Init(R, 'Ilo˜† linii:'));
     Dlg^.Insert(Control);

     R.Assign(43, 5, 48, 6);
     Control := New(PColoredText, Init(R, '00000', $71, cmKompilacjaNumerLinii));
     Wskazniki[cmKompilacjaNumerLinii] := Control;
     Dlg^.Insert(Control);

     R.Assign(43, 6, 48, 7);
     Control := New(PColoredText, Init(R, '00000', $71, cmKompilacjaIloscLinii));
     Wskazniki[cmKompilacjaIloscLinii] := Control;
     Dlg^.Insert(Control);

     R.Assign(1, 9, 49, 10);
     Control := New(PColoredText, Init(R, 'Kompilowanie...', $1F, cmKompilacjaStatusKoncowy));
{     Control := New(PColoredText, Init(R, 'Kompilacja zakoäczona pomy˜lnie', $1F, cmKompilacjaStatusKoncowy));}
     Wskazniki[cmKompilacjaStatusKoncowy] := Control;
     Dlg^.Insert(Control);

     Dlg^.SelectNext(False);
     MakeKompilacjaDlg := Dlg;
end;


end.
