Procedure TDebugger.UsunWszystkiePulapki;
begin
     if MessageBox('Usun¥† wszystkie pulapki?', nil, mfConfirmation+mfYesNoButton) = cmNo
        then exit;
    FillChar(Pulapki, MaxPulapek*2, $FF);
    IlePulapek := 0;
    Message(Desktop, evBroadcast, cmZmianaZawartosciROM, nil);
end;

procedure TDebugger.DodajUsunPulapke;
var Adres:Word;
    i:word;
begin
     if not CzyOtwarteOknoCPU then exit;
     Adres := OknoCPU^.PoleSledzeniaKodu^.AdresyOknaKodu[OknoCPU^.PoleSledzeniaKodu^.NumerLinii+1];
     for i := 1 to IlePulapek do
     begin
          if Pulapki[i] = Adres then
          begin
               Move(Pulapki[i+1], Pulapki[i], (IlePulapek-1)*2);
               Dec(IlePulapek);
               exit;
          end;
     end;
     Inc(IlePulapek);
     Pulapki[IlePulapek] := Adres;
     Message(Desktop, evBroadcast, cmZmianaZawartosciROM, nil);
end;
