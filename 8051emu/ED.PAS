unit ed;
interface
uses App, Views, Menus, Dialogs, ColorTxt, Zmienne, Drivers, Objects,
     Textoolz, Rej_Adr, Stale, Okienka, Procki, MsgBox;

procedure EdycjaBinarna(Adres:Word; var Wartosc:Byte; Gdzie:TTypPamieci);
procedure EdycjaZwykla(var Wartosc:Word; TypDanych:Byte);
          {TypDanych= 1-byte, 2-word}

implementation

Type PEdytorBitowy = ^TEdytorBitowy;
     TEdytorBitowy = object(TDialog)
       NazwaAdresu, AdresAdresu : PColoredText;
       NazwaBitu7, NazwaBitu6, NazwaBitu5, NazwaBitu4 : PStaticText;
       NazwaBitu2, NazwaBitu3, NazwaBitu0, NazwaBitu1 : PStaticText;
       WartoscHEX, WartoscASCII, WartoscDEC : PColoredText;
       PrzelacznikiBitow:array[0..7] of PCheckBoxes;
       Wartosc:Byte;
       constructor init(Adres:Word; Wart:Byte; Gdzie:TTypPamieci);
       procedure HandleEvent(var Event:TEvent); virtual;
       destructor Done; virtual;
     end;


procedure TEdytorBitowy.HandleEvent(var Event:TEvent);
var SprawdzBity:Boolean;
    bajt:byte;
