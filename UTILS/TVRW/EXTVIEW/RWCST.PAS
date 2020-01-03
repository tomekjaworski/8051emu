{**************************************************************************}
{*  BitSoft Development, L.L.C.                                           *}
{*  Turbo Vision Resource WorkShop custom controls dll                    *}
{*                                                                        *}
{*  Turbo Vision Resource Workshop                                        *}
{*  Copyright (C) 1995-1996 Balazs Scheidler                              *}
{*  Portions Copyright (C) 1995, 1996 BitSoft Developmet, L.L.C.          *}
{*  All rights reserved.                                                  *}
{**************************************************************************}


library RWCst;
{$R+,I-,T-}

{$D TVRW Custom Controls DLL.}

uses
  Objects, TinyStrm, TxtStrm, DrvUtils, ExpView, MsgBox;

const
  idConsts = 60400;

type
  TConstInputData = record
    MaxLen: Longint;
    ValidMin, ValidMax: Longint;
  end;

type
  PConstInput = ^TConstInput;
  TConstInput = Object(TView)
    MaxLen,
    CurPos,
    FirstPos,
    SelStart,
    SelEnd: Integer;
    ValidType: Word;
    ValidOpt: Word;
    ValidMin, ValidMax: Word;
    constructor Init(ARemoteSelf: PExtView; var Bounds: TRect);
    constructor Load(ARemoteSelf: PExtView; var S: TStream);
    procedure Store(var S: TStream);
    function GetPalette: PPalette; virtual;
    procedure Draw; virtual;
    procedure SizeLimits(var Min, Max: TPoint); virtual;
  end;

{****************************************************************************}
{ TConstInput object                                                         }
{****************************************************************************}
{****************************************************************************}
{ TConstInput.Init                                                           }
{****************************************************************************}
constructor TConstInput.Init(ARemoteSelf: PExtView; var Bounds: TRect);
begin
  Bounds.Assign(Bounds.A.X, Bounds.A.Y, Bounds.A.X + 10, Bounds.A.Y + 1);
  inherited Init(ARemoteSelf, Bounds);
  MaxLen := 30;
  CurPos := 1;
  FirstPos := 1;
  SelStart := 1;
  SelEnd := 1;
  RemoteSelf^.Options := RemoteSelf^.Options or ofVersion20;
  ValidType := idConsts + 6;
  ValidOpt := 2;  {votransfer}
  ValidMin := 0;
  ValidMax := $FFFF;
end;

{****************************************************************************}
{ TConstInput.Load                                                           }
{****************************************************************************}
constructor TConstInput.Load(ARemoteSelf: PExtView; var S: TStream);
begin
  inherited Load(ARemoteSelf, S);
  S.Read(MaxLen, SizeOf(Integer)*5);
  DisposeStr(S.ReadStr);
  S.Read(ValidType, SizeOf(ValidType));
  if ValidType = idConsts+6 then begin { Read validator object }
    S.Read(ValidOpt, 2);
    S.Read(ValidMin, 4);
  end;
end;

{****************************************************************************}
{ TConstInput.Store                                                          }
{****************************************************************************}
procedure TConstInput.Store(var S: TStream);
var
  L: Byte;
begin
  inherited Store(S);
  S.Write(MaxLen, SizeOf(Integer)*5);
  L := 0;
  S.Write(L, 1);    { string = '' }
  if ValidType = idConsts+6 then begin { Write the validator object }
    S.Write(ValidType, 2);
    S.Write(ValidOpt, 2);
    S.Write(ValidMin, 4);
  end;
end;

{****************************************************************************}
{ TConstInput.GetPalette                                                     }
{****************************************************************************}
function TConstInput.GetPalette: PPalette;
const
  P: String[1] = #19;
begin
  GetPalette := @P;
end;

{****************************************************************************}
{ TConstInput.Draw                                                           }
{****************************************************************************}
procedure TConstInput.Draw;
var
  B: TDrawBuffer;
begin
  inherited Draw;
  WriteStr(1, 0, 'ConstInp', 1);
end;

{****************************************************************************}
{ TConstInput.SizeLimits                                                     }
{****************************************************************************}
procedure TConstInput.SizeLimits(var Min, Max: TPoint);
begin
  Min.X := 3;
  Min.Y := 1;
  Max.Y := 1;
