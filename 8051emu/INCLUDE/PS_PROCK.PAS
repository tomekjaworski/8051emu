procedure TPoleSledzeniaKodu.Draw;
var i:byte;
    j:word;
    DlugoscInstrukcji:Byte;
    AdresInstrukcji:Word;
    JuzWyswietlona:Boolean;
begin
{     inherited Draw;}
     NumerLinii := Min(NumerLinii, Size.Y-1);
     AdresInstrukcji := AdresOkienka;
     JuzWyswietlona := False;
     for i := 0 to Size.Y-1 do
     begin
          AdresyOknaKodu[i+1] := AdresInstrukcji;
          if NumerLinii = i then DlugoscInstrukcji := WyswietlInstrukcje(0,i,AdresInstrukcji,True, (Blue shl 4) or White)
          else
          begin
               for j := 1 to IlePulapek do
               begin
                    if AdresInstrukcji = Pulapki[j] then
                    begin
                         DlugoscInstrukcji := WyswietlInstrukcje(0, i, AdresInstrukcji, True, (Red shl 4) or Yellow);
                         JuzWyswietlona:=True;
                    end;
               end;
               if not JuzWyswietlona
                  then DlugoscInstrukcji := WyswietlInstrukcje(0, i, AdresInstrukcji, False, 0)
                  else JuzWyswietlona := False;
          end;
          Inc(AdresInstrukcji, DlugoscInstrukcji);
     end;
end;

constructor TPoleSledzeniaKodu.Init(var Bounds:TRect);
begin
     inherited Init(Bounds);
     AdresOkienka := $0000;
     NumerLinii := 0;
     GrowMode := gfGrowHiY;
{     Options := Options or ofTileable;}
end;

procedure TPoleSledzeniaKodu.UstawAdresOkienka(Adr:Word);
var i:Byte;
begin
     for i := 1 to Size.Y do
     begin
          if AdresyOknaKodu[i] = Adr then
          begin
               NumerLinii := i-1;
               exit;
          end;
     end;
     AdresOkienka := Adr;
     NumerLinii := 0;
     Draw;
end;

procedure TPoleSledzeniaKodu.HandleEvent(var Event:TEvent);
var Mysza:TPoint;
begin
     inherited HandleEvent(event);
     if event.what = evMouseDown then
     begin
          if MouseInView(Event.Where) then
          begin
               MakeLocal(Event.Where, Mysza);
               NumerLinii := Mysza.Y;
               Draw;
               ClearEvent(Event);
          end;
     end;
end;


procedure TPoleSledzeniaKodu.Up;
begin
     if NumerLinii > 0 then Dec(NumerLinii)
     else
     begin
          if LongInt(AdresOkienka)-LongInt(DajDlugoscInstrukcji(AdresyOknaKodu[20])) >= 0
             then Dec(AdresOkienka, DajDlugoscInstrukcji(AdresyOknaKodu[20]))
             else AdresOkienka := 0;
     end;
     Draw;
end;

procedure TPoleSledzeniaKodu.Down;
var Dummy:Longint;
    Suma:Longint;
    i:byte;
begin
     if NumerLinii < Size.Y-1 then
     begin
          Dummy := DajDlugoscInstrukcji(AdresyOknaKOdu[NumerLinii+1]);
          Dummy := Dummy + AdresyOknaKodu[NumerLinii+1];
          if Dummy <= $FFFE then
          begin
               Inc(NumerLinii)
          end
     end else
     begin
          Suma := 0;
          for i := 1 to 20 do Inc(Suma, DajDlugoscInstrukcji(AdresyOknaKodu[i]));
          if AdresOkienka < $FFF0-Suma
            then Inc(AdresOkienka, DajDlugoscInstrukcji(AdresyOknaKodu[1]));
     end;
     Draw;
end;

Procedure TPoleSledzeniaKodu.PageUp;
begin
     NumerLinii := 0;
     if Longint(AdresOkienka) - 20 > 0
        then Dec(AdresOkienka,20)
        else AdresOkienka := 0;
     Draw;
end;

Procedure TPoleSledzeniaKodu.PageDown;
var Suma:Longint;
    i:byte;
begin
     NumerLinii := 0;
     Suma := 0;
     for i := 1 to 21 do Inc(Suma, DajDlugoscInstrukcji(AdresyOknaKodu[i]));
     if AdresOkienka + Suma <= $FFd0
        then Inc(AdresOkienka, Suma)
        else AdresOkienka := $FFFE-Suma;
     Draw;
end;

Procedure TPoleSledzeniaKodu.Top;
begin
     NumerLinii := 0;
     AdresOkienka := 0;
     Draw;
end;

