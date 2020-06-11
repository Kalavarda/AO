--------------------------------------------------------------------------------
-- GLOBAL		Объяввляем переменные и массивы
--------------------------------------------------------------------------------
Global( "AnswerQuestions", 1 ) -- ответ на вопрос (0-нет/1-да/god-как получится) (см. ../Settings.txt)

--Global( "MountRideList", {} ) -- массив с данными на призыв маунта (см. ../Settings.txt)

local QuestionId_Arr = {} -- массив с id вопросов

local wdt = {} -- массив с виджетами



--------------------------------------------------------------------------------
-- EVENT HANDLERS		Тело с функциями (основное рабочее пространство)
--------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Функция по ответу на вопрос (по запуску вопроса передается его id)
function OnAnswerQuestion( params )

	--params.id - ИД вопроса присланный по EVENT_QUESTION_ADDED


	--local result = {}
	--	result.choice = 1
	--questionLib.SendData( params.id, result )


	if QuestionId_Arr[params.id] == 1 then
		return
	end
	QuestionId_Arr[params.id] = 1
	
	
	-- Получаем список вопросов
	--local questions = questionLib.GetQuestions()
	
	--for key, value in pairs(questions) do
	if params.id then
	--if questions[0] then
		
		-- Получаем информацию о вопросе по его id
		local question = questionLib.GetInfo( params.id )
		--local question = questionLib.GetInfo( questions[0] )

		-- Получаем текст сообщения в присланном вопросе 
		local questionText = question.questionData.questionCustomData.text
		
		-- Преобразуем текст
		--questionText = common.ExtractWStringFromValuedText( questionText )
		--questionText = common.EscapeWString ( questionText )
		local qsttxt = userMods.FromWString(questionText)
--		LogInfo( "questionText=", questionText )

		-- Ищем совпадение по фразе
		local matchText = string.find(qsttxt, 'Выгнать игрока')
		if matchText then
			
			
			local result = {}
			--result.choice = 1
			
			if AnswerQuestions == 1 then
				result.choice = 1
			elseif AnswerQuestions == 0 then
				result.choice = 0
			else
				--local randNum = math.random(0,10) 
				local randNum = common.GetRand( 0, 10 )
				if randNum <= 5 then
					result.choice = 0
				elseif randNum > 5 then
					result.choice = 1
				end
			end
			
			questionLib.SendData( question.id, result )
			
			
			------------------------------------------------
			common.StateUnloadManagedAddon( "ContextUniMessageBox" )
			--common.StateLoadManagedAddon( "ContextUniMessageBox" )
			StartSecondTimerLoadManagedAddon( { NameAddon="ContextUniMessageBox"; TimeLimit=3 } )
			------------------------------------------------
		end


		local RaidMembersInfoList = {}
		
		local isExistGroup = group.IsExist()
		if not raid.IsExist() and isExistGroup then
		--if group.IsExist() then
			RaidMembersInfoList = {}
			local GroupMembers = group.GetMembers()
			for key, valueGroup in pairs(GroupMembers) do
			--local nm = userMods.FromWString(valueGroup.name)
			--LogInfo( "id: ", nm,"kjkj", valueGroup.id )
				if valueGroup.id then
					RaidMembersInfoList[valueGroup.id] = userMods.FromWString(valueGroup.name)
					
					-- Получаем список баффов Юзера
					local activeBuffs = object.GetBuffs( valueGroup.id )
					if activeBuffs then
						for i, id in pairs(activeBuffs) do
							-- Получаем информацию о баффах
							local buffInfo = object.GetBuffInfo( id )
							if buffInfo then
								-- Получаем имя баффа
								local nameBuff = userMods.FromWString(buffInfo.name)
								if nameBuff == "Голосование завершено" then
									-- Полное время действия бафа минус 3 секунды в милисукундах
									local a = buffInfo.durationMs-4*1000
									-- Время до окончания действия бафа в милисукундах
									local b = buffInfo.remainingMs
									if b > a then
										local nm = userMods.FromWString(valueGroup.name)
										local textChat = "Игрок "..nm.." начал голосование за исключение."
										Log(textChat, nil, 14)
									end
								end
							end
						end
					end
					
				end
			end
		elseif raid.IsExist() then
			RaidMembersInfoList = {}
			local RaidMembers = raid.GetMembers()
			for key, valueRaid in pairs(RaidMembers) do
				for key, valueGroup in pairs(valueRaid) do
				--local nm = userMods.FromWString(valueGroup.name)
				--LogInfo( "id: ", nm,"kjkj", valueGroup.id )
					if valueGroup.id then
						RaidMembersInfoList[valueGroup.id] = userMods.FromWString(valueGroup.name)
						
						-- Получаем список баффов Юзера
						local activeBuffs = object.GetBuffs( valueGroup.id )
						if activeBuffs then
							for i, id in pairs(activeBuffs) do
								-- Получаем информацию о баффах
								local buffInfo = object.GetBuffInfo( id )
								if buffInfo then
									-- Получаем имя баффа
									local nameBuff = userMods.FromWString(buffInfo.name)
									if nameBuff == "Голосование завершено" then
										-- Полное время действия бафа минус 3 секунды в милисукундах
										local a = buffInfo.durationMs-4*1000
										-- Время до окончания действия бафа в милисукундах
										local b = buffInfo.remainingMs
										if b > a then
											local nm = userMods.FromWString(valueGroup.name)
											local textChat = "Игрок "..nm.." начал голосование за исключение."
											Log(textChat, nil, 14)
										end
									end
								end
							end
						end
						
					end
				end
			end
		end
		
		
	end
	--end

