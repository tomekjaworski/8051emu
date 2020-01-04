unit Symb;
interface
Uses Zmienne, Textoolz, Stale, Strings, Procki, Dialogs, MyViews, Drivers,
     Objects, Views, Rej_Adr, App, MsgBox, Konfig;

Type PEdytorSymboli = ^TEdytorSymboli;
     TEdytorSymboli = object (TDialog)
       Lista:PMyListBox;
       constructor Init;
       destructor done; virtual;
       procedure HandleEvent(var Event:TEvent); virtual;
     end;


procedure DodajSymbol(Nazwa:String;Adres:Word;Gdzie:TTypPamieci);
procedure String2NazwaSymbolu(Nazwa:String; var Naz:TNazwaSymbolu);
procedure DodajSymbolBezposrednio(Sym:TSymbol);
procedure ZapiszSymboleNaDysk(naz:string);
Procedure WczytajSymboleZDysku(plik:String);
Function ZnajdzSymbolROM(Adres:Word):String;
Function ZnajdzSymbolROMAJakNieToNic(Adres:Word):String;
Function ZnajdzSymbolRAM(Adres:Word):String;

implementation
Uses Nazwy;

procedure DodajSymbol(Nazwa:String;Adres:Word;Gdzie:TTypPamieci);
var naz:TNazwaSymbolu;
    Dlg:Byte;
