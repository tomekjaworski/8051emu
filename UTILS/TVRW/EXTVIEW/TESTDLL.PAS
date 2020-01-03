{**************************************************************************}
{*  BitSoft Development, L.L.C.                                           *}
{*  Turbo Vision Resource WorkShop Demonstration DLL                      *}
{*                                                                        *}
{*  Turbo Vision Resource Workshop                                        *}
{*  Copyright (C) 1995-1996 Balazs Scheidler                              *}
{*  Portions Copyright (C) 1995, 1996 BitSoft Developmet, L.L.C.          *}
{*  All rights reserved.                                                  *}
{**************************************************************************}

library TestView;
{$R+,I-}

{$D TVRW Sample Custom Control DLL.}

uses
  Objects, TinyStrm, TxtStrm, DrvUtils, ExpView, ExpValid, MsgBox;

type
  { Used as the Transfer structure of the MyView Settings dialog }
  TMyViewData = record
    Str: String;
  end;

type
  PMyView = ^TMyView;
  TMyView = Object(TView)
    Str: PString;
    Color: Byte;
    Link: PExtView;
    { Validating will not work in the editor, but the sourcer will
      generate the appropriate code, and the data necessery for the
      validator is written to the stream... }
    Validator: Pointer;
    { The only difference in Init and Load is the ARemoteSelf parameter.
      You don't need to bother with this variable, just pass it to the
      inherited method. }
    constructor Init(ARemoteSelf: PExtView; var Bounds: TRect);
    constructor Load(ARemoteSelf: PExtView; var S: TStream);
    procedure Store(var S: TStream);
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure Draw; virtual;
  end;

{****************************************************************************}
{ TMyView object                                                             }
{****************************************************************************}
{****************************************************************************}
{ TMyView.Init                                                               }
{****************************************************************************}
constructor TMyView.Init(ARemoteSelf: PExtView; var Bounds: TRect);
begin
  Bounds.Assign(Bounds.A.X, Bounds.A.Y, Bounds.A.X + 45, Bounds.A.Y + 7);
  inherited Init(ARemoteSelf, Bounds);
  Str := NewStr('This is written from TESTVIEW.DLL');
  Color := 1;
end;

{****************************************************************************}
{ TMyView.Load                                                               }
{****************************************************************************}
constructor TMyView.Load(ARemoteSelf: PExtView; var S: TStream);
begin
  inherited Load(ARemoteSelf, S);
(*
  GetPeerViewPtr(S, Link);
  Str := S.ReadStr;
  Color := 1;
  LoadValidator(S);
  if RemoteSelf^.Options and ofViewExtensions <> 0 then begin
    { Read the data you wrote the similar section in store }
  end;
*)
end;

{****************************************************************************}
{ TMyView.Store                                                              }
{****************************************************************************}
procedure TMyView.Store(var S: TStream);
begin
  inherited Store(S);
(*
  PutPeerViewPtr(S, Link);
  S.WriteStr(Str);
  StoreValidator(S);
  if RemoteSelf^.Options and ofViewExtensions <> 0 then begin
    { If you add some data to your object that is not normally stored by
      your object.... Such an extension would be for instance the
      string representation of HelpCtx }
  end;
  { if you want to store a validator, do not use S.Put, instead
    use StoreValidator }
*)
end;

{****************************************************************************}
{ TMyView.HandleEvent                                                        }
{****************************************************************************}
procedure TMyView.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  case Event.What of
    evBroadCast:
      case Event.Command of
        cmIsValidable: ClearEvent(Event);
        cmSetValidator:
          begin
            Validator := Event.InfoPtr;
            ClearEvent(Event);
          end;
        cmGetValidator:
          begin
            Event.What := evNothing;
            Event.InfoPtr := Validator;
          end;
        cmIsLinkableTo:
          if Event.InfoPtr <> nil then begin
            { This view can be linked to an Inputline }
            if PString(Event.InfoPtr)^ = 'TInputLine' then ClearEvent(Event);
          end;
        cmSetLinkedView:
          begin
            Link := Event.InfoPtr;
            DrawView;
            ClearEvent(Event);
          end;
        cmGetLinkName:
          if Event.InfoPtr <> nil then begin
            if Str <> nil then
              PString(Event.InfoPtr)^ := '(TMyView)'
             else
              PString(Event.InfoPtr)^ := '';
            ClearEvent(Event);
          end;
      end;
    evMouseDown:
      begin
        if Event.Buttons = mbLeftButton then
          Inc(Color)
         else
          Dec(Color);
        if Event.Double then Color := 1;
        DrawView;
        ClearEvent(Event);
      end;
  end;
