local PanelTarget = mainForm:GetChildChecked( "PanelTarget", false )
local ButtonSettings = PanelTarget:GetChildChecked( "ButtonSettings", false )
local ButtonTarget = PanelTarget:GetChildChecked( "ButtonTarget", false )
local ButtonControl = PanelTarget:GetChildChecked( "ButtonControl", false )

ButtonTarget:SetVal("button_label", userMods.ToWString('Search target'))
ButtonTarget:SetTextColor(nil, { a = 1, r = 1, g = 1, b = 0 })
ButtonControl:SetVal("button_label", userMods.ToWString('Нет цели'))
ButtonControl:SetTextColor(nil, { a = 1, r = 1, g = 1, b = 0 })

local Mode = 0
local SavedTarget = 0
local SavedControl = 0
local SavedTargetName
local SavedControlName

local AvatarAspectTimerCounter = 0;
local AvatarAspect = 0;
local ASPECT_ATTACK = 1;
local ASPECT_SUPPORT = 2;
local ASPECT_HEAL = 3;
local ASPECT_DEFENSE = 4;

local MODE_PVE = 1;
local MODE_PVP = 2;
local GameMode = MODE_PVE;

local CLASS_PRIEST = 'PRIEST'
local CLASS_ENGINEER = 'ENGINEER'
local CLASS_STALKER = 'STALKER'
local CLASS_WARRIOR = 'WARRIOR'
local CLASS_MAGE = 'MAGE'
local CLASS_NECROMANCER = 'NECROMANCER'
local CLASS_WARLOCK = 'WARLOCK' -- демон
local CLASS_BARD = 'BARD'
local CLASS_PSIONIC = 'PSIONIC' -- мист

local PlayerIds = {}

function ButtonClick(params)
	if DnD:IsDragging() then return	end

	if params.name == "RIGHT_CLICK" then
		if GameMode == MODE_PVE then
			GameMode = MODE_PVP
		else
			GameMode = MODE_PVE
		end
		ShowMode()
	end

	SetAutoTarget(params)
end

function ShowMode()
	if GameMode == MODE_PVE then
		ButtonTarget:SetVal("button_label", userMods.ToWString('PvE'))
	else
		ButtonTarget:SetVal("button_label", userMods.ToWString('PvP'))
	end
end

function IsNear(coord1, coord2)
	local dx = coord1.posX - coord2.posX
	local dy = coord1.posY - coord2.posY
	local dz = coord1.posZ - coord2.posZ
	if math.sqrt(dx*dx + dy*dy + dz*dz) < 40 then
		return true
	end
	return false
end

function SelectTarget(arg, wt)
if arg == "ButtonTarget" then 
	if object.IsExist(SavedTarget) and unit.CanSelectTarget(SavedTarget) then
		avatar.SelectTarget(SavedTarget)
		end
elseif arg == "ButtonControl" then 
	if object.IsExist(SavedControl) and unit.CanSelectTarget(SavedControl) then
		avatar.SelectTarget(SavedControl)
		end
	end
end

function SaveTarget(arg, wt)
if arg == "ButtonTarget" then 
	if not avatar.GetTarget() then return end
	SavedTarget = avatar.GetTarget()
		if unit.IsPet(SavedTarget) then
		SavedTargetName = object.GetName(unit.GetPetOwner(SavedTarget))
		SavedTarget = unit.GetPetOwner(SavedTarget)
		else
		SavedTargetName = object.GetName(SavedTarget)
		end
	wt:SetVal("button_label", object.GetName(SavedTarget))
	wt:SetTextColor(nil, { a = 1, r = 0, g = 1, b = 0 })
elseif arg == "ButtonControl" then 
	if not avatar.GetTarget() then return end
	SavedControl = avatar.GetTarget()
		if unit.IsPet(SavedControl) then
		SavedControlName = object.GetName(unit.GetPetOwner(SavedControl))
		SavedControl = unit.GetPetOwner(SavedControl)
		else
		SavedControlName = object.GetName(SavedControl)
		end
	wt:SetVal("button_label", object.GetName(SavedControl))
	wt:SetTextColor(nil, { a = 1, r = 0, g = 1, b = 0 })	
	end
