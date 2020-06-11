--------------------------------------------------------------------------------
-- Integer functions
--------------------------------------------------------------------------------

function round(time)
	if not time then return nil end
	local int=math.floor(time)
	local rest=int~=0 and time%int or 0
	if rest<0.5 then
		return int
	end
	return int+1
end

--------------------------------------------------------------------------------
-- String functions
--------------------------------------------------------------------------------

local _lower = string.lower
local _upper = string.upper

function string.lower(s)
    return _lower(s:gsub("([А-Я])",function(c) return string.char(c:byte()+32) end):gsub("Ё", "ё"))
end

function string.upper(s)
    return _upper(s:gsub("([а-я])",function(c) return string.char(c:byte()-32) end):gsub("ё", "Ё"))
end

function toWString(text)
	if not text then return nil end
	if not common.IsWString(text) then
		text=userMods.ToWString(tostring(text))
	end
	return text
end

function toString(text)
	if not text then return nil end
	if common.IsWString(text) then
		text=userMods.FromWString(text)
	end
	return tostring(text)
end


function find(text, word)
	text=toString(text)
	word=toString(word)
	if text and word and word~="" then
		text=string.lower(text)
		word=string.lower(word)
		return string.find(text, word)
	end
	return false
end

function findWord(text)
	if not text then return {} end
	if string.gmatch then return string.gmatch(toString(text), "([^,]+),*%s*") end
	return pairs({toString(text)})
end

function formatText(text, align, fontSize, shadow, outline, fontName)
	return "<body fontname='"..(toString(fontName) or "AllodsWest").."' alignx = '"..(toString(align) or "left").."' fontsize='"..(toString(fontSize) or "14").."' shadow='"..(toString(shadow) or "1").."' outline='"..(toString(outline) or "0").."'><rs class='color'>"..(toString(text) or "").."</rs></body>"
end

function toValuedText(text, color, align, fontSize, shadow, outline, fontName)
	local valuedText=common.CreateValuedText()
	text=toWString(text)
	if not valuedText or not text then return nil end
	valuedText:SetFormat(toWString(formatText(text, align, fontSize, shadow, outline, fontName)))
	if color then
		valuedText:SetClassVal( "color", color )
	else
		valuedText:SetClassVal( "color", "LogColorYellow" )
	end
	return valuedText
end

function compare(name1, name2)
	name1=toWString(name1)
	name2=toWString(name2)
	if not name1 or not name2 then return nil end
	return common.CompareWStringEx(name1, name2)==0
end

function getTimeString(ms)
	if		ms<1000	then return "0."..toString(round(ms/100)).."s"
	else   	ms=round(ms/1000) end
	if		ms<60	then return toString(ms).."s"
	else    ms=math.floor(ms/60) end
	if		ms<60	then return toString(ms).."m"
	else    ms=round(ms/60) end
	if		ms<24	then return toString(ms).."h"
	else    ms=round(ms/24) end
	return toString(ms).."d"
end

--------------------------------------------------------------------------------
-- Widget funtions
--------------------------------------------------------------------------------

Global("WIDGET_ALIGN_LOW", 0)
Global("WIDGET_ALIGN_HIGH", 1)
Global("WIDGET_ALIGN_CENTER", 2)
Global("WIDGET_ALIGN_BOTH", 3)
Global("WIDGET_ALIGN_LOW_ABS", 4)

function destroy(widget)
	if widget and widget.DestroyWidget then widget:DestroyWidget() end
end

function isVisible(widget)
	if widget and widget.IsVisible then return widget:IsVisible() end
	return nil
end

function getChild(widget, name, g)
	if g==nil then g=false end
	if not widget or not widget.GetChildUnchecked or not name then return nil end
	return widget:GetChildUnchecked(name, g)
end

function getPos(widget)
	if not widget then return end
	return widget.GetPlacementPlain and widget:GetPlacementPlain()
end

function move(widget, posX, posY)
	if not widget then return end
	local BarPlace=widget.GetPlacementPlain and widget:GetPlacementPlain()
	if not BarPlace then return nil end
	if posX then
		BarPlace.posX = posX
		BarPlace.highPosX = posX
	end
	if posY then
		BarPlace.posY = posY
		BarPlace.highPosY = posY
	end
	if widget.SetPlacementPlain then widget:SetPlacementPlain(BarPlace) end
end

function setFade(widget, fade)
	if widget and fade and widget.SetFade then
		widget:SetFade(fade)
	end
end

function resize(widget, width, height)
	if not widget then return end
	local BarPlace=widget.GetPlacementPlain and widget:GetPlacementPlain()
	if not BarPlace then return nil end
	if width then BarPlace.sizeX = width end
	if height then BarPlace.sizeY = height end
	if widget.SetPlacementPlain then widget:SetPlacementPlain(BarPlace) end
end

function align(widget, alignX, alingY)
	if not widget then return end
	local BarPlace=widget.GetPlacementPlain and widget:GetPlacementPlain()
	if not BarPlace then return nil end
	if alignX then BarPlace.alignX = alignX end
	if alingY then BarPlace.alignY = alingY end
	if widget.SetPlacementPlain then widget:SetPlacementPlain(BarPlace) end
end

function priority(widget, priority)
	if not widget or not priority then return nil end
	if widget.SetPriority then widget:SetPriority(priority) end
end

function show(widget)
	if not widget  then return nil end
	if not widget.IsVisible or widget:IsVisible() then return nil end
	--if widget:IsVisible() then return nil end
	if widget.Show then widget:Show(true) end
end

function hide(widget)
	if not widget  then return nil end
	if not widget.IsVisible or not widget:IsVisible()  then return nil end
	--if not widget:IsVisible() then return nil end
	if widget.Show then widget:Show(false) end
end

function setName(widget, name)
	if not widget or not name then return nil end
	if widget.SetName then widget:SetName(name) end
end

function getName(widget)
	return widget and widget.GetName and widget:GetName() or nil
end

function getText(widget)
	return widget and widget.GetText and toString(widget:GetText()) or nil
end

function setText(widget, text, color, align, fontSize, shadow, outline, fontName)
	if not widget then return nil end
	text=userMods.ToWString(text or "")
	if widget.SetVal 		then widget:SetVal("button_label", text)  end
	--if widget.SetTextColor	then widget:SetTextColor("button_label", { a = 1, r = 1, g = 0, b = 0 } ) end --ENUM_ColorType_SHADOW
	if widget.SetText		then widget:SetText(text) end
	if widget.SetValuedText then widget:SetValuedText(toValuedText(text, color or "ColorWhite", align, fontSize, shadow, outline, fontName)) end
end

function setBackgroundTexture(widget, texture)
	if not widget or not widget.SetBackgroundTexture then return nil end
	widget:SetBackgroundTexture(texture)
end

function setBackgroundColor(widget, color)
	if not widget or not widget.SetBackgroundColor then return nil end
	if not color then color={ r = 0; g = 0, b = 0; a = 0 } end
	widget:SetBackgroundColor(color)
end

local templateWidget=nil
local form=nil

function getDesc(name)
	local widget=templateWidget and name and templateWidget.GetChildUnchecked and templateWidget:GetChildUnchecked(name, false)
	return widget and widget.GetWidgetDesc and widget:GetWidgetDesc() or nil
end

function getParent(widget, num)
	if not num or num<1 then num=1 end
	if not widget or not widget.GetParent then return nil end
	local parent=widget:GetParent()
	if num==1 then return parent end
	return getParent(parent, num-1)
end

function getForm(widget)
	if not widget then return nil end
	if not widget.CreateWidgetByDesc then
		return getForm(getParent(widget))
	end
	return widget
end

function createWidget(parent, widgetName, templateName, alignX, alignY, width, height, posX, posY, noParent)
	local desc=getDesc(templateName)
	if not desc and parent then return nil end
	local owner=getForm(parent)
	local widget=owner and owner:CreateWidgetByDesc(desc) or common.AddonCreateChildForm(templateName)
	if parent and widget and not noParent then parent:AddChild(widget) end --
	setName(widget, widgetName)
	align(widget, alignX, alignY)
	move(widget, posX, posY)
	resize(widget, width, height)
	return widget
end

function setTemplateWidget(widget)
	templateWidget=widget
end

function equals(widget1, widget2)
	if not widget1 or not widget2 then return nil end
	return widget1.IsEqual and widget1:IsEqual(widget2) or widget2.IsEqual and widget2:IsEqual(widget1) or nil
end

