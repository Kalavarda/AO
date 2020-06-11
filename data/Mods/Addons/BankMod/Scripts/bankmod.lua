----------------
--Author: Pfui--
----------------

----We change the Size of ContextDepositeBox and container
Global( "ContextDepBox", stateMainForm:GetChildChecked("ContextDepositeBox", false ) )
Global( "MainPanel", ContextDepBox:GetChildChecked("MainPanel", false) )
Global( "DepBoxCont", MainPanel:GetChildChecked("DepositeBoxContainer", false ) )
Global( "Heading", MainPanel:GetChildChecked("HeaderText", false))

Global( "MainSize", 1000)
Global( "contSize", 850 )
function changePlacement()

	local Screen = widgetsSystem:GetPosConverterParams()
	MainSize = Screen.fullVirtualSizeY - 15
	contSize = Screen.fullVirtualSizeY - 165

	
	local plCDB = ContextDepBox:GetPlacementPlain()
	plCDB.sizeY = MainSize
	plCDB.alignY = WIDGET_ALIGN_LOW
	plCDB.alignX = WIDGET_ALIGN_LOW
	plCDB.posY = 0
	ContextDepBox:SetPlacementPlain(plCDB)
	
	local plMP = MainPanel:GetPlacementPlain()
	plMP.sizeY = MainSize
	MainPanel:SetPlacementPlain(plMP)
	
	local plCont = DepBoxCont:GetPlacementPlain()
	plCont.sizeY = contSize
	DepBoxCont:SetPlacementPlain(plCont)
	
	DnD:Init(Heading, ContextDepBox, true, true, {-1,500,-1,-1}, nil )
	
end

function f_EVENT_WIDGET_SHOW_CHANGED(p)
	--common.LogInfo("common", userMods.ToWString("Changed")) --for debug purposes
	if p.widget ~= nil and p.widget:IsEqual(MainPanel) then
		if MainPanel:IsVisible() then
			changePlacement()
		end
	end
end
function Init()


	MainPanel:SetOnShowNotification(true)
	common.RegisterEventHandler(f_EVENT_WIDGET_SHOW_CHANGED, "EVENT_WIDGET_SHOW_CHANGED")
end
function PreInit()
	common.RegisterEventHandler( Init, "EVENT_AVATAR_CREATED" )
	if avatar.IsExist() then
		Init()
	end
end


PreInit()