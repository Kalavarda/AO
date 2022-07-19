--------------------------------------------------------------------------------
-- GLOBALS
--------------------------------------------------------------------------------
Global( "RELEASE", "68" )
Global( "wtMainPanel", mainForm:GetChildChecked( "MainPanel", false ))
Global( "wtTitleText", nil )
Global( "wtNewsText", nil )
Global( "wtDescFon", nil )
Global( "wtDescription", nil )
Global( "wtSort_NUM", nil )
Global( "wtSort_NAME", nil )
Global( "wtSort_CLS", nil )
Global( "wtSort_LVL", nil )
Global( "wtSort_TAB", nil )
Global( "wtSort_RNK", nil )
Global( "wtSort_AUTH", nil )
Global( "wtSort_MAUTH", nil)
Global( "wtSort_MFAME", nil)
Global( "wtSort_LOY", nil )
Global( "wtSort_JOIN", nil )
Global( "wtSort_WFAME", nil )
Global( "wtSort_ACT", nil )
Global( "wtSort_ZONE", nil )
Global( "wtPanelMenu", nil )
Global( "wtTextTELL",nil)
Global( "wtButtonListAll", nil )
Global( "wtButtonGuiFriend", nil )
Global( "wtButtonSize", nil )
Global( "wtFooter", nil )
Global( "wtFooterPage", nil )
Global( "wtButtonExport", nil )
Global( "GBEStatus", false )
Global( "wtButtonGBE", nil )
Global( "dy", 80+20 )
Global( "dyStart", 80+20 )
Global( "wtButtons_TELL", {} )
Global( "wtRowBtn", {} )
Global( "wtShowHideBtn", {} )
Global( "wtCell", {} )
Global( "PanelFlagMenu", false )
Global( "SLOT_PREFIX", "Form" )
Global( "GUILD", {})
Global( "GId", {})
Global( "count", 0)
Global( "List", 1)							-- номер показываемой страницы
Global( "ListMax", 1)						-- максимальное кол-во страниц
Global( "PagePixel", { [10]=335+20, [20]=535+20, [30]=735+20 } )	-- размер по высоте
Global( "LastON", nil)
Global( "LastOFF", nil)
Global( "GuildExist", false)			-- флаг существования гильдии
Global( "FriendExist", false)			-- флаг существования друзей
Global( "GuiFriend", "Guild")			-- какой список выводить
Global( "FriendChange", {})				-- событие у друга
Global( "LastNameInfo", nil )
Global( "SelfRank", 7 )
Global( "LastOnlineCache", { Member = {} } )
Global( "GameLanguage", "eng" )
Global( "Config", {} )
Global( "col", { NUM=1, NAME=2, CLS_ICO=3, CLASS=4, LVL=5, TAB=6, RNK=7, AUTH=8, MAUTH=9, MFAME = 10, LOYAL=11, JOIN=12, WFAME=13, ACT=14, ZONE=15 } )

local GetCurrencyInfo

--------------------------------------------------------------------------------
-- REACTION HANDLERS
--------------------------------------------------------------------------------
local IsAOPanelEnabled = GetConfig( "EnableAOPanel" ) or GetConfig( "EnableAOPanel" ) == nil

function OnAOPanelStart( params )
	local SetVal = { val =  ToWS("G") } 
	local params = { header =  SetVal , ptype =  "button" , size = 30 } 
	userMods.SendEvent( 'AOPANEL_SEND_ADDON', { name = common.GetAddonName(), sysName = common.GetAddonName(), param = params } )
	wtShowHideBtn:Show(false)
end

function OnAOPanelButtonLeftClick( params )
 if params.sender==common.GetAddonName() then  OnReactionShowHide( params ) end  	
end

function onAOPanelChange( params )
	if params.unloading and params.name == "UserAddon/AOPanelMod" then
		wtShowHideBtn:Show( true )
	end
end

function enableAOPanelIntegration( enable )
	IsAOPanelEnabled = enable
	SetConfig( "EnableAOPanel", enable )
	if enable then
		onAOPanelStart()
	else
		wtShowHideBtn:Show( true )
	end
end

function outputList ()
	if not wtMainPanel:IsVisible() then return end
	ClearList()
	wtMainPanel:Show( true )
	dy = dyStart
	CreateList()
end

-- "EVENT_GUILD_MEMBER_ONLINE"
function OnEventGuildOnline (params )
	LastON = params.name
	if not group.IsLeader and LastOnlineCache then -- AO 1.1.02/03/04
		SetTableElementByWStringIndex( LastOnlineCache.Member, params.name, nil )
	end
	outputList ()
end

-- "EVENT_GUILD_MEMBER_OFFLINE"
function OnEventGuildOffline (params )
	LastOFF = params.name
	if not group.IsLeader and LastOnlineCache then -- AO 1.1.02/03/04
		if mission.GetWorldTimeHMS then -- AO 1.1.03/04
			SetTableElementByWStringIndex( LastOnlineCache.Member, params.name, GetCurrentDateTime() )
		else -- AO 1.1.02
			SetTableElementByWStringIndex( LastOnlineCache.Member, params.name, 1 ) -- 1ms, for better sorting.
		end
	end
	outputList ()
end

function OnEventGuildOnlineOffline(params)
if guild.GetMemberInfo( params.id ).onlineStatus == "ENUM_AvatarOnlineStatus_Online" then
OnEventGuildOnline (params )
else
OnEventGuildOffline (params )
end
end

function OnEventGuildChanged (params )
	outputList ()
end

function OnEventGuildMessage (params )
	wtNewsText:SetVal( "NEWS", guild.GetMessage() )
end

-- события списка друзей --

-- "EVENT_AVATAR_FRIEND_ONLINE_CHANGED"
function OnEventFriendOnline( params )
	if LastOnlineCache then
		if params.isOnline then
			SetTableElementByWStringIndex( LastOnlineCache.Member, params.name, nil )
		else
			if mission.GetWorldTimeHMS then -- AO 1.1.03+
				SetTableElementByWStringIndex( LastOnlineCache.Member, params.name, GetCurrentDateTime() )
			else -- AO 1.1.02
				SetTableElementByWStringIndex( LastOnlineCache.Member, params.name, 1 ) -- 1ms, for better sorting.
			end
		end
	end
	outputList ()
end

function OnEventFriendAdd (params )
	outputList ()
end

function OnEventFriendRemoved (params )
	outputList ()
end

function OnEventFriendMutual (params )
if social.IsFriendListLoaded() then
	local members = social.GetFriendList()
	if GetTableSize( members ) ~= 0 then
		for i = 0, GetTableSize( members ) - 1 do
			if social.GetFriendInfo then -- AO 1.1.04+
				members[i] = social.GetFriendInfo( members[i] )
			end
			FriendChange[i].name = members[i].name
			if common.CompareWStringEx( params.name, FriendChange[i].name ) == 0 then
				if params.isMutual then
					FriendChange[i].mutual = 10
				else
					FriendChange[i].mutual = 11
				end
			end
		end
	end
	outputList ()
	end
end

-- "EVENT_AVATAR_CREATED" 
function OnEventAvatarCreated()
	SelectViewMode()	
	-- Applying localization.
	GameLanguage = common.GetLocalization()
	Config.Language = GetConfig( "Language" ) or GameLanguage -- User selected language (MUST have locale)
	if not GameLanguage then
		Config.Language = "eng_eu"
	end
	SignChange()
	-- Friends' lastOnline updates ONCE per session, so it MUST be collected right now.
	--LastOnline_CollectFriends()
end

-- проверка существования гильдии и списка друзей
function SelectViewMode()
	if guild.IsExist() then
		GuildExist = true
	end
	if GetTableSize( social.GetFriendList() ) ~= 0 then
		FriendExist = true
	end
	if not GuildExist then
		GuiFriend = "Friend"
	end
end

-- "Функция для отчистки списка гильдии"
function ClearList()
	wtPanelMenu:Show( false )
	for i = 0, 600 do
		wtRowBtn[i]:Show( false )
		for c,_ in pairs(wtCell) do
			wtCell[c][i]:Show( false )
		end
	end
end

