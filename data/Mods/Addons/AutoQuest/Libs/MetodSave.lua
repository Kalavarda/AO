
-- �� ����������
common = {}
common.RegisterEventHandler = function() end
userMods = {}
userMods.GetAvatarConfigSection  = function() end
userMods.SetAvatarConfigSection  = function() end
userMods.SetGlobalConfigSection  = function() end
userMods.GetGlobalConfigSection  = function() end
userMods.FromWString = function(sss) return sss end
Chat = print
-- 
--���������
--1) nameAddonSaveMetod - ������ ��� ������
--2) typeSaveMod -- ������ �������� �� ���������
--3) �������� ����� ���� � ������ ��� ������������ ������ ���������� / ��������


----------------------------------------------------------------------------
--����� ���������� ������ (������)
----------------------------------------------------------------------------

--[[ �������� ������

��������� ������ ����:
1) "/BuildManager GetSave" - ������� ������� ����� ���������� ( Avatar - ��������� ������ ��� �������� ������, Global - ��������� ��� ���� ������� )
2) "/BuildManager Save Avatar" - ��������� ������ ��� �������� ������ (���������� ������������� �����)
3) "/BuildManager Save Global" - ��������� ������ ��� ���� ������� (���������� ������������� �����)
4) "/TypeSave" - ������� ��������� �����
]]

local nameAddonSaveMetod = "BuildManager"
local  typeSaveMod = "Avatar" -- ����� ���������� �� ���������
local keyMetodSave = nameAddonSaveMetod .. "C7C2FA8793C14AEA84FD14658610145C"

--������� ����������
--������� ����������
Global( "SetConfigSection" , nil ) --userMods.SetAvatarConfigSection  --{	userMods.SetAvatarConfigSection,	userMods.SetGlobalConfigSection	}
Global( "GetConfigSection" , nil ) --userMods.GetAvatarConfigSection  --{	userMods.GetAvatarConfigSection,	userMods.GetGlobalConfigSection	}

function onSlashCommandMetodSave( params ) --��������� ������ ����
	
	local text = userMods.FromWString( params.text )
	--Chat(text)
	local getTypeSave = "/"..nameAddonSaveMetod .. " GetSave" --������� � ��� ����� ����������
	local setTypeSaveAvatar = "/"..nameAddonSaveMetod .. " Save Avatar" --��������� ������ ��� �������
	local setTypeSaveGlobal = "/"..nameAddonSaveMetod .." Save Global" --��������� ��� ���� ����������
	
	if text == getTypeSave then
		local typeMetodSave = userMods.GetGlobalConfigSection(keyMetodSave) 
		if typeMetodSave == nil then
			typeMetodSave = typeSaveMod
		else
			typeMetodSave = typeMetodSave.typeModSave
		end
		
		

		if typeMetodSave == "Avatar" then
			Chat("����� ����������: "..typeMetodSave .. " -��������� ��� ������� ������� ��������" )
		elseif typeMetodSave == "Global" then
			Chat("����� ����������: "..typeMetodSave .. " - ��������� ��� ���� �������� (��� ���������� ������ ���������� ����� ���������� ��� � ������ ���� ���������� (�������� ����������� ������� ���� � ���� ����������))" )
		else
			Chat("����� ����������: �����������" )
		end
	elseif text == setTypeSaveAvatar then
		userMods.SetGlobalConfigSection( keyMetodSave, {["typeModSave"] = "Avatar"} )
		InitModSave()
		Chat("����� "..nameAddonSaveMetod .. " ��������� ��� ������� ������� ��������")
	elseif text == setTypeSaveGlobal then
		userMods.SetGlobalConfigSection( keyMetodSave, {["typeModSave"] = "Global"} )
		InitModSave()
		Chat("����� "..nameAddonSaveMetod .. " ��������� ��� ���� ��������")
		
	elseif text == "/TypeSave" then -- ������� � ��� ��� 
		Chat(getTypeSave .. " - ������� ������� ������ ����������")
		Chat(setTypeSaveAvatar .. " - ��������� ������ ��� �������� ���������")
		Chat(setTypeSaveGlobal .. " - ��������� ��� ���� ����������")
	end	
	
end
function isAvatarSave()
	local flagMetodSave = userMods.GetGlobalConfigSection(keyMetodSave)
	if flagMetodSave == nil then
		flagMetodSave = typeSaveMod
	else
		flagMetodSave = flagMetodSave.typeModSave
	end
	if flagMetodSave == "Avatar" then
		return true
	elseif flagMetodSave == "Global" then
		return false
	else	
		return nil
	end
end
function InitModSave()
	if isAvatarSave() == true then
		SetConfigSection = userMods.SetAvatarConfigSection  --{	userMods.SetAvatarConfigSection,	userMods.SetGlobalConfigSection	}
		GetConfigSection = userMods.GetAvatarConfigSection  --{	userMods.GetAvatarConfigSection,	userMods.GetGlobalConfigSection	}
	elseif isAvatarSave() == false then
			SetConfigSection = userMods.SetGlobalConfigSection  --{	userMods.SetAvatarConfigSection,	userMods.SetGlobalConfigSection	}
			GetConfigSection = userMods.GetGlobalConfigSection  --{	userMods.GetAvatarConfigSection,	userMods.GetGlobalConfigSection	}
	else
		if typeSaveMod == "Avatar" then
			SetConfigSection = userMods.SetAvatarConfigSection  --{	userMods.SetAvatarConfigSection,	userMods.SetGlobalConfigSection	}
			GetConfigSection = userMods.GetAvatarConfigSection  --{	userMods.GetAvatarConfigSection,	userMods.GetGlobalConfigSection	}
		elseif typeSaveMod == "Global" then
			SetConfigSection = userMods.SetGlobalConfigSection  --{	userMods.SetAvatarConfigSection,	userMods.SetGlobalConfigSection	}
			GetConfigSection = userMods.GetGlobalConfigSection  --{	userMods.GetAvatarConfigSection,	userMods.GetGlobalConfigSection	}
		else
			error ("����������� ����� ����������")
		end
	end
end
InitModSave()

common.RegisterEventHandler( onSlashCommandMetodSave, "EVENT_UNKNOWN_SLASH_COMMAND" )

----------------------------------------------------------------------------
--����� ���������� ������ (�����)
----------------------------------------------------------------------------

--����

onSlashCommandMetodSave( {text = "EnchantInsNew GetSave"} )

error("��������� � ������")
