Function AlokujLinie(NumerPliku:Byte; Numerlinii:Word; Linia:String):PSourceLine;
var sz:Word;
    wyn:PSourceLine;
begin
     sz := SizeOf(TSourceLine) - SizeOf(String) + Length(Linia) + 1;
     GetMem(Wyn, sz);
     Wyn^.NumerPliku := NumerPliku;
     Wyn^.NumerLinii := NumerLinii;
     Move(Linia[0], Wyn^.Linia[0], Length(Linia)+1);
     AlokujLinie := Wyn;
end;

Procedure ZwolnijLinie(var Linia:PSourceLine);
var sz:Word;
begin
     sz := SizeOf(TSourceLine) - SizeOf(String) + 1;
     Inc(Sz, Length(Linia^.Linia));
     FreeMem(Linia, Sz);
end;

Function PolozNaStosInclude(var Element:TElementStosuInclude):Boolean;
begin
     PolozNaStosInclude := False;
     if StosInclude = nil then Exit;
     if StosInclude^.Wskaznik = MaxStosInclude then
     begin
          GenerujBlad(errZbytDuzoInclude);
          exit;
     end;
     Inc(StosInclude^.Wskaznik);
     StosInclude^.Stos[StosInclude^.Wskaznik] := Element;
     PolozNaStosInclude := True;
end;

Function ZdejmijZeStosuInclude(var Element:TElementStosuInclude):Boolean;
begin
     ZdejmijZeStosuInclude := False;
     if StosInclude = nil then Exit;
     if StosInclude^.Wskaznik = 0 then
     begin
          GenerujBlad(errZaMaloElementowNaStosie);
          exit;
     end;
     Element := StosInclude^.Stos[StosInclude^.Wskaznik];
     Dec(StosInclude^.Wskaznik);
     ZdejmijZeStosuInclude := True;
end;

procedure ZwolnijElementStosuInclude(var e:TElementStosuInclude);
begin
     Close(e.Uchwyt);
     if Assigned(e.nazwa) then DisposeStr(e.Nazwa);
end;

Function AlokujElementStosuInclude(var e:TElementStosuInclude; Nazwa:String):boolean;
begin
     AlokujElementStosuInclude := False;
     Nazwa := UpperCase(Trim(Nazwa));
     if not FileExists(Nazwa) then
     begin
          GenerujBlad(errBrakPodanegoPliku);
          Exit;
     end;
     e.Nazwa := NewStr(Nazwa);
     Assign(e.Uchwyt, Nazwa);
     Reset(e.Uchwyt);
     e.NumerLinii := 0;
     AlokujElementStosuInclude := True;
end;

Function AlokujMakro(NumerPliku:Byte; NumerLinii:Word; IloscLinii:Word; Nazwa:String; Wsk:PSourceLine):PMakro;
var sz:Word;
    wyn:PMakro;
    i:Word;
begin
     sz := SizeOf(TMakro) - SizeOf(String) + Length(Nazwa) + 1;
     GetMem(Wyn, sz);
     Wyn^.NumerPliku := NumerPliku;
     Wyn^.IloscLinii := IloscLinii;
     Wyn^.NumerLinii := NumerLinii;
     Wyn^.Wskaznik := wsk;
     Move(Nazwa[0], Wyn^.Nazwa[0], Length(Nazwa)+1);
     AlokujMakro := Wyn;
     for i := 1 to MaxParametrowMakra do Wyn^.Parametry[i] := '';
end;

Procedure ZwolnijMakro(var Makro:PMakro);
var sz:Word;
begin
     sz := SizeOf(TMakro) - SizeOf(String) + 1;
     Inc(Sz, Length(Makro^.Nazwa));
     FreeMem(Makro, Sz);
end;