function CreateBase ()
	local BaseList = {}

	if GuiFriend == "Guild" then
		local members = guild.GetMembers()
		for i = 0, GetTableSize( members ) - 1 do
			BaseList[i] = {}
		end
		for i = 0, GetTableSize( members ) - 1 do
			if guild.GetMemberInfo then -- AO 1.1.03+
				members[i] = guild.GetMemberInfo( members[i] )
				BaseList[i].pid = members[i].playerId
				BaseList[i].lid = members[i].id
				BaseList[i].rank = guild.GetRank( BaseList[i].lid )
				-- Added in AO 1.1.03:
				BaseList[i].authority = members[i].authority
				BaseList[i].mauthority = members[i].monthAuthority
				BaseList[i].fame = members[i].fame
				BaseList[i].monthFame = members[i].monthFame
				BaseList[i].loyalty = members[i].loyalty
				BaseList[i].tabardType = members[i].tabardType
				BaseList[i].sysTabardType = members[i].sysTabardType
				BaseList[i].joinTime = NormalizeJoinDate( members[i].joinTime )
				BaseList[i].sysClassName = members[i].sysClassName
				BaseList[i].balance = guild.GetMemberBalance( members[i].id )/10000
				BaseList[i].guildcomment = guild.GetMemberDescription(members[i].id)
				--Prestige and Fame added in MWar afterpatch. Setras. 
				--Prestige removed for 5.0.x version. RoZher.
				BaseList[i].totlFame = 0
				BaseList[i].longFame = 0
				BaseList[i].mediumFame = 0
				BaseList[i].shortFame = 0
				
				BaseList[i].totlSymb = 0
				BaseList[i].longSymb = 0
				BaseList[i].mediumSymb = 0
				BaseList[i].shortSymb = 0
				if members[i].profit then
				for ii, vv in pairs(members[i].profit) do
					local info = vv.key and GetCurrencyInfo(vv.key)
					if info ~= nil then
						if info.sysName == "MWResourcePvP" then
						BaseList[i].totlFame = vv.value.totalProfit
						BaseList[i].longFame = vv.value.profitLongPeriod
						BaseList[i].mediumFame = vv.value.profitMediumPeriod
						BaseList[i].shortFame = vv.value.profitShortPeriod
						else
						BaseList[i].totlSymb = vv.value.totalProfit
						BaseList[i].longSymb = vv.value.profitLongPeriod
						BaseList[i].mediumSymb = vv.value.profitMediumPeriod
						BaseList[i].shortSymb = vv.value.profitShortPeriod
							end
						end
					end
				end
				---
				else
				BaseList[i].pid = members[i].id
				BaseList[i].lid = nil
				BaseList[i].rank = guild.GetRank( members[i].name )
			end
			BaseList[i].name = members[i].name
			BaseList[i].level = members[i].level
			BaseList[i].class = members[i].class
			BaseList[i].isConnect = (members[i].onlineStatus == "ENUM_AvatarOnlineStatus_Online")
			if group.IsLeader then -- AO 2.0.00+
				BaseList[i].lastOnline = ( not (members[i].onlineStatus == "ENUM_AvatarOnlineStatus_Online") ) and NormalizeLastOnline( members[i].lastOnlineTime ) or nil
				else -- AO 1.1.02/03/04
				BaseList[i].lastOnline = LastOnlineCache and GetTableElementByWStringIndex(LastOnlineCache.Member, members[i].name ) or nil
			end
			BaseList[i].zone = members[i].zoneName -- Available for offline players too.
			BaseList[i].subzone = members[i].subZoneName
		end
	elseif GuiFriend == "Friend" then
		local members = social.GetFriendList()
		for i = 0, GetTableSize( members ) - 1 do
			BaseList[i] = {}
		end
		local mapInfo = nil
		local mapId = nil
		for i = 0, GetTableSize( members ) - 1 do
			if social.GetFriendInfo then -- AO 1.1.04+
				members[i] = social.GetFriendInfo( members[i] )
				if members[i].isMutual then
					BaseList[i].rank = 10
				else
					BaseList[i].rank = 11
				end
				-- Added in AO 1.1.04:
				BaseList[i].lid = members[i].id
				BaseList[i].sex = members[i].sex.sex -- 1=M, 2=F.
				BaseList[i].raceSex = members[i].sex.raceSexName
				BaseList[i].isMutual = members[i].isMutual
			else
				BaseList[i].lid = nil
			end
			BaseList[i].isConnect = members[i].isLogged
			BaseList[i].lastOnline = nil
			if ( not members[i].isLogged ) and LastOnlineCache then
				local lastOnline = GetTableElementByWStringIndex( LastOnlineCache.Member, members[i].name )
				if not lastOnline then
					lastOnline = OfflineTimeToDateTime( members[i].lastOnlineTimeMs )
					SetTableElementByWStringIndex( LastOnlineCache.Member, members[i].name, lastOnline )
				end
				BaseList[i].lastOnline = lastOnline or nil
			end
			BaseList[i].name = members[i].name
			BaseList[i].level = members[i].level
			BaseList[i].class = members[i].raceClass.name
			BaseList[i].usercomment = members[i].description
			BaseList[i].sysClassName = members[i].raceClass.sysClassName
			BaseList[i].ClassName = members[i].raceClass.className
			BaseList[i].ClassSName = members[i].raceClass.sysName
			BaseList[i].subzone = nil
			mapId = members[i].mapId
			if BaseList[i].isConnect and mapId then
				BaseList[i].zone = cartographer.GetZonesMapInfo( mapId ).name
			else
				BaseList[i].zone = nil
			end
			if common.CompareWStringEx( BaseList[i].name, FriendChange[i].name ) == 0 then
				if FriendChange[i].mutual > 5 then
					BaseList[i].rank = FriendChange[i].mutual
				end
			end
		end	
	end
	return BaseList
end

-- функции сортировки списка --
function SortList (members,  param) -- TODO: Ugly sorting! It should use table.sort().
	local a,b,c
	for i = 0, GetTableSize( members ) - 1 do
		for k = i, GetTableSize( members ) - 1 do
			----------------------------------- получение нужной колонки
			local array, result = {}
			if param == "NAME" then
				b = members[i].name
				c = members[k].name
			elseif param == "WFAME" then
				b = members[i].longFame or 0
				c = members[k].longFame or 0
			elseif param == "CLS" then
				b = members[i].class
				c = members[k].class
			elseif param == "LVL" then
				b = members[i].level
				c = members[k].level
			elseif param == "TAB" then
				b = members[i].tabardType or members[i].sex or 0
				c = members[k].tabardType or members[k].sex or 0
			elseif param == "RNK" then
				b = members[i].rank
				c = members[k].rank
			elseif param == "AUTH" then
				b = members[i].authority or 0
				c = members[k].authority or 0
			elseif param == "MAUTH" then
				b = members[i].mauthority or 0
				c = members[k].mauthority or 0
			elseif param == "MFAME" then
				b = members[i].monthFame or 0
				c = members[k].monthFame or 0
			elseif param == "LOY" then
				b = members[i].loyalty or 0
				c = members[k].loyalty or 0
			elseif param == "JOIN" then
					b = members[i].joinTime and ( members[i].joinTime.y * 10000 + members[i].joinTime.m * 100 + members[i].joinTime.d ) or 0
					c = members[k].joinTime and ( members[k].joinTime.y * 10000 + members[k].joinTime.m * 100 + members[k].joinTime.d ) or 0
			elseif param == "ACT" then
				if mission.GetWorldTimeHMS then -- AO 1.1.03+
					b = members[i].isConnect and 99991231235959 or DateTimeToNumber( members[i].lastOnline )
					c = members[k].isConnect and 99991231235959 or DateTimeToNumber( members[k].lastOnline )
				else
					b = members[i].isConnect and -1 or ( members[i].lastOnline or 0 )
					c = members[k].isConnect and -1 or ( members[k].lastOnline or 0 )
				end
			elseif param == "ZONE" then
				b = members[i].zone or common.GetEmptyWString()
				c = members[k].zone or common.GetEmptyWString()
			end
 			if b and c then
				if common.IsWString(b) and common.IsWString(c) then	----------------------------------- проверка типа данных
					if Config.SortOrder == "AZ" then -- сортировка вниз или вверх
						if common.CompareWStringEx( b, c ) == 1 then
							a = members[i]
							members[i] = members[k]
							members[k] = a
						end
					else
						if common.CompareWStringEx( b, c ) == -1 then
							a = members[i]
							members[i] = members[k]
							members[k] = a
						end
					end
				else
					if common.IsWString(b) and not common.IsWString(c) then
						b = 0
					end
					if not common.IsWString(b) and common.IsWString(c) then
						c = 0
					end
					if Config.SortOrder == "AZ" then
						if b > c then
							a = members[i]
							members[i] = members[k]
							members[k] = a
						end
					else
						if b < c then
							a = members[i]
							members[i] = members[k]
							members[k] = a
						end
					end
				end
			end
		end
	end
	return members
end
-- "Создает список гильдии"

function CreateList()
	if not wtMainPanel:IsVisible() then return end

	local members = CreateBase()
	
	count = 0
	local OnlineMember = 0
	local str1 = (List - 1) * Config.PageSize + 1
	local str2 = str1 + Config.PageSize - 1
	if Config.SortBy ~= "none" then
		members = SortList (members, Config.SortBy)
	end
	
	local Now
	local Yest
	local DateSep
	local DateYesterday
	if mission.GetWorldTimeHMS then -- AO 1.1.03+
		Now = GetCurrentDateTime()
		Yest = GetYesterdayDateTime()
		DateSep = L("DateSep")
		DateYesterday = L( "DateYesterday" )..", "
	end

	for i = 0, GetTableSize( members ) - 1 do
		if members[i].isConnect or Config.ListAll then
			count = count + 1
			if members[i].isConnect then
				OnlineMember = OnlineMember + 1
			end
			if count >= str1 and count <= str2 then
				GUILD[count] = members[i]
-- установка позиций виджетов
				SetupTableRow( wtRowBtn[count], dy )
				for c,_ in pairs(wtCell) do
					SetupTableRow( wtCell[c][count], dy )
				end
--- имя
				if not members[i].isConnect then
					wtCell[col.NAME][count]:SetClassVal( "class", "tip_grey" )
				else
					wtCell[col.NAME][count]:SetClassVal( "class", "tip_green" )
				end
				wtCell[col.NAME][count]:SetVal( "INFO", members[i].name )
				if avatar.GetId() == members[i].pid then
					if guild.GetMemberInfo then -- AO 1.1.03+
						SelfRank = guild.GetRank( members[i].lid ) or 7
					else -- AO 1.1.02
						SelfRank = guild.GetRank( members[i].name ) or 7
					end
				end
--- уровень
				wtCell[col.LVL][count]:SetVal( "LVL", common.FormatInt( members[i].level , "%d" ) )
