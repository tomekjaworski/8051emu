{$IFDEF DPMI}
Uses Crt, Dos, WinDos, WinApi, Dialogs, StdDlg, Drivers, Objects, App, MsgBox,
     Okienka, Menusy, Menus, Views, Textoolz, ColorTxt, Nazwy, Zmienne,
     Procki, Inst8051, Symb, Rej_Adr, Stale, MyViews, Strings, Calc, AsciiTab,
     Konfig, IntelHEX, MMsgBox, ViewHex, Ed, Editors, Memory, ColorSel,
     HistList, HelpFile, MenuUtil, Calendar;
{$ELSE}
Uses Crt, Dos, Dialogs, StdDlg, Drivers, Objects, App, MsgBox,
     Okienka, Menusy, Menus, Views, Textoolz, ColorTxt, Nazwy, Zmienne,
     Procki, Inst8051, Symb, Rej_Adr, Stale, MyViews, Strings, Calc, AsciiTab,
     Konfig, IntelHEX, MMsgBox, ViewHex, Ed, Editors, Memory, ColorSel,
     HistList, HelpFile, MenuUtil, Calendar;
{$ENDIF}

type PWord = ^Word;

type TDebugger = object(TApplication)
       OknoPomocyOtwarte:Boolean;
       constructor Init;
       destructor Done; virtual;
       procedure HandleEvent(var Event: TEvent); virtual;
       procedure InitDesktop; virtual;
       procedure InitMenuBar; virtual;
       procedure InitStatusLine; virtual;
       procedure Idle; virtual;
       procedure OutOfMemory; virtual;
       Procedure EdytorSymboli;
       Procedure Kalkulator;
       procedure TabelaASCII;
       procedure Kalendarz;
       procedure ZapiszSymbole;
       procedure WczytajSymbole;
       procedure WczytajZawartoscPamieciRAM;
       procedure WczytajZawartoscPamieciROM;
       procedure ZapiszZawartoscPamieciROM;
       procedure ZapiszZawartoscPamieciRAM;
       procedure UsunWszystkieSymbole;
       procedure OtworzOknoCPU(OstrzegajGdyOtwarte:Boolean);
       procedure WyczyscZawartoscPamieciRAM;
       procedure WyczyscZawartoscPamieciROM;
       procedure ResetProcka;
       procedure ListaOkien;
       procedure ZerujCykle;
       procedure ProcesorSledz;
       procedure ProcesorKrok;
       procedure ProcesorUruchom;
       procedure UsunWszystkiePulapki;
       procedure EdytujROM;
       procedure EdytujRAM;
       procedure DodajusunPulapke;
       procedure PokazSchowek;
       procedure OtworzPlik;
       procedure NowyPlik;
       procedure ZmienKatalog;
       procedure UstawTypProcesora(StartProgramu:Boolean);
       procedure ZapiszOkna(var St:TStream);
       procedure ZapiszPulpit;
       procedure KompilacjaProgramu;
       procedure ShowHelp(aHelpCtx:word);
       function  GetPalette: PPalette; virtual;
       procedure GetEvent(var Event: TEvent); virtual;
     end;


     PPoleSledzeniaKodu = ^TPoleSledzeniaKodu;
     TPoleSledzeniaKodu = object(TView)
{       AdresWOkienkuRodzica:PWord;}
       AdresyOknaKodu:array[1..32] of word;
       AdresOkienka:Word;
       NumerLinii:Byte;
       Wlasciciel:PWindow;
       procedure Draw; virtual;
       function WyswietlInstrukcje(x,y:byte;AdresDASM:word;Podswietlony:Boolean;KolorPodsw:Byte):Byte;
       constructor Init(var Bounds:TRect);
       procedure HandleEvent(var Event:TEvent); virtual;
       procedure Up;
       procedure Down;
       Procedure PageUp;
       Procedure PageDown;
       Procedure Top;
       procedure UstawAdresOkienka(Adr:Word);
     end;