end;

{****************************************************************************}
{ ConstInput_Allocate                                                        }
{****************************************************************************}
function ConstInput_Allocate: Pointer; export;
{ Allocate function.  An Allocate function is needed for all
  exported controls. }
begin
  ConstInput_Allocate := New(PConstInput);
end;

{****************************************************************************}
{ ConstInput_Free                                                            }
{****************************************************************************}
procedure ConstInput_Free(P: PConstInput); export;
{ Free function. TVRW will take care about calling first ConstInput_Done and
  then ConstInput_Free, so DO NOT use Dispose(P, Done) here. The same applies
  to the allocate function. }
begin
  Dispose(P);
end;

{****************************************************************************}
{ ConstInput_Init                                                            }
{****************************************************************************}
function ConstInput_Init(Self: PConstInput; RemoteSelf: PExtView;
  var Bounds: TRect): Boolean; export;
begin
  ConstInput_Init := Self^.Init(RemoteSelf, Bounds);
end;

{****************************************************************************}
{ ConstInput_Done                                                            }
{****************************************************************************}
procedure ConstInput_Done(Self: PConstInput); export;
begin
  Self^.Done;
end;

{****************************************************************************}
{ ConstInput_Load                                                            }
{****************************************************************************}
function ConstInput_Load(Self: PConstInput; RemoteSelf: PExtView;
  MemBlock: Pointer; Len: Word): Boolean; export;
var
  S: PStream;
begin
  S := New(PTinyStream, Init(MemBlock, Len));
  ConstInput_Load := Self^.Load(RemoteSelf, S^);
  Dispose(S, Done);
end;

{****************************************************************************}
{ ConstInput_Store                                                           }
{****************************************************************************}
procedure ConstInput_Store(Self: PConstInput; MemBlock: Pointer;
  MaxLen: Word; var Len: Word); export;
var
  S: PStream;
begin
  S := New(PTinyStream, Init(MemBlock, MaxLen));
  Self^.Store(S^);
  Len := S^.GetPos;
  Dispose(S, Done);
end;

{****************************************************************************}
{ ConstInput_CtrlToData                                                      }
{****************************************************************************}
procedure ConstInput_CtrlToData(Self: PConstInput; Consts: PCollection;
  var Rec: TConstInputData); export;
{ This procedure is used to build the Transfer structure of the settings
  dialog.  TConstInput has only one field. }
begin
  Rec.MaxLen := Self^.MaxLen;
  Rec.ValidMin := Self^.ValidMin;
  Rec.ValidMax := Self^.ValidMax;
end;

{****************************************************************************}
{ ConstInput_DataToCtrl                                                      }
{****************************************************************************}
procedure ConstInput_DataToCtrl(Self: PConstInput;
  var Rec: TConstInputData); export;
{ The opposite of the above.  The Consts parameter is used, when you use the
  Constant inputline feature of Turbo Vision Resource WorkShop.  Just pass
  the Consts parameter in the transfer record. }
begin
  Self^.MaxLen := Rec.MaxLen;
  Self^.ValidMin := Rec.ValidMin;
  Self^.ValidMax := Rec.ValidMax;
end;

{****************************************************************************}
{ ConstInput_WriteSource                                                     }
{****************************************************************************}
procedure ConstInput_WriteSource(Self: PConstInput; Lang: Word; ClassName,
  VarName, LinkTo: PChar; MemBlock: PChar; MemSize: Word); export;
{ This is the sourcer procedure }
var
  Out: PTxtStream;
  Params: array [1..6] of Longint;
