---------------------------------------------------------------------------------------------------
-- Locales
---------------------------------------------------------------------------------------------------
local locales = {
  rus = { -- Russian, Win-1251
    [ "AutoMountFeed" ] = "AutoMountFeed",
    [ "Select All" ] = "Выделить все",
    [ "UnSelect All" ] = "Снять выделение",
    [ "Save" ] = "Сохранить",
    [ "Name" ] = "Имя",
    ["Description"] = "Кормит активного маунта",
    [ "Settings" ] = "Параметры",
  },
  eng = { -- English, Latin-1
    [ "AutoMountFeed" ] = "AutoMountFeed",
    [ "Select All" ] = "Select All",
    [ "UnSelect All" ] = "UnSelect All",
    [ "Save" ] = "Save",
    [ "Name" ] = "Name",
    ["Description"] = "Feeds the active mount",
    [ "Settings" ] = "Settings",
  },
  ger = { -- German, Win-1252
    [ "AutoMountFeed" ] = "AutoMountFeed",
    [ "Select All" ] = "Alle ausw\228hlen",
    [ "UnSelect All" ] = "Keines ausw\228hlen",
    [ "Save" ] = "Speichern",
    [ "Name" ] = "Name",
    ["Description"] = "F\252ttert das aktive Reittier",
    [ "Settings" ] = "Einstellungen",
  },
fra = { -- French, Win-1252
     [ "AutoMountFeed" ]  = "AutoMountFeed",
     [ "Select All" ]  = "S\233lectionner tout",
     [ "UnSelect All" ]  = "D\233s\233lectionner tout",
     [ "Save" ]  = "Enregistrer",
     [ "Name" ]  = "Nom",
     ["Description"]  = "Nourrir la monture active",
     [ "Settings" ]  = "Options",
  },
  br = {  -- Portuguese, Win-1252
    [ "AutoMountFeed" ] = "AutoMountFeed",
    [ "Select All" ] = "Select All",
    [ "UnSelect All" ] = "UnSelect All",
    [ "Save" ] = "Save",
    [ "Name" ] = "Name",
    ["Description"] = "Feeds the active mount",
    [ "Settings" ] = "Settings",
  },
  jpn = {  -- Japanese, Shift-JIS
    [ "AutoMountFeed" ] = "AutoMountFeed",
    [ "Select All" ] = "Select All",
    [ "UnSelect All" ] = "UnSelect All",
    [ "Save" ] = "Save",
    [ "Name" ] = "Name",
    ["Description"] = "Feeds the active mount",
    [ "Settings" ] = "Settings",
  }
}

Global( "L", locales[ "eng" ] )
---------------------------------------------------------------------------------------------------
-- AO game Localization detection by SLA. Version 2011-02-10.
---------------------------------------------------------------------------------------------------
function GetGameLocalization()
  local B = cartographer.GetMapBlocks()
  local T = {
      rus="\203\232\227\224",
      eng="Holy Land",
      ger="Heiliges Land",
      fra="Terre Sacr\233e",
      br="Terra Sagrada",
      jpn="\131\74\131\106\131\65"
    }
  for b in pairs(B) do
    for l,t in pairs(T) do
      if userMods.FromWString( cartographer.GetMapBlockInfo(B [b] ).name ) == t
        then return l
      end
    end
  end
  return "eng"
end
---------------------------------------------------------------------------------------------------
function InitLocalText( lang )
   L = locales[ lang or "eng" ]
end


 
