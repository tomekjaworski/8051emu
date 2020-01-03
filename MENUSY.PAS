{{$DEFINE LISTA_OKIEN}
unit Menusy;
interface
Uses Menus, Objects, App, Views, Drivers, Stale, Editors;

function MakeMenuGlowne: PMenuBar;

implementation

function MakeMenuGlowne: PMenuBar;
var
  Menu: PMenuBar;
  R: TRect;
begin
  R.Assign(0, 0, 80, 1);
  Menu := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu('~'#1'~', hcNoContext, NewMenu(
      NewItem('~O~ programie...', '', kbNoKey, cmOProgramie, hcNoContext,
      NewLine(
      NewItem('~K~alkulator', '', kbNoKey, cmKalkulator, hcNoContext,
      NewItem('~T~abela ASCII', '', kbNoKey, cmTabelaASCII, hcNoContext,
      NewItem('K~a~lendarz', '', kbNoKey, cmKalendarz, hcNoContext,
      nil)))))),
    NewSubMenu('~P~lik', hcNoContext, NewMenu(
      NewItem('~N~owy', '', kbNoKey, cmNew, hcNew,
      NewLine(
      NewItem('~O~tw¢rz...', 'F3', kbF3, cmOpen, hcOpen,
      NewItem('O~s~tatnio otwarte pliki...', '', kbNoKey, cmOstatnioOtwartePliki, hcNoContext,
      NewItem('~Z~apisz', 'F2', kbF2, cmSave, hcSave,
      NewItem('Z~a~pisz jako...', '', kbNoKey, cmSaveAs, hcSaveAs,
      NewItem('Zapisz w~s~zystkie', '', kbNoKey, cmSaveAll, hcSaveAll,
{      NewLine(
      NewItem('Z~m~ieä katalog...', '', kbNoKey, cmChangeDir, hcChangeDir,
      NewItem('Tryb MS-~D~OS', '', kbNoKey, cmDosShell, hcDosShell,}
      NewLine(
      NewItem('~K~oniec', 'Alt+X', kbAltX, cmKoniec, hcExit,
      nil)))))))))){)))},
    NewSubMenu('~E~dycja', hcNoContext, NewMenu(
      NewItem('Co~f~nij', 'Alt+Backspace', kbAltBack, cmUndo, hcUndo,
      NewLine(
      NewItem('~W~ytnij', 'Shift+Del', kbShiftDel, cmCut, hcCut,
      NewItem('~K~opiuj', 'Ctrl+Ins', kbCtrlIns, cmCopy, hcCopy,
      NewItem('Wk~l~ej', 'Shift+Ins', kbShiftIns, cmPaste, hcPaste,
      NewItem('W~y~czy˜†', 'Ctrl+Del', kbCtrlDel, cmClear, hcClear,
      NewLine(
      NewItem('~S~zukaj...', '', kbNoKey, cmFind, hcNoContext,
      NewItem('~Z~ast¥p...', '', kbNoKey, cmReplace, hcNoContext,
      NewItem('Szukaj ~p~onownie', '', kbNoKey, cmSearchAgain, hcNoContext,
      NewLine(
      NewItem('Poka¾ s~c~howek', '', kbNoKey, cmPokazSchowek, hcNoContext,
      nil))))))))))))),
    NewSubMenu('~K~ompilacja', hcNoContext, NewMenu(
      NewItem('~K~ompiluj', 'F4', kbF4, cmKompiluj, hcNoContext,
      NewLine(
      NewItem('~P~rocesor...', '', kbNoKey, cmTypProcka, hcNoContext,
      NewItem('~D~omy˜lny plik...', '', kbNoKey, cmPlikDomyslny, hcNoContext,
      NewItem('~B~rak pliku domy˜lnego', '', kbNoKey, cmBrakPlikuDomyslnego, hcNoContext,
{      NewLine(
      NewItem('~I~nformacja...', '', kbNoKey, 65503, hcNoContext,}
      nil{))})))))),
    NewSubMenu('P~a~mi©†', hcNoContext, NewMenu(
      NewSubMenu('Pami©† R~O~M', hcNoContext, NewMenu(
        NewItem('~W~czytaj...', '', kbNoKey, cmWczytajRom, hcNoContext,
        NewItem('~Z~apisz...', '', kbNoKey, cmZapiszRom, hcNoContext,
        NewLine(
        NewItem('~E~dytuj...', '', kbNoKey, cmEdytujROM, hcNoContext,
        NewItem('~W~yczy˜† zawarto˜† pami©ci', '', kbNoKey, cmWyczyscRom, hcNoContext,
        nil)))))),
      NewSubMenu('Pami©† R~A~M', hcNoContext, NewMenu(
        NewItem('~W~czytaj...', '', kbNoKey, cmWczytajRAM, hcNoContext,
        NewItem('~Z~apisz...', '', kbNoKey, cmZapiszRAM, hcNoContext,
        NewLine(
        NewItem('~E~dytuj...', '', kbNoKey, cmEdytujRAM, hcNoContext,
        NewItem('~W~yczy˜† zawarto˜† pami©ci', '', kbNoKey, cmWyczyscRAM, hcNoContext,
        nil)))))),
      nil))),
    NewSubMenu('P~r~ocesor', hcNoContext, NewMenu(
      NewItem('~O~tw¢rz okno CPU', '', kbNoKey, cmOtworzOknoCPU, hcNoContext,
      NewLine(
      NewItem('~R~eset procka', 'Ctrl+F2', kbCtrlF2, cmResetProcka, hcNoContext,
      NewItem('~K~rok', 'F8', kbF8, cmProcekKrok, hcNoContext,
      NewItem('—~l~ed«', 'F7', kbF7, cmProcekSledz, hcNoContext,
      NewItem('~U~ruchom', 'F9', kbF9, cmProcekUruchom, hcNoContext,
      NewItem('~Z~eruj cykle', '', kbNoKey, cmZerujCykle, hcNoContext,
      NewLine(
      NewItem('~D~odaj/usuä puˆapk©', 'Ctrl+F8', kbCtrlF8, cmDodajUsunPulapke, hcNoContext,
      NewItem('U~s~uä wszystkie puˆapki', '', kbNoKey, cmUsunWszystkiePulapki, hcNoContext,
      NewLine(
      NewSubMenu('Prz~e~rwania', hcNoContext, NewMenu(
        NewItem('Z~e~wn©trzne INT0', '', kbNoKey, cmINT0, hcNoContext,
        NewItem('Ze~w~n©trzne INT1', '', kbNoKey, cmINT1, hcNoContext,
        NewItem('Li~c~znikowe T0', '', kbNoKey, cmT0, hcNoContext,
        NewItem('Lic~z~nikowe T1', '', kbNoKey, cmT1, hcNoContext,
        NewItem('Szere~g~owe RI (odbi¢r)', '', kbNoKey, cmRI, hcNoContext,
        NewItem('Szereg~o~we TI (wysyˆabnie)', '', kbNoKey, cmTI, hcNoContext,
        nil))))))),
      nil))))))))))))),
    NewSubMenu('~S~ymbole', hcNoContext, NewMenu(
        NewItem('~W~czytaj...', '', kbNoKey, cmWczytajSymbole, hcNoContext,
        NewItem('~E~dytuj...', '', kbNoKey, cmEdytujSymbole, hcNoContext,
        NewItem('~Z~apisz...', '', kbNoKey, cmZapiszSymbole, hcNoContext,
        NewLine(
        NewItem('~U~suä wszystkie', '', kbNoKey, cmUsunWszystkieSymbole, hcNoContext,
        nil)))))),
    NewSubMenu('~O~kna', hcNoContext, NewMenu(
        NewItem('~R~¢wnolegle', '', kbNoKey, cmTile, hcTile,
        NewItem('K~a~skadowo', '', kbNoKey, cmCascade, hcCascade,
        NewItem('Zamknij ~w~szystkie', '', kbNoKey, cmCloseAll, hcCloseAll,
        NewLine(
        NewItem('Z~m~ieä rozmiar/Przesuä','Ctrl+F5', kbCtrlF5, cmResize, hcResize,
        NewItem('P~o~wi©ksz', 'F5', kbF5, cmZoom, hcZoom,
        NewItem('~N~ast©pne', 'F6', kbF6, cmNext, hcNext,
        NewItem('~P~oprzednie', 'Shift+F6', kbShiftF6, cmPrev, hcPrev,
        NewItem('~Z~amknij', 'Alt+F3', kbAltF3, cmClose, hcClose,
{$IFDEF LISTA_OKIEN}
        NewLine(
        NewItem('~L~ista...','Alt+0', kbAlt0, cmListaOkien, hcNoContext,
        nil)))))))))))),
{$ELSE}
        nil)))))))))),
{$ENDIF}
    nil))))
  )))))));
  MakeMenuGlowne := Menu;