begin
  Out := New(PTxtStream, Init(New(PTinyStream, Init(MemBlock, MemSize))));
  case Lang of
    lnPascal:
      begin
        Params[1] := Longint(VarName);
        Params[2] := Longint(ClassName);
        Params[3] := Self^.MaxLen;
        Params[4] := Longint(VarName);
        Params[5] := Self^.ValidMin;
        Params[6] := Self^.ValidMax;
        Out^.WrParamText('%z := New(P%z, Init(R, %d));'#13+
	                 'PConstInput(%z)^.SetValidator(New(PConstValidator, Init(%d, %d)));'#13, Params);
      end;
    lnCPlusPlus:
      begin
        Out^.WrStr('/* C++ version of TConstInput is not supported. */');
      end;
  end;
  Out^.WrChar(#0, 1);
  Dispose(Out, Done);
end;

{****************************************************************************}
{ ConstInput_WriteTransferFields                                             }
{****************************************************************************}
procedure ConstInput_WriteTransferFields(Self: PConstInput; Lang,
  TabNum: Word; MemBlock: PChar; MemSize: Word); export;
var
  Out: PTxtStream;
  Params: array [1..3] of Longint;
begin
  Out := New(PTxtStream, Init(New(PTinyStream, Init(MemBlock, MemSize))));
  Params[1] := TabNum;
  case Lang of
    lnPascal:
      begin
        Params[2] := TabNum;
        Params[3] := Self^.MaxLen;
        Out^.WrParamText('Consts%d: PConstCollection;'#13+
	                 'ConstInput%d: String[%d];'#13, Params);
      end;
    lnCPlusPlus:
      begin
        Out^.WrParamText('/* C++ version of TConstInput is not supported */'+
          #13, Params);
      end;
  end;
  Out^.WrChar(#0, 1);
  Dispose(Out, Done);
end;

type
  TConstZoomData = record
    Hex: Boolean;
  end;

  PConstZoom = ^TConstZoom;
  TConstZoom = Object(TView)
    Link: PExtView;
    Hex: Boolean;
    constructor Init(ARemoteSelf: PExtView; var Bounds: TRect);
    constructor Load(ARemoteSelf: PExtView; var S: TStream);
    procedure Store(var S: TStream);
    procedure HandleEvent(var Event: TEvent); virtual;
    function GetPalette: PPalette; virtual;
    procedure Draw; virtual;
    procedure SizeLimits(var Min, Max: TPoint); virtual;
  end;

{****************************************************************************}
{ TConstZoom object                                                          }
{****************************************************************************}
{****************************************************************************}
{ TConstZoom.Init                                                            }
{****************************************************************************}
constructor TConstZoom.Init(ARemoteSelf: PExtView; var Bounds: TRect);
begin
  Bounds.Assign(Bounds.A.X, Bounds.A.Y, Bounds.A.X+3, Bounds.A.Y+1);
  inherited Init(ARemoteSelf, Bounds);
  Hex := False;
  Link := nil;
end;

{****************************************************************************}
{ TConstZoom.Load                                                            }
{****************************************************************************}
constructor TConstZoom.Load(ARemoteSelf: PExtView; var S: TStream);
begin
  inherited Load(ARemoteSelf, S);
  GetPeerViewPtr(S, Link);
  S.Read(Hex, SizeOf(Hex));
end;

{****************************************************************************}
{ TConstZoom.Store                                                           }
{****************************************************************************}
procedure TConstZoom.Store(var S: TStream);
begin
  inherited Store(S);
  PutPeerViewPtr(S, Link);
  S.Write(Hex, SizeOf(Hex));
end;

{****************************************************************************}
{ TConstZoom.HandleEvent                                                     }
{****************************************************************************}
procedure TConstZoom.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evBroadCast:
      case Event.Command of
        cmIsLinkableTo:
          if Event.InfoPtr <> nil then begin
            { This view can be linked to a TConstInput, or a TInputLine }
            if (PString(Event.InfoPtr)^ = 'TConstInput') or
	       (PString(Event.InfoPtr)^ = 'TInputLine') then ClearEvent(Event);
          end;
        cmSetLinkedView:
          begin
            Link := Event.InfoPtr;
            ClearEvent(Event);
          end;
        cmGetLinkName:
          if Event.InfoPtr <> nil then begin
            PString(Event.InfoPtr)^ := '(TConstZoom)';
            ClearEvent(Event);
          end;
      end;
  end;
end;

{****************************************************************************}
{ TConstZoom.GetPalette                                                      }
{****************************************************************************}
function TConstZoom.GetPalette: PPalette;
const
  P: String[2] = #22#23;
begin
  GetPalette := @P;
end;

{****************************************************************************}
{ TConstZoom.Draw                                                            }
{****************************************************************************}
procedure TConstZoom.Draw;
var
  B: TDrawBuffer;
begin
  MoveCStr(B, #222'~*~'#221, GetColor($0102));
  WriteLine(0, 0, Size.X, Size.Y, B);
end;

{****************************************************************************}
{ TConstZoom.SizeLimits                                                      }
{****************************************************************************}
procedure TConstZoom.SizeLimits(var Min, Max: TPoint);
begin
  Min.X := 3;
  Min.Y := 1;
  Max.Y := 1;
  Max.X := 3;
end;

{****************************************************************************}
{ ConstZoom_Allocate                                                         }
{****************************************************************************}
function ConstZoom_Allocate: Pointer; export;
{ Allocate function.  An Allocate function is needed for all
  exported controls. }
begin
  ConstZoom_Allocate := New(PConstZoom);
end;

{****************************************************************************}
{ ConstZoom_Free                                                             }
{****************************************************************************}
procedure ConstZoom_Free(P: PConstZoom); export;
{ Free function. TVRW will take care about calling first ConstInput_Done and
  then ConstInput_Free, so DO NOT use Dispose(P, Done) here. The same applies
  to the allocate function. }
begin
  Dispose(P);
end;

{****************************************************************************}
{ ConstZoom_Init                                                             }
{****************************************************************************}
function ConstZoom_Init(Self: PConstZoom; RemoteSelf: PExtView;
  var Bounds: TRect): Boolean; export;
begin
  ConstZoom_Init := Self^.Init(RemoteSelf, Bounds);
end;

{****************************************************************************}
{ ConstZoom_Done                                                             }
{****************************************************************************}
procedure ConstZoom_Done(Self: PConstZoom); export;
begin
  Self^.Done;
end;

{****************************************************************************}
{ ConstZoom_Load                                                             }
{****************************************************************************}
function ConstZoom_Load(Self: PConstZoom; RemoteSelf: PExtView;
  MemBlock: Pointer; Len: Word): Boolean; export;
var
  S: PStream;
begin
  S := New(PTinyStream, Init(MemBlock, Len));
  ConstZoom_Load := Self^.Load(RemoteSelf, S^);
  Dispose(S, Done);
end;

{****************************************************************************}
{ ConstZoom_Store                                                            }
{****************************************************************************}
procedure ConstZoom_Store(Self: PConstZoom; MemBlock: Pointer; MaxLen: Word;
  var Len: Word); export;
var
  S: PStream;
begin
  S := New(PTinyStream, Init(MemBlock, MaxLen));
  Self^.Store(S^);
  Len := S^.GetPos;
  Dispose(S, Done);
end;

{****************************************************************************}
{ ConstZoom_CtrlToData                                                       }
{****************************************************************************}
procedure ConstZoom_CtrlToData(Self: PConstZoom; Consts: PCollection;
  var Rec: TConstZoomData); export;
begin
  Rec.Hex := Self^.Hex;
end;

{****************************************************************************}
{ ConstZoom_DataToCtrl                                                       }
{****************************************************************************}
procedure ConstZoom_DataToCtrl(Self: PConstZoom;
  var Rec: TConstZoomData); export;
begin
  Self^.Hex := Rec.Hex;
end;

{****************************************************************************}
{ ConstZoom_WriteSource                                                      }
{****************************************************************************}
procedure ConstZoom_WriteSource(Self: PConstZoom; Lang: Word; ClassName,
  VarName, LinkTo: PChar; MemBlock: PChar; MemSize: Word); export;
var
  Out: PTxtStream;
  Params: array [1..6] of Longint;
  Tmp2: String[5];
const
  Tmp1: array [0..3] of Char = 'nil';
begin
  Out := New(PTxtStream, Init(New(PTinyStream, Init(MemBlock, MemSize))));
  case Lang of
    lnPascal:
      begin
        Params[1] := Longint(VarName);
        Params[2] := Longint(ClassName);
        if (LinkTo = nil) or (LinkTo^ = #0) then
	  Params[3] := Longint(@Tmp1)
	 else
	  Params[3] := Longint(LinkTo);
        Params[4] := Longint(@Tmp2);
        if Self^.Hex then Tmp2 := 'True' else Tmp2 := 'False';
        Out^.WrParamText('%z := New(P%z, Init(R, PInputLine(%z), %s));'#13,
          Params);
      end;
    lnCPlusPlus:
      begin
        Out^.WrStr('/* C++ version of TConstZoom is not supported. */');
      end;
  end;
  Out^.WrChar(#0, 1);
  Dispose(Out, Done);
end;

{****************************************************************************}
{ ConstZoom_WriteTransferFields                                              }
{****************************************************************************}
procedure ConstZoom_WriteTransferFields(Self: PConstZoom; Lang, TabNum: Word;
  MemBlock: PChar; MemSize: Word); export;
var
  Out: PTxtStream;
  Params: array [1..3] of Longint;
begin
  Out := New(PTxtStream, Init(New(PTinyStream, Init(MemBlock, MemSize))));
  Params[1] := TabNum;
  case Lang of
    lnPascal:
      begin
        Out^.WrParamText('Consts%d: PConstCollection;'#13, Params);
      end;
    lnCPlusPlus:
      begin
        Out^.WrParamText('/* C++ version of TConstZoom is not supported */'+
          #13, Params);
      end;
  end;
  Out^.WrChar(#0, 1);
  Dispose(Out, Done);
end;

type
  PConstDisplay = ^TConstDisplay;
  TConstDisplay = Object(TView)
    Link: PExtView;
    constructor Init(ARemoteSelf: PExtView; var Bounds: TRect);
    constructor Load(ARemoteSelf: PExtView; var S: TStream);
    procedure Store(var S: TStream);
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure Draw; virtual;
    procedure SizeLimits(var Min, Max: TPoint); virtual;
  end;

{****************************************************************************}
{ TConstDisplay object                                                       }
{****************************************************************************}
{****************************************************************************}
{ TConstDisplay.Init                                                         }
{****************************************************************************}
constructor TConstDisplay.Init(ARemoteSelf: PExtView; var Bounds: TRect);
begin
  Bounds.Assign(Bounds.A.X, Bounds.A.Y, Bounds.A.X + 15, Bounds.A.Y + 1);
  inherited Init(ARemoteSelf, Bounds);
  RemoteSelf^.EventMask := RemoteSelf^.EventMask or evBroadCast;
end;

{****************************************************************************}
{ TConstDisplay.Load                                                         }
{****************************************************************************}
constructor TConstDisplay.Load(ARemoteSelf: PExtView; var S: TStream);
begin
  inherited Load(ARemoteSelf, S);
  GetPeerViewPtr(S, Link);
end;

{****************************************************************************}
{ TConstDisplay.Store                                                        }
{****************************************************************************}
procedure TConstDisplay.Store(var S: TStream);
begin
  inherited Store(S);
  PutPeerViewPtr(S, Link);
end;

{****************************************************************************}
{ TConstDisplay.HandleEvent                                                  }
{****************************************************************************}
procedure TConstDisplay.HandleEvent(var Event: TEvent);
var
  Err: Word;
begin
  if Event.What = evBroadCast then
    case Event.Command of
        cmIsLinkableTo:
          if Event.InfoPtr <> nil then begin
            { This view can be linked to a TConstInput, or a TInputLine }
            if (PString(Event.InfoPtr)^ = 'TConstInput') or
	       (PString(Event.InfoPtr)^ = 'TInputLine') then ClearEvent(Event);
          end;
        cmSetLinkedView:
          begin
            Link := Event.InfoPtr;
            ClearEvent(Event);
          end;
        cmGetLinkName:
          if Event.InfoPtr <> nil then begin
            PString(Event.InfoPtr)^ := '(TConstDisplay)';
            ClearEvent(Event);
          end;
    end;
end;

{****************************************************************************}
{ TConstDisplay.Draw                                                         }
{****************************************************************************}
procedure TConstDisplay.Draw;
var
  B: TDrawBuffer;
begin
  MoveChar(B, ' ', GetColor(1), Size.X);
  MoveStr(B[1], 'ConstDisplay', GetColor(1));
  WriteLine(0, 0, Size.X, Size.Y, B);
end;

{****************************************************************************}
{ TConstDisplay.SizeLimits                                                   }
{****************************************************************************}
procedure TConstDisplay.SizeLimits(var Min, Max: TPoint);
begin
  Min.X := 3;
  Min.Y := 1;
  Max.Y := 1;
end;

{****************************************************************************}
{ ConstDisplay_Allocate                                                      }
{****************************************************************************}
function ConstDisplay_Allocate: Pointer; export;
begin
  ConstDisplay_Allocate := New(PConstDisplay);
end;

{****************************************************************************}
{ ConstDisplay_Free                                                          }
{****************************************************************************}
procedure ConstDisplay_Free(P: PConstDisplay); export;
begin
  Dispose(P);
end;

{****************************************************************************}
{ ConstDisplay_Init                                                          }
{****************************************************************************}
function ConstDisplay_Init(Self: PConstDisplay; RemoteSelf: PExtView;
  var Bounds: TRect): Boolean; export;
begin
  ConstDisplay_Init := Self^.Init(RemoteSelf, Bounds);
end;

{****************************************************************************}
{ ConstDisplay_Done                                                          }
{****************************************************************************}
procedure ConstDisplay_Done(Self: PConstDisplay); export;
begin
  Self^.Done;
end;

{****************************************************************************}
{ ConstDisplay_Load                                                          }
{****************************************************************************}
function ConstDisplay_Load(Self: PConstDisplay; RemoteSelf: PExtView;
  MemBlock: Pointer; Len: Word): Boolean; export;
var
  S: PStream;
begin
  S := New(PTinyStream, Init(MemBlock, Len));
  ConstDisplay_Load := Self^.Load(RemoteSelf, S^);
  Dispose(S, Done);
end;

{****************************************************************************}
{ ConstDisplay_Store                                                         }
{****************************************************************************}
procedure ConstDisplay_Store(Self: PConstDisplay; MemBlock: Pointer;
  MaxLen: Word; var Len: Word); export;
var
  S: PStream;
begin
  S := New(PTinyStream, Init(MemBlock, MaxLen));
  Self^.Store(S^);
  Len := S^.GetPos;
  Dispose(S, Done);
end;

{****************************************************************************}
{ ConstDisplay_WriteSource                                                   }
{****************************************************************************}
procedure ConstDisplay_WriteSource(Self: PConstDisplay; Lang: Word;
  ClassName, VarName, LinkTo: PChar; MemBlock: PChar; MemSize: Word); export;
var
  Out: PTxtStream;
  Params: array [1..6] of Longint;
const
  Tmp1: array [0..3] of Char = 'nil';
begin
  Out := New(PTxtStream, Init(New(PTinyStream, Init(MemBlock, MemSize))));
  case Lang of
    lnPascal:
      begin
        Params[1] := Longint(VarName);
        Params[2] := Longint(ClassName);
        if (LinkTo = nil) or (LinkTo^ = #0) then
          Params[3] := Longint(@Tmp1)
        else
          Params[3] := Longint(LinkTo);
        Out^.WrParamText('%z := New(P%z, Init(R, PInputLine(%z)));'#13,
          Params);
      end;
    lnCPlusPlus:
      begin
        Out^.WrStr('/* C++ version of TConstDisplay is not supported. */');
      end;
  end;
  Out^.WrChar(#0, 1);
  Dispose(Out, Done);
end;

{****************************************************************************}
{ ConstDisplay_WriteTransferFields                                           }
{****************************************************************************}
procedure ConstDisplay_WriteTransferFields(Self: PConstDisplay; Lang,
  TabNum: Word; MemBlock: PChar; MemSize: Word); export;
var
  Out: PTxtStream;
  Params: array [1..3] of Longint;
begin
  Out := New(PTxtStream, Init(New(PTinyStream, Init(MemBlock, MemSize))));
  Params[1] := TabNum;
  case Lang of
    lnPascal:
      begin
        Out^.WrParamText('Consts%d: PConstCollection;'#13, Params);
      end;
    lnCPlusPlus:
      begin
        Out^.WrParamText('/* C++ version of TConstDisplay is not supported */'+
          #13, Params);
      end;
  end;
  Out^.WrChar(#0, 1);
  Dispose(Out, Done);
end;

const

  { Data structure used when communicating with TVRW. }

  DConstInput: TControlData =
    (Size: SizeOf(TControlData);
     Id: 'TVRWCust_ConstInput';  { Has to be unique among all external  }
                                 { controls, that's why we included the }
                                 { DLL name and the class name here}
     TypeId: 'ConstInput';
     Description: 'Constant Inputline';
     ObjType: idConsts+2;
     PrefixStr: 'CONSTINPUT');

  DConstZoom: TControlData =
    (Size: SizeOf(TControlData);
     Id: 'TVRWCust_ConstZoom';
     TypeId: 'ConstZoom';
     Description: 'Constant zoomer';
     ObjType: idConsts+3;
     PrefixStr: 'CONSTZOOM');

  DConstDisplay: TControlData =
    (Size: SizeOf(TControlData);
     Id: 'TVRWCust_ConstDisplay';
     TypeId: 'ConstDisplay';
     Description: 'Constant displayer';
     ObjType: idConsts+4;
     PrefixStr: 'ConstDisplay');

const
  ExportedControls: array [1..4] of PControlData =
    (@DConstInput, @DConstZoom, @DConstDisplay, nil);

var
  CurrCtrl: Integer;

{****************************************************************************}
{ CtrlFindFirst                                                              }
{****************************************************************************}
function CtrlFindFirst: PControlData; export;
{ Findfirst function. Resets search and returns the first available control. }
begin
  CurrCtrl := 2;
  CtrlFindFirst := ExportedControls[1];
end;

{****************************************************************************}
{ CtrlFindNext                                                               }
{****************************************************************************}
function CtrlFindNext: PControlData; export;
begin
  CtrlFindNext := ExportedControls[CurrCtrl];
  Inc(CurrCtrl);
end;

{****************************************************************************}
{ InitControlDLL                                                             }
{****************************************************************************}
procedure InitControlDLL(TVRWInstance: Word; var Description: String); export;
{ DLL initialization procedure. TVRW will not accept DLLs without this
  routine. }
begin
  LinkProcedures(TVRWInstance);
  Description := 'TVRW Custom Control DLL.';
end;

{****************************************************************************}
{ DoneControlDLL                                                             }
{****************************************************************************}
procedure DoneControlDLL; export;
{ DLL exit procedure. }
begin
end;

{****************************************************************************}
{ AboutControlDLL                                                            }
{****************************************************************************}
procedure AboutControlDLL; export;
{ About procedure. }
begin
  MessageBox(^C'TVRW Custom Control Library'^M+
    ^C'BitSoft Development, L.L.C.'^M+
    ^C'Copyright (C) 1995-1996', nil, mfInformation or mfOKButton);
end;

exports
  ConstInput_Allocate,
  ConstInput_Free,
  ConstInput_Init,
  ConstInput_Done,
  ConstInput_Load,
  ConstInput_Store,
  ConstInput_CtrlToData,
  ConstInput_DataToCtrl,
  ConstInput_WriteSource,
  ConstInput_WriteTransferFields,
  ConstZoom_Allocate,
  ConstZoom_Free,
  ConstZoom_Init,
  ConstZoom_Done,
  ConstZoom_Load,
  ConstZoom_Store,
  ConstZoom_CtrlToData,
  ConstZoom_DataToCtrl,
  ConstZoom_WriteSource,
  ConstZoom_WriteTransferFields,
  ConstDisplay_Allocate,
  ConstDisplay_Free,
  ConstDisplay_Init,
  ConstDisplay_Done,
  ConstDisplay_Load,
  ConstDisplay_Store,
  ConstDisplay_WriteSource,
  ConstDisplay_WriteTransferFields,
  ViewDraw,
  ViewGetPalette,
  ViewHandleEvent,
  ViewSizeLimits,
  ViewValid,
  ViewChangeBounds,
  ViewSetData,
  ViewGetData,
  ViewDataSize,
  InitControlDLL,
  DoneControlDLL,
  AboutControlDLL,
  CtrlFindFirst,
  CtrlFindNext;

begin
end.
