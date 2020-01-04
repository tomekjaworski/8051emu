function DajPlikPomocy: PathStr;
var EXEName: PathStr;
    Dir: DirStr;
    Name: NameStr;
    Ext: ExtStr;
begin
     if Lo(DosVersion) >= 3
        then EXEName := ParamStr(0)
        else EXEName := FSearch('DEBUG.EXE', GetEnv('PATH'));
     FSplit(EXEName, Dir, Name, Ext);
     if Dir[Length(Dir)] = '\'
        then Dec(Dir[0]);
     DajPlikPomocy := FSearch('8051HELP.HLP', Dir);
end;

function TDebugger.GetPalette: PPalette;
const CNewColor = CAppColor + CHelpColor;
      CNewBlackWhite = CAppBlackWhite + CHelpBlackWhite;
      CNewMonochrome = CAppMonochrome + CHelpMonochrome;
      P: array[apColor..apMonochrome] of string[Length(CNewColor)] =
           (CNewColor, CNewBlackWhite, CNewMonochrome);
begin
     GetPalette := @P[AppPalette];
end;

procedure TDebugger.GetEvent(var Event: TEvent);
begin
  inherited GetEvent(Event);
  case Event.What of
    evCommand:
      if (Event.Command = cmHelp) then ShowHelp(GetHelpCtx);
  end;
end;

procedure TDebugger.ShowHelp(aHelpCtx:word);
var
  W: PWindow;
  HFile: PHelpFile;
  HelpStrm: PDosStream;
begin
     if HelpInUseLocker = 0 then
     begin
          HelpStrm := New(PDosStream, Init(DajPlikPomocy, stOpenRead));
          HFile := New(PHelpFile, Init(HelpStrm));
          if HelpStrm^.Status <> stOk then
          begin
               MessageBox('Nie mog© otworzy† pliku pomocy.', nil, mfError + mfOkButton);
               Dispose(HFile, Done);
          end else
          begin
               W := New(PHelpWindow,Init(HFile, aHelpCtx));
               if ValidView(W) <> nil then
               begin
                    ExecView(W);
                    Dispose(W, Done);
{                    InsertWindow(W);}
               end;
          end;
     end else
     begin
          Message(Desktop, evBroadcast, cmSwitchToTopic, Pointer(aHelpCtx))
     end;
end;


