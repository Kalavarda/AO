--------------------------------------------------------------------------------
--- Globals
--------------------------------------------------------------------------------
Global( "CID", 0 )
Global( "BID", 0 )

local sysNameExceptions = {} --Исключающие квесты
sysNameExceptions["Snow_12"] = true --квест огнеяр
sysNameExceptions["GuildQuest_4_1"] = true --Обед рвения

local sysNameExceptionsAddTkaRika = {} --Дополнительные квесты
sysNameExceptionsAddTkaRika["QuestEvent03"] = true --Тка рика, дорого испытаний
sysNameExceptionsAddTkaRika["QuestEventDaily"] = true --Тка рика, вызов вероники

--квесты астральной академии
local astac = {}
astac["AstralBossLeague"] = true
astac["TreasureHuntingLeague"] = true
astac["Астральная охота"] = true

--квесты карнавал фантазий
sysNameExceptionsAddTkaRika["Quest_new2_1"] = true
sysNameExceptionsAddTkaRika["Quest_new2_2"] = true-- не проверен
sysNameExceptionsAddTkaRika["Quest_new2_3"] = true-- не проверен
sysNameExceptionsAddTkaRika["Quest_new3_1"] = true
sysNameExceptionsAddTkaRika["Quest_new3_2"] = true -- не проверен
sysNameExceptionsAddTkaRika["Quest_new3_3"] = true -- не проверен
sysNameExceptionsAddTkaRika["Quest_new1_1"] = true -- не проверен
sysNameExceptionsAddTkaRika["Quest_new1_2"] = true
sysNameExceptionsAddTkaRika["Quest_new1_3"] = true -- не проверен


--квесты 3х3 6х6
sysNameExceptionsAddTkaRika["Резня"] = true
sysNameExceptionsAddTkaRika["Побоище"] = true

--Личный аллод
sysNameExceptionsAddTkaRika["Загадочная посылка"] = true

--Новоград
sysNameExceptionsAddTkaRika["Будни героев"] = true
sysNameExceptionsAddTkaRika["Ни дня без подвига!"] = true

--квесты руины ал-риата

sysNameExceptionsAddTkaRika["RedForest"] = true
sysNameExceptionsAddTkaRika["RedForest_1_1"] = true
sysNameExceptionsAddTkaRika["RedForest_1_2"] = true
sysNameExceptionsAddTkaRika["RedForest_1_3"] = true
sysNameExceptionsAddTkaRika["RedForest_2_1"] = true
sysNameExceptionsAddTkaRika["RedForest_2_2"] = true
sysNameExceptionsAddTkaRika["RedForest_2_3"] = true


sysNameExceptionsAddTkaRika["GreenForest"] = true
sysNameExceptionsAddTkaRika["GreenForest_1_1"] = true
sysNameExceptionsAddTkaRika["GreenForest_1_2"] = true
sysNameExceptionsAddTkaRika["GreenForest_1_3"] = true
sysNameExceptionsAddTkaRika["GreenForest_2_1"] = true
sysNameExceptionsAddTkaRika["GreenForest_2_2"] = true
sysNameExceptionsAddTkaRika["GreenForest_2_3"] = true

sysNameExceptionsAddTkaRika["Umoir"] = true
sysNameExceptionsAddTkaRika["Umoir_1_1"] = true
sysNameExceptionsAddTkaRika["Umoir_1_2"] = true
sysNameExceptionsAddTkaRika["Umoir_1_3"] = true
sysNameExceptionsAddTkaRika["Umoir_2_1"] = true
sysNameExceptionsAddTkaRika["Umoir_2_2"] = true
sysNameExceptionsAddTkaRika["Umoir_2_3"] = true

--квесты цс
sysNameExceptionsAddTkaRika["Snow_1"] = true
sysNameExceptionsAddTkaRika["Snow_2"] = true
sysNameExceptionsAddTkaRika["Snow_3"] = true
sysNameExceptionsAddTkaRika["Snow_4"] = true
sysNameExceptionsAddTkaRika["Snow_5"] = true
sysNameExceptionsAddTkaRika["Snow_6"] = true
sysNameExceptionsAddTkaRika["Snow_7"] = true
sysNameExceptionsAddTkaRika["Snow_8"] = true
sysNameExceptionsAddTkaRika["Snow_9"] = true
sysNameExceptionsAddTkaRika["Snow_10"] = true
sysNameExceptionsAddTkaRika["Snow_11"] = true-- не проверен
sysNameExceptionsAddTkaRika["Snow_12"] = true

sysNameExceptionsAddTkaRika["Water_1"] = true
sysNameExceptionsAddTkaRika["Water_2"] = true-- не проверен
sysNameExceptionsAddTkaRika["Water_3"] = true
sysNameExceptionsAddTkaRika["Water_4"] = true

sysNameExceptionsAddTkaRika["Air_1"] = true
sysNameExceptionsAddTkaRika["Air_2"] = true
sysNameExceptionsAddTkaRika["Air_3"] = true
sysNameExceptionsAddTkaRika["Air_4"] = true

sysNameExceptionsAddTkaRika["Ice_1"] = true
sysNameExceptionsAddTkaRika["Ice_2"] = true
sysNameExceptionsAddTkaRika["Ice_3"] = true
sysNameExceptionsAddTkaRika["Ice_4"] = true

sysNameExceptionsAddTkaRika["Stone_1"] = true
sysNameExceptionsAddTkaRika["Stone_2"] = true
sysNameExceptionsAddTkaRika["Stone_3"] = true
sysNameExceptionsAddTkaRika["Stone_4"] = true



sysNameExceptionsAddTkaRika["Center_1"] = true
sysNameExceptionsAddTkaRika["Center_2"] = true
sysNameExceptionsAddTkaRika["Center_3"] = true
sysNameExceptionsAddTkaRika["Center_4"] = true

