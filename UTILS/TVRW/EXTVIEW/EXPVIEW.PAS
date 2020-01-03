{**************************************************************************}
{*  BitSoft Development, L.L.C.                                           *}
{*  Turbo Vision Resource WorkShop exportable controls unit               *}
{*                                                                        *}
{*  Turbo Vision Resource Workshop                                        *}
{*  Copyright (C) 1995-1996 Balazs Scheidler                              *}
{*  Portions Copyright (C) 1995, 1996 BitSoft Developmet, L.L.C.          *}
{*  All rights reserved.                                                  *}
{**************************************************************************}

unit ExpView;
{$S-}

{$IFNDEF DPMI}
   'This unit requires to be compiled for the DPMI plataform...'
{$ENDIF}

interface

uses
  Objects, DrvUtils, WinAPI, ExpValid;

{ Constants of the Views unit }

{ TView State masks }

const
  sfVisible     = $0001;
  sfCursorVis   = $0002;
  sfCursorIns   = $0004;
  sfShadow      = $0008;
  sfActive      = $0010;
  sfSelected    = $0020;
  sfFocused     = $0040;
  sfDragging    = $0080;
  sfDisabled    = $0100;
  sfModal       = $0200;
  sfDefault     = $0400;
  sfExposed     = $0800;

{ TView Option masks }

  ofSelectable  = $0001;
  ofTopSelect   = $0002;
  ofFirstClick  = $0004;
  ofFramed      = $0008;
  ofPreProcess  = $0010;
  ofPostProcess = $0020;
  ofBuffered    = $0040;
  ofTileable    = $0080;
  ofCenterX     = $0100;
  ofCenterY     = $0200;
  ofCentered    = $0300;
  ofValidate    = $0400;
  ofVersion     = $3000;
  ofVersion10   = $0000;
  ofVersion20   = $1000;

{ TView GrowMode masks }

  gfGrowLoX = $01;
  gfGrowLoY = $02;
  gfGrowHiX = $04;
  gfGrowHiY = $08;
  gfGrowAll = $0F;
  gfGrowRel = $10;

{ TView DragMode masks }

  dmDragMove = $01;
  dmDragGrow = $02;
  dmLimitLoX = $10;
  dmLimitLoY = $20;
  dmLimitHiX = $40;
  dmLimitHiY = $80;
  dmLimitAll = $F0;

{ Standard command codes }

  cmValid   = 0;
  cmQuit    = 1;
  cmError   = 2;
  cmMenu    = 3;
  cmClose   = 4;
  cmZoom    = 5;
  cmResize  = 6;
  cmNext    = 7;
  cmPrev    = 8;
  cmHelp    = 9;

{ Application command codes }

  cmCut     = 20;
  cmCopy    = 21;
  cmPaste   = 22;
  cmUndo    = 23;
  cmClear   = 24;
  cmTile    = 25;
  cmCascade = 26;

{ TDialog standard commands }

  cmOK      = 10;
  cmCancel  = 11;
  cmYes     = 12;
  cmNo      = 13;
  cmDefault = 14;

{ Standard messages }

  cmReceivedFocus     = 50;
  cmReleasedFocus     = 51;
  cmCommandSetChanged = 52;

{ TScrollBar messages }

  cmScrollBarChanged  = 53;
  cmScrollBarClicked  = 54;

{ TWindow select messages }

  cmSelectWindowNum   = 55;

{ TListViewer messages }

  cmListItemSelected  = 56;

  MaxViewWidth = 132;

  { Commands used by TVRW to communicate with the view }
  cmIsLinkableTo	= 2064;
  cmGetLinkName		= 2065;
  cmSetLinkedView	= 2066;

  ofViewExtensions	= $8000;

  lnPascal	= 0;
  lnCPlusPlus	= 1;

