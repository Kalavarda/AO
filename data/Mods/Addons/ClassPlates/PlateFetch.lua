function SumPlate()
	ResourceDefault = PlatesAvatarFrame:GetChildUnchecked("Pool", false)
	ResourceModified = stateMainForm:GetChildUnchecked("Pool", false)
	PetBar = stateMainForm:GetChildUnchecked( "NecromancerPet2", false )
	if ResourceDefault == nil then
		ResourceBar = ResourceModified
	else
		ResourceBar = ResourceDefault
	end
end

function PalPlate()
	Plate = stateMainForm:GetChildUnchecked( "PaladinPanel", true ):GetParent()
end

function DruPlate()
	Plate = stateMainForm:GetChildUnchecked( "PetCommandPoints", true )
end

function PsiPlate()
	Plate = stateMainForm:GetChildUnchecked("PsionicContact2", false)
	ResourceDefault = PlatesAvatarFrame:GetChildUnchecked("PsionicStress", false)
	ResourceModified = stateMainForm:GetChildUnchecked("PsionicStress", false)
	if ResourceDefault == nil then
		ResourceBar = ResourceModified
	else
		ResourceBar = ResourceDefault
	end
end

function WarPlate()
	Plate = stateMainForm:GetChildUnchecked( "ClassAddonWarrior", false )
end

function MagPlate()
	Plate = stateMainForm:GetChildUnchecked( "MageEnergyInstability3", true )
end

function StaPlate()
	ResourceDefault = PlatesAvatarFrame:GetChildUnchecked("StalkerMateriel", false)
	ResourceModified = stateMainForm:GetChildUnchecked("StalkerMateriel", false)
	Plate = stateMainForm:GetChildUnchecked("StalkerCartridgeBelt2", false)
	-- удалить двойные тире перед строчками ниже, если нужна поддержка Следопыта из Края Мира
	--ResourceDefault = PlatesAvatarFrame:GetChildUnchecked("StalkerComrade", false)
	--ResourceModified = stateMainForm:GetChildUnchecked("StalkerComrade", false)
	if ResourceDefault == nil then
		ResourceBar = ResourceModified
	else
		ResourceBar = ResourceDefault
	end
end

function EngineerPlate()
	Plate = stateMainForm:GetChildUnchecked( "Engineer", true ):GetParent()
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

function DemPlate()
	Plate = stateMainForm:GetChildUnchecked( "DemonologistStance", true )
end

-- Warp Classes
function WitcherPlate()
	ResourceDefault = PlatesAvatarFrame:GetChildUnchecked("WitcherShards", false)
	ResourceModified = stateMainForm:GetChildUnchecked("WitcherShards", false)
	if ResourceDefault == nil then
		ResourceBar = ResourceModified
	else
		ResourceBar = ResourceDefault
	end
end
