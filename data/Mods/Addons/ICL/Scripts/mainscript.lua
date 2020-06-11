local ItemRememberTable = {
[0] = true,
[1] = true,
[2] = true,
[3] = true,
[4] = true,
[5] = true,
[6] = true,
[7] = true, 
[8] = true,
[9] = true,
[10] = true,
[11] = true,
[12] = true,
[13] = true,
[14] = true,
[15] = true,
[16] = true,
[26] = true,
}

local CraftItems = {
[0] = true,
[1] = true,
[2] = true,
[3] = true,
[8] = true,
[9] = true,
[10] = true,
[12] = true,
[13] = true,
[26] = true,
}

local itemnames = {
['Инсигния героя'] = true,
['Упакованная инсигния героя'] = true,
['Компас героя'] = true,
}

local ItemQuality = {
[0] = "None",
[3] = "ITEM_QUALITY_COMMON",
[4] = "ITEM_QUALITY_UNCOMMON",
[5] = "ITEM_QUALITY_RARE",
[6] = "ITEM_QUALITY_EPIC",
[7] = "ITEM_QUALITY_LEGENDARY",
[8] = "ITEM_QUALITY_RELIC",
}

local ItemClassQuality = {
[0] = "Goods",
[3] = "Common",
[4] = "Uncommon",
[5] = "Rare",
[6] = "Epic",
[7] = "Legendary",
[8] = "Relic",
}

local itemwt = {} 
local config = {}

function wtSetPlace(w, place )
	local p = w:GetPlacementPlain()
	for k, v in pairs(place) do	
		p[k] = place[k] or v
	end
	w:SetPlacementPlain(p)
end

function CreateWG(desc, name, parent, show, place)
	local n = mainForm:CreateWidgetByDesc( mainForm:GetChildChecked( desc, true ):GetWidgetDesc() )
	if name then n:SetName( name ) end
	if parent then parent:AddChild(n) end
	if place then wtSetPlace( n, place ) end
	n:Show( show == true )
	return n
end

local Bag = stateMainForm:GetChildChecked("ContextBag", false):GetChildChecked("Bag", false)
local Area = Bag:GetChildChecked("Area", false)
Area:GetChildChecked("SlotLine01", false):GetChildChecked("Item01", false):GetChildChecked("Frame", false):SetOnShowNotification(true)
local wtButtonSlot1 = Bag:GetChildChecked("Tabs", false):GetChildChecked("Tab01", false)
local wtPanel = mainForm:GetChildChecked( "Panel", false )
local wtCheck = wtPanel:GetChildChecked( "CheckboxInsignion", false )
local AvatarWindow = stateMainForm:GetChildUnchecked("ContextCharacter2", false):GetChildUnchecked("MainPanel", false):GetChildUnchecked("FrameEquipment", false)
AvatarWindow:AddChild(wtPanel)

config.NeedIns03 = 0
config.NeedIns06 = 0
config.NeedIns09 = 0
config.NeedIns12 = 0
config.NeedIns15 = 0
config.IsFullOnly = true
config.CurrentUnlock = 0
config.NeedIns03txt = CreateWG("Text", "NeedIns03txt", wtPanel, true, { alignX = 0, sizeX=30, posX = 37, alignY = 0, sizeY=20, posY=16})
config.NeedIns06txt = CreateWG("Text", "NeedIns06txt", wtPanel, true, { alignX = 0, sizeX=30, posX = 73, alignY = 0, sizeY=20, posY=16})
config.NeedIns09txt = CreateWG("Text", "NeedIns09txt", wtPanel, true, { alignX = 0, sizeX=30, posX = 106, alignY = 0, sizeY=20, posY=16})
config.NeedIns12txt = CreateWG("Text", "NeedIns12txt", wtPanel, true, { alignX = 0, sizeX=30, posX = 140, alignY = 0, sizeY=20, posY=16})
config.NeedIns15txt = CreateWG("Text", "NeedIns15txt", wtPanel, true, { alignX = 0, sizeX=30, posX = 175, alignY = 0, sizeY=20, posY=16})

local textformat = "<html><body alignx='center' fontsize='11' outline='1'><rs class='class'><r name='name'/></rs></body></html>"

config.Ins03txt = CreateWG("Text", "Ins03txt", wtPanel, true, { alignX = 0, sizeX=40, posX = 35, alignY = 0, sizeY=20, posY=2})
config.Ins06txt = CreateWG("Text", "Ins06txt", wtPanel, true, { alignX = 0, sizeX=40, posX = 71, alignY = 0, sizeY=20, posY=2})
config.Ins09txt = CreateWG("Text", "Ins09txt", wtPanel, true, { alignX = 0, sizeX=40, posX = 104, alignY = 0, sizeY=20, posY=2})
config.Ins12txt = CreateWG("Text", "Ins12txt", wtPanel, true, { alignX = 0, sizeX=40, posX = 138, alignY = 0, sizeY=20, posY=2})
config.Ins15txt = CreateWG("Text", "Ins15txt", wtPanel, true, { alignX = 0, sizeX=40, posX = 172, alignY = 0, sizeY=20, posY=2})

