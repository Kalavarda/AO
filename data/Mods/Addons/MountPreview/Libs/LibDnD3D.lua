--------------------------------------------------------------------------------
-- LibDnD3D.lua // "Drag&Drop Library" by SLA, version 2011-05-28
--                                   updated version 2014-10-29 by hal.dll
-- Help, support and updates: 
-- https://alloder.pro/topic/260-how-to-libdndlua-biblioteka-dragdrop/
--------------------------------------------------------------------------------
Global( "DnD3D", {} )
-- PUBLIC FUNCTIONS --
function DnD3D.Init( wtMovable, wtReacting, fUseCfg, fLockedToParentArea, Padding, KbFlag, Cursor, oldParam1, oldParam2 )
	if wtMovable == DnD3D then
		wtMovable, wtReacting, fUseCfg, fLockedToParentArea, Padding, KbFlag, Cursor, oldParam1 =
		           wtReacting, fUseCfg, fLockedToParentArea, Padding, KbFlag, Cursor, oldParam1, oldParam2
	end
	if type(wtMovable) == "number" then
		wtReacting, wtMovable, fUseCfg, fLockedToParentArea, Padding, KbFlag, Cursor, oldParam1 =
		           wtReacting, fUseCfg, fLockedToParentArea, Padding, KbFlag, Cursor, oldParam1, oldParam2
	end
	if type(wtMovable) ~= "userdata" then return end
	if not DnD3D.Widgets then
		DnD3D.Widgets = {}
		DnD3D.Screen = widgetsSystem:GetPosConverterParams()
		common.RegisterEventHandler( DnD3D.OnPickAttempt, "EVENT_DND_PICK_ATTEMPT" )
		common.RegisterEventHandler( DnD3D.OnResolutionChanged, "EVENT_POS_CONVERTER_CHANGED" )
	end
	wtReacting = wtReacting or wtMovable
	local ID = DnD3D.AllocateDnDID(wtReacting)
	DnD3D.Widgets[ ID ] = {}
	DnD3D.Widgets[ ID ].wtReacting = wtReacting
	DnD3D.Widgets[ ID ].wtMovable = wtMovable
	DnD3D.Widgets[ ID ].Enabled = true
	DnD3D.Widgets[ ID ].fUseCfg = fUseCfg or false
	DnD3D.Widgets[ ID ].CfgName = fUseCfg and "DnD:" .. DnD3D.GetWidgetTreePath( DnD3D.Widgets[ ID ].wtMovable )
	DnD3D.Widgets[ ID ].fLockedToParentArea = fLockedToParentArea == nil and true or fLockedToParentArea
	DnD3D.Widgets[ ID ].KbFlag = type(KbFlag) == "number" and KbFlag or false
	DnD3D.Widgets[ ID ].Cursor = Cursor == false and "default" or type(Cursor) == "string" and Cursor or "drag"
	DnD3D.Widgets[ ID ].Padding = { 0, 0, 0, 0 } -- { T, R, B, L }
	if type( Padding ) == "table" then
		for i = 1, 4 do
			if Padding[ i ] then
				DnD3D.Widgets[ ID ].Padding[ i ] = Padding[ i ]
			end
		end
	elseif type( Padding ) == "number" then
		for i = 1, 4 do
			DnD3D.Widgets[ ID ].Padding[ i ] = Padding
		end
	end
	local InitialPlace = DnD3D.Widgets[ ID ].wtMovable:GetPlacementPlain()
	if fUseCfg then
		local Cfg = GetConfig( DnD3D.Widgets[ ID ].CfgName )
		if Cfg then
			local LimitMin, LimitMax = DnD3D.PrepareLimits( ID, InitialPlace )
			InitialPlace.posX = Cfg.posX or InitialPlace.posX
			InitialPlace.posY = Cfg.posY or InitialPlace.posY
			InitialPlace.highPosX = Cfg.highPosX or InitialPlace.highPosX
			InitialPlace.highPosY = Cfg.highPosY or InitialPlace.highPosY
			DnD3D.Widgets[ ID ].wtMovable:SetPlacementPlain( DnD3D.NormalizePlacement( InitialPlace, LimitMin, LimitMax ) )
		end
	end
	DnD3D.Widgets[ ID ].Initial = { X = InitialPlace.posX, Y = InitialPlace.posY, HX = InitialPlace.highPosX, HY = InitialPlace.highPosY }
	local mt = getmetatable( wtReacting )
	if not mt._Show then
		mt._Show = mt.Show
		mt.Show = function ( self, show )
			self:_Show( show ); DnD3D.Register( self, show )
		end
	end
	DnD3D.Register( wtReacting, true )
