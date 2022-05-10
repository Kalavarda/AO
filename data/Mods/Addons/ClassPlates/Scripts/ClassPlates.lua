Global("MainPanel", mainForm:GetChildChecked("MainPanel", false))
Global("Text", MainPanel:GetChildChecked("Barrier", false))
Global("Plate", nil)
Global("PetBar", nil)
--changes for 7.0 here
Global("ResourceBar", nil)
Global("ResourceDefault", nil)
Global("ResourceModified", nil)
Global("PlatesFrame", stateMainForm:GetChildUnchecked( "Plates", false ))
Global("PlatesAvatarFrame", PlatesFrame:GetChildUnchecked( "Avatar", false ))
Global("ResourceDNDPanel", mainForm:GetChildChecked("ResourceDNDPanel", false))
Global("PetBarName", nil)
Global("PlateName", nil)
--end of 7.0 changes
--Global("CharData", nil)
Global("DNDPanel", mainForm:GetChildChecked("DNDPanel", false))
Global("PetDND", mainForm:GetChildChecked("PetDND", false))
Global("ClassP", userMods.GetGlobalConfigSection("ClassP"))
-------------------------------------------------------------------------------
-- FUNCTION
-------------------------------------------------------------------------------

function BarrierChanged()
	local barriers = avatar.GetBarriersInfo()
	Text:ClearValues()
	local VT = common.CreateValuedText()
	local msg = "<html>"
	for i, v in pairs(barriers) do
		if v and v.damage > 0 then
			local color = "<tip_golden>"
			local colorend = "</tip_golden>"
			if v.remainingTimeMs/1000 < 3 then
				color = "<tip_red>"
				colorend = "</tip_red>"
			end
			local sec = math.ceil(v.remainingTimeMs/1000)-1
			msg = msg..color.."["..(i+1).."] "..v.damage.." - "..sec.." s "..colorend
		end
	end
	msg = msg.."</html>"
	VT:SetFormat(userMods.ToWString(msg))
	Text:SetVal("value", VT)
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end

function CEChanged()
	if ClassP["Color"] then
		local advPerc = avatar.GetWarriorCombatAdvantage() / 100
		if advPerc > .75 then
			Text:SetClassVal("class", "tip_green")
		elseif advPerc > .45 then
			Text:SetClassVal("class", "LogColorYellow")
		elseif advPerc > .25 then
			Text:SetClassVal("class", "LogColorOrange")
		else
			Text:SetClassVal("class", "tip_red")
		end
	else
		Text:SetClassVal("class", "tip_red")
	end
	Text:SetVal("value", userMods.ToWString("Advantage: "..avatar.GetWarriorCombatAdvantage())) --Боевое преимущество
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end

function onObjectBuffsChanged(params)	
	local avatarId = avatar.GetId()
	if avatarId and params.objectId then
		if avatarId == params.objectId then
			EntropyChanged(params.objectId)
		end
	end
end

function onObjectBuffsElementChanged(params)
	local avatarId = avatar.GetId()
	if avatarId and params.objects then
		local buffChanged = params.objects[avatarId]
		if buffChanged then
			EntropyChanged(avatarId)
		end
	end
end

function EntropyChanged(avatarId)
	if avatarId then
	
		local VT = common.CreateValuedText()
		VT:SetFormat(userMods.ToWString("<html><tip_red><r name='name1'/></tip_red> <tip_blue><r name='name2'/></tip_blue> <tip_golden><r name='name3'/></tip_golden></html>"))
		local value = 0
		local CharData = avatar.GetVariables()

		for index, id in pairs(CharData) do
			local power = avatar.GetVariableInfo(id)
			
			if power.sysName == "MageFireInstability" then
				VT:SetVal("name1", userMods.ToWString("Fire: "..power.value)) --Огонь
				value = 1
			elseif power.sysName == "MageIceInstability" then
				VT:SetVal("name2", userMods.ToWString("Ice: "..power.value)) --Лед
				value = 1
			elseif power.sysName == "MageEnergyInstability" then
				VT:SetVal("name3", userMods.ToWString("Lightning: "..power.value)) --Молния
				value = 1
			end
		end		

		if value == 1 then
			Text:SetVal("value", VT)
		elseif value == 0 then
			Text:SetVal("value", userMods.ToWString(""))
		end
		
		if Plate then
			Plate:Show(ClassP["Panel"])
		end
	end
end

