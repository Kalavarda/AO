--------------------------------------------------------------------------------
-- GLOBAL		���������� ���������� � �������
--------------------------------------------------------------------------------
Global( "ShowHelpText", 1 ) -- ���������� ��������� ��� ��������� �� ������ [���������] (1-���/0-����)
Global( "ShowIconFlash", 0 ) -- ��������� ������� ������� � ������ ����� �� ������� ��������� ����������� ������ (1-���/0-����)

local DB_RememberDate_arr = {} -- ������ � ����� �� ��������
local DB_RememberName_arr = {} -- ������ � ������� ����������� �� ��������
local DB_RememberValueWidget_arr = {} -- ������ � ������ ������� ������ �� ��������
local DB_RememberDateRepeat_arr = {} -- ������ � �������� ������� ��� ���������� �����������
--

local DB_RememberNameTime_arr = {} -- ������ � ������� ����������� �� �������� (����� � �������� �����)

--local der = 0

local MsDayStart = 0 -- ���������� ����������� �� ������ ���

local wdt = {} -- ������ � ���������
local var = {} -- ������ � �����������

local AddonName = common.GetAddonName()



--------------------------------------------------------------------------------
-- EVENT HANDLERS		���� � ��������� (�������� ������� ������������)
--------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- ������� ������� ���������� ����������� (���������� �������) (�� �������)
function RememberDateMath()

	local array, result = {}
	
	--for key, val in pairs(DB_RememberDate) do
	for key, val in pairs(DB_RememberDate_arr) do
		--table.insert( array, tonumber(val))
		if val > 0 then
			table.insert( array, tonumber(val))
		end
	end
	
	-- �������-������� ��� ���������� �������
	result = function( a, b )
		return a > b
	end

	--��������� ������ �� ������� � ���������� ���
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
-- ������� ����������� �����������
function RememberDateView( TimeStop, TimeName )

	-- ������� ����������� ���� � ���������� ����������� �� ������ ���
	local LocalDateTime = common.GetLocalDateTime()
	-- �������� ������� ���� � ������������ �� ��� �������� unix (1-�� ������ 1970-�� ����)
	local TimePresent = common.GetMsFromDateTime( LocalDateTime )
	
	
	-- ���� ������� ����� ������ ��� ������ + ���� ����� + 30 ������ �� ��������� ������ ���
	if MsDayStart+86430000 > TimePresent then
		MsDayStart = common.GetMsFromDateTime( {y=LocalDateTime.y, m=LocalDateTime.m, d=LocalDateTime.d} )
	end
	
	
	local TimeStopWarningYellow = 1800000 --//30 ���
	local TimeStopWarninRed = 600000 --//10 ���
	
	--local TimeStopWarning = 432000000 --//5 �����
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
	--wt.TitleText:SetVal( "myrmyr", "�" )
	
	--[[W( 'AnnounceT' ):SetClassVal( "class", style )
	W( 'AnnounceT' ):SetVal( "myrmyr", "�" )
	W( 'AnnounceT' ):Show( true )]]
	
	-- ��������� ������� ������� � ������ ����� �� ������� ��������� ����������� ������ (1-���/0-����)
	if ShowIconFlash == 1 then
		-- �������� ������� ������� � ������ ����� �� ������� ��������� ����������� ������
		if TimeStopWarningTT == 60000 then -- 1 ���
			common.SetIconFlash( 3 )
		elseif TimeStopWarningTT <= 5000 then -- 5 ��� � ������
			common.SetIconFlash( 3 )
		end
	end

end


---------------------------------------------------------------------------------------------------
-- ������� �������������� ���� ������ ����������
function OnEventFormatDateView( dateView )

	-- �������
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
		
		
		-- ����� �������� �������
		DateTimeFromMs.m = 0
		DateTimeFromMs.d = math.floor(dateView / Kd)
		
		
		-- ������� ����������� ���� � ���������� ����������� �� ������ ���
		local LocalDateTime = common.GetLocalDateTime()

		-- ������ ��������� ����� � ���
		local month, year = LocalDateTime.m, LocalDateTime.y
		-- ���������� ������� ���� �� ���������
		local day = DateTimeFromMs.d
		-- ���� ����� ������ �����
		local monthTotal, ddd = 0, 0
		
		-- ���������� ���� ���� �� ����� ������ 30 (������ ������)
		while day >30 do
			-- ���� ������� ������ 12 �� �������� ������� ������� � ���������� ���
			if month > 12 then
				month = 1
				year = year+1
			end
		
			-- ������� ������� ���� � ��������� ������
			local DaysCountInMonth = mission.GetMonthDaysCount( month, year )
			-- �������� �� ������ ���������� ���� ��� ������
			day = day-DaysCountInMonth 
			-- ���������� � ������ +1 (������� �������)
			month = month+1
			
			-- ���������� ������� ����� ������� ��������
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
		FormatDateView = DateTimeFromMs.m.."�. "..DateTimeFromMs.d.."��. "..DateTimeFromMs.h.."�. "..string.format( "%02d", DateTimeFromMs.min).."���."
		--FormatDateView = DateTimeFromMs.m.."�. "..DateTimeFromMs.d.."��. "..DateTimeFromMs.h..":"..string.format( "%02d", DateTimeFromMs.min).." "
	end
	if (DateTimeFromMs.d > 0) and (DateTimeFromMs.m <= 0) then
		FormatDateView = DateTimeFromMs.d.."��. "..DateTimeFromMs.h.."�. "..string.format( "%02d", DateTimeFromMs.min).."���."
		--FormatDateView = DateTimeFromMs.d.."��. "..DateTimeFromMs.h..":"..string.format( "%02d", DateTimeFromMs.min).." "
	end
	if (DateTimeFromMs.h > 0) and (DateTimeFromMs.d <= 0) and (DateTimeFromMs.m <= 0) then
		FormatDateView = DateTimeFromMs.h.."�. "..string.format( "%02d", DateTimeFromMs.min).."���."
		--FormatDateView = DateTimeFromMs.h..":"..string.format( "%02d", DateTimeFromMs.min).." "
	end
	if (DateTimeFromMs.min > 0) and (DateTimeFromMs.h <= 0) and (DateTimeFromMs.d <= 0) and (DateTimeFromMs.m <= 0) then
		FormatDateView = DateTimeFromMs.min.."���."
	end
	if (DateTimeFromMs.s > 0) and (DateTimeFromMs.min <= 0) and (DateTimeFromMs.h <= 0) and (DateTimeFromMs.d <= 0) then
		FormatDateView = DateTimeFromMs.s.."���."
	end
	
	
	return FormatDateView

