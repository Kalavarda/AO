local wTip, wTipTxt, wSettingsMenu, wContainer, formattxt
local function tip_init()
	wTip = mainForm:GetChildChecked("dscBorder", true)
	if skin.texture then wTip:SetBackgroundTexture( skin.texture ) end
	if skin.color then wTip:SetBackgroundColor( skin.color ) end
	wTipTxt = mainForm:GetChildChecked("dscText", true)
	wTip:AddChild(wTipTxt) wTipTxt:Show(true)
	wTipTxt:SetMultiline( true )
	wtSetPlace( wTipTxt, { posX=20, highPosX=20, posY=20, highPosY=20, alignX = 3, alignY = 3 } )
	wTipTxt:SetFormat( ToWS("<html alignx='left' aligny='middle' fontname='AllodsWest' fontsize='14' shadow='1' color='0xFFCCCCCC' >".."<r name='value'/><r name='nameVT'/>".."</html>"))
	wTip:SetPriority( 500 )
end

local function settings_init()
	wSettingsMenu = WCD( dsc.Menu, "Settings", nil, { sizeX = 470, sizeY = 400}, false )
	wContainer = WCD( W("ContainerOptions"):GetWidgetDesc(), "Container", wSettingsMenu, {posY = 40, posX = 10, sizeX = 440}, true )
	DnD.Init(wSettingsMenu, wSettingsMenu, true)
	local buttonclose = WCD( dsc.ButtonCornerCross, "closesettings", wSettingsMenu, {}, true )
	local buttonsave = WCD( dsc.Button, "savesettings", wSettingsMenu, {posX = 20, alignY = 1, highPosY = 15, sizeX = 200}, true )
	buttonsave:SetVal("button_label", ToWS(L("Save Settings")))
	formattxt = ToWS("<html alignx='center' fontsize='14' shadow='1'><r name='value'/></html>")
	for k, v in pairs(PS) do
		-- не показываем параметры которые когда-то перестали использоваться
		if k ~= "HullSizeY" then 
			local typ = common.GetApiType(v)
			if typ == "string" then
				local t = {}
				t.key = k
				t.main = WCD( dsc.PanelOptions, k, nil, { sizeX = 420, sizeY = 60, posX = 0}, true )
				t.desc = WCD( dsc.Text, "dsc", t.main, {posY = 10, posX = 0, sizeY = 20, sizeX = 420, highPosX = 0, alignX = WIDGET_ALIGN_BOTH   }, true )
				t.str = WCD( dsc.Text, "srt", t.main, {posY = 35, posX = 0, sizeY = 20, sizeX = 420, highPosX = 0, alignX = WIDGET_ALIGN_BOTH   }, true )
				t.str:SetFormat(formattxt)
				t.desc:SetFormat(formattxt)
				t.str:SetVal("value", v)
				t.desc:SetVal("value", L(k))
				t.buttonlist = WCD( dsc.Button, "list"..k, t.main, { sizeX = 30, sizeY = 30, posX = 120, posY = 30}, true )
				t.buttonlist:SetVal("button_label", ToWS("v"))
				t.list = WCD( dsc.Panel, "List", mainForm, { sizeX = 250, sizeY = 200, posX = 0}, false )
					for k, v in pairs(Targets) do
					local button = WCD( dsc.Button, "trgt"..v, t.list, { sizeX = 200, sizeY = 30, posX = 5, posY = k*30, alignX = 0, alignY = 0}, true )
					button:SetVal("button_label", ToWS(v))
					end
				t.value = function(sss)
					local valText = sss.str:GetValuedText()
					local ws = common.ExtractWStringFromValuedText( valText )
					local strin = FromWS( ws )
					return strin
				end
				wContainer:PushBack( t.main )
				Options[k] = t
			end
			
			if typ == "number" then
				local t = {}
				t.key = k
				t.main = WCD( dsc.PanelOptions, k, nil, { sizeX = 420, sizeY = 60, posX = 0}, true )
				t.desc = WCD( dsc.Text, "dsc", t.main, {posY = 10, posX = 0, sizeY = 20, sizeX = 420, alignX = 4 }, true )
				t.str = WCD( dsc.EditLineNum, "srt", t.main, {posY = 25, alignX = 2, sizeX = 60, posX = 20}, true )
				t.desc:SetFormat(formattxt)
				t.desc:SetVal("value", L(k))
				t.str:SetText(ToWS(tostring(v)))
				t.value = function(sss)
					local str = sss.str:GetString()
					local num = tonumber(str)
					return num
				end
				
				wContainer:PushBack( t.main )
				Options[k] = t
			end
			
			if typ == "boolean" then
				local t = {}
				t.key = k
				t.main = WCD( dsc.PanelOptions, k, nil, { sizeX = 420, sizeY = 60, posX = 0}, true )
				t.desc = WCD( dsc.Text, "dsc", t.main, {posY = 10, posX = 0, sizeY = 20, sizeX = 420, highPosX = 0, alignX = WIDGET_ALIGN_BOTH   }, true )
				t.str = WCD( dsc.Text, "srt", t.main, {posY = 35, posX = 0, sizeY = 20, sizeX = 420, highPosX = 0, alignX = WIDGET_ALIGN_BOTH   }, true )
				t.str:SetFormat(formattxt)
				t.desc:SetFormat(formattxt)
				t.str:SetVal("value", L(tostring(v)))
				t.desc:SetVal("value", L(k))
				t.buttonleft = WCD( dsc.Button, "left"..k, t.main, { sizeX = 30, sizeY = 30, posX = 120, posY = 30}, true )
				t.buttonleft:SetVal("button_label", ToWS("<"))
				t.buttonright = WCD( dsc.Button, "right"..k, t.main, { sizeX = 30, sizeY = 30, posX = 270, posY = 30}, true )
				t.buttonright:SetVal("button_label", ToWS(">"))
				t.value = function(sss)
					local valText = sss.str:GetValuedText()
					local ws = common.ExtractWStringFromValuedText( valText )
					local strin = FromWS( ws )
					
					local val = toboolean( strin )
					
					--LogInfo(sss,valText,ws,strin,val,"=================================")
					
					return val
				end
				wContainer:PushBack( t.main )
				Options[k] = t
			end
		end
	end
