program Screen_demo;

uses msgbox,objects,menus,drivers,extrascr,views,app;

const
  cmChangeMode = 300;
  hcSelectAModeDialog = 1000;
  hcProgramerInfo = 1001;

type
  TMyApp = object(TScrApplication)
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure HandleEvent(var Event:TEvent); virtual;
    procedure HandleScreenError; virtual;
  end;
  PMyStatusLine = ^TMyStatusLine;
  TMyStatusLine = object(TStatusLine)
    function Hint(AHelpCtx: Word): String; virtual;
  end;

var
  MyApp:TMyApp;

procedure TMyApp.HandleScreenError;
begin
  case CfgError of
    CfgFileNotFound:
        begin
          MessageBox('The Driver-File was not found!',
             nil, mfError or mfOkButton);
        end;
    CfgFileError:
        begin
          MessageBox('The Driver-File is not build correctly!',
             nil, mfError or mfOkButton);
        end;
    CfgWrongVersion:
        begin
          MessageBox('Wrong Version of Driver-File!',
             nil, mfError or mfOkButton);
        end;
  end;
end;

procedure TMyApp.HandleEvent(var Event:TEvent);
begin
  TApplication.HandleEvent(Event);
  if Event.What=evCommand then begin
    case Event.Command of
      cmChangeMode: begin
        SelectAMode;
      end;
      else exit;
    end;
    ClearEvent(Event);
  end;
end;

procedure TMyApp.InitMenuBar;
var
  R:TRect;
begin
  GetExtent(R);
  R.B.Y:=R.A.Y+1;
  MenuBar:=New( PMenuBar, Init(R, NewMenu(
    NewSubMenu('~T~est',hcNoContext, NewMenu(
      NewItem('~C~hange Mode', '', kbNoKey, cmChangeMode, hcNoContext,
      NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil))),
    nil)
  )));
end;

function TMyStatusLine.Hint(AHelpCtx: Word): String;
begin
  case AHelpCtx of
    hcSelectAModeDialog: Hint:='This is the hint-text of SelectAMode';
    hcProgramerInfo: Hint:='Extrascr ver 1.00';
    else Hint:='No Hint';
  end;
end;

procedure TMyApp.InitStatusLine;
var
  R:TRect;
begin
  GetExtent(R);
  R.A.Y:=R.B.Y-1;
  StatusLine:=New(PMyStatusLine, Init(R,
    NewStatusDef(0,$FFFF,
       NewStatusKey('~Alt-X~ Exit',kbAltx,cmquit,
    nil),
  nil)));
  
end;

begin
  MyApp.Init;
  MyApp.SetScrHelpContext(hcSelectAModeDialog, hcProgramerInfo);
  MyApp.Run;
  MyApp.Done;
end.