local PanelTarget = mainForm:GetChildChecked( "PanelTarget", false )
local ButtonSettings = PanelTarget:GetChildChecked( "ButtonSettings", false )
local ButtonTarget = PanelTarget:GetChildChecked( "ButtonTarget", false )
local ButtonControl = PanelTarget:GetChildChecked( "ButtonControl", false )

ButtonTarget:SetVal("button_label", userMods.ToWString(''))
ButtonTarget:SetTextColor(nil, { a = 1, r = 1, g = 1, b = 0 })

local Mode = 0
local SavedTarget = 0
local SavedControl = 0
local SavedTargetName
local SavedControlName

local PlayerIds = {}
local AvatarGuildId = 0
local GuildIds = {}
local GreenColor = { a = 1, r = 0, g = 1, b = 0 }
local RedColor = { a = 1, r = 1, g = 0, b = 0 }

function ButtonClick(params)
	if DnD:IsDragging() then return	end

	if params.name == "RIGHT_CLICK" then
	end
end

function OnUnitsChanged(params)
	for _, id in pairs(params.spawned) do
		StoreUnitName(id)
	end
end

function StoreUnitName(id)
	if unit.IsPlayer(id) and unit.CanSelectTarget(id) then
		if not PlayerIds[id] then
			local name = object.GetName(id)
			local n = userMods.FromWString(name)
			if n ~= 'Кладоискатель' then
				if name then
					PlayerIds[id] = name
					--Chat(n)
				end
				local guild = unit.GetGuildInfo(id)
				if guild and guild.guildId then
					GuildIds[id] = guild.guildId
					--Chat(userMods.FromWString(guild.name))
				end
			end
		end
	end
end

function OnAvatarTargetChanged()
	local targetId = avatar.GetTarget()
	if targetId then
		local name = PlayerIds[targetId]
		if name then
			local guildId = GuildIds[targetId]
			if guildId == AvatarGuildId then
				ButtonTarget:SetTextColor(nil, GreenColor)
			else
				ButtonTarget:SetTextColor(nil, RedColor)
			end
			ButtonTarget:SetVal("button_label", name)
		else
			ButtonTarget:SetVal("button_label", userMods.ToWString(''))
		end
	else
		ButtonTarget:SetVal("button_label", userMods.ToWString(''))
	end	
end


function ButtonClick(params)
	if DnD:IsDragging() then return	end

	local units = avatar.GetUnitList()
	for key, unitId in pairs(units) do
		StoreUnitName(unitId)
	end
	Chat('Ники запомнены')
end

function Init()
	DnD.Init(PanelTarget,ButtonSettings,true)

	local guild = unit.GetGuildInfo(avatar.GetId())
	if guild then
		AvatarGuildId = guild.guildId
	else
		AvatarGuildId = nil
	end

	common.RegisterReactionHandler( ButtonClick, "LEFT_CLICK" )
	common.RegisterEventHandler(OnUnitsChanged, "EVENT_UNITS_CHANGED")
	common.RegisterEventHandler(OnAvatarTargetChanged, "EVENT_AVATAR_TARGET_CHANGED")
end

if (avatar.IsExist()) then Init()
else common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")	
end