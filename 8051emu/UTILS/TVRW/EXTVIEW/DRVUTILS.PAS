{**************************************************************************}
{*  BitSoft Development, L.L.C.                                           *}
{*  Turbo Vision Resource WorkShop exportable controls unit               *}
{*                                                                        *}
{*  Turbo Vision Resource Workshop                                        *}
{*  Copyright (C) 1995-1996 Balazs Scheidler                              *}
{*  Portions Copyright (C) 1995, 1996 BitSoft Developmet, L.L.C.          *}
{*  All rights reserved.                                                  *}
{**************************************************************************}

(*
  NOTE: This unit is a subset of procedures found in the Drivers unit,
  plus some constants. This unit is needed to provide compatibility with
  REAL TV code.
*)

unit DrvUtils;
{$S-}

interface

uses
  Objects;

const

{ Event codes }

  evMouseDown = $0001;
  evMouseUp   = $0002;
  evMouseMove = $0004;
  evMouseAuto = $0008;
  evKeyDown   = $0010;
  evCommand   = $0100;
  evBroadcast = $0200;

{ Event masks }

  evNothing   = $0000;
  evMouse     = $000F;
  evKeyboard  = $0010;
  evMessage   = $FF00;

{ Event record }

type
  PEvent = ^TEvent;
  TEvent = record
    What: Word;
    case Word of
      evNothing: ();
      evMouse: (
        Buttons: Byte;
        Double: Boolean;
        Where: TPoint);
      evKeyDown: (
        case Integer of
	  0: (KeyCode: Word);
          1: (CharCode: Char;
              ScanCode: Byte));
      evMessage: (
        Command: Word;
        case Word of
          0: (InfoPtr: Pointer);
          1: (InfoLong: Longint);
          2: (InfoWord: Word);
          3: (InfoInt: Integer);
          4: (InfoByte: Byte);
          5: (InfoChar: Char));
  end;

const

{ Extended key codes }

  kbEsc       = $011B;  kbAltSpace  = $0200;  kbCtrlIns   = $0400;
  kbShiftIns  = $0500;  kbCtrlDel   = $0600;  kbShiftDel  = $0700;
  kbBack      = $0E08;  kbCtrlBack  = $0E7F;  kbShiftTab  = $0F00;
  kbTab       = $0F09;  kbAltQ      = $1000;  kbAltW      = $1100;
  kbAltE      = $1200;  kbAltR      = $1300;  kbAltT      = $1400;
  kbAltY      = $1500;  kbAltU      = $1600;  kbAltI      = $1700;
  kbAltO      = $1800;  kbAltP      = $1900;  kbCtrlEnter = $1C0A;
  kbEnter     = $1C0D;  kbAltA      = $1E00;  kbAltS      = $1F00;
  kbAltD      = $2000;  kbAltF      = $2100;  kbAltG      = $2200;
  kbAltH      = $2300;  kbAltJ      = $2400;  kbAltK      = $2500;
  kbAltL      = $2600;  kbAltZ      = $2C00;  kbAltX      = $2D00;
  kbAltC      = $2E00;  kbAltV      = $2F00;  kbAltB      = $3000;
  kbAltN      = $3100;  kbAltM      = $3200;  kbF1        = $3B00;
  kbF2        = $3C00;  kbF3        = $3D00;  kbF4        = $3E00;
  kbF5        = $3F00;  kbF6        = $4000;  kbF7        = $4100;
  kbF8        = $4200;  kbF9        = $4300;  kbF10       = $4400;
  kbHome      = $4700;  kbUp        = $4800;  kbPgUp      = $4900;
  kbGrayMinus = $4A2D;  kbLeft      = $4B00;  kbRight     = $4D00;
  kbGrayPlus  = $4E2B;  kbEnd       = $4F00;  kbDown      = $5000;
  kbPgDn      = $5100;  kbIns       = $5200;  kbDel       = $5300;
  kbShiftF1   = $5400;  kbShiftF2   = $5500;  kbShiftF3   = $5600;
  kbShiftF4   = $5700;  kbShiftF5   = $5800;  kbShiftF6   = $5900;
  kbShiftF7   = $5A00;  kbShiftF8   = $5B00;  kbShiftF9   = $5C00;
  kbShiftF10  = $5D00;  kbCtrlF1    = $5E00;  kbCtrlF2    = $5F00;
  kbCtrlF3    = $6000;  kbCtrlF4    = $6100;  kbCtrlF5    = $6200;
  kbCtrlF6    = $6300;  kbCtrlF7    = $6400;  kbCtrlF8    = $6500;
  kbCtrlF9    = $6600;  kbCtrlF10   = $6700;  kbAltF1     = $6800;
  kbAltF2     = $6900;  kbAltF3     = $6A00;  kbAltF4     = $6B00;
  kbAltF5     = $6C00;  kbAltF6     = $6D00;  kbAltF7     = $6E00;
  kbAltF8     = $6F00;  kbAltF9     = $7000;  kbAltF10    = $7100;
  kbCtrlPrtSc = $7200;  kbCtrlLeft  = $7300;  kbCtrlRight = $7400;
  kbCtrlEnd   = $7500;  kbCtrlPgDn  = $7600;  kbCtrlHome  = $7700;
  kbAlt1      = $7800;  kbAlt2      = $7900;  kbAlt3      = $7A00;
  kbAlt4      = $7B00;  kbAlt5      = $7C00;  kbAlt6      = $7D00;
  kbAlt7      = $7E00;  kbAlt8      = $7F00;  kbAlt9      = $8000;
  kbAlt0      = $8100;  kbAltMinus  = $8200;  kbAltEqual  = $8300;
  kbCtrlPgUp  = $8400;  kbAltBack   = $0800;  kbNoKey     = $0000;

