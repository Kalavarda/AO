--------------------------------------------------------------------------------
-- GLOBAL		Объяввляем переменные и массивы
--------------------------------------------------------------------------------
Global( "ShowHelpText", 1 ) -- показывать подсказку при наведении на кнопку [Будильник] (1-вкл/0-выкл)
Global( "ShowIconFlash", 0 ) -- включение мигание иконкой в панели задач до момента получения приложением фокуса (1-вкл/0-выкл)

local DB_RememberDate_arr = {} -- массив с датой из настроек
local DB_RememberName_arr = {} -- массив с текстом напоминалки из настроек
local DB_RememberValueWidget_arr = {} -- массив с именем виджета планки из настроек
local DB_RememberDateRepeat_arr = {} -- массив с пометкой разовая или ежедневная напоминалка
--

local DB_RememberNameTime_arr = {} -- массив с текстом напоминалки из настроек (время в качестве ключа)

--local der = 0

local MsDayStart = 0 -- количество миллисекунд на начало дня

local wdt = {} -- массив с виджетами
local var = {} -- массив с переменными

local AddonName = common.GetAddonName()



--------------------------------------------------------------------------------
-- EVENT HANDLERS		Тело с функциями (основное рабочее пространство)
--------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Функция Расчета ближайшего напоминания (сортировка массива) (по таймеру)
function RememberDateMath()

	local array, result = {}
	
	--for key, val in pairs(DB_RememberDate) do
	for key, val in pairs(DB_RememberDate_arr) do
		--table.insert( array, tonumber(val))
		if val > 0 then
			table.insert( array, tonumber(val))
		end
	end
	
	-- Функция-условие для сортировки массива
	result = function( a, b )
		return a > b
	end

	--Сортируем массив по условию и перебираем его
	table.sort( array, result )
	for key, val in pairs(array) do
		local TimeStop = val
		
		local TimeNamew = tonumber(val)
		--local TimeName = DB_RememberName_arr[TimeNamew]
		local TimeName = DB_RememberNameTime_arr[TimeNamew]
		
		RememberDateView( TimeStop, TimeName )
	end

end


---------------------------------------------------------------------------------------------------
-- Функция Отображения напоминания
function RememberDateView( TimeStop, TimeName )

	-- Смотрим сегодняшнюю дату и количество миллисекунд на начало дня
	local LocalDateTime = common.GetLocalDateTime()
	-- Получаем текущую дату в милисекундах со дня рождения unix (1-го января 1970-го года)
	local TimePresent = common.GetMsFromDateTime( LocalDateTime )
	
	
	-- Если текущее время больше чем начало + плюс сутки + 30 секунд то обновляем начало дня
	if MsDayStart+86430000 > TimePresent then
		MsDayStart = common.GetMsFromDateTime( {y=LocalDateTime.y, m=LocalDateTime.m, d=LocalDateTime.d} )
	end
	
	
	local TimeStopWarningYellow = 1800000 --//30 мин
	local TimeStopWarninRed = 600000 --//10 мин
	
	--local TimeStopWarning = 432000000 --//5 суток
	--local TimeStopWarningT = TimeStop - TimeStopWarning
	
	local TimeStopWarningTT = TimeStop - TimePresent
	local TimeStopWarningTTT = OnEventFormatDateView( TimeStopWarningTT )
	
	local style
	if (TimeStopWarningTT < TimeStopWarninRed) and (TimeStopWarningTT > 0) then
		style = "ColorRed"
	end
	if (TimeStopWarningTT < TimeStopWarningYellow) and (TimeStopWarningTT > TimeStopWarninRed) then
		style = "ColorGreen"
		
	end
	if (TimeStopWarningTT > TimeStopWarningYellow) then
		style = "ColorBlack"
	end
	
	
	if TimeStopWarningTT < 0 then
		wdt.RememberViewText:SetVal( "myrmyr", "" )
		return
	end
	
	if not TimeName or TimeName =="" or TimeName ==" " then
		TimeName = "non"
	end
	
	
	local text = TimeName..": "..TimeStopWarningTTT
	
	wdt.RememberViewText:SetClassVal( "class", style )
	wdt.RememberViewText:SetVal( "myrmyr", text )
	--wdt.RememberViewText:SetTextColor( nil, { a = 0.5, r = 0, g = 0, b = 1 }, ENUM_ColorType_SHADOW )
	--wdt.RememberViewText:SetTextColor( nil, { a = 0.5, r = 0, g = 0, b = 1 }, ENUM_ColorType_OUTLINE )
	

	
	--local text = TimeName.." "..TimeStopWarningTTT
	--Log(text, style, 14)
	
	--wt.TitleText:SetClassVal( "class", "ColorGreen" )
	--wt.TitleText:SetVal( "myrmyr", "д" )
	
	--[[W( 'AnnounceT' ):SetClassVal( "class", style )
	W( 'AnnounceT' ):SetVal( "myrmyr", "ч" )
	W( 'AnnounceT' ):Show( true )]]
	
	-- Включение мигание иконкой в панели задач до момента получения приложением фокуса (1-вкл/0-выкл)
	if ShowIconFlash == 1 then
		-- Вызывает мигание иконкой в панели задач до момента получения приложением фокуса
		if TimeStopWarningTT == 60000 then -- 1 мин
			common.SetIconFlash( 3 )
		elseif TimeStopWarningTT <= 5000 then -- 5 сек и меньше
			common.SetIconFlash( 3 )
		end
	end

end