end

function show_settings()
	wSettingsMenu:Show(not wSettingsMenu:IsVisible())
end

function show_tip( pars, active, wBase )
--Chat(tostring("dist"))
	if active == true then
		--exObj("pars", pars)
		--LogInfo(pars)
		wTipTxt:ClearValues()
		local str, frmt, nameVT
		local sizeY, d_sizeY = 160, 35
		local frmtHP = "HP: <html fontname='AllodsWest' fontsize='20'>"
		if pars.slot then
			if pars.slot.tipMake then
				nameVT = pars.slot.tipMake( pars.slot )
			else
				frmt = "<html fontname='AllodsSystem' fontsize='18' color='0xFFCCCCCC'>"
				local color = "'0xFFDDEE33'"
				if pars.slot.quality then
					color = "'"..getHEXItemQualityStyle(pars.slot.quality).."'"
				end
				if pars.slot.name then
					frmt = frmt .. "<html fontname='AllodsWest' fontsize='18' color="..color..">"
					frmt = frmt .. pars.slot.name.." "..itemLib.GetItemInfo(device.GetItemInstalled( pars.slot.id )).level
					frmt = frmt .. "</html>"
				end
				frmt = frmt.. "<br />"
				if pars.slot.hp then
					local r, g, b, colorHP = getHPColors( pars.slot.hp )
					local i1, i2 = string.find( colorHP, "<r name='value'/>" )
					colorHP = string.gsub(colorHP, "<r name='value'/>", pars.slot.hp.."" )
					colorHP = string.gsub(colorHP, "alignx='center' fontsize='14'", "" )
					frmt = frmt ..frmtHP .. colorHP .. "%</html>"
				end

				local val = pars.slot.val
				if val then val = pars.slot.valFunc and userFuncts [pars.slot.valFunc] (val) or val end
			
				frmt = frmt .. (pars.slot.tip and string.format(pars.slot.tip, val or 0) or "")

				local title = pars.slot.id and FromWS( device.GetTitle(pars.slot.id) )
				if title then
					frmt = frmt.. "<br />" .. title
					sizeY = 100
				end
				if pars.slot.id then
					--дополнительное описание предмета
					local desc = itemLib.GetItemInfo(device.GetItemInstalled(pars.slot.id))
					if desc.description then
					frmt = frmt.. "<br />"
					--LogInfo(common.ExtractWStringFromValuedText(desc.description))
					--frmt = frmt.."<html fontsize='16' color='0xFFAAAAAA'>"..L("Damage: ")..pars.slot.id.."</html>"				
					end
				end	
				frmt = frmt .. "</html>"
				nameVT = common.CreateValuedText()
				nameVT:SetFormat( ToWS(frmt) )
			end
		elseif pars.obj then
			--pars.obj.enemy = true pars.obj.friend = true 
			local POIs = pars.obj.getPOIs and pars.obj.getPOIs(pars.obj)
			str = nil
			
			if pars.obj[ "type" ] == "SHIP" then
			
				local ShipInfo = transport.GetShipInfo( pars.obj.id )
				local gildInfo = ""
				if ShipInfo.ownerGuildName then
					gildInfo = " ("..FromWS(ShipInfo.ownerGuildName)..")"
				end
				
				frmt = "<html >".."<html fontsize='18' color='"
					.. (pars.obj.enemy and "0xFFFF4422" or pars.obj.friend and "0xFF33FFAA" or "0xFF55BBFF") .."'>"..FromWS( pars.obj.name ).."</html>. "
					.. (pars.obj.description and "<html fontsize='16' color='0xFFAAAAAA'>"..FromWS( pars.obj.description ).."</html> " or "")
					.. "<br /><html fontsize='16' color='0xFFAAAAAA'>"..FromWS( ShipInfo.ownerName )..gildInfo.."</html>"
					.. "<br /><html fontsize='16' color='0xFFAAAAAA'>"..L("ship_gearscore")..": "..tostring( math.ceil(ShipInfo.gearScore) ).."</html>"
					.. "<br /><html fontsize='16' color='0xFFAAAAAA'>"..L("ship_hull_generation")..": "..tostring( math.ceil(ShipInfo.techLevel) ).."</html>"
					--.. "<br /><html fontsize='16' color='0xFFAAAAAA'>улучшения корпуса корабля за аномалии: "..tostring( math.ceil(ShipInfo.quality) ).."</html>"
					.. "<br />"
					.. (pars.obj.hpp and frmtHP..pars.obj.hpp.."</html>% " or "")
					.. (pars.obj.dist and L(" DIST:<html fontsize='16' color='0xFF5588FF'>")..math.ceil(pars.obj.dist)..L("m").."</html>. " or "")
					.. (pars.obj.deltaZt and math.abs(pars.obj.deltaZt) > 1 and L(" H:").."<html fontsize='16' color='0xFF5588FF'>"..pars.obj.deltaZt..L("m").."</html>.." or "")
			
			else
				frmt = "<html >".."<html fontsize='18' color='"
					.. (pars.obj.enemy and "0xFFFF4422" or pars.obj.friend and "0xFF33FFAA" or "0xFF55BBFF") .."'>"..FromWS( pars.obj.name ).."</html>. "
					.. (pars.obj.description and "<html fontsize='16' color='0xFFAAAAAA'>"..FromWS( pars.obj.description ).."</html>. " or "")
					.. "<br />"
					.. (pars.obj.hpp and frmtHP..pars.obj.hpp.."</html>% " or "")
					.. (pars.obj.dist and L(" DIST:<html fontsize='16' color='0xFF5588FF'>")..math.ceil(pars.obj.dist)..L("m").."</html>. " or "")
					.. (pars.obj.deltaZt and math.abs(pars.obj.deltaZt) > 1 and L(" H:").."<html fontsize='16' color='0xFF5588FF'>"..pars.obj.deltaZt..L("m").."</html>.." or "")
				sizeY = 100
			
			end
			
			
			if pars.obj.players then
				local clr = pars.obj.enemy and "0xFFFF4433" or "0xFF33FF11"
				frmt = frmt .. "<br />"..L("Players: ").. "<html fontsize='16' color='"..clr.."'>" .. table.concat ( pars.obj.players, ", ")..".</html>"
				sizeY = sizeY + d_sizeY
			end
			if pars.obj.transChests then
				frmt = frmt .. "<br />"..L("Chests: ")..pars.obj.transChests.."."
				sizeY = sizeY + d_sizeY
			end
			
			frmt = frmt .. (POIs or "" ) .."</html>"
			nameVT = common.CreateValuedText()
			nameVT:SetFormat( ToWS(frmt) )
		end

		if str then wTipTxt:SetVal("value", ToWS( str ) ) end
		if nameVT then wTipTxt:SetVal("nameVT", nameVT ) end
		wtSetPlace( wTip, { sizeX = 380, sizeY = sizeY } )
		wtChain( wTip, wBase, 10, 10)
		--LogToChat( str )
		--LogInfo(frmt)
	end
	
	wTip:Show( active )