end
function DnD3D.Remove( wtWidget, oldParam1 )
	if not DnD3D.Widgets then return end
	if wtWidget == DnD then wtWidget = oldParam1 end
	local ID = DnD3D.GetWidgetID( wtWidget )
	if ID then
		DnD3D.Enable( wtWidget, false )
		DnD3D.Widgets[ ID ] = nil
	end
end
function DnD3D.Enable( wtWidget, fEnable, oldParam1 )
	if not DnD3D.Widgets then return end
	if wtWidget == DnD3D then wtWidget, fEnable = fEnable, oldParam1 end
	local ID = DnD3D.GetWidgetID( wtWidget )
	if ID and DnD3D.Widgets[ ID ].Enabled ~= fEnable then
		DnD3D.Widgets[ ID ].Enabled = fEnable
		DnD3D.Register( wtWidget, fEnable )
	end
end
function DnD3D.IsDragging()
	return DnD3D.Dragging and true or false
end
-- FREE BONUS --
function GetConfig( name )
	local cfg = userMods.GetGlobalConfigSection( common.GetAddonName() )
	if not name then return cfg end
	return cfg and cfg[ name ]
end
function SetConfig( name, value )
	local cfg = userMods.GetGlobalConfigSection( common.GetAddonName() ) or {}
	if type( name ) == "table" then
		for i, v in pairs( name ) do cfg[ i ] = v end
	elseif name ~= nil then
		cfg[ name ] = value
	end
	userMods.SetGlobalConfigSection( common.GetAddonName(), cfg )
end
-- INTERNAL FUNCTIONS --
function DnD3D.AllocateDnDID( wtWidget )
	local BaseID = 300200
	return BaseID + common.RequestIntegerByInstanceId(wtWidget:GetInstanceId())
end
function DnD3D.GetWidgetID( wtWidget )
	local WtId = wtWidget:GetInstanceId()
	for ID, W in pairs( DnD3D.Widgets ) do
		if W.wtReacting:GetInstanceId() == WtId or W.wtMovable:GetInstanceId() == WtId then
			return ID
		end
	end
end
function DnD3D.GetWidgetTreePath( wtWidget )
	local components = {}
	while wtWidget do
		table.insert( components, 1, wtWidget:GetName() )
		wtWidget = wtWidget:GetParent()
	end
	return table.concat( components, '.' )
end
function DnD3D.Register( wtWidget, fRegister )
	if not DnD3D.Widgets then return end
	local ID = DnD3D.GetWidgetID( wtWidget )
	if ID then
		if fRegister and DnD3D.Widgets[ ID ].Enabled and DnD3D.Widgets[ ID ].wtReacting:IsVisible() then
			mission.DNDRegister( DnD3D.Widgets[ ID ].wtReacting, ID, true )
		elseif not fRegister then
			if DnD3D.Dragging == ID then
				mission.DNDCancelDrag()
				DnD3D.OnDragCancelled()
			end
			mission.DNDUnregister( DnD3D.Widgets[ ID ].wtReacting )
		end
	end
end
-----------------------------------------------------------------------------------------------------------
function DnD3D.GetParentRealSize( Widget )
	local ParentSize = {}
	local ParentRect
	local parent = Widget:GetParent()
	if parent then
		ParentRect = parent:GetRealRect()
		ParentSize.sizeX = (ParentRect.x2 - ParentRect.x1) * DnD3D.Screen.fullVirtualSizeX / DnD3D.Screen.realSizeX
		ParentSize.sizeY = (ParentRect.y2 - ParentRect.y1) * DnD3D.Screen.fullVirtualSizeY / DnD3D.Screen.realSizeY
	else
		ParentRect = { x1 = 0, y1 = 0, x2 = DnD3D.Screen.realSizeX, y2 = DnD3D.Screen.realSizeY }
		ParentSize.sizeX = DnD3D.Screen.fullVirtualSizeX
		ParentSize.sizeY = DnD3D.Screen.fullVirtualSizeY
	end
	return ParentSize, ParentRect
end
function DnD3D.NormalizePlacement( Place, LimitMin, LimitMax )
	local Opposite = { posX = "highPosX", posY = "highPosY", highPosX = "posX", highPosY = "posY"  }
	for k,v in pairs(LimitMax) do
		if Place[k] > v then
			Place[ Opposite[k] ] = Place[ Opposite[k] ] + Place[k] - v
			Place[k] = v
		end
	end
	for k,v in pairs(LimitMin) do
		if Place[k] < v then
			Place[ Opposite[k] ] = Place[ Opposite[k] ] + Place[k] - v
			Place[k] = v
		end
	end
	return Place