end


---------------------------------------------------------------------------------------------------
-- Функция обработки событий нажатия левой кнопки мыши по виджетам аддона
function OnMouseLeftClick( params )
	local parent = params.widget:GetParent()
	local parentName = parent:GetName()
	local widgetVar = params.widget:GetVariant() == 1
	
	--[[if params.sender == 'ButtonMain' or params.sender == 'CloseBtnMainPanelSettingsAddon' then
		if DnD:IsDragging() then return end
		CloseSettings()
		return

	elseif params.sender == 'ButtonSave' then
		SaveRememberDataTest()
		CloseSettings()
		--OnEventInstanceDecline()
		return
	end]]
	
	if params.sender == 'ShowHideBtn' then
	end

end


--------------------------------------------------------------------------------
-- CHECKED AVATAR AND DATE		Проверки создания аватара, даты и прочее до начала работы основных скриптов
--------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Функция проверки даты
function OnEventCheckDate( params )

	-- Получаем текущую дату в милисекундах со дня рождения unix (1-го января 1970-го года)
	local TimePresent = common.GetMsFromDateTime( common.GetLocalDateTime() )
	
	local timeTable = {}
		timeTable.y = 2018
		timeTable.m = 01
		timeTable.d = 10
	local TimeStop = common.GetMsFromDateTime( timeTable )

	if (TimeStop >= TimePresent) then
		--OnEventAvatarCreatedRun()
	end

end


---------------------------------------------------------------------------------------------------
-- Функция запускает функции после момента создания персонажа (входа в игру)
function OnEventAvatarCreatedRun()
	--OnEventRET()

end


---------------------------------------------------------------------------------------------------
-- Функция запускающаяся с момента создания юзера в игре (после его захода)
function OnEventAvatarCreated()

	--OnEventCheckDate()
	
	-- Запускаем функцию спешивания с маунта при Афке юзера по событию (активация маунта)
	common.RegisterEventHandler(OnAnswerQuestion, "EVENT_QUESTION_ADDED")
	--common.RegisterEventHandler(OnAnswerQuestion, "EVENT_SECOND_TIMER")

end


--------------------------------------------------------------------------------
-- INITIALIZATION		Инициализация функций
--------------------------------------------------------------------------------
function Init()
	-- События:
	-- Цепляем виджет
	wdt.ShowHideBtn = mainForm:GetChildChecked( "ShowHideBtn", true )
	wdt.ShowHideBtn:Show( false )
		local p = wdt.ShowHideBtn:GetPlacementPlain()
			p.alignX = WIDGET_ALIGN_LOW
			p.alignY = WIDGET_ALIGN_LOW
			p.posX = 500
			--p.posY = 240
			p.posY = 3
		wdt.ShowHideBtn:SetPlacementPlain(p)
	
	--DnD:Init( 545, mainForm:GetChildChecked( "ShowHideBtn", true ), mainForm:GetChildChecked( "AutoMountDismount", true ), true )
	
	-- Реакция на клик левой кнопки мыши по виджиту (см виджет)
	common.RegisterReactionHandler( OnMouseLeftClick, "mouse_left_click" )
	
	
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