---------------------------------------------------------------------------------------------------
-- Функция Форматирования даты вывода напминалки
function OnEventFormatDateView( dateView )

	-- Создаем
	local FormatDateView = 0
	
	if (dateView < 0) then
		FormatDateView = 0
		return FormatDateView
	end
	
	
	local Ksek = 1000
	local Kmin = 60000
	local Kh = 3600000
	local Kd = 86400000
	local Km = Kd*30
	
	local DateTimeFromMs = {}
		--DateTimeFromMs.m = math.floor(dateView / Km)
		--DateTimeFromMs.d = math.floor((dateView-(DateTimeFromMs.m*Km)) / Kd)
		--DateTimeFromMs.h = math.floor((dateView-(DateTimeFromMs.d*Kd)-(DateTimeFromMs.m*Km)) / Kh)
		--DateTimeFromMs.min = math.floor((dateView-(DateTimeFromMs.h*Kh)-(DateTimeFromMs.d*Kd)-(DateTimeFromMs.m*Km)) / Kmin)
		--DateTimeFromMs.s = math.floor((dateView-(DateTimeFromMs.min*Kmin)-(DateTimeFromMs.h*Kh)-(DateTimeFromMs.d*Kd)-(DateTimeFromMs.m*Km)) / Ksek)
		
		
		-- НОВЫЙ АЛГАРИТМ РАСЧЕТА
		DateTimeFromMs.m = 0
		DateTimeFromMs.d = math.floor(dateView / Kd)
		
		
		-- Смотрим сегодняшнюю дату и количество миллисекунд на начало дня
		local LocalDateTime = common.GetLocalDateTime()

		-- Задаем стартовые месяц и год
		local month, year = LocalDateTime.m, LocalDateTime.y
		-- Записываем сколько дней до окончания
		local day = DateTimeFromMs.d
		-- Сюда будем писать итоги
		local monthTotal, ddd = 0, 0
		
		-- Перебираем пока дней не будет меньше 30 (меньше месяца)
		while day >30 do
			-- Если месяцев больше 12 то обнуляем счетчик месяцев и прибавляем год
			if month > 12 then
				month = 1
				year = year+1
			end
		
			-- Смотрим сколько дней в указанном месяце
			local DaysCountInMonth = mission.GetMonthDaysCount( month, year )
			-- Вычитаем из общего количество дней дни месяца
			day = day-DaysCountInMonth 
			-- Закидываем в месяцы +1 (счетчик месяцев)
			month = month+1
			
			-- Записываем сколько всего месяцев отсчитал
			monthTotal = monthTotal+1
		end
		local dddc = day
		
		
		DateTimeFromMs.h = math.floor((dateView-(DateTimeFromMs.d*Kd)-(DateTimeFromMs.m*Km)) / Kh)
		DateTimeFromMs.min = math.floor((dateView-(DateTimeFromMs.h*Kh)-(DateTimeFromMs.d*Kd)-(DateTimeFromMs.m*Km)) / Kmin)
		DateTimeFromMs.s = math.floor((dateView-(DateTimeFromMs.min*Kmin)-(DateTimeFromMs.h*Kh)-(DateTimeFromMs.d*Kd)-(DateTimeFromMs.m*Km)) / Ksek)
	
		DateTimeFromMs.m = monthTotal
		DateTimeFromMs.d= day
	
	
	--local DateTimeFromMs = common.GetDateTimeFromMs( dateView )
	
	if (DateTimeFromMs.m > 0) then
		FormatDateView = DateTimeFromMs.m.."м. "..DateTimeFromMs.d.."дн. "..DateTimeFromMs.h.."ч. "..string.format( "%02d", DateTimeFromMs.min).."мин."
		--FormatDateView = DateTimeFromMs.m.."м. "..DateTimeFromMs.d.."дн. "..DateTimeFromMs.h..":"..string.format( "%02d", DateTimeFromMs.min).." "
	end
	if (DateTimeFromMs.d > 0) and (DateTimeFromMs.m <= 0) then
		FormatDateView = DateTimeFromMs.d.."дн. "..DateTimeFromMs.h.."ч. "..string.format( "%02d", DateTimeFromMs.min).."мин."
		--FormatDateView = DateTimeFromMs.d.."дн. "..DateTimeFromMs.h..":"..string.format( "%02d", DateTimeFromMs.min).." "
	end
	if (DateTimeFromMs.h > 0) and (DateTimeFromMs.d <= 0) and (DateTimeFromMs.m <= 0) then
		FormatDateView = DateTimeFromMs.h.."ч. "..string.format( "%02d", DateTimeFromMs.min).."мин."
		--FormatDateView = DateTimeFromMs.h..":"..string.format( "%02d", DateTimeFromMs.min).." "
	end
	if (DateTimeFromMs.min > 0) and (DateTimeFromMs.h <= 0) and (DateTimeFromMs.d <= 0) and (DateTimeFromMs.m <= 0) then
		FormatDateView = DateTimeFromMs.min.."мин."
	end
	if (DateTimeFromMs.s > 0) and (DateTimeFromMs.min <= 0) and (DateTimeFromMs.h <= 0) and (DateTimeFromMs.d <= 0) then
		FormatDateView = DateTimeFromMs.s.."сек."
	end
	
	
	return FormatDateView

end


---------------------------------------------------------------------------------------------------
-- Функции Локализации аддона и присвоения надписей (по входу в игру. Смотри парпку Locales)
function LangSetup( locale )

	InitLocalText( locale )
	--W( 'HeaderTextPanelSettingsAddon' ):SetVal( 'value', userMods.ToWString(L[ 'AddonName' ]) )
	mainForm:GetChildChecked( "HeaderTextPanelSettingsAddon", true ):SetVal( 'value', userMods.ToWString(L[ 'AddonName' ]) )
	mainForm:GetChildChecked( "ButtonSave", true ):SetVal( 'button_label', userMods.ToWString(L[ 'Save' ]) )
	
	
	--mainForm:GetChildChecked( "TitleTextD", true ):SetClassVal( "class", "ColorGreen" )
	mainForm:GetChildChecked( "TitleTextD", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 0 } )
	mainForm:GetChildChecked( "TitleTextD", true ):SetVal( "TitleTextT", "д" )
	
	--mainForm:GetChildChecked( "TitleTextM", true ):SetClassVal( "class", "ColorGreen" )
	mainForm:GetChildChecked( "TitleTextM", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 0 } )
	mainForm:GetChildChecked( "TitleTextM", true ):SetVal( "TitleTextT", "м" )
	
	--mainForm:GetChildChecked( "TitleTextH", true ):SetClassVal( "class", "ColorGreen" )
	mainForm:GetChildChecked( "TitleTextH", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 0 } )
	mainForm:GetChildChecked( "TitleTextH", true ):SetVal( "TitleTextT", "ч" )
	
	--mainForm:GetChildChecked( "TitleTextMin", true ):SetClassVal( "class", "ColorGreen" )
	mainForm:GetChildChecked( "TitleTextMin", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 0 } )
	mainForm:GetChildChecked( "TitleTextMin", true ):SetVal( "TitleTextT", "мин" )
	
	--mainForm:GetChildChecked( "TitleTextName", true ):SetClassVal( "class", "ColorGreen" )
	mainForm:GetChildChecked( "TitleTextName", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 0 } )
	--mainForm:GetChildChecked( "TitleTextName", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 1 }, ENUM_ColorType_SHADOW )
	mainForm:GetChildChecked( "TitleTextName", true ):SetVal( "TitleTextT", "наименование" )
	
	
	mainForm:GetChildChecked( "ButtonClear", true ):SetVal( 'button_label', userMods.ToWString( "x" ) )
end


---------------------------------------------------------------------------------------------------
-- Функция Запуска/остановки аддона (по клику на кнопку)
function StartRemember()
	
	if not wdt.RememberViewText:IsVisible() then
		wdt.RememberViewText:Show( true )
		
		local text = "Аддон запущен"
		Log(text, nil, 14)
		
		common.RegisterEventHandler( RememberDateMath, "EVENT_SECOND_TIMER" )
	else
		wdt.RememberViewText:Show( false )
		
		local text = "Аддон остановлен"
		Log(text, nil, 14)
		
		common.UnRegisterEventHandler( RememberDateMath, "EVENT_SECOND_TIMER" )
	end

end


---------------------------------------------------------------------------------------------------
-- Функция Отображения настроек аддона (по клику на кнопку)
function SettingsShowMenu()
	
	if not wdt.MainPanelSettings:IsVisible() then
		wdt.MainPanelSettings:Show( true )
		SettingsScanItem()
	else
		wdt.MainPanelSettings:Show( false )
	end

