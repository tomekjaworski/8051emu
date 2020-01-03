unit MyViews;
interface
Uses App, Drivers, Dialogs, Views, Objects, Crt;

type PMyListBox = ^TMyListBox;
     TMyListBox = object (TListBox)
       procedure HandleEvent(var Event:TEvent); virtual;
     end;

Type PWskaznikPamieci = ^TWskaznikPamieci;
     TWskaznikPamieci = object(TView)
        procedure Update; virtual;
     end;

type TMyListBoxRec = record
       Items:PCollection;
       Selection:Integer;
end;


const cmMyListBoxDoubleClicked = 200;
      cmMyListBoxEnterPressed  = 201;
      cmMyListBoxSpacePressed  = 202;

implementation

Procedure TMyListBox.HandleEvent(var Event:TEvent);
begin
     if (Event.What = evMouseDown) and (Event.Double)
        then Message(Owner, evBroadCast, cmMyListBoxDoubleClicked, @Self)
        else if (event.what = evkeydown) and (event.KeyCode = KbEnter)
             then Message(Owner, evBroadCast, cmMyListBoxEnterPressed, @Self)
             else if (event.what = evkeydown) and (event.CharCode = ' ')
                  then Message(Owner, evBroadCast, cmMyListBoxSpacePressed, @Self)
                  else inherited HandleEvent(event);
End;

procedure TWskaznikPamieci.Update;
var Ram:Longint;
    wart:string;
    b:TDrawBuffer;
begin
     Ram := MemAvail;
     FormatStr(Wart, '%d',Ram);
     MoveStr(b, wart, Black or (LightGray shl 4));
     WriteLine(0,0,ord(wart[0]),1,b);
end;

end.
