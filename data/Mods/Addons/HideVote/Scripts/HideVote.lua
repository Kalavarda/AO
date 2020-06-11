--------------------------------------------------------------------------------
-- GLOBAL		���������� ���������� � �������
--------------------------------------------------------------------------------
Global( "AnswerQuestions", 1 ) -- ����� �� ������ (0-���/1-��/god-��� ���������) (��. ../Settings.txt)

--Global( "MountRideList", {} ) -- ������ � ������� �� ������ ������ (��. ../Settings.txt)

local QuestionId_Arr = {} -- ������ � id ��������

local wdt = {} -- ������ � ���������



--------------------------------------------------------------------------------
-- EVENT HANDLERS		���� � ��������� (�������� ������� ������������)
--------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- ������� �� ������ �� ������ (�� ������� ������� ���������� ��� id)
function OnAnswerQuestion( params )

	--params.id - �� ������� ���������� �� EVENT_QUESTION_ADDED


	--local result = {}
	--	result.choice = 1
	--questionLib.SendData( params.id, result )


	if QuestionId_Arr[params.id] == 1 then
		return
	end
	QuestionId_Arr[params.id] = 1
	
	
	-- �������� ������ ��������
	--local questions = questionLib.GetQuestions()
	
	--for key, value in pairs(questions) do
	if params.id then
	--if questions[0] then
		
		-- �������� ���������� � ������� �� ��� id
		local question = questionLib.GetInfo( params.id )
		--local question = questionLib.GetInfo( questions[0] )

		-- �������� ����� ��������� � ���������� ������� 
		local questionText = question.questionData.questionCustomData.text
		
		-- ����������� �����
		--questionText = common.ExtractWStringFromValuedText( questionText )
		--questionText = common.EscapeWString ( questionText )
		local qsttxt = userMods.FromWString(questionText)
--		LogInfo( "questionText=", questionText )

		-- ���� ���������� �� �����
		local matchText = string.find(qsttxt, '������� ������')
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
					
					-- �������� ������ ������ �����
					local activeBuffs = object.GetBuffs( valueGroup.id )
					if activeBuffs then
						for i, id in pairs(activeBuffs) do
							-- �������� ���������� � ������
							local buffInfo = object.GetBuffInfo( id )
							if buffInfo then
								-- �������� ��� �����
								local nameBuff = userMods.FromWString(buffInfo.name)
								if nameBuff == "����������� ���������" then
									-- ������ ����� �������� ���� ����� 3 ������� � ������������
									local a = buffInfo.durationMs-4*1000
									-- ����� �� ��������� �������� ���� � ������������
									local b = buffInfo.remainingMs
									if b > a then
										local nm = userMods.FromWString(valueGroup.name)
										local textChat = "����� "..nm.." ����� ����������� �� ����������."
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
						
						-- �������� ������ ������ �����
						local activeBuffs = object.GetBuffs( valueGroup.id )
						if activeBuffs then
							for i, id in pairs(activeBuffs) do
								-- �������� ���������� � ������
								local buffInfo = object.GetBuffInfo( id )
								if buffInfo then
									-- �������� ��� �����
									local nameBuff = userMods.FromWString(buffInfo.name)
									if nameBuff == "����������� ���������" then
										-- ������ ����� �������� ���� ����� 3 ������� � ������������
										local a = buffInfo.durationMs-4*1000
										-- ����� �� ��������� �������� ���� � ������������
										local b = buffInfo.remainingMs
										if b > a then
											local nm = userMods.FromWString(valueGroup.name)
											local textChat = "����� "..nm.." ����� ����������� �� ����������."
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
-- ������� ��������� ������� ������� ����� ������ ���� �� �������� ������
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
-- CHECKED AVATAR AND DATE		�������� �������� �������, ���� � ������ �� ������ ������ �������� ��������
--------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- ������� �������� ����
function OnEventCheckDate( params )

	-- �������� ������� ���� � ������������ �� ��� �������� unix (1-�� ������ 1970-�� ����)
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
-- ������� ��������� ������� ����� ������� �������� ��������� (����� � ����)
function OnEventAvatarCreatedRun()
	--OnEventRET()

end


---------------------------------------------------------------------------------------------------
-- ������� ������������� � ������� �������� ����� � ���� (����� ��� ������)
function OnEventAvatarCreated()

	--OnEventCheckDate()
	
	-- ��������� ������� ���������� � ������ ��� ���� ����� �� ������� (��������� ������)
	common.RegisterEventHandler(OnAnswerQuestion, "EVENT_QUESTION_ADDED")
	--common.RegisterEventHandler(OnAnswerQuestion, "EVENT_SECOND_TIMER")

end


--------------------------------------------------------------------------------
-- INITIALIZATION		������������� �������
--------------------------------------------------------------------------------
function Init()
	-- �������:
	-- ������� ������
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
	
	-- ������� �� ���� ����� ������ ���� �� ������� (�� ������)
	common.RegisterReactionHandler( OnMouseLeftClick, "mouse_left_click" )
	
	
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