end
function DnD3D.PrepareLimits( ID, Place )
	local LimitMin = {}
	local LimitMax = {}
	local ParentSize, ParentRect = DnD3D.GetParentRealSize( DnD3D.Widgets[ ID ].wtMovable )
	local Padding = DnD3D.Widgets[ ID ].Padding
	Place = Place or DnD3D.Widgets[ ID ].wtMovable:GetPlacementPlain()
	if Place.alignX == WIDGET_ALIGN_LOW then
		LimitMin.posX = Padding[ 4 ]
		LimitMax.posX = ParentSize.sizeX - Place.sizeX - Padding[ 2 ]
	elseif Place.alignX == WIDGET_ALIGN_HIGH then
		LimitMin.highPosX = Padding[ 2 ]
		LimitMax.highPosX = ParentSize.sizeX - Place.sizeX - Padding[ 4 ]
	elseif Place.alignX == WIDGET_ALIGN_CENTER then
		LimitMin.posX = Place.sizeX / 2 - ParentSize.sizeX / 2 + Padding[ 4 ]
		LimitMax.posX = ParentSize.sizeX / 2 - Place.sizeX / 2 - Padding[ 2 ]
	elseif Place.alignX == WIDGET_ALIGN_BOTH then
		LimitMin.posX = Padding[ 4 ]
		LimitMin.highPosX = Padding[ 2 ]
	elseif Place.alignX == WIDGET_ALIGN_LOW_ABS then
		LimitMin.posX = Padding[ 4 ] * DnD3D.Screen.realSizeX / DnD3D.Screen.fullVirtualSizeX
		LimitMax.posX = ( ParentSize.sizeX - Place.sizeX - Padding[ 2 ] ) * DnD3D.Screen.realSizeX / DnD3D.Screen.fullVirtualSizeX
	end
	if Place.alignY == WIDGET_ALIGN_LOW then
		LimitMin.posY = Padding[ 1 ]
		LimitMax.posY = ParentSize.sizeY - Place.sizeY - Padding[ 3 ]
	elseif Place.alignY == WIDGET_ALIGN_HIGH then
		LimitMin.highPosY = Padding[ 3 ]
		LimitMax.highPosY = ParentSize.sizeY - Place.sizeY - Padding[ 1 ]
	elseif Place.alignY == WIDGET_ALIGN_CENTER then
		LimitMin.posY = Place.sizeY / 2 - ParentSize.sizeY / 2 + Padding[ 1 ]
		LimitMax.posY = ParentSize.sizeY / 2 - Place.sizeY / 2 - Padding[ 3 ]
	elseif Place.alignY == WIDGET_ALIGN_BOTH then
		LimitMin.posY = Padding[ 1 ]
		LimitMin.highPosY = Padding[ 3 ]
	elseif Place.alignY == WIDGET_ALIGN_LOW_ABS then
		LimitMin.posY = Padding[ 1 ] * DnD3D.Screen.realSizeY / DnD3D.Screen.fullVirtualSizeY
		LimitMax.posY = (ParentSize.sizeY - Place.sizeY - Padding[ 3 ] ) * DnD3D.Screen.realSizeY / DnD3D.Screen.fullVirtualSizeY
	end
	return LimitMin, LimitMax
end
-----------------------------------------------------------------------------------------------------------
function DnD3D.OnPickAttempt( params )
	local Picking = params.srcId
	if DnD3D.Widgets[ Picking ] and DnD3D.Widgets[ Picking ].Enabled and ( not DnD3D.Widgets[ Picking ].KbFlag or DnD3D.Widgets[ Picking ].KbFlag == KBF_NONE and params.kbFlags == KBF_NONE or common.GetBitAnd( params.kbFlags, DnD3D.Widgets[ Picking ].KbFlag ) ~= 0 ) then
		DnD3D.Place = DnD3D.Widgets[ Picking ].wtMovable:GetPlacementPlain()
		DnD3D.Reset = DnD3D.Widgets[ Picking ].wtMovable:GetPlacementPlain()
		DnD3D.Cursor = { X = params.posX , Y = params.posY }
		DnD3D.Screen = widgetsSystem:GetPosConverterParams()
		if DnD3D.Widgets[ Picking ].fLockedToParentArea then
			DnD3D.LimitMin, DnD3D.LimitMax = DnD3D.PrepareLimits( Picking, DnD3D.Place )
		end
		--common.SetCursor( DnD3D.Widgets[ Picking ].Cursor )
		DnD3D.Dragging = Picking
		common.RegisterEventHandler( DnD3D.OnDragTo, "EVENT_DND_DRAG_TO" )
		common.RegisterEventHandler( DnD3D.OnDropAttempt, "EVENT_DND_DROP_ATTEMPT" )
		common.RegisterEventHandler( DnD3D.OnDragCancelled, "EVENT_DND_DRAG_CANCELLED" )
		-- AO 2.0.06+ All IDs other than 14xxx and 15xxx need confirmation
		mission.DNDConfirmPickAttempt()
	end