{ Mouse button state masks }

  mbLeftButton  = $01;
  mbRightButton = $02;

{ Keyboard support routines }

function GetAltChar(KeyCode: Word): Char;
function GetAltCode(Ch: Char): Word;
function GetCtrlChar(KeyCode: Word): Char;
function GetCtrlCode(Ch: Char): Word;
function CtrlToArrow(KeyCode: Word): Word;

{ String routines }

procedure PrintStr(const S: String);

{ Buffer move routines }

procedure MoveBuf(var Dest; var Source; Attr: Byte; Count: Word);
procedure MoveChar(var Dest; C: Char; Attr: Byte; Count: Word);
procedure MoveCStr(var Dest; const Str: String; Attrs: Word);
procedure MoveStr(var Dest; const Str: String; Attr: Byte);
function CStrLen(const S: String): Integer;

procedure FormatStr(var Dest: String; const Format: String; var Params);
procedure FormatStrExt(Dest: PChar; const Format: String; var Params);

implementation

{ Keyboard support routines }

const

  AltCodes1: array[$10..$32] of Char =
    'QWERTYUIOP'#0#0#0#0'ASDFGHJKL'#0#0#0#0#0'ZXCVBNM';

  AltCodes2: array[$78..$83] of Char =
    '1234567890-=';

{****************************************************************************}
{ GetAltChar                                                                 }
{****************************************************************************}
function GetAltChar(KeyCode: Word): Char;
begin
  GetAltChar := #0;
  if Lo(KeyCode) = 0 then
    case Hi(KeyCode) of
      $02: GetAltChar := #240;
      $10..$32: GetAltChar := AltCodes1[Hi(KeyCode)];
      $78..$83: GetAltChar := AltCodes2[Hi(KeyCode)];
    end;
end;

{****************************************************************************}
{ GetAltCode                                                                 }
{****************************************************************************}
function GetAltCode(Ch: Char): Word;
var
  I: Word;
begin
  GetAltCode := 0;
  if Ch = #0 then Exit;
  Ch := UpCase(Ch);
  if Ch = #240 then
  begin
    GetAltCode := $0200;
    Exit;
  end;
  for I := $10 to $32 do
    if AltCodes1[I] = Ch then
    begin
      GetAltCode := I shl 8;
      Exit;
    end;
  for I := $78 to $83 do
    if AltCodes2[I] = Ch then
    begin
      GetAltCode := I shl 8;
      Exit;
    end;
end;

{****************************************************************************}
{ GetCtrlChar                                                                }
{****************************************************************************}
function GetCtrlChar(KeyCode: Word): Char;
begin
  GetCtrlChar := #0;
  if (Lo(KeyCode) <> 0) and (Lo(KeyCode) <= Byte('Z') - Byte('A') + 1) then
    GetCtrlChar := Char(Lo(KeyCode) + Byte('A') - 1);
end;

{****************************************************************************}
{ GetCtrlCode                                                                }
{****************************************************************************}
function GetCtrlCode(Ch: Char): Word;
begin
  GetCtrlCode := GetAltCode(Ch) or (Byte(UpCase(Ch)) - Byte('A') + 1);
end;

{****************************************************************************}
{ CtrlToArrow                                                                }
{****************************************************************************}
function CtrlToArrow(KeyCode: Word): Word;
const
  NumCodes = 11;
  CtrlCodes: array[0..NumCodes-1] of Char = ^S^D^E^X^A^F^G^V^R^C^H;
  ArrowCodes: array[0..NumCodes-1] of Word =
    (kbLeft, kbRight, kbUp, kbDown, kbHome, kbEnd, kbDel, kbIns,
     kbPgUp, kbPgDn, kbBack);
