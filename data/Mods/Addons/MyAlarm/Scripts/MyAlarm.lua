local CheckIntervalSeconds = 30
local MinRemain = 2 * 60 * 1000
local PvE_Locations = {
	'����� �������',
	'�������� ������',
	'���������� ������',
	'������ ����',
	'����� ������ �������',
	'��������� "��������"',
	'��������',
	'���������� ������',
	'������� �����',
	'��������',
	'���������� ����'
}
local PvP_Locations = {
	"������� ��",
	"����� �����",
	"����� �� ���������",
	"�������",
	"����� �������",
	"����� ������",
	"������ ������"
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
		if string.find(nameBuff, '�������') then
			if buffInfo.remainingMs > MinRemain then
				alchemy = true
			end
		end
		if nameBuff == '��������� ����������' then
			if buffInfo.remainingMs > MinRemain then
				pvp_def = true
			end
		end
		if nameBuff == '�������� ����������' then
			if buffInfo.remainingMs > MinRemain then
				pvp_atack = true
			end
		end	
		if nameBuff == '���������' or nameBuff == '������������' or nameBuff == '���������' then
			if buffInfo.remainingMs > MinRemain then
				pve_def = true
			end
		end
		if nameBuff == '���������' then
			if buffInfo.remainingMs > MinRemain then
				pve_atack = true
			end
		end
		if string.find(nameBuff, '�������') or string.find(nameBuff, '�������') then
			if buffInfo.remainingMs > MinRemain then
				essence_count = essence_count + 1
			end
		end
	end
	
	if (not alchemy) or (not pvp_def) or (not pvp_atack)or (not pve_def) or (not pve_atack) or (essence_count < 2) then
		if not alchemy then
			Chat('����� �������', "LogColorRed")
		end
		if isPvpLocation then
			if not pvp_def then
				Chat('����� ������ �����', "LogColorRed")
			end
			if not pvp_atack then
				Chat('����� ������ ��������', "LogColorRed")
			end
		end
		if isPveLocation then
			if not pve_def then
				Chat('����� ��� �� ������', "LogColorRed")
			end
			if not pve_atack then
				Chat('����� ��� �� �����', "LogColorRed")
			end
		end
		if essence_count < 2 then
			Chat('����� �������� ��� ��������', "LogColorRed")
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
