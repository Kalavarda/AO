--------------------------------------------------------------------------------
-- GLOBAL		Объяввляем глобальные переменные и функции
--------------------------------------------------------------------------------
--Global( "DB", {} ) -- массив с действиями на Инстансы (снять заявку, без действия)


--------------------------------------------------------------------------------
-- EVENT HANDLERS		Тело с функциями (основное рабочее пространство)
--------------------------------------------------------------------------------
-- Функция вывода информации в Лог-файл
function LogInfo( ... )
	common.LogInfo( common.GetAddonName(), GetDateTime(), unpack( GetStringListByArguments( arg ) ) )
end


--------------------------------------------------------------------------------
-- Функция преобразования символов для функции вывода информации в Лог-файл
function GetStringListByArguments( argList )
	local newArgList = {}
	
	for i = 1, argList.n do
		local arg = argList[i]
		if common.IsWString( arg ) then
			newArgList[i] = arg
		else
			newArgList[i] = tostring( arg )
		end
	end

	return newArgList
end


--------------------------------------------------------------------------------
-- Функция выводит время (по клиенту)
function GetDateTime()
	--Возвращает клиентскую дату и время в формате LuaFullDateTime
	local date = common.GetLocalDateTime()
	
	date.d = string.format( "%02d", date.d )
	date.m = string.format( "%02d", date.m )
	date.y = string.format( "%02d", date.y )

	date.h = string.format( "%02d", date.h )
	date.min = string.format( "%02d", date.min )
	date.s = string.format( "%02d", date.s )

--	timestamp = string.format( "%d-%02d-%02d %02d:%02d:%02d: ", d.y,d.m,d.d,t.h,t.m,t.s )

--	local dateFormat = userMods.ToWString(date.d.."."..date.m.."."..date.y.." "..date.h..":"..date.min..":"..date.s.."::")
	local dateFormat = date.d.."."..date.m.."."..date.y.." "..date.h..":"..date.min..":"..date.s.."||"

	return dateFormat


--[[
	--LuaFullDateTime
	--local date = common.GetDateTimeFromMs( 123456789012345 )
	--LogInfo( "date: ", date.d, ".", date.m, ".", date.y )

	-- пример:
	local date = common.GetLocalDateTime()
	LogInfo( "date: ", date.d, ".", date.m, ".", date.y )

	-- возвращаемые значение:
	таблица LuaFullDateTime
	-- параметры:
	timeTable - таблица с полями:
	y: number (integer) - год
	m: number (integer) - месяц (начиная с 1)
	d: number (integer) - день
	h: nil or number (integer) - час (необязательный параметр, по умолчанию 0)
	min: nil or number (integer) - минута (необязательный параметр, по умолчанию 0)
	s: nil or number (integer) - секунда (необязательный параметр, по умолчанию 0)
	ms: nil or number (integer) - миллисекунда (необязательный параметр, по умолчанию 0)
]]
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- спозиционироваь к независимому виджету
function wtChain(w, wBase, dx, dy)
	--LogToChat(dx..":".. dy)
	local p, r = w:GetPlacementPlain(), wBase:GetRealRect()
	local xx, yy = getScreenSizeCenter()
	p.alignX = WIDGET_ALIGN_LOW_ABS
	p.alignY = WIDGET_ALIGN_LOW_ABS
	local x, y = (r.x1 + r.x2)*0.5, 0.5*(r.y1 + r.y2) --- центр берем у базы
	---LogInfo(x,":",y, "   xx:y",xx, ":", yy)
	if xx > x then
		--p.posX = x+dx
		--p.posX = x-r.x1
		p.posX = r.x1-p.sizeX
		--p.posX = p.sizeX+r.x1
	else
		p.posX = x - dx - p.sizeX
		--p.posX = x1 - p.sizeX
	end
	if yy > y then
		--p.posY = y+dy
		p.posY = r.y1 - p.sizeY
	else
		--p.posY = y - dy - p.sizeY
		p.posY = r.y1
	end
	w:SetPlacementPlain(p)
end

local ScreenSize
local wtToResizeOnResolutionChanged = {}


--------------------------------------------------------------------------------
local function OnResolutionChanged()
	local newScreenSize = widgetsSystem:GetPosConverterParams()
	---exObj("ScreenSize",ScreenSize)
	for i, wt in pairs(wtToResizeOnResolutionChanged) do
		local plc = wt:GetPlacementPlain()
		for _, v in { "size", "pos", "highPos" } do
			for _, xy in { "X", "Y" } do
				local k = v..xy
				plc[k] = plc[k] / ScreenSize["fullVirtualSize"..xy] * newScreenSize["fullVirtualSize"..xy]
			end
		end
		wt:SetPlacementPlain( plc )
		
	end
	ScreenSize = newScreenSize
end


--------------------------------------------------------------------------------
function wtAddForResolutionChanged( wt )
	table.insert( wtToResizeOnResolutionChanged, wt )
end


--------------------------------------------------------------------------------
function getScreenSizeCenter()
	---return ScreenSize.fullVirtualSizeX/2, ScreenSize.fullVirtualSizeY/2
	return ScreenSize.realSizeX/2, ScreenSize.realSizeY/2
end

OnResolutionChanged()
common.RegisterEventHandler( OnResolutionChanged, "EVENT_POS_CONVERTER_CHANGED" )


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local TimerMs = 1000

function OnEventEffectFinishedTimer( params )
  if params.wtOwner:IsEqual( mainForm:GetChildChecked( "bimbo" , false ) ) then
    CheckWidgetStatus()
    mainForm:GetChildChecked( "bimbo" , false ):PlayFadeEffect( 0.0, 1.0, TimerMs, EA_SYMMETRIC_FLASH )
  end
end

function StartTimer( value )
  TimerMs = value
  mainForm:GetChildChecked( "bimbo" , false ):PlayFadeEffect( 0.0, 1.0, TimerMs, EA_SYMMETRIC_FLASH )
  common.RegisterEventHandler( OnEventEffectFinishedTimer, "EVENT_EFFECT_FINISHED" )
end

function StopTimer( value )
  common.UnRegisterEventHandler( OnEventEffectFinishedTimer , "EVENT_EFFECT_FINISHED" )
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local TimerSecond = 0
local ParamsLoadManagedAddon = nil

local TimerSecondOn = 0

---------------------------------------------------------------------------------------------------
-- Функция запускает функцию Загрузки отключенного аддона
function StartSecondTimerLoadManagedAddon( params )
	TimerSecond = 0
	ParamsLoadManagedAddon = params
	if TimerSecondOn == 0 then
		common.RegisterEventHandler( SecondTimerLoadManagedAddon, "EVENT_SECOND_TIMER" )
		TimerSecondOn = 1
	end
end

---------------------------------------------------------------------------------------------------
-- Функция Загрузки отключенного аддона
function SecondTimerLoadManagedAddon( params )
	TimerSecond = TimerSecond + 1
	
	if not ParamsLoadManagedAddon.TimeLimit then
		ParamsLoadManagedAddon.TimeLimit = 2
	end
	
	if (TimerSecond >= ParamsLoadManagedAddon.TimeLimit) then
		common.UnRegisterEventHandler( SecondTimerLoadManagedAddon, "EVENT_SECOND_TIMER" )
		common.StateLoadManagedAddon( ParamsLoadManagedAddon.NameAddon )
		ParamsLoadManagedAddon = nil
		
		TimerSecondOn = 0
	end
end