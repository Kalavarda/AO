---------------------------------------------------------------------------------------------------------------------------
-- AOClassLibrary - Library for working with Widgets in Addons for "Allods Online" (See DarkDPSMeter addon for example)  --
--         Originally created by DarkMaster. Currently maintained by UI9 community: http://ui9.ru/forum/develop          --
--                      Licensed under WTFPL v2.0 public license: http://sam.zoy.org/wtfpl/COPYING                       --
---------------------------------------------------------------------------------------------------------------------------
------------------------------------------------- COMMON GLOBAL VARIABLES -------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
Global( "ClassColors", {
	["WARRIOR"]		= { r = 0.65; g = 0.54; b = 0.34; a = 1 },
	["PALADIN"]		= { r = 0.80; g = 1.00; b = 1.00; a = 1 },
	["STALKER"]		= { r = 0.00; g = 0.78; b = 0.00; a = 1 },
	["BARD"]		= { r = 0.00; g = 1.00; b = 1.00; a = 1 },
	["PRIEST"]		= { r = 1.00; g = 1.00; b = 0.31; a = 1 },
	["DRUID"]		= { r = 1.00; g = 0.50; b = 0.00; a = 1 },
	["PSIONIC"]		= { r = 1.00; g = 0.50; b = 1.00; a = 1 },
	["MAGE"]		= { r = 0.18; g = 0.57; b = 1.00; a = 1 },
	["NECROMANCER"]	= { r = 0.95; g = 0.17; b = 0.28; a = 1 },
	["UNKNOWN"]		= { r = 0.50; g = 0.50; b = 0.50; a = 1 },
} )
--------------------------------------------------------------------------------
Global( "AssistColors", {
	["MERCENARY"]		= { r = 0.33; g = 0.50; b = 0.60; a = 1 },
} )
--------------------------------------------------------------------------------
Global( "ClassColorsIcons", {
	["WARRIOR"]		= { r = 143/255; g = 119/255; b = 075/255; a = 1 },
	["PALADIN"]		= { r = 207/255; g = 220/255; b = 155/255; a = 1 },
	["STALKER"]		= { r = 150/255; g = 204/255; b = 086/255; a = 1 },
	["BARD"]		= { r = 106/255; g = 230/255; b = 223/255; a = 1 },
	["PRIEST"]		= { r = 255/255; g = 207/255; b = 123/255; a = 1 },
	["DRUID"]		= { r = 255/255; g = 118/255; b = 060/255; a = 1 },
	["PSIONIC"]		= { r = 221/255; g = 123/255; b = 245/255; a = 1 },
	["MAGE"]		= { r = 126/255; g = 159/255; b = 255/255; a = 1 },
	["NECROMANCER"]	= { r = 208/255; g = 069/255; b = 075/255; a = 1 },
	["UNKNOWN"]		= { r = 127/255; g = 127/255; b = 127/255; a = 1 },
} )
--------------------------------------------------------------------------------
Global( "DamageTypeColors", {
	 ["ENUM_SubElement_PHYSICAL"]	= { r = 0.7; g = 0.5; b = 0.3; a = 1 },
	 ["ENUM_SubElement_FIRE"]		= { r = 1.0; g = 0.0; b = 0.0; a = 1 },
	 ["ENUM_SubElement_COLD"]		= { r = 0.5; g = 0.5; b = 1.0; a = 1 },
	 ["ENUM_SubElement_LIGHTNING"]	= { r = 0.8; g = 0.8; b = 1.0; a = 1 },
	 ["ENUM_SubElement_HOLY"]		= { r = 1.0; g = 1.0; b = 0.5; a = 1 },
	 ["ENUM_SubElement_SHADOW"]		= { r = 0.5; g = 0.1; b = 0.7; a = 1 },
	 ["ENUM_SubElement_ASTRAL"]		= { r = 1.0; g = 1.0; b = 1.0; a = 1 },
	 ["ENUM_SubElement_POISON"]		= { r = 0.5; g = 1.0; b = 0.5; a = 1 },
	 ["ENUM_SubElement_DISEASE"]	= { r = 0.7; g = 0.7; b = 0.4; a = 1 },
	 ["ENUM_SubElement_ACID"]		= { r = 1.0; g = 1.0; b = 0.0; a = 1 },
} )
--------------------------------------------------------------------------------
Global( "HitTypeColors", {
	 [1] = { r = 1.0; g = 1.0; b = 1.0; a = 1 }, -- Normal
	 [2] = { r = 1.0; g = 0.0; b = 0.0; a = 1 }, -- Critical
	 [3] = { r = 0.5; g = 1.0; b = 0.5; a = 1 }, -- Glancing
	 [4] = { r = 0.5; g = 0.5; b = 1.0; a = 1 }, -- Dodge
	 [5] = { r = 1.0; g = 1.0; b = 0.5; a = 1 }, -- Miss
} )
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- HELPER FUNCTIONS -----------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
function GetTableSize( t )
	if not t then return 0 end
	return t[0] and table.getn(t)+1 or table.getn(t)