type
  PView = ^TView;
  TDrawBuffer = array [0..MaxViewWidth-1] of Word;

  { Structure used to represent a TView on the other side }
  PExtView = ^TExtView;
  TExtView = record
    VMTLink: Word;
    Owner: Pointer;
    Next: PExtView;
    Origin: TPoint;
    Size: TPoint;
    Cursor: TPoint;
    GrowMode: Byte;
    DragMode: Byte;
    HelpCtx: Word;
    State: Word;
    Options: Word;
    EventMask: Word;
    OtherSelf: PView;           { This pointer is present only in the Remote View }
  end;

  PPalette = PString;

  { This structure is used when TVRW finds Controls using CtrlFindFirst, CtrlFindNext }
  PControlData = ^TControlData;
  TControlData = record
    Size: Word; { To provide backward compatibility }
    Id: String[30];
    TypeId: String[30];
    Description: String[50];
    ObjType: Word;
    PrefixStr: String[30];
  end;

  TDoMessageBoxProc = function (const S: String; Params: Pointer; Flags: Word): Word;
  TDoMessageBoxRectProc = function (var Bounds: TRect; const S: String; Params: Pointer; Flags: Word): Word;

  { Derive your control from this object type }
  TView = object(TObject)
    Origin: TPoint;
    Size: TPoint;
    RemoteSelf: PExtView;
    constructor Init(ARemoteSelf: PExtView; var Bounds: TRect);
    constructor Load(ARemoteSelf: PExtView; var S: TStream);
    destructor Done; virtual;
    procedure BlockCursor;
    procedure ChangeBounds(var Bounds: TRect); virtual;
    procedure ClearEvent(var Event: TEvent);
    function CommandEnabled(Command: Word): Boolean;
    function DataSize: Word; virtual;
    procedure Draw; virtual;
    procedure DrawView;
    function EventAvail: Boolean;
    procedure GetBounds(var Bounds: TRect);
    function GetColor(Color: Word): Word;
    procedure GetData(var Rec); virtual;
    procedure GetEvent(var Event: TEvent); virtual;
    procedure GetExtent(var Extent: TRect);
    function GetPalette: PPalette; virtual;
    procedure GetPeerViewPtr(var S: TStream; var P);
    function GetState(AState: Word): Boolean;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure Hide;
    procedure HideCursor;
    procedure KeyEvent(var Event: TEvent);
    procedure MakeGlobal(Source: TPoint; var Dest: TPoint);
    procedure MakeLocal(Source: TPoint; var Dest: TPoint);
    function Message(Receiver: Pointer; What, Command: Word; InfoPtr: Pointer): Pointer;
    function MouseEvent(var Event: TEvent; Mask: Word): Boolean;
    function MouseInView(Mouse: TPoint): Boolean;
    procedure NormalCursor;
    procedure PutEvent(var Event: TEvent); virtual;
    procedure PutPeerViewPtr(var S: TStream; P: PExtView);
    procedure SetCursor(X, Y: Integer);
    procedure SetData(var Rec); virtual;
    procedure SetState(AState: Word; Enable: Boolean); virtual;
    procedure Show;
    procedure ShowCursor;
    procedure SizeLimits(var Min, Max: TPoint); virtual;
    procedure Store(var S: TStream);
    function Valid(Command: Word): Boolean; virtual;
    procedure WriteBuf(X, Y, W, H: Integer; var Buf);
    procedure WriteChar(X, Y: Integer; C: Char; Color: Byte;
      Count: Integer);
    procedure WriteLine(X, Y, W, H: Integer; var Buf);
    procedure WriteStr(X, Y: Integer; Str: String; Color: Byte);
    procedure LoadValidator(var S: TStream);
    procedure StoreValidator(var S: TStream);
  end;

{ Procedures TVRW calls, when a VIRTUAL function/procedure must be performed.
  Since virtual procedures do not need their own STUB function these can be
  Global. }