end


---------------------------------------------------------------------------------------------------
-- Функция Создания виджетов/панелек (по запуску настроек)
function SettingsAddItem( params )

	-- Выкидываем пустые ячейки (доделать на минимум)
	if params.name=="" then
		--return
	end
	
	
	local widget
	-- Если в массиве нет виджета берем его и кладем. Если есть то делаем с него копию
	if not wdt.itemDescSettings then
		widget = mainForm:GetChildChecked( "ItemSettings", true )
		wdt.itemDescSettings = widget:GetWidgetDesc()
	else
		widget = mainForm:CreateWidgetByDesc( wdt.itemDescSettings )
	end

	-- Задаем параметры созданному виджету 
	-- Присваиваем имя виджету
	widget:SetName( params.value )
	--W( 'ButtonItemSettings', widget ):SetVariant( params.new and 1 or 0 )

	local dateFromMs = {}

	-- Раскладываем дату из настроек (из миллисекунд в минуты часы дни и тд)
	--local dateqw = common.GetLocalDateTime( params.state )
	if params.state >= 0 then
		dateFromMs = common.GetDateTimeFromMs( tonumber(params.state) )
	end
	
	-- Если дата ежедневная то месяц и день равны нулю
	if DB_RememberDateRepeat_arr[params.value] == 1 then
		dateFromMs.m = 0
		dateFromMs.d = 0
	end
	
	if params.state < 0 then
		dateFromMs.m = 0
		dateFromMs.d = 0
		dateFromMs.h = 0
		dateFromMs.min = 0
	end
	
	
	-- Задаем максимально число символов для ввода а также вставляем данные из сохраненных настроек
	--W( 'TextLineInputDateD', widget ):SetMaxSize( 2 )
	--W( 'TextLineInputDateD', widget ):InsertTextAtCursorPos( userMods.ToWString( string.format( "%02d", dateFromMs.d ) ) )
	widget:GetChildChecked( "TextLineInputDateD", true ):SetMaxSize( 2 )
	widget:GetChildChecked( "TextLineInputDateD", true ):InsertTextAtCursorPos( userMods.ToWString( string.format( "%02d", dateFromMs.d ) ) )
	widget:GetChildChecked( "TextLineInputDateD", true ):SetTextColor( nil, { a = 0.5, r = 1, g = 1, b = 1 } )
	
	widget:GetChildChecked( "TextLineInputDateM", true ):SetMaxSize( 2 )
	widget:GetChildChecked( "TextLineInputDateM", true ):InsertTextAtCursorPos( userMods.ToWString( string.format( "%02d", dateFromMs.m ) ) )
	widget:GetChildChecked( "TextLineInputDateM", true ):SetTextColor( nil, { a = 0.5, r = 1, g = 1, b = 1 } )
	
	widget:GetChildChecked( "TextLineInputDateH", true ):SetMaxSize( 2 )
	widget:GetChildChecked( "TextLineInputDateH", true ):InsertTextAtCursorPos( userMods.ToWString( string.format( "%02d", dateFromMs.h ) ) )
	widget:GetChildChecked( "TextLineInputDateH", true ):SetTextColor( nil, { a = 0.5, r = 1, g = 1, b = 1 } )
	
	widget:GetChildChecked( "TextLineInputDateMin", true ):SetMaxSize( 2 )
	widget:GetChildChecked( "TextLineInputDateMin", true ):InsertTextAtCursorPos( userMods.ToWString( string.format( "%02d", dateFromMs.min ) ) )
	widget:GetChildChecked( "TextLineInputDateMin", true ):SetTextColor( nil, { a = 0.5, r = 1, g = 1, b = 1 } )
	
	widget:GetChildChecked( "TextLineInputDateName", true ):SetMaxSize( 50 )
	widget:GetChildChecked( "TextLineInputDateName", true ):InsertTextAtCursorPos( userMods.ToWString( params.name ) )
	--widget:GetChildChecked( "TextLineInputDateName", true ):SetTextColor( nil, { a = 1, r = 1, g = 1, b = 0 }, ENUM_ColorType_SHADOW )
	widget:GetChildChecked( "TextLineInputDateName", true ):SetTextColor( nil, { a = 0.5, r = 1, g = 1, b = 1 } )
	
	
	-- Созданный виджет кидаем в массив
	var.itemsSettings[ params.value ] = widget

end


---------------------------------------------------------------------------------------------------
-- Функция Сканирования сохраненных настроек из массива и запуск создания виджетов (по заходу в игру или открытию настроек)
function SettingsScanItem()

	-- Создаем/обнуляем массив с виджетами (планками) под настройки
	var.itemsSettings = {}

	-- Перебираем массив [имя планки] = текст напоминалки
	for key, val in pairs(DB_RememberDate_arr) do
		if val then
			-- Запускаем функцию создания виджетов/панелек
			SettingsAddItem( {value = key, name = DB_RememberName_arr[key], state = val } )
			
			--local text = NameItemSettings.."|"..key
			--Log(text, nil, 14)
		end
	end


	-- Массив с цветом заливки виджета
	local colors = {
		{ r = 255 / 255, g = 185 / 255, b = 255 / 255, a = 1.0 },
		{ r = 255, g = 255, b = 255, a = 1.0 }
	}
	
	wdt.ContainerSettings:RemoveItems()
	local j = 1
	
	for i, value in pairs(var.itemsSettings) do
		j = j+1
		
		if value then
		--	LogInfo( "value: ", value.name, i )
			local widget = var.itemsSettings[ i ]
			
			if widget then 
				wdt.ContainerSettings:PushBack( widget )
				if not widget:IsVisible() then
					widget:Show( true )
				end
				widget = widget:GetChildChecked( "ButtonItemSettings", true )

				--if math.mod( j, 2 ) == 0 then
				if math.fmod( j, 2 ) == 0 then
					widget:SetBackgroundColor( colors[ 1 ] )
				else
					widget:SetBackgroundColor( colors[ 2 ] )
				end
			end
		end
	end

end