end

function ClearTarget(arg, wt)
if arg == "ButtonTarget" then 
	SavedTarget = 0
	SavedTargetName = nil
	wt:SetVal("button_label", userMods.ToWString('Нет цели'))
	wt:SetTextColor(nil, { a = 1, r = 1, g = 1, b = 0 })
elseif arg == "ButtonControl" then 
	SavedControl = 0
	SavedControlName = nil
	wt:SetVal("button_label", userMods.ToWString('Нет цели'))
	wt:SetTextColor(nil, { a = 1, r = 1, g = 1, b = 0 })
	end
end

function DespawnUnit(params)
if params.unitId == SavedTarget then
	ButtonTarget:SetTextColor(nil, { a = 1, r = 1, g = 0, b = 0 })
elseif params.unitId == SavedControl then
	ButtonControl:SetTextColor(nil, { a = 1, r = 1, g = 0, b = 0 })
	end
end

function SpawnUnit(params)
if SavedTargetName then
if userMods.FromWString(object.GetName(params.unitId)) == userMods.FromWString(SavedTargetName) then
	SavedTarget = params.unitId
	ButtonTarget:SetTextColor(nil, { a = 1, r = 0, g = 1, b = 0 })
	end
end 
if SavedControlName then
if userMods.FromWString(object.GetName(params.unitId)) == userMods.FromWString(SavedControlName) then
	SavedControl = params.unitId
	ButtonControl:SetTextColor(nil, { a = 1, r = 0, g = 1, b = 0 })
		end 
	end
end

function DeadUnit(params)
if params.unitId == SavedTarget then
	ButtonTarget:SetTextColor(nil, { a = 1, r = 1, g = 0, b = 0 })
elseif params.unitId == SavedControl then
	ButtonControl:SetTextColor(nil, { a = 1, r = 1, g = 0, b = 0 })
	end
end

function AOLocker(params)
	if params.StatusDnD then
		DnD:Enable( PanelTarget, false )
	elseif not params.StatusDnD then
		DnD:Enable( PanelTarget, true )
	end
end

function DetectAvatarAspect()
	AvatarAspect = GetAspect(avatar.GetId())
end

function GetAspect(playerId)
	local buffs = object.GetBuffs(playerId)
	if buffs then
		for i, id in pairs(buffs) do
			local buffInfo = object.GetBuffInfo(id)
			if buffInfo then
				local nameBuff = userMods.FromWString(buffInfo.name)
				if nameBuff then
					if nameBuff == 'Аспект Нападения' then
						return ASPECT_ATTACK
					end
					if nameBuff == 'Аспект Поддержки' then
						return ASPECT_SUPPORT
					end
					if nameBuff == 'Аспект Исцеления' then
						return ASPECT_HEAL
					end
					if nameBuff == 'Аспект Защиты' then
						return ASPECT_DEFENSE
					end
				end
			end
		end
	end
	
	return nil
end

function GetPlayerIds()
	local avatarPos = avatar.GetPos()

	-- clear
	for k in pairs (PlayerIds) do
		PlayerIds[k] = nil
	end
	
	if AvatarAspect == ASPECT_HEAL then

		PlayerIds["avatar"] = avatar.GetId()

		-- raid
		if raid.IsExist() then
			local raidMembers = raid.GetMembers()
			if raidMembers then
				for key, valueRaid in pairs(raidMembers) do
					for key, valueGroup in pairs(valueRaid) do
						local coord = object.GetPos(valueGroup.id)
						if coord and IsNear(avatarPos, coord) then
							PlayerIds[key] = valueGroup.id
						end
					end
				end
			end
		end

		-- group
		if group.IsExist() then
			local groupMembers = group.GetMembers()
			if groupMembers then
				for key, valueGroup in pairs(groupMembers) do
					local coord = object.GetPos(valueGroup.id)
					if coord and IsNear(avatarPos, coord) then
						PlayerIds[key] = valueGroup.id
					end
				end
			end
		end
	end
	
	if AvatarAspect == ASPECT_SUPPORT then
		local units = avatar.GetUnitList()
		for key, unitId in pairs(units) do
			local coord = object.GetPos(unitId)
			if coord and IsNear(avatarPos, coord) then
				if GameMode == MODE_PVP then
					if unit.IsPlayer(unitId) then
						if object.IsEnemy(unitId) and not object.IsDead(unitId) then
							PlayerIds[key] = unitId
						end
					end
				end
				if GameMode == MODE_PVE then
					PlayerIds[key] = unitId
				end
			end
		end
	end
	
	if AvatarAspect == ASPECT_ATTACK then
		local units = avatar.GetUnitList()
		for key, unitId in pairs(units) do
			local coord = object.GetPos(unitId)
			if coord and IsNear(avatarPos, coord) then
				if GameMode == MODE_PVE then
					PlayerIds[key] = unitId
				end
			end
		end
	end

	return PlayerIds
