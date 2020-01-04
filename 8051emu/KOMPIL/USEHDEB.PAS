{$B-,I-,N-,O-,P-,Q-,R-,S-,T-,V-,W-,X+}
Unit USEHDEB;

interface

implementation

{$IFOPT D+}

{$DEFINE USE_SHAREWARE}              {<<  see README.TXT   }
{not $DEFINE GERMAN_LANG}            {<<  for the          }
{$DEFINE GETDEBUGINFO}               {<<  dokumentation    }
{not $DEFINE REPORT_TO_FILE}         {<<  of these         }
{not $DEFINE SWITCH_TO_LASTMODE}     {<<  switches !       }

{$IFDEF DPMI}    {$DEFINE WIN_OR_DPMI} {$ENDIF}
{$IFDEF WINDOWS} {$DEFINE WIN_OR_DPMI} {$ENDIF}

uses
{$IFDEF WINDOWS}
     WinCrt,
{$ELSE}
     crt, drivers,
{$ENDIF}
{$IFDEF WIN_OR_DPMI}
     WinProcs, Strings,
{$ENDIF}
{$IFDEF USE_SHAREWARE}
     HDeb7S;
{$ELSE}
     HDeb7F;
{$ENDIF}

const
  DumpFileName = 'HEAPDEB.DMP'; {only used if REPORT_TO_FILE-Switch defined}

var
  OldExitProc: pointer;

procedure DumpReport;
type
  PtrRec = record
     Ofs, Seg: Word;
  end;
var
  A:  array[0..9] of longint;
{$IFDEF WINDOWS}
  S:  array[0..80] of char;
const
  S4: array[1..5] of char = '    '#0; {indx from 1 for comatibility with pas-str}
var
  S5: array[0..5] of char;
  SFile: array[0..12] of char;
  SLine: array[0..5] of char;
{$ELSE}
  S:  string;
const
  S4: string[4] = '    ';
var
  S5: string[5];
  SFile: string[12];
  SLine: string[5];
{$ENDIF}
  C: Char ;
  AEntry: PHeapDebEntry;
  L: LongInt;
  i: Integer;

const
{$IFNDEF GERMAN_LANG}
    MessageHello      = 'HEAP DEBUGGER DIAGNOSIS:';
    MessageList       = 'list (Y/N) ? ';
    MessageContList   = 'press any key to continue list or ESC to abort';
    MessageLimitEx    = 'Shareware-limit exceeded!'#13#10'Only 50 pointers were registered!';
    MessageHeadLine   =
    '   No    Pointer   Size  Flags            Caller          File   Line';
{$ELSE}
    MessageHello      = 'HEAP DEBUGGER DIAGNOSE:';
    MessageList       = 'auflisten (J/N) ? ';
    MessageContList   = 'zum Fortsetzen eine Taste druecken oder ESC zum Abbrechen';
    MessageLimitEx    = 'Shareware-Limit ueberschritten!'#13#10'Es wurden nur 50 pointer verarbeitet!';
    MessageHeadLine   =
    '   Nr    Pointer   Size  Flags          Aufrufer         Datei  Zeile';
{$ENDIF}

{$IFDEF WINDOWS}
    MessagePtrNo      = '%lu';
    MessageReport     =
    '%5s  %04lx:%04lx  %5lu  %s    %04lx[%04lx]:%04lx  %12s  %5s';
{$ELSE}
    MessagePtrNo      = '%d';
    MessageReport     =
    '%5s  %04x:%04x  %5d  %s    %04x[%04x]:%04x  %12s  %5s';
{$ENDIF}