---------------------------------------------------------------------------------------------------
-- Функция Добавления дополнительной панельки (при скане настроек)
function SettingsAddPlusItem()

	-- Создаем массивы с ключами (arrayItem) и критерием сортировки (resultItem)
	local arrayItem, resultItem = {}
	-- Переменные с переключателем есть нет пустых напоминалок (s) и счетчик (sr)
	local nameEmpty, nameIter = 0, 0
	--local arrayItemS, resultItemS = {} -- под кусок на выкидывание (см ниже в этой функции)
	
	-- Перебираем массив с текстом напоминалки на поиск пустых значений
	for key, value in pairs(DB_RememberName_arr) do
		if not value or value =="" then
			nameEmpty = 1
			nameIter = nameIter+1
		
			--local dw = string.gsub(key, "val", "") -- под кусок на выкидывание (см ниже в этой функции)
			--table.insert( arrayItemS, tonumber(dw)) -- под кусок на выкидывание (см ниже в этой функции)
		end
		
		-- Обрезаем ключ до числа
		local keyNum = string.gsub(key, "val", "")
		-- Вставляем в массив ключи как значение key = value(keyNum)
		table.insert( arrayItem, tonumber(keyNum))
	end

	-- Функция-условие для сортировки массива
	resultItem = function( a, b )
		return a < b
	end

	--Сортируем массив по условию
	table.sort( arrayItem, resultItem )
	
	-- Переменная счетчик
	local keyIter = 1
	-- Перебираем массив до тех пор пока значение массива равно значению счетчика. Как только неравно то останавливаем
	while arrayItem[keyIter] == keyIter do
		keyIter = keyIter+1
	end
	
	--local text = "sss| "..keyIter
	--Log(text, nil, 14)
	
	-- Если нет пустых значений (переключатель не изменился) то добавляем в массив данные под пустую панельку
	if nameEmpty == 0 then
		-- Присоединяем к val первый пропущенный номер
		local remKeyWidget = "val"..keyIter
		
		-- Распределяем данные по массивам
		DB_RememberDate_arr[remKeyWidget] = -1 -- массив с датой из настроек
		DB_RememberName_arr[remKeyWidget] = "" -- массив с текстом напоминалки и настроек
		--DB_RememberValueWidget_arr = {} -- массив с именем виджета планки из настроек
		DB_RememberDateRepeat_arr[remKeyWidget] = 1 -- массив с пометкой разовая или ежедневная напоминалка
	end
	
	-----------------------
	-- Кусок на выкидывание данных под пустые панельки если их перебор.
	-- В идеале ввести в сохранение настроек т.к. первый раз при сохранении в БД попадут пустые значения
	-----------------------
	
	--[[-- Функция-условие для сортировки массива
	resultItemS = function( a, b )
		return a > b
	end
	
	table.sort( arrayItemS, resultItemS )
	
	local derf =1
	while arrayItemS[derf] > 6 do
		local deredd = arrayItemS[derf]
		local dereddd = "val"..deredd
		
		derf = derf+1
		
		local text = "dereddd| "..dereddd
		Log(text, nil, 14)
		
		--table.remove(DB_RememberDate_arr, tonumber(dereddd))
		--table.remove(DB_RememberName_arr, tonumber(dereddd))
		--table.remove(DB_RememberDateRepeat_arr, tonumber(dereddd))
	end]]

end


---------------------------------------------------------------------------------------------------
-- Функция Очистки текстовых полей в окне настроек (по клику кнопки)
function SettingsClearTextLineInput( parent )
	
	local GetTextDateM = parent:GetChildChecked( "TextLineInputDateM", true )
	local GetTextDateD = parent:GetChildChecked( "TextLineInputDateD", true )
	local GetTextDateH = parent:GetChildChecked( "TextLineInputDateH", true )
	local GetTextDateMin = parent:GetChildChecked( "TextLineInputDateMin", true )
	local GetTextDateName = parent:GetChildChecked( "TextLineInputDateName", true )
	--local GetTextDateName = mainForm:GetChildChecked( "TextLineInputDateName", true )
	
	
	local GetTextDateMFromWStr = userMods.FromWString( GetTextDateM:GetText() )
	local GetTextDateDFromWStr = userMods.FromWString( GetTextDateD:GetText() )
	local GetTextDateHFromWStr = userMods.FromWString( GetTextDateH:GetText() )
	local GetTextDateMinFromWStr = userMods.FromWString( GetTextDateMin:GetText() )
	local GetTextDateNameFromWStr = userMods.FromWString( GetTextDateName:GetText() )
	
	
	--local GetTextDateM = W( 'TextLineInputDateM', parent ):GetText()
	--local GetTextDateMFromWStr = userMods.FromWString( GetTextDateM )


	local Er= #GetTextDateMFromWStr
	for i = 0, Er do
		--W( 'TextLineInputDateM', parent ):DeleteCharAtCursorPos()
		--W( 'TextLineInputDateM', parent ):BackspaceCharAtCursorPos()
		GetTextDateM:DeleteCharAtCursorPos()
		GetTextDateM:BackspaceCharAtCursorPos()
	end
		GetTextDateM:InsertTextAtCursorPos( userMods.ToWString( string.format( "%02d", 0 ) ) )
	
	local Er= #GetTextDateDFromWStr
	for i = 0, Er do
		GetTextDateD:DeleteCharAtCursorPos()
		GetTextDateD:BackspaceCharAtCursorPos()
	end
		GetTextDateD:InsertTextAtCursorPos( userMods.ToWString( string.format( "%02d", 0 ) ) )
	
	local Er= #GetTextDateHFromWStr
	for i = 0, Er do
		GetTextDateH:DeleteCharAtCursorPos()
		GetTextDateH:BackspaceCharAtCursorPos()
	end
		GetTextDateH:InsertTextAtCursorPos( userMods.ToWString( string.format( "%02d", 0 ) ) )
	
	local Er= #GetTextDateMinFromWStr
	for i = 0, Er do
		GetTextDateMin:DeleteCharAtCursorPos()
		GetTextDateMin:BackspaceCharAtCursorPos()
	end
		GetTextDateMin:InsertTextAtCursorPos( userMods.ToWString( string.format( "%02d", 0 ) ) )
	
	local Er= #GetTextDateNameFromWStr
	for i = 0, Er do
		GetTextDateName:DeleteCharAtCursorPos()
		GetTextDateName:BackspaceCharAtCursorPos()
	end

end


---------------------------------------------------------------------------------------------------
-- Функция Обработки событий нажатия левой кнопки мыши по виджетам аддона (см виджет)
function OnMouseLeftClick( params )
	local parent = params.widget:GetParent()
	local parentName = parent:GetName()
	local widgetVar = params.widget:GetVariant() == 1
	
	-- Клик по  кнопке Крестик (закрытие настроек)
	if params.sender == 'ButtonMain' or params.sender == 'CloseBtnMainPanelSettingsAddon' then
		if DnD:IsDragging() then return end
		SettingsShowMenu() -- закрытие
		return

	-- Клик по кнопке Сохранить (сохранение и закрытие настроек)
	elseif params.sender == 'ButtonSave' then
		SaveRememberData() -- сохранение настроек
		SettingsShowMenu() -- закрытие
		return
	end

	-- Клик по кнопке Будильник (открытие настроек и считывание)
	if params.sender == 'ShowHideBtn' then
		if common.GetBitAnd( params.kbFlags, KBF_SHIFT ) ~= 0 then
		--if common.IsKeyEnabled( 0x10 ) then
			StartRemember() -- запуск/остановка аддона
		else
			SettingsShowMenu() -- открыть панель настроек
			SettingsScanItem() -- считываем настройки
		end
	end

	-- Клик по кнопке D (запуск/остановка аддона)
	if params.sender == 'ShowHideSettingsBtn' then
		--StartRemember() -- запуск/остановка аддона
	end

	-- Клик по кнопке Х (очистить) (удаляет содержимое полей строки. Отправляет родителя к какому принадлижит кнопка)
	if params.sender == 'ButtonClear' then
		SettingsClearTextLineInput( parent )
	end

