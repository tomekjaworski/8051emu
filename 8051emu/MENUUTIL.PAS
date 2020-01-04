unit MenuUtil;
interface
uses Menus;

Function FindMenuByID(ID:Word; Menu:PMenu):PMenuItem;

implementation

Function FindMenuByID(ID:Word; Menu:PMenu):PMenuItem;
var Wyn:PMenuItem;
    Element:PMenuItem;
begin
     Wyn := nil;
     FindMenuByID := nil;
     Element := Menu^.Items;

     while Element <> nil do
     begin
          if (Element^.Command = 0) and (Element^.Name <> nil) then {SubMenu}
          begin
               wyn := FindMenuByID(ID, Element^.SubMenu);
               if wyn <> nil then
               begin
                    FindMenuByID := Wyn;
                    exit;
               end;
          end else
          if Element^.Command = ID then
          begin
               FindMenuByID := Element;
               Exit;
          end;
          Element := Element^.Next;
     end;
end;

end.