function swap(widget)
	if widget and widget.IsVisible and not widget:IsVisible() then
		show(widget)
	else
		hide(widget)
	end
end

function changeCheckBox(widget)
	if not widget or not widget.GetVariantCount then return end
	if not widget.GetVariant or not widget.SetVariant then return end

	if 0==widget:GetVariant() then 	widget:SetVariant(1)
	else 							widget:SetVariant(0) end
end

function setCheckBox(widget, value)
	if not widget or not widget.SetVariant or not widget.GetVariantCount then return end
	if widget:GetVariantCount()<2 then return end
	if 		value 	then 	widget:SetVariant(1) return end
	widget:SetVariant(0)
end

function getCheckBoxState(widget)
	if not widget or not widget.GetVariant then return end
	return widget:GetVariant()==1 and true or false
end

function getModFromFlags(flags)
	local ctrl=flags>3
	if ctrl then flags=flags-4 end
	local alt=flags>1
	if alt then flags=flags-2 end
	local shift=flags>0
	return ctrl, alt, shift
end


function CopyTable(t)
  local result = { }
  for k, v in pairs( t ) do
    result[k] = v
  end
  return result
end

--------------------------------------------------------------------------------
-- Timers functions
--------------------------------------------------------------------------------

local template=createWidget(nil, "Template", "Template")
local timers={}

function timer(params)
	if not params.effectType == ET_FADE then return end
	local name=nil
	for i, j in pairs(timers) do
		if j and equals(params.wtOwner, j.widget) then
			name=i
		end
	end
	if not name then return end


	if timers[name] then
		if timers[name].widget and not timers[name].one then
			timers[name].widget:PlayFadeEffect( 1.0, 1.0, timers[name].speed*1000, EA_MONOTONOUS_INCREASE )
		end
		userMods.SendEvent( timers[name].event, {sender = common.GetAddonName()} )
	end
end

function startTimer(name, eventname, speed, one)
	if name and timers[name] then destroy(timers[name].widget) end
	setTemplateWidget(template)
	local timerWidget=createWidget(mainForm, name, "Timer")
	if not timerWidget or not name or not eventname then return nil end
	timers[name]={}
	timers[name].event=eventname
	timers[name].widget=timerWidget
	timers[name].one=one
	timers[name].speed=tonumber(speed) or 1

	common.RegisterEventHandler(timer, "EVENT_EFFECT_FINISHED")
    timerWidget:PlayFadeEffect(1.0, 1.0, timers[name].speed*1000, EA_MONOTONOUS_INCREASE)
	return true
end

function stopTimer(name)
    common.UnRegisterEventHandler( timer, "EVENT_EFFECT_FINISHED" )
end

function setTimeout(name, speed)
	if name and timers[name] and speed then
		timers[name].speed=tonumber(speed) or 1
	end
end

function destroyTimer(name)
	if timers[name] then destroy(timers[name].widget) end
	timers[name]=nil
end

