{**************************************************************************}
{*  BitSoft Development, L.L.C.                                           *}
{*  Turbo Vision Resource WorkShop custom control unit                    *}
{*                                                                        *}
{*  Turbo Vision Resource Workshop                                        *}
{*  Copyright (C) 1995-1996 Balazs Scheidler                              *}
{*  Portions Copyright (C) 1995, 1996 BitSoft Developmet, L.L.C.          *}
{*  All rights reserved.                                                  *}
{**************************************************************************}

unit TxtStrm;

interface
{$S-,T-,X+}

uses
  Objects;

type
  PTxtStream = ^TTxtStream;
  TTxtStream = Object(TObject)
    Stream: PStream;
    constructor Init(AStream: PStream);
    destructor Done; virtual;
    procedure WrStr(const Str: String); virtual;
    procedure WrPChar(P: PChar); virtual;
    procedure WrLn;
    procedure WrLong(L: Longint; FWidth: Integer);
    procedure WrParamText(const Format: String; var Params);
    procedure WrChar(Chr: Char; Count: Byte);
  end;

implementation

uses
  Strings, DrvUtils;

const
  vmtHeaderSize	= 8;
  TStream_Write	= vmtHeaderSize + $20;

{****************************************************************************}
{ TTxtStream object                                                          }
{****************************************************************************}
{****************************************************************************}
{ TTxtStream.Init                                                            }
{****************************************************************************}
constructor TTxtStream.Init(AStream: PStream);
begin
  inherited Init;
  Stream := AStream;
end;

{****************************************************************************}
{ TTxtStream.Done                                                            }
{****************************************************************************}
destructor TTxtStream.Done;
begin
  if Stream <> nil then Dispose(Stream, Done);
end;

{****************************************************************************}
{ TTxtStream.WrStr                                                           }
{****************************************************************************}
procedure TTxtStream.WrStr(const Str: String); assembler;
asm
	LES	DI,Str
	MOV	AX,DI
        MOV	DX,ES
        INC	AX
        MOV	CL,ES:[DI]
        XOR	CH,CH
        LES	DI,Self
        LES	DI,ES:[DI].TTxtStream.Stream
        MOV	BX,ES:[DI]
        PUSH	DX
        PUSH	AX
        PUSH	CX
        PUSH	ES
        PUSH	DI
        CALL	DWORD PTR [BX].TStream_Write
end;

{****************************************************************************}
{ TTxtStream.WrPChar                                                         }
{****************************************************************************}
procedure TTxtStream.WrPChar(P: PChar);
begin
  Stream^.Write(P^, StrLen(P));
end;

{****************************************************************************}
{ TTxtStream.WrLn                                                            }
{****************************************************************************}
procedure TTxtStream.WrLn;
const
  CRLF: array [1..2] of Char = #13#10;
begin
  WrStr(CRLF);
end;

{****************************************************************************}
{ TTxtStream.WrLong                                                          }
{****************************************************************************}
procedure TTxtStream.WrLong(L: Longint; FWidth: Integer);
var
  Tmp: String[10];
begin
  Str(L: FWidth, Tmp);
  WrStr(Tmp);
end;

{****************************************************************************}
{ TTxtStream.WrParamText                                                     }
{****************************************************************************}
procedure TTxtStream.WrParamText(const Format: String; var Params);
var
  Tmp: array [0..2048] of Char;
begin
  FormatStrExt(@Tmp, Format, Params);
  WrPChar(Tmp);
end;

{****************************************************************************}
{ TTxtStream.WrChar                                                          }
{****************************************************************************}
procedure TTxtStream.WrChar(Chr: Char; Count: Byte);
var
  Tmp: String;
  I: Integer;
begin
  for I := 1 to Count do Tmp[I] := Chr;
  Tmp[0] := System.Chr(Count);
  WrStr(Tmp);
end;

end.
