Unit K_Errs;
interface

Uses Objects;

const
     errNiewlasciwaWartosc              = 1;
     errNiewlasciwaDyrektywaKompilatora = 2;
     errSpodziewanyAB                   = 4;
     errNiewlasciweAdresowanieBitowe    = 8;
     errNiewlasciwaNazwaPliku           = 9;
     errBladSkladni                     = 10;
     errEtykietaNieOdnaleziona          = 11;
     errEtykietaPozaZakresemAdresowania = 12;
     errCofniecieAdresow                = 13;
     errTakaStalaJuzIstnieje            = 14;
     errTakaEtykietaJuzIstnieje         = 15;
{wersja 2.00}
     errZbytDuzoInclude                 = 17;
     errZaMaloElementowNaStosie         = 18;
     errBrakPodanegoPliku               = 19;
     errNiewlasciwyTypProcka            = 20;
     errBrakImplementacji               = 21;
     errNiewlasciwaIloscParametrow      = 22;
     errBrakZgodnosciParametrow         = 23;
     errTakaNazwaBituJuzIstnieje        = 24;
     errBladBitu                        = 25;
     errBrakKoncaMakra                  = 26;
     errMakroNieRozpoczete              = 27;
     errZbytDuzoParametrowMakra         = 28;
var ErrArray:array[1..30] of PString;

implementation
begin
     ErrArray[ 1] := NewStr('Niew�a�ciwa warto��');
     ErrArray[ 2] := NewStr('Niew�a�ciwa dyrektywa kompilatora');
     ErrArray[ 4] := NewStr('Spodziewany AB');
     ErrArray[ 8] := NewStr('Niew�a�ciwe adresowanie bitowe');
     ErrArray[ 9] := NewStr('Niew�a�ciwa nazwa pliku');
     ErrArray[10] := NewStr('B��d sk�adni');
     ErrArray[11] := NewStr('Etykieta nie odnaleziona');
     ErrArray[12] := NewStr('Etykieta po za zakresem adresowania');
     ErrArray[13] := NewStr('Cofni�cie rejestr�w w instrukcji ORG');
     ErrArray[14] := NewStr('Sta�a o tej nazwie ju� istnieje');
     ErrArray[15] := NewStr('Etykieta o tej nazwie ju� istnieje');
     ErrArray[17] := NewStr('Zbyt du�o dyerktyw INCLDUE');
     ErrArray[18] := NewStr('Za ma�o dyrektyw INCLUDE ?????. Prosze o kontakt z autorem');
     ErrArray[19] := NewStr('Brak podanego pliku');
     ErrArray[20] := NewStr('Niew�a�ciwy typ procka');
     ErrArray[21] := NewStr('Ta dyrektywa/opcja nie zosta�a zaimplementowana');
     ErrArray[22] := NewStr('Niew�a�ciwa ilo�� parametr�w');
     ErrArray[23] := NewStr('Parametry niezgodne lub niew�a�ciwe');
     ErrArray[24] := NewStr('Taka nazwa bitu ju� istnieje');
     ErrArray[25] := NewStr('B��d w zapisie bitu');
     ErrArray[26] := NewStr('Brak zaznaczonego ko�ca makra');
     ErrArray[27] := NewStr('�adne makro nie zosta�o rozpocz�te');
     ErrArray[28] := NewStr('Zbyt du�o parametr�w przy definicji makra');
end.

