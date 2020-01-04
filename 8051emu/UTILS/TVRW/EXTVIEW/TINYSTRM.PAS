{**************************************************************************}
{*  BitSoft Development, L.L.C.                                           *}
{*  Turbo Vision Resource WorkShop custom control unit                    *}
{*                                                                        *}
{*  Turbo Vision Resource Workshop                                        *}
{*  Copyright (C) 1995-1996 Balazs Scheidler                              *}
{*  Portions Copyright (C) 1995, 1996 BitSoft Developmet, L.L.C.          *}
{*  All rights reserved.                                                  *}
{**************************************************************************}

(*
  This unit defines a very simple stream called TTinyStream. This stream
  implements a TMemoryStream-like behaviour, but is much simpler. It cannot
  resize the memory-block it is working on. This is used in the EXTCTRL.

  Since I cannot pass a stream pointer from TVRW to the control DLL, the
  Load and Store procedures are given Memory blocks to work on. But you can
  use TTinyStream to use this memory block as a data-area. Then your
  original Load, and Store code can be used in your controls' Load and
  Store methods.
*)

unit TinyStrm;
{$S-}

interface

uses
  Objects;

type
  PTinyStream = ^TTinyStream;
  TTinyStream = Object(TStream)
    MemBlock: Pointer;
    Pos: Word;
    Size: Word;
    constructor Init(AMemBlock: Pointer; ASize: Word);
    procedure Read(var Rec; Len: Word); virtual;
    procedure Write(var Rec; Len: Word); virtual;
    procedure Seek(NewPos: Longint); virtual;
    function GetPos: Longint; virtual;
    function GetSize: Longint; virtual;
  end;

implementation

{****************************************************************************}
{ TTinyStream object                                                         }
{****************************************************************************}
{****************************************************************************}
{ TTinyStream.Init                                                           }
{****************************************************************************}
constructor TTinyStream.Init(AMemBlock: Pointer; ASize: Word);
begin
  inherited Init;
  MemBlock := AMemBlock;
  Size := ASize;
end;

{****************************************************************************}
{ TTinyStream.Read                                                           }
{****************************************************************************}
procedure TTinyStream.Read(var Rec; Len: Word);
begin
  if Status = stOk then begin
    if Pos + Len > Size then
      Error(stReadError, 0)
     else begin
      Move(Ptr(Seg(MemBlock^), Ofs(MemBlock^) + Pos)^, Rec, Len);
      Inc(Pos, Len);
    end;
  end;
end;

{****************************************************************************}
{ TTinyStream.Write                                                          }
{****************************************************************************}
procedure TTinyStream.Write(var Rec; Len: Word);
begin
  if Status = stOk then begin
    if Pos + Len > Size then
      Error(stWriteError, 0)
     else begin
      Move(Rec, Ptr(Seg(MemBlock^), Ofs(MemBlock^) + Pos)^ , Len);
      Inc(Pos, Len);
    end;
  end;
end;

{****************************************************************************}
{ TTinyStream.Seek                                                           }
{****************************************************************************}
procedure TTinyStream.Seek(NewPos: Longint);
begin
  if Status = stOk then begin
    if NewPos > Size then Error(stError, 0) else Pos := NewPos;
  end;
end;

{****************************************************************************}
{ TTinyStream.GetPos                                                         }
{****************************************************************************}
function TTinyStream.GetPos: Longint;
begin
  GetPos := Pos;
end;


{****************************************************************************}
{ TTinyStream.GetSize                                                        }
{****************************************************************************}
function TTinyStream.GetSize: Longint;
begin
  GetSize := Size;
end;

end.