end


---------------------------------------------------------------------------------------------------
-- ������� ����������� ������ � ���������� �������� (�� ����� � ����. ������ ������ Locales)
function LangSetup( locale )

	InitLocalText( locale )
	--W( 'HeaderTextPanelSettingsAddon' ):SetVal( 'value', userMods.ToWString(L[ 'AddonName' ]) )
	mainForm:GetChildChecked( "HeaderTextPanelSettingsAddon", true ):SetVal( 'value', userMods.ToWString(L[ 'AddonName' ]) )
	mainForm:GetChildChecked( "ButtonSave", true ):SetVal( 'button_label', userMods.ToWString(L[ 'Save' ]) )
	
	
	--mainForm:GetChildChecked( "TitleTextD", true ):SetClassVal( "class", "ColorGreen" )
	mainForm:GetChildChecked( "TitleTextD", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 0 } )
	mainForm:GetChildChecked( "TitleTextD", true ):SetVal( "TitleTextT", "�" )
	
	--mainForm:GetChildChecked( "TitleTextM", true ):SetClassVal( "class", "ColorGreen" )
	mainForm:GetChildChecked( "TitleTextM", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 0 } )
	mainForm:GetChildChecked( "TitleTextM", true ):SetVal( "TitleTextT", "�" )
	
	--mainForm:GetChildChecked( "TitleTextH", true ):SetClassVal( "class", "ColorGreen" )
	mainForm:GetChildChecked( "TitleTextH", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 0 } )
	mainForm:GetChildChecked( "TitleTextH", true ):SetVal( "TitleTextT", "�" )
	
	--mainForm:GetChildChecked( "TitleTextMin", true ):SetClassVal( "class", "ColorGreen" )
	mainForm:GetChildChecked( "TitleTextMin", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 0 } )
	mainForm:GetChildChecked( "TitleTextMin", true ):SetVal( "TitleTextT", "���" )
	
	--mainForm:GetChildChecked( "TitleTextName", true ):SetClassVal( "class", "ColorGreen" )
	mainForm:GetChildChecked( "TitleTextName", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 0 } )
	--mainForm:GetChildChecked( "TitleTextName", true ):SetTextColor( nil, { a = 0.5, r = 0.2, g = 1, b = 1 }, ENUM_ColorType_SHADOW )
	mainForm:GetChildChecked( "TitleTextName", true ):SetVal( "TitleTextT", "������������" )
	
	
	mainForm:GetChildChecked( "ButtonClear", true ):SetVal( 'button_label', userMods.ToWString( "x" ) )
end


---------------------------------------------------------------------------------------------------
-- ������� �������/��������� ������ (�� ����� �� ������)
function StartRemember()
	
	if not wdt.RememberViewText:IsVisible() then
		wdt.RememberViewText:Show( true )
		
		local text = "����� �������"
		Log(text, nil, 14)
		
		common.RegisterEventHandler( RememberDateMath, "EVENT_SECOND_TIMER" )
	else
		wdt.RememberViewText:Show( false )
		
		local text = "����� ����������"
		Log(text, nil, 14)
		
		common.UnRegisterEventHandler( RememberDateMath, "EVENT_SECOND_TIMER" )
	end

end


---------------------------------------------------------------------------------------------------
-- ������� ����������� �������� ������ (�� ����� �� ������)
function SettingsShowMenu()
	
	if not wdt.MainPanelSettings:IsVisible() then
		wdt.MainPanelSettings:Show( true )
		SettingsScanItem()
	else
		wdt.MainPanelSettings:Show( false )
	end

end