--[[function BeltChanged() -- obsolete
	local VT = common.CreateValuedText()
	VT:SetFormat(userMods.ToWString("<html><tip_red><r name='name0'/></tip_red> <tip_purple><r name='name1'/></tip_purple> <tip_golden><r name='name2'/></tip_golden> <tip_green><r name='name3'/></tip_green></html>"))
	local value = 0
	local arrows = avatar.GetStalkerCartridge()
	for i, v in pairs(arrows) do
		if string.find(spellLib.GetProperties(v.enchantSpellId).sysSubElement, "FIRE") then
			VT:SetVal("name0", userMods.ToWString("Fire: "..v.arrowCount))
		elseif string.find(spellLib.GetProperties(v.enchantSpellId).sysSubElement, "ASTRAL") then
			VT:SetVal("name1", userMods.ToWString("Tranq: "..v.arrowCount))
		elseif string.find(spellLib.GetProperties(v.enchantSpellId).sysSubElement, "LIGHT") then
			VT:SetVal("name2", userMods.ToWString("Tesla: "..v.arrowCount))
		elseif string.find(spellLib.GetProperties(v.enchantSpellId).sysSubElement, "PHYS") then
			VT:SetVal("name3", userMods.ToWString("Phys: "..v.arrowCount))
		end
	end
	Text:SetVal("value", VT)
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end ]]

function GearPieceChanged()
	local CharData = avatar.GetVariables()
	local materiel = { value = nil, minValue = nil, maxValue = nil }
		
	for index, id in pairs(CharData) do
		local power = avatar.GetVariableInfo(id)
		if power.sysName == "MaterielEnergyType" then
			--LogInfo("Materiel: "..tostring(power.value))
			--LogInfo("Max Materiel: "..tostring(power.maxValue))
			--LogInfo("Min Materiel: "..tostring(power.minValue))
			materiel.value = power.value
			materiel.minValue = power.minValue
			materiel.maxValue = power.maxValue
		end
	end
	
	if ClassP["Color"] then
		local materielPerc = materiel.value / materiel.maxValue
		if materielPerc > .75 then
			Text:SetClassVal("class", "tip_green")
		elseif materielPerc > .45 then
			Text:SetClassVal("class", "LogColorYellow")
		elseif materielPerc > .25 then
			Text:SetClassVal("class", "LogColorOrange")
		else
			Text:SetClassVal("class", "tip_red")
		end
	else
		Text:SetClassVal("class", "tip_red")
	end
	Text:SetVal("value", userMods.ToWString("Gear Piece: "..materiel.value)) --Снаряжение
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end

function PetSpawn()
	if PetBar then
		PetBar:Show(ClassP["Pet"])
	end
end

function BloodChanged()
	local CharData = avatar.GetVariables()
	local blood = { value = nil, minValue = nil, maxValue = nil }
	
	for index, id in pairs(CharData) do
		local power = avatar.GetVariableInfo(id)
		if power.sysName == "BloodPool" then
			--LogInfo("Blood: "..tostring(power.value))
			--LogInfo("Max Blood: "..tostring(power.maxValue))
			--LogInfo("Min Blood: "..tostring(power.minValue))
			blood.value = power.value
			blood.minValue = power.minValue
			blood.maxValue = power.maxValue
		end
	end
	
	if ClassP["Color"] then
		local bloodPerc = blood.value / blood.maxValue
		if bloodPerc > .75 then
			Text:SetClassVal("class", "tip_green")
		elseif bloodPerc > .45 then
			Text:SetClassVal("class", "LogColorYellow")
		elseif bloodPerc > .25 then
			Text:SetClassVal("class", "LogColorOrange")
		else
			Text:SetClassVal("class", "tip_red")
		end
	else
		Text:SetClassVal("class", "tip_red")
	end
	Text:SetVal("value", userMods.ToWString("Blood: "..blood.value)) --Кровь
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end

--[[function SPChanged() -- obsolete
	local com = avatar.GetDruidPetCommandPoints()
	if ClassP["Color"] then
		local comPerc = com.value / com.maxValue
		if comPerc > .75 then
			Text:SetClassVal("class", "tip_green")
		elseif comPerc > .45 then
			Text:SetClassVal("class", "LogColorYellow")
		elseif comPerc > .25 then
			Text:SetClassVal("class", "LogColorOrange")
		else
			Text:SetClassVal("class", "tip_red")
		end
	else
		Text:SetClassVal("class", "LogColorOrange")
	end
	Text:SetVal("value", userMods.ToWString("Command: "..com.value))
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end ]]