--Ёрема Костров ЦС
sysNameExceptionsAddTkaRika["PvP_L1"] = true
sysNameExceptionsAddTkaRika["PvP_L2"] = true
sysNameExceptionsAddTkaRika["PvP_L3"] = true


local sysNameExceptionsAddGuild = {} -- квест гильдии
sysNameExceptionsAddGuild["GuildQuest_4_1"] = true -- Обед рвения
sysNameExceptionsAddGuild["GuildQuest_1_1"] = true 
sysNameExceptionsAddGuild["GuildQuest_3_1"] = true 
sysNameExceptionsAddGuild["GuildQuest_5_1"] = true
sysNameExceptionsAddGuild["GuildQuest_2_17"] = true

--------------------------------------------------------------------------------
--- Locals
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--- Functions
--------------------------------------------------------------------------------

function GetQuestName(id)
	if id then
		local QuestInfo = avatar.GetQuestInfo( id )
		local sysName = QuestInfo["sysName"]
		if sysName == "" then
			local ws = common.ExtractWStringFromValuedText( QuestInfo.name )
			return userMods.FromWString( ws )
		else	
			return sysName
		end
	else
		return ""
	end
end

function On_EVENT_INTERACTION_STARTED(params) 
	--Событие посылается в ответ на запрос наличия доступных заданий у собеседника avatar.RequestInteractions(). Также приходит автоматически при начале разговора.

	if params and avatar.IsTalking() then
	
		if avatar.HasInteractorCue() then
			local cue = avatar.GetInteractorCue()
			if cue then
				local nextCues = avatar.GetInteractorNextCues()			
				if nextCues then
					for id, c in pairs(nextCues) do
						local actionName = userMods.FromWString(c.name)
						--Chat(actionName)
						if string.find(actionName, "Забрать сотворённые ценности") then
							avatar.SelectInteractorCue(id)
							break
						end
						
						-- Этих пунктов вообще нет
						-- if string.find(actionName, "Материализовать астральный коралл") then
							-- avatar.SelectInteractorCue(id)
							-- break
						-- end
						-- if string.find(actionName, "Чеканить монеты в количестве") then
							-- avatar.SelectInteractorCue(id)
							-- break
						-- end						
					end
				end
				
				if nextCues[1] then
					-- Chat(userMods.FromWString(nextCues[1].text))
					-- local answer0 = nextCues[0].text
					-- Chat(answer0)
				else
					--Chat(userMods.FromWString(cue.text))
					if cue.isSpecial then
						-- Chat("isSpecial == true")
					end
					if cue.data then
						local q = cue.data[0]
						if q then
							-- Chat("cue.data[0]")
						end
					end
					avatar.SelectInteractorCue(0)
				end
			end
		end
		
		local retQuestList = avatar.GetReturnableQuests()
		if retQuestList then
			for i, id in pairs(retQuestList) do
				local sysName = GetQuestName(id)
				if  sysNameExceptions[sysName] == true then 
					--кроме квеста огнеяр

				else
				
					local ai=avatar.GetQuestReward( id ).alternativeItems
					if #ai==0 then
						avatar.ReturnQuest( id,nil )
					end

				end
			end
		end
		
		local availableQuestList = avatar.GetAvailableQuests()
		if availableQuestList then
			for i, id in pairs(availableQuestList) do
				local qInf = avatar.GetQuestInfo( id )
				local sysName = GetQuestName(id)
				
				--LogInfo(sysName)
				
				if qInf.canBeSkipped then
					avatar.AcceptQuest( id )
					--return---ssssssss
				elseif sysNameExceptionsAddTkaRika[sysName] == true then
					avatar.AcceptQuest( id )
					--return---ssssssss
				elseif sysNameExceptionsAddGuild[sysName] == true then
					avatar.AcceptQuest( id )
					--return---ssssssss
				elseif astac[sysName] == true then
					avatar.AcceptQuest( id )
				end
			end
			
		end
	end
end

function On_EVENT_QUEST_RECEIVED(params)
	--Событие посылается каждый раз, когда игрок получил и принял задание.
	local qid=params.questId
	if qid then
		local sysName = GetQuestName(qid)
		if  sysNameExceptions[sysName] == true then
				--
				--кроме квеста огнеяр
		elseif sysNameExceptionsAddTkaRika[sysName] == true 
			or sysNameExceptionsAddGuild[sysName] == true then			
			
			if sysName ~= "GuildQuest_4_1" then
				local progress = avatar.GetQuestProgress( qid )
				if progress == QUEST_COMPLETED then
					avatar.SkipQuest( qid )
				end
			end

		else		
			if avatar.GetSkipQuestCost( qid) <= avatar.GetDestinyPoints().total then
				avatar.SkipQuest( qid )
			end
			if avatar.IsTalking() then
				On_EVENT_INTERACTION_STARTED()
			end
		end
	end
end



function AvatarInit()
	if not avatar.IsExist() then
		return false
	end
	if not avatar.GetId() then    
		return false
	end

	common.UnRegisterEventHandler( AvatarInit, "EVENT_SECOND_TIMER" )

	common.RegisterEventHandler(On_EVENT_QUEST_RECEIVED, "EVENT_QUEST_RECEIVED")
	common.RegisterEventHandler(On_EVENT_INTERACTION_STARTED, "EVENT_INTERACTION_STARTED")

end


--------------------------------------------------------------------------------
--- INITIALIZATION
--------------------------------------------------------------------------------
function Init()
	common.RegisterEventHandler( AvatarInit, "EVENT_SECOND_TIMER" )
end
--------------------------------------------------------------------------------
Init()
--------------------------------------------------------------------------------
