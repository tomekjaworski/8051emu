Unit IntelHEX;
interface
Uses Konfig, Textoolz, Procki, MsgBox, App, Drivers, Dialogs, Views,
     MMsgBox;

procedure ZapiszBuforJakoHEX(Bufor:Pointer; Wielkosc:Word; Plik:String; PytajGdyIstnieje:Boolean);
procedure ZapiszBuforJakoBIN(Bufor:Pointer; Wielkosc:Word; Plik:String; PytajGdyIstnieje:Boolean);
procedure WczytajBuforJakoHEX(Bufor:Pointer; Wielkosc:Word; Plik:String);
procedure WczytajBuforJakoBIN(Bufor:Pointer; Wielkosc:Word; Plik:String);

implementation

procedure ZapiszBuforJakoHEX(Bufor:Pointer; Wielkosc:Word; Plik:String; PytajGdyIstnieje:Boolean);
var f:text;
    linia:string;
    Adres:Word;
    i:word;
    SumaCRC, DlLinii:Byte;
begin
     if Plik = '' then exit;
     if PytajGdyIstnieje and FileExists(Plik) then
     begin
          if MessageBox(#3'Plik '+DajNazweZNazwy(Plik)+' ju¾ istnieje. Czy napewno zapisa†?', nil,
                        mfConfirmation + mfyesButton + mfNoButton) = cmNo
             then exit;
     end;
     Assign(F, Plik);
     ReWrite(F);
     if IOResult <> 0 then Exit;
     Adres := 0;
     repeat
           SumaCRC := 0;
           if Wielkosc > $10 then DlLinii := $10
                             else DlLinii := Wielkosc;
           Linia := ':'+Dec2HexB(DlLinii);
           Linia := Linia+Dec2HexW(Adres)+'00';
           SumaCRC := DlLinii+Hi(Adres)+Lo(Adres);
           for i := 1 to DlLinii do
           begin
                Linia := Linia + Dec2HexB(Byte(Pointer(Longint(Bufor)+Adres)^));
                Byte(SumaCRC) := Byte(SumaCRC) + Byte(Pointer(Longint(Bufor)+Adres)^);
                Inc(Adres);
                Dec(Wielkosc);
           end;
           Linia := Linia + Dec2HexB(Byte(Byte(0)-SumaCRC));
           WriteLn(F, Linia);
     until Wielkosc <= 0;
     WriteLn(F, ':00000001FF');
     Close(F);
end;

procedure ZapiszBuforJakoBIN(Bufor:Pointer; Wielkosc:Word; Plik:String; PytajGdyIstnieje:Boolean);
var f:file;
begin
     if Plik = '' then exit;
     if PytajGdyIstnieje and FileExists(Plik) then
     begin
          if MessageBox(#3'Plik '+DajNazweZNazwy(Plik)+' ju¾ istnieje. Czy napewno zapisa†?', nil,
                        mfConfirmation + mfyesButton + mfNoButton) = cmNo
             then exit;
     end;
     assign(f, Plik);
     rewrite(f,1);
     blockwrite(f, Bufor^, Wielkosc);
     close(f);
end;

procedure WczytajBuforJakoBIN(Bufor:Pointer; Wielkosc:Word; Plik:String);
var f:File;
begin
     if Plik = '' then exit;
     if not FileExists(Plik) then
     begin
          MessageBox(#3'Nie mog© otworzy† podanego pliku.', nil,
                     mfConfirmation + mfyesButton + mfNoButton);
          exit;
     end;

     if Not Assigned(Bufor) then GetMem(Bufor, Wielkosc);
     FillChar(Bufor^, Wielkosc, #0);

     Assign(F, Plik);
     Reset(F, 1);
     if FileSize(F) < Wielkosc then Wielkosc := FileSize(F);
     if FileSize(F) > Wielkosc then
     begin
          if MyMessageBox(11, #3'Wczytywany plik ma wielko˜† '+Int2Str(FileSize(F))+
                          ', podczas gdy bufor docelowy ma wielko˜† '+Int2Str(Wielkosc)+
                          #13#3'Wczytywany plik zostanie obci©ty. Czy kontynuowa†?', nil,
                          mfConfirmation+mfYesButton+mfNoButton) = cmNo
             then exit;
     end;
     BlockRead(F, Bufor^, Wielkosc);
     Close(F);
end;

procedure WczytajBuforJakoHEX(Bufor:Pointer; Wielkosc:Word; Plik:String);
var f:text;
    Tryb:byte;
    Linia:String;
    n:byte;
    AdresWBuforze:word;
    bajt:byte;
    AdresBajtuWHex:Byte;
    DlugoscLiniiHex:Byte;
begin
     if Plik = '' then exit;
     if not FileExists(Plik) then
     begin
          MessageBox(#3'Nie mog© otworzy† podanego pliku.', nil,
                     mfConfirmation + mfyesButton + mfNoButton);
          exit;
     end;

     if Not Assigned(Bufor) then GetMem(Bufor, Wielkosc);
     FillChar(Bufor^, Wielkosc, #0);

     Assign(F, Plik);
     Reset(F);
     Tryb := 0;

     repeat
           Readln(f, linia);
           if linia[1] = ':' then
           begin
                DlugoscLiniiHex := Hex2DecW('00'+Copy(linia, 2, 2));
                AdresWBuforze := Hex2DecW(Copy(linia, 4, 4));
                Tryb := Hex2DecW('00'+Copy(linia, 8, 2));
                if Tryb = 0 then
                begin
                     AdresBajtuWHex := 10;
                     for n := 1 to DlugoscLiniiHex do
                     begin
                          bajt := Hex2DecW('00'+Copy(linia, AdresBajtuWHex ,2));
                          if AdresWBuforze = Wielkosc then
                          begin
                               MyMessageBox(11, 'Wielkosc odczytywanego pliku przekroczyˆa dopuszczaln¥ wielko˜† bufora.'#13+
                                            'Operacja zostaˆa przerwana z powodu niebezpieczeästwa utraty innych danych.',
                                            nil, mfError+mfOkButton);
                               Exit;
                          end;
                          Byte(Pointer(Longint(Bufor)+AdresWBuforze)^) := bajt;
                          Inc(AdresBajtuWHex, 2);
                          Inc(AdresWBuforze);
                     end; {for}
                end; {if}
           end; {if linia[1]....}
     until (Tryb = 1) or Eof(F);
     Close(F);
end;



end.