procedure ViewDraw(Self: PView); export;
function ViewGetPalette(Self: PView): PPalette; export;
procedure ViewHandleEvent(Self: PView; var Event: TEvent); export;
procedure ViewSizeLimits(Self: PView; var Min, Max: TPoint); export;
function ViewValid(Self: PView; Command: Word): Boolean; export;
procedure ViewChangeBounds(Self: PView; var Bounds: TRect); export;
procedure ViewSetData(Self: PView; var Rec); export;
procedure ViewGetData(Self: PView; var Rec); export;
function ViewDataSize(Self: PView): Word; export;

procedure LinkProcedures(ATVRWInstance: THandle);

var
  DoMessageBox: TDoMessageBoxProc;
  DoMessageBoxRect: TDoMessageBoxRectProc;

implementation

uses
  TinyStrm;

type
  TViewGetPeerViewPtrProc = procedure (Self: PExtView; Ndx: Word; var P);
  TViewPutPeerViewPtrProc = function (Self: PExtView; P: PExtView): Word;
  TViewSetStateProc = procedure (Self: PExtView; AState: Word; AEnable: Boolean);
  TViewPutEventProc = procedure (Self: PExtView; var Event: TEvent);
  TViewGetEventProc = procedure (Self: PExtView; var Event: TEvent);
  TViewMakeGlobalProc = procedure (Self: PExtView; Source: TPoint; var Dest: TPoint);
  TViewMakeLocalProc = procedure (Self: PExtView; Source: TPoint; var Dest: TPoint);
  TViewWriteBufProc = procedure (Self: PExtView; X, Y, W, H: Integer; var Buf);
  TViewWriteLineProc = procedure (Self: PExtView; X, Y, W, H: Integer; var Buf);
  TViewWriteCharProc = procedure (Self: PExtView; X, Y: Integer; Ch: Char; Color: Byte; Count: Integer);
  TViewWriteStrProc = procedure (Self: PExtView; X, Y: Integer; Str: String; Color: Byte);
  TViewGetColorProc = function (Self: PExtView; Color: Word): Word;
  TViewMessageProc = function (Self: PExtView; Receiver: Pointer; What, Command: Word; InfoPtr: Pointer): Pointer;
  TViewLoadValidatorProc = procedure (Self: PExtView; MemBlk: Pointer; MaxSize: Word);
  TViewStoreValidatorProc = procedure (Self: PExtView; MemBlk: Pointer; var MaxSize: Word);
  TViewSetCursorProc = procedure (Self: PExtView; X, Y: Integer);

var
  TVRWInstance: THandle;
  ViewGetPeerViewPtr: TViewGetPeerViewPtrProc;
  ViewPutPeerViewPtr: TViewPutPeerViewPtrProc;
  ViewSetState: TViewSetStateProc;
  ViewPutEvent: TViewPutEventProc;
  ViewGetEvent: TViewGetEventProc;
  ViewMakeGlobal: TViewMakeGlobalProc;
  ViewMakeLocal: TViewMakeLocalProc;
  ViewWriteBuf: TViewWriteBufProc;
  ViewWriteLine: TViewWriteLineProc;
  ViewWriteChar: TViewWriteCharProc;
  ViewWriteStr: TViewWriteStrProc;
  ViewGetColor: TViewGetColorProc;
  ViewMessage: TViewMessageProc;
  ViewSetCursor: TViewSetCursorProc;
  ViewLoadValidator: TViewLoadValidatorProc;
  ViewStoreValidator: TViewStoreValidatorProc;