end


---------------------------------------------------------------------------------------------------
-- Функция Обработки событий нажатия на клавиатуре кнопки Esc по виджетам аддона (см виджет)
function OnKbdPressEsc( params )

	SettingsShowMenu() -- закрытие

end


---------------------------------------------------------------------------------------------------
-- Функция Обработки событий нажатия на клавиатуре кнопки Enter по виджетам аддона (см виджет)
function OnKbdPressEnt( params )

	SaveRememberData() -- сохранение данных введенных в настройках
	SettingsShowMenu() -- закрытие

end


---------------------------------------------------------------------------------------------------
-- Функция Обработки событий при наведение на виджет/кнопку (см виджет)
function OnWidgetPoint (params)

	-- Если отключен показ подсказки то отрубаем функцию
	if ShowHelpText ~= 1 then
		return
	end



	if params.active then 
		--local text = "Аддон отключится"
		--Log(text, nil, 14)
		
		
		-- Если в массиве нет виджета берем его и кладем. Если есть то делаем с него копию
		if not wdt.itemDescSet then
			-- Получаем описатель виджета
			wdt.itemDescSet = wdt.RememberViewText:GetWidgetDesc()
			-- По описателю создвем новый виджет
			wdt.HelpViewText = mainForm:CreateWidgetByDesc( wdt.itemDescSet )
			--wdt.HelpViewText = wdt.RememberView:CreateWidgetByDesc( wdt.itemDescSet )
			
			-- Присваиваем имя виджету
			wdt.HelpViewText:SetName( "HelpView" )
			
			-- Задаем виджету параметр многострочного текста
			wdt.HelpViewText:SetMultiline( true )
			wdt.HelpViewText:SetWrapText( true )
			
			--- Расстояние между строк
			--wdt.HelpViewText:SetLinespacing( 21 )
			
			-- Задаем формат надписп (текста) виджета
			local format = "<body alignx='left' fontname='AllodsWest' fontsize='14"
			format = format.."' shadow='1' ><rs class='color'><r name='myrmyrEE'/><br /><r name='myrmyr'/><br /><r name='myrmyrE'/></rs></body>"
			wdt.HelpViewText:SetFormat(userMods.ToWString(format))
			
			-- Задаем цвет и прозрачность текста и тени
			wdt.HelpViewText:SetTextColor( nil, { a = 0.7, r = 125, g = 125, b = 125 } )
			wdt.HelpViewText:SetTextColor( nil, { a = 0.1, r = 255, g = 0, b = 0 }, ENUM_ColorType_SHADOW )
			--wdt.HelpViewText:SetTextColor( nil, { a = 0.1, r = 0, g = 1, b = 1 }, ENUM_ColorType_TEXT )
			--wdt.HelpViewText:SetTextColor( nil, { a = 1, r = 0, g = 0, b = 0 }, ENUM_ColorType_OUTLINE )
			wdt.HelpViewText:SetTextColor( nil, { a = 0.3, r = 0, g = 0, b = 0 }, ENUM_ColorType_OUTLINE )
			
			--wdt.HelpViewText:SetTextColor( userMods.ToWString("myrmyr"), { a = 0.5, r = 1, g = 0, b = 0 }, ENUM_ColorType_TEXT )
			
			-- Задаем значение для подстановки класса в тег rs (цвет текста) 
			--local style = "ColorWhite"
			--wdt.HelpViewText:SetClassVal( "class", style )
			
		end
		
		
		-- Задаем координаты относительно указанного виджета (Берем положение указанного виджета и относительно него позиционируем свой)
		local pw = wdt.RememberView:GetPlacementPlain()
			--pw.alignX = WIDGET_ALIGN_LOW
			--pw.alignY = WIDGET_ALIGN_LOW
			pw.posX = pw.posX+50
			pw.posY = pw.posY+30
		wdt.HelpViewText:SetPlacementPlain(pw)
		
		
		-- Текст подсказки
		local text = "[лкм] - открыть настройки"
		local textE = "[лкм+shift] - вкл/откл аддон"
		local textEE = AddonName
		
		
		wdt.HelpViewText:SetVal( "myrmyr", text )
		wdt.HelpViewText:SetVal( "myrmyrE", textE )
		wdt.HelpViewText:SetVal( "myrmyrEE", textEE )
		
		
		-- Показываем текст подсказки
		wdt.HelpViewText:Show( true )
	else
		-- Скрываем текст подсказки
		wdt.HelpViewText:Show( false )
		
		--local text = "Аддон отключится"
		--Log(text, nil, 14)
	end

end