type POknoSledzenia = ^TOknoSledzenia;
     TOknoSledzenia = object(TWindow)
       FlagaCY, FlagaAC, FlagaF0, FlagaRS1, FlagaRS0, FlagaOV : PColoredText;
       FlagaUNDEF, FlagaP, NumerBanku : PColoredText;
       RejestrDPTR, RejestrPC, RejestrACC, RejestrB:PColoredText;
       RejestrR0,RejestrR2,RejestrR4,RejestrR6:PColoredText;
       RejestrR1,RejestrR3,RejestrR5,RejestrR7:PColoredText;
       PortP1, PortP3, RejestrSP, WartoscSP:PColoredText;
       WartoscSP1, WartoscSP2, WartoscSP3, WartoscSP4, WartoscSP5:PColoredText;
       WartoscSP6, WartoscSP7, WartoscSP8, WartoscSP9 :PColoredText;
       RejestrSCON, RejestrTCON, RejestrSBUF:PColoredText;
       WartoscLicznikaT0, WartoscLicznikaT1:PColoredtext;
       PoleSledzeniaKodu:PPoleSledzeniaKodu;
       RejestrPCON, RejestrTMOD : PColoredtext;
       PoziomLO, PoziomHI, RejestrIP, RejestrIE:PColoredText;
       LiczbaCykli: PColoredText;
       constructor Init;
       destructor Done; virtual;
       procedure Draw; virtual;
       procedure HandleEvent(var Event: TEvent); virtual;
       procedure Redraw; virtual;
       procedure UstawWartosciMonitoraRejestrow;
       procedure SizeLimits(var Min, Max:TPoint); virtual;
     end;


Type PMyEditWindow = ^TMyEditWindow;
     TMyEditWindow = object(TEditWindow)
       function GetTitle(MaxSize: Integer): TTitleStr; virtual;
       procedure HandleEvent(var Event:TEvent); virtual;
     end;

function TMyEditWindow.GetTitle(MaxSize: Integer): TTitleStr;
begin
  if Pointer(Editor) = Pointer(Clipboard)
     then GetTitle := 'Schowek'
     else if Editor^.FileName = ''
             then GetTitle := 'Beznazwy'
             else GetTitle := Editor^.FileName;
end;

Procedure UruchomKompilator(var Wymiana:PWymianaZKompilatorem);
begin
end;


var OknoCPU:POknoSledzenia;
    pam:PWskaznikPamieci;
    Debugger:TDebugger;
    Schoweczek:PMyEditWindow;
    OknoAktywnegoEdytora:PMyEditWindow;
{    OknoKompilatora:PDialog;}

procedure TMyEditWindow.HandleEvent(var Event:TEvent);
begin
     inherited HandleEvent(Event);
     if Event.What = evBroadcast then
     begin
          if event.command = cmReleasedFocus
             then OknoAktywnegoEdytora := nil;
          if event.command = cmReceivedFocus
             then if (event.InfoPtr <> Schoweczek) and (event.infoptr = @self)
                     then OknoAktywnegoEdytora := PMyEditWindow(Event.InfoPtr);
     end;
end;

{$i INCLUDE\przerwan.pas}
{$i INCLUDE\os_init.pas}
{$i INCLUDE\os_monit.pas}
{$i INCLUDE\os_procki.pas}
{$i INCLUDE\db_procki.pas}
{$i INCLUDE\db_io.pas}
{$i INCLUDE\db_help.pas}
{$i INCLUDE\ps_procki.pas}
{$i INCLUDE\rom_ram.pas}
{$i INCLUDE\sym.pas}
{$i INCLUDE\up_reset.pas}
{$i INCLUDE\deskt.pas}
{$i INCLUDE\okno_cpu.pas}
{$i INCLUDE\traps.pas}
{$i INCLUDE\edytor.pas}

{****************************************************************************}
{****************************************************************************}

procedure TDebugger.UstawTypProcesora(StartProgramu:Boolean);
var Menu:PMenuItem;
    Naz:String;
    WyborProcka:record
        {TListBoxRec}
        Elementy:PCollection;
        Wybor:Integer;
    end;
    i:byte;