end
--------------------------------------------------------------------------------
function CloneTable( t )
	if type( t ) ~= "table" then return t end
	local c = {}
	for i, v in t do c[ i ] = CloneTable( v ) end
	return c
end
--------------------------------------------------------------------------------
function LogInfo( ... )
	local timestamp = ""
	if mission.GetWorldTimeHMS then
		if mission.GetLocalTimeHMS then -- AO 2.0.01+
			local t = mission.GetLocalTimeHMS()
			local d = mission.GetLocalDateYMD()
			timestamp = string.format( "%d-%02d-%02d %02d:%02d:%02d.%03d: ", d.y,d.m,d.d,t.h,t.m,t.s,t.ms )
		else -- AO 1.1.03-2.0.00
			local t = mission.GetWorldTimeHMS()
			local d = mission.GetWorldDateYMD()
			timestamp = string.format( "%d-%02d-%02d %02d:%02d:%02d: ", d.y,d.m,d.d,t.h,t.m,t.s )
		end
	end
	local argNorm = {}
	for i = 1, arg.n do
		if common.IsWString( arg[ i ] ) then
			argNorm[ i ] = arg[ i ]
		else
			argNorm[ i ] = tostring( arg[ i ] )
		end
	end
	common.LogInfo( common.GetAddonName(), timestamp, unpack( argNorm ) )
end
--------------------------------------------------------------------------------
function LogTable( t, tabstep )
	tabstep = tabstep or 1
	if t == nil then
		LogInfo( "nil (no table)" )
		return
	end
	assert( type( t ) == "table", "Invalid data passed" )
	local TabString = string.rep( "    ", tabstep )
	local isEmpty = true
	for i, v in t do
		if type( v ) == "table" then
			LogInfo( TabString, i, ":" )
			LogTable( v, tabstep + 1 )
		else
			LogInfo( TabString, i, " = ", v )
		end
		isEmpty = false
	end
	if isEmpty then
		LogInfo( TabString, "{} (empty table)" )
	end
end
--------------------------------------------------------------------------------
function GetExecutionSpeedMs( TimeS, TimeF )
	local S = TimeS.h * 3600000 + TimeS.m * 60000 + TimeS.s * 1000 + ( TimeS.ms or 0 )
	local F = TimeF.h * 3600000 + TimeF.m * 60000 + TimeF.s * 1000 + ( TimeF.ms or 0 )
	return ( F >= S ) and ( F - S ) or ( 86400000 + F - S )
end
--------------------------------------------------------------------------------
function RegisterEventHandlers( handlers )
	for event, handler in handlers do
		common.RegisterEventHandler( handler, event )
	end
end
--------------------------------------------------------------------------------
function RegisterReactionHandlers( handlers )
	for event, handler in handlers do
		common.RegisterReactionHandler( handler, event )
	end
end
---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------- MULTIPLE LOCALIZATIONS SUPPORT ----------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- AO game Localization detection by SLA. Version 2011-02-10.
function GetGameLocalization()
	local B = cartographer.GetMapBlocks()
	local T = { rus="\203\232\227\224", eng="Holy Land", ger="Heiliges Land",
	fra="Terre Sacr\233e", br="Terra Sagrada", jpn="\131\74\131\106\131\65" }
	for b in B do for l,t in T do
	if userMods.FromWString( cartographer.GetMapBlockInfo(B[b]).name ) == t
	then return l end end end return "eng"
end
--------------------------------------------------------------------------------
function GetTextLocalized( strTextName )
	return common.GetAddonRelatedTextGroup( localization ):GetText( strTextName )
end
---------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ GLOBAL VARIABLES, CLASSES ------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
Global( "TWidget", {} )
---------------------------------------------------------------------------------------------------------------------------
function TWidget:CreateNewObject( WidgetName )
	return setmetatable( {
			Widget = WidgetName and mainForm:GetChildUnchecked( WidgetName, true ),
			bDraggable = false
		}, { __index = self } )
