uses crt, dos, textoolz, procki, inst8051;
var we:text;
    wy:file;
    linia:string;
    Mnemonik:String;
    OpKod:Longint;
    Parametrow:Longint;
    Par1, Par2, Par3:TTypParametru;
    NrLinii:word;
    IleWczytano:Byte;
    tabl:array[1..200] of TWpisWTablicyInstrukcji;
    w:TWpisWTablicyInstrukcji;
    Dummy:String;

Procedure Blad;
begin
     WriteLn('Bˆad w linia ',NrLinii);
     close(we);
     Close(wy);
     Halt;
end;

Function DajParametr(naz:String):TTypParametru;
var Wyn:TTypParametru;
begin
     naz := UpperCase(Trim(naz));
     Byte(Wyn) := 255;
     if naz = 'TPNIEZNANY' then Wyn := tprNieznany;
     if naz = 'TPCODE11'   then Wyn := tprCode11;
     if naz = 'TPCODE16'   then Wyn := tprCode16;
     if naz = 'TPACC'      then Wyn := tprACC;
     if naz = 'TPRI'       then Wyn := tprRi;
     if naz = 'TPRN'       then Wyn := tprRn;
     if naz = 'TPRAMADDR'  then Wyn := tprRamAddr;
     if naz = 'TPBIT'      then Wyn := tprBit;
     if naz = 'TPCODE8'    then Wyn := tprCode8;
     if naz = 'TPDATA8'    then Wyn := tprData8;
     if naz = 'TPPTRADPTR' then Wyn := tprPtrADPTR;
     if naz = 'TPPTRAPC'   then Wyn := tprPtrAPC;
     if naz = 'TPDPTR'     then Wyn := tprDPTR;
     if naz = 'TPDATA16'   then Wyn := tprData16;
     if naz = 'TPC'        then Wyn := tprC;
     if naz = 'TPAB'       then Wyn := tprAB;
     if naz = 'TPNEGBIT'   then Wyn := tprNegBit;
     if naz = 'TPPTRDPTR'  then Wyn := tprPtrDPTR;
     if Byte(Wyn) = 255 then Blad;
     DajParametr := Wyn;
end;

begin
     assign(we, 'inst.dat');
     reset(we);
     NrLinii := 0;
     IleWczytano:=0;
     while not eof(we) do
     begin
          ReadLn(We, Linia);
          Inc(NrLinii);
          Linia := Linia+#9;
          Linia := Trim(UpperCase(Linia));
          while pos(#9, Linia) <> 0 do
          begin
               Delete(Linia, Pos(#9, Linia), 1);
          end;
          if (Linia = '') or (Linia[1] = ';') then Continue;
          FillChar(w, SizeOf(TWpisWTablicyInstrukcji), 0);
          Mnemonik := Trim(Token(',', Linia));
          Move(Mnemonik[1], w.Nazwa, Ord(Mnemonik[0]));
          if not Konwersja32Norm(Trim(Token(',', Linia)), OpKod) then Blad;
          if not Konwersja32Norm(Trim(Token(',', Linia)), Parametrow) then Blad;
          w.OpKod := Byte(OpKod);
          w.IloscPar := Byte(Parametrow);
          w.par[1] := DajParametr(Trim(Token(',', Linia)));
          w.par[2] := DajParametr(Trim(Token(',', Linia)));
          w.par[3] := DajParametr(Trim(Token(',', Linia)));
          Dummy := UpperCase(Trim(Token(',', Linia)));
          if Dummy = 'T' then w.MoznaZaufac := True;
          inc(IleWczytano);
          tabl[IleWczytano] := w;
     end;
     close(we);

     assign(wy, 'opcodes.dat');
     ReWrite(wy, 1);
     BlockWrite(Wy, IleWczytano, 1);
     BlockWrite(Wy, Tabl, IleWczytano*SizeOf(TWpisWTablicyInstrukcji));
     Close(wy);
end.