end

-----------------------------------------------------------------------------------------------

local mnu

local valFormats = { 
	[names[ON]] = "<html alignx='right' fontsize='14' shadow='1'><tip_green><r name='value'/></tip_green></html>",
	[names[OFF]] = "<html><log_dark_white><body alignx='right' fontsize='14' shadow='1'><r name='value'/></body></log_dark_white></html>",
	}

local function valGet(item)
	--LogInfo( item.name )
	
	return get_PS( item.name )
	--LogInfo( item.value )
	
end

function reLoadMyAddon()
	toConfig()
	common.StateUnloadManagedAddon( "UserAddon/"..ADDONname )
	common.StateLoadManagedAddon( "UserAddon/"..ADDONname )
end

local function reLoad()
	common.StateUnloadManagedAddon( "UserAddon/"..ADDONname )
	common.StateLoadManagedAddon( "UserAddon/"..ADDONname )
end
local function toConfig_RE()
	toConfig()
	reLoad()
end
local function fromConfig_RE()
	fromConfig()
	reLoad()
end
local function reset_PS_RE()
	reset_PS()
	reLoad()
end

local function valOnSetRe( item )
	local n, v = item.name, tonumber(item.value) or item.value
	set_PS(n, v)
	toConfig_RE()
end

local function valOnSet( item )

	local n, v = item.name, tonumber(item.value) or item.value
	set_PS(n, v)

	item.parent:ItemFade( item, v == OFF and 0.7 or 1)
	if type(v) ~= "table" then
		--LogToChat(n.." = "..v)
	else
		--LogToChat("see mods.txt")
		--exObj( n, v )
	end
