{**************************************************************************}
{*  BitSoft Development, L.L.C.                                           *}
{*  Turbo Vision Resource WorkShop dialog controls for constant support   *}
{*                                                                        *}
{*  Turbo Vision Resource Workshop                                        *}
{*  Copyright (C) 1995-1996 Balazs Scheidler                              *}
{*  Portions Copyright (C) 1995, 1996 BitSoft Developmet, L.L.C.          *}
{*  All rights reserved.                                                  *}
{**************************************************************************}

(*
  NOTE: This is only a FAKE unit. I mean these objects are not REAL. Only
  the Init, Load, Store methods exist. This allows you to create Dialogs
  using the TConstInput, TConstDisplay, TConstZoom and TConstValidate
  controls and store the dialog on a stream, and later on TVRW will be able
  to read it back.
*)

unit Consts;
{$F+,I-,O+,S-,R-,Q-,V-,X+}

interface

uses
  Objects, Views, Dialogs, StdDlg, Validate;

const
  idConsts = 60400;

type
  PConstZoom = ^TConstZoom;
  TConstZoom = Object(TView)
    Link: PInputLine;
    Hex: Boolean;
    constructor Init(var Bounds: TRect; ALink: PInputLine; AHex: Boolean);
    constructor Load(var S: TStream);
    procedure Store(var S: TStream);
  end;

type
  PConstValidator = ^TConstValidator;
  TConstValidator = Object(TLookupValidator)
    Min, Max: Word;
    constructor Init(AMin, AMax: Word);
    constructor Load(var S: TStream);
    procedure Store(var S: TStream);
  end;

type
  PConstInput = ^TConstInput;
  TConstInput = Object(TInputLine)
  end;

type
  PConstDisplay = ^TConstDisplay;
  TConstDisplay = Object(TView)
    Displayed: Word;
    Link: PInputLine;
    constructor Init(var Bounds: TRect; ALink: PInputLine);
    constructor Load(var S: TStream);
    procedure Store(var S: TStream);
  end;

procedure RegisterConsts;

const
  RConstInput: TStreamRec =
   (ObjType: idConsts+2;
    VMTLink: Ofs(TypeOf(TConstInput)^);
    Load: @TConstInput.Load;
    Store: @TConstInput.Store);

  RConstZoom: TStreamRec =
   (ObjType: idConsts+3;
    VMTLink: Ofs(TypeOf(TConstZoom)^);
    Load: @TConstZoom.Load;
    Store: @TConstZoom.Store);

  RConstDisplay: TStreamRec =
   (ObjType: idConsts+4;
    VMTLink: Ofs(TypeOf(TConstDisplay)^);
    Load: @TConstDisplay.Load;
    Store: @TConstDisplay.Store);

  RConstValidator: TStreamRec =
   (ObjType: idConsts+6;
    VMTLink: Ofs(TypeOf(TConstValidator)^);
    Load: @TConstValidator.Load;
    Store: @TConstValidator.Store);

implementation

{****************************************************************************}
{ TConstZoom object                                                          }
{****************************************************************************}
{****************************************************************************}
{ TConstZoom.Init                                                            }
{****************************************************************************}
constructor TConstZoom.Init(var Bounds: TRect; ALink: PInputLine;
  AHex: Boolean);
begin
  inherited Init(Bounds);
  Options := Options or ofPreProcess;
  EventMask := EventMask or evBroadCast;
  Link := ALink;
  Hex := AHex;
end;

{****************************************************************************}
{ TConstZoom.Load                                                            }
{****************************************************************************}
constructor TConstZoom.Load(var S: TStream);
begin
  inherited Load(S);
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
{ TConstValidator object                                                     }
{****************************************************************************}
{****************************************************************************}
{ TConstValidator.Init                                                       }
{****************************************************************************}
constructor TConstValidator.Init(AMin, AMax: Word);
begin
  inherited Init;
  Min := AMin;
  Max := AMax;
  Options := Options or voTransfer;
end;

{****************************************************************************}
{ TConstValidator.Load                                                       }
{****************************************************************************}
constructor TConstValidator.Load(var S: TStream);
begin
  inherited Load(S);
  S.Read(Min, SizeOf(Min));
  S.Read(Max, SizeOf(Max));
end;

{****************************************************************************}
{ TConstValidator.Store                                                      }
{****************************************************************************}
procedure TConstValidator.Store(var S: TStream);
begin
  inherited Store(S);
  S.Write(Min, SizeOf(Min));
  S.Write(Max, SizeOf(Max));
end;


{****************************************************************************}
{ TConstDisplay object                                                       }
{****************************************************************************}
{****************************************************************************}
{ TConstDisplay.Init                                                         }
{****************************************************************************}
constructor TConstDisplay.Init(var Bounds: TRect; ALink: PInputLine);
begin
  inherited Init(Bounds);
  Link := ALink;
  EventMask := EventMask or evBroadCast;
end;

{****************************************************************************}
{ TConstDisplay.Load                                                         }
{****************************************************************************}
constructor TConstDisplay.Load(var S: TStream);
begin
  inherited Load(S);
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
{ RegisterConsts                                                             }
{****************************************************************************}
procedure RegisterConsts;
begin
  RegisterType(RConstInput);
  RegisterType(RConstDisplay);
  RegisterType(RConstZoom);
  RegisterType(RConstValidator);
end;

end.