end
--------------------------------------------------------------------------------
function TWidget:CreateNewObjectByDesc( WidgetName, Desc, Parent )
	local Widget = mainForm:CreateWidgetByDesc( Desc )
	Widget:SetName( WidgetName )
	if Parent then
		Parent.Widget:AddChild( Widget )
	end
	return setmetatable( { Widget = Widget, bDraggable = false }, { __index = self } )
end
--------------------------------------------------------------------------------
function TWidget:GetDesc()
	if self.Widget then
		return self.Widget:GetWidgetDesc()
	end
end
--------------------------------------------------------------------------------
function TWidget:GetChildCount()
	if self.Widget then
		return table.getn( self.Widget:GetNamedChildren() ) + 1
	end
	return 0
end
--------------------------------------------------------------------------------
function TWidget:GetChildByName( Name )
	if self.Widget then
		local wtChild = self.Widget:GetChildUnchecked( Name, false )
		
		if wtChild then
			return setmetatable( { Widget = wtChild, bDraggable = false }, { __index = self } )
		end
	end
end
--------------------------------------------------------------------------------
function TWidget:GetChildByIndex( Index )
	if self.Widget then
		local wtChildren = self.Widget:GetNamedChildren()
		local wtChild = wtChildren[ Index ]
		
		if wtChild then
			return setmetatable( { Widget = wtChild, bDraggable = false }, { __index = self } )
		end
	end
end
--------------------------------------------------------------------------------
function TWidget:Destroy()
	if self.Widget then
		self.Widget:DestroyWidget()
		self = nil
	end
end
--------------------------------------------------------------------------------
function TWidget:DragNDrop( bDraggable, ID, wtMovable, bUseCfg, bLockedToScreenArea, Padding )
	if self.Widget then
		self.bDraggable = bDraggable
		if ID then
			DnD:Init( ID, self.Widget, wtMovable, bUseCfg, bLockedToScreenArea, Padding )
		else
			DnD:Enable( self.Widget, bDraggable )
		end
	end
end
--------------------------------------------------------------------------------
function TWidget:SetPosition( newX, newY )
	if self.Widget then
		local Placement = self.Widget:GetPlacementPlain()
		if newX then Placement.posX = math.ceil( newX ) end
		if newY then Placement.posY = math.ceil( newY ) end
		self.Widget:SetPlacementPlain( Placement )
	end
end
--------------------------------------------------------------------------------
function TWidget:SetWidth( newW )
	if self.Widget then
		local Placement = self.Widget:GetPlacementPlain()
		Placement.sizeX = math.ceil( newW )
		self.Widget:SetPlacementPlain( Placement )
	end
end
--------------------------------------------------------------------------------
function TWidget:SetHeight( newH )
	if self.Widget then
		local Placement = self.Widget:GetPlacementPlain()
		Placement.sizeY = math.ceil( newH )
		self.Widget:SetPlacementPlain( Placement )
	end
end
--------------------------------------------------------------------------------
function TWidget:GetWidth()
	if self.Widget then
		return self.Widget:GetPlacementPlain().sizeX
	end
end
--------------------------------------------------------------------------------
function TWidget:GetHeight()
	if self.Widget then
		return self.Widget:GetPlacementPlain().sizeY
	end
end
--------------------------------------------------------------------------------
function TWidget:SetColor( Color, Alpha )
	if self.Widget then
		if Alpha then
			Color.a = Alpha
		end
		self.Widget:SetBackgroundColor( Color )
	end
end
--------------------------------------------------------------------------------
function TWidget:SetTransparency( Alpha )
	if self.Widget then
		local Color = self.Widget:GetBackgroundColor()
		Color.a = Alpha
		self.Widget:SetBackgroundColor( Color )
	end
end
--------------------------------------------------------------------------------
function TWidget:Show()
	if self.Widget then
		self.Widget:Show( true )
	end
end
--------------------------------------------------------------------------------
function TWidget:Hide()
	if self.Widget then
		self.Widget:Show( false )
	end
end
--------------------------------------------------------------------------------
function TWidget:HideAllChild()
	if self.Widget then
		local wtChildren = self.Widget:GetNamedChildren()
		for _, wtChild in pairs( wtChildren ) do
			wtChild:Show( false )
		end
	end
end
--------------------------------------------------------------------------------
function TWidget:ShowAllChild()
	if self.Widget then
		local wtChildren = self.Widget:GetNamedChildren()
		for _, wtChild in pairs( wtChildren ) do
			wtChild:Show( true )
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------- INITIALIZATION ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
Global( "localization", "eng" ) -- "eng" is default.
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