begin
     Menu := FindMenuByID(cmTypProcka, MenuBar^.Menu);
     if not Assigned(Menu) then exit;
     if not StartProgramu then
     begin
          FillChar(WyborProcka, SizeOf(WyborProcka), 0);

          WyborProcka.Elementy := New(PCollection, Init(2, 2));
          WyborProcka.Elementy^.Insert(NewStr('AT98C1051'));
          WyborProcka.Elementy^.Insert(NewStr('AT98C2051'));
          WyborProcka.Elementy^.Insert(NewStr('AT98C4051'));
          WyborProcka.Elementy^.Insert(NewStr('wedˆug autora'));
          WyborProcka.Wybor := Byte(Cfg.TypProcesora);

          if ExecuteDialog(MakeWyborProckaDlg, @WyborProcka) <> cmCancel
          then Cfg.TypProcesora := TTypProcesora(WyborProcka.Wybor);

          for i := 1 to WyborProcka.Elementy^.Count do
          begin
               DisposeStr(PString(WyborProcka.Elementy^.Items^[0]));
               WyborProcka.Elementy^.AtDelete(0);
          end;
          Dispose(WyborProcka.Elementy, Done);
     end;
     case Cfg.TypProcesora of
            tp1051: naz := 'AT89C1051';
            tp2051: Naz := 'AT89C2051';
            tp4051: Naz := 'AT89C4051';
          tpAutora: Naz := 'wedˆug autora';
     end;
     DisposeStr(Menu^.Param);
     Menu^.Param := NewStr(Naz);
end;

Function FindColoredTextByCommand(Grp:PGroup; Command:Word):PView;
var Root:PView;
begin
     Root := Grp^.Last;
     FindColoredTextByCommand := nil;
     while Root <> nil do
     begin
          if TypeOf(Root^) = TypeOf(TColoredText) then
          begin
               if PColoredText(Root)^.Command = Command then
               begin
                    FindColoredTextByCommand := Root;
                    exit;
               end;
          end;
          Root := Root^.Next;
     end;
end;


Procedure WyswietlBlad(X, Y, W:Byte; Msg:String);
var i:word;
begin
     for i := 0 to W-1 do
     begin
          Mem[SegB800:((X+i)+Y*80)*2+1] := (Red shl 4) or White;
          Mem[SegB800:((X+i)+Y*80)*2] := 32;
     end;
     Inc(x);
     for i := 1 to Ord(Msg[0]) do Mem[SegB800:((X+i-1)+Y*80)*2] := Ord(Msg[i]);
end;


procedure TDebugger.KompilacjaProgramu;
var Nazwa:String;
    Gdzie:TRect;
    ev:TEvent;
    Zwrot:PWymianaZKompilatorem;
    Tekst:String;
    BuforEkranu:Pointer;
    StareX, StareY:Byte;
    StareTextAttr:Byte;
