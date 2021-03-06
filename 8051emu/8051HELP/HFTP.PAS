{************************************************************}
{************************************************************}
{**                                                        **}
{**  Turbo Vision Demo                                     **}
{**  Portions Copyright (c) 1992 by Borland International  **}
{**  Portions Coypright (c) 1993 by KAP Holger Lembke      **}
{**                                                        **}
{************************************************************}
{************************************************************}

{
dt.
KAP - Erg�nzungen
14.01.94
  � Farbumsetztablle "CConverter" eingebaut
10.01.93
  � Einige Geschwindigkeitsoptimierungen
    Haupts�chlich wiederholtes Dereferenzieren beseitigt,
    ca. 8% schneller, Kleinvieh macht auch Mist.
06.01.93
  � Farbcodegeschichten gestrafft und vereinheitlicht
  � Farbcodes, die VOR dem sichtbaren Teil der Seite liegen, wurden
    nicht ber�cksichtigt
     zweite "for i:=1 to delta.y" Schleife
  � Fehler in Farbdarstellung bei direkt aufeinanderfolgenden Farbcodes
     Farbcodeumsetzer modifiziert
         k:=1;
         m:=0;
         cc:=0;
         while (k<=length(line)) do begin
**         while (line[k]='#') and (k<length(line)) do begin
war        if (line[k]='#') then begin
30.12.93
  � THelpWindow
     InitHelpViewer eingebaut, um auch Nachfahren von THelpViewer einfach
     einf�gen zu k�nnen.
     Dazu auch eine �nderung in der DONE-Methode von THelpViewer
22.12.93
  � Seltener Fehler beim Zur�cksteppen, wenn kein Link auf Seite
      procedure MakeSelectVisible;
      var D: TPoint;
      begin
**      if (selected=0) or (topic^.crossrefs=nil) then exit;

        if (locarray=nil) kap
          then Topic^.GetCrossRef(Selected, KeyPoint, KeyLength, KeyRef)
18.09.93
  � SELECTED im TStackRec (von Byte) auf Word ge�ndert
  � MAKEFOCUSVISIBLE Bereichs�berschreitung beim Suchen des Hotkeys
    (while (p<>nil) !!and (count<=topic^.numrefs)!! do begin
16.09.93
  � LASTPARAGRAPH:=NIL; in constructor THelpTopic.Load (Quelle: H.C.F.)
    (Komisch, da� das nicht schon fr�her gest�rt hat....)
19.08.93
  � Kontrolle der Streamregistrierung eingebaut. Wenn Hilfsstreams nicht
    registriert, dann reagieren wichtige Objekte im Constructor mit FAIL.
10.08.93
  � Kontrolle der �nderungen vom 8.-9.8.
  � Topic link-Jumping eingebaut (MakefocusVisible)
09.08.93
  � Markierung von Schaltfl�chen dramatisch beschleunigt (Handleevent)
    (alles im Zuge des Deppen-Aufr�umens)
08.08.93
  � DRAW-Methode bei vielen Links dramatisch beschleunigt
    (vorher muss ein Depp drangewesen sein...)
04.08.93
  � compressor/decompressor optimiert
01.08.93
  � compressor/decompressor
22.07.93
  � modales Fenster erg�nzt um "resizable dialog"
11.07.93
  � Fehler in der thelpviewer.draw methode, wenn farbumschaltung
    ausserhalb des sichtbereiches liegt. es wurde dann �bersehen.
    Folge: text war falsch befarbt...
03.07.93
  � Speichern der letzten Men�position umgestellt
02.06.93
  � Ver�ndertes Mono-Handling
19.05.93
  � Bugfix: Topic-Markierung und Farben in einer Zeile
    Bugfix: Farbmarkierungen und horizontales Scrollen
11.05.93
  � Bugfix: thelpviewer.draw und mehrzeiliger Umbruch farbiger texte
25.04.93
  � Optimisierung bei "countcs" in THelpTopic.WrapText
    (Die Darstellung bei vielen Topics ist immer noch recht tr�ge.)
21.04.93
  � Bugfix: Zeilenumbruch bei langen Paragraphen
20.04.93
  � nicht-modale Hilfe merkt sich die Gr��e
  � ge�nderte Farbe auch �ber Zeilenumbr�che hinweg
19.04.93
  � Umbau der THelpViewer.Draw-Methode
    (incl. �nderungen in THelpTopic.WrapText)
    - lock/unlock zur Darstellungsberuhigung
    - zeichenweises Ablegen wg. Farb�nderungen
      methode: #n als Code, es �ndert sich =nur= der Vordergrund
               ## f�r #
               #! f�r R�cksetzen auf Dialogfarbe
16.04.93
  � Alt-F1 focusiert letztes focusiertes topic
15.04.93
  � modales Fenster wird in anderem Farbset dargestellt als nicht-modales
  � Alt-F1 f�r Help-History
  � Shift-F1 f�r Hilfe �ber Hilfe
14.04.93
  � Unterscheidung zwischen modaler und nicht-modaler Hilfe


eng.
22.12.93
  � rare error with "last help", if last page has no link
      procedure MakeSelectVisible;
      var D: TPoint;
      begin
**      if (selected=0) or (topic^.crossrefs=nil) then exit;

        if (locarray=nil) kap
          then Topic^.GetCrossRef(Selected, KeyPoint, KeyLength, KeyRef)

18.09.93
  � SELECTED at TStackRec (from Byte) changed to Word
  � MAKEFOCUSVISIBLE range-error when searching the hotkey
    (while (p<>nil) !!and (count<=topic^.numrefs)!! do begin
16.09.93
  � LASTPARAGRAPH:=NIL; at constructor THelpTopic.Load (Quelle: H.C.F.)
    (funny, that this hadn't disturbed earlyer....)
19.08.93
  � check of stream-registration inserted. if stream is not registered,
    importend constructors will FAIL.
10.08.93
  � check of changes from 8.-9.8.
  � Topic link-Jumping einserted (MakefocusVisible)
09.08.93
  � dramaticly increase of link-selection (Handleevent)
    (again: tiding up after the fool)
08.08.93
  � DRAW-methode inceased when lot of links are shown
    (must been programed by a fool.....)
04.08.93
  � compressor/decompressor optimized
01.08.93
  � compressor/decompressor
22.07.93
  � added "resizable dialog" to modalar view
11.07.93
  � fixed error inside thelpviewer.draw methode, if colorchange is outside
    the visible range, it was missed then.
    result: text has wrong color...
03.07.93
  � change: storing the last menueposition
02.06.93
  � change: mono-handling
19.05.93
  � Bugfix: link-color and color of a line of text
    Bugfix: color and horizontal scrolling
11.05.93
  � Bugfix: thelpviewer.draw and wrap with more lines
25.04.93
  � optimization: at "countcs" in THelpTopic.WrapText
    (displaying lot of links is ugly slow.)
21.04.93
  � Bugfix: linewrap with long paragraphs
20.04.93
  � non-modal helpview will store its size
  � changed color with wrapped lines
19.04.93
  � redesign of THelpViewer.Draw-methode
    (incl. changes in THelpTopic.WrapText)
    - lock/unlock
    - changed to piut-by-char because coloring
      methode: #n for colorcode, only foreground!
               ## f�r #
               #! f�r reset to "standardcolor"
16.04.93
  � Alt-F1 for switching back to last topic
15.04.93
  � modale view gets a different color set than non-modal view
  � Alt-F1 for help-history
  � Shift-F1 for help about help
14.04.93
  � nodal view <-> non-modal view
}

{$A+,B-,D-,E-,F-,G-,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X+,Y-}

{$Q-,I-,O- }


unit HelpFile;

interface

uses Objects, Drivers, Views;

const
  CHelpColor      = {8} #$37#$3F#$3A#$13#$13#$30#$3E#$1E;
  CHelpBlackWhite = {8} #$07#$0F#$07#$70#$70#$07#$0F#$70;
  CHelpMonochrome = {8} #$07#$0F#$07#$70#$70#$07#$0F#$70;
  CHelpViewer     = {3} #6#7#8;
  Chelpwindow     = {8} #16#17#18#19#20#57#21#13;

  Cdialogwindow   = {8} #32#33#34#35#36#38#40#13; { die farbe der dialoge }

{KAP}
  {
  chelpwindow-felder
   1 ????
   2 rahmen
   3 rahmensymbole [�]
   4 scroller
   5 background, scrollersymbole
   6 textinhalt
   7 nicht focusierter topic
   8 linked topics/reaktionstopic f�r ENTER
  }

(*
  CHelpWindow     = #128#129#130#131#132#133#134#135;
*)

{KAP}
  maxhelpback           = 50;

  indexpagenumber       : word = 100;
  helpabouthelp         : word = 99;

  cmhelplast            = 65001;
  cmhelpindex           = 65002;

  lastpos               : trect = (a:(x:-1;y:0);b:(x:50;y:18));

  MagicHeader           = $46484246; {'FBHF'}

{ wenn auch tp60-hf ge�ffnet werden k�nnen sollen ... }
{ if it should be possible to old tp60-hf }
  openanyway            : boolean = false;

{ erlaubt den Hilfsfenster (trotz Dialog-Aussehen) die Gr��e zu �ndern }
{ a non-modal help will be resizable, if set to true }
  resizeabledialog      : boolean = false;

  ct_store              = $01;
  ct_nibble             = $02;
  ct_lastnibble         = $03;

  nc_rawchar            = $0f;
  nc_repchar            = $0e;

  comparraysize         = 13;

  createcompressedhelp  : boolean = false;

  helpversion           = $20;  { helpfile - version 2.0 }

Type string80 = string[80];

Const

  helpdialogtitle       : string80 = 'Help-Dialog';
  helpwindowtitle       : string80 = 'Help';
  nohelpInvalidStr      : string80 = #13' No help for this topic link.';
  emptyhelpInvalidStr   : string80 = #13' This helppage is empty.';

  CCConverter           : array[0..15] of byte
                        = (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15);


type
      pbytearray = ^tbytearray;
      tbytearray = array[0..63*1024] of byte;

      pchararray = ^tchararray;
      tchararray = array[0..63*1024] of char;

{ TParagraph }

  PPParagraph = ^pparagraph;
  PParagraph = ^TParagraph;
  TParagraph = record
    Next: PParagraph;
    Wrap: Boolean;
    Size: Word;
    Text: record end;
  end;

{ THelpTopic }

  TCrossRef = record
    Ref: Word;
    Offset: Integer;
    Length: Byte;
  end;

  tCompressinfo = record
    comptype  : byte;                 {                           }
    orgsize   : word;                 { orginalgroesse            }
                                      { original size             }
    chartable : array[0..comparraysize] of byte;
                                      { die comparraysize+1 h�ufigsten codes   }
                                      { the comparraysize+1 most used codes}
  end;


  plocarray  = ^tlocarray;
  tlocarray  = array[1..1000] of tpoint;

  PCrossRefs = ^TCrossRefs;
  TCrossRefs = array[1..10000] of TCrossRef;
  TCrossRefHandler = procedure (var S: TStream; XRefValue: Integer);

  PHelpTopic = ^THelpTopic;
  THelpTopic = object(TObject)
{ private}
    Paragraphs    : PParagraph;
    NumRefs       : Integer;
    CrossRefs     : PCrossRefs;
    Width         : Integer;
    LastOffset    : Integer;
    LastLine      : Integer;
    LastParagraph : PParagraph;
{ public }
    constructor   Init;
    constructor   Load(var S: TStream);
    destructor    Done; virtual;

    procedure     initstatistic    (var compheader : tcompressinfo;     p : pParagraph);
    function      Paragraphcompress(var compheader : tcompressinfo;     p : PPParagraph):word;
    procedure     Paragraphexpand  (var compheader : tcompressinfo; var p : ppparagraph);

    procedure     AddCrossRef(Ref: TCrossRef);
    procedure     AddParagraph(P: PParagraph);

    procedure     GetCrossRef(I: Integer; var Loc: TPoint; var Length: Byte; var Ref: Word);
    procedure     GetallCrossRef(locarray : plocarray; maxline : integer);

    function      GetLine(Line: Integer): String;
    function      GetNumCrossRefs: Integer;
    function      NumLines: Integer;
    procedure     SetCrossRef(I: Integer; var Ref: TCrossRef);
    procedure     SetNumCrossRefs(I: Integer);
    procedure     SetWidth(AWidth: Integer);
    procedure     Store(var S: TStream);
{ private }
    function WrapText(var Text; Size: Integer; var Offset: Integer;
      Wrap: Boolean): String;
  end;

{ THelpIndex }

  PIndexArray = ^TIndexArray;
  TIndexArray = array[0..16380] of LongInt;

  PContextArray = ^TContextArray;
  TContextArray = array[0..16380] of Word;

  PHelpIndex = ^THelpIndex;
  THelpIndex = object(TObject)
    Contexts  : PContextArray;
    Index     : PIndexArray;
{ private }
    Size      : Word;
    Used      : Word;
{ public }
    constructor Init;
    constructor Load(var S: TStream);
    destructor  Done; virtual;
    function    Position(I: Word): Longint;
    procedure   Add(I: Word; Val: Longint);
    procedure   Store(var S: TStream);
{ private }
    function    Find(I: Word):longint;
  end;

{ THelpFile }

  PHelpFile = ^THelpFile;
  THelpFile = object(TObject)
    Stream     : PStream;
    Modified   : Boolean;
{KAP}
    invaltopic : boolean;
{ private}
    Index      : PHelpIndex;
    IndexPos   : LongInt;
{ public }
    constructor Init(S: PStream);
    destructor  Done; virtual;
    function    GetTopic(I: Word): PHelpTopic;
    function    InvalidTopic: PHelpTopic;
    function    emptyTopic: PHelpTopic;
    procedure   RecordPositionInIndex(I: word);
    procedure   PutTopic(Topic: PHelpTopic);
  end;

{KAP}
  TStackrec = record
    helpctx  : word;
    selected : word;
  end;

  pstackarray = ^tstackarray;
  tstackarray = array[1..maxhelpback] of TStackrec;

{ THelpViewer }
  PHelpViewer = ^THelpViewer;
  THelpViewer = object(TScroller)
    HFile         : PHelpFile;
    Topic         : PHelpTopic;
    stack         : pstackarray;
    Selected      : Integer;

    oldsize       : byte;
    locarray      : plocarray;
    locarraysize  : word;
    keyfocus      : pstring;
    constructor Init(var Bounds       : TRect;
                         AHScrollBar,
                         AVScrollBar  : PScrollBar;
                         AHelpFile    : PHelpFile;
                         Context      : Word);
    destructor Done; virtual;
    procedure  ChangeBounds(var Bounds: TRect); virtual;
    procedure  Draw; virtual;
    function   GetPalette: PPalette; virtual;
    procedure  HandleEvent(var Event: TEvent); virtual;
    procedure  SwitchToTopic(KeyRef: word);

    procedure  invalidatelocarray;

    procedure  Popstack(var keyword : word);
    procedure  Pushstack(keyword : word);
    procedure  SwitchTooldTopic(Var keyref : word);
  end;

{ THelpWindow }
  PHelpWindow = ^THelpWindow;
  THelpWindow = object(TWindow)
    phv      : phelpviewer;
    ismodal  : boolean;
    constructor Init(HFile: PHelpFile; Context: Word; aismodal : boolean);
    function    GetPalette: PPalette; virtual;
    procedure   InitHelpviewer(HFile: PHelpFile; Context: Word);
    destructor  done; virtual;
  end;

Var
  originalsize, compresssize  : longint;


const
  RHelpTopic: TStreamRec = (
     ObjType: 10000;
     VmtLink: Ofs(TypeOf(THelpTopic)^);
     Load:    @THelpTopic.Load;
     Store:   @THelpTopic.Store
  );

const
  RHelpIndex: TStreamRec = (
     ObjType: 10001;
     VmtLink: Ofs(TypeOf(THelpIndex)^);
     Load:    @THelpIndex.Load;
     Store:   @THelpIndex.Store
  );

procedure RegisterHelpFile;

procedure NotAssigned(var S: TStream; Value: Integer);

const     CrossRefHandler: TCrossRefHandler = NotAssigned;

implementation

{............................................................}

end.