function TPoleSledzeniaKodu.WyswietlInstrukcje(x,y:byte;AdresDASM:word;Podswietlony:Boolean;KolorPodsw:Byte):Byte;
var Instr:TInstrukcja;
    BuforInstr:TBuforInstr;
    Etykieta:String;
    wyn:string;
    mnemonik,kodyhex:string;
    Poz:Byte;
    Linia:TDrawBuffer;
    i:word;
begin
     if AdresDASM = $FFFF then AdresDASM := 0;
     Pozycja := AdresDASM;

     Instr := Instrukcje[PamiecROM^[AdresDASM]];
     for i := 0 to Instr.Bajtow-1 do
         BuforInstr[i+1] := PamiecROM^[AdresDASM+i];
{     Move(PamiecROM^[AdresDASM], BuforInstr, Instr.Bajtow);}
     Instr.Dasm(PamiecROM^[AdresDASM],Instr.Bajtow,BuforInstr,Wyn);

     MoveStr(Linia, Dec2HexW(AdresDASM)+': ', LightGreen or (Cyan shl 4));
     WriteLine(x, y, 6, 1, Linia);

     if AdresDASM = pc then
     begin
          MoveChar(Linia, #16, Red or (Cyan shl 4), 1);
          WriteLine(x+5, y, 1, 1, Linia);
     end;

     If not podswietlony then
     begin
          poz := Pos(OdstepInstrArg, Wyn);
          if poz <> 0 then
          begin
               mnemonik := Copy(wyn, 1, poz-1);
               wyn := Copy(wyn, poz+1, Length(Wyn));
               While ord(mnemonik[0]) < MaxNazwaInstrukcji do mnemonik := mnemonik+' ';
               wyn := mnemonik+wyn;
          end;
          KodyHex := '';
          for poz := 1 to Instr.Bajtow
              do KodyHex := KodyHex + Dec2HexB(PamiecROM^[adresDASM+poz-1])+' ';
          While ord(KodyHEX[0]) < 13 do KodyHEX := KodyHEX+' ';
          While ord(Wyn[0]) < 33 do Wyn := Wyn+' ';

          MoveStr(Linia, KodyHEX, Blue or (Cyan shl 4));
          WriteLine(x+6, y, ord(KodyHEX[0]), 1, Linia);
          Etykieta := ZnajdzSymbolROMAJakNieToNic(AdresDASM);
          if Ord(Etykieta[0]) <> 0 then
          begin
               Etykieta := Etykieta + ':';
               While ord(Etykieta[0]) < 11 do Etykieta := Etykieta+' ';

               MoveStr(Linia, Etykieta, Yellow or (Cyan shl 4));
               WriteLine(x+6+3+3+3, y, ord(Etykieta[0]), 1, Linia);
          end else
          begin
               MoveStr(Linia, '           ', Yellow or (Cyan shl 4));
               WriteLine(x+6+3+3+3, y, 11, 1, Linia);
          end;
          MoveStr(Linia, Wyn, Black or (Cyan shl 4));
          WriteLine(x+6+3+3+3+4+7, y, Ord(Wyn[0]), 1, Linia);
{          PrintText(x+6+3+3+3+4+7,y,clDbgKod,wyn);}
     end else
     begin {podswietlony}
          poz := Pos(OdstepInstrArg, Wyn);
          if poz <> 0 then
          begin
               mnemonik := Copy(wyn, 1, poz-1);
               wyn := Copy(wyn, poz+1, Length(Wyn));
               While ord(mnemonik[0]) < MaxNazwaInstrukcji do mnemonik := mnemonik+' ';
               wyn := mnemonik+wyn;
          end;
          KodyHex := '';
          for poz := 1 to Instr.Bajtow
              do KodyHex := KodyHex + Dec2HexB(PamiecROM^[adresDASM+poz-1])+' ';
          Etykieta := ZnajdzSymbolROMAJakNieToNic(AdresDASM);
          if Ord(Etykieta[0]) <> 0 then
          begin
               While ord(KodyHEX[0]) < 9 do KodyHEX := KodyHEX+' ';
               Etykieta := Etykieta+':';
               While ord(Etykieta[0]) < 11 do Etykieta := Etykieta+' ';
               Wyn := KodyHEX+Etykieta+Wyn;
          end else
          begin
               While ord(KodyHEX[0]) < 20 do KodyHEX := KodyHEX+' ';
               Wyn := KodyHEX+Wyn;
          end;
          While ord(Wyn[0]) < 53 do Wyn := Wyn+' ';

          MoveStr(Linia, Wyn, KolorPodsw);
          WriteLine(x+6, y, Ord(Wyn[0]), 1, Linia);
     end;
     WyswietlInstrukcje := Instr.Bajtow;
end;