config.Ins03txt:SetFormat(textformat)
config.Ins06txt:SetFormat(textformat)
config.Ins09txt:SetFormat(textformat)
config.Ins12txt:SetFormat(textformat)
config.Ins15txt:SetFormat(textformat)

config.Ins03txt:SetVal("name", "103%")
config.Ins06txt:SetVal("name", "106%")
config.Ins09txt:SetVal("name", "109%")
config.Ins12txt:SetVal("name", "112%")
config.Ins15txt:SetVal("name", "115%")

function onWidgetShowChanged(params)
	if params.widget:GetName() == "Frame" and params.widget:GetParent():GetName() == "Item01" and params.widget:IsVisibleEx() then GetActiveIndex() CalculateInsignion() SetVals() end 
	if params.widget:GetName() == "Bag" and params.widget:GetParent():GetName() == "ContextBag" and (not params.widget:IsVisibleEx()) then ClearItemLvl() end 
end

function OnChangeInventorySlot(params)
if itemnames[userMods.FromWString(itemLib.GetItemInfo(params.itemId).name)] then
		GetActiveIndex()
	end
end

function GetActiveIndex()
ClearItemLvl()
if wtButtonSlot1:GetVariant() == 1 then
	CheckItemLvl() 
	end
end

function SetVals()
config.NeedIns03txt:SetVal("name", tostring(config.NeedIns03))
config.NeedIns06txt:SetVal("name", tostring(config.NeedIns06))
config.NeedIns09txt:SetVal("name", tostring(config.NeedIns09))
config.NeedIns12txt:SetVal("name", tostring(config.NeedIns12))
config.NeedIns15txt:SetVal("name", tostring(config.NeedIns15))

config.NeedIns03txt:SetClassVal("class", ItemClassQuality[config.CurrentUnlock])
config.NeedIns06txt:SetClassVal("class", ItemClassQuality[config.CurrentUnlock])
config.NeedIns09txt:SetClassVal("class", ItemClassQuality[config.CurrentUnlock])
config.NeedIns12txt:SetClassVal("class", ItemClassQuality[config.CurrentUnlock])
config.NeedIns15txt:SetClassVal("class", ItemClassQuality[config.CurrentUnlock])
end

function OnChangeEquipment()
CalculateInsignion()
SetVals()
end

function OnChangeInventory()
GetActiveIndex()
end
	
function CheckItemLvl()
local tab=avatar.GetInventoryItemIds()
for _,itemId in pairs( tab ) do
	local info=itemLib.GetItemInfo(itemId)
		if info and itemnames[userMods.FromWString(info.name)] then
		local lvl = CreateWG("Text", "ItemLvl", Area:GetChildChecked("SlotLine"..userMods.FromWString(common.FormatInt(math.floor(((containerLib.GetItemSlot(itemId).slot+1)/6)+0.9),"%02d")), false):GetChildChecked("Item0"..containerLib.GetItemSlot(itemId).slot%6+1, false), true, { alignX = 0, sizeX=100, posX = 0, highPosX = 0, alignY = 1, sizeY=30, posY=0, highPosY=-10})
		table.insert(itemwt, containerLib.GetItemSlot(itemId).slot, lvl)
		lvl:SetFormat (userMods.ToWString("<html><body alignx='left' fontsize='14' outline='1'><rs class='class'><r name='name'/></rs></body></html>" ))
			if userMods.FromWString(info.name):find("Компас") then
			lvl:SetVal("name", tostring(info.level))
			elseif userMods.FromWString(info.name):find("Инсигния") then
			lvl:SetVal("name", tostring(userMods.FromWString(common.ExtractWStringFromValuedText(info.description)):sub(84, 86)))
			elseif userMods.FromWString(info.name):find("Упакованная") then
			lvl:SetVal("name", tostring(userMods.FromWString(common.ExtractWStringFromValuedText(info.description)):sub(227, 229)))
			end
			lvl:SetClassVal("class", "Golden")
		end
	end
end

function GetInsignii(a, b, id)
local c = math.min(a, b)
	if c < 90 then 
	GetFullInsignion(id)
	end
	if c >= 90 and c < 103 then
		if CraftItems[id] then
		config.NeedIns03 = config.NeedIns03 + 3 
		else
		config.NeedIns03 = (103 - c) + config.NeedIns03 
		end
		config.NeedIns06 = config.NeedIns06 + 3
		config.NeedIns09 = config.NeedIns09 + 3
		config.NeedIns12 = config.NeedIns12 + 3
		config.NeedIns15 = config.NeedIns15 + 3
	end 
	if c >= 103 and c < 106 then
	config.NeedIns06 = (106 - c) + config.NeedIns06
	config.NeedIns09 = config.NeedIns09 + 3
	config.NeedIns12 = config.NeedIns12 + 3
	config.NeedIns15 = config.NeedIns15 + 3
	end
	if c >= 106 and c < 109 then
	config.NeedIns09 = (109 - c) + config.NeedIns09
	config.NeedIns12 = config.NeedIns12 + 3
	config.NeedIns15 = config.NeedIns15 + 3
	end 
	if c >= 109 and c < 112 then
	config.NeedIns12 = config.NeedIns12 + (112 - c) 
	config.NeedIns15 = config.NeedIns15 + 3
	end
	if c >= 112 and c < 115 then
	config.NeedIns15 = (115 - c) + config.NeedIns15
	end
