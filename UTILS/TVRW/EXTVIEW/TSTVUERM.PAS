{**************************************************************************}
{*  BitSoft Development, L.L.C.                                           *}
{*  Turbo Vision Resource WorkShop Resources Test Program                 *}
{*                                                                        *}
{*  Turbo Vision Resource Workshop                                        *}
{*  Copyright (C) 1995-1996 Balazs Scheidler                              *}
{*  Portions Copyright (C) 1995, 1996 BitSoft Developmet, L.L.C.          *}
{*  All rights reserved.                                                  *}
{**************************************************************************}

program TSTVUERM;
{$S-}

uses
  Drivers, Views, Dialogs, App, Objects, StdDlg, Editors, Validate, Menus;

var
  ResFile: PResourceFile;

{****************************************************************************}
{ MakeTestView_MyViewOptDlg                                                  }
{****************************************************************************}
function MakeTestView_MyViewOptDlg: PDialog;
var
  Control, Crnt: PView;
  R: TRect;
  SB1, SB2: PScrollBar;
  Dlg: PDialog;
  Strs: PStringCollection;
  V: PValidator;
begin
  R.Assign(10, 8, 70, 16);
  Dlg := New(PDialog, Init(R, 'Edit TMyView'));
  with Dlg^ do begin
    R.Assign(3, 3, 44, 4);
    Crnt := New(PInputLine, Init(R, 255));
    Insert(Crnt);
    R.Assign(3, 2, 8, 3);
    Insert(New(PLabel, Init(R, '~T~ext', Crnt)));
    R.Assign(47, 2, 57, 4);
    Control := New(PButton, Init(R, 'O~K~', cmOk, bfDefault));
    Insert(Control);
    R.Assign(47, 4, 57, 6);
    Control := New(PButton, Init(R, 'Cancel', cmCancel, bfNormal));
    Insert(Control);
    R.Assign(3, 5, 41, 7);
    Control := New(PStaticText, Init(R, 'This is an example of creating external controls and their settings dialog.'));
    Insert(Control);
    Crnt^.Select;
  end;
  MakeTestView_MyViewOptDlg := PDialog(Dlg);
end;

begin
  RegisterViews;
  RegisterDialogs;
  RegisterApp;
  RegisterObjects;
  RegisterStdDlg;
  RegisterEditors;
  RegisterValidate;
  RegisterMenus;
  RegisterType(RStrListMaker);
  ResFile := New(PResourceFile, Init(New(PBufStream, Init('TESTDLL.RES', stCreate, 4096))));
  with ResFile^ do begin
    Put(MakeTestView_MyViewOptDlg, 'TestView_MyViewOptDlg');
  end;
  Dispose(ResFile, Done);
end.