end
local function setLocalize(item)
	valOnSet( item )
	SetGameLocalization(item.value)
	mnu:Update()
end

-------------------------------------------------------------------------------
function mainMenuToggle( pars )
	if mnu then
		--exObj("pars",pars)
		if not DnD:isSetted( mnu.wtMenu ) then
			--- если окно еще не передвигали и не запомнили с новыми координатами, 
			--- то задаим свои
			if pars.reaction and pars.reaction.widget then wtChain( mnu.wtMenu, pars.reaction.widget , 10, 10 ) end
		end
		mnu:Show( true )
	else ---LogInfo("mainMenu.ShowToggle - mnu = nil")
	end
end

function AOCommand( pars )
	if pars.command == "cmd1" then
		LogToChat("You select FIRST command")
	elseif pars.command == "cmd2" then
		LogToChat("You select command 2")
	end
	
end
----------------------------------------------------------------
------ INIT
----------------------------------------------------------------
function menuUpdate()
	if mnu then mnu:Update() end
end


--- списки значений, которые будут прокручиваться как значения некоторых полей
local onoff = { ON, OFF }

function GUIinit()

	tip_init()
	settings_init()

	local w = stateMainForm:GetChildUnchecked("ContextShipDeviceCrosshair",false)
	local c_a = get_PS("CannonAim")
	if c_a == "system" then
	elseif c_a == "OrkAura01Glow" then
		w:SetBackgroundTexture(common.GetAddonRelatedTexture("OrkAura01Glow"))
		w:SetBackgroundColor( {r = 1, g = 0.3, b = 0.2, a = 0.6} )
		wtSize(w, 150, 150)
	elseif c_a == "CannonAim" then
		w:SetBackgroundTexture(common.GetAddonRelatedTexture("CannonAim"))
		w:SetBackgroundColor( {r = 1, g = 0.1, b = 0.1, a = 1} )
		wtSize(w, 250, 250)
	elseif c_a == "CannonAim2" then
		w:SetBackgroundTexture(common.GetAddonRelatedTexture("CannonAim2"))
		w:SetBackgroundColor( {r = 1, g = 0.3, b = 0.1, a = 0.7} )
		wtSize(w, 150, 150)
	elseif c_a == "sysCannonAim2" then
		local ww = WCD( dsc.PanelEmpty, nil, w, { alignX = 3, alignY = 3}, true )
		ww:SetBackgroundTexture(common.GetAddonRelatedTexture("CannonAim2"))
		ww:SetBackgroundColor( {r = 1, g = 0.3, b = 0.1, a = 0.7} )
		wtSize(w, 150, 150)
	end
end


--LogInfo("PS.ShipPlatePlace",PS)

