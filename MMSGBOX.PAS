Unit MMsgBox;
interface
Uses MsgBox, Objects, App;

const mfYesNoButton = mfYesButton+mfNoButton;

function MyMessageBox(l:Byte; const Msg: String; Params: Pointer;
  AOptions: Word): Word;

implementation

function MyMessageBox(l:Byte; const Msg: String; Params: Pointer;
  AOptions: Word): Word;
var
  R: TRect;
begin
  R.Assign(0, 0, 40, l);
  if AOptions and mfInsertInApp = 0 then
    R.Move((Desktop^.Size.X - R.B.X) div 2, (Desktop^.Size.Y - R.B.Y) div 2)
  else R.Move((Application^.Size.X - R.B.X) div 2, (Application^.Size.Y - R.B.Y) div 2);
  MyMessageBox := MessageBoxRect(R, Msg, Params, AOptions);
end;

end.