end

function GetFullInsignion(id)
	if config.IsFullOnly or (not config.IsFullOnly) and CraftItems[id] then
	config.NeedIns03 = config.NeedIns03 + 3 
	elseif (not config.IsFullOnly) and (not CraftItems[id]) then
	config.NeedIns03 = config.NeedIns03 + 13 
	end
	config.NeedIns06 = config.NeedIns06 + 3
	config.NeedIns09 = config.NeedIns09 + 3
	config.NeedIns12 = config.NeedIns12 + 3
	config.NeedIns15 = config.NeedIns15 + 3
end

function ResetInsignion()
config.NeedIns03 = 0
config.NeedIns03 = 0 
config.NeedIns06 = 0
config.NeedIns09 = 0
config.NeedIns12 = 0
config.NeedIns15 = 0
end

function CalculateInsignion()
ResetInsignion()
	for k, _ in pairs(ItemRememberTable) do
		if unit.GetEquipmentItemId(avatar.GetId(), k, 0) then
			if itemLib.GetQuality(unit.GetEquipmentItemId(avatar.GetId(), k, 0)).quality == config.CurrentUnlock then
				local itemstats = itemLib.GetBudgets(unit.GetEquipmentItemId(avatar.GetId(), k, 0))
					if itemLib.GetItemInfo(unit.GetEquipmentItemId(avatar.GetId(), k, 0)).isDoubleHands and itemstats then 
					GetInsignii(itemstats[1], itemstats[2], k)
					GetInsignii(itemstats[1], itemstats[2], k)
					elseif (not itemLib.GetItemInfo(unit.GetEquipmentItemId(avatar.GetId(), k, 0)).isDoubleHands) and itemstats then
					GetInsignii(itemstats[1], itemstats[2], k)
					end
				elseif itemLib.GetQuality(unit.GetEquipmentItemId(avatar.GetId(), k, 0)).quality < config.CurrentUnlock then
					if itemLib.GetItemInfo(unit.GetEquipmentItemId(avatar.GetId(), k, 0)).isDoubleHands then 
					GetFullInsignion(k)
					GetFullInsignion(k)
					else
					GetFullInsignion(k)
				end
			end
		end
	end
end

function ClearItemLvl()
for k, v in pairs(itemwt) do
	v:DestroyWidget()
	end
end
		
function EventAdded()
local сategories = matchMaking.GetEventCategories()
	if сategories then
		for i = 0, GetTableSize(сategories) - 1 do
			for k, v in pairs(matchMaking.GetEventsByCategory( сategories[i] )) do
				if userMods.FromWString(matchMaking.GetEventInfo(v).rawName):find("Слой") and k > 0 then
				config.CurrentUnlock = tonumber(userMods.FromWString(matchMaking.GetEventInfo(v).rawName):sub(6, userMods.FromWString(matchMaking.GetEventInfo(v).rawName):find(":")-1))+2
				end
			end
		end
	end
end

function ReactionCBox( params )
if params.sender == "CheckboxInsignion" then
		if wtCheck:GetVariant() == 0 then
			wtCheck:SetVariant(1)
			config.IsFullOnly = true
			CalculateInsignion()
			SetVals()
		else
			wtCheck:SetVariant(0)
			config.IsFullOnly = false
			CalculateInsignion()
			SetVals()
		end
    end
end

function Init()
	matchMaking.ListenEvents(true)
	common.RegisterEventHandler( onWidgetShowChanged, "EVENT_WIDGET_SHOW_CHANGED")
	common.RegisterEventHandler( OnChangeInventorySlot, "EVENT_INVENTORY_SLOT_CHANGED")
	common.RegisterEventHandler( OnChangeInventory, "EVENT_INVENTORY_CHANGED")
	common.RegisterEventHandler( OnChangeEquipment, "EVENT_UNIT_EQUIPMENT_CHANGED", {unitId = avatar.GetId(), slotType = 0})
	common.RegisterEventHandler( EventAdded, "EVENT_MATCH_MAKING_EVENT_ADDED" )
	common.RegisterReactionHandler(ReactionCBox, "checkbox_pressed" )
	EventAdded()
	if  config.IsFullOnly == true then
        wtCheck:SetVariant(1)
    else
        wtCheck:SetVariant(0)
    end
	OnChangeEquipment()
end

if (avatar.IsExist()) then Init()
else common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")	
end
