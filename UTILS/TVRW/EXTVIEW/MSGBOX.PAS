{**************************************************************************}
{*  BitSoft Development, L.L.C.                                           *}
{*  Turbo Vision Resource WorkShop Custom Controls Support Unit           *}
{*                                                                        *}
{*  Redirects MsgBox calls to TVRW, so that you use these functions.      *}
{*                                                                        *}
{*  Turbo Vision Resource Workshop                                        *}
{*  Copyright (C) 1995-1996 Balazs Scheidler                              *}
{*  Portions Copyright (C) 1995, 1996 BitSoft Developmet, L.L.C.          *}
{*  All rights reserved.                                                  *}
{**************************************************************************}

unit MsgBox;

interface

uses
  Objects;

const
{ Message box classes }

  mfWarning      = $0000;       { Display a Warning box }
  mfError        = $0001;       { Dispaly a Error box }
  mfInformation  = $0002;       { Display an Information Box }
  mfConfirmation = $0003;       { Display a Confirmation Box }

  mfInsertInApp  = $0080;       { Insert message box into application }
                                { instead of the Desktop }

{ Message box button flags }

  mfYesButton    = $0100;       { Put a Yes button into the dialog }
  mfNoButton     = $0200;       { Put a No button into the dialog }
  mfOKButton     = $0400;       { Put an OK button into the dialog }
  mfCancelButton = $0800;       { Put a Cancel button into the dialog }

  mfYesNoCancel  = mfYesButton + mfNoButton + mfCancelButton;
                                { Standard Yes, No, Cancel dialog }
  mfOKCancel     = mfOKButton + mfCancelButton;
                                { Standard OK, Cancel dialog }

function MessageBox(const S: String; Params: Pointer; Flags: Word): Word;
function MessageBoxRect(var R: TRect; Msg: String; Params: Pointer; AOptions: Word): Word;

implementation

uses
  ExpView;

{****************************************************************************}
{**                     EXPORTED FUNCTIONS AND PROCEDURES                  **}
{****************************************************************************}
{****************************************************************************}
{ MessageBox                                                                 }
{****************************************************************************}
function MessageBox(const S: String; Params: Pointer; Flags: Word): Word;
begin
  if Assigned(DoMessageBox) then
    DoMessageBox(S, Params, Flags);
end;

{****************************************************************************}
{ MessageBoxRect                                                             }
{****************************************************************************}
function MessageBoxRect(var R: TRect; Msg: String; Params: Pointer;
  AOptions: Word): Word;
begin
  if Assigned(DoMessageBoxRect) then
    DoMessageBoxRect(R, Msg, Params, AOptions);
end;

end.