function ManaChanged()
	local id = avatar.GetId()
	local mana = unit.GetMana(id).mana
	local manaPerc = unit.GetMana(id).percents
	--local manaMax = unit.GetMana(id).maxMana

	if ClassP["Color"] then
		if manaPerc > 75 then
			Text:SetClassVal("class", "tip_green")
		elseif manaPerc > 45 then
			Text:SetClassVal("class", "LogColorYellow")
		elseif manaPerc > 25 then
			Text:SetClassVal("class", "LogColorOrange")
		else
			Text:SetClassVal("class", "tip_red")
		end
	else
		Text:SetClassVal("class", "LogColorOrange")
	end
	Text:SetVal("value", userMods.ToWString("Mana: "..mana.."  |  "..manaPerc.."%")) --Мана
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end

function StressChanged()
	local CharData = avatar.GetVariables()
	local stress = { value = nil, minValue = nil, maxValue = nil }
	
	for index, id in pairs(CharData) do
		local power = avatar.GetVariableInfo(id)
		if power.sysName == "StressManaType" then
			--LogInfo("Stress: "..tostring(power.value))
			--LogInfo("Max Stress: "..tostring(power.maxValue))
			--LogInfo("Min Stress: "..tostring(power.minValue))
			stress.value = power.value
			stress.minValue = power.minValue
			stress.maxValue = power.maxValue
		end
	end
	
	if ClassP["Color"] then
		local stressPerc = stress.value / stress.maxValue
		if stressPerc > .75 then
			Text:SetClassVal("class", "tip_red")
		elseif stressPerc > .45 then
			Text:SetClassVal("class", "LogColorOrange")
		elseif stressPerc > .25 then
			Text:SetClassVal("class", "LogColorYellow")
		else
			Text:SetClassVal("class", "tip_green")
		end
	else
		Text:SetClassVal("class", "tip_red")
	end
	Text:SetVal("value", userMods.ToWString("Stress: "..stress.value)) --Стресс
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end

function FanaticismChanged()
	local CharData = avatar.GetVariables()
	local fanaticism = { value = nil, minValue = nil, maxValue = nil }
		
	for index, id in pairs(CharData) do
		local power = avatar.GetVariableInfo(id)
		if power.sysName == "PriestZeal" then
			--LogInfo("Fanaticism: "..tostring(power.value))
			--LogInfo("Max Fanaticism: "..tostring(power.maxValue))
			--LogInfo("Min Fanaticism: "..tostring(power.minValue))
			fanaticism.value = power.value
			fanaticism.minValue = power.minValue
			fanaticism.maxValue = power.maxValue
		end
	end
	
	if ClassP["Color"] then
		local fanaticismPerc = fanaticism.value / fanaticism.maxValue
		if fanaticismPerc > .75 then
			Text:SetClassVal("class", "tip_green")
		elseif fanaticismPerc > .45 then
			Text:SetClassVal("class", "LogColorYellow")
		elseif fanaticismPerc > .25 then
			Text:SetClassVal("class", "LogColorOrange")
		else
			Text:SetClassVal("class", "tip_red")
		end
	else
		Text:SetClassVal("class", "tip_red")
	end
	Text:SetVal("value", userMods.ToWString("Fanaticism: "..fanaticism.value)) --Фанатизм
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end

function DriveChanged()
	local CharData = avatar.GetVariables()
	local drive = { value = nil, minValue = nil, maxValue = nil }
		
	for index, id in pairs(CharData) do
		local power = avatar.GetVariableInfo(id)
		if power.sysName == "Drive" then
			--LogInfo("Drive: "..tostring(power.value))
			--LogInfo("Max Drive: "..tostring(power.maxValue))
			--LogInfo("Min Drive: "..tostring(power.minValue))
			drive.value = power.value
			drive.minValue = power.minValue
			drive.maxValue = power.maxValue
		end
	end
	
	if ClassP["Color"] then
		local drivePerc = drive.value / drive.maxValue
		if drivePerc > .75 then
			Text:SetClassVal("class", "tip_green")
		elseif drivePerc > .45 then
			Text:SetClassVal("class", "LogColorYellow")
		elseif drivePerc > .25 then
			Text:SetClassVal("class", "LogColorOrange")
		else
			Text:SetClassVal("class", "tip_red")
		end
	else
		Text:SetClassVal("class", "tip_red")
	end
	Text:SetVal("value", userMods.ToWString("Tempo: "..drive.value)) --Темп
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end

