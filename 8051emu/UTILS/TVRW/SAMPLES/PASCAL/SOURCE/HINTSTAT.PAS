{**************************************************************************
  HintStat.pas, Status Line object with Hints

  Copyright (C) 1996, BitSoft Development, L.L.C.

  This unit implementes a TStatusLine descendants that displays hints
  from a string list.  It was implemented in a separate unit so that you
  can easily re-generate other files from Turbo Vision Resource Workshop
  without having to add again the object definition to one of those
  files.
***************************************************************************}

unit HintStat;

interface

uses
  Drivers, Objects, Views, Dialogs, Menus, Validate, App,
  Types;

var
  { Add a pointer to the string table to be used as hints }
  Hints : PStringList;

type
  { New Status Line object for displaying hints from a string list. }
  PHintStatusLine = ^THintStatusLine;
  THintStatusLine = object(TStatusLine)
    function Hint(AHelpCtx: Word): string; virtual;
  end;

implementation

function THintStatusLine.Hint(AHelpCtx : Word) : string;
var
  AHint : string;
begin
  if AHelpCtx > hcAboutBox then
    begin
      AHint := Hints^.Get(AHelpCtx);
      if AHint = '' then
        Hint := 'Press F1 for more information'
      else
        Hint := AHint;
    end
  else
    Hint := '';
end;

end.