{****************************************************************************}
{ LinkProcedures                                                             }
{****************************************************************************}
procedure LinkProcedures(ATVRWInstance: THandle);
begin
  TVRWInstance := ATVRWInstance;
  Pointer(@ViewGetPeerViewPtr) := GetProcAddress(TVRWInstance, 'VIEWGETPEERVIEWPTR');
  Pointer(@ViewPutPeerViewPtr) := GetProcAddress(TVRWInstance, 'VIEWPUTPEERVIEWPTR');
  Pointer(@ViewSetState) := GetProcAddress(TVRWInstance, 'VIEWSETSTATE');
  Pointer(@ViewPutEvent) := GetProcAddress(TVRWInstance, 'VIEWPUTEVENT');
  Pointer(@ViewGetEvent) := GetProcAddress(TVRWInstance, 'VIEWGETEVENT');
  Pointer(@ViewMakeGlobal) := GetProcAddress(TVRWInstance, 'VIEWMAKEGLOBAL');
  Pointer(@ViewMakeLocal) := GetProcAddress(TVRWInstance, 'VIEWMAKELOCAL');
  Pointer(@ViewWriteBuf) := GetProcAddress(TVRWInstance, 'VIEWWRITEBUF');
  Pointer(@ViewWriteLine) := GetProcAddress(TVRWInstance, 'VIEWWRITELINE');
  Pointer(@ViewWriteChar) := GetProcAddress(TVRWInstance, 'VIEWWRITECHAR');
  Pointer(@ViewWriteStr) := GetProcAddress(TVRWInstance, 'VIEWWRITESTR');
  Pointer(@ViewGetColor) := GetProcAddress(TVRWInstance, 'VIEWGETCOLOR');
  Pointer(@ViewMessage) := GetProcAddress(TVRWInstance, 'VIEWMESSAGE');
  Pointer(@ViewSetCursor) := GetProcAddress(TVRWInstance, 'VIEWSETCURSOR');
  Pointer(@DoMessageBox) := GetProcAddress(TVRWInstance, 'DOMESSAGEBOX');
  Pointer(@DoMessageBoxRect) := GetProcAddress(TVRWInstance, 'DOMESSAGEBOXRECT');
  Pointer(@ViewLoadValidator) := GetProcAddress(TVRWInstance, 'VIEWLOADVALIDATOR');
  Pointer(@ViewStoreValidator) := GetProcAddress(TVRWInstance, 'VIEWSTOREVALIDATOR');
end;

{ TExPExtView }

{****************************************************************************}
{ TView object                                                               }
{****************************************************************************}
{****************************************************************************}
{ TView.Init                                                                 }
{****************************************************************************}
constructor TView.Init(ARemoteSelf: PExtView; var Bounds: TRect);
begin
  inherited Init;
  RemoteSelf := ARemoteSelf;
  ChangeBounds(Bounds);
end;

{****************************************************************************}
{ TView.Load                                                                 }
{****************************************************************************}
constructor TView.Load(ARemoteSelf: PExtView; var S: TStream);
begin
  inherited Init;
  RemoteSelf := ARemoteSelf;
  Size := RemoteSelf^.Size;
  Origin := RemoteSelf^.Origin;
end;

{****************************************************************************}
{ TView.Done                                                                 }
{****************************************************************************}
destructor TView.Done;
begin
end;

{****************************************************************************}
{ TView.BlockCursor                                                          }
{****************************************************************************}
procedure TView.BlockCursor;
begin
  SetState(sfCursorIns, True);
end;

{****************************************************************************}
{ TView.ChangeBounds                                                         }
{****************************************************************************}
procedure TView.ChangeBounds(var Bounds: TRect);
begin
  Origin := Bounds.A;
  Size.X := Bounds.B.X - Bounds.A.X;
  Size.Y := Bounds.B.Y - Bounds.A.Y;
end;

{****************************************************************************}
{ TView.ClearEvent                                                           }
{****************************************************************************}
procedure TView.ClearEvent(var Event: TEvent);
begin
  Event.What := evNothing;
  Event.InfoPtr := @Self;
end;

{****************************************************************************}
{ TView.CommandEnabled                                                       }
{****************************************************************************}
function TView.CommandEnabled(Command: Word): Boolean;
begin
  CommandEnabled := True;
end;

