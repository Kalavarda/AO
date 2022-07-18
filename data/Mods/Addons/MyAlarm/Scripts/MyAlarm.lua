local Counter = 0

function Check(zoneName, buffs)
	if zoneName == "Светлолесье" then
	end
	
	local alchemy = false
	
	for i, id in pairs(buffs) do
		local buffInfo = object.GetBuffInfo(id)
		if buffInfo then
			local nameBuff = userMods.FromWString(buffInfo.name)
			if nameBuff then
			end
		end
	end
	
	if not alchemy then
		Chat('Нужна алхимка!', "LogColorRed")
	end
end

function OnEventSecondTimer(params)
	Counter = Counter + 1
	if Counter == 5 then
		Counter = 0
	end
	if Counter > 0 then
		return
	end
	local zoneName = userMods.FromWString(cartographer.GetCurrentZoneInfo().zoneName)
	local buffs = object.GetBuffs(avatar.GetId())
	Check(zoneName, buffs)
end

function OnEventAvatarCreated()
	common.RegisterEventHandler(OnEventSecondTimer, "EVENT_SECOND_TIMER")
end

function Init()
	common.RegisterEventHandler(OnEventAvatarCreated, "EVENT_AVATAR_CREATED")

	if avatar.IsExist() then
		OnEventAvatarCreated()
	end
end

Init()