end

function GetTargetId(ids)
	if AvatarAspect == ASPECT_HEAL then
		local minPerc = 100
		local minObjectId = -1
		for key, playerId in pairs(ids) do
			local healthInfo = object.GetHealthInfo(playerId)
			if healthInfo then
				if GameMode == MODE_PVE or healthInfo.valuePercents > 0 then
					if healthInfo.valuePercents < minPerc then
						minPerc = healthInfo.valuePercents
						minObjectId = playerId
					end
				end
			end
		end
		if minObjectId ~= -1 then
			return minObjectId
		end
	end

	if AvatarAspect == ASPECT_SUPPORT then
		for key, playerId in pairs(ids) do
			local clId = unit.GetClassId(playerId)
			if clId then
				local classId = clId:GetInfo().className

				if classId == CLASS_ENGINEER then
					if HasBuff(playerId, 'Железный занавес') then
						return playerId
					end
				end
				
				if classId == CLASS_BARD then
					if HasBuff(playerId, 'Антре') then
						return playerId
					end
				end
				
				if classId == CLASS_PRIEST then
					if GetAspect(playerId) ~= ASPECT_HEAL and HasBuff(playerId, 'Броня света') then
						return playerId
					end
				end
				
				if classId == CLASS_PSIONIC then
					if HasBuff(playerId, 'Астральная форма') or HasBuff(playerId, 'Псионический панцирь') then
						return playerId
					end
				end
				
				if classId == CLASS_WARRIOR then
					if HasBuff(playerId, 'Глухая оборона') then
						return playerId
					end
				end
			end
		end
	end
	
	if AvatarAspect == ASPECT_ATTACK then
		for key, playerId in pairs(ids) do
			return playerId
		end
	end
	
	return nil
end

function HasBuff(playerId, buffName)
	local buffs = object.GetBuffs(playerId)
	if buffs then
		for i, buffId in pairs(buffs) do
			local buffInfo = object.GetBuffInfo(buffId)
			if buffInfo then
				if userMods.FromWString(buffInfo.name) == buffName then
					return true
				end
			end
		end
	end
	
	return false
end


-- function onObjectBuffsChanged(params)	
	-- Chat('onObjectBuffsChanged')
	-- SetAutoTarget(params)
-- end

function SetAutoTarget(params)

	-- detect aspect of avatar
	if AvatarAspectTimerCounter == 0 then
		DetectAvatarAspect()
	end
	AvatarAspectTimerCounter = AvatarAspectTimerCounter + 1
	if AvatarAspectTimerCounter >= 60 then
		AvatarAspectTimerCounter = 0
	end
	
	local ids = GetPlayerIds()
	local id = GetTargetId(ids)
	if id then
		if unit.CanSelectTarget(id) then
			avatar.SelectTarget(id)
		end
	end
end

function Init()
	DnD.Init(PanelTarget,ButtonSettings,true)
	common.RegisterReactionHandler( ButtonClick, "LEFT_CLICK" )
	common.RegisterReactionHandler( ButtonClick, "RIGHT_CLICK" )
	ShowMode()

	common.RegisterReactionHandler(SetAutoTarget, "mouse_left_click" )
	--common.RegisterEventHandler(onObjectBuffsChanged, "EVENT_EMOTES_CHANGED" )
	--common.RegisterEventHandler(SetAutoTarget, "EVENT_SECOND_TIMER")
end

if (avatar.IsExist()) then Init()
else common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")	
end