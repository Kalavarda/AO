Global( "localization", "eng" )
Global( "onEvent", {} )
Global( "onReaction", {} )
local wtMain
local wtControl3D

-- slider setup
local slider = mainForm:GetChildChecked( "MainPanel", false ):GetChildChecked( 'SliderPanel', false ):GetChildChecked( 'DiscreteSlider', false )
local stepsCount = 10
slider:SetStepsCount( stepsCount )
local value 
-- min and max scale
local valueMin = 0.2
local valueMax = 0.8
local step = ( valueMax - valueMin ) / stepsCount

function RegisterEventHandlers( handlers )
	for event, handler in pairs(handlers) do
		common.RegisterEventHandler( handler, event )
	end
end

function RegisterReactionHandlers( handlers )
	for event, handler in pairs(handlers) do
		common.RegisterReactionHandler( handler, event )
	end
end

-- AO game Localization detection by SLA. Version 2011-02-10.
function GetGameLocalization()
	local B = cartographer.GetMapBlocks()
	local T = { rus="\203\232\227\224", eng="Holy Land", ger="Heiliges Land",
	fra="Terre Sacr\233e", br="Terra Sagrada", jpn="\131\74\131\106\131\65" }
	for b in pairs(B) do for l,t in pairs(T) do
	if userMods.FromWString( cartographer.GetMapBlockInfo(B [b] ).name ) == t
	then return l end; end; end; return "eng"
end

function GetTextLocalized( strTextName )
	return common.GetAddonRelatedTextGroup( localization ):GetText( strTextName )
end
-------------------------------------------------------------

-- create scene with a chosen mount skin
function createMountScene(skinId)
	mission.SetMountScene( 1, wtControl3D, skinId )
	mission.SetCharacterSceneScaleFactor( 1, 0.38 )
	mission.SetCharacterScenePosition( 1, { posX = 0.0; posY = 0.8; posZ = 0.2 } ) -- move it up a bit
	mission.SetCharacterSceneSmoothRotation( 1, false ) -- set true for smoother animation but it also takes way too long, applies rotation animation (that doesn't really look that good) and might result with infinite spin 
	mission.ResetCharacterSceneRotation( 1 ) -- to remove any previous rotations
	mission.RotateCharacterScene( 1, 0.5 ) -- do the rotation so it looks nice
	
end

-- user clicked valued object on chat 
onEvent [ "EVENT_VALUED_OBJECT_CLICKED" ] = function( params )
	local itemId = params.object:GetId()
	if params.object:GetType() == VAL_OBJ_TYPE_ITEM and params.kbFlags == KBF_ALT then
		--ChatLog("item clicked")
		local skinId = itemLib.GetIncludedMountSkin( itemId )
		if skinId then
			createMountScene(skinId)
			slider:SetPos(3)
			show(wtMain)
		end
		--ChatLog("item without inlucluded skin clicked")
	end
end

-- user changed slider position
onReaction [ "discrete_slider_changed" ] = function( params )
	if params.widget:IsEqual( slider ) then
		value = valueMin + params.widget:GetPos() * step
		mission.SetCharacterSceneScaleFactor( 1, value )
	end
end

-- user clicked on X to close window
onReaction [ "mouse_left_click" ] = function( params )
	hide(wtMain)
end

--------------------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------------------
function Init()
	localization = GetGameLocalization()
	if not common.GetAddonRelatedTextGroup( localization ) then
		localization = "eng"
	end
	wtMain = mainForm:GetChildChecked( "MainPanel", false )
	local wtControl3DPanel = wtMain:GetChildChecked( "Control3DPanel", false )

	local wtHeader = wtMain:GetChildChecked( "Header", false ):GetChildChecked( "Header", false )
	wtHeader:SetVal( "value", GetTextLocalized( "AddonName" ) )

	wtControl3D = wtControl3DPanel:GetChildChecked( "Control", false )
	-- DnD for preview rotation
	DnD3D:Init( wtControl3D, wtControl3D, true )
	-- DnD for main window
	DnD:Init( wtHeader, wtMain, true )

	RegisterEventHandlers( onEvent )
	RegisterReactionHandlers( onReaction )
end
--------------------------------------------------------------------------------
Init()
--------------------------------------------------------------------------------