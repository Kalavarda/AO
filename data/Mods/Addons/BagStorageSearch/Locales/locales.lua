Global("locales", {})
local ToWString = userMods.ToWString

--------------------------------------------------------------------------------
-- Russian
--------------------------------------------------------------------------------

locales["rus"]={}
locales["rus"]["search"]="Поиск"

--------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------
		
locales["eng_eu"]={}
locales["eng_eu"]["search"]="Search"

-- put locales used by client
locales = locales[common.GetLocalization()] or locales["eng_eu"]

locales["secondsToBlink"] = 7 -- sets how long are found items supposed to blink