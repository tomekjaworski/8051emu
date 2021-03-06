/*************************************************************************
   AboutBox Make function.
   ABOUT.CPP

   Copyright (C) 1996 BitSoft Development, L.L.C.

   Generated by Turbo Vision Resource WorkShop
**************************************************************************/

#include "ABOUT.H"
#include "types.h"

TDialog *makeAboutBox(void)
{
    TView *Control, *Crnt, *Peer;
    TRect r;
    TScrollBar *SB1, *SB2;
    TStringCollection *strs;

    r = TRect(20, 5, 59, 18);
    TDialog *dlg = new TDialog(r, "About...");

    dlg->options = dlg->options | (ofCenterX+ofCenterY);
    r = TRect(14, 10, 24, 12);
    Crnt = new TButton(r, "O~k~", cmOK, bfDefault);
    Crnt->helpCtx = hcAboutBox;
    Crnt->options = Crnt->options | (ofCenterX);
    Crnt->state = Crnt->state | (sfActive+sfSelected+sfFocused+sfExposed);
    Crnt->dragMode = Crnt->dragMode & ~(dmLimitLoY);
    dlg->insert(Crnt);
    r = TRect(10, 2, 29, 3);
    Control = new TStaticText(r, "Sample Application");
    Control->options = Control->options | (ofCenterX);
    Control->state = Control->state | (sfActive+sfSelected+sfFocused+sfExposed);
    Control->dragMode = Control->dragMode & ~(dmLimitLoY) | (dmLimitHiX);
    dlg->insert(Control);
    r = TRect(12, 4, 27, 5);
    Control = new TStaticText(r, "Created using");
    Control->state = Control->state | (sfActive+sfSelected+sfFocused+sfExposed);
    Control->dragMode = Control->dragMode & ~(dmLimitLoY) | (dmLimitHiY);
    dlg->insert(Control);
    r = TRect(4, 5, 35, 6);
    Control = new TStaticText(r, "Turbo Vision Resource Workshop");
    Control->options = Control->options | (ofCenterX);
    Control->state = Control->state | (sfActive+sfSelected+sfFocused+sfExposed);
    Control->dragMode = Control->dragMode & ~(dmLimitLoY) | (dmLimitHiX);
    dlg->insert(Control);
    r = TRect(10, 7, 29, 8);
    Control = new TStaticText(r, "Copyright (C) 1996");
    Control->options = Control->options | (ofCenterX);
    Control->state = Control->state | (sfActive+sfSelected+sfFocused+sfExposed);
    Control->dragMode = Control->dragMode & ~(dmLimitLoY) | (dmLimitHiX);
    dlg->insert(Control);
    r = TRect(5, 8, 33, 9);
    Control = new TStaticText(r, "BitSoft Development, L.L.C.");
    Control->options = Control->options | (ofCenterX);
    Control->state = Control->state | (sfActive+sfSelected+sfFocused+sfExposed);
    Control->dragMode = Control->dragMode & ~(dmLimitLoY) | (dmLimitHiX);
    dlg->insert(Control);

    Crnt->select();
    return dlg;
}


