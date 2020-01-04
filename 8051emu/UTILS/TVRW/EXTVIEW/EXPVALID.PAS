{**************************************************************************}
{*  BitSoft Development, L.L.C.                                           *}
{*  Turbo Vision Resource WorkShop Demonstration DLL                      *}
{*                                                                        *}
{*  Turbo Vision Resource Workshop                                        *}
{*  Copyright (C) 1995-1996 Balazs Scheidler                              *}
{*  Portions Copyright (C) 1995, 1996 BitSoft Developmet, L.L.C.          *}
{*  All rights reserved.                                                  *}
{**************************************************************************}

unit ExpValid;

{$IFNDEF DPMI}
   'This unit requires to be compiled for the DPMI plataform...'
{$ENDIF}

interface

uses
  Objects, MsgBox;

const
  cmIsValidable		= 2072;
  cmGetValidator	= 2073;
  cmSetValidator	= 2074;

type
  PValidData = ^TValidData;
  TValidData = record
    Size: Word;
    Id: String[30];
    TypeId: String[30];
    Description: String[50];
    ObjType: Word;
    PrefixStr: String[30];
  end;

  PExtValidator = ^TExtValidator;
  TExtValidator = record
    VMTLink: Word;
    Status: Word;
    Options: Word;
  end;

  PValidator = ^TValidator;
  TValidator = Object(TObject)
    RemoteSelf: PExtValidator;
    constructor Init(ARemoteSelf: PExtValidator);
    constructor Load(ARemoteSelf: PExtValidator; var S: TStream);
    destructor Done; virtual;
    procedure Store(var S: TStream); virtual;
    function IsValid(const S: String): Boolean; virtual;
    function IsValidInput(var S: string; SuppressFill: Boolean): Boolean; virtual;
    function Valid(const S: string): Boolean; virtual;
    procedure Error; virtual;
  end;

procedure ValidDone(Self: PValidator); export;
procedure ValidStore(Self: PValidator; MemBlock: Pointer; var MaxLen: Word); export;
function ValidIsValid(Self: PValidator; const S: String): Boolean; export;
function ValidIsValidInput(Self: PValidator; var S: String; SuppressFill: Boolean): Boolean; export;
function ValidValid(Self: PValidator; const S: String): Boolean; export;

implementation

uses
  TinyStrm;

{****************************************************************************}
{ TValidator object                                                          }
{****************************************************************************}
{****************************************************************************}
{ TValidator.Init                                                            }
{****************************************************************************}
constructor TValidator.Init(ARemoteSelf: PExtValidator);
begin
  inherited Init;
  RemoteSelf := ARemoteSelf;
end;

{****************************************************************************}
{ TValidator.Done                                                            }
{****************************************************************************}
destructor TValidator.Done;
begin
end;

{****************************************************************************}
{ TValidator.Load                                                            }
{****************************************************************************}
constructor TValidator.Load(ARemoteSelf: PExtValidator; var S: TStream);
begin
  inherited Init;
  RemoteSelf := ARemoteSelf;
end;

{****************************************************************************}
{ TValidator.Store                                                           }
{****************************************************************************}
procedure TValidator.Store(var S: TStream);
begin
end;

{****************************************************************************}
{ TValidator.IsValid                                                         }
{****************************************************************************}
function TValidator.IsValid(const S: String): Boolean;
begin
  IsValid := True;
end;

{****************************************************************************}
{ TValidator.IsValidInput                                                    }
{****************************************************************************}
function TValidator.IsValidInput(var S: string; SuppressFill: Boolean):
  Boolean;
begin
  IsValidInput := True;
end;

{****************************************************************************}
{ TValidator.Valid                                                           }
{****************************************************************************}
function TValidator.Valid(const S: string): Boolean;
begin
  if IsValid(S) then
    Valid := True
   else begin
    Error;
    Valid := False;
  end;
end;

{****************************************************************************}
{ TValidator.Error                                                           }
{****************************************************************************}
procedure TValidator.Error;
begin
end;

{****************************************************************************}
{**                     EXPORTED FUNCTIONS AND PROCEDURES                  **}
{****************************************************************************}
{****************************************************************************}
{ ValidDone                                                                  }
{****************************************************************************}
procedure ValidDone(Self: PValidator);
begin
  Self^.Done;
end;

{****************************************************************************}
{ ValidStore                                                                 }
{****************************************************************************}
procedure ValidStore(Self: PValidator; MemBlock: Pointer; var MaxLen: Word);
var
  S: PStream;
begin
  S := New(PTinyStream, Init(MemBlock, MaxLen));
  Self^.Store(S^);
  MaxLen := S^.GetPos;
  Dispose(S, Done);
end;

{****************************************************************************}
{ ValidIsValid                                                               }
{****************************************************************************}
function ValidIsValid(Self: PValidator; const S: String): Boolean;
begin
  ValidIsValid := Self^.IsValid(S);
end;

{****************************************************************************}
{ ValidIsValidInput                                                          }
{****************************************************************************}
function ValidIsValidInput(Self: PValidator; var S: String;
  SuppressFill: Boolean): Boolean;
begin
  ValidIsValidInput := Self^.IsValidInput(S, SuppressFill);
end;

{****************************************************************************}
{ ValidValid                                                                 }
{****************************************************************************}
function ValidValid(Self: PValidator; const S: String): Boolean;
begin
  ValidValid := Self^.Valid(S);
end;

end.