{$IFDEF WINDOWS}
  {$IFNDEF GERMAN_LANG}
    MessageHalt       = 'program stopped by HALT(%lu)';
    MessageRTE        = 'runtime-error %03lu at %04lx:%04lx, file: %s line: %s ';
    MessageInternalEr = 'internal error %lu occured in Heap Debugger';
    MessagePtrReg     = '%lu pointers were registered';
    MessageDebEntries = '%lu debug-entries available';
{$ELSE}
    MessageHalt       = 'Programm durch HALT(%lu) gestoppt';
    MessageRTE        = 'Laufzeitfehler %03lu bei %04lx:%04lx, Datei: %s Zeile: %s ';
    MessageInternalEr = 'interner Fehler %lu im Heap Debugger aufgetreten';
    MessagePtrReg     = '%lu Pointer wurden registiert';
    MessageDebEntries = '%lu Debug-Eintraege vorhanden';
  {$ENDIF}

  procedure FormatStr(DestStr, FormatStr: PChar; var ArgList);
  begin
    wvsprintf(DestStr, FormatStr, ArgList);
  end;
{$ELSE}
  {$IFNDEF GERMAN_LANG}
    MessageHalt       = 'program halted by HALT(%d)';
    MessageRTE        = 'runtime-error %03d at %04x:%04x, file: %s line: %s ';
    MessageInternalEr = 'internal error %d occured in Heap Debugger';
    MessagePtrReg     = '%d pointers were registered';
    MessageDebEntries = '%d debug-entries available';
  {$ELSE}
    MessageHalt       = 'Programm durch HALT(%d) gestoppt';
    MessageRTE        = 'Laufzeitfehler %03d bei %04x:%04x, Datei: %s Zeile: %s ';
    MessageInternalEr = 'interner Fehler %d im Heap Debugger aufgetreten';
    MessagePtrReg     = '%d Pointer wurden registiert';
    MessageDebEntries = '%d Debug-Eintraege vorhanden';
  {$ENDIF}
{$ENDIF}

{$IFDEF WINDOWS}
  procedure GetSourcePos(Address: pointer; Filename0T, LineNr0T: PChar);
  var
    FileName: String[12];
    LineNr: String[5];
{$ELSE}
  procedure GetSourcePos(Address: pointer; var Filename, LineNr: string);
{$ENDIF}
      function ModuleFileName: String;
{$IFDEF MSDOS}
      begin
        ModuleFileName := ParamStr(0);
      end;
{$ELSE}
      var
        Buff: Array[0..127] of char;
      begin
        GetModuleFileName(System.HInstance, Buff, Sizeof(Buff)-1);
        ModuleFileName := StrPas(Buff);
      end;
{$ENDIF}
  var w: word;
  begin
{$IFNDEF GERMAN_LANG}
    FileName := 'unavailable';
{$ELSE}
    FileName := 'keine Info.';
{$ENDIF}
    LineNr   := '' ;
{$IFDEF GETDEBUGINFO}
    if GetDebugInfoRes = drNotInit then
      InitDebugInfo(ModuleFileName);
    if (GetDebugInfoRes <> drInvalidEXE)   and
       (GetDebugInfoRes <> drInfoNotFound) then
    begin
      FileName := '           ?';
      LineNr   := '    ?' ;

{$IFDEF USE_SHAREWARE}
      HDeb7S.GetSourcePos(Address, Filename, w);
{$ELSE}
      HDeb7F.GetSourcePos(Address, Filename, w);
{$ENDIF}
      if GetDebugInfoRes = drOK then Str(w, LineNr);
    end;
{$ENDIF}
{$IFDEF WINDOWS}
    StrPCopy(FileName0T, FileName);
    StrPCopy(LineNr0T, LineNr);
{$ENDIF}
  end;

var
  DumpFile: Text {$IFNDEF REPORT_TO_FILE} absolute System.Output {$ENDIF};

begin
  SuspendHeapdeb := true;