{****************************************************************************}
{ TView.DataSize                                                             }
{****************************************************************************}
function TView.DataSize: Word;
begin
  DataSize := 0;
end;

{****************************************************************************}
{ TView.Draw                                                                 }
{****************************************************************************}
procedure TView.Draw;
var
  B: TDrawBuffer;
begin
  MoveChar(B, ' ', GetColor(1), Size.X);
  WriteLine(0, 0, Size.X, Size.Y, B);
end;

{****************************************************************************}
{ TView.DrawView                                                             }
{****************************************************************************}
procedure TView.DrawView;
begin
  Draw;
end;

{****************************************************************************}
{ TView.EventAvail                                                           }
{****************************************************************************}
function TView.EventAvail: Boolean;
var
  Event: TEvent;
begin
  GetEvent(Event);
  if Event.What <> evNothing then PutEvent(Event);
  EventAvail := Event.What <> evNothing;
end;

{****************************************************************************}
{ TView.GetBounds                                                            }
{****************************************************************************}
procedure TView.GetBounds(var Bounds: TRect);
begin
  Bounds.A := Origin;
  Bounds.B.X := Bounds.A.X + Size.X;
  Bounds.B.Y := Bounds.A.Y + Size.Y;
end;

{****************************************************************************}
{ TView.GetColor                                                             }
{****************************************************************************}
function TView.GetColor(Color: Word): Word;
begin
  GetColor := ViewGetColor(RemoteSelf, Color);
end;

{****************************************************************************}
{ TView.GetData                                                              }
{****************************************************************************}
procedure TView.GetData(var Rec);
begin
end;

{****************************************************************************}
{ TView.GetEvent                                                             }
{****************************************************************************}
procedure TView.GetEvent(var Event: TEvent);
begin
  ViewGetEvent(RemoteSelf, Event);
end;

{****************************************************************************}
{ TView.GetExtent                                                            }
{****************************************************************************}
procedure TView.GetExtent(var Extent: TRect);
begin
  Extent.A.X := 0;
  Extent.A.Y := 0;
  Extent.B := Size;
end;

{****************************************************************************}
{ TView.GetPalette                                                           }
{****************************************************************************}
function TView.GetPalette: PPalette;
begin
  GetPalette := nil;
end;

{****************************************************************************}
{ TView.GetPeerViewPtr                                                       }
{****************************************************************************}
procedure TView.GetPeerViewPtr(var S: TStream; var P);
var
  Ndx: Word;
begin
  S.Read(Ndx, 2);
  ViewGetPeerViewPtr(RemoteSelf, Ndx, P);
end;

{****************************************************************************}
{ TView.GetState                                                             }
{****************************************************************************}
function TView.GetState(AState: Word): Boolean;
begin
  GetState := RemoteSelf^.State and AState <> 0;
end;

{****************************************************************************}
{ TView.HandleEvent                                                          }
{****************************************************************************}
procedure TView.HandleEvent(var Event: TEvent);
begin
end;

{****************************************************************************}
{ TView.Hide                                                                 }
{****************************************************************************}
procedure TView.Hide;
begin
  SetState(sfVisible, False);
end;

{****************************************************************************}
{ TView.HideCursor                                                           }
{****************************************************************************}
procedure TView.HideCursor;
begin
  SetState(sfCursorVis, False);
end;

{****************************************************************************}
{ TView.KeyEvent                                                             }
{****************************************************************************}
procedure TView.KeyEvent(var Event: TEvent);
begin
  repeat
    GetEvent(Event);
  until Event.What = evKeyDown;
end;

{****************************************************************************}
{ TView.MakeGlobal                                                           }
{****************************************************************************}
procedure TView.MakeGlobal(Source: TPoint; var Dest: TPoint);
begin
  ViewMakeGlobal(RemoteSelf, Source, Dest);
end;