function TempChanged()
	local CharData = avatar.GetVariables()
	local temp = { value = nil, minValue = nil, maxValue = nil }
		
	for index, id in pairs(CharData) do
		local power = avatar.GetVariableInfo(id)
		if power.sysName == "EngineerOverheating" then
			--LogInfo("Temp: "..tostring(power.value))
			--LogInfo("Max Temp: "..tostring(power.maxValue))
			--LogInfo("Min Temp: "..tostring(power.minValue))
			temp.value = power.value
			temp.minValue = power.minValue
			temp.maxValue = power.maxValue
		end
	end
	
	if ClassP["Color"] then
		if temp.value >= 200 then
			Text:SetClassVal("class", "tip_red")
		elseif temp.value > 80 then
			Text:SetClassVal("class", "LogColorOrange")
		elseif temp.value >= 0 then
			Text:SetClassVal("class", "LogColorYellow")
		elseif temp.value >= -80 then
			Text:SetClassVal("class", "LogColorCyan")
		elseif temp.value > -200 then
			Text:SetClassVal("class", "tip_blue")
		else
			Text:SetClassVal("class", "LogColorBlue")
		end
	else
		Text:SetClassVal("class", "LogColorBlue")
	end
	Text:SetVal("value", userMods.ToWString("Temp: "..temp.value)) --Температура
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end

function ObsessionChanged()
	local CharData = avatar.GetVariables()
	local obsession = { value = nil, minValue = nil, maxValue = nil }
		
	for index, id in pairs(CharData) do
		local power = avatar.GetVariableInfo(id)
		if power.sysName == "DemonRage" then
			--LogInfo("Obsession: "..tostring(power.value))
			--LogInfo("Max Obsession: "..tostring(power.maxValue))
			--LogInfo("Min Obsession: "..tostring(power.minValue))
			obsession.value = power.value
			obsession.minValue = power.minValue
			obsession.maxValue = power.maxValue
		end
	end
	
	if ClassP["Color"] then
		local obsessionPerc = obsession.value / obsession.maxValue
		if obsessionPerc > .75 then
			Text:SetClassVal("class", "tip_green")
		elseif obsessionPerc > .45 then
			Text:SetClassVal("class", "LogColorYellow")
		elseif obsessionPerc > .25 then
			Text:SetClassVal("class", "LogColorOrange")
		else
			Text:SetClassVal("class", "tip_red")
		end
	else
		Text:SetClassVal("class", "tip_red")
	end
	Text:SetVal("value", userMods.ToWString("Obsession: "..obsession.value)) --Одержимость
	if Plate then
		Plate:Show(ClassP["Panel"])
	end
end

function Slash(p)
	if userMods.FromWString(p.text) == "/cpdnd" then
		if Plate then
			DNDPanel:Show(not DNDPanel:IsVisible())
		end
		if ResourceBar then
			ResourceDNDPanel:Show(not ResourceDNDPanel:IsVisible())
		end
		if PetBar then
			PetDND:Show(not PetDND:IsVisible())
		end
	elseif userMods.FromWString(p.text) == "/cpplate" then
		if Plate then
			ClassP["Panel"] = not ClassP["Panel"]
			Plate:Show(ClassP["Panel"])
		end
		userMods.SetGlobalConfigSection("ClassP", ClassP)
	elseif userMods.FromWString(p.text) == "/cppet" then
		if PetBar then
			ClassP["Pet"] = not ClassP["Pet"]
			PetBar:Show(ClassP["Pet"])
		end
		userMods.SetGlobalConfigSection("ClassP", ClassP)
	elseif userMods.FromWString(p.text) == "/cpcolor" then
		ClassP["Color"] = not ClassP["Color"]
		userMods.SetGlobalConfigSection("ClassP", ClassP)
	elseif userMods.FromWString(p.text) == "/cptext" then
		ClassP["Text"] = not ClassP["Text"]
		MainPanel:Show(ClassP["Text"])
		userMods.SetGlobalConfigSection("ClassP", ClassP)
	end
end