begin
     if Assigned(OknoAktywnegoEdytora) then
     begin
          if not OknoAktywnegoEdytora^.Editor^.Save then Exit;
          Nazwa := OknoAktywnegoEdytora^.GetTitle(70);
     end else Exit;
     New(Zwrot); FillChar(Zwrot^, SizeOf(TWymianaZKompilatorem), #0);
     Zwrot^.PlikWe := Nazwa;

     GetMem(BuforEkranu, 80*25*2);
     Move(Ptr(SegB800,0)^, BuforEkranu^, 80*25*2);
     StareX := WhereX; StareY := WhereY; StareTextAttr := TextAttr;

     FillChar(Ptr(SegB800,0)^, 80*25*0, 0);

     UruchomKompilator(Zwrot);

     GotoXY(StareX, StareY);
     TextAttr := StareTextAttr;
     Move(BuforEkranu^, Ptr(SegB800,0)^, 80*25*2);
     FreeMem(BuforEkranu, 80*25*2);
     if not Zwrot^.JestBlad then
     begin
          ClearEvent(Ev);
          repeat
                GetEvent(Ev);
          until (Ev.What = evKeyDown) or (ev.What = evMouseDown);
          PutEvent(Ev);
     end else
     begin
          OknoAktywnegoEdytora^.GetBounds(Gdzie);
          Inc(Gdzie.A.X); Inc(Gdzie.A.Y, 2);
          Tekst := Copy(Zwrot^.OpisBledu, 1, Gdzie.B.X-Gdzie.A.X-1);
          With OknoAktywnegoEdytora^.Editor^ do
          begin
               Lock;
               SetCurPtr(LineMove(0, Zwrot^.LiniaBledu), 0);
               TrackCursor(True);
               Unlock;
               WyswietlBlad(Gdzie.A.X, Gdzie.A.Y, Gdzie.B.X-Gdzie.A.X-1, Tekst);
               ClearEvent(Ev);
               repeat
                     GetEvent(Ev);
               until (Ev.What = evKeyDown) or (ev.What = evMouseDown);
               PutEvent(Ev);
               OknoAktywnegoEdytora^.Draw;
          end;
     end;
     Dispose(Zwrot);
end;

{****************************************************************************}
{****************************************************************************}
procedure TDEbugger.ListaOkien;
begin
end;

procedure TDebugger.HandleEvent(var Event: TEvent);
{var x:word;}
begin
     case Event.What of
          evKeyDown:
            begin
                 if event.keycode = kbesc then
                 begin
{                      EndModal(cmQuit);}
                 end;
{                 if event.keycode = kbAlt1 then ShowHelp(33+Random(100));}
            end; {zdarzenie evKeyDown}
          evCommand:
            begin
                 case Event.Command of
{                      cmHelp: Show}
                      cmOProgramie: ExecuteDialog(MakeAboutDlg, nil);
                      cmKoniec: EndModal(cmQuit);
                      cmEdytujSymbole: EdytorSymboli;
                      cmResetProcka: ResetProcka;
                      cmKalkulator: Kalkulator;
                      cmTabelaASCII: TabelaASCII;
                      cmKalendarz: Kalendarz;
                      cmWczytajSymbole: WczytajSymbole;
                      cmZapiszSymbole: ZapiszSymbole;
                      cmUsunWszystkieSymbole:UsunWszystkieSymbole;
                      cmOtworzOknoCPU: OtworzOknoCPU(True);
                      cmWczytajROM: WczytajZawartoscPamieciROM;
                      cmWczytajRAM: WczytajZawartoscPamieciRAM;
                      cmZapiszROM: ZapiszZawartoscPamieciROM;
                      cmZapiszRAM: ZapiszZawartoscPamieciRAM;
                      cmWyczyscROM: WyczyscZawartoscPamieciROM;
                      cmWyczyscRAM: WyczyscZawartoscPamieciRAM;
                      cmListaOkien: ListaOkien;
                      cmZerujCykle: ZerujCykle;
                      cmProcekKrok: ProcesorKrok;
                      cmProcekSledz: ProcesorSledz;
                      cmProcekUruchom: ProcesorUruchom;
                      cmUsunWszystkiePulapki: UsunWszystkiePulapki;
                      cmEdytujRom: EdytujRom;
                      cmEdytujRAM: EdytujRAM;
                      cmDodajUsunPulapke: DodajUsunPulapke;
                      cmPokazSchowek: PokazSchowek;
                      cmNew: NowyPlik;
                      cmOpen: OtworzPlik;
                      cmKompiluj: KompilacjaProgramu;
                      cmQuit: EndModal(cmQuit);
                     cmTypProcka: UstawTypProcesora(False);
                     cmKompiluj: UstawTypProcesora(False);

                     cmPreviousTopic: ShowHelp(PreviousTopic);
  {                    cmSave: Beep(300);
                      cmSaveAs: Beep(400);
                      cmSaveAll: Beep(500);
                      cmChangeDir: ZmienKatalog;
                      cmDosShell: Beep(700);    }
                 end; {event.command}
            end; {evCommand}
          evBroadcast:
            begin
            end;
     end;
     inherited HandleEvent(Event);
     ClearEvent(event);
end;

procedure TDEbugger.InitDesktop;
begin
     inherited InitDesktop;
end;

procedure TDebugger.InitMenuBar;
begin
{     inherited InitMenuBar;}
     MenuBar := MakeMenuGlowne;
     UstawTypProcesora(True);
end;

procedure TDebugger.InitStatusLine;
var R:TRect;
begin
     GetExtent(R);
     R.A.Y := R.B.Y - 1;
     StatusLine := New(PStatusLine, Init(R,
      NewStatusDef(hcHelpWindow, hcHelpWindow,
{        StdStatusKeys(}
{        NewStatusKey('~F1~ Korzystanie z pomocy', kbF1, cmHelpOnHelp,}
        NewStatusKey('~Alt+F1~ Cofnij', kbAltF1, cmPreviousTopic,
        NewStatusKey('~Alt+C~ Kontekst', kbAltC, cmHelpContents,
        NewStatusKey('~F5~ Zoom', kbF5, cmZoom,
        NewStatusKey('~Esc~ Zamknij pomoc', kbEsc, cmClose,
      Nil)))),
      NewStatusDef(hcOknoCPU, hcOknoCPU,
        NewStatusKey('~F1~ Pomoc', kbF1, cmHelp,
        NewStatusKey('~Alt-F3~ Zamknij', kbAltF3, cmClose,
{        NewStatusKey('~Ctrl+F2~ Reset', kbCtrlF2, cmResetProcka,
        NewStatusKey('~Ctrl+F8~ Puˆapka', kbCtrlF8, cmDodajUsunPulapke,}
        NewStatusKey('~F7~ —led«', kbF7, cmProcekSledz,
        NewStatusKey('~F8~ Krok', kbF8, cmProcekKrok,
        NewStatusKey('~F9~ Uruchom', kbF9, cmProcekUruchom,
        NewStatusKey('', kbF10, cmMenu,
        nil)))))){))},
      NewStatusDef($0000, $FFFF,
        NewStatusKey('~F1~ Pomoc', kbF1, cmHelp,
        NewStatusKey('~Alt-X~ Koniec', kbAltX, cmQuit,
        NewStatusKey('~F3~ Otw¢rz', kbF3, cmOpen,
        NewStatusKey('~Alt-F3~ Zamknij', kbAltF3, cmClose,
        NewStatusKey('~F5~ Zoom', kbF5, cmZoom,
        NewStatusKey('', kbF10, cmMenu,
        NewStatusKey('', kbCtrlF5, cmResize,
        nil))))))),
      nil)))));
end;

procedure TDebugger.Idle;
begin
     inherited Idle;
     TApplication.Idle;
     if Assigned(pam) then pam^.Update;
end;

constructor TDebugger.Init;
var r:trect;
begin
{$IFNDEF DPMI}
     MaxHeapSize := 240*(1024 div 16);

{$ENDIF}
     inherited Init;

     DisableCommands([cmSave, cmSaveAs, cmCut, cmCopy, cmPaste, cmClear,
                      cmUndo, cmFind, cmReplace, cmSearchAgain]);
     {EditorDialog := ZdarzeniaEdytora;}
     GetExtent(r);
     r.assign(72,24,81,25);
     pam := new(PWskaznikPamieci, Init(r));
     insert(pam);

     Schoweczek := Nil;
     OknoAktywnegoEdytora := nil;
     Schoweczek := OtworzEdytor('', False);
     if Assigned(Schoweczek) then
     begin
          Clipboard := Schoweczek^.Editor;
          Clipboard^.CanUndo := False;
          Schoweczek^.HelpCtx := hcOknoSchowek;
     end else OutOfMemory;
     WpisDoSBUF := False; IleSymboli := 0; IlePulapek := 0; IloscCykli := 0;
     PC := $0000;
     FillChar(Pulapki, SizeOf(Pulapki), #0);

     New(Symbole);
     AlokujPamieciProcka;
     OknoCPU := nil;
     OknoPOmocyOtwarte := False;
{     OknoKompilatora := nil;}
end;

destructor TDebugger.Done;
begin
{     ZapiszPulpit;}
     inherited Done;

     ZwolnijPamieciProcka;
     Dispose(Symbole);
end;


var mema, maxa:longint;
var x:PMenuView;
begin
     mema:= MemAvail;
     maxa := MaxAvail;

     Debugger.Init;
     Debugger.Run;
     Debugger.Done;

Writeln(MemA, ' bytes available');
Writeln('Largest free block is ', MaxA, ' bytes');
Writeln(MemAvail, ' bytes available');
Writeln('Largest free block is ', MaxAvail, ' bytes');
WriteLn('Program wpieprzyˆ ',MemA-MemAvail,' bajt¢w');

end.

