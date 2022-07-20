local CheckIntervalSeconds = 30
local MinRemain = 2 * 60 * 1000
local PvE_Locations = {
	'Белый колизей',
	'Цитадель Нихаза',
	'Изумрудный остров',
	'Медная гора',
	'Земля Тысячи Крыльев',
	'Санаторий "Снежинка"',
	'Огнехлад',
	'Изумрудный остров',
	'Обитель Фении',
	'Лумисаар',
	'Безмолвная падь'
}
local PvP_Locations = {
	"Ведьмин яр",
	"Дикий хутор",
	"Битва за Каргаллас",
	"Полигон",
	"Башня Порядка",
	"Арена Смерти",
	"Тающий остров"
}
local Counter = 0

function Check(zoneName, buffs)
	local isPveLocation = IsPveLocation(zoneName)
	local isPvpLocation = IsPvpLocation(zoneName)
	if (not isPveLocation) and (not isPvpLocation) then
		return
	end

	local alchemy = false
	local pvp_def = false
	local pvp_atack = false
	local pve_def = false
	local pve_atack = false
	local essence_count = 0
	
	for i, id in pairs(buffs) do
		local buffInfo = object.GetBuffInfo(id)
		local nameBuff = userMods.FromWString(buffInfo.name)
		if string.find(nameBuff, 'надобье') then
			if buffInfo.remainingMs > MinRemain then
				alchemy = true
			end
		end
		if nameBuff == 'Стойкость поединщика' then
			if buffInfo.remainingMs > MinRemain then
				pvp_def = true
			end
		end
		if nameBuff == 'Доблесть поединщика' then
			if buffInfo.remainingMs > MinRemain then
				pvp_atack = true
			end
		end	
		if nameBuff == 'Живучесть' or nameBuff == 'Осторожность' or nameBuff == 'Стойкость' then
			if buffInfo.remainingMs > MinRemain then
				pve_def = true
			end
		end
		if nameBuff == 'Решимость' then
			if buffInfo.remainingMs > MinRemain then
				pve_atack = true
			end
		end
		if string.find(nameBuff, 'ссенция') or string.find(nameBuff, 'кстракт') then
			if buffInfo.remainingMs > MinRemain then
				essence_count = essence_count + 1
			end
		end
	end
	
	if (not alchemy) or (not pvp_def) or (not pvp_atack)or (not pve_def) or (not pve_atack) or (essence_count < 2) then
		if not alchemy then
			Chat('Нужна алхимка', "LogColorRed")
		end
		if isPvpLocation then
			if not pvp_def then
				Chat('Нужна Острая рыбка', "LogColorRed")
			end
			if not pvp_atack then
				Chat('Нужна Острая настойка', "LogColorRed")
			end
		end
		if isPveLocation then
			if not pve_def then
				Chat('Нужна еда на защиту', "LogColorRed")
			end
			if not pve_atack then
				Chat('Нужна еда на атаку', "LogColorRed")
			end
		end
		if essence_count < 2 then
			Chat('Нужна эссенция или экстракт', "LogColorRed")
		end
	end
end

function IsPveLocation(zoneName)
	for i, locName in ipairs(PvE_Locations) do
		if locName == zoneName then
			return true
		end
	end
	return false
end

function IsPvpLocation(zoneName)
	for i, locName in ipairs(PvP_Locations) do
		if locName == zoneName then
			return true
		end
	end
	return false
end

function OnEventSecondTimer(params)
	Counter = Counter + 1
	if Counter == CheckIntervalSeconds then
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