---------------------------------------------------------------------------------------------------
-- Функция Сохранения настроек (по клику)
function SaveRememberData()
	-- Объявляем локальный массив с будущими настройками
	local config = {}
	-- Перебираем массив с планками и вытягиваем данные введеные юзером
	for key, val in pairs(var.itemsSettings) do
		
		-- Берем имя планки (она же в DB_RememberValueWidget_arr)
		local WidgetName = val:GetName()
		
		-- Берем локальное время в миллисекундах
		local DateLocalClient = common.GetLocalDateTime()
		
		
		
		-- Обрабатываем данные из текстового поля Месяц
		-- Получаем данные из тектового поля
		local TextDateM = val:GetChildChecked( "TextLineInputDateM", true ):GetText()
		-- Если поле пустое то присваиваем значению 0
		if not TextDateM then
			--TextDateMFromWStr=0
			TextDateM=0
		end
		-- Преобазуем текст в обычный из локализуемого
		local TextDateMStr = userMods.FromWString( TextDateM )
		-- Фильтр на отсев левых символов. Хз зачем тут т.к. есть в виджете
		TextDateMStr = string.gsub(TextDateMStr, "[а-я А-ЯёЁa-zA-Z %D]", "")
		--TextDateMFromWStr = string.gsub(TextDateMFromWStr, "", "0")
		-- Задаем тип переменной как числовой
		TextDateMStr = tonumber(TextDateMStr)
		
		-- Проверяем укладывается ли месяц в диапапазон по календарю (макс=12, мин=0, контролируемое число)
		TextDateMStr = OnEventCheckNum( 12, 0, TextDateMStr )
		
		-- Создаем доп переменную. Если месяц рамен нулю то указываем текущий или пишем тот который указал юзер. (Для расчета разовых дат без месяца)
		local TextDateMStrCopy
		if TextDateMStr == 0 then
			TextDateMStrCopy = DateLocalClient.m
		else
			TextDateMStrCopy = TextDateMStr
		end
		
		
		
		-- Обрабатываем данные из текстового поля День
		-- Получаем данные из тектового поля
		local TextDateD = val:GetChildChecked( "TextLineInputDateD", true ):GetText()
		-- Если поле пустое то присваиваем значению 0
		if not TextDateD then
			TextDateD=0
		end
		-- Преобазуем текст в обычный из локализуемого
		local TextDateDStr = userMods.FromWString( TextDateD )
		-- Фильтр на отсев левых символов. Хз зачем тут т.к. есть в виджете
		TextDateDStr = string.gsub(TextDateDStr, "[а-я А-ЯёЁa-zA-Z %D]", "")
		-- Задаем тип переменной как числовой
		TextDateDStr = tonumber(TextDateDStr)

		--GetTextDateDFromWStr = string.gsub(GetTextDateDFromWStr, "%D", "0")
		if TextDateDStr == 0 and TextDateDStr <=0 then
			-- Проверяем укладывается ли день в диапапазон по календарю (макс=0, мин=0, контролируемое число) Если месяц и день указан как 0
			TextDateDStr = OnEventCheckNum( 0, 0, TextDateDStr )
		else
			--[[
			-- Проверяем дни в зависимости от месяца 
			if (TextDateMStrCopy == 1) or (TextDateMStrCopy == 3) or (TextDateMStrCopy == 5) or (TextDateMStrCopy == 7) or (TextDateMStrCopy == 8) or (TextDateMStrCopy == 10) or (TextDateMStrCopy == 12) then
				TextDateDStr = OnEventCheckNum( 31, 1, TextDateDStr )
				--GetTextDateDFromWStr = string.find("ytytuyuyu 11.12.13.14", "(%d+)")
			elseif TextDateMStrCopy == 4 or TextDateMStrCopy == 6 or TextDateMStrCopy == 9 or TextDateMStrCopy == 11 then
				TextDateDStr = OnEventCheckNum( 30, 1, TextDateDStr )
			elseif TextDateMStrCopy == 2 then
				-- Определяем количество дней в феврале в зависимости от того високосный год или нет
				-- Смотрим по остатку деления на 4 (если 0 то год високосный)
				if math.fmod( DateLocalClient.y, 4 ) == 0 then
				--if DateLocalClient.y == 2016 or DateLocalClient.y == 2020 or DateLocalClient.y == 2024 then
					TextDateDStr = OnEventCheckNum( 29, 1, TextDateDStr )
				else
					TextDateDStr = OnEventCheckNum( 28, 1, TextDateDStr )
				end
			end
			]]
			
			--Вся фигня выше заменяется функцией из игры
			
			-- Смотрим количество дней в месяце по месяцу и году
			local DaysCountInMonth = mission.GetMonthDaysCount( TextDateMStrCopy, DateLocalClient.y )
			-- Проверяем укладывается ли день в диапапазон по календарю (макс=в зависимости от месяца, мин=1, контролируемое число)
			TextDateDStr = OnEventCheckNum( DaysCountInMonth, 1, TextDateDStr )
			
		end
		
		
		
		-- Обрабатываем данные из текстового поля Часы
		-- Получаем данные из тектового поля
		local TextDateH = val:GetChildChecked( "TextLineInputDateH", true ):GetText()
		-- Если поле пустое то присваиваем значению 0
		if not TextDateH then
			TextDateH=0
		end
		-- Преобазуем текст в обычный из локализуемого
		local TextDateHStr = userMods.FromWString( TextDateH )
		-- Фильтр на отсев левых символов. Хз зачем тут т.к. есть в виджете
		TextDateHStr = string.gsub(TextDateHStr, "[а-я А-ЯёЁa-zA-Z %D]", "")
		-- Задаем тип переменной как числовой
		TextDateHStr = tonumber(TextDateHStr)
		
		-- Проверяем укладываются ли часы в диапапазон по календарю (макс=23, мин=0, контролируемое число)
		TextDateHStr = OnEventCheckNum( 23, 0, TextDateHStr )
		
		
		
		-- Обрабатываем данные из текстового поля Минуты
		-- Получаем данные из тектового поля
		local TextDateMin = val:GetChildChecked( "TextLineInputDateMin", true ):GetText()
		-- Если поле пустое то присваиваем значению 0
		if not TextDateMin then
			TextDateMin=0
		end
		-- Преобазуем текст в обычный из локализуемого
		local TextDateMinStr = userMods.FromWString( TextDateMin )
		-- Фильтр на отсев левых символов. Хз зачем тут т.к. есть в виджете
		TextDateMinStr = string.gsub(TextDateMinStr, "[а-я А-ЯёЁa-zA-Z %D]", "")
		-- Задаем тип переменной как числовой
		TextDateMinStr = tonumber(TextDateMinStr)
		
		-- Проверяем укладываются ли минуты в диапапазон по календарю (макс=59, мин=0, контролируемое число)
		TextDateMinStr = OnEventCheckNum( 59, 0, TextDateMinStr )
		
		
		
		-- Обрабатываем данные из текстового поля Текс напоминалки
		-- Получаем данные из тектового поля
		local TextDateName = val:GetChildChecked( "TextLineInputDateName", true ):GetText()
		-- Если поле пустое то присваиваем значению 0
		if not TextDateName then
			TextDateName=""
		end
		-- Преобазуем текст в обычный из локализуемого
		local TextDateNameStr = userMods.FromWString( TextDateName )
		-- Фильтр на отсев левых символов. Хз зачем тут т.к. есть в виджете (нужно ограничение только на ";")
		TextDateNameStr = string.gsub(TextDateNameStr, "[^а-я А-ЯёЁa-zA-Z0-9%(%)%[%]%,%.%@%'!?%*%-%_%+%=%#%№%{%}]", "")
		-- Обрезаем пробелы в начали и в конце строки
		TextDateNameStr = TextDateNameStr:match("^%s*(.*)%s*$")
		
		
		
		-- Если дата указана и неукзан месяц то присваиваем текущий (повторяемые только по часам и минутам, по дням и месяцам разовые)
		if TextDateDStr >0 and TextDateMStr == 0 then
			TextDateMStr = DateLocalClient.m
		end
		
		
		-- Определяемся с годом (текущий или следующий) Нужен для переноса напоминалка на след год если дата разовая уже прошла
		local DateLocalClientYear
		if (TextDateMStr < DateLocalClient.m and TextDateDStr < DateLocalClient.d) or (TextDateMStr == DateLocalClient.m and TextDateDStr < DateLocalClient.d) then
			DateLocalClientYear = DateLocalClient.y+1
		else
			DateLocalClientYear = DateLocalClient.y
		end
		
		
		-- Переводим дату в миллисекунды
		local TimeToMs
		if TextDateDStr ~=0 and TextDateMStr ~= 0 then
			local timeTableD = {}
				timeTableD.y = DateLocalClientYear
				timeTableD.m = TextDateMStr
				timeTableD.d = TextDateDStr
				timeTableD.h = TextDateHStr
				timeTableD.min = TextDateMinStr
			TimeToMs = common.GetMsFromDateTime( timeTableD )
		else
			local RepeatTextDateHStr = TextDateHStr*3600000
			local RepeatTextDateMinStr = TextDateMinStr*60000
			local RepeatTotalTime = RepeatTextDateHStr+RepeatTextDateMinStr
			TimeToMs = RepeatTotalTime
		end
		
		
		-- Подставляем значение в переменную если Наименование сообщения не заполнено
		if TextDateNameStr ==nil or TextDateNameStr =="" then
			TextDateNameStr = " "
			TimeToMs = -1
		end
		
		
		--local text = GetTextDateDFromWStr.."."..GetTextDateMFromWStr.." "..GetTextDateHFromWStr..":"..GetTextDateMinFromWStr.."||"..GetTextDateNameFromWStr.."   key="..key.."   val="..WidgetName
		--Log(text, nil, 14)
		
		
		-- Обрезаем имя виджета до числа
		local WidgetNameNum = string.gsub(WidgetName, "val", "")
		-- Если ключ виджета больше 9 и текст напоминалки отсутствует то это не занносим в массив и не сохраняем чтобы не плодить строки
		if tonumber(WidgetNameNum) > 9 and TextDateNameStr ==" " then
		else
			table.insert(config, 1, WidgetName..";"..TextDateNameStr..";"..TimeToMs )
		end
	end
	-- Смотрим размер массива. Если он больше нуля то вносим данные (т.е. если в нем есть хоть какая то информация о кормежки то запишим ее в файл конфигурации - БД)
	if GetTableSize(config) > 0 then
		--userMods.SetAvatarConfigSection ("AMF_mountList", config)
		userMods.SetGlobalConfigSection ("REMEMBER_AddonRememberDataGlobal", config)
		
		LoadRememberData()
	end
