procedure TDebugger.ZapiszOkna(var St:TStream);
var Pal:PString;

procedure WriteView(P: PView); far;
begin
     if P <> Desktop^.Last then St.Put(P);
end;
begin
     Desktop^.Store(St);

     St.Put(nil);
     Pal := @Application^.GetPalette^;
     St.WriteStr(Pal);
end;


procedure TDebugger.ZapiszPulpit;
var S:PStream;
    F:File;
begin
     S := New(PBufStream, Init('EMUX051.DSK', stCreate, 1024));
     if not LowMemory and (S^.Status = stOk) then
     begin
          S^.Write(SygnaturaDSK[1], SygnaturaDSKSize);
          S^.Write(PamiecRAM, SizeOf(TPamiecRAM));
          S^.Write(PamiecROM^, SizeOf(TPamiecROM));
          S^.Write(Cfg, SizeOf(TKonfiguracja));
          ZapiszOkna(S^);
          StoreIndexes(S^);
          StoreHistory(S^);
          if S^.Status <> stOk then
          begin
               MessageBox('Bˆ¥d podczas tworzenia pliku pulpitu', nil, mfOkButton + mfError);
               Dispose(S, Done);
               Assign(F, 'EMUX051.DSK');
               Erase(F);
               Exit;
          end;
     end;
     Dispose(S, Done);
end;