---------------------------------------------------------------------------------------------------
-- ������� �������� ��������/������� (�� ������� ��������)
function SettingsAddItem( params )

	-- ���������� ������ ������ (�������� �� �������)
	if params.name=="" then
		--return
	end
	
	
	local widget
	-- ���� � ������� ��� ������� ����� ��� � ������. ���� ���� �� ������ � ���� �����
	if not wdt.itemDescSettings then
		widget = mainForm:GetChildChecked( "ItemSettings", true )
		wdt.itemDescSettings = widget:GetWidgetDesc()
	else
		widget = mainForm:CreateWidgetByDesc( wdt.itemDescSettings )
	end

	-- ������ ��������� ���������� ������� 
	-- ����������� ��� �������
	widget:SetName( params.value )
	--W( 'ButtonItemSettings', widget ):SetVariant( params.new and 1 or 0 )

	local dateFromMs = {}

	-- ������������ ���� �� �������� (�� ����������� � ������ ���� ��� � ��)
	--local dateqw = common.GetLocalDateTime( params.state )
	if params.state >= 0 then
		dateFromMs = common.GetDateTimeFromMs( tonumber(params.state) )
	end
	
	-- ���� ���� ���������� �� ����� � ���� ����� ����
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
	
	
	-- ������ ����������� ����� �������� ��� ����� � ����� ��������� ������ �� ����������� ��������
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
	
	
	-- ��������� ������ ������ � ������
	var.itemsSettings[ params.value ] = widget

end