end;

{****************************************************************************}
{ TMyView.Draw                                                               }
{****************************************************************************}
procedure TMyView.Draw;
var
  B: TDrawBuffer;
begin
  inherited Draw;
  if Str <> nil then begin
    MoveStr(B, Str^, GetColor(Color));
    WriteLine((Size.X - Length(Str^)) shr 1, Size.Y shr 1, Length(Str^), 1, B);
  end;
  if Link <> nil then begin
    WriteStr(1, 1, 'Linked.', Color);
   end
   else
    WriteStr(1, 1, 'Not linked.', Color);
end;

{****************************************************************************}
{ MyView_Allocate                                                            }
{****************************************************************************}
function MyView_Allocate: Pointer; export;
{ Allocate function. Such function is needed for all exported controls }
begin
  MyView_Allocate := New(PMyView);
end;

{****************************************************************************}
{ MyView_Free                                                                }
{****************************************************************************}
procedure MyView_Free(P: PMyView); export;
{ Free function. TVRW will care about calling first MyView_Done and then
  MyView_Free, so DO NOT use Dispose(P, Done) here. The same applies to the
  allocate function. }
begin
  Dispose(P);
end;

{****************************************************************************}
{ MyView_Init                                                                }
{****************************************************************************}
function MyView_Init(Self: PMyView; RemoteSelf: PExtView; var
  Bounds: TRect): Boolean; export;
begin
  MyView_Init := Self^.Init(RemoteSelf, Bounds);
end;

{****************************************************************************}
{ MyView_Done                                                                }
{****************************************************************************}
procedure MyView_Done(Self: PMyView); export;
begin
  Self^.Done;
end;

{****************************************************************************}
{ MyView_Load                                                                }
{****************************************************************************}
function MyView_Load(Self: PMyView; RemoteSelf: PExtView; MemBlock: Pointer;
  Len: Word): Boolean; export;
var
  S: PStream;
begin
  S := New(PTinyStream, Init(MemBlock, Len));
  MyView_Load := Self^.Load(RemoteSelf, S^);
  Dispose(S, Done);
end;

