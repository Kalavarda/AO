-- -----------------------------------------------------
-- ---------- ! Настройка аддона здесь ! ---------------
local Merc = {

-- Чтобы изменить список вызываемых наёмников, надо закомментировать
-- строку с именем ненужного наёмника (поставить два минуса в начале
-- строки) или раскомментировать строку с нужным (убрать эти минусы).
-- Например, сейчас закомментирована строка с Бурей, поэтому она не
-- вызывается.

	"Громила Лоб Буйных",
	"Лекарь Матрёна Коновалова",
--	"Стрелок Кузьма Орлов",
--	"Рубака Буря Степных",
    "Ведунья Лиза ди Вевр"
--	"Колдун Михаил Грамотин"
   }

-- Автозапуск битвы при разговоре с НПС (аддон выбирает "Начнём!" в диалоге).
-- Чтобы выключить этот автозапуск, замените true на false.

local AutoStartBattle = true

-- --------- ! конец области с настройкам ! ------------
-- -----------------------------------------------------


local MapName = "Безвременье"
local MercOffc = { "Александра Сольдина", "Властемир Наймитов" }
local HireMercLine = "Нанять наёмника"
local ReviveMercLine = "Воскресить наёмника"

local BattleNPC = {
	"Ерофей Хранилов",
	"Нимра Озёрнова",
	"Тереза ди Ардер",
	"Дух Света",
	"Степан Триглавин",
	"Матёрый мечник",
	"Искусная волшебница",
	"Угрюмый гридень"
}
local StartBattleLine = "Начнём!"

-- Функция: Событие начала разговора с NPC
function OnTalkStarted()

   local currentMap = cartographer.GetCurrentMapInfo()
   if userMods.FromWString(currentMap.name) == MapName then

	local info = avatar.GetInteractorInfo()

	if info.hasInteraction then

		if userMods.FromWString(object.GetName(avatar.GetInterlocutor())) == MercOffc[1] or userMods.FromWString(object.GetName(avatar.GetInterlocutor())) == MercOffc[2] then
			if TalkOptionPresent(ReviveMercLine) then
				SelectTalkOption(ReviveMercLine)
				for i=1, GetTableSize(Merc) do
					SelectTalkOption(Merc[i])
				end
			else
				SelectTalkOption(HireMercLine)
				for i=1, GetTableSize(Merc) do
					SelectTalkOption(Merc[i])
				end
			end
		end

		for i=1, GetTableSize(BattleNPC) do
			if AutoStartBattle and userMods.FromWString(object.GetName(avatar.GetInterlocutor())) == BattleNPC[i] then
				SelectTalkOption(StartBattleLine)
			end
		end

	end
   end
end


-- Функция: Выбрать эту опцию в разговоре

function SelectTalkOption(talkOption)

	local SpisReplik = avatar.GetInteractorNextCues()
	for i=0, GetTableSize(SpisReplik) do
		if SpisReplik[i] then
			if userMods.FromWString(SpisReplik[i].name) == talkOption then
				avatar.SelectInteractorCue(i)
			end
		end
	end
end

-- Функция: Если ли эта опция в разговоре

function TalkOptionPresent(talkOption)

	local SpisReplik = avatar.GetInteractorNextCues()
	for i=0, GetTableSize(SpisReplik) do
		if SpisReplik[i] then
			if userMods.FromWString(SpisReplik[i].name) == talkOption then
				return true
			end
		end
	end
end



-- ------------------------

local GetContextActionShortInfo = avatar.GetContextActionShortInfo or avatar.GetContextActionInfo
local IsNavigateToPoint = avatar.IsNavigateToPoint or function() return false end
local ExtractWStringFromValuedText = function(str) return common.IsWString(str) and str or common.ExtractWStringFromValuedText(str) end

local activeNPC
local knownNPCs = {}
local retries
local maxRetries = 20

function OnActionFailed( params )
	if activeNPC and params.sysId == "ENUM_ActionFailCause_TooFar" and not params.isInNotPredicate then
		if not retries then retries = maxRetries end
		if retries > 0 then
			retries = retries - 1
			-- Try again
			knownNPCs = {}
			OnContextActionsChanged()
		else
			-- It's enough
			retries = nil
		end
	end
end

function OnContextActionsChanged()
	local currentMap = cartographer.GetCurrentMapInfo()
	local current = {}
	local flag = false
	local actions = avatar.GetContextActions()
	for _,action in pairs(actions) do
		local info = GetContextActionShortInfo(action)
		if info and info.objectId and info.enabled and info.sysType == "ENUM_CONTEXT_ACTION_TYPE_NPC_TALK" then
			local name = userMods.FromWString(object.GetName(info.objectId))
			if not knownNPCs[name] then
				flag = true
			end
			current[name] = info.objectId
		end
	end
	-- Not starting interaction if:
	--  1. already talking with another NPC
	--  2. automoving to NPC
	if avatar.IsTalking() or IsNavigateToPoint() then
		flag = false
	end

	if flag and userMods.FromWString(currentMap.name) == MapName then
		for j = 1, GetTableSize(MercOffc) do
			local name = MercOffc[j]
			if current[name] and not knownNPCs[name] then
				avatar.StartInteract(current[name])
				break
			end
		end
	end
	knownNPCs = current
end


--------------------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------------------
function Init()
	-- События:
	common.RegisterEventHandler(OnTalkStarted, "EVENT_INTERACTION_STARTED")
	common.RegisterEventHandler(OnActionFailed, "EVENT_ACTION_FAILED_OTHER")
	common.RegisterEventHandler(OnContextActionsChanged, "EVENT_CONTEXT_ACTIONS_CHANGED")
	Init = nil
end
--------------------------------------------------------------------------------
Init()
--------------------------------------------------------------------------------