---------------------------------------------------------------------------------------------------
-- ������� ������������ ����������� �������� �� ������� � ������ �������� �������� (�� ������ � ���� ��� �������� ��������)
function SettingsScanItem()

	-- �������/�������� ������ � ��������� (��������) ��� ���������
	var.itemsSettings = {}

	-- ���������� ������ [��� ������] = ����� �����������
	for key, val in pairs(DB_RememberDate_arr) do
		if val then
			-- ��������� ������� �������� ��������/�������
			SettingsAddItem( {value = key, name = DB_RememberName_arr[key], state = val } )
			
			--local text = NameItemSettings.."|"..key
			--Log(text, nil, 14)
		end
	end


	-- ������ � ������ ������� �������
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
-- ������� ���������� �������������� �������� (��� ����� ��������)
function SettingsAddPlusItem()

	-- ������� ������� � ������� (arrayItem) � ��������� ���������� (resultItem)
	local arrayItem, resultItem = {}
	-- ���������� � �������������� ���� ��� ������ ����������� (s) � ������� (sr)
	local nameEmpty, nameIter = 0, 0
	--local arrayItemS, resultItemS = {} -- ��� ����� �� ����������� (�� ���� � ���� �������)
	
	-- ���������� ������ � ������� ����������� �� ����� ������ ��������
	for key, value in pairs(DB_RememberName_arr) do
		if not value or value =="" then
			nameEmpty = 1
			nameIter = nameIter+1
		
			--local dw = string.gsub(key, "val", "") -- ��� ����� �� ����������� (�� ���� � ���� �������)
			--table.insert( arrayItemS, tonumber(dw)) -- ��� ����� �� ����������� (�� ���� � ���� �������)
		end
		
		-- �������� ���� �� �����
		local keyNum = string.gsub(key, "val", "")
		-- ��������� � ������ ����� ��� �������� key = value(keyNum)
		table.insert( arrayItem, tonumber(keyNum))
	end

	-- �������-������� ��� ���������� �������
	resultItem = function( a, b )
		return a < b
	end

	--��������� ������ �� �������
	table.sort( arrayItem, resultItem )
	
	-- ���������� �������
	local keyIter = 1
	-- ���������� ������ �� ��� ��� ���� �������� ������� ����� �������� ��������. ��� ������ ������� �� �������������
	while arrayItem[keyIter] == keyIter do
		keyIter = keyIter+1
	end
	
	--local text = "sss| "..keyIter
	--Log(text, nil, 14)
	
	-- ���� ��� ������ �������� (������������� �� ���������) �� ��������� � ������ ������ ��� ������ ��������
	if nameEmpty == 0 then
		-- ������������ � val ������ ����������� �����
		local remKeyWidget = "val"..keyIter
		
		-- ������������ ������ �� ��������
		DB_RememberDate_arr[remKeyWidget] = -1 -- ������ � ����� �� ��������
		DB_RememberName_arr[remKeyWidget] = "" -- ������ � ������� ����������� � ��������
		--DB_RememberValueWidget_arr = {} -- ������ � ������ ������� ������ �� ��������
		DB_RememberDateRepeat_arr[remKeyWidget] = 1 -- ������ � �������� ������� ��� ���������� �����������
	end
	
	-----------------------
	-- ����� �� ����������� ������ ��� ������ �������� ���� �� �������.
	-- � ������ ������ � ���������� �������� �.�. ������ ��� ��� ���������� � �� ������� ������ ��������
	-----------------------
	
	--[[-- �������-������� ��� ���������� �������
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
-- ������� ������� ��������� ����� � ���� �������� (�� ����� ������)
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
-- ������� ��������� ������� ������� ����� ������ ���� �� �������� ������ (�� ������)
function OnMouseLeftClick( params )
	local parent = params.widget:GetParent()
	local parentName = parent:GetName()
	local widgetVar = params.widget:GetVariant() == 1
	
	-- ���� ��  ������ ������� (�������� ��������)
	if params.sender == 'ButtonMain' or params.sender == 'CloseBtnMainPanelSettingsAddon' then
		if DnD:IsDragging() then return end
		SettingsShowMenu() -- ��������
		return

	-- ���� �� ������ ��������� (���������� � �������� ��������)
	elseif params.sender == 'ButtonSave' then
		SaveRememberData() -- ���������� ��������
		SettingsShowMenu() -- ��������
		return
	end

	-- ���� �� ������ ��������� (�������� �������� � ����������)
	if params.sender == 'ShowHideBtn' then
		if common.GetBitAnd( params.kbFlags, KBF_SHIFT ) ~= 0 then
		--if common.IsKeyEnabled( 0x10 ) then
			StartRemember() -- ������/��������� ������
		else
			SettingsShowMenu() -- ������� ������ ��������
			SettingsScanItem() -- ��������� ���������
		end
	end

	-- ���� �� ������ D (������/��������� ������)
	if params.sender == 'ShowHideSettingsBtn' then
		--StartRemember() -- ������/��������� ������
	end

	-- ���� �� ������ � (��������) (������� ���������� ����� ������. ���������� �������� � ������ ����������� ������)
	if params.sender == 'ButtonClear' then
		SettingsClearTextLineInput( parent )
	end

end


---------------------------------------------------------------------------------------------------
-- ������� ��������� ������� ������� �� ���������� ������ Esc �� �������� ������ (�� ������)
function OnKbdPressEsc( params )

	SettingsShowMenu() -- ��������

end


---------------------------------------------------------------------------------------------------
-- ������� ��������� ������� ������� �� ���������� ������ Enter �� �������� ������ (�� ������)
function OnKbdPressEnt( params )

	SaveRememberData() -- ���������� ������ ��������� � ����������
	SettingsShowMenu() -- ��������

end


---------------------------------------------------------------------------------------------------
-- ������� ��������� ������� ��� ��������� �� ������/������ (�� ������)
function OnWidgetPoint (params)

	-- ���� �������� ����� ��������� �� �������� �������
	if ShowHelpText ~= 1 then
		return
	end



	if params.active then 
		--local text = "����� ����������"
		--Log(text, nil, 14)
		
		
		-- ���� � ������� ��� ������� ����� ��� � ������. ���� ���� �� ������ � ���� �����
		if not wdt.itemDescSet then
			-- �������� ��������� �������
			wdt.itemDescSet = wdt.RememberViewText:GetWidgetDesc()
			-- �� ��������� ������� ����� ������
			wdt.HelpViewText = mainForm:CreateWidgetByDesc( wdt.itemDescSet )
			--wdt.HelpViewText = wdt.RememberView:CreateWidgetByDesc( wdt.itemDescSet )
			
			-- ����������� ��� �������
			wdt.HelpViewText:SetName( "HelpView" )
			
			-- ������ ������� �������� �������������� ������
			wdt.HelpViewText:SetMultiline( true )
			wdt.HelpViewText:SetWrapText( true )
			
			--- ���������� ����� �����
			--wdt.HelpViewText:SetLinespacing( 21 )
			
			-- ������ ������ ������� (������) �������
			local format = "<body alignx='left' fontname='AllodsWest' fontsize='14"
			format = format.."' shadow='1' ><rs class='color'><r name='myrmyrEE'/><br /><r name='myrmyr'/><br /><r name='myrmyrE'/></rs></body>"
			wdt.HelpViewText:SetFormat(userMods.ToWString(format))
			
			-- ������ ���� � ������������ ������ � ����
			wdt.HelpViewText:SetTextColor( nil, { a = 0.7, r = 125, g = 125, b = 125 } )
			wdt.HelpViewText:SetTextColor( nil, { a = 0.1, r = 255, g = 0, b = 0 }, ENUM_ColorType_SHADOW )
			--wdt.HelpViewText:SetTextColor( nil, { a = 0.1, r = 0, g = 1, b = 1 }, ENUM_ColorType_TEXT )
			--wdt.HelpViewText:SetTextColor( nil, { a = 1, r = 0, g = 0, b = 0 }, ENUM_ColorType_OUTLINE )
			wdt.HelpViewText:SetTextColor( nil, { a = 0.3, r = 0, g = 0, b = 0 }, ENUM_ColorType_OUTLINE )
			
			--wdt.HelpViewText:SetTextColor( userMods.ToWString("myrmyr"), { a = 0.5, r = 1, g = 0, b = 0 }, ENUM_ColorType_TEXT )
			
			-- ������ �������� ��� ����������� ������ � ��� rs (���� ������) 
			--local style = "ColorWhite"
			--wdt.HelpViewText:SetClassVal( "class", style )
			
		end
		
		
		-- ������ ���������� ������������ ���������� ������� (����� ��������� ���������� ������� � ������������ ���� ������������� ����)
		local pw = wdt.RememberView:GetPlacementPlain()
			--pw.alignX = WIDGET_ALIGN_LOW
			--pw.alignY = WIDGET_ALIGN_LOW
			pw.posX = pw.posX+50
			pw.posY = pw.posY+30
		wdt.HelpViewText:SetPlacementPlain(pw)
		
		
		-- ����� ���������
		local text = "[���] - ������� ���������"
		local textE = "[���+shift] - ���/���� �����"
		local textEE = AddonName
		
		
		wdt.HelpViewText:SetVal( "myrmyr", text )
		wdt.HelpViewText:SetVal( "myrmyrE", textE )
		wdt.HelpViewText:SetVal( "myrmyrEE", textEE )
		
		
		-- ���������� ����� ���������
		wdt.HelpViewText:Show( true )
	else
		-- �������� ����� ���������
		wdt.HelpViewText:Show( false )
		
		--local text = "����� ����������"
		--Log(text, nil, 14)
	end

end


---------------------------------------------------------------------------------------------------
-- ������� ���������� �������� (�� �����)
function SaveRememberData()
	-- ��������� ��������� ������ � �������� �����������
	local config = {}
	-- ���������� ������ � �������� � ���������� ������ �������� ������
	for key, val in pairs(var.itemsSettings) do
		
		-- ����� ��� ������ (��� �� � DB_RememberValueWidget_arr)
		local WidgetName = val:GetName()
		
		-- ����� ��������� ����� � �������������
		local DateLocalClient = common.GetLocalDateTime()
		
		
		
		-- ������������ ������ �� ���������� ���� �����
		-- �������� ������ �� ��������� ����
		local TextDateM = val:GetChildChecked( "TextLineInputDateM", true ):GetText()
		-- ���� ���� ������ �� ����������� �������� 0
		if not TextDateM then
			--TextDateMFromWStr=0
			TextDateM=0
		end
		-- ���������� ����� � ������� �� �������������
		local TextDateMStr = userMods.FromWString( TextDateM )
		-- ������ �� ����� ����� ��������. �� ����� ��� �.�. ���� � �������
		TextDateMStr = string.gsub(TextDateMStr, "[�-� �-߸�a-zA-Z %D]", "")
		--TextDateMFromWStr = string.gsub(TextDateMFromWStr, "", "0")
		-- ������ ��� ���������� ��� ��������
		TextDateMStr = tonumber(TextDateMStr)
		
		-- ��������� ������������ �� ����� � ���������� �� ��������� (����=12, ���=0, �������������� �����)
		TextDateMStr = OnEventCheckNum( 12, 0, TextDateMStr )
		
		-- ������� ��� ����������. ���� ����� ����� ���� �� ��������� ������� ��� ����� ��� ������� ������ ����. (��� ������� ������� ��� ��� ������)
		local TextDateMStrCopy
		if TextDateMStr == 0 then
			TextDateMStrCopy = DateLocalClient.m
		else
			TextDateMStrCopy = TextDateMStr
		end
		
		
		
		-- ������������ ������ �� ���������� ���� ����
		-- �������� ������ �� ��������� ����
		local TextDateD = val:GetChildChecked( "TextLineInputDateD", true ):GetText()
		-- ���� ���� ������ �� ����������� �������� 0
		if not TextDateD then
			TextDateD=0
		end
		-- ���������� ����� � ������� �� �������������
		local TextDateDStr = userMods.FromWString( TextDateD )
		-- ������ �� ����� ����� ��������. �� ����� ��� �.�. ���� � �������
		TextDateDStr = string.gsub(TextDateDStr, "[�-� �-߸�a-zA-Z %D]", "")
		-- ������ ��� ���������� ��� ��������
		TextDateDStr = tonumber(TextDateDStr)

		--GetTextDateDFromWStr = string.gsub(GetTextDateDFromWStr, "%D", "0")
		if TextDateDStr == 0 and TextDateDStr <=0 then
			-- ��������� ������������ �� ���� � ���������� �� ��������� (����=0, ���=0, �������������� �����) ���� ����� � ���� ������ ��� 0
			TextDateDStr = OnEventCheckNum( 0, 0, TextDateDStr )
		else
			--[[
			-- ��������� ��� � ����������� �� ������ 
			if (TextDateMStrCopy == 1) or (TextDateMStrCopy == 3) or (TextDateMStrCopy == 5) or (TextDateMStrCopy == 7) or (TextDateMStrCopy == 8) or (TextDateMStrCopy == 10) or (TextDateMStrCopy == 12) then
				TextDateDStr = OnEventCheckNum( 31, 1, TextDateDStr )
				--GetTextDateDFromWStr = string.find("ytytuyuyu 11.12.13.14", "(%d+)")
			elseif TextDateMStrCopy == 4 or TextDateMStrCopy == 6 or TextDateMStrCopy == 9 or TextDateMStrCopy == 11 then
				TextDateDStr = OnEventCheckNum( 30, 1, TextDateDStr )
			elseif TextDateMStrCopy == 2 then
				-- ���������� ���������� ���� � ������� � ����������� �� ���� ���������� ��� ��� ���
				-- ������� �� ������� ������� �� 4 (���� 0 �� ��� ����������)
				if math.fmod( DateLocalClient.y, 4 ) == 0 then
				--if DateLocalClient.y == 2016 or DateLocalClient.y == 2020 or DateLocalClient.y == 2024 then
					TextDateDStr = OnEventCheckNum( 29, 1, TextDateDStr )
				else
					TextDateDStr = OnEventCheckNum( 28, 1, TextDateDStr )
				end
			end
			]]
			
			--��� ����� ���� ���������� �������� �� ����
			
			-- ������� ���������� ���� � ������ �� ������ � ����
			local DaysCountInMonth = mission.GetMonthDaysCount( TextDateMStrCopy, DateLocalClient.y )
			-- ��������� ������������ �� ���� � ���������� �� ��������� (����=� ����������� �� ������, ���=1, �������������� �����)
			TextDateDStr = OnEventCheckNum( DaysCountInMonth, 1, TextDateDStr )
			
		end
		
		
		
		-- ������������ ������ �� ���������� ���� ����
		-- �������� ������ �� ��������� ����
		local TextDateH = val:GetChildChecked( "TextLineInputDateH", true ):GetText()
		-- ���� ���� ������ �� ����������� �������� 0
		if not TextDateH then
			TextDateH=0
		end
		-- ���������� ����� � ������� �� �������������
		local TextDateHStr = userMods.FromWString( TextDateH )
		-- ������ �� ����� ����� ��������. �� ����� ��� �.�. ���� � �������
		TextDateHStr = string.gsub(TextDateHStr, "[�-� �-߸�a-zA-Z %D]", "")
		-- ������ ��� ���������� ��� ��������
		TextDateHStr = tonumber(TextDateHStr)
		
		-- ��������� ������������ �� ���� � ���������� �� ��������� (����=23, ���=0, �������������� �����)
		TextDateHStr = OnEventCheckNum( 23, 0, TextDateHStr )
		
		
		
		-- ������������ ������ �� ���������� ���� ������
		-- �������� ������ �� ��������� ����
		local TextDateMin = val:GetChildChecked( "TextLineInputDateMin", true ):GetText()
		-- ���� ���� ������ �� ����������� �������� 0
		if not TextDateMin then
			TextDateMin=0
		end
		-- ���������� ����� � ������� �� �������������
		local TextDateMinStr = userMods.FromWString( TextDateMin )
		-- ������ �� ����� ����� ��������. �� ����� ��� �.�. ���� � �������
		TextDateMinStr = string.gsub(TextDateMinStr, "[�-� �-߸�a-zA-Z %D]", "")
		-- ������ ��� ���������� ��� ��������
		TextDateMinStr = tonumber(TextDateMinStr)
		
		-- ��������� ������������ �� ������ � ���������� �� ��������� (����=59, ���=0, �������������� �����)
		TextDateMinStr = OnEventCheckNum( 59, 0, TextDateMinStr )
		
		
		
		-- ������������ ������ �� ���������� ���� ���� �����������
		-- �������� ������ �� ��������� ����
		local TextDateName = val:GetChildChecked( "TextLineInputDateName", true ):GetText()
		-- ���� ���� ������ �� ����������� �������� 0
		if not TextDateName then
			TextDateName=""
		end
		-- ���������� ����� � ������� �� �������������
		local TextDateNameStr = userMods.FromWString( TextDateName )
		-- ������ �� ����� ����� ��������. �� ����� ��� �.�. ���� � ������� (����� ����������� ������ �� ";")
		TextDateNameStr = string.gsub(TextDateNameStr, "[^�-� �-߸�a-zA-Z0-9%(%)%[%]%,%.%@%'!?%*%-%_%+%=%#%�%{%}]", "")
		-- �������� ������� � ������ � � ����� ������
		TextDateNameStr = TextDateNameStr:match("^%s*(.*)%s*$")
		
		
		
		-- ���� ���� ������� � ������� ����� �� ����������� ������� (����������� ������ �� ����� � �������, �� ���� � ������� �������)
		if TextDateDStr >0 and TextDateMStr == 0 then
			TextDateMStr = DateLocalClient.m
		end
		
		
		-- ������������ � ����� (������� ��� ���������) ����� ��� �������� ����������� �� ���� ��� ���� ���� ������� ��� ������
		local DateLocalClientYear
		if (TextDateMStr < DateLocalClient.m and TextDateDStr < DateLocalClient.d) or (TextDateMStr == DateLocalClient.m and TextDateDStr < DateLocalClient.d) then
			DateLocalClientYear = DateLocalClient.y+1
		else
			DateLocalClientYear = DateLocalClient.y
		end
		
		
		-- ��������� ���� � ������������
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
		
		
		-- ����������� �������� � ���������� ���� ������������ ��������� �� ���������
		if TextDateNameStr ==nil or TextDateNameStr =="" then
			TextDateNameStr = " "
			TimeToMs = -1
		end
		
		
		--local text = GetTextDateDFromWStr.."."..GetTextDateMFromWStr.." "..GetTextDateHFromWStr..":"..GetTextDateMinFromWStr.."||"..GetTextDateNameFromWStr.."   key="..key.."   val="..WidgetName
		--Log(text, nil, 14)
		
		
		-- �������� ��� ������� �� �����
		local WidgetNameNum = string.gsub(WidgetName, "val", "")
		-- ���� ���� ������� ������ 9 � ����� ����������� ����������� �� ��� �� �������� � ������ � �� ��������� ����� �� ������� ������
		if tonumber(WidgetNameNum) > 9 and TextDateNameStr ==" " then
		else
			table.insert(config, 1, WidgetName..";"..TextDateNameStr..";"..TimeToMs )
		end
	end
	-- ������� ������ �������. ���� �� ������ ���� �� ������ ������ (�.�. ���� � ��� ���� ���� ����� �� ���������� � �������� �� ������� �� � ���� ������������ - ��)
	if GetTableSize(config) > 0 then
		--userMods.SetAvatarConfigSection ("AMF_mountList", config)
		userMods.SetGlobalConfigSection ("REMEMBER_AddonRememberDataGlobal", config)
		
		LoadRememberData()
	end
end


--------------------------------------------------------------------------------------------------
-- ������� �������� �������� (�� ����� ��� ������� ����)
function LoadRememberData()

	-- ��������� ������ �������� �� �� (�� ����� ������������)
	local config = userMods.GetGlobalConfigSection("REMEMBER_AddonRememberDataGlobal")
	
	-- �������� ������ � �������� ������� ��� ���������� �����������
	DB_RememberDateRepeat_arr = {}
	
	DB_RememberDate_arr = {}
	DB_RememberName_arr = {}
	
	-- ������� ����������� ���� � ���������� ����������� �� ������ ���
	local LocalDateTime = common.GetLocalDateTime()
	MsDayStart = common.GetMsFromDateTime( {y=LocalDateTime.y, m=LocalDateTime.m, d=LocalDateTime.d} )
	
	if config then
		-- ���������� ������
		for _, val in pairs(config) do
			
			--[[local _, _, a, b, c, d = string.find("10 11;12; tr13; 14 15tyt \0", "(%d+)%;(%Z+)%;(%Z+)%;(%Z+)")
			local a, b, c, d = string.match("10 11;12; tr13; 14 15tyt \0", "(%d+)%;(%Z+)%;(%Z+)%;(%Z+)")]]

			-- ����������� ������
			--local a, b, c = string.match(val, "(%S*)%;(%S*)%;(%S*)") -- �� ������ �������
			--local a, b, c = string.match(val, "(%Z+)%;(%Z+)%;(%Z+)") -- �� ������� �����
			--local a, b, c = string.match(val, "(.+)%;(.+)%;(.+)") -- ����� ������
			local remValueWidget, remName, remDate = string.match(val, "(%Z+)%;(%Z+)%;(%Z+)")
			
			-- �������� ������� � ������ � � ����� ������
			remName = remName:match("^%s*(.*)%s*$")
			remDate = remDate:match("^%s*(.*)%s*$")
			
			-- ����������� �������� � ���������� ���� ��� �����
			remName = remName or "non"
			remDate = remDate or "-1"
			
			-- ������������ ������ ����� �����
			remDate = tonumber(remDate)
			
			--local text = "remValueWidget="..remValueWidget.." remName="..remName.." remDate="..remDate
			--Log(text, nil, 14)
			
			-- ������������ ������ �� ��������
			DB_RememberDate_arr[remValueWidget] = remDate -- ������ � ����� �� ��������
			DB_RememberName_arr[remValueWidget] = remName -- ������ � ������� ����������� � ��������
			--DB_RememberValueWidget_arr = {} -- ������ � ������ ������� ������ �� ��������
			--DB_RememberDateRepeat_arr[remValueWidget] = {} -- ������ � �������� ������� ��� ���������� �����������
			
			
			-- ���� ���� ������ 24 ����� �� ���������� ��� ����������
			if remDate < 86400000 and remDate > 0 then
				DB_RememberDateRepeat_arr[remValueWidget] = 1
				DB_RememberDate_arr[remValueWidget] = remDate+MsDayStart -- ���������� � ���������� ������������ ���������� ����������� �� ������ ���
				
				DB_RememberNameTime_arr[(remDate+MsDayStart)] = remName -- ������ � ������� ����������� �� �������� (����� � �������� �����)
			else
				DB_RememberDateRepeat_arr[remValueWidget] = 0
				
				DB_RememberNameTime_arr[remDate] = remName -- ������ � ������� ����������� �� �������� (����� � �������� �����)
			end

		end
	elseif not config then
		for i=1, 9 do
			local valueWidget = "val"..tostring( i )
			
			-- ������������ ������ �� ��������
			DB_RememberDate_arr[valueWidget] = -1 -- ������ � ����� �� ��������
			DB_RememberName_arr[valueWidget] = "" -- ������ � ������� ����������� � ��������
			--DB_RememberValueWidget_arr = {} -- ������ � ������ ������� ������ �� ��������
			DB_RememberDateRepeat_arr[valueWidget] = 1 -- ������ � �������� ������� ��� ���������� �����������
		end
	end
	-- ��������� ������� ������������ ������ ����� ����� ��������� ����������� ������� � ���������� ������ � ����������� ������
	--SettingsScanItem()
	SettingsAddPlusItem()
end


---------------------------------------------------------------------------------------------------
-- ������� �������� ����� ���� � ������� (����� ������������ � �������� �� ���������)
function OnEventCheckNum( maxNum, minNum, Num )

	-- �������
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
-- ������� ��������� ������� ������� ����� ������ ���� �� �������� ������
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
			local text = "�������"
			Log(text, nil, 14)
			
			-- ��������� ������� �������� ������������ ������� (�� �������)
			common.RegisterEventHandler(onEventAutoSpeakNPC, "EVENT_SECOND_TIMER")
		end
		if (stateScreenBtnA == 0) then
			local text = "����������"
			Log(text, nil, 14)
			
			-- ������������� ������� �������� ������������ ������� (�� �������)
			common.UnRegisterEventHandler(onEventAutoSpeakNPC, "EVENT_SECOND_TIMER")
		end

	end

end]]