end


--------------------------------------------------------------------------------------------------
-- Функция Загрузки настроек (по клюку или запуску игры)
function LoadRememberData()

	-- Загружаем данные настроек из БД (из файла конфигурации)
	local config = userMods.GetGlobalConfigSection("REMEMBER_AddonRememberDataGlobal")
	
	-- Обнуляем массив с пометкой разовая или ежедневная напоминалка
	DB_RememberDateRepeat_arr = {}
	
	DB_RememberDate_arr = {}
	DB_RememberName_arr = {}
	
	-- Смотрим сегодняшнюю дату и количество миллисекунд на начало дня
	local LocalDateTime = common.GetLocalDateTime()
	MsDayStart = common.GetMsFromDateTime( {y=LocalDateTime.y, m=LocalDateTime.m, d=LocalDateTime.d} )
	
	if config then
		-- Перебираем массив
		for _, val in pairs(config) do
			
			--[[local _, _, a, b, c, d = string.find("10 11;12; tr13; 14 15tyt \0", "(%d+)%;(%Z+)%;(%Z+)%;(%Z+)")
			local a, b, c, d = string.match("10 11;12; tr13; 14 15tyt \0", "(%d+)%;(%Z+)%;(%Z+)%;(%Z+)")]]

			-- Захватываем данные
			--local a, b, c = string.match(val, "(%S*)%;(%S*)%;(%S*)") -- не символ пробела
			--local a, b, c = string.match(val, "(%Z+)%;(%Z+)%;(%Z+)") -- не нулевой сивол
			--local a, b, c = string.match(val, "(.+)%;(.+)%;(.+)") -- любой символ
			local remValueWidget, remName, remDate = string.match(val, "(%Z+)%;(%Z+)%;(%Z+)")
			
			-- Обрезаем пробелы в начали и в конце строки
			remName = remName:match("^%s*(.*)%s*$")
			remDate = remDate:match("^%s*(.*)%s*$")
			
			-- Подставляем значение в переменную если она пуста
			remName = remName or "non"
			remDate = remDate or "-1"
			
			-- Предаствляем данные ввиде числа
			remDate = tonumber(remDate)
			
			--local text = "remValueWidget="..remValueWidget.." remName="..remName.." remDate="..remDate
			--Log(text, nil, 14)
			
			-- Распределяем данные по массивам
			DB_RememberDate_arr[remValueWidget] = remDate -- массив с датой из настроек
			DB_RememberName_arr[remValueWidget] = remName -- массив с текстом напоминалки и настроек
			--DB_RememberValueWidget_arr = {} -- массив с именем виджета планки из настроек
			--DB_RememberDateRepeat_arr[remValueWidget] = {} -- массив с пометкой разовая или ежедневная напоминалка
			
			
			-- Если дата меньше 24 часов то обозначаем как ежедневная
			if remDate < 86400000 and remDate > 0 then
				DB_RememberDateRepeat_arr[remValueWidget] = 1
				DB_RememberDate_arr[remValueWidget] = remDate+MsDayStart -- прибавляем к ежедневным напоминалкам количество миллисекунд на начало дня
				
				DB_RememberNameTime_arr[(remDate+MsDayStart)] = remName -- массив с текстом напоминалки из настроек (время в качестве ключа)
			else
				DB_RememberDateRepeat_arr[remValueWidget] = 0
				
				DB_RememberNameTime_arr[remDate] = remName -- массив с текстом напоминалки из настроек (время в качестве ключа)
			end

		end
	elseif not config then
		for i=1, 9 do
			local valueWidget = "val"..tostring( i )
			
			-- Распределяем данные по массивам
			DB_RememberDate_arr[valueWidget] = -1 -- массив с датой из настроек
			DB_RememberName_arr[valueWidget] = "" -- массив с текстом напоминалки и настроек
			--DB_RememberValueWidget_arr = {} -- массив с именем виджета планки из настроек
			DB_RememberDateRepeat_arr[valueWidget] = 1 -- массив с пометкой разовая или ежедневная напоминалка
		end
	end
	-- Запускаем функцию сканирования стойла чтобы потом запустить графические виджеты и выстроился список с настройками аддона
	--SettingsScanItem()
	SettingsAddPlusItem()
end


---------------------------------------------------------------------------------------------------
-- Функция Проверки чисел даты и времени (чтобы укладывались в диапазон по календарю)
function OnEventCheckNum( maxNum, minNum, Num )

	-- Создаем
	if (Num < minNum) then
		Num = minNum
	end
	if (Num <= maxNum) and (Num >= minNum) then
		Num = Num
	end
	if (Num > maxNum) then
		Num = maxNum
	end
	
	return Num

end


---------------------------------------------------------------------------------------------------
-- Функция обработки событий нажатия левой кнопки мыши по виджетам аддона
--[[function OnMouseLeftClick( params )
	--local parent = params.widget:GetParent()
	--local parentName = parent:GetName()
	--local widgetVar = params.widget:GetVariant() == 1
	
	if params.sender == 'ButtonMain' or params.sender == 'CloseBtnMainPanelSettingsAddon' then
		if DnD:IsDragging() then return end
		CloseSettings()
		return

	elseif params.sender == 'ButtonSave' then
		SaveRememberDataTest()
		CloseSettings()
		--OnEventInstanceDecline()
		return
	end
	
	if params.sender == 'ShowHideBtn' then

		local stateScreenBtn = wdt.ShowHideBtn:GetVariant() == 1
		wdt.ShowHideBtn:SetVariant( ( not stateScreenBtn ) and 1 or 0 )
		
		local stateScreenBtnA = mainForm:GetChildChecked( "ShowHideBtn", true ):GetVariant()
		if (stateScreenBtnA == 1 ) then
			local text = "Запущен"
			Log(text, nil, 14)
			
			-- Запускаем функцию Проверки расположения Кутюрье (по таймеру)
			common.RegisterEventHandler(onEventAutoSpeakNPC, "EVENT_SECOND_TIMER")
		end
		if (stateScreenBtnA == 0) then
			local text = "Остановлен"
			Log(text, nil, 14)
			
			-- Останавливаем функцию Проверки расположения Кутюрье (по таймеру)
			common.UnRegisterEventHandler(onEventAutoSpeakNPC, "EVENT_SECOND_TIMER")
		end

	end

end]]


