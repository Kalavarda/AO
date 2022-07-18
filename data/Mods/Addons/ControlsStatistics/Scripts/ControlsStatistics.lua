local Counters = {}
local ControlTypes = {
	"���������",
	"����������",
	"�����",
	"�������",
	"����������",
	"��� ���������",
	"��������",
	"���������",
	"���",
	"�������",
	"������� ������",
	"�����"
}

function BuffAddedHandler( params )

	local buffName = userMods.FromWString(params.buffName)
	
	for i, ct in ipairs(ControlTypes) do
		if ct == buffName then
			local count = Counters[ct]
			count = count + 1
			Counters[ct] = count
		end
	end
end

function OnEventUnknownSlashCommand( params )
	local cmd = userMods.FromWString( params.text )
	if cmd == "/controls" or cmd == "/��������" or cmd == "/����" then
		for key, value in pairs(Counters) do
			if value > 0 then
				Chat(key.." = "..value)
			end
		end
	end
	if cmd == "/controlsReset" or cmd == "/�������������" or cmd == "/���������" then
		ResetCounters()
		Chat('�������� ��������')
	end
end

function OnEventAvatarCreated()
	common.RegisterEventHandler(BuffAddedHandler, "EVENT_OBJECT_BUFF_ADDED", avatar.GetId() )
	common.RegisterEventHandler(OnEventUnknownSlashCommand, "EVENT_UNKNOWN_SLASH_COMMAND" )
end

function ResetCounters()
	for i, ct in ipairs(ControlTypes) do
		Counters[ct] = 0
	end
end

function Init()
	ResetCounters()

	common.RegisterEventHandler(OnEventAvatarCreated, "EVENT_AVATAR_CREATED")

	if avatar.IsExist() then
		OnEventAvatarCreated()
	end

end

Init()