{****************************************************************************}
{ MyView_Store                                                               }
{****************************************************************************}
procedure MyView_Store(Self: PMyView; MemBlock: Pointer; MaxLen: Word;
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
{ MyView_CtrlToData                                                          }
{****************************************************************************}
procedure MyView_CtrlToData(Self: PMyView; Consts: PCollection;
  var Rec: TMyViewData); export;
{ This procedure is used to build the Transfer structure of the settings
  dialog.  TMyView has only one field. }
begin
  if Self^.Str <> nil then Rec.Str := Self^.Str^ else Rec.Str := '';
end;

{****************************************************************************}
{ MyView_DataToCtrl                                                          }
{****************************************************************************}
procedure MyView_DataToCtrl(Self: PMyView; var Rec: TMyViewData); export;
{ The opposite of the above.  The consts parameter is used, when you use the
  Constant inputline feature of Turbo Vision Resource WorkShop. Just pass the
  Consts parameter in the transfer record. }
begin
  DisposeStr(Self^.Str);
  Self^.Str := NewStr(Rec.Str);
end;

{****************************************************************************}
{ MyView_WriteSource                                                         }
{****************************************************************************}
procedure MyView_WriteSource(Self: PMyView; Lang: Word; ClassName, VarName,
  LinkTo: PChar; MemBlock: PChar; MemSize: Word); export;
{ This is the sourcer procedure. }
var
  Out: PTxtStream;
  Params: array [1..5] of Pointer;
const
  NilStr: array [0..4] of Char = 'nil';
  NullStr: array [0..5] of Char = 'NULL';
begin
  Out := New(PTxtStream, Init(New(PTinyStream, Init(MemBlock, MemSize))));
  { At this time the necessary variables had been set up, so we need to
    output only the init statement.  TVRW will care about the options,
    eventmask and state flags.

    You should follow these few rules to produce the correct output:

    - To indent to the following tab-stop insert a tab #9 character.
    - To insert a newline simply insert a #13 character. You don't need
      to care about the indentation in the next line.
    - The size of the memory block should be about 16384 bytes.  This
      should be enough for most views. }

  Params[1] := VarName;
  Params[2] := ClassName;
  Params[3] := Self^.Str;
  case Lang of
    lnPascal:
      begin
        if (LinkTo = nil) or (LinkTo^ = #0)  then Params[4] := @NilStr else Params[4] := LinkTo;
        Out^.WrParamText('%z := New(P%z, Init(R, ''%s'', PInputLine(%z)));'#13, Params);
      end;
    lnCPlusPlus:
      begin
        if (LinkTo = nil) or (LinkTo^ = #0) then Params[4] := @NullStr else Params[4] := LinkTo;
        Out^.WrParamText('%z = new T%z(r, "%s", (TInputLine *) %z);'#13, Params);
      end;
  end;
  Out^.WrChar(#0, 1);
  Dispose(Out, Done);
end;

{****************************************************************************}
{ MyView_WriteTransferFields                                                 }
{****************************************************************************}
procedure MyView_WriteTransferFields(Self: PMyView; Lang, TabNum: Word;
  MemBlock: PChar; MemSize: Word); export;
var
  Out: PTxtStream;
  Params: array [1..1] of Longint;
begin
  Out := New(PTxtStream, Init(New(PTinyStream, Init(MemBlock, MemSize))));
  Params[1] := TabNum;
  case Lang of
    lnPascal:
      begin
        Out^.WrParamText('{ object TMyView has no parameters. Tab #%d }'#13,
          Params);
      end;
    lnCPlusPlus:
      begin
        Out^.WrParamText('/* class TMyView has no parameters. Tab #%d */'#13,
          Params);
      end;
  end;
  Out^.WrChar(#0, 1);
  Dispose(Out, Done);
end;

const
  { Data structure used when communicating with TVRW. }
  DMyView: TControlData =
    (Size: SizeOf(TControlData);
     Id: 'TestDLL_MyView';  { Has to be unique among all external controls, }
                            { that's why we included the DLL name and the   }
                            { class name here.                              }
     TypeId: 'MyView';
     Description: 'Blue Textbox';
     ObjType: 20000;
     PrefixStr: 'MYVIEW');

const
  ExportedControls: array [1..2] of PControlData =
    (@DMyView, nil);

var
  CurrCtrl: Integer;

{****************************************************************************}
{ CtrlFindFirst                                                              }
{****************************************************************************}
function CtrlFindFirst: PControlData; export;
{ Findfirst function. Resets search and returns the first available control }
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
  CurrCtrl := CurrCtrl + 1;
end;

{ Validators }

type
  PMyValidator = ^TMyValidator;
  TMyValidator = Object(TValidator)
    function IsValidInput(var S: String; SuppressFill: Boolean): Boolean;
      virtual;
  end;

{****************************************************************************}
{ TMyValidator object                                                        }
{****************************************************************************}
{****************************************************************************}
{ TMyValidator.IsValidInput                                                  }
{****************************************************************************}
function TMyValidator.IsValidInput(var S: String; SuppressFill: Boolean):
  Boolean;
var
  I: Integer;
begin
  for I := 1 to Length(S) do S[I] := UpCase(S[I]);
  IsValidInput := True;
end;

{****************************************************************************}
{ MyValidator_Init                                                           }
{****************************************************************************}
function MyValidator_Init(ARemoteSelf: PExtValidator): Pointer; export;
begin
  MyValidator_Init := New(PMyValidator, Init(ARemoteSelf));
end;

{****************************************************************************}
{ MyValidator_Load                                                           }
{****************************************************************************}
function MyValidator_Load(ARemoteSelf: PExtValidator; MemBlk: Pointer;
  MemLen: Word): Pointer; export;
var
  S: PStream;
begin
  S := New(PTinyStream, Init(MemBlk, MemLen));
  MyValidator_Load := New(PMyValidator, Load(ARemoteSelf, S^));
  Dispose(S, Done);
end;

{****************************************************************************}
{ MyValidator_WriteSource                                                    }
{****************************************************************************}
procedure MyValidator_WriteSource(Self: PValidator; Lang: Word; ClassName,
  VarName, MemBlock: PChar; MemSize: Word); export;
var
  Out: PTxtStream;
  Params: array [1..2] of Pointer;
begin
  Out := New(PTxtStream, Init(New(PTinyStream, Init(MemBlock, MemSize))));
  { At this time the necessary variables had been set up, so we need to
    output only the init statement and the Options := XXXX statement.

    You should follow these few rules to produce the correct output:

    - To indent to the following tab-stop insert a tab #9 character.
    - To insert a newline simply insert a #13 character. You don't need
      to care about the indentation in the next line.
    - The size of the memory block should be about 16384 bytes.  This
      should be enough for most views. }

  Params[1] := VarName;
  Params[2] := ClassName;
  case Lang of
    lnPascal:
      begin
        Out^.WrParamText('%z := New(P%z, Init);'#13, Params);
      end;
    lnCPlusPlus:
      begin
        Out^.WrParamText('%z = new T%z();'#13, Params);
      end;
  end;
  Out^.WrChar(#0, 1);
  Dispose(Out, Done);
end;

{****************************************************************************}
{ MyValidator_WriteTransferFields                                            }
{****************************************************************************}
function MyValidator_WriteTransferFields(Self: PMyView; Lang, TabNum: Word;
  MemBlock: PChar; MemSize: Word): Boolean; export;
var
  Out: PTxtStream;
  Params: array [1..1] of Longint;
begin
  Out := New(PTxtStream, Init(New(PTinyStream, Init(MemBlock, MemSize))));
  Params[1] := TabNum;
  case Lang of
    lnPascal:
      begin
        Out^.WrParamText('{ object TMyValidator has no parameters. '+
          'Tab #%d }'#13, Params);
      end;
    lnCPlusPlus:
      begin
        Out^.WrParamText('/* class TMyValidator has no parameters. '+
          'Tab #%d */'#13, Params);
      end;
  end;
  Out^.WrChar(#0, 1);
  Dispose(Out, Done);
  { Indicate that the transfer fields of the linked inputline should
    be included. You should return true, if you want your own transfer
    handling. }
  MyValidator_WriteTransferFields := False;
end;

const
  DMyValidator: TValidData =
    (Size: SizeOf(TValidData);
     Id: 'TestDLL_MyValidator';
     TypeId: 'MyValidator';
     Description: 'A Validator forcing all characters uppercase';
     ObjType: 20001;
     PrefixStr: 'MYVALIDATOR');

const
  ExportedValidators: array [1..2] of PValidData =
    (@DMyValidator, nil);

var
  CurrValid: Integer;

{****************************************************************************}
{ ValidFindFirst                                                             }
{****************************************************************************}
function ValidFindFirst: PValidData; export;
{ Findfirst function. Resets search and returns the first available
  Validator }
begin
  CurrValid := 2;
  ValidFindFirst := ExportedValidators[1];
end;

{****************************************************************************}
{ ValidFindNext                                                              }
{****************************************************************************}
function ValidFindNext: PValidData; export;
begin
  ValidFindNext := ExportedValidators[CurrValid];
  CurrValid := CurrValid + 1;
end;

{****************************************************************************}
{ InitControlDLL                                                             }
{****************************************************************************}
procedure InitControlDLL(TVRWInstance: Word; var Description: String); export;
{ DLL initialization procedure. TVRW will not accept DLLs without this
  routine. }
begin
  LinkProcedures(TVRWInstance);
  Description := 'Sample Control DLL.';
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
  MessageBox(^C'Sample Control Library'^M+
    ^C'BitSoft Development, L.L.C.'^M+
    ^C'Copyright (C) 1995-1996', nil, mfInformation or mfOKButton);
end;

exports
  MyView_Allocate,
  MyView_Free,
  MyView_Init,
  MyView_Done,
  MyView_Load,
  MyView_Store,
  MyView_CtrlToData,
  MyView_DataToCtrl,
  MyView_WriteSource,
  MyView_WriteTransferFields,
  MyValidator_Init,
  MyValidator_Load,
  MyValidator_WriteSource,
  MyValidator_WriteTransferFields,
  ViewDraw,
  ViewGetPalette,
  ViewHandleEvent,
  ViewSizeLimits,
  ViewValid,
  ViewChangeBounds,
  ViewSetData,
  ViewGetData,
  ViewDataSize,
  ValidDone,
  ValidStore,
  ValidIsValid,
  ValidIsValidInput,
  ValidValid,
  InitControlDLL,
  DoneControlDLL,
  AboutControlDLL,
  CtrlFindFirst,
  CtrlFindNext,
  ValidFindFirst,
  ValidFindNext;

begin
end.