--ScriptLIB
---- update 2011.09.26
function AT_Vers()
	return {
	lib = 8, --- 4.0.02 --itemInfi.name = name + quality+level+mets+... [[[ScriptLIB + itemLib + wtGetSizeY
	tools = 3, --- AddonsTools - LibDnD - use standard
	menu = 8, --- + childObj-destroy()
	addons = 4, --- AddonsMenu + PlanTime + +skin+terxtures
	version = "r81d",  -- item.temporaryInfo
	}
end

local ADDONname = common.GetAddonName()

local valuedText = common.CreateValuedText()
local formatVT = "<html fontname='AllodsSystem' shadow='1'><rs class='color'><r name='addon'/><r name='text'/></rs></html>"
valuedText:SetFormat(userMods.ToWString(formatVT))

--------------------------------------------------------------------------------
-- FUNCTIONS
--------------------------------------------------------------------------------
local ScreenSize
local wtToResizeOnResolutionChanged = {}
local function OnResolutionChanged()
	local newScreenSize = widgetsSystem:GetPosConverterParams()
	---exObj("ScreenSize",ScreenSize)
	for i, wt in pairs(wtToResizeOnResolutionChanged) do
		local plc = wt:GetPlacementPlain()
		for _, v in pairs({ "size", "pos", "highPos" }) do
			for _, xy in pairs({ "X", "Y" }) do
				local k = v..xy
				plc[k] = plc[k] / ScreenSize["fullVirtualSize"..xy] * newScreenSize["fullVirtualSize"..xy]
			end
		end
		wt:SetPlacementPlain( plc )
		
	end
	ScreenSize = newScreenSize
end
function wtAddForResolutionChanged( wt )
	table.insert( wtToResizeOnResolutionChanged, wt )
end

function getScreenSizeCenter()
	---return ScreenSize.fullVirtualSizeX/2, ScreenSize.fullVirtualSizeY/2
	return ScreenSize.realSizeX/2, ScreenSize.realSizeY/2
end
OnResolutionChanged()
common.RegisterEventHandler( OnResolutionChanged, "EVENT_POS_CONVERTER_CHANGED" )


local ToDo = {}
function ToDo_Add1(time, func, arg)
	table.insert(ToDo, { time = time, func = func, arg = arg } ) 
end

local function sTimer ( pars )
	for i, item in pairs(ToDo) do
		if item.time <= 0 then
			item.func(item.arg)
			table.remove( ToDo, i )
		else
			item.time = item.time - 1
		end
	end
end
common.RegisterEventHandler(sTimer, "EVENT_SECOND_TIMER")



 --- динамические параметры - они сохраняются в конфиге персонажа
 --- чтобы user.cfg не раздувать, параметры PS из config.txt трогаться не будут и сохранться тоже
 --- таким образом изменение параметров нужно делать только в динамические параметры
 --- тоесть setPS(i)=... === PSD.i=...
local PSD = {}
--- выдает либо динмический параметр либо статический (из config.txt) - с наследование глобальных значений
--- getPS(key) -- будет безнаследования от глобальных паарметров работать
local PSnames = {}
function getPS(key,name)
	local index = name and key..name or key
	--- тут же с наследованием если локального нету параметра ("tbSIZE"), то берем глобальные ("SIZE")
	local val = PSD[index]
	if val then
		--[[if val == "-" and name then
			--- если это прочерк и пареметр подчинен глобальному то возьмем его глобальное значение
			val = getPS(name)
		end
		]]
	elseif PS[index] ~= nil then
		val = PS[index]
	elseif name and PSD[name] ~= nil then
		val = PSD[name]
	elseif name and PS[name] ~= nil then
		val = PS[name]
	else
		val = nil
	end
	 --- если такого параметра нет значения - запомним имя параметра чтобы его выдать в интерфейсе
	if val == nil then
		PSnames[index] = PSnames[index] or "-"
	else
		PSnames[index] = ListParsRef[val] or type(val)
	end
	--- если там таблица - то надо создать объединеную таблицу - глбальные + добавка локальных
	if type(val) == "table" then
		local tab = {}
		for k, v in pairs(name and PS[name] or {}) do
			tab[k] = v
		end
		for k, v in pairs(PS[index] or {}) do
			tab[k] = v
		end
		for k, v in pairs(name and PSD[name] or {}) do
			tab[k] = v
		end
		for k, v in pairs(PSD[index] or {}) do
			tab[k] = v
		end
		return tab
	else
		return val
	end
end
function getPSnames(key)
	return PSnames
end
--- приравнивает к значению
function setPS(index, val)
	PSD[index] = val
end
--- добавляет элементы к таблице
function addPS(index, tab)
	if not PSD[index] then PSD[index] = {} end
	for k, v in pairs(tab) do
		PSD[index][k] = v
	end
end
--- удаляет элементы из таблицы
function remPS(index, tab)
	if PSD[index] then
		for _, k in pairs(tab) do
			PSD[index][k] = nil
		end
	end
end
 --- сам массив динамических параметров дает
function getPSD()
	return PSD
end
function setPSD(val)
	PSD = val
end


function GetErrMessages()
	if IsEmptyTable(errMess) then
		return _
	end
	return errMess
end
------------------------------------------------------------------
------ Loging To Chat
------------------------------------------------------------------
---- output in Chat. created by icreator(EDS) 2011/01/23
--- initial ref
--- Chat...Chat
local wtChat = nil
local chatRows = 0 --- for clear buffer after show messages

--- поиск окна системного чата
--- выдает контейнер чата и главное его окно
function GetSysChatContainer()
	--- найдем окно чата
	--- Chat..Chat
	---local w = getNamedChild(stateMainForm, "Chat", false)
	local parents = 2
	local w = stateMainForm:GetChildUnchecked("Chat", false)
	if not w then
		--- главня форма не найдена - найден по ребенку
		w = stateMainForm:GetChildUnchecked("Chat", true)
	else
		w = w:GetChildUnchecked("Chat", true)
	end
	if not w then ---- 2.0.06.13 [26.05.2011] 
		w = stateMainForm:GetChildUnchecked("ChatLog", false)
		---getAllChildrensOfWidget("ChatLog",w, "PushBack")
		w = w:GetChildUnchecked("Container", true)
		if w then parents = 3 end
	end
	
	return w, wtGetNumParents(w, parents)
end

function LogToChatVT(valuedText, name, toWW)
--- вывод в чат ValuedText
	name = name or ADDONname
	--- выведем в WhisperWindow
	if toWW then LogToChatWWVT(valuedText, name) end
	--- и попробуем вывести в системной чат
	if not wtChat then wtChat = GetSysChatContainer() end
	if wtChat and wtChat.PushFrontValuedText then
		--- запомним что 1 строчку в системный час добавили
		chatRows =  chatRows + 1
		valuedText:SetVal( "addon", userMods.ToWString(name..": ") )
		wtChat:PushFrontValuedText( valuedText )
	end
end
function LogToChatWWVT(valuedText, name)

	local sender = name or ADDONname --- object.GetName(avatar.GetId())
	if not common.IsWString(sender) then sender = userMods.ToWString(sender) end
	local senderId = avatar.IsExist() and avatar.GetId()
	local chatType = CHAT_TYPE_NOTICE --- -1 ---CHAT_TYPE_NOTICE ---CHAT_TYPE_WHISPER --- = -1 --- от аддонов
	local recipient = sender
	userMods.SendEvent("EVENT_CHAT_MESSAGE_WITH_OBJECTS", { msg = valuedText, chatType = chatType, sender = sender, isEcho=true, isAlive=true, recipient = recipient, senderId = senderId})

end

--[[ semd message to chat and WishperWindow chat
 message , color,
 toWW = true|false|nil
]]
function LogToChat(message, color, toWW)

	valuedText:ClearValues() --- обязательно очистим
	valuedText:SetClassVal( "color", color or "LogColorYellow" )
	if not common.IsWString( message ) then	message = userMods.ToWString(message) end
	valuedText:SetVal( "text", message )
	LogToChatVT(valuedText, ADDONname, toWW)

end
--- call by "EVENT_SECOND_TIMER" - for clear messages from chat
function ClearChat( size )
--- очистка контейнара от выведенных нами строк - чтобы он не переполнился
-- и не тормозил потом
	if chatRows < 1 then return end
	if wtChat then
		for i=1, size or math.ceil( chatRows / 30 ) + 1 do
			if chatRows < 1 then return end
			chatRows = chatRows - 1
			wtChat:PopBack()
		end
	else
		wtChat = GetSysChatContainer()
	end
end
------------------------------------------------------------------------------------

--- Log error mess to Chat
function ErrToChat(mess)
	LogToChat("ERROR: "..mess, "LogColorRed")
end

function getAllChildrensOfWidget(tab,widget, metod)
	local childrens = widget:GetNamedChildren()
	for _, w in pairs(childrens) do
		local tab1 = tab .. ":" .. w:GetName()
		if metod and w[metod] then tab1 = tab1 .. " proc.".. metod end
		LogInfo (tab1)
		getAllChildrensOfWidget(tab1,w)
	end
end

function testAllMainForms()
	local childrens = stateMainForm:GetNamedChildren()
	for _, w in pairs(childrens) do
		if string.lower(w:GetName()) == "mainform" then getAllChildrensOfWidget("+",w) end
	end
end

--- выдать ребенка виджета, поиск вглубь или нет
function getNamedChild( w, name, recursive )
	local ch = w:GetChildUnchecked(name, recursive )
	if ch then
		return ch
	else
		LogInfo(" ERROR: can't find widget \"", name,"\" in parent \"", w:GetName(), "\"" )
		LogInfo( w:GetName(), " childs:" )
		for _, ww in pairs(w:GetNamedChildren()) do
			LogInfo (ww:GetName())
		end
	end
end

wtGetAllParents = function(w)
	if w.GetParent then
		local pr = w:GetParent()
		if pr then
			return wtGetAllParents(pr)..":"..w:GetName()
		end
	end
	if w.GetName then return w:GetName() end
	return ""

end

--- возвращает ролителя выше на Номер
wtGetNumParents = function(w, parents)
	if parents > 0 and w.GetParent then
		local pr = w:GetParent()
		---LogInfo( pr:GetName() )
		if pr then
			return wtGetNumParents(pr, parents-1)
		end
	end
	return w
end


function alt_Z()
---AO 2.0:
---:ContextPinMenu2:MainPanel:PinPanelLeft:PinButtonItemMall
---:ContextItemMall
---:WidgetsManagerForm
---:ContextItemMall:ItemMall:Stand:Plate03:Favorites
---old
---:ItemMall:Stand:Plate03:Favorites

	local w, n
	if true then
		n = "ContextDamageVisualization" --- его отключает аддон какойто
		n = "ContextItemMall" --- 7900 priority
		n = "ContextOverlayMap" --- 3200
		w = stateMainForm:GetChildUnchecked(n, false)
		if w then
			----n = mainForm:GetPriority()
			w:AddChild(mainForm)
			----mainForm:SetPriority( n-w:GetPriority() )
			----LogToChat(""..mainForm:GetPriority())
		else
		end
	else
		w = stateMainForm:GetChildUnchecked("PinButtonItemMall", true)
		if w then 
			w = w:GetParent():GetParent():GetParent()
			w:AddChild(mainForm)
		end
	end
end

function wtResize( w, dX, dY )
	local place = w:GetPlacementPlain()
	place.sizeX = place.sizeX + dX
	place.sizeY = place.sizeY + dY
	w:SetPlacementPlain(place)
end

function wtSize( w, sizeX, sizeY )
	local place = w:GetPlacementPlain()
	place.sizeX = sizeX or place.sizeX
	place.sizeY = sizeY or place.sizeY
	w:SetPlacementPlain(place)
end


function wtScale( w, scaleX, scaleY, andChildrens )

	if not w or (scaleX ==1 and scaleY==1) then return end
	local place = w:GetPlacementPlain()
	---LogInfo(w:GetName())
	place.posX = math.ceil(place.posX * scaleX)
	place.highPosX = math.ceil(place.highPosX * scaleX)
	place.posY = math.ceil(place.posY * scaleY)
	place.highPosY = math.ceil(place.highPosY * scaleY)
	if not w.SetVal and not w.GetText then
		----LogInfo("scaled....")
		---- если это не виджеты ValuedText и не EditLine  то можно изменить его размеры
		place.sizeX = math.ceil(place.sizeX * scaleX)
		place.sizeY = math.ceil(place.sizeY * scaleY)
	end
	if w.SetTextScale then
		w:SetTextScale(scaleX)
	end
	w:SetPlacementPlain(place)

	if andChildrens then
		--- всех детишек тоже
		for _, wCh in pairs(w:GetNamedChildren()) do
			wtScale( wCh, scaleX, scaleY, andChildrens )
		end
	end
end

function wtMove( w, shiftX, shiftY, highShiftX, highShiftY )
	local place = w:GetPlacementPlain()
	place.posX = place.posX + shiftX
	place.posY = place.posY + shiftY
	if highShiftX then place.highPosX = place.highPosX + highShiftX end
	if highShiftY then place.highPosY = place.highPosY + highShiftY end
	w:SetPlacementPlain(place)
end

function wtPlace( w, posX, posY, alignX, alignY )
	local place = w:GetPlacementPlain()
	place.posX = posX or place.posX
	place.posY = posY or place.posY
	place.alignX = alignX or place.alignX
	place.alignY = alignY or place.alignY
	w:SetPlacementPlain(place)
end

--- заменяет некоторые значения
function wtSetPlace( w, place )
	local p = w:GetPlacementPlain()
	for k, v in pairs(place) do	
		p[k] = place[k] or v
	end
	w:SetPlacementPlain(p)
end

--- взять абсолютные координаты и размер окна
function wtGetAbsPos( w )
--[[	local p = w:GetPlacementPlain()
	if p.alignX == 0 then
	elseif p.alignX == 1 then p.posX = p.posX + ScreenSize.realSizeX
	elseif p.alignX == 2 then p.posX = p.posX + ScreenSize.realSizeX
	end
	return p.posX, p.posY
--]]
	local rect = w:GetRealRect()

	local place = w:GetPlacementPlain()
	place.alignX = WIDGET_ALIGN_LOW_ABS
	place.alignY = WIDGET_ALIGN_LOW_ABS
	place.posX = rect.x1
	place.posY = rect.y1
	place.highPosX = rect.x2
	place.highPosY = rect.y2
	place.sizeX = place.sizeX or rect.x2 - rect.x1
	place.sizeY = place.sizeY or rect.y2 - rect.y1
	return place
end

--- возвращает размер виджета
function wtGetSizeX(w, p)
--[[ она масштабирует до реальных точек	local rr = w:GetRealRect()
	return rr.x2-rr.x1, rr.y2-rr.y1
--]]
	if not w then return ScreenSize.fullVirtualSizeX end
	if not p then p = w:GetPlacementPlain() end
	--LogIndo(w:GetName(),": sX=", p.sizeX,"  sY=",p.sizeY )

	if p.alignX == 3 then
		local parent = w.GetParent and w:GetParent()
		return wtGetSizeX(parent) - p.posX - p.highPosX
	
	elseif p.alignX == WIDGET_ALIGN_LOW_ABS then
		--exObj2("abs",p)
		return p.sizeX * ScreenSize.fullVirtualSizeX / ScreenSize.realSizeX
	else
		return p.sizeX
	end

end
--- возвращает размер виджета
function wtGetSizeY(w, p)
--[[ она масштабирует до реальных точек	local rr = w:GetRealRect()
	return rr.x2-rr.x1, rr.y2-rr.y1
--]]
	if not w then return ScreenSize.fullVirtualSizeY end
	if not p then p = w:GetPlacementPlain() end
	if p.alignY == 3 then
		local parent = w.GetParent and w:GetParent()
		return wtGetSizeY(parent) - p.posY - p.highPosY
	
	elseif p.alignX == WIDGET_ALIGN_LOW_ABS then
		return p.sizeY * ScreenSize.fullVirtualSizeY / ScreenSize.realSizeY
	else
		return p.sizeY
	end

end

--- таскать за виджетом базовым внутри родительского виджета
function wtAttach(w, wtBase, dx, dy)
	local p = w:GetPlacementPlain()
	local base = wtBase:GetRealRect()
--[[ некатит так как берет координаты всего экрана а у нас виджеты как дети есть
	p.alignX = WIDGET_ALIGN_LOW_ABS
	p.alignY = WIDGET_ALIGN_LOW_ABS
	p.posX = base.x1 + dx
	p.posY = base.y1 + dy
--]]
	local pBase = wtBase:GetPlacementPlain()
	local parentSizeX = wtGetSizeX(wtBase:GetParent())
	local parentSizeY = wtGetSizeY(wtBase:GetParent())
	if pBase.alignX == 1 then
		--- если главный по правому позиционируется то по размеру родителя
		p.posX = parentSizeX - pBase.highPosX - pBase.sizeX + dx
		p.alignX = 0
		p.highPosX = 0
	else
		p.alignX = pBase.alignX
		p.highPosX = pBase.highPosX + dx
		p.posX = pBase.posX + dx
	end
	if pBase.alignY == 1 then
		p.posY = parentSizeY - pBase.highPosY - pBase.sizeY + dy
		p.alignY = 0
		p.highPosY = 0
	else
		p.alignY = pBase.alignY
		p.highPosY =  pBase.highPosY + dy
		p.posY = pBase.posY + dy
	end

	w:SetPlacementPlain(p)
end
--- соединить с виджетом с лева
function wtAttLeft(w, wtBase, dx)
	local p = w:GetPlacementPlain()
--[[	local base = wtBase:GetRealRect()
	p.alignX = WIDGET_ALIGN_LOW_ABS
	p.posX = base.x1 - p.sizeX - dx
	LogToChat(base.x1..":"..p.posX)
--]]
	local pBase = wtBase:GetPlacementPlain()
	local parentSizeX = wtGetSizeX(wtBase:GetParent())
	--- тут надо отосительно своего правого края виджет позиуионировать
	p.alignX = 1
	if pBase.alignX == 1 then
		p.posX=0
		p.highPosX = pBase.highPosX + pBase.sizeX + dx
	else
		p.posX=0
		p.highPosX = parentSizeX - pBase.posX + dx
	end
	p.posY = pBase.posY
	p.highPosY = pBase.highPosY
	p.alignY = pBase.alignY
	w:SetPlacementPlain(p)
end
--- соединить с виджетом справа
function wtAttRight(w, wtBase, dx)
	local p = w:GetPlacementPlain()
--[[	local base = wtBase:GetRealRect()
	p.alignX = WIDGET_ALIGN_LOW_ABS
	p.posX = base.x2 + dx
--]]
	local pBase = wtBase:GetPlacementPlain()
	local parentSizeX = wtGetSizeX(wtBase:GetParent())
	--- тут надо отосительно своего левого края виджет позиуионировать
	p.alignX = 0
	if pBase.alignX == 1 then
		p.posX = parentSizeX - pBase.highPosX + dx
		p.highPosX = 0
	else
		p.posX = pBase.posX + pBase.sizeX + dx
		p.highPosX = 0
	end
	p.posY = pBase.posY
	p.highPosY = pBase.highPosY
	p.alignY = pBase.alignY
	w:SetPlacementPlain(p)
end

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
		p.posX = x+dx
	else
		p.posX = x - dx - p.sizeX
	end
	if yy > y then
		p.posY = y+dy
	else
		p.posY = y - dy - p.sizeY
	end
	w:SetPlacementPlain(p)
end

--- заменяет цвета
function wtSetBColor( w, color )
	local clr = w:GetBackgroundColor()
	for k, v in pairs(color) do	
		clr[k] = color[k] or v
	end
	w:SetBackgroundColor(clr)
end
function wtSetFColor( w, color )
	local clr = w:GetForegroundColor()
	for k, v in pairs(color) do	
		clr[k] = color[k] or v
	end
	w:SetForegroundColor(clr)
end



function wtSetVal( w, v )
	local n = w:GetName()
	if string.sub(n,-4) == "_clr" and w.SetBackgroundColor then w:SetBackgroundColor( v ) return end

	if type(v) == "number" then v = ""..v 
	elseif type(v) == "table" then v = "{table}" 
	end
	if false then
	elseif string.find(n,"_btn") then w:SetVal( "button_label", ToWS(v) ) ---LogToChat(n)
	elseif string.find(n,"_mnu") then w:SetVal( "button_label", ToWS(v) )
	elseif string.find(n,"_edl") or string.find(n,"_edn") then w:SetText( ToWS(v) )
	elseif string.find(n,"_chk") then w:SetVariant( v and 1 or 0 )
	elseif string.find(n,"_cch") then w:SetVariant( v and 1 or 0 ) --- сложный CheckCmplx
	elseif w.SetVal then w:SetVal( "value", ToWS(v) )
	else LogInfo("wtSetVal: unknown widgets type:"..n) errr()
	end
end
function wtGetVal( w )
	local n = w:GetName()
	if	string.find(n,"_chk") then return w:GetVariant() == 1
	elseif 	string.find(n,"_edl") then return ToWS( w:GetText( ) )
	end
end

local function wtReSkin( wt, nameIn )
	local name = nameIn or wt:GetName()
	if string.sub(name,-4) == "_frm" then
		if skin.texture then wt:SetBackgroundTexture(skin.texture) end
		if skin.color then wt:SetBackgroundColor(skin.color ) end
	elseif string.sub(name,-4) == "_btn" then
		if skin.item_texture then wt:SetBackgroundTexture(skin.item_texture) end
		if skin.item_color then wt:SetBackgroundColor( skin.item_color ) end
	--	if skin.item_font then wt:Set----BackgroundColor(skin.color ) end
	end
end

local skinnedWidgets = {}
--- создать виджет по описанию (descr), с именем ( name), для родителя (parent), на месте (place и показать (show)
--- skinOn = true -->
--          _frm +skin.texture  +skin.color
--          _btn +skin.item_texture  +skin.item_color
-- и такие виджеты должны удаляться через тутошнюю wtDestroy( w )
function WCD(descr, name, parent, place, show, skinOn )
	if not descr then LogInfo("ScriptLIB.lua/function WCD(): - Descriptor is nil...") return end
	local n
	n = mainForm:CreateWidgetByDesc( descr )
	if name then n:SetName( name ) else n:SetName( "" ) end
	if parent then parent:AddChild(n) end
	if place then wtSetPlace( n, place ) end
	n:Show( show == true )
	if skinOn then
		--- сразу его формим по одежке
		wtReSkin( n, name )
		--- и запомним чтоо но с оформлением от АТ создано
		--- и по событию его перерисуем
		skinnedWidgets[ GetInstanceId(n) ] = n
	end

	return n
end
function repaint_all_GUI()
	local name
	for ids, wt in pairs(skinnedWidgets) do
		wtReSkin( wt )
	end
end


function W( s, wt ) return getNamedChild(wt or mainForm, s, true) end
--- выдаьт unchecked ребенка вbджета только на это уровне
function Wun0( s, wt) return (wt or mainForm):GetChildUnchecked(s, false) end

function FromWS( str )
	if str then return userMods.FromWString( str ) end
end

function ToWS( str )
	if str then return userMods.ToWString( str ) end
end

---- удалить записи из таблицы
function delRows( tab, rows )
	for k in pairs(rows) do 
		tab[k] = nil
	end
end

--- вернуть разницу таблиц
function subTable( tab1, tab2 )
	local subTab = {}
	for k,v in pairs(tab1) do 
		if tab2[k] ~= v then
			subTab[k] = v
		end
	end
	return subTab
end

--- это пустая таблица?
function IsEmptyTable( tab )
	for _,__ in pairs(tab) do 
		return false
	end
	return true
end

function addTable(tab, add)
	for _, v in pairs(add) do
		table.insert(tab, v)
	end
end

---выдает все поля и значения а так же функции объекта
--- meta=true  - выдает метаданные объекта
--- exclude = "filter string" or { filter_1 = 1, filter_2 = 1, ... }
function exObj(tab,obj,meta, exclude) --- explore an object

	if not tab then tab="nil" end
	---ограничим рекурсию
	if string.len (tab) > 100 then 
		LogInfo (" рекурсия ограничена!")
		return 
	end 

	if meta then
		local metaTable = getmetatable (obj)
		if metaTable then
			exObj(tab.." meta" , metaTable,nil, exclude)
		end
	end
	----LogInfo(tab, "{",type(obj),"}")
	if type(obj) == "table" then
		---- покажем поля (переменные) таблицы
		---if obj == {} then
		---	LogInfo ( tab, "{}")
		---	return
		---	end
		LogInfo(tab, "{")
		for k,v in pairs(obj) do 
			if k == true then k = "[TRUE]" end
			if k == false then k = "[FALSE]" end
			---LogInfo ( tab, k,":=",v,  "{", type (v), "}")
			if k == "__index" then
				--- "__index" - он такую же точно таблицу вложенную имеет что приводит к зацикливанию
				--- поэтому просто выведем список
				---LogInfo(tab, k)
				---for k1,v1 in pairs(v) do 
				---	LogInfo ( tab, k, " - ",k1," = ",v1,"{", type (v1), "}")
				---end
			elseif k == "__gc" then
			elseif k == "_G" then
			elseif k == "parent" or exclude and ( type(exclude) == "table" and exclude[k] or exclude == k ) then
				LogInfo(tab.."."..k.." -> excluded...")
			else
				if "userdata" ~= type(k) then exObj(tab.."."..k , v, nil,exclude)
				else exObj(tab..".userdata" , v, nil, exclude)
				end
			end
		end
		LogInfo(tab, "}")
	elseif type(obj) == "string" then
		LogInfo ( tab, "=\"",obj, "\"")
	elseif common.IsWString(obj) then
		LogInfo ( tab, "=\"",obj, "{WString}")
	elseif type(obj) == "number" then
		LogInfo ( tab, "=",obj)
	else
		LogInfo ( tab, "=",obj, "{", type (obj), "}")
	end
end

---выдает все поля и значения а так же функции объекта
--- meta=true  - выдает метаданные объекта
--- exclude = "filter string" or { filter_1 = 1, filter_2 = 1, ... }
function exObj2(val,obj,meta, exclude, level) --- explore an object

	local tabStr, tab = "   ", ""

	if not level then
		level = 0
	else
		level = level + 1
		tab = string.rep (tabStr, level) --- 
	end

	--if not val then val="nil" end
	---ограничим рекурсию
	if string.len (tab) > 100 then 
		LogInfo (" рекурсия ограничена!")
		return 
	end 
	
	if meta then
		local metaTable = getmetatable (obj)
		if metaTable then
			exObj2("[{meta}]" , metaTable,nil, exclude, level)
		end
	end

	local comma = level == 0 and "" or ","

	----LogInfo(tab, "{",type(obj),"}")
	if type(obj) == "table" then
		---- покажем поля (переменные) таблицы
		---if obj == {} then
		---	LogInfo ( tab, "{}")
		---	return
		---	end

		LogInfo(tab, val," = {")
		local key
		for k,v in pairs(obj) do 
			key = k
			if key == true then key = "[TRUE]" end
			if key == false then key = "[FALSE]" end

			if key == "__index" then
				--- "__index" - он такую же точно таблицу вложенную имеет что приводит к зацикливанию
				--- поэтому просто выведем список
				---LogInfo(tab, k)
				---for k1,v1 in pairs(v) do 
				---	LogInfo ( tab, k, " - ",k1," = ",v1,"{", type (v1), "}")
				---end
			elseif key == "__gc" then
			elseif key == "_G" then
			elseif key == "parent" or exclude and ( type(exclude) == "table" and exclude[key] or exclude == key ) then
				LogInfo(tab..tabStr, "[\""..key.."\"]".." -> excluded...")
			else
				if "userdata" ~= type(k) then exObj2("[\""..key.."\"]", v, nil,exclude,level)
				else exObj2("[{userdata}]", v, nil, exclude,level)
				end
			end
		end
		LogInfo(tab, "}"..( level > 0 and "," or ""))
	elseif type(obj) == "boolean" then
		LogInfo ( tab, val, " = ",obj, comma, " ---{boolean}")
	elseif type(obj) == "string" then
		LogInfo ( tab, val, " = \"",obj, "\"", comma, " ---{string}")
	elseif common.IsWString(obj) then
		LogInfo ( tab, val, " = \"",obj, "\"", comma, " ---{WString}")
	elseif type(obj) == "number" then
		LogInfo ( tab, val, " = ", obj, comma)
	else
		LogInfo ( tab, val, " = ", obj, comma, " --- {", type (obj), "}")
	end
end

function vers_corrupt()
	if 
	true then
			return false
	else return true
	end
end
----------------------------
function IsWs( text )
	return common.IsWString( text )
end
--------------------------------------------------------------------------------
function IsEWs( text )
	return common.IsEmptyWString( text )
end

function GetIndexFromName( name )
	return tonumber( string.sub( name, - 2 ) ), string.sub( name, 1, string.len(name)-2 ) 
end

function IsEqual( value01, value02 )
	if type( value01 ) == "table" and type( value02 ) == "table" then
		local match = true

		for id, value in pairs(value01) do
			match = IsEqual( value, value02[ id ] )
			if match == false then break end
		end
		return match
		
	elseif IsWs( value01 ) and IsWs( value02 ) then
		return common.CompareWString( value01, value02 ) == 0

	else
		return value01 == value02
	end
end
--------------------------------------------------------------------------------
function IsTable( tab )
	return type( tab ) == "table"
end
--------------------------------------------------------------------------------
function CloneNotUserData( value )
	if type( value ) == "table" then
		local new = {}
		for id, val in pairs(value) do
			new[ id ] = CloneNotUserData( val )
		end
		return new
	else
		if type(value) == "string" then
			return ""..value.."" --- клонируем строчку
		elseif type(value) == "userdata" then
			--- юзер дату убьем - виджеты иконки и прочее
			return nil
		end
		--LogInfo(type(value))
		return value
	end
end
function Clone( value )
	if type( value ) == "table" then
		local new = {}
		for id, val in pairs(value) do
			new[ id ] = Clone( val )
		end
		return new
	else
		if type(value) == "string" then
			return ""..value.."" --- клонируем строчку
		end
		return value
	end
end

function SearchInTable( tab, entry )
	if not ( IsTable( entry ) and IsEmptyTable( entry ) ) then
		for id, value in pairs(tab) do
			if IsEqual( entry, value ) then
				return id, value
			end
		end
	end
	return nil
end

--- поиск внктри тблицы в под таблице
function SearchInSubTable( tab, key, entry )
	if not ( IsTable( entry ) and IsEmptyTable( entry ) ) then
		for id, subTab in pairs(tab) do
			if IsEqual( subTab[key], entry ) then
				return id, subTab
			end
		end
	end
	return nil
end

-------------------------------------------------------------------------------
function RegisterEventHandlers( handlers )
	
	for event, handler in pairs(handlers) do
		common.RegisterEventHandler( handler, event )
	end
	
end
function UnRegisterEventHandlers( handlers )
	
	for event, handler in pairs(handlers) do
		common.UnRegisterEventHandler( handler, event )
	end
	
end
-------------------------------------------------------------------------------
function RegisterReactionHandlers( handlers )

	for reaction, handler in pairs(handlers) do
		---LogToChat(reaction)
		common.RegisterReactionHandler( handler, reaction )
	end
end
function UnRegisterReactionHandlers( handlers )

	for reaction, handler in pairs(handlers) do
		---LogToChat("UN:"..reaction)
		common.UnRegisterReactionHandler( handler, reaction )
	end
end

--- собирает ValuedTex
--- параметры - если строковое - то это цвет для class
--- valuedObject - это для ввода в r name
--- все остльное - сторковое в формате всталять
function makeValuedText(format, params )
	local vt = common.CreateValuedText()
	vt:SetFormat(userMods.ToWString(format))
	for k, v in pairs(params) do
		if type(v)=="string" then vt:SetClassVal(k, v)
		else vt:SetVal(k, v)
		end
	end
	return vt
end

function GetGlobalConfig( name )
	local cfg = userMods.GetGlobalConfigSection( common.GetAddonName() ) or {}
	return name == nil and cfg or cfg[ name ]
end
function SetGlobalConfig( name, value )
	local cfg = userMods.GetGlobalConfigSection( common.GetAddonName() ) or {}
	if type( name ) == "table" then
		for i, v in pairs( name ) do cfg[name][ i ] = v end
	elseif name ~= nil then
		cfg[ name ] = value
	end
	userMods.SetGlobalConfigSection( common.GetAddonName(), cfg )
end

--- распаковывает значения в таблицу из конфига по заданному шаблону полей:
--- local key, tab = unpackToTab("проба пера:0|123455|3|2|1|5|", {"MinBid", "Buyout", "StackCount", "TimeSel", "Spread", "RandomCh"} )
--- (устарело так как в названиях появилист ":", теперь ставим там "|"
--- unpackToTab("проба пера|0|123455|3|2|1|5|", {"MinBid", "Buyout", "StackCount", "TimeSel", "Spread", "RandomCh"} )
function unpackToTab(str, pars)
	local _, val, pos, key, sEnd, val2
	_, pos  = string.find(str,"|")
	if not pos then return end
	key = strFromNormalize(string.sub(str,1,pos-1))
	local tab = {}
	sEnd = string.sub(str,pos+1)
	for i, par in ipairs(pars) do
		_, pos = string.find(sEnd,"|")
		if not pos then break end
		val = strFromNormalize( string.sub(sEnd,1,pos-1) )
		sEnd=string.sub(sEnd,pos+1)
		tab[par] = val
	end
	---LogToChat("from norm:"..key, nil, true)
	return key, tab
end
--- запаковывает таблицу по шаблону полей для сохранения в конфиг
function packFromTab(key, tab, template)
	local str = strToNormalize(key).."|"
	for i, v in pairs(template) do
		str = tab[v] and str.. strToNormalize( ""..(tab[v] or "") ) .."|"
	end
	---LogToChat("to norm:"..str, nil, true)
	return str
end

strToNormalize = function ( str )
	local res = ""
	local char
	for i=1, string.len( str ) do
		char = string.sub(str, i, i)
		if char == '"' then char = "'" end
		res = res .. char
	end
	return res
end
strFromNormalize = function ( str )
	local res = ""
	local char
	for i=1, string.len( str ) do
		char = string.sub(str, i, i)
		if char == "'" then char = '"' end
		res = res .. char
	end
	return res
end


--- возвращает состояние заданного аддона
getStateAddon = function ( name )
	local nn = "UserAddon/"..name
	for i, addon in pairs(common.GetStateManagedAddons()) do
		if addon.name == nn then
			return addon.isLoaded
		end
	end
end
--- возвращает состояние заданного системного аддона
getStateSysAddon = function ( name )
	local nn = name
	for i, addon in pairs(common.GetStateManagedAddons()) do
		if addon.name == nn then
			return addon.isLoaded
		end
	end
end

--- Возвращает два числа, Целую чать x и дробную часть x.
--- 123.45 = 123, 45
function modf100( x )
	local f = math.floor(x)
	return f, math.floor((x - f) * 100) /100
end
--- вернет уже две строки с точкой у целой части
function modf100string( x )
	local f, m = modf100( x )
	return f..".", string.format("%02d",m*100) ---string.sub( string.format("%02d",m),3)
end

----------------------------------------------------------------------------- CLASS CONSTRUCTOR
function addmetatable( tab, mt )
	local _mt = getmetatable( tab )
	_mt = type( _mt ) == "table" and _mt or {}
	
	for k, v in pairs(mt) do
		_mt [ k ]  = v
	end
	
	setmetatable( tab, _mt )
end

-- ScriptClassesImplementation.lua
-- from Interface.1.0.03.26.2\Common\Script
-- REQUIRES: ScriptStandardExtension.lua
--------------------------------------------------------------------------------
do
	local constructor = function( cl, object )
		local object = object or {}
		addmetatable( object, { __index = cl } )
		return object
	end
	------------------------------------------------------------------------------
	function class( proto )
		addmetatable( proto, { __call = constructor } )
		return proto
	end
	------------------------------------------------------------------------------
	function Class( name, object )
		Global( name, class( object ) )
	end
end
--------------------------------------------------------------------------------


local function getVersionAO1()
	if false then
	elseif avatar.GetInventoryOverflowSize then return 3 --- 2.0.08.12 [3.08.2011]  Атолл
	elseif stateMainForm:GetChildUnchecked("ChatLog", false) then ---- 2.0.06.13 [26.05.2011]
		local w = stateMainForm:GetChildUnchecked("RollGreedNeed", false)
		if w and w:GetChildUnchecked( "ItemSlot", true ) then --- --- 2.0.08.12 [3.08.2011]  Атолл
			return 3
		elseif w and w:GetChildUnchecked( "Icon", true ) then
			return 2
		end
	elseif stateMainForm:GetChildUnchecked("Chat", false) then
		return 1 -- тут уже Чат.Чат был
	elseif stateMainForm:GetChildUnchecked("Chat", true) then
		return 0 --- тут еще mainForm у чата был
	end
	return -1
end
local versAO = getVersionAO1()
function getVersionAO()
	return versAO
end

local sysItemQualityStyle = {
	[ ITEM_QUALITY_JUNK ] = "Junk", ---1
	[ ITEM_QUALITY_GOODS ] = "Goods", ---2
	[ ITEM_QUALITY_COMMON ] = "Common", ---3
	[ ITEM_QUALITY_UNCOMMON ] = "Uncommon", ---4 - синяя
	[ ITEM_QUALITY_RARE ] = "Rare", --- 5 - оранж
	[ ITEM_QUALITY_EPIC ] = "Epic", --- 6 - салат
	[ ITEM_QUALITY_LEGENDARY ] = "Legendary", --- 7 - из ГД
	[ ITEM_QUALITY_RELIC ] = "Relic" --- 8
	}
function getSysItemQualityStyle( quality, isCursed )
	return sysItemQualityStyle[ quality ] .. ( isCursed and "Cursed" or "")
end

------------------------------------------------
------------------------------------------------
--- itemLib -----------
-- патч 4.0.01.14++

function NameFromHTML( strIn )
--Info: addon AucEDSman:    ["name"] = "<html><t href="/Mechanics/Ships/TextFragments/Names/Crystals/Crystal_Common_Cap.txt"/> <t href="/Mechanics/Ships/TextFragments/Names/BeamCannon_Par.txt"/> <t href="/Mechanics/Ships/TextFragments/Names/BeamCannons/3.txt"/>/<t href="/Mechanics/Ships/TextFragments/Names/BeamCannons/4.txt"/> <t href="/Mechanics/Ships/TextFragments/Names/Generations/1.txt"/></html>", ---{WString}

	--LogInfo("<html>...")
	local str = FromWS(strIn) ---  вновой версии FromWS убивает формат и выдает текст готовый
	if "<html>" == string.sub( str, 1, 6 ) then
		local nameVT
		nameVT = common.CreateValuedText()
		nameVT:SetFormat( str )
		return common.ExtractWStringFromValuedText( nameVT ), nameVT
	else
		return ToWS(str)
	end

end

local _avaItem, _itemLib
if avatar.GetItemInfo then _avaItem = true end
if not _avaItem and itemLib.GetItemInfo then _itemLib = true end

--old vers info: level, name, quality, dressSlot, source, itemMallType
--[[
avatar.GetItemMetaInfo( itemId ).hasMetaState - true если это основа.
avatar.GetItemMetaInfo( itemId ).isMetaEnchancer - true если это улучшитель, при условии что это не основа.
improvement = 0...99

ENUM_ItemSource_Quest
ENUM_ItemSource_FixedDrop
ENUM_ItemSource_WorldDrop
ENUM_ItemSource_Crafted
ENUM_ItemSource_Conjured
ENUM_ItemSource_Vendor
ENUM_ItemSource_QuestItem
]]
-- new vers itemLib.info: level, name, (quality), dressSlot, (source), (itemMallType)
--[[
itemLib.GetSource( itemId )
itemMall.GetItemType( itemId )
]]
function GetItemInfo( itemId )
	local itemInfo
	if false then
	elseif _avaItem then
		itemInfo = avatar.GetItemInfo( itemId )
	elseif _itemLib then
 --[[
  id: ObjectId (not nil) - идентификатор предмета
  name: WString - название предмета
  description: ValuedText or nil - описание с подставленными текущими значениями параметров
  dressSlot: number (enum) - слот одежды или оружия, если предмет надевается: DRESS_SLOT_XXXX
  sysName: string - специальные интерфейсные особенности предмета.
  level: number (integer) - уровень предмета
  requiredLevel: number (integer) - уровень персонажа, необходимый для ношения предмета
  requiredReputationLevel: number (enum REPUTATION_LEVEL_...) - уровнь репутации, необходимый для покупки предмета
  isRitual: boolean - является ли предмет ритуальным (надевается, если игрок прошел ритуал и лежит в контейнере ITEM_CONT_EQUIPMENT_RITUAL)
  debugName: string - путь к файлу описания предмета (отладочная информация)
  icon: TextureId - текстура с иконкой предмета (доступно только в UI)
]]
		itemInfo = itemLib.GetItemInfo( itemId )
	end

	--exObj2("itemInfo", itemInfo)
	--- некоторы имена теперь содержат ШТМЛ код - надо оттуда его выцепить
	local name, nameVT = NameFromHTML(itemInfo.name)
	--LogInfo(name, ":",nameVT)
	itemInfo.name = name
	itemInfo.nameVT = nameVT

	--- имя с учетом качества и проч. - чтобы небыло путанницы товаров с одниковым именем и разным качеством
	local metaInfo = (avatar.GetItemMetaInfo or itemLib.GetMetaInfo)( itemId )
	itemInfo.nameOrig = itemInfo.name
	itemInfo.name = string.format("%02d ",itemInfo.level or 0)
		..FromWS(itemInfo.name) 
		.. " ".. (itemLibGetQuality( itemId, itemInfo) or "X")
		.. "-".. (metaInfo and ( (metaInfo.hasMetaState and "1" or "0")
				..(metaInfo.isMetaEnchancer and "1" or "0")
				--..(metaInfo.improvement)
					)
				or "")
	-- пока тут только НИЛ	.. "-".. (itemLibGetSource( itemId, itemInfo) or "??")

	itemInfo.name = ToWS(itemInfo.name) 
	--LogInfo(itemInfo.name)

	return itemInfo
end

function itemLibGetSource( itemId, itemInfo )
	local info
	if false then
	elseif _avaItem then
		info = itemInfo or avatar.GetItemInfo( itemId )
		return info.sourse --- before 4.0.01
	elseif _itemLib then
		return itemLib.GetSource( itemId )
	end

end

function itemLibGetStackInfo( itemId, itemInfo )

	local info
	if false then
	elseif _avaItem then
		info = itemInfo or avatar.GetItemInfo( itemId )
		return { count = info.stackCount, limit = info.stackLimit } --- before 4.0.01
	elseif _itemLib then
		return itemLib.GetStackInfo( itemId )
	end

end

function itemMallGetItemType( itemId, itemInfo )
	local info
	if false then
	elseif _avaItem then
		info = itemInfo or avatar.GetItemInfo( itemId )
		return info.itemMallType --- before 4.0.01
	elseif itemMall.GetItemType then
		return itemMall.GetItemType( itemId )
	end

end

function itemLibGetQuality( itemId, itemInfo )
	local info
	if false then
	elseif _avaItem then
		info = itemInfo or avatar.GetItemInfo( itemId )
		return info.quality --- before 4.0.01
	elseif _itemLib then
		return itemLib.GetQuality( itemId ).quality
	end

end

function itemLibIsCursed( itemId, itemInfo )
	local info
	if false then
	elseif _avaItem then
		info = itemInfo or avatar.GetItemInfo( itemId )
		return info.isCursed --- before 4.0.01
	elseif _itemLib then
		return itemLib.IsCursed( itemId )
	end

end

function itemLibGetPriceInfo( itemId, itemInfo )
	local info
	if false then
	elseif _avaItem then
		info = itemInfo or avatar.GetItemInfo( itemId )
		return info --- before 4.0.01
	elseif _itemLib then
		return itemLib.GetPriceInfo( itemId )
	end

end

function itemLibGetBindingInfo( itemId, itemInfo )

	local info
	if false then
	elseif _avaItem then
		info = itemInfo or avatar.GetItemInfo( itemId )
		return info --- before 4.0.01
	elseif _itemLib then
		return itemLib.GetBindingInfo( itemId )
	end

end

function itemLibGetOverallStackCount( itemId, itemInfo )

	local info
	if false then
	elseif _avaItem then
		info = itemInfo or avatar.GetItemInfo( itemId )
		return info.overallStackCount --- before 4.0.01
	elseif _itemLib then
		return itemLib.GetOverallStackCount( itemId )
	end

end


function itemLibIsQuestOperator( itemId, itemInfo )

	local info
	if false then
	elseif _avaItem then
		info = itemInfo or avatar.GetItemInfo( itemId )
		return info.isQuestOperator --- before 4.0.01
	elseif _itemLib then
		return itemLib.IsQuestOperator( itemId )
	end

end

function itemLibIsQuestRelated( itemId, itemInfo )

	local info
	if false then
	elseif _avaItem then
		info = itemInfo or avatar.GetItemInfo( itemId )
		return info.isQuestRelated --- before 4.0.01
	elseif _itemLib then
		return itemLib.IsQuestRelated( itemId )
	end

end

function itemLibGetTemporaryInfo( itemId, itemInfo )

	local info
	if false then
	elseif _avaItem then
		info = itemInfo or avatar.GetItemInfo( itemId )
		return info.temporaryInfo --- before 4.0.01
	elseif _itemLib then
		return itemLib.GetTemporaryInfo( itemId )
	end

end
 
--ItemId - id ресурса предмета (ResourceId); можно сравнивать с другими ItemId (см. :IsEqual) и получать информацию о нём (см. avatar.GetItemResourceInfo( itemResourceId ))
--avatar.GetItemResourceId( itemId )
function GetItemResourceId( itemId )
	return (avatar.GetItemResourceId or itemLib.GetResourceId)( itemId )
end


----------------------- обработка эффектоа окон иначе они при удажении ошибки дают
-------------------------------------------------------------------------------------
--- список что окно в эффекте пока находится и его нельзя удалять иначе по всем аддонам ошибка
local wtEFFS = { } ---funcs = {}, deals = {} --- список чего делать с виджетом при эффектах - а в конце можно и убить
--[[
ET_MOVE - эффект изменения Placement виджета
ET_FADE - эффект изменения прозрачности виджета/текста
ET_RESIZE - эффект изменения размеров виджета
ET_TEXTURE_ROTATION - эффект изменения угла поворота FrontLayer виджета
ET_TEXT_SCALE - эффект изменения размера текста, только для TextView
]]
function wtEFFSfuncAdd(wt, func)
	local ID = GetInstanceId(wt)
	if not wtEFFS[ ID ] then wtEFFS[ ID ] = { wt = wt, effs = {}, funcs = {} } end
	table.insert( wtEFFS[ ID ].funcs, func )
end
function wtEFFSfuncClear(wt)
	local ID = GetInstanceId(wt)
	if not wtEFFS[ ID ] then return end
	wtEFFS[ ID ].funcs = {}
end

--local registeregIntegers = {} --- толку от этого 0 -
local function wtDoEffect( wt, type )
	local ID = GetInstanceId(wt)
--	--- запомним его уникальный интежер - чтобы потом на приход окончани эффекта проверить
--	--- а не удален ли виджет?
--	registeregIntegers[ common.RequestIntegerByInstanceId( ID ) ] = 1
	if not wtEFFS[ ID ] then wtEFFS[ ID ] = { wt = wt, effs = {}, funcs = {} } end
	wtEFFS[ ID ].effs[type] = 1
	--exObj2( "wtEFFS", wtEFFS )
end

function wtIsInEffect( wt, type )
	local ID = GetInstanceId(wt)
	local wtTab = wtEFFS[ ID ]
	return wtTab and wtTab.effs[type]
end

local function wtFinishEffect( wt, type )
	if false then
	elseif type == ET_FADE then wt:FinishFadeEffect()
	elseif type == ET_MOVE then wt:FinishMoveEffect()
	elseif type ==ET_RESIZE then wt:FinishResizeEffect()
	elseif type == ET_TEXTURE_ROTATION then wt:FinishRotationEffect()
	elseif type == ET_TEXT_SCALE then wt:FinishTextScaleEffect()
	end
end

function wtPlayFadeEffect( wt, fromP, toP, time1, algor )
	wtDoEffect( wt, ET_FADE )
	wt:PlayFadeEffect(fromP, toP, time1, algor )
end
function wtPlayMoveEffect( wt, fromP, toP, time1, algor )
	wtDoEffect( wt, ET_MOVE )
	wt:PlayMoveEffect(fromP, toP, time1, algor )
end
function wtPlayResizeEffect( wt, fromP, toP, time1, algor )
	wtDoEffect( wt, ET_RESIZE )
	wt:PlayResizeEffect(fromP, toP, time1, algor )
end
function wtPlayRotationEffect( wt, fromP, toP, time1, algor )
	wtDoEffect( wt, ET_TEXTURE_ROTATION )
	wt:PlayRotationEffect(fromP, toP, time1, algor )
end
function wtPlayTextScaleEffect( wt, fromP, toP, time1, algor )
	wtDoEffect( wt, ET_TEXT_SCALE )
	wt:PlayTextScaleEffect(fromP, toP, time1, algor )
end

--- айти хотябы 1 эффект у детей
local function getChildsEFFs( wt )
	local ID = GetInstanceId(wt)
	local wtTab = wtEFFS[ID]
	if wtTab and GetTableSize(wtTab.effs) ~= 0 then
		return ID, wtTab
	end

	for i, wCh in pairs(wt:GetNamedChildren()) do
		ID, wtTab = getChildsEFFs( wCh )
		if wtTab then
			--- если есть эффект у детей
			return ID, wtTab
		end
	end
end

local resumeDestroy = {}
local function DestroyWidget0( wt )
	--- удалим его и памяти если он с оформлением по событию
	skinnedWidgets[ GetInstanceId(wt) ] = nil
	wt:DestroyWidget()
end
function wtDestroy( wt )
--- тут надо проверить - нет ли для этого виджета активных эффектов или функций на эффекты
--- и удалять только если все пусто

---а тут же надо по всем детям проверять!!!!!!!!!!!!!
--- в эффекте то дети находятся
	local childID, childTab = getChildsEFFs( wt )
	if childID then
		--- нашли первого ребенка с эффектом
		--- принудительно обрубим все у него
		childTab.funcs = {}
		for type,_ in pairs(childTab.effs) do
			wtFinishEffect( childTab.wt, type )
			childTab.effs[type] = nil
		end
		--- продолжим поиск детей с эффектами
		wtDestroy( wt )
		return
	end
	
	--- нет эффектов ни у него ни у детей - удаляем сразу
	if not childID then
		--LogInfo("DestroyWidget  "..wt:GetName())
		--LogToChat("DestroyWidget  "..wt:GetName())

		--- и все равно нужно с небольшой задержкой их удалять ибо иначе
		--- ошибка вылазит
		ToDo_Add1(2, DestroyWidget0, wt)
	else
		--- иначе сначал погасим и дадим задание в конце удалить
		--LogInfo("DestroyWidget --- resume  "..wt:GetName())
		--LogToChat("DestroyWidget --- resume  "..wt:GetName())
		--wt:Show( false )
		LogToChat("сюда не олжно приходить даже")

		resumeDestroy[childID] = wt

	end
end

onEVENT_EFFECT_FINISHED_lib = function( pars )
	local wId = GetInstanceId( pars.wtOwner )
	if not wId then return end

	--LogInfo("onEVENT_EFFECT_FINISHED_lib")
	local type = pars.effectType
	local wtTab = wtEFFS[wId]

	if not wtTab then return end
	--- запомним чо эффект закончился
	wtTab.effs[ type ] = nil

	--- эсли этот ребенок мешал удалению то попробуем еще раз удалить
	local wtResume = resumeDestroy[wId]
	if wtResume then
		resumeDestroy[wId] = nil
		wtDestroy( wtResume )
		return
	end

	--- тут индексированный массив чтобы последовательность функций сохранялась
	local func = table.remove( wtTab.funcs, 1 )
	if func then func( pars.wtOwner )
	else
	end

end
----------------------------------------------------------

function GetInstanceId( wt )
	return wt:IsValid() and wt:GetInstanceId() or wt:Show( false ) and nil
end


function makeFontFormatFromVal( vN, val )
	if not val then return ""
	elseif type( val ) == "table" then
		return vN.."='0x"
			..string.format("%02X",(val.a or 1)*255) --- color="0xFFFF771F"
			..string.format("%02X",(val.r or 1)*255)
			..string.format("%02X",(val.g or 1)*255)
			..string.format("%02X",(val.b or 1)*255)
			.."' "
	end
	return vN.."='"..val.."' "
end

--"fontsize", "fontname", "outline", "shadow", "alignx", "aligny", "color", "shadowcolor", "outlinecolor"
function makeFontFormatFromTab( tab, rName )
	if not tab then return end

	local str, v, vN = "<html "

	for key, val in pairs(tab) do
		str = str .. makeFontFormatFromVal( key, val)
	end
	str = str.." ><r name='"..(rName or "value").."'/></html>"
	return str 
end

function SizeInside( w, wt, dxy )
	local p = wt:GetPlacementPlain()
	local pp = w:GetPlacementPlain()
	pp.sizeX = p.sizeX + 2*dxy
	pp.sizeY = p.sizeY + 2*dxy
	wtSetPlace(w, pp )
end
function PlaceInside( w, wt, dxy )
	local p = wt:GetPlacementPlain()
	local pp = Clone ( p )
	pp.sizeX = p.sizeX + 2*dxy
	pp.sizeY = p.sizeY + 2*dxy
	pp.posX = p.posX - dxy
	pp.posY = p.posY - dxy
	w:SetPlacementPlain( pp )
	w:AddChild( wt )
	--wtSetPlace(wt, { posX = dxy, posY = dxy, highPosX = dxy, highPosY = dxy, alignX = 3, slignY = 3})
	wtSetPlace(wt, { posX = 0, posY = 0, highPosX = 0, highPosY = 0, alignX = 2, slignY = 2})
end

function NormalizePlacement( wt, PlaceIn )
	local Place = PlaceIn or wt:GetPlacementPlain()
	local wtParent = wt:GetParent()
	--exObj2("Place", Place )
	local sizeXparent, sizeYparent = wtGetSizeX(wtParent), wtGetSizeY(wtParent)
	--LogInfo("sizeXparent, sizeYparent", sizeXparent,", ", sizeYparent)
	local sizeX = wtGetSizeX(wt)
	local sizeY = wtGetSizeY(wt)
	--LogInfo("sizeX, sizeY", sizeX,", ", sizeY)

	if Place.posX + sizeX > sizeXparent then
		Place.posX = sizeXparent - sizeX end
	if Place.posY + sizeY > sizeYparent then
		Place.posY = sizeYparent - sizeY end
	if Place.posX < 0 then Place.posX = 0 end
	if Place.posY < 0 then Place.posY = 0 end

	wt:SetPlacementPlain( Place )
	return Place
end

--LogInfo("PS.ShipPlatePlace",PS)