---------------------------------------------------------------------------------------------------
-- ������� ��������� ��������� ������ (�� ����-������� �� ����)
function OnEventUnknownSlashCommand( params )

	-- ������� ��������� ���������� �� ����-�������� ��������������� �� ��������������� ������ � ����������
	local cmd = userMods.FromWString( params.text )
	
	-- ���� ����-������� ����� ����� �� ��������� ������� � ����������� ������
	if cmd == "/remember" then
		SettingsShowMenu()
	end

end


--------------------------------------------------------------------------------
-- CHECKED AVATAR AND DATE		�������� �������� �������, ���� � ������ �� ������ ������ �������� ��������
--------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- ������� �������� ����
function OnEventCheckDate( params )

	-- �������� ������� ���� � ������������� �� ��� �������� unix (1-�� ������ 1970-�� ����)
	local TimePresent = common.GetMsFromDateTime( common.GetLocalDateTime() )
	
	local timeTable = {}
		timeTable.y = 2020
		timeTable.m = 01
		timeTable.d = 20
	local TimeStop = common.GetMsFromDateTime( timeTable )

	-- ���������� � �������� � ������
	local StartAllow = true
	
	--if (TimeStop >= TimePresent) then
	if (TimeStop <= TimePresent) then
		--OnEventAvatarCreatedRun()
		StartAllow = false
	end
	
	
	local TimeStopWarning = 432000000 --//5 �����
	local TimeStopWarningT = TimeStop - TimeStopWarning
	
	-- ������� � ��� �������������� �� ���������� ������ �� 5 �����
	if (TimeStopWarningT <= TimePresent) then
		local text = "����� ���������� "..string.format( "%02d", timeTable.d).."."..string.format( "%02d", timeTable.m).."."..timeTable.y..". �������������� �����. www.alloder.pro/"
		Log(text, nil, 14)
	end

	return StartAllow