--- ранг
				wtCell[col.RNK][count]:SetVal( "RNK", common.GetEmptyWString() )
				if members[i].rank then
					if members[i].rank < 1 then
						wtCell[col.RNK][count]:SetClassVal( "class", "LegendaryWithoutShadow" )
					elseif members[i].rank < 3 then
						wtCell[col.RNK][count]:SetClassVal( "class", "tip_golden" )
					elseif members[i].rank == 6 then
						wtCell[col.RNK][count]:SetClassVal( "class", "tip_blue" )
					elseif members[i].rank == 7 then
						wtCell[col.RNK][count]:SetClassVal( "class", "tip_grey" )
					elseif members[i].rank == 8 then 
						wtCell[col.RNK][count]:SetClassVal( "class", "tip_red" )
					elseif members[i].rank == 9 then 
						wtCell[col.RNK][count]:SetClassVal( "class", "tip_red" )
					elseif members[i].rank == 10 then -- Friend Mutual
						wtCell[col.RNK][count]:SetClassVal( "class", "tip_golden" )
					elseif members[i].rank == 11 then -- Friend Not mutual
						wtCell[col.RNK][count]:SetClassVal( "class", "tip_grey" )
					else
						wtCell[col.RNK][count]:SetClassVal( "class", "tip_white" )
					end
					if members[i].rank < 11 and guild.GetMemberInfo then -- Standard rank & AO 1.1.03+
						wtCell[col.RNK][count]:SetVal( "RNK", guild.GetRankInfo( members[i].rank ).name )
					else -- Mutual check(don`t work :c )
						wtCell[col.RNK][count]:SetVal( "RNK", L( "Rnk" .. members[i].rank ) )
					end
				end
--- авторитет, лояльность, накидка, дата вступления
				if GuiFriend == "Guild" and guild.GetMemberInfo then -- AO 1.1.03+
					local DateSep = L( "DateSep" )
					wtCell[col.JOIN][count]:SetVal( "JOIN", ToWS( string.format( "%d%s%02d%s%02d", members[i].joinTime.y, DateSep, members[i].joinTime.m, DateSep, members[i].joinTime.d ) ) )
					wtCell[col.AUTH][count]:SetVal( "AUTH", common.FormatInt( members[i].authority, "%dK5" ) )
					wtCell[col.MAUTH][count]:SetVal( "MAUTH", common.FormatInt( members[i].mauthority, "%dK5" ) )
					wtCell[col.MFAME][count]:SetVal( "MFAME", common.FormatInt( members[i].monthFame, "%dK5" ) )
					wtCell[col.LOYAL][count]:SetVal( "LOYAL", common.FormatInt( members[i].loyalty, "%d" ) )
					wtCell[col.WFAME][count]:SetVal( "WFAME", common.FormatInt( members[i].longFame, "%dK5" ) )
					wtCell[col.TAB][count]:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("TABARD" .. members[i].tabardType))
				else -- For Friends (ALL versions) and for old Guild versions (AO 1.1.02)
					wtCell[col.JOIN][count]:SetVal( "JOIN", common.GetEmptyWString() )
					wtCell[col.AUTH][count]:SetVal( "AUTH", common.GetEmptyWString()  )
					wtCell[col.MAUTH][count]:SetVal( "MAUTH", common.GetEmptyWString() )
					wtCell[col.MFAME][count]:SetVal( "MFAME", common.GetEmptyWString() )
					wtCell[col.LOYAL][count]:SetVal( "LOYAL", common.GetEmptyWString() )
					wtCell[col.WFAME][count]:SetVal( "WFAME", common.GetEmptyWString() )
					wtCell[col.TAB][count]:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("TABARD0"))
				end
--- пол
				if GuiFriend == "Friend" then
					if social.GetFriendInfo then -- AO 1.1.04+
						wtCell[col.TAB][count]:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("SEX" .. members[i].sex))
					else
						wtCell[col.TAB][count]:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("SEX0"))
					end
				end
--- порядковый номер, выделение последнего зашедшего/вышедшего
				local last_on = 2
				local last_off = 2
				if LastON then
					last_on = common.CompareWStringEx( LastON, members[i].name )
				end
				if LastOFF then
					last_off = common.CompareWStringEx( LastOFF, members[i].name )
				end
				if last_on == 0 or last_off == 0 then
					wtCell[col.NUM][count]:SetClassVal( "class", "tip_red" )
				else
					wtCell[col.NUM][count]:SetClassVal( "class", "tip_yellow" )
				end
				wtCell[col.NUM][count]:SetVal( "NUM", common.FormatInt( count, "%d" ) )
--- зона, подзона
				wtCell[col.ZONE][count]:SetClassVal( "class", members[i].isConnect and "tip_green" or "tip_grey" )
				wtCell[col.ZONE][count]:SetVal( "ZONE", members[i].zone or common.GetEmptyWString() )
				if GuiFriend == "Guild" and members[i].subzone and not common.IsEmptyWString( members[i].subzone ) then
					wtCell[col.ZONE][count]:SetVal( "SEP", L( "ZoneSep" ) )
					wtCell[col.ZONE][count]:SetVal( "SUBZONE", members[i].subzone )
				else
					wtCell[col.ZONE][count]:SetVal( "SEP", common.GetEmptyWString() )
					wtCell[col.ZONE][count]:SetVal( "SUBZONE", common.GetEmptyWString() )
				end
--- активность, время оффлайн
				wtCell[col.ACT][count]:SetClassVal( "class", members[i].isConnect and "tip_green" or "tip_grey" )
				if mission.GetWorldTimeHMS then -- AO 1.1.03+
					wtCell[col.ACT][count]:SetVal("ACT", members[i].isConnect and L( "ListAll2" ) or common.GetEmptyWString() )
					if members[i].lastOnline and not members[i].isConnect then
					
						local time = string.format( "%02d:%02d", members[i].lastOnline.h, members[i].lastOnline.min )
						local date
						if members[i].lastOnline.y == Now.y and members[i].lastOnline.m == Now.m and members[i].lastOnline.d == Now.d then
							date = ""
						elseif members[i].lastOnline.y == Yest.y and members[i].lastOnline.m == Yest.m and members[i].lastOnline.d == Yest.d then
							date = DateYesterday
						else
							date = string.format( "%d%s%02d%s%02d, ", members[i].lastOnline.d, DateSep, members[i].lastOnline.m, DateSep, members[i].lastOnline.y )
						end
						wtCell[col.ACT][count]:SetVal( "TIME", ToWS( date .. time ) )
					else
						wtCell[col.ACT][count]:SetVal("TIME", common.GetEmptyWString() )
					end
				else -- AO 1.1.02
					wtCell[col.ACT][count]:SetVal("ACT", members[i].isConnect and L( "ListAll2" ) or L( "Offline" ) )
					wtCell[col.ACT][count]:SetVal("TIME", common.GetEmptyWString() )
					if members[i].lastOnline and not members[i].isConnect then
						local time = ""
						local minute = 0
						local hour = 0
						local day = 0
						local minute_local = FromWS( L( "Time_minute" ) )
						local hour_local = FromWS( L( "Time_hour" ) )
						local day_local = FromWS( L( "Time_day" ) )
						minute = math.floor (members[i].lastOnline / 60000)
						hour = math.floor (minute / 60)
						day = math.floor (hour / 24)
						minute = minute - hour * 60
						hour = hour - day * 24
						if minute < 10 and hour > 0 then
							minute = "0" .. minute
						end
						if day == 0 then
							time = ": " .. hour .. hour_local .. minute .. minute_local
						else
							if hour < 10 then
								hour = "0" .. hour
							end
							time = ": " .. day .. day_local .. hour .. hour_local
						end
						time = ToWS (time)
						wtCell[col.ACT][count]:SetVal("TIME", time)
					end
				end
--- класс
				if not common.IsEmptyWString( members[i].class ) then
					local clsName = members[i].sysClassName
					if clsName then
						wtCell[col.CLS_ICO][count]:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture(clsName))
						wtCell[col.CLS_ICO][count]:SetBackgroundColor( ClassColorsIcons[ clsName ] )
					end
					if not members[i].isConnect then
						wtCell[col.CLASS][count]:SetClassVal( "class", "tip_grey" )
					else
						wtCell[col.CLASS][count]:SetClassVal( "class", "tip_green" )
					end
				else
					wtCell[col.CLS_ICO][count]:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("SEX0"))
					wtCell[col.CLS_ICO][count]:SetBackgroundColor( { r = 1.0; g = 1.0; b = 1.0; a = 1.0 } )
				end
				wtCell[col.CLASS][count]:SetVal( "CLASS", members[i].class )
----------
				wtRowBtn[count]:Show( true )
				for c,_ in pairs(wtCell) do
					wtCell[c][count]:Show( true )
				end
				dy = dy + 20
			end
		end
	end
	ListMax = math.ceil ( count / Config.PageSize )
	wtFooterPage:SetVal( "PAGE", common.FormatInt( List , "%d" ) )
--- Guild News and Description...
	if GuildExist then
		local news = guild.GetMessage()
		local desc = guild.GetDescription()
		wtNewsText:SetVal( "NEWS", news )
		local sizeY = 350
		local dlina = string.len(FromWS( desc ))
		sizeY = math.ceil ( dlina / 160 ) * 25 + 45 -- 160 is very very approximately, lol
		local Placement = wtDescFon:GetPlacementPlain()
		Placement.sizeY = sizeY
		wtDescFon:SetPlacementPlain( Placement )
		wtDescription:SetVal( "DESC", desc )
	end
--- Window Title...
	wtTitleText:SetAlignY ( 1 ) 
	wtTitleText:SetFormat (ToWS("<html><body alignx='center' fontsize='14' outline='1'><tip_green><r name='TITLE'/></tip_green></body><body alignx='center' fontsize='14' outline='1'><Golden><r name='TXT1'/></Golden></body><body alignx='center' fontsize='14' outline='1'><Golden><r name='ONLINE'/></Golden></body><body alignx='center' fontsize='14' outline='1'><Golden><r name='TXT2'/></Golden></body><body alignx='center' fontsize='14' outline='1'><Golden><r name='TOTAL'/></Golden></body><body alignx='center' fontsize='14' outline='1'><tip_green><r name='AUTH'/></tip_green></body><body alignx='center' fontsize='14' outline='1'><Golden><r name='GLEVELS'/></Golden></body><body alignx='center' fontsize='14' outline='1'><tip_green><r name='SP'/></tip_green></body><body alignx='center' fontsize='14' outline='1'><Golden><r name='SPLVL'/></Golden></body><body alignx='center' fontsize='14' outline='1'><Golden><r name='SPTXT1'/></Golden></body><body alignx='center' fontsize='14' outline='1'><Golden><r name='SPTXT2'/></Golden></body><body alignx='center' fontsize='14' outline='1'><Golden><r name='NEXTLVL'/></Golden></body><body alignx='center' fontsize='14' outline='1'><Golden><r name='SPTOTAL'/></Golden></body></html>" ))
	wtTitleText:SetVal( "TXT1", L( "TitleTXT1" ) )
	wtTitleText:SetVal( "TXT2", L( "TitleTXT2" ) )
	wtTitleText:SetVal( "TOTAL", " "..FromWS((common.FormatInt( GetTableSize( members ) , "%d" )))..") " )
	wtTitleText:SetVal( "ONLINE", ": ("..FromWS(common.FormatInt( OnlineMember , "%d" )).." " )
	if GuiFriend == "Guild" then
		wtTitleText:SetVal( "TITLE", FromWS(guild.GetName()).." " )
		if guild.GetMemberInfo then -- AO 1.1.03+
			local GP = guild.GetProgress()
			local GSP = guild.GetSeasonProgress()
			local LevelPercent = string.format( ".%02d", ( GP.authority - GP.minAuthority ) / ( GP.maxAuthority - GP.minAuthority ) * 100 )
			local ap = common.FormatInt( GP.maxAuthority-GP.authority, "%dK5" )
			wtTitleText:SetVal( "GLEVELS", "("..L( "Sort_LVL" ).." "..GP.level..LevelPercent .."/"..GP.unlockedLevel..L("NextLevel")..FromWS(ap).." " )
			local LevelSeasonPercent = string.format( ".%02d", ( GSP.authority - GSP.minAuthority ) / ( GSP.maxAuthority - GSP.minAuthority ) * 100 )
			wtTitleText:SetVal( "AUTH", L("GuildAut") )
			wtTitleText:SetVal("SP", L("SeasonPrestige"))
			wtTitleText:SetVal("SPLVL", "("..L( "Sort_LVL" ))
			wtTitleText:SetVal("SPTXT1", " "..tostring(GSP.level)..LevelSeasonPercent.."/")
			wtTitleText:SetVal("SPTXT2", tostring(GSP.unlockedLevel))
			wtTitleText:SetVal("NEXTLVL", L("NextLevel"))
			wtTitleText:SetVal("SPTOTAL", common.FormatInt( GSP.maxAuthority-GSP.authority, "%dK5" ))
			wtTitleText:Show(true)
		else
			wtTitleText:SetVal( "GLEVELS", common.GetEmptyWString() )		
		end
	else
		wtTitleText:SetVal( "TITLE", L( "Friend").." " )
		wtTitleText:SetVal( "GLEVELS", common.GetEmptyWString() )
		wtTitleText:SetVal( "SP", common.GetEmptyWString() )
		wtTitleText:SetVal( "SPLVL", common.GetEmptyWString() )
		wtTitleText:SetVal( "AUTH", common.GetEmptyWString() )
		wtTitleText:SetVal( "SPTXT1", common.GetEmptyWString() )
		wtTitleText:SetVal( "SPTXT2", common.GetEmptyWString() )
		wtTitleText:SetVal( "NEXTLVL", common.GetEmptyWString() )
		wtTitleText:SetVal( "SPTOTAL", common.GetEmptyWString() )
	end
end
------------------------------------------------------------------------


------------Функция для установки динамических контроллов---------------

function SetWidgetPos( wtWidget, posX, posY )
	local Placement = wtWidget:GetPlacementPlain()
	Placement.posX = posX
	Placement.posY = posY
	wtWidget:SetPlacementPlain( Placement )
end

function SetupTableColumn( wtCell, iPosX, iWidth )
	local p = wtCell:GetPlacementPlain()
	p.sizeX = iWidth
	p.posX = iPosX
	p.posY = 80
	wtCell:SetPlacementPlain( p )
end

function SetupTableRow( wtCell, iPosY )
	local p = wtCell:GetPlacementPlain()
	p.posY = iPosY
	wtCell:SetPlacementPlain( p )
end

function onLoadGBE()
local addons = common.GetStateManagedAddons()
for i = 0, GetTableSize( addons ) - 1 do
  local info = addons[i]
  if not info.loaded then
	if info.name == "UserAddon/GuildBalanceEdit" then
			if info.isLoaded then wtButtonGBE:Show(true)
			else wtButtonGBE:Show(false)
				end
			end
		end
	end
end

function onGBEChange(params)
if params.unloading and params.name == "UserAddon/GuildBalanceEdit" then
wtButtonGBE:Show(false)
GBEStatus = false
elseif params.loading and params.name == "UserAddon/GuildBalanceEdit" then
wtButtonGBE:Show(true)
GBEStatus = true
	end
end

function onReactionGBE()
userMods.SendEvent( "GBE_VISIBLE", { visible = true } )
end

-- "Мини-кнопка показать/скрыть главное окно"
function OnReactionShowHide( params )
	if DnD:IsDragging() then return end
	SelectViewMode()	-- проверка на существование гильдии
	ClearList()
	if wtMainPanel:IsVisible() then
		wtMainPanel:Show( false )
		SetConfig( Config ) -- Saving Config.
	else
		dy = dyStart
		wtMainPanel:Show( true )
		CreateList()
	end
end

function OnReactionPushNick( params )
	local sender = string.sub( params.sender, string.len( SLOT_PREFIX ) + 1 )
	local slotIndex = tonumber( sender )
	GId = GUILD[slotIndex]
	if common.IsEmptyWString( GId.name ) then return end -- Sometimes AO gives a friendlist filled with empty values.
	local chatLineParams = {}
	chatLineParams.name = GId.name
	wtTextTELL:SetVal( "INFO", chatLineParams.name )
	if params.x ~= 0 or params.y ~= 0 then -- Unknown game version, I guess, AO 1.1.03.
		local Screen = widgetsSystem:GetPosConverterParams()
		local X = math.floor( params.x * Screen.fullVirtualSizeX / Screen.realSizeX )
		local Y = math.floor( params.y * Screen.fullVirtualSizeY / Screen.realSizeY )
		SetWidgetPos( wtPanelMenu, X, Y )
	else -- AO 1.1.02 :(
		local WindowPos = wtMainPanel:GetPlacementPlain()
		local SenderPos = params.widget:GetPlacementPlain()
		SetWidgetPos( wtPanelMenu, WindowPos.posX + SenderPos.posX + 172, WindowPos.posY + SenderPos.posY + SenderPos.sizeY - 8 )
	end
	if not PanelFlagMenu or LastNameInfo == chatLineParams.name then
		PanelFlagMenu = not PanelFlagMenu
	end
	wtPanelMenu:Show( PanelFlagMenu )
	LastNameInfo = chatLineParams.name

-- формирование меню
	HideTELL ()
	local strok = 0
	-- Пригласить в группу
	if group.InviteByName and group.CanInvite() and GId.isConnect and GId.pid ~= avatar.GetId() then
		strok = strok + 1
		ShowTELL (strok, 1)
	end
	-- Выйти из гильдии
	if GId.pid == avatar.GetId() and SelfRank > 0 then
		strok = strok + 1
		ShowTELL (strok, 4)
	end
	-- Исключить из списка
	if GuiFriend == "Friend" then
		strok = strok + 1
		ShowTELL (strok, 5)
	end
	-- Добавить к друзьям
	if GuiFriend == "Guild" then
		local frnd = social.GetFriendList()
		local frnd_exist = false
		if FriendExist == true then
			for i = 0, GetTableSize( frnd ) - 1 do
				if social.GetFriendInfo then -- AO 1.1.04+
					frnd[i] = social.GetFriendInfo( frnd[i] )
				end
				if common.CompareWStringEx( frnd[i].name, GId.name ) == 0 then
					frnd_exist = true
				end
			end
		end
		if not frnd_exist and GId.pid ~= avatar.GetId() then
			strok = strok + 1
			ShowTELL (strok, 8)
		end
	end
	-- Закрыть
	strok = strok + 1
	ShowTELL (strok, 3)
	
	local Placement = wtPanelMenu:GetPlacementPlain()
	Placement.sizeY = 40 + 20 * strok
	wtPanelMenu:SetPlacementPlain( Placement )
end

function OnReactionCloseContextMenu(params)
	PanelFlagMenu = false
	wtPanelMenu:Show( false )
end

function OnReactionPush(params)
--	LogInfo(params.sender)
	-- Пригласить в группу
	if params.sender == "Push1" then
		group.InviteByName( GId.name )
	end
	-- Осмотреть
	if params.sender == "Push2" and GId.pid then
		avatar.SelectTarget( GId.pid )
		avatar.StartInspect()
	end
	-- Закрыть
	if params.sender == "Push3" then
		-- Nothing, just closing menu.
	end
	-- Выйти из гильдии
	if params.sender == "Push4" then
		--guild.Leave()
	end
	-- Исключить из списка
	if params.sender == "Push5" then
		social.RemoveFriend( GId.name )
	end
	-- Добавить к друзьям
	if params.sender == "Push8" then
		social.AddFriend( GId.name, common.GetEmptyWString() )
	end
	wtPanelMenu:Show( false )
	PanelFlagMenu = false
end

function HideTELL ()
	for i = 1, 8 do
		wtButtons_TELL[i]:Show(false)
	end
end
function ShowTELL (strok, NumPush)
	wtButtons_TELL[NumPush]:Show ( true )
	SetWidgetPos( wtButtons_TELL[NumPush], 10, 5 + strok * 20  )
end

function OnReaction( params )
	if count > Config.PageSize then
		ClearList()
		if params.name == "listnext" then
			if  List < ListMax then
				List = List + 1
			else 
				List = 1
			end
		else
			if  List > 1 then
				List = List - 1
			else
				List = ListMax
			end
		end
		wtFooterPage:SetVal( "PAGE", common.FormatInt( List , "%d" ) )
		dy = dyStart
		CreateList()
	end
end

function OnReactionListAll( params )
	ClearList()
	if Config.ListAll then
		wtButtonListAll:SetVal( "button_label", ToWS(L( "ListAll2" )) )
	else
		wtButtonListAll:SetVal( "button_label", ToWS(L( "ListAll1" )) )
	end
	Config.ListAll = not Config.ListAll
	List = 1
	dy = dyStart
	CreateList()
end

function OnReactionGuiFriend( params )
	ClearList()
	if GuiFriend == "Guild" and FriendExist then
		GuiFriend = "Friend"
	elseif GuiFriend == "Friend" and GuildExist then
		GuiFriend = "Guild"
	end
	wtButtonGuiFriend:SetVal( "button_label", ToWS(L( GuiFriend ) ))
	List = 1
	dy = dyStart
	CreateList()
end

function OnReactionSizeChange()
	if Config.PageSize == 10 then
		Config.PageSize = 20
		wtButtonSize:SetVal( "button_label", ToWS("20") )
	elseif Config.PageSize == 20 then
		Config.PageSize = 30
		wtButtonSize:SetVal( "button_label", ToWS("30") )
	elseif Config.PageSize == 30 then
		Config.PageSize = 10
		wtButtonSize:SetVal( "button_label",ToWS("10") )
	end
	local MainPanelPlacement = wtMainPanel:GetPlacementPlain()
	MainPanelPlacement.sizeY = PagePixel[ Config.PageSize ]
	dy = dyStart
	ListMax = 1
	List = 1
	ClearList()
	CreateList()
	wtMainPanel:SetPlacementPlain( MainPanelPlacement )
end

function OnReactionExport()
	local Now = 0
	local timestamp = ""
	if mission.GetWorldTimeHMS then -- AO 1.1.03+
		Now = GetCurrentDateTime()
		timestamp = string.format( " @ %d-%02d-%02d %02d:%02d:%02d", Now.y, Now.m, Now.d, Now.h, Now.min, Now.s )
	end
	if guild.GetMemberInfo then -- AO 1.1.03+
		-- Guild Info.
		if GuiFriend == "Guild" then
			local x, y
			LogInfo( "" )
			LogInfo(L("GuildInfo"), timestamp )
			LogInfo(L("GuildName"), guild.GetName() )
			x = guild.GetProgress()
			LogInfo(L("GuildLvl"), x.level, " / ", x.unlockedLevel )
			LogInfo(L("GuildAut"), x.authority, " / ", x.maxAuthority, " ( ", math.ceil( ( x.authority - x.minAuthority ) / ( x.maxAuthority - x.minAuthority ) * 100 ), "% )" )
			LogInfo(L("GuildNextLvl"), ( x.unlockedLevel + 1 ) , L("GuildNextLv2"), x.nextLevelPrice/10000, " ", L("GuildNextLv3") )
			LogInfo(L("GuildLeader"), guild.GetMemberInfo( guild.GetLeader() ).name )
			x = guild.GetEnableTime()
			x = string.format( "%d-%02d-%02d", x.y, x.m, x.d )
			LogInfo(L("GuildEnable"), x )
			LogInfo(L("GuildMembers"), GetTableSize( guild.GetMembers() )," / 150" )
			LogInfo(L("GuildMoney"), guild.GetMoney() )
			LogInfo(L("GuildCurr") )
			x = guild.GetCurrencies()
			for i, v in pairs(x) do
				local y = v and GetCurrencyInfo(v);
				if y ~= nil and y.name ~= nil then
					LogInfo( "\t", y.name, ": ", y.value );
				end
			end
			if not x[0] then LogInfo( "\tnone" ) end
			LogInfo( L("GuildTabards") )
			x = guild.GetTabards()
			LogInfo( L("GuildTabards1"), x[1] or 0 )
			LogInfo( L("GuildTabards2"), x[2] or 0)
			LogInfo( L("GuildTabardsBonus") )
			for i, v in pairs(guild.GetTabardBonus()) do LogInfo( ";", "\t", i, ": ", v ) end
			LogInfo( L("GuildDesc"), guild.GetDescription() )
			LogInfo( L("GuildMessage"), guild.GetMessage() )
		end
	end
	local m = CreateBase()
	if Config.SortBy ~= "none" then
		m = SortList( m, Config.SortBy )
	end
	LogInfo( "" )
	-- Guild Members.
	if GuiFriend == "Guild" then
		LogInfo( "GUILD MEMBERS (CSV format)", timestamp )
		if guild.GetMemberInfo then -- AO 1.1.03+
			LogInfo( ";#;",L("Sort_NAME"),";", L("Sort_CLS"), ";", L("ExportLevel"),";", L("ExportTabard"), ";", L("Sort_RNK"), ";", L("ExportA"), ";", L("ExportMA"), ";", L("ExportFame"), ";" , L("ExportMFame"), ";" , L("ExportLoy"), ";", L("Sort_JOIN"), ";", L("Sort_ACT"), ";", L("ListAll2"), ";", L("Sort_ZONE"), ";", L("Fame"), ";", L("LongFame"),";", L("MediumFame"),";", L("ShortFame"), ";",L("Symbols"), ";", L("LongSymbols"),";", L("MediumSymbols"),";", L("ShortSymbols"), ";",L("Balance"))
			for i = 0, GetTableSize( m ) - 1 do
				m[i].joinTime = string.format( "%d-%02d-%02d", m[i].joinTime.y, m[i].joinTime.m, m[i].joinTime.d )
				--m[i].sysClassName = string.sub( m[i].sysClassName, 1, 1) .. string.lower( string.sub( m[i].sysClassName, 2) )
				m[i].lastOnline = DateTimeToString( m[i].isConnect and Now or m[i].lastOnline )
				if social.GetFriendInfo then -- AO 1.1.04+
					m[i].sysTabardType = string.sub( m[i].sysTabardType, 17 )
				end
				m[i].zone = m[i].zone or "-"
				local zonesep = ", "
				
				
				if not m[i].subzone or common.IsEmptyWString( m[i].subzone ) then m[i].subzone = "" zonesep = "" end
				LogInfo( ";", (i+1), ";", m[i].name, ";", m[i].class, ";", m[i].level, ";", L(m[i].sysTabardType), ";", guild.GetRankInfo( m[i].rank ).name, ";", m[i].authority, ";", m[i].mauthority, ";", m[i].fame ,";", m[i].monthFame , ";", m[i].loyalty, ";", m[i].joinTime, ";", m[i].isConnect, ";", m[i].lastOnline, ";", m[i].zone,zonesep,m[i].subzone,";",m[i].totlFame,";",m[i].longFame,";",m[i].mediumFame,";",m[i].shortFame,";",m[i].totlSymb,";",m[i].longSymb,";",m[i].mediumSymb,";",m[i].shortSymb,";", m[i].balance )
			end
		else -- AO 1.1.02
			LogInfo( ";#;", L("Sort_NAME"), ";", L("Sort_CLS"), ";", L("ExportLevel"), ";", L("Sort_RNK"), ";", L("ListAll2"), ";" , L("Sort_ZONE")  )
			for i = 0, GetTableSize( m ) - 1 do
				m[i].lastOnline = DateTimeToString( m[i].isConnect and 0 or m[i].lastOnline )
				m[i].zone = m[i].zone or "-"
				local zonesep = ", "
				if not m[i].subzone or common.IsEmptyWString( m[i].subzone ) then m[i].subzone = "" zonesep = "" end
				LogInfo( ";", (i+1), ";", m[i].name, ";", m[i].class, ";", m[i].level, ";", guild.GetRankInfo( m[i].rank ).name, ";", L(m[i].isConnect), ";", m[i].lastOnline, ";", m[i].zone,zonesep,m[i].subzone )
			end
		end
	-- Or Friends.
	elseif GuiFriend == "Friend" then
		LogInfo( ";", "FRIENDS (CSV format)", timestamp )
		if social.GetFriendInfo then -- AO 1.1.04+
			LogInfo( ";#;", L("Sort_NAME"), ";", L("Sort_CLS"), ";", L("ExportLevel"), ";", L("Sex"), ";", L("Race"), ";", L("Friendship"), ";", L("ListAll2"), ";" , L("Sort_ZONE"), ";", L("Comment") )
		end
		for i = 0, GetTableSize( m ) - 1 do
			m[i].lastOnline = DateTimeToString( m[i].isConnect and Now or m[i].lastOnline )
			m[i].zone = m[i].zone or "-"
			m[i].usercomment = m[i].usercomment or ""
			if social.GetFriendInfo then -- AO 1.1.04+
				if m[i].sex == 1 then m[i].sex = L("Sex0")
				elseif m[i].sex == 2 then m[i].sex = L("Sex1")
				else m[i].sex = "Unknown"
				end
				m[i].isMutual = m[i].isMutual and ToWS("Yes") or L("No")
				LogInfo( ";", (i+1), ";", m[i].name, ";", m[i].class, ";", m[i].level, ";", m[i].sex, ";", m[i].raceSex, ";", m[i].isMutual, ";", m[i].lastOnline, ";", m[i].zone, ";", m[i].usercomment )
			end
		end
	end
	LogInfo( "" )
end


function DateTimeToString( dt )
	if not dt then return "?" end
	if mission.GetWorldTimeHMS then -- AO 1.1.03+
		return string.format( "%d-%02d-%02d %02d:%02d:%02d", dt.y, dt.m, dt.d, dt.h, dt.min, dt.s )
	else -- AO 1.1.02
		if dt == 0 then return "Online" end
		local m = 0
		local h = 0
		local d = 0
		m = math.floor (dt / 60000)
		h = math.floor (m / 60)
		d = math.floor (h / 24)
		m = m - h * 60
		h = h - d * 24
		return string.format( "%03dd %02dh %02dm", d,h,m )
	end
end

function OfflineTimeToDateTime( lastOnlineMs )
	if not lastOnlineMs then return nil end
	local lastOnline = common.GetDateTimeFromMs(lastOnlineMs)
	return lastOnline
end

function GetCurrentDateTime()
	return common.GetLocalDateTime()
end

function GetYesterdayDateTime()
	local d = GetCurrentDateTime()
	d.h = 0; d.min = 0; d.s = 0; d.d = d.d - 1
	if d.d > 0 then return d end
	local Months31 = { [0]=true, [1]=true, [3]=true, [5]=true, [7]=true, [8]=true, [10]=true }
	d.d = Months31[ d.m - 1 ] and 31 or 30
	if d.m - 1 == 2 then d.d = math.mod( d.m, 4 ) ~= 0 and 28 or 29 end; d.m = d.m - 1
	if d.m > 0 then return d end
	d.m = 12; d.y = d.y - 1
	return d
end

function DateTimeToNumber( dt )
	if type( dt ) ~= "table" then return 0 end
	return ( dt.y * 10000000000 + dt.m * 100000000 + dt.d * 1000000 + dt.h * 10000 + dt.min * 100 + dt.s )
end

function NumberToDateTime( n )
	if not n then n = 0 end
	local dt = {}
	dt.y = math.floor( n / 10000000000 )
	dt.m = math.floor( math.mod( n, 10000000000 ) / 100000000 )
	dt.d = math.floor( math.mod( n, 100000000 ) / 1000000 )
	dt.h = math.floor( math.mod( n, 1000000 ) / 10000 )
	dt.min = math.floor( math.mod( n, 10000 ) / 100 )
	dt.s = math.floor( math.mod( n, 100 ) )
	return dt
end

function NormalizeLastOnline( dt )
	if not dt then return nil end
	local lastOnlineStarted
	if GameLanguage == "rus" then
		lastOnlineStarted = 20100617000000 -- Дата появления параметра lastOnline в русской версии АО.
	elseif GameLanguage == "eng" or GameLanguage == "ger" or GameLanguage == "fra" then
		lastOnlineStarted = 20101005000000 -- Date when lastOnline patameter was added in EU/US AO.
	end
	return DateTimeToNumber( dt ) > lastOnlineStarted and dt or NumberToDateTime( lastOnlineStarted )
end

function NormalizeJoinDate( joinTime )
	local joinTimeMin
	if GameLanguage == "rus" then
		joinTimeMin = {y=2010,m=8,d=10} -- День, предшествовавший появлению параметра joinTime в русской версии АО.
	elseif GameLanguage == "eng_eu" or GameLanguage == "ger" or GameLanguage == "fra" then
		joinTimeMin = {y=2010,m=12,d=14} -- Day preceding the appearance of joinTime parameter in EU/US AO.
	end
	local iJT = joinTime.y * 10000 + joinTime.m * 100 + joinTime.d
	local iJTMin = joinTimeMin.y * 10000 + joinTimeMin.m * 100 + joinTimeMin.d
	if iJT < iJTMin then
		return joinTimeMin
	end
	return joinTime
end

------

function OnReactionSortNUM( params )
	ClearList()
	Config.SortBy = "none"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortNAME( params )
	ClearList()
	if Config.SortBy == "NAME" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "NAME" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "NAME"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortCLS( params )
	ClearList()
	if Config.SortBy == "CLS" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "CLS" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "CLS"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortLVL( params )
	ClearList()
	if Config.SortBy == "LVL" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "LVL" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "LVL"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortTAB( params )
	ClearList()
	if Config.SortBy == "TAB" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "TAB" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "TAB"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortRNK( params )
	ClearList()
	if Config.SortBy == "RNK" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "RNK" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "RNK"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortAUTH( params )
	ClearList()
	if Config.SortBy == "AUTH" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "AUTH" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "AUTH"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortMAUTH( params )
	ClearList()
	if Config.SortBy == "MAUTH" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "MAUTH" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "MAUTH"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortMFAME( params )
	ClearList()
	if Config.SortBy == "MFAME" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "MFAME" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "MFAME"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortLOY( params )
	ClearList()
	if Config.SortBy == "LOY" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "LOY" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "LOY"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortWFAME( params )
	ClearList()
	if Config.SortBy == "WFAME" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "WFAME" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "WFAME"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortJOIN( params )
	ClearList()
	if Config.SortBy == "JOIN" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "JOIN" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "JOIN"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortACT( params )
	ClearList()
	if Config.SortBy == "ACT" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "ACT" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "ACT"
	dy = dyStart
	List = 1
	CreateList()
end

function OnReactionSortZONE( params )
	ClearList()
	if Config.SortBy == "ZONE" and Config.SortOrder == "AZ" then
		Config.SortOrder = "ZA"
	elseif Config.SortBy == "ZONE" and Config.SortOrder == "ZA" then
		Config.SortOrder = "AZ"
	end
	Config.SortBy = "ZONE"
	dy = dyStart
	List = 1
	CreateList()
end

function SignChange()
	
	for i = 1, 8 do
		wtButtons_TELL[i]:SetVal( "button_label", ToWS(L( "message" .. i )) )

	end
	
	wtSort_NUM:SetVal( "button_label", ToWS(L( "Sort_NUM" )) )
	wtSort_NAME:SetVal( "button_label", ToWS(L( "Sort_NAME" )) )
	wtSort_CLS:SetVal( "button_label", ToWS(L( "Sort_CLS" )) )
	wtSort_LVL:SetVal( "button_label", ToWS(L( "Sort_LVL" )) )
	wtSort_TAB:SetVal( "button_label", ToWS(L( "Sort_TAB" )) )
	wtSort_RNK:SetVal( "button_label", ToWS(L( "Sort_RNK" )) )
	wtSort_AUTH:SetVal( "button_label", ToWS(L( "Sort_AUTH" )) )
	wtSort_MAUTH:SetVal( "button_label", ToWS(L( "Sort_MAUTH" ))) 
	wtSort_MFAME:SetVal( "button_label", ToWS(L( "Sort_MFAME" ))) 
	wtSort_LOY:SetVal( "button_label", ToWS(L( "Sort_LOY" )) )
	wtSort_JOIN:SetVal( "button_label", ToWS(L( "Sort_JOIN")) )
	wtSort_WFAME:SetVal( "button_label", ToWS(L( "Sort_WFAME")) )
	wtSort_ACT:SetVal( "button_label", ToWS(L( "Sort_ACT")) )
	wtSort_ZONE:SetVal( "button_label", ToWS(L( "Sort_ZONE")) )
	
	wtButtonSize:SetVal( "button_label", common.FormatNumber( Config.PageSize, "[3]A5" ) )
	wtButtonGuiFriend:SetVal( "button_label", ToWS(L( GuiFriend )) )
	if Config.ListAll then
		wtButtonListAll:SetVal( "button_label", ToWS(L( "ListAll1" )) )
	else
		wtButtonListAll:SetVal( "button_label", ToWS(L( "ListAll2" )) )
	end
	
	wtButtonExport:SetVal( "button_label", ToWS(L( "Export" )) )
	wtButtonGBE:SetVal( "button_label", ToWS(L("GBE")) )
	
	OnEventAMAddonInfoRequest( { target = common.GetAddonName() } ) -- Refreshing description.
end

function OnReactionDescription( params )
	if params.active and GuildExist then
		wtDescFon:Show(true)
	else
		wtDescFon:Show(false)
	end
end

-- "SCRIPT_ADDON_INFO_REQUEST" -- "Addon Manager", Sending addon info.
function OnEventAMAddonInfoRequest( params )
	if params.target == common.GetAddonName() then
		userMods.SendEvent( "SCRIPT_ADDON_INFO_RESPONSE", {
			sender = params.target,
			desc = L( "Description" ),
			showDNDButton = true,
			showHideButton = true,
			showSettingsButton = true,
		} )
	end
end

-- "SCRIPT_ADDON_MEM_REQUEST" -- "Addon Manager", Sending memory usage info.
function OnEventAMAddonMemoryRequest( params )
	if params.target == common.GetAddonName() then
		userMods.SendEvent( "SCRIPT_ADDON_MEM_RESPONSE", { sender = params.target, memUsage = gcinfo() } )
	end
end

-- "SCRIPT_SHOW_SETTINGS" -- "Addon Manager", Showing the Main window by request.
function OnEventAMShowSettings( params )
	if params.target == common.GetAddonName() then
		if not wtMainPanel:IsVisible() then
			OnReactionShowHide()
		end
	end
end

-- "SCRIPT_TOGGLE_VISIBILITY" -- "Addon Manager", Showing/hiding the show/hide button.
function OnEventAMToggleVisibility( params )
	if params.target == common.GetAddonName() then
		wtShowHideBtn:Show( params.state and true or false )
	end
end

-- "SCRIPT_TOGGLE_DND" -- "Addon Manager", Locking/unlocking the show/hide button.
function OnEventAMToggleDnD( params )
	if params.target == common.GetAddonName() then
		DnD:Enable( wtShowHideBtn, params.state )
	end
end

-- "SCRIPT_TOGGLE_UI" -- Alt+Z / ESC hiding.
function OnEventToggleUI( params )
	mainForm:Show( params.visible )
end

-- Astrum-Nival's GetTableSize() mystery revealed.
function GetTableSize( t )
	if not t then return 0 end
	return t[0] and table.getn(t)+1 or table.getn(t)
end

function SetTableElementByWStringIndex( tabTable, wsIndex, NewValue )
	tabTable[ FromWS( wsIndex ) ] = NewValue
end

function GetTableElementByWStringIndex( tabTable, wsIndex )
	return tabTable[ FromWS( wsIndex ) ]
end

-------------------------------------------------------------------------------
-- "INITIALIZATION"
--------------------------------------------------------------------------------
function Init()
	
	
	GetCurrencyInfo = avatar.GetCurrencyInfo or
		function ( Id )
			local info = Id:GetInfo() or {};
			local values = avatar.GetCurrencyValue( Id ) or {};
			info.value = values.value;
			return info;
		end


	if not math.mod then math.mod = math.fmod end
	mission.GetWorldTimeHMS=true

	common.RegisterReactionHandler( OnReactionShowHide, "ShowHideBtnReaction" )
	common.RegisterReactionHandler( OnReactionPushNick, "pushnick" )
	common.RegisterReactionHandler( OnReactionCloseContextMenu, "closecontextmenu" )
	common.RegisterReactionHandler( OnReactionPush, "push" )
	common.RegisterReactionHandler( OnReaction, "listnext" )
	common.RegisterReactionHandler( OnReaction, "listback" )
	common.RegisterReactionHandler( OnReactionExport, "export" )
	common.RegisterReactionHandler( onReactionGBE, "balance" )
	common.RegisterReactionHandler( OnReactionDescription, "description" )
	common.RegisterReactionHandler( OnReactionListAll, "listAll" )
	common.RegisterReactionHandler( OnReactionGuiFriend, "guifriend" )
	common.RegisterReactionHandler( OnReactionSizeChange, "SizeChange" )
	common.RegisterReactionHandler( OnReactionSortNUM, "Sort_NUM" )
	common.RegisterReactionHandler( OnReactionSortNAME, "Sort_NAME" )
	common.RegisterReactionHandler( OnReactionSortCLS, "Sort_CLS" )
	common.RegisterReactionHandler( OnReactionSortLVL, "Sort_LVL" )
	common.RegisterReactionHandler( OnReactionSortTAB, "Sort_TAB" )
	common.RegisterReactionHandler( OnReactionSortRNK, "Sort_RNK" )
	common.RegisterReactionHandler( OnReactionSortAUTH, "Sort_AUTH" )
	common.RegisterReactionHandler( OnReactionSortMAUTH, "Sort_MAUTH" )
	common.RegisterReactionHandler( OnReactionSortMFAME, "Sort_MFAME" )
	common.RegisterReactionHandler( OnReactionSortLOY, "Sort_LOY" )
	common.RegisterReactionHandler( OnReactionSortJOIN, "Sort_JOIN" )
	common.RegisterReactionHandler( OnReactionSortWFAME, "Sort_WFAME" )
	common.RegisterReactionHandler( OnReactionSortACT, "Sort_ACT" )
	common.RegisterReactionHandler( OnReactionSortZONE, "Sort_ZONE" )
	
	common.RegisterEventHandler( OnEventAvatarCreated, "EVENT_AVATAR_CREATED" )
	common.RegisterEventHandler( onGBEChange, "EVENT_ADDON_LOAD_STATE_CHANGED" )
	common.RegisterEventHandler( OnEventGuildOnline, "EVENT_GUILD_MEMBER_ONLINE" )
	common.RegisterEventHandler( OnEventGuildOnlineOffline, "EVENT_GUILD_MEMBER_ONLINE_STATUS_CHANGED" )
	common.RegisterEventHandler( OnEventGuildOffline, "EVENT_GUILD_MEMBER_OFFLINE" )
	common.RegisterEventHandler( OnEventGuildOnline, "EVENT_GUILD_MEMBER_ADDED" )
	common.RegisterEventHandler( OnEventGuildOffline, "EVENT_GUILD_MEMBER_REMOVED" )
	common.RegisterEventHandler( OnEventGuildMessage, "EVENT_GUILD_MESSAGE_CHANGED" )
	common.RegisterEventHandler( OnEventGuildChanged, "EVENT_GUILD_CHANGED" )
	
	common.RegisterEventHandler( OnEventFriendOnline, "EVENT_AVATAR_FRIEND_ONLINE_CHANGED" )
	common.RegisterEventHandler( OnEventFriendAdd, "EVENT_AVATAR_FRIEND_ADDED" )
	common.RegisterEventHandler( OnEventFriendRemoved, "EVENT_AVATAR_FRIEND_REMOVED" )
	common.RegisterEventHandler( OnEventFriendMutual, "EVENT_AVATAR_FRIEND_MUTUAL_CHANGED" )
	
	common.RegisterEventHandler( OnEventAMAddonInfoRequest, "SCRIPT_ADDON_INFO_REQUEST" )
	common.RegisterEventHandler( OnEventAMAddonMemoryRequest, "SCRIPT_ADDON_MEM_REQUEST" )
	common.RegisterEventHandler( OnEventAMShowSettings, "SCRIPT_SHOW_SETTINGS" )
	common.RegisterEventHandler( OnEventAMToggleVisibility, "SCRIPT_TOGGLE_VISIBILITY" )
	common.RegisterEventHandler( OnEventAMToggleDnD, "SCRIPT_TOGGLE_DND" )
	common.RegisterEventHandler( OnEventToggleUI, "SCRIPT_TOGGLE_UI" )
	common.RegisterEventHandler( OnAOPanelStart, "AOPANEL_START" ) 
    common.RegisterEventHandler( OnAOPanelButtonLeftClick, "AOPANEL_BUTTON_LEFT_CLICK" ) 
		common.RegisterEventHandler( onAOPanelChange, "EVENT_ADDON_LOAD_STATE_CHANGED" )
	
	wtMainPanel = mainForm:GetChildChecked( "MainPanel", false )
	wtShowHideBtn = mainForm:GetChildChecked( "ShowHideBtn", false )
	wtPanelMenu = mainForm:GetChildChecked( "PanelMenu", false )
	
	wtTitleText = 		wtMainPanel:GetChildChecked( "TitleText", false )


	wtNewsText = 		wtMainPanel:GetChildChecked( "News", false )
	wtDescFon =			wtMainPanel:GetChildChecked( "DescFon", false )
	
	wtSort_NUM = 	wtMainPanel:GetChildChecked( "Sort_NUM", false )
	wtSort_NAME = 	wtMainPanel:GetChildChecked( "Sort_NAME", false )
	wtSort_CLS = 	wtMainPanel:GetChildChecked( "Sort_CLS", false )
	wtSort_LVL = 	wtMainPanel:GetChildChecked( "Sort_LVL", false )
	wtSort_TAB = 	wtMainPanel:GetChildChecked( "Sort_TAB", false )
	wtSort_RNK = 	wtMainPanel:GetChildChecked( "Sort_RNK", false )
	wtSort_AUTH = 	wtMainPanel:GetChildChecked( "Sort_AUTH", false )
	wtSort_MAUTH = 	wtMainPanel:GetChildChecked( "Sort_MAUTH", false )
	wtSort_MFAME = 	wtMainPanel:GetChildChecked( "Sort_MFAME", false )
	wtSort_LOY = 	wtMainPanel:GetChildChecked( "Sort_LOY", false )
	wtSort_JOIN = 	wtMainPanel:GetChildChecked( "Sort_JOIN", false )
	wtSort_WFAME = 	wtMainPanel:GetChildChecked( "Sort_WFAME", false )
	wtSort_ACT = 	wtMainPanel:GetChildChecked( "Sort_ACT", false )
	wtSort_ZONE = 	wtMainPanel:GetChildChecked( "Sort_ZONE", false )

	local wtButtonA = 		wtMainPanel:GetChildChecked( "PushNick", false )
	local wtTextView_NUM = 	wtMainPanel:GetChildChecked( "TextView_NUM", false )
	local wtTextView_NAME = 	wtMainPanel:GetChildChecked( "TextView_INFO", false )
	local wtTextView_CLS_ICO = 	wtMainPanel:GetChildChecked( "TextView_CLS_ICO", false )
	local wtTextView_CLASS = 	wtMainPanel:GetChildChecked( "TextView_CLASS", false )
	local wtTextView_LVL = 	wtMainPanel:GetChildChecked( "TextView_LVL", false )
	local wtTextView_TAB = 	wtMainPanel:GetChildChecked( "TextView_TAB", false )
	local wtTextView_RNK = 	wtMainPanel:GetChildChecked( "TextView_RNK", false )
	local wtTextView_AUTH = 	wtMainPanel:GetChildChecked( "TextView_AUTH", false )
	local wtTextView_MAUTH = 	wtMainPanel:GetChildChecked( "TextView_MAUTH", false )
	local wtTextView_MFAME = 	wtMainPanel:GetChildChecked( "TextView_MFAME", false )
	local wtTextView_LOYAL = 	wtMainPanel:GetChildChecked( "TextView_LOYAL", false )
	local wtTextView_JOIN = 	wtMainPanel:GetChildChecked( "TextView_JOIN", false )
	local wtTextView_WFAME = 	wtMainPanel:GetChildChecked( "TextView_WFAME", false )
	local wtTextView_ACT = 	wtMainPanel:GetChildChecked( "TextView_ACT", false )
	local wtTextView_ZONE = 	wtMainPanel:GetChildChecked( "TextView_ZONE", false )

	-- Loading Config:
	Config.PageSize		= GetConfig( "PageSize" ) or 20				-- кол-во строк на странице
	Config.SortBy		= GetConfig( "SortBy" ) or "ACT"			-- тип сортировки
	Config.SortOrder	= GetConfig( "SortOrder" ) or "AZ"			-- способ сортировки
	Config.ListAll		= GetConfig( "ListAll" ) or false			-- показать только онлайн или всех
	Config.Language		= GameLanguage	-- выбранный язык. We'll update it on EventAvatarCreated, okay?

	-- Setting column positions and widths shouldn't be so hard ;) - SLA
	local WindowMarginsLeftRight = 20
	local TableColumnWidth = { 30,150,100,40,20,120,80,80,80,50,80,50,150,300 }
	local TableColumnPosX = {}
	for i,_ in pairs(TableColumnWidth) do
		TableColumnPosX[i] = WindowMarginsLeftRight
		for W=1, i-1 do TableColumnPosX[i] = TableColumnPosX[i] + TableColumnWidth[W] end
	end
	SetupTableColumn( wtSort_NUM, TableColumnPosX[1], TableColumnWidth[1] )
	SetupTableColumn( wtSort_NAME, TableColumnPosX[2], TableColumnWidth[2] )
	SetupTableColumn( wtSort_CLS, TableColumnPosX[3], TableColumnWidth[3] )
	SetupTableColumn( wtSort_LVL, TableColumnPosX[4], TableColumnWidth[4] )
	SetupTableColumn( wtSort_TAB, TableColumnPosX[5], TableColumnWidth[5]  )
	SetupTableColumn( wtSort_RNK, TableColumnPosX[6], TableColumnWidth[6] )
	SetupTableColumn( wtSort_AUTH, TableColumnPosX[7], TableColumnWidth[7] )
	SetupTableColumn( wtSort_MAUTH, TableColumnPosX[8], TableColumnWidth[8] )
	SetupTableColumn( wtSort_MFAME, TableColumnPosX[9], TableColumnWidth[9] )
	SetupTableColumn( wtSort_LOY, TableColumnPosX[10], TableColumnWidth[10] )
	SetupTableColumn( wtSort_JOIN, TableColumnPosX[11], TableColumnWidth[11] )
	SetupTableColumn( wtSort_WFAME, TableColumnPosX[12], TableColumnWidth[12] )
	SetupTableColumn( wtSort_ACT, TableColumnPosX[13], TableColumnWidth[13] )
	SetupTableColumn( wtSort_ZONE, TableColumnPosX[14], TableColumnWidth[14] )
	-- As well as main window size ;)
	local MainPanelPos = wtMainPanel:GetPlacementPlain()
	MainPanelPos.sizeX = TableColumnPosX[table.getn(TableColumnPosX)] + TableColumnWidth[table.getn(TableColumnWidth)] + WindowMarginsLeftRight
	MainPanelPos.posX = math.floor( widgetsSystem:GetPosConverterParams().fullVirtualSizeX - MainPanelPos.sizeX / 2 )
	MainPanelPos.sizeY = PagePixel[ Config.PageSize ] -- Height
	wtMainPanel:SetPlacementPlain( MainPanelPos )
	
	wtButtonListAll = 	wtMainPanel:GetChildChecked( "ListAll", false )
	wtButtonGuiFriend =	wtMainPanel:GetChildChecked( "GuiFriend", false )
	wtButtonSize = 		wtMainPanel:GetChildChecked( "ButtonSize", false )

	wtDescription =		wtDescFon:GetChildChecked( "Description", false )

	wtFooter = 		wtMainPanel:GetChildChecked( "Footer", false )
	wtFooterPage = 		wtFooter:GetChildChecked( "FooterPage", false )
	wtButtonExport = 	wtFooter:GetChildChecked( "ButtonExport", false )
	wtButtonGBE = wtFooter:GetChildChecked( "ButtonBalance", false )
	
	
	local wtButtonTELL = wtPanelMenu:GetChildChecked( "Push", false )
	wtTextTELL = wtPanelMenu:GetChildChecked( "TextTELL", false )

	for i = 1, 8 do
		wtButtons_TELL[i] = mainForm:CreateWidgetByDesc( wtButtonTELL:GetWidgetDesc() )
		wtPanelMenu:AddChild( wtButtons_TELL[i] )
		wtButtons_TELL[i]:SetName( "Push" .. i )
	--	wtButtons_TELL[i]:SetVal( "button_label", ToWS(L( "message" .. i )) )
		if i == 4 or i == 5 then
			wtButtons_TELL[i]:SetClassVal( "CLASS", "tip_red" )
		elseif i == 3 then
			wtButtons_TELL[i]:SetClassVal( "CLASS", "tip_grey" )
		end
	--	SetWidgetPos( wtButtons_TELL[i], 10, 5 + i*20  )
		wtButtons_TELL[i]:Show(false)
	end

	for _,c in pairs(col) do
		wtCell[c] = {}
	end
		for i = 0, 600 do
		wtRowBtn[i] = 		mainForm:CreateWidgetByDesc( wtButtonA:GetWidgetDesc() ) 
		wtRowBtn[i]:SetName( SLOT_PREFIX .. i )
		wtCell[col.NUM][i] = 	mainForm:CreateWidgetByDesc( wtTextView_NUM:GetWidgetDesc() ) 
		wtCell[col.NUM][i]:SetAlignY ( 1 )
		wtCell[col.NAME][i] = 	mainForm:CreateWidgetByDesc( wtTextView_NAME:GetWidgetDesc() )
		wtCell[col.CLS_ICO][i] = 	mainForm:CreateWidgetByDesc( wtTextView_CLS_ICO:GetWidgetDesc() )
		wtCell[col.CLASS][i] = 	mainForm:CreateWidgetByDesc( wtTextView_CLASS:GetWidgetDesc() )
		wtCell[col.LVL][i] = 	mainForm:CreateWidgetByDesc( wtTextView_LVL:GetWidgetDesc() )
		wtCell[col.TAB][i] = 	mainForm:CreateWidgetByDesc( wtTextView_TAB:GetWidgetDesc() )
		wtCell[col.RNK][i] = 	mainForm:CreateWidgetByDesc( wtTextView_RNK:GetWidgetDesc() )
		wtCell[col.AUTH][i] = 	mainForm:CreateWidgetByDesc( wtTextView_AUTH:GetWidgetDesc() )
		wtCell[col.MAUTH][i] = 	mainForm:CreateWidgetByDesc( wtTextView_MAUTH:GetWidgetDesc() )
		wtCell[col.MFAME][i] = 	mainForm:CreateWidgetByDesc( wtTextView_MFAME:GetWidgetDesc() )
		wtCell[col.LOYAL][i] = 	mainForm:CreateWidgetByDesc( wtTextView_LOYAL:GetWidgetDesc() )
		wtCell[col.JOIN][i] = 	mainForm:CreateWidgetByDesc( wtTextView_JOIN:GetWidgetDesc() ) 
		wtCell[col.WFAME][i] = 	mainForm:CreateWidgetByDesc( wtTextView_WFAME:GetWidgetDesc() )
		wtCell[col.ACT][i] = 	mainForm:CreateWidgetByDesc( wtTextView_ACT:GetWidgetDesc() )
		wtCell[col.ZONE][i] = 	mainForm:CreateWidgetByDesc( wtTextView_ZONE:GetWidgetDesc() )
	---- ширина и позиция ---
		SetupTableColumn( wtCell[col.NUM][i], TableColumnPosX[1], TableColumnWidth[1] )
		SetupTableColumn( wtCell[col.NAME][i], TableColumnPosX[2], TableColumnWidth[2] )
		SetupTableColumn( wtCell[col.CLS_ICO][i], TableColumnPosX[3], 20 )
		SetupTableColumn( wtCell[col.CLASS][i], TableColumnPosX[3] + 20, TableColumnWidth[3] - 20 )
		SetupTableColumn( wtCell[col.LVL][i], TableColumnPosX[4], TableColumnWidth[4] )
		SetupTableColumn( wtCell[col.TAB][i], TableColumnPosX[5], TableColumnWidth[5]  )
		SetupTableColumn( wtCell[col.RNK][i], TableColumnPosX[6], TableColumnWidth[6] )
		SetupTableColumn( wtCell[col.AUTH][i], TableColumnPosX[7], TableColumnWidth[7] )
		SetupTableColumn( wtCell[col.MAUTH][i], TableColumnPosX[8], TableColumnWidth[8] )
		SetupTableColumn( wtCell[col.MFAME][i], TableColumnPosX[9], TableColumnWidth[9] )
		SetupTableColumn( wtCell[col.LOYAL][i], TableColumnPosX[10], TableColumnWidth[10] )
		SetupTableColumn( wtCell[col.JOIN][i], TableColumnPosX[11], TableColumnWidth[11] )
		SetupTableColumn( wtCell[col.WFAME][i], TableColumnPosX[12], TableColumnWidth[12] )
		SetupTableColumn( wtCell[col.ACT][i], TableColumnPosX[13], TableColumnWidth[13] )
		SetupTableColumn( wtCell[col.ZONE][i], TableColumnPosX[14], TableColumnWidth[14] )
	---- прозрачность ---
		for c,_ in pairs(wtCell) do
			if c ~= col.CLS_ICO and c ~= col.TAB then
				wtCell[c][i]:SetBackgroundColor( { r = 1.0; g = 1.0; b = 1.0; a = 0.7 } )
			end
		end
	---- привязка к родительскому ---
		wtMainPanel:AddChild( wtRowBtn[i] )
		for c,_ in pairs(wtCell) do
			wtMainPanel:AddChild( wtCell[c][i] )
		end
	---------------------------------
	end
	
	for i = 0, 600 do
		FriendChange[i] = {}
		FriendChange[i].name = common.GetEmptyWString()
		FriendChange[i].mutual = 1
	end
	
	DnD:Init( 540, wtTitleText, wtMainPanel, true, true) 
	DnD:Init( 541, wtShowHideBtn, wtShowHideBtn, true )
		
	wtButtonTELL:DestroyWidget()
	wtButtonA:DestroyWidget()
	wtTextView_NUM:DestroyWidget()
	wtTextView_NAME:DestroyWidget()
	wtTextView_CLASS:DestroyWidget()
	wtTextView_CLS_ICO:DestroyWidget()
	wtTextView_LVL:DestroyWidget()
	wtTextView_TAB:DestroyWidget()
	wtTextView_RNK:DestroyWidget()
	wtTextView_AUTH:DestroyWidget()
	wtTextView_MAUTH:DestroyWidget()
	wtTextView_LOYAL:DestroyWidget()
	wtTextView_JOIN:DestroyWidget()
	wtTextView_WFAME:DestroyWidget()
	wtTextView_ACT:DestroyWidget()
	wtTextView_ZONE:DestroyWidget()
	
	ClearList()
	
	-- Backward compatibility with pre-1.1.04 versions:
	if not social.GetFriendInfo then
		mainForm:SetPriority( 1001 )
	end
	
	if avatar.IsExist() then
		OnEventAvatarCreated()
	end
	
	wtFooter:GetChildChecked( "FooterText", false ):SetVal( "RELEASE", RELEASE )
	onLoadGBE()
end
--------------------------------------------------------------------------------
Init()
--------------------------------------------------------------------------------
