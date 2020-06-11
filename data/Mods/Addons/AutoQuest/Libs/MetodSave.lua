
-- не копировать
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
--Установка
--1) nameAddonSaveMetod - ввести имя аддона
--2) typeSaveMod -- ввести значение по умолчанию
--3) вставить текст кода в модуль где используется методы сохранения / загрузки


----------------------------------------------------------------------------
--Метод сохранения данных (начало)
----------------------------------------------------------------------------

--[[ Описание работы

Обработка команд чата:
1) "/BuildManager GetSave" - вывести текущий метод сохранения ( Avatar - сохраняет только для текущего игрока, Global - сохраняет для всех игроков )
2) "/BuildManager Save Avatar" - сохранять данные для текущего аватар (необходимо перезапустить аддон)
3) "/BuildManager Save Global" - сохранять данные для всех игроков (необходимо перезапустить аддон)
4) "/TypeSave" - Вывести параметры ввода
]]

local nameAddonSaveMetod = "BuildManager"
local  typeSaveMod = "Avatar" -- метод сохранения по умолчанию
local keyMetodSave = nameAddonSaveMetod .. "C7C2FA8793C14AEA84FD14658610145C"

--функции сохранения
--функции сохранения
Global( "SetConfigSection" , nil ) --userMods.SetAvatarConfigSection  --{	userMods.SetAvatarConfigSection,	userMods.SetGlobalConfigSection	}
Global( "GetConfigSection" , nil ) --userMods.GetAvatarConfigSection  --{	userMods.GetAvatarConfigSection,	userMods.GetGlobalConfigSection	}

function onSlashCommandMetodSave( params ) --Обработка команд чата
	
	local text = userMods.FromWString( params.text )
	--Chat(text)
	local getTypeSave = "/"..nameAddonSaveMetod .. " GetSave" --вывести в чат метод сохранения
	local setTypeSaveAvatar = "/"..nameAddonSaveMetod .. " Save Avatar" --сохранять только для аватара
	local setTypeSaveGlobal = "/"..nameAddonSaveMetod .." Save Global" --сохранять для всех персонажей
	
	if text == getTypeSave then
		local typeMetodSave = userMods.GetGlobalConfigSection(keyMetodSave) 
		if typeMetodSave == nil then
			typeMetodSave = typeSaveMod
		else
			typeMetodSave = typeMetodSave.typeModSave
		end
		
		

		if typeMetodSave == "Avatar" then
			Chat("Метод сохранения: "..typeMetodSave .. " -сохраняет для каждого аватара отдельно" )
		elseif typeMetodSave == "Global" then
			Chat("Метод сохранения: "..typeMetodSave .. " - сохраняет для всех аватаров (для корректной работы необходимо чтобы количество вех и умений было одинаковое (возможно минимальное которой есть у всех персонажей))" )
		else
			Chat("Метод сохранения: неопределен" )
		end
	elseif text == setTypeSaveAvatar then
		userMods.SetGlobalConfigSection( keyMetodSave, {["typeModSave"] = "Avatar"} )
		InitModSave()
		Chat("Аддон "..nameAddonSaveMetod .. " сохраняет для каждого аватара отдельно")
	elseif text == setTypeSaveGlobal then
		userMods.SetGlobalConfigSection( keyMetodSave, {["typeModSave"] = "Global"} )
		InitModSave()
		Chat("Аддон "..nameAddonSaveMetod .. " сохранять для всех аватаров")
		
	elseif text == "/TypeSave" then -- Вывести в чат имя 
		Chat(getTypeSave .. " - Вывести текущей формат сохранения")
		Chat(setTypeSaveAvatar .. " - сохранять только для текущего персонажа")
		Chat(setTypeSaveGlobal .. " - сохранять для всех персонажей")
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
			error ("неопределен метод сохранения")
		end
	end
end
InitModSave()

common.RegisterEventHandler( onSlashCommandMetodSave, "EVENT_UNKNOWN_SLASH_COMMAND" )

----------------------------------------------------------------------------
--Метод сохранения данных (конец)
----------------------------------------------------------------------------

--Тест

onSlashCommandMetodSave( {text = "EnchantInsNew GetSave"} )

error("Вставлять в модуль")