--------------------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------------------
function Init()
	if not ClassP then
		ClassP = {}
		ClassP["Panel"] = true
		ClassP["Color"] = true
		ClassP["Pet"] = true
		ClassP["Text"] = true
		userMods.SetGlobalConfigSection("ClassP", ClassP)
	end
	
	common.RegisterEventHandler( Slash, "EVENT_UNKNOWN_SLASH_COMMAND")
	
	--resize the Plates frame to allow moving resource bar over entire screen
	local P = PlatesFrame:GetPlacementPlain()
	P.alignX = WIDGET_ALIGN_BOTH
	P.alignY = WIDGET_ALIGN_BOTH
	P.posX = 0
	P.highposX = 0
	P.sizeX = 0
	P.posY = 0
	P.highposY = 0
	P.sizeY = 0
	PlatesFrame:SetPlacementPlain(P)
	
	--fix the position of direct child frames that have been affected by above resize (those aligned "WIDGET_ALIGN_HIGH" in either X or Y)
	--those are: Party and TargetsTarget, FanaticismItem and DissonanceItem

	--Party (was aligned "high" in Y)
	local PartyFrame = PlatesFrame:GetChildUnchecked("Party", false)
	P = PartyFrame:GetPlacementPlain()
	P.alignY = WIDGET_ALIGN_LOW
	P.posY = 320
	PartyFrame:SetPlacementPlain(P)
	
	--TargetsTarget (was aligned "high" in X)
	local TargetsTargetFrame = PlatesFrame:GetChildUnchecked("TargetsTarget", false)
	P = TargetsTargetFrame:GetPlacementPlain()
	P.alignX = WIDGET_ALIGN_LOW
	P.posX = 700
	TargetsTargetFrame:SetPlacementPlain(P)
	
	--[[--FanaticismItem (was aligned "high" in Y)
	local FItemFrame = PlatesFrame:GetChildUnchecked("FanaticismItem", false)
	P = FItemFrame:GetPlacementPlain()
	P.alignY = WIDGET_ALIGN_LOW
	P.posY = 664
	FItemFrame:SetPlacementPlain(P)
	
	--DissonanceItem (was aligned "high" in Y)
	local DItemFrame = PlatesFrame:GetChildUnchecked("DissonanceItem", false)
	P = DItemFrame:GetPlacementPlain()
	P.alignY = WIDGET_ALIGN_LOW
	P.posY = 670
	DItemFrame:SetPlacementPlain(P)
	]]
	
	if unit.GetClass(avatar.GetId()).className == "PALADIN" then
		common.RegisterEventHandler( BarrierChanged, "EVENT_AVATAR_BARRIERS_CHANGED")
		PalPlate()
	end
	if unit.GetClass(avatar.GetId()).className == "WARRIOR" then
		common.RegisterEventHandler( CEChanged, "EVENT_AVATAR_WARRIOR_COMBAT_ADVANTAGE_CHANGED")
		WarPlate()
	end
	if unit.GetClass(avatar.GetId()).className == "MAGE" then
		common.RegisterEventHandler( EntropyChanged, "EVENT_VARIABLE_VALUE_CHANGED")
		common.RegisterEventHandler( onObjectBuffsChanged, "EVENT_OBJECT_BUFFS_CHANGED")
		common.RegisterEventHandler( onObjectBuffsElementChanged, "EVENT_OBJECT_BUFFS_ELEMENT_CHANGED")
		--EntropyChanged(avatar.GetId())
		MagPlate()
	end
	if unit.GetClass(avatar.GetId()).className == "STALKER" then
		--common.RegisterEventHandler( BeltChanged, "EVENT_AVATAR_STALKER_CARTRIDGE_BELT_CHANGED")
		--BeltChanged()
		common.RegisterEventHandler( GearPieceChanged, "EVENT_VARIABLE_VALUE_CHANGED")
		GearPieceChanged()
		StaPlate()
	end
	if unit.GetClass(avatar.GetId()).className == "NECROMANCER" then
		common.RegisterEventHandler( BloodChanged, "EVENT_VARIABLE_VALUE_CHANGED")
		common.RegisterEventHandler( PetSpawn, "EVENT_ACTIVE_PET_CHANGED")
		BloodChanged()
		NecrPlate()
	end
	if unit.GetClass(avatar.GetId()).className == "DRUID" then
		--common.RegisterEventHandler( SPChanged, "EVENT_DRUID_PET_COMMAND_POINTS_CHANGED")
		common.RegisterEventHandler( PetSpawn, "EVENT_ACTIVE_PET_CHANGED")
		common.RegisterEventHandler( ManaChanged, "EVENT_UNIT_MANA_CHANGED")
		ManaChanged()
		DruPlate()
	end
	if unit.GetClass(avatar.GetId()).className == "PSIONIC" then
		common.RegisterEventHandler( StressChanged, "EVENT_VARIABLE_VALUE_CHANGED")
		StressChanged()
		PsiPlate()
	end
	if unit.GetClass(avatar.GetId()).className == "PRIEST" then
		common.RegisterEventHandler( FanaticismChanged, "EVENT_VARIABLE_VALUE_CHANGED")
		FanaticismChanged()
		PriestPlate()
	end
	if unit.GetClass(avatar.GetId()).className == "BARD" then
		common.RegisterEventHandler( DriveChanged, "EVENT_VARIABLE_VALUE_CHANGED")
		DriveChanged()
		BardPlate()
	end
	if unit.GetClass(avatar.GetId()).className == "ENGINEER" then
		common.RegisterEventHandler( TempChanged, "EVENT_VARIABLE_VALUE_CHANGED")
		TempChanged()
		EngineerPlate()
	end
	if unit.GetClass(avatar.GetId()).className == "WARLOCK" then
		common.RegisterEventHandler( ObsessionChanged, "EVENT_VARIABLE_VALUE_CHANGED")
		ObsessionChanged()
		DemPlate()
	end