var
  I: Integer;
begin
  CtrlToArrow := KeyCode;
  for I := 0 to NumCodes - 1 do
    if WordRec(KeyCode).Lo = Byte(CtrlCodes[I]) then
    begin
      CtrlToArrow := ArrowCodes[I];
      Exit;
    end;
end;


{ String formatting routines }

{****************************************************************************}
{ PrintStr                                                                   }
{****************************************************************************}
procedure PrintStr(const S: String); assembler;
asm
	PUSH	DS
        LDS	SI,S
	CLD
	LODSB
	XOR	AH,AH
        XCHG	AX,CX
        MOV	AH,40H
        MOV	BX,1
        MOV	DX,SI
        INT	21H
        POP	DS
end;


{ Buffer move routines }

{****************************************************************************}
{ MoveBuf                                                                    }
{****************************************************************************}
procedure MoveBuf(var Dest; var Source; Attr: Byte; Count: Word); assembler;
asm
	MOV	CX,Count
	JCXZ	@@5
	MOV	DX,DS
	LES	DI,Dest
	LDS	SI,Source
	MOV	AH,Attr
	CLD
	OR	AH,AH
	JE	@@3
@@1:	LODSB
	STOSW
	LOOP	@@1
	JMP	@@4
@@2:	INC	DI
@@3:	MOVSB
	LOOP	@@2
@@4:	MOV	DS,DX
@@5:
end;

{****************************************************************************}
{ MoveChar                                                                   }
{****************************************************************************}
procedure MoveChar(var Dest; C: Char; Attr: Byte; Count: Word); assembler;
asm
	MOV	CX,Count
	JCXZ	@@4
	LES	DI,Dest
	MOV	AL,C
	MOV	AH,Attr
	CLD
	OR	AL,AL
	JE	@@1
	OR	AH,AH
	JE	@@3
	REP	STOSW
	JMP	@@4
@@1:	MOV	AL,AH
@@2:	INC	DI
@@3:	STOSB
	LOOP	@@2
@@4:
end;

{****************************************************************************}
{ MoveCStr                                                                   }
{****************************************************************************}
procedure MoveCStr(var Dest; const Str: String; Attrs: Word); assembler;
asm
	MOV	DX,DS
	LDS	SI,Str
	CLD
	LODSB
	MOV	CL,AL
	XOR	CH,CH
	JCXZ	@@3
	LES	DI,Dest
	MOV	BX,Attrs
	MOV	AH,BL
@@1:	LODSB
	CMP	AL,'~'
	JE	@@2
	STOSW
	LOOP	@@1
	JMP	@@3
@@2:	XCHG	AH,BH
	LOOP	@@1
@@3:	MOV	DS,DX
end;

{****************************************************************************}
{ MoveStr                                                                    }
{****************************************************************************}
procedure MoveStr(var Dest; const Str: String; Attr: Byte); assembler;
asm
	MOV	DX,DS
	LDS	SI,Str
	CLD
	LODSB
	MOV	CL,AL
	XOR	CH,CH
	JCXZ	@@4
	LES	DI,Dest
	MOV	AH,Attr
	OR	AH,AH
	JE	@@3
@@1:	LODSB
	STOSW
	LOOP	@@1
	JMP	@@4
@@2:	INC	DI
@@3:	MOVSB
	LOOP	@@2
@@4:	MOV	DS,DX
end;

{****************************************************************************}
{ CStrLen                                                                    }
{****************************************************************************}
function CStrLen(const S: String): Integer; assembler;
asm
	LES	DI,S
	MOV	CL,ES:[DI]
	INC	DI
	XOR	CH,CH
	MOV	BX,CX
        JCXZ    @@2
	MOV	AL,'~'
        CLD
@@1:	REPNE	SCASB
	JNE	@@2
	DEC	BX
	JMP	@@1
@@2:	MOV	AX,BX
end;

{$L FORMAT.OBJ}
{$L FORMATEX.OBJ}

{****************************************************************************}
{ FormatStr                                                                  }
{****************************************************************************}
procedure FormatStr(var Dest: String; const Format: String;
  var Params); external;

{****************************************************************************}
{ FormatStrExt                                                               }
{****************************************************************************}
procedure FormatStrExt(Dest: PChar; const Format: String;
  var Params); external;
{ Extended version of the FormatStr procedure. The followings have been
  added:

  - Result is put into a C style string, to allow longer strings to be used.
  - %z format specifier: to insert a Zero-terminated (C style) string. }

end.