---------------------------------------------------------------------------------------------------
-- Функция Запускает настройки аддона (по слеш-команде из Чата)
function OnEventUnknownSlashCommand( params )

	-- Создаем локальную переменную со слеш-командой преобразованной из локализованного текста в нормальный
	local cmd = userMods.FromWString( params.text )
	
	-- Если слеш-команда ровна нашей то запускаем функцию с настройками аддона
	if cmd == "/remember" then
		SettingsShowMenu()
	end

end


--------------------------------------------------------------------------------
-- CHECKED AVATAR AND DATE		Проверки создания аватара, даты и прочее до начала работы основных скриптов
--------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Функция проверки даты
function OnEventCheckDate( params )

	-- Получаем текущую дату в миллисекундах со дня рождения unix (1-го января 1970-го года)
	local TimePresent = common.GetMsFromDateTime( common.GetLocalDateTime() )
	
	local timeTable = {}
		timeTable.y = 2020
		timeTable.m = 01
		timeTable.d = 20
	local TimeStop = common.GetMsFromDateTime( timeTable )

	-- Переменная с доступом к аддону
	local StartAllow = true
	
	--if (TimeStop >= TimePresent) then
	if (TimeStop <= TimePresent) then
		--OnEventAvatarCreatedRun()
		StartAllow = false
	end
	
	
	local TimeStopWarning = 432000000 --//5 суток
	local TimeStopWarningT = TimeStop - TimeStopWarning
	
	-- Выводим в чат предупреждение об отключении аддона за 5 суток
	if (TimeStopWarningT <= TimePresent) then
		local text = "Аддон отключится "..string.format( "%02d", timeTable.d).."."..string.format( "%02d", timeTable.m).."."..timeTable.y..". Переустановите аддон. www.alloder.pro/"
		Log(text, nil, 14)
	end

	return StartAllow

end


---------------------------------------------------------------------------------------------------
-- Функция запускает функции после момента создания персонажа (входа в игру)
function OnEventAvatarCreatedRun()
	--OnEventRET()

end


---------------------------------------------------------------------------------------------------
-- Функция запускающаяся с момента создания юзера в игре (после его захода)
function OnEventAvatarCreated()

	-- Проверка по времени
--	if not OnEventCheckDate() then
--		wdt.RememberView:Show( false )
--		return
--	end
	
	
	-- Запускаем функцию локализации аддона. В зависимостти от языка клиента переведем кнопки
	--LangSetup( GetGameLocalization() )
	LangSetup( common.GetLocalization() )
	
	-- Запускаем функцию загрузки настроек из файла
	LoadRememberData()
	
	-- Запускаем функцию реагирующую на слеш-команды чата (по слеш-команде из Чата)
	common.RegisterEventHandler( OnEventUnknownSlashCommand, "EVENT_UNKNOWN_SLASH_COMMAND" )
	
	-- Запускаем функцию Отображения таймера за инстансы
	common.RegisterEventHandler( RememberDateMath, "EVENT_SECOND_TIMER" )
	
	-- Запускаем функцию Проверки расположения Кутюрье (по таймеру)
--	common.RegisterEventHandler(onEventAutoSpeakNPC, "EVENT_SECOND_TIMER")

end


--------------------------------------------------------------------------------
-- INITIALIZATION		Инициализация функций
--------------------------------------------------------------------------------
function Init()
	-- События:
	-- Цепляем виджет
	wdt.ShowHideBtn = mainForm:GetChildChecked( "ShowHideBtn", true )
	wdt.ShowHideBtn:Show( true )
		local p = wdt.ShowHideBtn:GetPlacementPlain()
			p.alignX = WIDGET_ALIGN_LOW
			p.alignY = WIDGET_ALIGN_LOW
			p.posX = 0
			p.posY = 0
		wdt.ShowHideBtn:SetPlacementPlain(p)
	
	wdt.RememberView = mainForm:GetChildChecked( "MoneyInfo", true )
	wdt.RememberView:Show( true )
	
	wdt.RememberViewText = mainForm:GetChildChecked( "MoneyInfo", true ):GetChildChecked( 'Announce', false )
	wdt.RememberViewText:Show( true )
		local pw = wdt.RememberViewText:GetPlacementPlain()
			pw.alignX = WIDGET_ALIGN_LOW
			pw.alignY = WIDGET_ALIGN_LOW
			pw.posX = 40
			pw.posY = 4
		wdt.RememberViewText:SetPlacementPlain(pw)
	
	
	--wdt.ContainerSettings = mainForm:GetChildChecked( "FramePanelSettingsAddon", true )
	wdt.ContainerSettings = mainForm:GetChildChecked( "FramePanelSettingsAddon", true ):GetChildChecked( 'ContainerSettings', false )
	
	wdt.MainPanelSettings = mainForm:GetChildChecked( "MainPanelSettings", true )
	
	
	-- Функция перетаскивания виджета (Тело функции находится в библиотеке)
	--DnD.Init( wdt.ShowHideBtn, wdt.ShowHideBtn, true )
	DnD.Init( wdt.RememberView, wdt.ShowHideBtn, true, true, {0,-450,0,0} )
	DnD.Init( wdt.MainPanelSettings, mainForm:GetChildChecked( "HeaderTextPanelSettingsAddon", true ), true )
	
	-- Реакция на клик левой кнопки мыши по виджиту (см виджет)
	common.RegisterReactionHandler( OnMouseLeftClick, "mouse_left_click" )
	
	-- Реакция на клик кнопки в активном виджите (см виджет)
	common.RegisterReactionHandler( OnKbdPressEsc, "rESC" )
	common.RegisterReactionHandler( OnKbdPressEnt, "rEnt" )
	
	-- Реакция при наведение на виджет/кнопку (см виджет)
	common.RegisterReactionHandler( OnWidgetPoint, "show_help" )
	
	
	-- Вызываем функцию при создании юзера (при входе в игру)
	common.RegisterEventHandler(OnEventAvatarCreated, "EVENT_AVATAR_CREATED")
	-- Вызываем функцию если юзер уже создан
	if avatar.IsExist() then
		OnEventAvatarCreated()
	end
	
end
--------------------------------------------------------------------------------
-- Запускаем инициализацию
Init()
--------------------------------------------------------------------------------