begin
     if event.what = evMouseDown then SprawdzBity := True
                                 else SprawdzBity := false;
     inherited handleEvent(Event);
     if event.what = evKeyDown then
     begin
{          beep(1000);}
     end;
     if event.what = evbroadcast then SprawdzBity := True;
     if SprawdzBity then
     begin
          bajt := 0;
          if PrzelacznikiBitow[7]^.Value = 1 then Bajt := Bajt or $80;
          if PrzelacznikiBitow[6]^.Value = 1 then Bajt := Bajt or $40;
          if PrzelacznikiBitow[5]^.Value = 1 then Bajt := Bajt or $20;
          if PrzelacznikiBitow[4]^.Value = 1 then Bajt := Bajt or $10;
          if PrzelacznikiBitow[3]^.Value = 1 then Bajt := Bajt or $08;
          if PrzelacznikiBitow[2]^.Value = 1 then Bajt := Bajt or $04;
          if PrzelacznikiBitow[1]^.Value = 1 then Bajt := Bajt or $02;
          if PrzelacznikiBitow[0]^.Value = 1 then Bajt := Bajt or $01;
          WartoscASCII^.SetTitle(#3+chr(Bajt), True);
          WartoscDEC^.SetTitle(#3+Int2Str(bajt), True);
          WartoscHEX^.SetTitle(#3+Dec2HexB(bajt), True);
          DummyByte1 := Bajt;
     end;
end;

constructor TEdytorBitowy.init(Adres:Word; Wart:Byte; Gdzie:TTypPamieci);
var
  R : TRect;
  Control : PView;
  rej:TRejestr;
  nazwa:String;
begin
     R.Assign(14, 5, 65, 18);
     inherited Init(R, 'Edytuj warto˜†...');
     Options := Options or ofCenterX or ofCenterY;
     Palette := dpBlueDialog;

     if Gdzie = tpRAM then
        if DajOpisRejestru(Adres, rej)
           then Nazwa := Rej.Nazwa
           else Nazwa := 'Zwykˆa kom¢rka RAM';
{     else}
     if not Rej.OpisaneBity then
     begin
          Rej.Bit0.Nazwa := '0-lsb';
          Rej.Bit0.Uzywany := true;
          Rej.Bit1.Nazwa := '1';
          Rej.Bit1.Uzywany := true;
          Rej.Bit2.Nazwa := '2';
          Rej.Bit2.Uzywany := true;
          Rej.Bit3.Nazwa := '3';
          Rej.Bit3.Uzywany := true;
          Rej.Bit4.Nazwa := '4';
          Rej.Bit4.Uzywany := true;
          Rej.Bit5.Nazwa := '5';
          Rej.Bit5.Uzywany := true;
          Rej.Bit6.Nazwa := '6';
          Rej.Bit6.Uzywany := true;
          Rej.Bit7.Nazwa := '7-msb';
          Rej.Bit7.Uzywany := true;
     end;
{     begin
          Rej.Bit0.Nazwa := '0-lsb';
          Rej.Bit0.Uzywany := true;
          Rej.Bit1.Nazwa := '1';
          Rej.Bit1.Uzywany := true;
          Rej.Bit2.Nazwa := '2';
          Rej.Bit2.Uzywany := true;
          Rej.Bit3.Nazwa := '3';
          Rej.Bit3.Uzywany := true;
          Rej.Bit4.Nazwa := '4';
          Rej.Bit4.Uzywany := true;
          Rej.Bit5.Nazwa := '5';
          Rej.Bit5.Uzywany := true;
          Rej.Bit6.Nazwa := '6';
          Rej.Bit6.Uzywany := true;
          Rej.Bit7.Nazwa := '7-msb';
          Rej.Bit7.Uzywany := true;
     end;
}

     R.Assign(2, 6, 7, 7);
     Control := New(PCheckboxes, Init(R, NewSItem(' ', nil)));
     PrzelacznikiBitow[7] := PCheckBoxes(Control);
     Insert(Control);

     R.Assign(8, 6, 13, 7);
     Control := New(PCheckboxes, Init(R, NewSItem(' ', Nil)));
     PrzelacznikiBitow[6] := PCheckBoxes(Control);
     Insert(Control);

     R.Assign(14, 6, 19, 7);
     Control := New(PCheckboxes, Init(R, NewSItem(' ', Nil)));
     PrzelacznikiBitow[5] := PCheckBoxes(Control);
     Insert(Control);

     R.Assign(20, 6, 25, 7);
     Control := New(PCheckboxes, Init(R, NewSItem(' ', Nil)));
     PrzelacznikiBitow[4] := PCheckBoxes(Control);
     Insert(Control);

     R.Assign(26, 6, 31, 7);
     Control := New(PCheckboxes, Init(R, NewSItem(' ', Nil)));
     PrzelacznikiBitow[3] := PCheckBoxes(Control);
     Insert(Control);

     R.Assign(32, 6, 37, 7);
     Control := New(PCheckboxes, Init(R, NewSItem(' ', Nil)));
     PrzelacznikiBitow[2] := PCheckBoxes(Control);
     Insert(Control);

     R.Assign(38, 6, 43, 7);
     Control := New(PCheckboxes, Init(R, NewSItem(' ', Nil)));
     PrzelacznikiBitow[1] := PCheckBoxes(Control);
     Insert(Control);

     R.Assign(44, 6, 49, 7);
     Control := New(PCheckboxes, Init(R, NewSItem(' ', Nil)));
     PrzelacznikiBitow[0] := PCheckBoxes(Control);
     Insert(Control);

     R.Assign(2, 2, 10, 4);
     Control := New(PStaticText, Init(R, 'Rejestr:'^M'  Adres:'));
{     if Gdzie = tpROM then Control^.Hide;}
     Insert(Control);

     R.Assign(12, 2, 34, 3);
     if Gdzie = tpRam then NazwaAdresu := New(PColoredText, Init(R, Nazwa, $5F, 1000))
                      else NazwaAdresu := New(PColoredText, Init(R, 'Pami©† ROM', $5F, 1000));
     Insert(NazwaAdresu);

     R.Assign(12, 3, 34, 4);
     if Gdzie = tpRAM then AdresAdresu := New(PColoredText, Init(R, '0'+Dec2HexB(Adres)+'h', $5F, 2000))
                      else AdresAdresu := New(PColoredText, Init(R, '0'+Dec2HexW(Adres)+'h', $5F, 2000));
     Insert(AdresAdresu);

     R.Assign(11, 2, 12, 4);
     Control := New(PColoredText, Init(R, '', $5F, 3));
{     if Gdzie = tpROM then Control^.Hide;}
     Insert(Control);

     R.Assign(34, 2, 35, 4);
     Control := New(PColoredText, Init(R, '', $5F, 4));
{     if Gdzie = tpROM then Control^.Hide;}
     Insert(Control);

     R.Assign(2, 8, 15, 9);
     Control := New(PStaticText, Init(R, 'Szesnastkowo:'));
     Insert(Control);

     R.Assign(9, 9, 15, 10);
     Control := New(PStaticText, Init(R, 'ASCII:'));
     Insert(Control);

     R.Assign(3, 10, 15, 11);
     Control := New(PStaticText, Init(R, 'Dziesi©tnie:'));
     Insert(Control);

     R.Assign(2, 5, 7, 6);
     NazwaBitu7 := New(PStaticText, Init(R, ''+rej.Bit7.Nazwa));
     Insert(NazwaBitu7);

     R.Assign(8, 5, 13, 6);
     NazwaBitu6 := New(PStaticText, Init(R, ''+rej.Bit6.Nazwa));
     Insert(NazwaBitu6);

     R.Assign(14, 5, 19, 6);
     NazwaBitu5 := New(PStaticText, Init(R, ''+rej.Bit5.Nazwa));
     Insert(NazwaBitu5);

     R.Assign(20, 5, 25, 6);
     NazwaBitu4 := New(PStaticText, Init(R, ''+rej.Bit4.Nazwa));
     Insert(NazwaBitu4);

     R.Assign(26, 5, 31, 6);
     NazwaBitu2 := New(PStaticText, Init(R, ''+rej.Bit3.Nazwa));
     Insert(NazwaBitu2);

     R.Assign(32, 5, 37, 6);
     NazwaBitu3 := New(PStaticText, Init(R, ''+rej.Bit2.Nazwa));
     Insert(NazwaBitu3);

     R.Assign(38, 5, 43, 6);
     NazwaBitu0 := New(PStaticText, Init(R, ''+rej.Bit1.Nazwa));
     Insert(NazwaBitu0);

     R.Assign(44, 5, 49, 6);
     NazwaBitu1 := New(PStaticText, Init(R, ''+rej.Bit0.Nazwa));
     Insert(NazwaBitu1);

     R.Assign(16, 8, 21, 9);
     WartoscHEX := New(PColoredText, Init(R, '41', $4F, 5000));
     Insert(WartoscHEX);

     R.Assign(16, 9, 21, 10);
     WartoscASCII := New(PColoredText, Init(R, #3'A', $4F, 6000));
     Insert(WartoscASCII);

     R.Assign(16, 10, 21, 11);
     WartoscDEC := New(PColoredText, Init(R, '65', $4F, 7000));
     Insert(WartoscDEC);

     R.Assign(25, 9, 35, 11);
     Control := New(PButton, Init(R, 'O~K~', cmOK, bfDefault));
     Insert(Control);

     R.Assign(38, 9, 48, 11);
     Control := New(PButton, Init(R, '~A~nuluj', cmCancel, bfDefault));
     Insert(Control);

     SelectNext(False);
     Wartosc := Wart;
     if Wart and $80 <> 0 then PrzelacznikiBitow[7]^.Value := 1;
     if Wart and $40 <> 0 then PrzelacznikiBitow[6]^.Value := 1;
     if Wart and $20 <> 0 then PrzelacznikiBitow[5]^.Value := 1;
     if Wart and $10 <> 0 then PrzelacznikiBitow[4]^.Value := 1;
     if Wart and $08 <> 0 then PrzelacznikiBitow[3]^.Value := 1;
     if Wart and $04 <> 0 then PrzelacznikiBitow[2]^.Value := 1;
     if Wart and $02 <> 0 then PrzelacznikiBitow[1]^.Value := 1;
     if Wart and $01 <> 0 then PrzelacznikiBitow[0]^.Value := 1;
end;

destructor TEdytorBitowy.Done;
begin
     inherited Done;
end;

procedure EdycjaBinarna(Adres:Word; var Wartosc:Byte; Gdzie:TTypPamieci);
var p:PEdytorBitowy;
    dlg:word;
begin
     p := New(PEdytorBitowy, Init(Adres, Wartosc, Gdzie));
     dlg := Application^.ExecuteDialog(p, nil);
     if dlg = cmOK then
     begin
          Wartosc := DummyByte1;
          Message(Desktop, evBroadcast, cmZmianaZawartosciRAM, nil);
     end;
end;

procedure EdycjaZwykla(var Wartosc:Word; TypDanych:Byte);
          {TypDanych= 1-byte, 2-word}
var Zawartosc : record
      Wartosc:String[10];
    end;
    p:PDialog;
    Koniec:Boolean;
    z:string;
    i:byte;
    wart:longint;
    dlg:word;
begin
     if typdanych = 1 then Zawartosc.Wartosc := '0'+Dec2HexB(Wartosc)+'h'
                      else Zawartosc.Wartosc := '0'+Dec2HexW(Wartosc)+'h';
     koniec := False;
     while not koniec do
     begin
          p := MakeEdytujDlg;
          dlg := Application^.ExecuteDialog(p, @Zawartosc);
          if dlg = cmCancel then Exit;
          z := UpperCase(Trim(Zawartosc.Wartosc));
          if Konwersja32Norm(z, Wart) then
          begin
               Wartosc := Wart;
               if TypDanych = 1 then Wartosc := Wartosc and $00FF
                                else Wartosc := Wartosc and $FFFF;
               Koniec := True;
          end else messageBox('Niewˆa˜ciwy format liczby', nil, mfError+mfOkButton)
     end;
end;


end.