end


---------------------------------------------------------------------------------------------------
-- ������� ��������� ������� ����� ������� �������� ��������� (����� � ����)
function OnEventAvatarCreatedRun()
	--OnEventRET()

end


---------------------------------------------------------------------------------------------------
-- ������� ������������� � ������� �������� ����� � ���� (����� ��� ������)
function OnEventAvatarCreated()

	-- �������� �� �������
--	if not OnEventCheckDate() then
--		wdt.RememberView:Show( false )
--		return
--	end
	
	
	-- ��������� ������� ����������� ������. � ������������ �� ����� ������� ��������� ������
	--LangSetup( GetGameLocalization() )
	LangSetup( common.GetLocalization() )
	
	-- ��������� ������� �������� �������� �� �����
	LoadRememberData()
	
	-- ��������� ������� ����������� �� ����-������� ���� (�� ����-������� �� ����)
	common.RegisterEventHandler( OnEventUnknownSlashCommand, "EVENT_UNKNOWN_SLASH_COMMAND" )
	
	-- ��������� ������� ����������� ������� �� ��������
	common.RegisterEventHandler( RememberDateMath, "EVENT_SECOND_TIMER" )
	
	-- ��������� ������� �������� ������������ ������� (�� �������)
--	common.RegisterEventHandler(onEventAutoSpeakNPC, "EVENT_SECOND_TIMER")

