/**************************************************************************
  SOURCE.CPP, MyApp Main module

  Copyright (C) 1996 BitSoft Development, L.L.C.

  Generated by Turbo Vision Resource WorkShop
***************************************************************************/

#define Uses_TApplication
#define Uses_TKeys
#define Uses_TRect
#define Uses_TMenuBar
#define Uses_TSubMenu
#define Uses_TMenuItem
#define Uses_TStatusLine
#define Uses_TStatusItem
#define Uses_TStatusDef
#define Uses_TDeskTop
#define Uses_TButton
#define Uses_TLabel
#define Uses_TStaticText
#define Uses_TParamText
#define Uses_TMemo
#define Uses_TListBox
#define Uses_TSItems
#define Uses_TSortedListBox
#define Uses_TScrollBar
#define Uses_THistory
#define Uses_TInputLine
#define Uses_TCheckBoxes
#define Uses_TRadioButtons
#define Uses_TSItem
#define Uses_TMultiCheckBoxes
#define Uses_TPXPictureValidator
#define Uses_TStringCollection
#define Uses_TStringLookupValidator
#define Uses_TRangeValidator
#define Uses_TDialog

#include <tvision\tv.h>

#include "types.h"
#include "menu.cpp"
#include "status.cpp"
#include "about.cpp"


// application definition...
class TMyApp : public TApplication
{

public:
	 TMyApp();
	 virtual ~TMyApp();
	 virtual void handleEvent(TEvent &);
	 static TStatusLine *initStatusLine( TRect r );
	 static TMenuBar *initMenuBar( TRect r );
};

// application constructor
TMyApp::TMyApp() :
	 TProgInit(&TMyApp::initStatusLine,
         &TMyApp::initMenuBar,
         &TMyApp::initDeskTop)
{
}

// application destructor
TMyApp::~TMyApp()
{
}

void TMyApp::handleEvent(TEvent &event)
{
    TApplication::handleEvent(event);
    switch (event.what) {
		case evCommand: {
			switch (event.message.command) {
				case cmAbout: {
					TDialog *dlg=makeAboutBox();
					deskTop->execView(dlg);
					clearEvent( event );
					break;
				}
			}
		}
	 }
}

TStatusLine *TMyApp::initStatusLine(TRect r)
{
    return makeSampleStatus();
}

TMenuBar *TMyApp::initMenuBar( TRect r )
{
	 return makeSampleMenu();
}

int main()
{
	 TMyApp MyApp;
	 if(MyApp.valid(cmValid))
		  MyApp.run();
	 MyApp.shutDown();
	 return 0;
}