end;
end.

function StdFileMenuItems(Next: PMenuItem): PMenuItem;
begin
  StdFileMenuItems :=
    NewItem('~N~ew', '', kbNoKey, cmNew, hcNew,
    NewItem('~O~pen...', 'F3', kbF3, cmOpen, hcOpen,
    NewItem('~S~ave', 'F2', kbF2, cmSave, hcSave,
    NewItem('S~a~ve as...', '', kbNoKey, cmSaveAs, hcSaveAs,
    NewItem('Save a~l~l', '', kbNoKey, cmSaveAll, hcSaveAll,
    NewLine(
    NewItem('~C~hange dir...', '', kbNoKey, cmChangeDir, hcChangeDir,
    NewItem('~D~OS shell', '', kbNoKey, cmDosShell, hcDosShell,
    NewItem('E~x~it', 'Alt+X', kbAltX, cmQuit, hcExit,
    Next)))))))));
end;

function StdEditMenuItems(Next: PMenuItem): PMenuItem;
begin
  StdEditMenuItems :=
    NewItem('~U~ndo', '', kbAltBack, cmUndo, hcUndo,
    NewLine(
    NewItem('Cu~t~', 'Shift+Del', kbShiftDel, cmCut, hcCut,
    NewItem('~C~opy', 'Ctrl+Ins', kbCtrlIns, cmCopy, hcCopy,
    NewItem('~P~aste', 'Shift+Ins', kbShiftIns, cmPaste, hcPaste,
    NewItem('C~l~ear', 'Ctrl+Del', kbCtrlDel, cmClear, hcClear,
    Next))))));
end;

