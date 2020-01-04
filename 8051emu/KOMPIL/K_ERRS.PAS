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
     ErrArray[ 1] := NewStr('Niewˆa˜ciwa warto˜†');
     ErrArray[ 2] := NewStr('Niewˆa˜ciwa dyrektywa kompilatora');
     ErrArray[ 4] := NewStr('Spodziewany AB');
     ErrArray[ 8] := NewStr('Niewˆa˜ciwe adresowanie bitowe');
     ErrArray[ 9] := NewStr('Niewˆa˜ciwa nazwa pliku');
     ErrArray[10] := NewStr('Bˆ¥d skˆadni');
     ErrArray[11] := NewStr('Etykieta nie odnaleziona');
     ErrArray[12] := NewStr('Etykieta po za zakresem adresowania');
     ErrArray[13] := NewStr('Cofni©cie rejestr¢w w instrukcji ORG');
     ErrArray[14] := NewStr('Staˆa o tej nazwie ju¾ istnieje');
     ErrArray[15] := NewStr('Etykieta o tej nazwie ju¾ istnieje');
     ErrArray[17] := NewStr('Zbyt du¾o dyerktyw INCLDUE');
     ErrArray[18] := NewStr('Za maˆo dyrektyw INCLUDE ?????. Prosze o kontakt z autorem');
     ErrArray[19] := NewStr('Brak podanego pliku');
     ErrArray[20] := NewStr('Niewˆa˜ciwy typ procka');
     ErrArray[21] := NewStr('Ta dyrektywa/opcja nie zostaˆa zaimplementowana');
     ErrArray[22] := NewStr('Niewˆa˜ciwa ilo˜† parametr¢w');
     ErrArray[23] := NewStr('Parametry niezgodne lub niewˆa˜ciwe');
     ErrArray[24] := NewStr('Taka nazwa bitu ju¾ istnieje');
     ErrArray[25] := NewStr('Bˆ¥d w zapisie bitu');
     ErrArray[26] := NewStr('Brak zaznaczonego koäca makra');
     ErrArray[27] := NewStr('½adne makro nie zostaˆo rozpocz©te');
     ErrArray[28] := NewStr('Zbyt du¾o parametr¢w przy definicji makra');
end.

