local PanelTarget = mainForm:GetChildChecked( "PanelTarget", false )
local ButtonSettings = PanelTarget:GetChildChecked( "ButtonSettings", false )
local ButtonTarget = PanelTarget:GetChildChecked( "ButtonTarget", false )
local ButtonControl = PanelTarget:GetChildChecked( "ButtonControl", false )

ButtonTarget:SetVal("button_label", userMods.ToWString(''))
ButtonTarget:SetTextColor(nil, { a = 1, r = 1, g = 1, b = 0 })

local IsWorking = false

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
	if IsWorking then
		return
	end
	IsWorking = true

	local status, retval = pcall(Work)
	if status then
	else
		Chat(retval)
	end		

	IsWorking = false
end

function Work()
	local items = avatar.GetInventoryItemIds()
	for index, itemId in pairs(items) do
		if itemId then
			local itemInfo = itemLib.GetItemInfo(itemId)
			if itemInfo.isDressable then
				if not itemLib.IsCursed(itemId) then
					Process(index, itemInfo)
				end
			end
		end
	end
end

function Process(inventSlotId, itemInfo)
	local slotId = GetEquipSlotFor(itemInfo)
	if slotId then
		--Chat(userMods.FromWString(itemInfo.name))
		local status, retval = pcall(avatar.EquipItem, inventSlotId);
		if status then
		else
			Chat(retval)
		end		
	else
		if NeedSale(itemInfo) then
			local freeSlot = GetLastFreeSlot()
			if freeSlot then
				if freeSlot > inventSlotId then
					avatar.InventoryMoveItem(inventSlotId, freeSlot)
				end
			end
		end
	end	
end

function NeedSale(itemInfo)
	local slotId = GetEquipSlotFor(itemInfo)
	if slotId then
		return false
	else
		if itemInfo.dressSlot == DRESS_SLOT_MAINHAND or itemInfo.dressSlot == DRESS_SLOT_OFFHAND then
			local gearScore = itemLib.GetGearScore(itemInfo.id)
			local maxGS = GetMaxGearscoreInInventory(itemInfo.dressSlot)
			if gearScore < maxGS then
			 	return true
			end
			return false
		end
	
		return true
	end	
end

function GetMaxGearscoreInInventory(dressSlot)
	local max = 0
	local items = avatar.GetInventoryItemIds()
	for index, itemId in pairs(items) do
		if itemId then
			local itemInfo = itemLib.GetItemInfo(itemId)
			if itemInfo.dressSlot == dressSlot then
				local gearScore = itemLib.GetGearScore(itemInfo.id)
				if gearScore > max then
					max = gearScore
				end
			end
		end
	end
	return max
end

function GetEquipSlotFor(itemInfo)
	if itemInfo.dressSlot == DRESS_SLOT_MAINHAND or itemInfo.dressSlot == DRESS_SLOT_OFFHAND then
		return nil
	end

	--Chat(userMods.FromWString(itemInfo.name))
	local slotIndex = avatar.GetInventoryItemSlot(itemInfo.id)
	--Chat("slotIndex")
	local inventorySize = avatar.GetInventorySize() / 3
	if slotIndex > inventorySize then
		return nil
	end

	local gearScore = itemLib.GetGearScore(itemInfo.id)

	local slots = itemLib.GetCompatibleSlots(itemInfo.id)
	for i, cur_slot in pairs(slots) do
		local equipedItemId = avatar.GetContainerItem(cur_slot, ITEM_CONT_EQUIPMENT)
		if equipedItemId then
			local equipedGearScore = itemLib.GetGearScore(equipedItemId)
			if gearScore and equipedGearScore and gearScore > equipedGearScore then
				return i
			end
		else
			return i
		end
	end

	return nil
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

-- function OnEquipFailed(params)
-- 	Chat("OnEquipFailed")
-- 	for k, v in pairs(params) do
-- 		if v then
-- 			Chat(k)
-- 		end
-- 	end

-- 	local errorText = avatar.GetEquipResult(params["sysCode"])
-- 	Chat(userMods.FromWString(errorText))
-- end

function Init()
	DnD.Init(PanelTarget,ButtonSettings,true)
	
--	common.RegisterEventHandler( OnChangeInventory, "EVENT_INVENTORY_CHANGED")
	common.RegisterEventHandler( OnChangeInventorySlot, "EVENT_INVENTORY_SLOT_CHANGED")
	common.RegisterReactionHandler( ButtonClick, "LEFT_CLICK")
	-- common.RegisterEventHandler(OnEquipFailed, "EVENT_EQUIP_FAILED")
end

if (avatar.IsExist()) then
	Init()
else
	common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")	
end