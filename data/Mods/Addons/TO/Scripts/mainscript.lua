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

function ButtonClick(params)
	if DnD:IsDragging() then return	end

	if params.name == "RIGHT_CLICK" then
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

function OnUnitsChanged(params)
	for _, id in pairs(params.spawned) do
		if unit.IsPlayer(id) and unit.CanSelectTarget(id) then
			if not PlayerIds[id] then
				local name = object.GetName(id)
				if name then
					PlayerIds[id] = name
					--Chat(userMods.FromWString(name))
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
				ButtonTarget:SetTextColor(nil, { a = 1, r = 0, g = 1, b = 0 })
			else
				ButtonTarget:SetTextColor(nil, { a = 1, r = 1, g = 0, b = 0 })
			end
			ButtonTarget:SetVal("button_label", name)
		end
	else
		ButtonTarget:SetVal("button_label", userMods.ToWString(''))
	end	
end

function Init()
	DnD.Init(PanelTarget,ButtonSettings,true)

	local guild = unit.GetGuildInfo(avatar.GetId())
	if guild then
		AvatarGuildId = guild.guildId
	else
		AvatarGuildId = nil
	end
	Chat(AvatarGuildId)

	common.RegisterEventHandler(OnUnitsChanged, "EVENT_UNITS_CHANGED")
	common.RegisterEventHandler(OnAvatarTargetChanged, "EVENT_AVATAR_TARGET_CHANGED")
end

if (avatar.IsExist()) then Init()
else common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")	
end