end


--------------------------------------------------------------------------------
-- INITIALIZATION		������������� �������
--------------------------------------------------------------------------------
function Init()
	-- �������:
	-- ������� ������
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
	
	
	-- ������� �������������� ������� (���� ������� ��������� � ����������)
	--DnD.Init( wdt.ShowHideBtn, wdt.ShowHideBtn, true )
	DnD.Init( wdt.RememberView, wdt.ShowHideBtn, true, true, {0,-450,0,0} )
	DnD.Init( wdt.MainPanelSettings, mainForm:GetChildChecked( "HeaderTextPanelSettingsAddon", true ), true )
	
	-- ������� �� ���� ����� ������ ���� �� ������� (�� ������)
	common.RegisterReactionHandler( OnMouseLeftClick, "mouse_left_click" )
	
	-- ������� �� ���� ������ � �������� ������� (�� ������)
	common.RegisterReactionHandler( OnKbdPressEsc, "rESC" )
	common.RegisterReactionHandler( OnKbdPressEnt, "rEnt" )
	
	-- ������� ��� ��������� �� ������/������ (�� ������)
	common.RegisterReactionHandler( OnWidgetPoint, "show_help" )
	
	
	-- �������� ������� ��� �������� ����� (��� ����� � ����)
	common.RegisterEventHandler(OnEventAvatarCreated, "EVENT_AVATAR_CREATED")
	-- �������� ������� ���� ���� ��� ������
	if avatar.IsExist() then
		OnEventAvatarCreated()
	end
	
end
--------------------------------------------------------------------------------
-- ��������� �������������
Init()
--------------------------------------------------------------------------------