end
function DnD3D.OnDragTo( params )
	
	if not DnD3D.Dragging then return end
	local dx = params.posX - DnD3D.Cursor.X
	--ChatLog(dx)
	mission.RotateCharacterScene( 1, dx/6500 )
	local dy = params.posY - DnD3D.Cursor.Y
	if DnD3D.Place.alignX ~= WIDGET_ALIGN_LOW_ABS then
		dx = dx * DnD3D.Screen.fullVirtualSizeX / DnD3D.Screen.realSizeX
	end
	if DnD3D.Place.alignY ~= WIDGET_ALIGN_LOW_ABS then
		dy = dy * DnD3D.Screen.fullVirtualSizeY / DnD3D.Screen.realSizeY
	end
	DnD3D.Place.posX = math.floor( DnD3D.Reset.posX + dx )
	DnD3D.Place.posY = math.floor( DnD3D.Reset.posY + dy )
	DnD3D.Place.highPosX = math.floor( DnD3D.Reset.highPosX - dx )
	DnD3D.Place.highPosY = math.floor( DnD3D.Reset.highPosY - dy )
	if DnD3D.Widgets[ DnD3D.Dragging ].fLockedToParentArea then
		DnD3D.Place = DnD3D.NormalizePlacement( DnD3D.Place, DnD3D.LimitMin, DnD3D.LimitMax )
	end
	DnD3D.Widgets[ DnD3D.Dragging ].wtMovable:SetPlacementPlain( DnD3D.Place )
	--common.SetCursor( DnD3D.Widgets[ DnD3D.Dragging ].Cursor )
end
function DnD3D.OnDropAttempt()
	DnD3D.StopDragging( true )
end
function DnD3D.OnDragCancelled()
	DnD3D.StopDragging( false )
end
function DnD3D.StopDragging( fSuccess )
	if not DnD3D.Dragging then return end
	common.UnRegisterEventHandler( DnD3D.OnDragTo, "EVENT_DND_DRAG_TO" )
	common.UnRegisterEventHandler( DnD3D.OnDropAttempt, "EVENT_DND_DROP_ATTEMPT" )
	common.UnRegisterEventHandler( DnD3D.OnDragCancelled, "EVENT_DND_DRAG_CANCELLED" )
	if fSuccess then
		mission.DNDConfirmDropAttempt()
		if DnD3D.Widgets[ DnD3D.Dragging ].fUseCfg then
			SetConfig( DnD3D.Widgets[ DnD3D.Dragging ].CfgName, { posX = DnD3D.Place.posX, posY = DnD3D.Place.posY, highPosX = DnD3D.Place.highPosX, highPosY = DnD3D.Place.highPosY } )
		end
		DnD3D.Widgets[ DnD3D.Dragging ].Initial = { X = DnD3D.Place.posX, Y = DnD3D.Place.posY, HX = DnD3D.Place.highPosX, HY = DnD3D.Place.highPosY }
	else
		DnD3D.Widgets[ DnD3D.Dragging ].wtMovable:SetPlacementPlain( DnD3D.Reset )
	end
	DnD3D.Place = nil
	DnD3D.Reset = nil
	DnD3D.Cursor = nil
	DnD3D.LimitMin = nil
	DnD3D.LimitMax = nil
	DnD3D.Dragging = nil
	--common.SetCursor( "default" )
end
function DnD3D.OnResolutionChanged()
	mission.DNDCancelDrag()
	DnD3D.OnDragCancelled()
	DnD3D.Screen = widgetsSystem:GetPosConverterParams()
	for ID, W in pairs( DnD3D.Widgets ) do
		if W.fLockedToParentArea then
			local InitialPlace = W.wtMovable:GetPlacementPlain()
			local LimitMin, LimitMax = DnD3D.PrepareLimits( ID, InitialPlace )
			InitialPlace.posX = W.Initial.X
			InitialPlace.posY = W.Initial.Y
			InitialPlace.highPosX = W.Initial.HX
			InitialPlace.highPosY = W.Initial.HY
			W.wtMovable:SetPlacementPlain( DnD3D.NormalizePlacement( InitialPlace, LimitMin, LimitMax ) )
		end
	end
end