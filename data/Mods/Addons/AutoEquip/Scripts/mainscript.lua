local PanelTarget = mainForm:GetChildChecked( "PanelTarget", false )
local ButtonSettings = PanelTarget:GetChildChecked( "ButtonSettings", false )
local ButtonTarget = PanelTarget:GetChildChecked( "ButtonTarget", false )
local ButtonControl = PanelTarget:GetChildChecked( "ButtonControl", false )

ButtonTarget:SetVal("button_label", userMods.ToWString(''))
ButtonTarget:SetTextColor(nil, { a = 1, r = 1, g = 1, b = 0 })

function ButtonClick(params)
	if DnD:IsDragging() then
		return
	end

	if params.name == "RIGHT_CLICK" then
		return
	end
	
	ProcessItems()
end

function ProcessItems()
	local items = avatar.GetInventoryItemIds()
	for index, itemId in pairs(items) do
		if itemId then
			local itemInfo = itemLib.GetItemInfo(itemId)
			if itemInfo.isDressable then
				if itemLib.IsCursed(itemId) ~= true then -- если не проклят
					Process(index, itemInfo)
				end
			end
		end
	end
end

function Process(inventSlotId, itemInfo)
	if itemInfo.dressSlot == DRESS_SLOT_MAINHAND or itemInfo.dressSlot == DRESS_SLOT_OFFHAND then
		return
	end
	if itemInfo.dressSlot == DRESS_SLOT_EARRINGS or itemInfo.dressSlot == DRESS_SLOT_EARRING1 or itemInfo.dressSlot == DRESS_SLOT_EARRING2 then
		return
	end
	if itemInfo.dressSlot == DRESS_SLOT_RING or itemInfo.dressSlot == DRESS_SLOT_RING1 or itemInfo.dressSlot == DRESS_SLOT_RING2 then
		return
	end

	local gearScore = itemLib.GetGearScore(itemInfo.id)
	if gearScore then	
		local equipedGearScore = GetEquipedGearscore(itemInfo)
		if equipedGearScore < gearScore then
			Chat(GetItemType(itemInfo))
			avatar.EquipItem(inventSlotId)
		else
			local freeSlot = GetLastFreeSlot()
			if freeSlot then
				if freeSlot > inventSlotId then
					avatar.InventoryMoveItem(inventSlotId, freeSlot)
				end
			end
		end
	end
end

function GetItemType(itemInfo)
	return userMods.FromWString(itemInfo.name)
end

function GetLastFreeSlot()
	local inventorySize = avatar.GetInventorySize() / 3
	for i=inventorySize-1, 0, -1 do
		local itemId = avatar.GetInventoryItemId(i)
		if itemId then
		else
			return i
		end
	end
	return nil
end

function GetEquipedGearscore(itemInfo)
	local maxGS = 0;
	local slots = itemLib.GetCompatibleSlots(itemInfo.id)
	for i, cur_slot in pairs(slots) do
		local equipedItemId = avatar.GetContainerItem(cur_slot, ITEM_CONT_EQUIPMENT)
		if equipedItemId then
			local equipedGearScore = itemLib.GetGearScore(equipedItemId)
			if equipedGearScore then
				maxGS = equipedGearScore
			end
		end
	end
	return maxGS
end

function OnChangeInventory()
	ProcessItems()
end

function OnChangeInventorySlot(params)
	ProcessItems()
end


function Init()
	DnD.Init(PanelTarget,ButtonSettings,true)
	
--	common.RegisterEventHandler( OnChangeInventory, "EVENT_INVENTORY_CHANGED" )
	common.RegisterEventHandler( OnChangeInventorySlot, "EVENT_INVENTORY_SLOT_CHANGED")
	common.RegisterReactionHandler( ButtonClick, "LEFT_CLICK" )
end

if (avatar.IsExist()) then Init()
else common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")	
end