begin
     Nazwa := Trim(Nazwa);
     Dlg := Min(MaxNazwaSymbolu, ord(Nazwa[0]));
     fillChar(Naz, MaxNazwaSymbolu+1, #0);
     move(Nazwa[1], naz, dlg);
     inc(IleSymboli);
     Symbole^[IleSymboli].Nazwa := Naz;
     Symbole^[IleSymboli].Adres := Adres;
     Symbole^[IleSymboli].TypPamieci := Gdzie;
end;

procedure DodajSymbolBezposrednio(Sym:TSymbol);
begin
     inc(IleSymboli);
     Symbole^[IleSymboli] := Sym;
end;

procedure String2NazwaSymbolu(Nazwa:String; var Naz:TNazwaSymbolu);
var dl:Byte;
begin
     Nazwa := Trim(Nazwa);
     Dl := Min(MaxNazwaSymbolu, ord(Nazwa[0]));
     fillChar(Naz, MaxNazwaSymbolu+1, #0);
     move(Nazwa[1], naz, dl);
end;

Function ZnajdzSymbolROM(Adres:Word):String;
var i:word;
    Mam:Boolean;
begin
     Mam := False;
     for i := 1 to IleSymboli do
     begin
          if (Symbole^[i].TypPamieci = tpROM) and (Symbole^[i].Adres = Adres) then
          begin
               ZnajdzSymbolROM := StrPas(@Symbole^[i].Nazwa);
               Exit;
          end;
     end;
     ZnajdzSymbolROM := Dec2hexWH(adres)
end;

Function ZnajdzSymbolROMAJakNieToNic(Adres:Word):String;
var i:word;
    Mam:Boolean;
begin
     Mam := False;
     for i := 1 to IleSymboli do
     begin
          if (Symbole^[i].TypPamieci = tpROM) and (Symbole^[i].Adres = Adres) then
          begin
               ZnajdzSymbolROMAJakNieToNic := StrPas(@Symbole^[i].Nazwa);
               Exit;
          end;
     end;
     ZnajdzSymbolROMAJakNieToNic := '';
end;

Function ZnajdzSymbolRAM(Adres:Word):String;
var i:word;
    Mam:Boolean;
begin
     Mam := False;
     for i := 1 to IleSymboli do
     begin
          if (Symbole^[i].TypPamieci = tpRAM) and (Symbole^[i].Adres = Adres) then
          begin
               ZnajdzSymbolRAM := StrPas(@Symbole^[i].Nazwa);
               Exit;
          end;
     end;
     ZnajdzSymbolRAM := Dec2hexBH(adres)
end;

constructor TEdytorSymboli.Init;
var
  R : TRect;
  Control : PView;
  i:Word;
  Sym:TSymbol;
  Poz:String;
  Bit:String;
begin
     R.Assign(14, 2, 65, 15);
     inherited Init(R, 'Symbole');
     Options := Options or ofCenterX or ofCenterY;
     HelpCtx := hcOknoSymbole;

     R.Assign(36, 3, 37, 11);
     Control := New(PScrollBar, Init(R));
     Insert(Control);

     R.Assign(3, 3, 36, 11);
     Lista := New(PMyListBox, Init(R, 1, PScrollbar(Control)));
     Insert(Lista);

     R.Assign(2, 2, 11, 3);
     Insert(New(PLabel, Init(R, '~S~ymbole:', Lista)));

     R.Assign(38, 3, 49, 5);
     Control := New(PButton, Init(R, '~E~dytuj', cmEdytujSymbol, bfNormal));
     Insert(Control);

     R.Assign(38, 5, 49, 7);
     Control := New(PButton, Init(R, '~D~odaj', cmDodajSymbol, bfNormal));
     Insert(Control);

     R.Assign(38, 7, 49, 9);
     Control := New(PButton, Init(R, '~U~suä', cmUsunSymbol, bfNormal));
     Insert(Control);

     R.Assign(38, 10, 49, 12);
     Control := New(PButton, Init(R, '~Z~amknij', cmOK, bfDefault));
     Insert(Control);

     SelectNext(False);

     Lista^.List := New(PCollection, Init(10, 10));
     for i := 1 to IleSymboli do
     begin
          Sym := Symbole^[i];
          if Cfg.UkryjAdresyWewnetrzne and (Sym.TypPamieci = tpRAM) and (Byte(Sym.Adres) in WewnetrzneAdresyRejestrow)
             then Continue;
          poz := StrPas(@Sym.Nazwa)+' (';
          Poz := LowerCase(Poz);
          case Sym.TypPamieci of
             tpRAM: Poz := Poz + '0'+Dec2hexB(Sym.Adres)+'h, RAM)';
             tpROM: Poz := Poz + '0'+Dec2HexW(Sym.Adres)+'h, ROM)';
             tpBIT:{ begin
                         DajNazweBitu(Byte(Sym.Adres), Bit, False);
                         Poz := Poz + Bit +', BIT)';
                    end;}
                    Continue;
          end;
          if Sym.TypPamieci in [tpROM, tpRAM]
             then FillChar(Symbole^[i], SizeOf(TSymbol), #0);
          Lista^.List^.Insert(NewStr(Poz));
          Lista^.SetRange(Lista^.List^.Count);
          Lista^.DrawView;
     end;
end;

Procedure OptymalizujListeSymboli;
var i:word;
    licznik:word;
    Symbole2:PTablicaSymboli;
begin
     Symbole2 := New(PTablicaSymboli);
     Licznik := 0;
     for i := 1 to IleSymboli do
     begin
          if Symbole^[i].Nazwa[1] <> #0 then
          begin
               Inc(Licznik);
               Symbole2^[Licznik] := Symbole^[i];
          end;
     end;
     Dispose(Symbole);
     Symbole := Symbole2;
     IleSymboli := licznik;
end;



destructor TEdytorSymboli.done;
var ListaSymboli:TMyListBoxRec;
    i:word;
    Ad,Linia:String;
    Symbol:TSymbol;
    dwAdres:Longint;
begin
     Lista^.GetData(ListaSymboli);

     OptymalizujListeSymboli;

     if ListaSymboli.Items^.Count > 0 then
     begin
          for i := 0 to ListaSymboli.Items^.Count-1 do
          begin
               Linia := PString(ListaSymboli.Items^.At(0))^;
               String2NazwaSymbolu(trim(Copy(Linia, 1, Pos('(', Linia)-1)), Symbol.nazwa);

               Linia := Copy(Linia, Pos('(', Linia)+1, Length(Linia));
               Ad := trim(Copy(Linia, 1, Pos(',', Linia)-1));

               Symbol.TypPamieci := tpBIT;
               if Pos('ROM', Linia) <> 0 then Symbol.TypPamieci := tpROM;
               if Pos('RAM', Linia) <> 0 then Symbol.TypPamieci := tpRAM;

               if Symbol.TypPamieci <> tpBit then
               begin
                    if not Konwersja32Norm(Ad, dwAdres) then
                    begin
                         MessageBox('Bˆ¥d podczas konwersji warto˜ci liczbowej '+Ad, nil, mfError + mfOkButton);
                    end else
                    begin
                         Symbol.Adres := Word(dwAdres);
                         DodajSymbolBezposrednio(Symbol);
                    end;
               end else
               begin

                    MessageBox('Edycja bit¢w nie zaimplementowana', nil, mfError + mfOkButton);
               end;
               DisposeStr(ListaSymboli.Items^.At(0));
               ListaSymboli.Items^.AtDelete(0);
          end;
     end;
     Dispose(ListaSymboli.Items, Done);
     inherited Done;
end;

function MakeSymbolDlg : PDialog;
var
  Dlg : PDialog;
  R : TRect;
  Control : PView;
begin
     R.Assign(11, 7, 69, 16);
     New(Dlg, Init(R, 'Symbol'));
     Dlg^.Options := Dlg^.Options or ofCenterX or ofCenterY;
     Dlg^.Palette := dpBlueDialog;
     Dlg^.HelpCtx := hcOknoEdycjaSymbolu;

     R.Assign(3, 3, 29, 4);
     Control := New(PInputLine, Init(R, MaxNazwaSymbolu));
     Dlg^.Insert(Control);

     R.Assign(2, 2, 9, 3);
     Dlg^.Insert(New(PLabel, Init(R, '~N~azwa:', Control)));

     R.Assign(3, 6, 29, 7);
     Control := New(PInputLine, Init(R, 10));
     Dlg^.Insert(Control);

     R.Assign(2, 5, 13, 6);
     Dlg^.Insert(New(PLabel, Init(R, '~A~dres:', Control)));

     R.Assign(31, 3, 43, 5);
     Control := New(PRadioButtons, Init(R, NewSItem('~R~OM',
                                           NewSItem('R~A~M',nil))));
     Dlg^.Insert(Control);

     R.Assign(30, 2, 42, 3);
     Dlg^.Insert(New(PLabel, Init(R, '~T~yp', Control)));

     R.Assign(45, 2, 55, 4);
     Control := New(PButton, Init(R, '~O~k', cmOK, bfDefault));
     Dlg^.Insert(Control);

     R.Assign(45, 4, 55, 6);
     Control := New(PButton, Init(R, '~A~nuluj', cmOK, bfNormal));
     Dlg^.Insert(Control);

     Dlg^.SelectNext(False);
     MakeSymbolDlg := Dlg;
end;
{
Function CzyZgodnoscZBitem(Nazwa:String):Boolean;
var poz:byte;
    wyn:boolean;
    DummyL:Longint;
    Dummy:Byte;
begin
     if Nazwa[1] in ['/','!'] then exit;
     poz := Pos('.',Nazwa);
     if poz = 0 {numer bitu, 00h - 7Fh}{ then
{     begin
          Wyn := Konwersja32Norm(Nazwa, dummyL);
          Dummy := Byte(DummyL);
          CzyZgodnoscZBitem := Wyn and (Dummy >= $00)
                                   and (Dummy <= $7F)
     end else
     begin
          Wyn := Konwersja32Norm(copy(Nazwa, 1, poz-1), DummyL);
          Dummy := Byte(DummyL);
          wyn := wyn and ((Dummy >= $20) and (Dummy <= $2F) or
                     ((Dummy and $F0 >= $80) and (Dummy and $F0 <= $F0)
                     and (Dummy and $8 in [0, 8])));
          wyn := wyn and Konwersja32Norm(copy(Nazwa, poz+1, ord(Nazwa[0])), dummyL);
          Dummy := Byte(DummyL);
          CzyZgodnoscZBitem := Wyn and (Dummy >= 0) and (Dummy <= 7);
     end;
end;

Function DajAdresBitu(naz:string):Byte;
var p:byte;
    w:Longint;
    adres,bit:string;
    a,b:byte;
begin
     Naz := UpperCase(Naz);
     DajAdresBitu := 0;
     if naz[1] in ['!', '/'] then Delete(naz, 1, 1);
     p := pos('.',naz);
     if p = 0 then {wartosc bezwzgledna}
{     begin
          Konwersja32Norm(naz, w);
          DajAdresBitu := Byte(w);
          Exit;
          {tu ka¾dy bit rejestr¢w SFR ma swoj¥ wag©}
{     end;
     Adres := Trim(Copy(naz,1,p-1));
     Bit := Trim(Copy(naz,p+1,ord(naz[0])));
     Konwersja32Norm(Adres,w); a := Byte(w);
     Konwersja32Norm(Bit,w); b := Byte(w);
     b := b and $07;
     if a in [$20..$2f] then {blok 16-bitowy po banku rejestrow RB3}
{     begin
          Dec(a,$20);
          a := a shl 3;
          a := a + b;
          DajAdresBitu := a;
     end else
     begin
          {format AAAAABBB }
{          if (A and $07) <> 0 then Exit; {bˆad - niewˆa˜ciwe adresownie}
                                         {bitowe}
{          a := a and $F8;
          a := a or b;
          DajAdresBitu := a;
     end;
end;
 }

procedure TEdytorSymboli.HandleEvent(var Event:TEvent);
var linia:string;
    wart:longint;
    l:PString;
    SymbolDlgRec:record
       NazwaSymbolu:String[MaxNazwaSymbolu];
       AdresSymbolu:String[10];
       TypPamieci:Word;
    end;
    SymbolDlg:PDialog;
    Bit:String;
begin
     if Lista^.List^.Count = 0 then
     begin
          DisableCommands([cmUsunSymbol, cmEdytujSymbol]);
     end else
     begin
          EnableCommands([cmUsunSymbol, cmEdytujSymbol]);
     end;
     inherited HandleEvent(Event);
     if event.what = evcommand then
     begin
          if (event.Command = cmEdytujSymbol) then
          begin
               SymbolDlg := MakeSymbolDlg;

               Linia := PString(Lista^.List^.At(Lista^.Focused))^;
               SymbolDlgRec.NazwaSymbolu := trim(Copy(Linia, 1, Pos('(', Linia)-1));

               Linia := Copy(Linia, Pos('(', Linia)+1, Length(Linia));
               SymbolDlgRec.AdresSymbolu := trim(Copy(Linia, 1, Pos(',', Linia)-1));

{               SymbolDlgRec.TypPamieci := Byte(tpBIT);}
               if Pos('ROM', Linia) <> 0 then SymbolDlgRec.TypPamieci := Byte(tpROM);
               if Pos('RAM', Linia) <> 0 then SymbolDlgRec.TypPamieci := Byte(tpRAM);
               Konwersja32Norm(SymbolDlgRec.AdresSymbolu, Wart);

               if (Pos('BIT', Linia) <> 0) or
                  ((TTypPamieci(SymbolDlgRec.TypPamieci) = tpRAM) and
                   (Byte(Wart) in WewnetrzneAdresyRejestrow))
               then MessageBox('Nie mo¾na edytowa† symboli wewn©trznych procesora.', nil, mfError + mfOKButton)
               else
               begin
                    if Application^.ExecuteDialog(SymbolDlg, @SymbolDlgRec) = cmOk then
                    begin
                         Linia := UpperCase(Trim(SymbolDlgRec.AdresSymbolu));
                         if (SymbolDlgRec.TypPamieci = Byte(tpRAM)) and (Byte(Wart) in WewnetrzneAdresyRejestrow) then
                         begin
                              MessageBox('Nie mo¾na zmienia† nazw wewn©trznych adres¢w procka.', nil, mfError + mfOKButton);
                              ClearEvent(Event);
                              Exit;
                         end;
                         if SymbolDlgRec.TypPamieci <> Byte(tpBIT) then
                         begin
                              if not Konwersja32Norm(Linia, Wart) then
                              begin
                                   MessageBox('Bˆ¥d w adresie', nil, mfError + mfOKButton);
                                   ClearEvent(Event);
                                   Exit;
                              end;
                         end else
                         begin
                         end;
                         if Trim(SymbolDlgRec.NazwaSymbolu) = '' then
                         begin
                              MessageBox('Niewˆa˜ciwa nazwa dla symbolu.', nil, mfError + mfOKButton);
                              ClearEvent(Event);
                              Exit;
                         end;
                         Linia := Trim(LowerCase(SymbolDlgRec.NazwaSymbolu))+' (';

                         case TTypPamieci(SymbolDlgRec.TypPamieci) of
                           tpRAM: Linia := Linia + '0'+Dec2hexB(Wart)+'h, RAM)';
                           tpROM: Linia := Linia + '0'+Dec2HexW(Wart)+'h, ROM)';
                           tpBIT: begin
                                       DajNazweBitu(Byte(Wart), Bit, False);
                                       Linia := Linia + Bit +', BIT)';
                                  end;
                         end;

                         l := Lista^.List^.At(Lista^.Focused);
                         DisposeStr(l);
                         l := NewStr(Linia);
                         Lista^.List^.AtPut(Lista^.Focused, l);
                    end;
               end;
          end;
          if event.command = cmDodajSymbol then
          begin
               Lista^.List^.Insert(NewStr('? (00000h, ROM)'));
               Event.Command := cmEdytujSymbol;
{               HandleEvent(Event);}
          end;
          if (event.command = cmUsunSymbol) then
          begin
               if MessageBox('Usun¥† symbol?', nil, mfConfirmation + mfYesButton + mfNoButton) = cmYes then
               begin
                    l := Lista^.List^.At(Lista^.Focused);
                    Lista^.List^.Delete(l);
                    DisposeStr(l);
               end;
          end;
          Lista^.SetRange(Lista^.List^.Count);
          Lista^.drawView;
          ClearEvent(Event);
     end;
end;

Procedure WczytajSymboleZDysku(plik:String);
var linia:string;
    p:text;
    typ:byte;
    adres:word;
    nazwa:string;
begin
{Niech format pliku symboli bedzie taki:
typ adres16 nazwa

typ     - (0 - rom, 1 - ram, 2 - bit)
adres16 - wartosc word (0-65535) adresu etykiety/wartosci
          dla pamieci ram brany jest tylko pod uwage mlodszy bajt
nazwa   - nazwa adresu/wartosci. Dlugosc = MaxNazwaSymbolu. Jezeli
          dlugosc jest wieksza, to tekst jest obcinany przez procke
          DodajSymbol()
np.
1 30 Sekundy
0 3 Int0
0 11 Int1

}
     if not fileexists(plik) then
     begin
          MessageBox(#3'Nie mog© otworzy† pliku '+Plik, nil, mfError + mfOkButton);
          Exit;
     end;

     if IleSymboli <> 0 then
     begin
          if MessageBox(#3'Aktualnie w programie jest '+Int2Str(IleSymboli)+' symbol(i).'#13+
                        #3'Czy usun¥† je przed wczytaniem nowych?', nil, mfConfirmation
                        + mfYesButton + mfNoButton) = cmYes then
          begin
               FillChar(Symbole^, SizeOf(TTablicaSymboli), #0);
               IleSymboli := 0;
          end;
     end;


     assign(p, plik);
     reset(p);
     while not eof(p) do
     begin
          ReadLn(p, typ,adres,nazwa);
          Nazwa := Trim(Nazwa);
          if TTypPamieci(typ) in [tpROM, tpBit]
             then DodajSymbol(Nazwa, Adres, TTypPamieci(Typ))
          else
          begin
               if Byte(Adres) in WewnetrzneAdresyRejestrow then
               begin
                    if Cfg.DodawajDoListySymboliAdresyWewnetrzne
                       then DodajSymbol(Nazwa, Adres, tpRAM)
               end else DodajSymbol(Nazwa, Adres, tpRAM)
          end;
     end;
     close(p);

end;

procedure ZapiszSymboleNaDysk(naz:string);
var p:text;
    i:word;
begin
     if FileExists(Naz) then
     begin
          if MessageBox('Plik o podanej nazwie ju¾ istnieje.'#13+
                        'Czy zast¥pi† go?', nil, mfConfirmation+mfYesButton+mfNoButton) = cmNo
          then Exit;

     end;
     assign(p, naz);
     rewrite(p);
     if IOResult <> 0 then
     begin
          MessageBox(#3'Bˆ¥d podczas tworzenia pliku '+naz+#13+
                     #3'Bˆ¥d DOS nr '+Int2Str(IOResult), nil, mfError+mfOKButton);
          Exit;
     end;
     for i := 1 to IleSymboli do
     begin
          writeln(p, Byte(Symbole^[i].TypPamieci),' ',Symbole^[i].Adres,' ',StrPas(@Symbole^[i].Nazwa));
     end;
     close(p);
end;






end.