--[[-- Warp Classes -- obsolete
	if unit.GetClass(avatar.GetId()).className == "WITCHER" then
		WitcherPlate()
	end ]]
	
--[[--test
	if Plate == nil then
		LogInfo("Plate nil")
	else
		LogInfo("Plate exists")
	end
	
	if PetBar == nil then
		LogInfo("PetBar nil")
	else
		LogInfo("PetBar exists")
	end
	
	if ResourceBar == nil then
		LogInfo("ResourceBar nil")
	else
		LogInfo("ResourceBar exists")
	end ]]
	
	if Plate then
		P = Plate:GetPlacementPlain()
		P.alignX = WIDGET_ALIGN_LOW
		P.alignY = WIDGET_ALIGN_LOW
		P.posX = 400
		P.posY = 400
		Plate:SetPlacementPlain(P)
		Plate:AddChild(DNDPanel)
		Plate:SetPriority(3001)
		
		DnD:Init(399, DNDPanel, Plate, true)
		Plate:Show(ClassP["Panel"])
		
		PlateName = Plate:GetName()
		Plate:SetOnShowNotification(true)
	end
	if PetBar then
		P = PetBar:GetPlacementPlain()
		P.alignX = WIDGET_ALIGN_LOW
		P.alignY = WIDGET_ALIGN_LOW
		P.posX = 400
		P.posY = 400
		PetBar:SetPlacementPlain(P)
		--PetBar:SetClipContent(true)
		--PetDND = DNDPanel
		PetBar:AddChild(PetDND)
		PetBar:SetPriority(3001)
		PetDND:SetPriority(250)
		
		DnD:Init(398, PetDND, PetBar, true)
		
		PetBarName = PetBar:GetName()
		PetBar:SetOnShowNotification(true)
	end
	
	--prevent auto-showing the petbar or plate when disabled and entering chat (happens for some odd reason)
	if PetBar or Plate then
		common.RegisterEventHandler(onFrameShowChanged, "EVENT_WIDGET_SHOW_CHANGED")
	end
	
	if ResourceBar then
		--move it from Plates.Avatar to stateMainForm if it hasn't been done already (not addon-reload)
		if ResourceModified == nil then
			stateMainForm:AddChild(ResourceBar)
		end
		
		P = ResourceBar:GetPlacementPlain()
		P.alignX = WIDGET_ALIGN_LOW
		P.alignY = WIDGET_ALIGN_LOW
		P.posX = 100
		P.posY = 100
		ResourceBar:SetPlacementPlain(P)
		ResourceBar:AddChild(ResourceDNDPanel)
		ResourceBar:SetPriority(3001)
		DnD:Init(396, ResourceDNDPanel, ResourceBar, true)
	end
	
	DnD:Init(397, MainPanel, MainPanel, true)
	if PetBar and not PetBar:IsVisible() then
		PetBar:Show(ClassP["Pet"])
	end
	MainPanel:Show(ClassP["Text"])
end

function onFrameShowChanged(params)
	local name = params.widget:GetName()
	
	if name == PlateName then
		Plate:Show(ClassP["Panel"])
	end
	
	if name == PetBarName then
		PetBar:Show(ClassP["Pet"])
	end
end

--------------------------------------------------------------------------------
common.RegisterEventHandler( Init, "EVENT_AVATAR_CREATED")
if avatar.IsExist() then
	Init()
end
--------------------------------------------------------------------------------