function PalPlate()
	Plate = stateMainForm:GetChildUnchecked("PaladinPanel", true):GetParent()
end

function WarPlate()
	Plate = stateMainForm:GetChildUnchecked("ClassAddonWarrior", true)
end

function MagPlate()
	Plate = stateMainForm:GetChildUnchecked("ClassAddonMage", true)
end

function StaPlate()
	ResourceDefault = PlatesAvatarFrame:GetChildUnchecked("StalkerMateriel", false)
	ResourceModified = stateMainForm:GetChildUnchecked("StalkerMateriel", false)
	Plate = stateMainForm:GetChildUnchecked("StalkerCartridgeBelt2", true)
	if ResourceDefault == nil then
		ResourceBar = ResourceModified
	else
		ResourceBar = ResourceDefault
	end
end

function NecrPlate()
	PetBar = stateMainForm:GetChildUnchecked("ClassAddonNecromancer", true)
end

function DruPlate()
	PetBar = stateMainForm:GetChildUnchecked("ClassAddonDruid", true)
end

function PsiPlate()
	Plate = stateMainForm:GetChildUnchecked("ClassAddonPsionic", true)
end

function PriestPlate()
	ResourceDefault = PlatesAvatarFrame:GetChildUnchecked("PriestVars", false)
	ResourceModified = stateMainForm:GetChildUnchecked("PriestVars", false)
	if ResourceDefault == nil then
		ResourceBar = ResourceModified
	else
		ResourceBar = ResourceDefault
	end
end

function BardPlate()
	ResourceDefault = PlatesAvatarFrame:GetChildUnchecked("BardDissonance", false)
	ResourceModified = stateMainForm:GetChildUnchecked("BardDissonance", false)
	if ResourceDefault == nil then
		ResourceBar = ResourceModified
	else
		ResourceBar = ResourceDefault
	end
end

function EngineerPlate()
	--Plate = stateMainForm:GetChildUnchecked("ClassAddonEngineer", true) -- does not work, disappears class panel
end

function DemPlate()
	Plate = stateMainForm:GetChildUnchecked("ClassAddonWarlock", true)
end

--[[-- Warp Classes -- obsolete
function WitcherPlate()
	ResourceDefault = PlatesAvatarFrame:GetChildUnchecked("WitcherShards", false)
	ResourceModified = stateMainForm:GetChildUnchecked("WitcherShards", false)
	if ResourceDefault == nil then
		ResourceBar = ResourceModified
	else
		ResourceBar = ResourceDefault
	end
end 

function StaPlate()
	ResourceDefault = PlatesAvatarFrame:GetChildUnchecked("StalkerComrade", false)
	ResourceModified = stateMainForm:GetChildUnchecked("StalkerComrade", false)
	if ResourceDefault == nil then
		ResourceBar = ResourceModified
	else
		ResourceBar = ResourceDefault
	end
end ]]