{$IFNDEF REPORT_TO_FILE}
 {$IFNDEF WINDOWS}
  DirectVideo := false; {so output is visible in graphicmode also}
  {$IFDEF SWITCH_TO_LASTMODE}
  Textmode(LastMode);
  {$ENDIF}
 {$ENDIF}
{$ELSE}
  Assign(DumpFile, DumpFileName);
  Append(DumpFile);
  if IOResult <> 0 then Rewrite(DumpFile);
{$ENDIF}

  writeln(DumpFile, MessageHello);

  if ExitCode <> 0 then
  begin
    A[0] := ExitCode;
    if ErrorAddr = nil then
      FormatStr(S, MessageHalt, A)
    else
    begin
      A[1] := PtrRec(ErrorAddr).Seg;
      A[2] := PtrRec(ErrorAddr).Ofs;
      GetSourcePos(ErrorAddr, SFile, SLine);
      A[3] := Longint(@SFile);
      A[4] := Longint(@SLine);
      FormatStr(S, MessageRTE, A);
      ErrorAddr := nil;
    end;
    writeln(DumpFile, S);
  end
  else
  begin
    if HeapDebInternalError = -1 then
      writeln(DumpFile, MessageLimitEx)
    else
      if HeapDebInternalError > 0 then
      begin
        A[0] := HeapDebInternalError;
        FormatStr(S, MessageInternalEr, A);
        writeln(DumpFile, S);
      end;

    FormatStr(S, MessagePtrReg, HeapDebTotalPtrCount);
    writeln (DumpFile, S);
    FormatStr(S, MessageDebEntries, HeapDebEntriesAvail);
    Writeln (DumpFile, S);

    if HeapDebEntriesAvail > 0 then
    begin
{$IFNDEF REPORT_TO_FILE}
      Write (DumpFile, MessageList);
      C := ReadKey;
      writeln (DumpFile, C);
      if Upcase (C) = 'N' then Exit;
{$ENDIF}
      AEntry := nil;
      i := 0;
      while HeapDebReport(AEntry) <> nil do
      begin
{$IFNDEF REPORT_TO_FILE}
        if i = 20 then
        begin
          i := 0;
          writeln(DumpFile, MessageContList);
          if readkey = #27 then Exit;
        end;
{$ENDIF}
        if i = 0 then
        begin
          writeln(DumpFile, '');
          writeln(DumpFile, MessageHeadLine);
        end;
        inc(i);
        with AEntry^ do
        begin
          if No = 0 then
            FillChar(S5, SizeOf(S5), #0)
          else
          begin
            A[0] := No;
            FormatStr(S5, MessagePtrNo, A);
          end;
          A[0] := longint(@S5);
          A[1] := PtrRec(Ptr).Seg;
          A[2] := PtrRec(Ptr).Ofs;
          A[3] := Size;
          S4[1] := ' '; S4[2] := ' '; S4[3] := ' '; S4[4] := ' ';
          if Flags and hdflagIsObject        > 0 then S4[1] := 'O';
          if Flags and hdflagFreeCall        > 0 then S4[2] := 'F';
          if Flags and hdflagWrongSizeOnFree > 0 then S4[3] := 'S';
          if Flags and hdflagNoMatchingGet   > 0 then S4[4] := 'M';
          A[4] := longint(@S4);
          A[5] := PtrRec(Caller).Seg;
          A[6] := AktSeg;
          A[7] := PtrRec(Caller).Ofs;
          GetSourcePos(Caller, SFile, SLine);
          A[8] := Longint(@SFile);
          A[9] := Longint(@SLine);
          FormatStr(S, MessageReport, A);
          writeln(DumpFile, S);
{$IFNDEF REPORT_TO_FILE}
          if Keypressed and (Readkey = #27) then Exit;
{$ENDIF}
        end;
      end;
    end;
  end;
{$IFNDEF REPORT_TO_FILE}
 {$IFNDEF WINDOWS}
  ReadKey;
 {$ENDIF}
{$ELSE}
  Close(DumpFile);
{$ENDIF}
end;

procedure LocalExitProc; far;
var
  SaveInOutRes: Integer;
begin
  ExitProc := OldExitProc;
  SaveInOutRes := InOutRes;
  InOutRes := 0; {force ok}
  DumpReport;
  HeapDebDone;
  InOutRes := SaveInOutRes; {a later ExitProc might like to know this}
end;

begin
{$IFDEF WINDOWS}
  if HPrevInst = 0 then
{$ENDIF}
    if HeapDebInit([]) then
    begin
      OldExitProc := ExitProc;
      ExitProc := @LocalExitProc;
    end
    else
    begin
{$IFNDEF REPORT_TO_FILE}
 {$IFNDEF WINDOWS}
      DirectVideo := false; {so output is visible in graphicmode also}
 {$ENDIF}
 {$IFNDEF GERMAN_LANG}
      writeln('Unable to initialize Heap Debugger !');
 {$ELSE}
      writeln('Heap Debugger konnte nicht initialisiert werden !');
 {$ENDIF}
{$ENDIF}
      Halt;
    end;
{$ENDIF (d+)}
end.