{****************************************************************************}
{ TView.MakeLocal                                                            }
{****************************************************************************}
procedure TView.MakeLocal(Source: TPoint; var Dest: TPoint);
begin
  ViewMakeLocal(RemoteSelf, Source, Dest);
end;

{****************************************************************************}
{ TView.Message                                                              }
{****************************************************************************}
function TView.Message(Receiver: Pointer; What, Command: Word;
  InfoPtr: Pointer): Pointer;
begin
  Message := ViewMessage(RemoteSelf, Receiver, What, Command, InfoPtr);
end;

{****************************************************************************}
{ TView.MouseEvent                                                           }
{****************************************************************************}
function TView.MouseEvent(var Event: TEvent; Mask: Word): Boolean;
begin
  repeat
    GetEvent(Event);
  until Event.What and (Mask or evMouseUp) <> 0;
  MouseEvent := Event.What <> evMouseUp;
end;

{****************************************************************************}
{ TView.MouseInView                                                          }
{****************************************************************************}
function TView.MouseInView(Mouse: TPoint): Boolean;
var
  Extent: TRect;
begin
  MakeLocal(Mouse, Mouse);
  GetExtent(Extent);
  MouseInView := Extent.Contains(Mouse);
end;

{****************************************************************************}
{ TView.NormalCursor                                                         }
{****************************************************************************}
procedure TView.NormalCursor;
begin
  SetState(sfCursorIns, False);
end;

{****************************************************************************}
{ TView.PutEvent                                                             }
{****************************************************************************}
procedure TView.PutEvent(var Event: TEvent);
begin
  ViewPutEvent(RemoteSelf, Event);
end;

{****************************************************************************}
{ TView.PutPeerViewPtr                                                       }
{****************************************************************************}
procedure TView.PutPeerViewPtr(var S: TStream; P: PExtView);
var
  Ndx: Word;
begin
  Ndx := ViewPutPeerViewPtr(RemoteSelf, P);
  S.Write(Ndx, 2);
end;

{****************************************************************************}
{ TView.SetCursor                                                            }
{****************************************************************************}
procedure TView.SetCursor(X, Y: Integer);
begin
  ViewSetCursor(RemoteSelf, X, Y);
end;

{****************************************************************************}
{ TView.SetData                                                              }
{****************************************************************************}
procedure TView.SetData(var Rec);
begin
end;

{****************************************************************************}
{ TView.SetState                                                             }
{****************************************************************************}
procedure TView.SetState(AState: Word; Enable: Boolean);
begin
  ViewSetState(RemoteSelf, AState, Enable);
end;

{****************************************************************************}
{ TView.Show                                                                 }
{****************************************************************************}
procedure TView.Show;
begin
  SetState(sfVisible, True);
end;

{****************************************************************************}
{ TView.ShowCursor                                                           }
{****************************************************************************}
procedure TView.ShowCursor;
begin
  SetState(sfCursorVis, True);
end;

{****************************************************************************}
{ TView.SizeLimits                                                           }
{****************************************************************************}
procedure TView.SizeLimits(var Min, Max: TPoint);
begin
  Longint(Min) := $00010001;
  Longint(Max) := $7FFF7FFF;
end;

{****************************************************************************}
{ TView.Store                                                                }
{****************************************************************************}
procedure TView.Store(var S: TStream);
begin
end;

{****************************************************************************}
{ TView.Valid                                                                }
{****************************************************************************}
function TView.Valid(Command: Word): Boolean;
begin
  Valid := True;
end;

{****************************************************************************}
{ TView.WriteBuf                                                             }
{****************************************************************************}
procedure TView.WriteBuf(X, Y, W, H: Integer; var Buf);
begin
  ViewWriteBuf(RemoteSelf, X, Y, W, H, Buf);
end;

{****************************************************************************}
{ TView.WriteChar                                                            }
{****************************************************************************}
procedure TView.WriteChar(X, Y: Integer; C: Char; Color: Byte;
  Count: Integer);
begin
  ViewWriteChar(RemoteSelf, X, Y, C, Color, Count);
end;

{****************************************************************************}
{ TView.WriteLine                                                            }
{****************************************************************************}
procedure TView.WriteLine(X, Y, W, H: Integer; var Buf);
begin
  ViewWriteLine(RemoteSelf, X, Y, W, H, Buf);
end;

{****************************************************************************}
{ TView.WriteStr                                                             }
{****************************************************************************}
procedure TView.WriteStr(X, Y: Integer; Str: String; Color: Byte);
begin
  ViewWriteStr(RemoteSelf, X, Y, Str, Color);
end;

{****************************************************************************}
{ TView.LoadValidator                                                        }
{****************************************************************************}
procedure TView.LoadValidator(var S: TStream);
var
  MaxLen: Word;
  MemBlk: Pointer;
begin
  if Assigned(ViewLoadValidator) then begin
    S.Read(MaxLen, 2);
    GetMem(MemBlk, MaxLen);
    S.Read(MemBlk^, MaxLen);
    ViewLoadValidator(RemoteSelf, MemBlk, MaxLen);
    FreeMem(MemBlk, MaxLen);
  end;
end;

{****************************************************************************}
{ TView.StoreValidator                                                       }
{****************************************************************************}
procedure TView.StoreValidator(var S: TStream);
var
  MaxLen: Word;
  MemBlk: Pointer;
begin
  if Assigned(ViewStoreValidator) then begin
    MaxLen := 16384;
    GetMem(MemBlk, MaxLen);
    ViewStoreValidator(RemoteSelf, MemBlk, MaxLen);
    if RemoteSelf^.Options and ofViewExtensions <> 0 then
      S.Write(MaxLen, 2);
    S.Write(MemBlk^, MaxLen);
    FreeMem(MemBlk, MaxLen);
  end;
end;

{****************************************************************************}
{**                     EXPORTED FUNCTIONS AND PROCEDURES                  **}
{****************************************************************************}
{****************************************************************************}
{ ViewDraw                                                                   }
{****************************************************************************}
procedure ViewDraw(Self: PView);
begin
  Self^.Draw;
end;

{****************************************************************************}
{ ViewGetPalette                                                             }
{****************************************************************************}
function ViewGetPalette(Self: PView): PPalette;
begin
  ViewGetPalette := Self^.GetPalette;
end;

{****************************************************************************}
{ ViewHandleEvent                                                            }
{****************************************************************************}
procedure ViewHandleEvent(Self: PView; var Event: TEvent);
begin
  Self^.HandleEvent(Event);
end;

{****************************************************************************}
{ ViewSizeLimits                                                             }
{****************************************************************************}
procedure ViewSizeLimits(Self: PView; var Min, Max: TPoint);
begin
  Self^.SizeLimits(Min, Max);
end;

{****************************************************************************}
{ ViewValid                                                                  }
{****************************************************************************}
function ViewValid(Self: PView; Command: Word): Boolean;
begin
  ViewValid := Self^.Valid(Command);
end;

{****************************************************************************}
{ ViewChangeBounds                                                           }
{****************************************************************************}
procedure ViewChangeBounds(Self: PView; var Bounds: TRect);
begin
  Self^.ChangeBounds(Bounds);
end;

{****************************************************************************}
{ ViewSetData                                                                }
{****************************************************************************}
procedure ViewSetData(Self: PView; var Rec);
begin
  Self^.SetData(Rec);
end;

{****************************************************************************}
{ ViewGetData                                                                }
{****************************************************************************}
procedure ViewGetData(Self: PView; var Rec);
begin
  Self^.GetData(Rec);
end;

{****************************************************************************}
{ ViewDataSize                                                               }
{****************************************************************************}
function ViewDataSize(Self: PView): Word;
begin
  ViewDataSize := Self^.DataSize;
end;

end.
