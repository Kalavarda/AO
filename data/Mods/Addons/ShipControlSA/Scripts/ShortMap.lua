local wts, uts, onEvent, onReact = {}, {}, {}, {}
local priorMob = 50
local SHIELDS_ANGLE = { [SHIP_SIDE_FRONT] = 0, [SHIP_SIDE_REAR] = math.pi, [SHIP_SIDE_LEFT] = math.pi/2, [SHIP_SIDE_RIGHT] = -math.pi/2 }
local ChestName = {
[L("Stabilization of Anomalous Matter")] = true,
[L("Captured Anomalous Matter")] = true,
}
																--3.1416
local TextFormat1 = ToWS("<html alignx='center' fontsize='14'><r name='value'/></html>")
local TextFormat2 = ToWS("<html alignx='center' fontsize='14'><r name='value'/></html>")
local TextFormat0 = ToWS("<html alignx='center' fontsize='14' outline='1'><tip_golden><r name='value'/></tip_golden></html>")

local clrRed = {r = 1; g = 0; b = 0; a = 1}
local clrGreen = {r = 0; g = 1; b = 0; a = 1}

local iconSize = 30

local ShipPlatePlaceX, ShipPlatePlaceY

---------------------------------------------------------------
local addon_name, toWString, container = common.GetAddonName(), userMods.ToWString

local getContainer = function()

    local chatLog = stateMainForm:GetChildUnchecked( 'ChatLog', false )    
    local area = chatLog and chatLog:GetChildUnchecked( 'Area', false )
    
    if area then
        local panel, panelNumber
        for _, widget in pairs( area:GetNamedChildren() ) do
            if widget:IsVisibleEx() then
                local widgetNumber = tonumber( string.sub( widget:GetName(), -2 ) )
                if panelNumber then
                    if widgetNumber < panelNumber then
                        panel, panelNumber = widget, widgetNumber
                    end
                else
                panel, panelNumber = widget, widgetNumber
                end
            end
		end
    return panel and panel:GetChildUnchecked( 'Container', false )
    end

end

function outputChatBox( text )

    if text then
        if not ( container and container:IsValid() and container:IsVisibleEx() ) then
            container = getContainer()
        end
        if container then
            local from, to = string.find( text, '#%x%x%x%x%x%x' )
            while from and to do
                text = string.format( '%s<html color="0xff%s" fontsize="14">%s</html>', string.sub( text, 1, from - 1 ), string.sub( text, from + 1, to ), string.sub( text, to + 1 ) )
                from, to = string.find( text, '#%x%x%x%x%x%x' )
            end
            local valuedText, time = common.CreateValuedText(), common.GetLocalDateTime()
																							--addon_name,
            valuedText:SetFormat( toWString( string.format( '<body shadow="1">%s%s</body>', '',text ) ) )
            if container:GetElementCount() >= 100 then
                container:PopBack()
            end
            container:PushFrontValuedText( valuedText )
        end
    end

end

--------------------------------------------------------------------------

local function sm_Pos( relatX, relatY, dR )
	if false then
		local sign = 1
		if math.abs(relatX/relatY) > math.abs(ShipPlatePlaceX/ShipPlatePlaceY) then
			if relatX < 0 then sign = -1 end
			return dR * sign*(ShipPlatePlaceX-0), dR * (ShipPlatePlaceY+30) * relatY
		else
			if relatY < 0 then sign = -1 end
			return dR * (ShipPlatePlaceX+70) * relatX, dR * sign*(ShipPlatePlaceY+0)
		end
	else
		return ShipPlatePlaceX*relatX*dR, ShipPlatePlaceY*relatY*dR
	
	end
end

local function calcRadius( dist )
	local rr = dist^get_PS("RadarLg") / get_PS("RadarScale")
	local rMax = get_MapRadius() - 30
	return rr > rMax and rMax or rr
end

local function calcPosition( uInfo )
	local shipID = getMyShipID()
	local avatarPos = shipID and object.IsExist( shipID ) and transport.GetPosition( shipID )
	if not avatarPos then return end
	--- .position - для стационарных объектов - островов, ТП, аномалий
	--- .GetPos() - для передвигающихся
	local pos = uInfo.position or object.IsExist( uInfo.id ) and uInfo.GetPos( uInfo.id )
	if not pos then return end

	--exObj( FromWS(uInfo.name), pos )

	local angle = - transport.GetDirection( shipID ) + math.pi

	local dX = pos.posX - avatarPos.posX
	local dY = pos.posY - avatarPos.posY

	local dist = math.sqrt(dX*dX + dY*dY) + 0.01

	local cos = math.cos(angle)
	local sin = math.sin(angle)

	local x = dX * sin + dY * cos
	local y = dX * cos - dY * sin

	local relatX = 1 / dist * x
	local relatY = 1 / dist * y
	if uInfo.GetDir then
		angle = angle + ( uInfo.GetDir( uInfo.id ) - math.pi )
	end

	if pos.posZ then
		uInfo.deltaZ = pos.posZ - avatarPos.posZ
	end

	uInfo.dist = dist
	return dist, relatX, relatY, angle

end

local function getDistNum( dist )
	-- сделаем округления чтобы цифра менялась не часто
	local d = math.ceil ( dist / 20 ) * 20
	--- тут сделаем цифры округления
	for i, v in pairs({ 250, 450, 600, 750, 800, 1150, 1300 }) do
		if math.ceil ( dist / 5 - 5 ) * 5 == v then d = v break end
	end
	return math.ceil(d)
end

local function set_AGGRO( uInfo )
	if not uInfo or not object.IsExist( uInfo.id ) or not uInfo.image then return end

	local aggro
	if astralUnit.HasAggro then 
		aggro = astralUnit.HasAggro( uInfo.id )
	elseif astralUnit.GetTarget then
		aggro = astralUnit.GetTarget( id )
	else
	end
	uInfo.aggro = aggro
	uInfo.wHP:GetParent():Show( aggro and true or false )
	
	if aggro then
		uInfo.wt:SetFade( 1 )
		uInfo.wt:SetPriority( priorMob + 10 )
		--wtSetPlace( uInfo.wt, { sizeX = iconSize*1.5, sizeY = iconSize*1.5} )
		--uInfo.wHP_sizeX = iconSize*1.5
		wtSetPlace( uInfo.wHP, { sizeY = 8 } )
	else
		uInfo.wt:SetFade( 0.7 )
		uInfo.wt:SetPriority( priorMob - 10 )
		--wtSetPlace( uInfo.wt, { sizeX = iconSize, sizeY = iconSize} )
		--uInfo.wHP_sizeX = iconSize
		wtSetPlace( uInfo.wHP, { sizeY = 6 } )
	end
end

local function set_HP_unit( uInfo )
	if not uInfo or not object.IsExist( uInfo.id ) then return end

	local Percentage
	if astralUnit.GetHealthLevel then Percentage = astralUnit.GetHealthLevel( uInfo.id )
	elseif object.GetHealthInfo then Percentage = object.GetHealthInfo( uInfo.id )
	end
	if not Percentage then return end
	if type(Percentage) == "table" then Percentage = Percentage.valuePercents end
	wtSetPlace( uInfo.wHP, { highPosX=(1-Percentage/100)*uInfo.wHP_sizeX} )
	uInfo.hpp = Percentage
end

local function getRelationColor( uInfo )
	local ka, kb = 1.2, 0.6
	if uInfo.enemy then
		return {r=ka; g=kb; b=kb, a=1 }, {r=0.8; g=0.3; b=0.3, a=1 }
	elseif uInfo.friend then
		-- почемуто наши корабли все НЕ ДРУГ
		return {r=kb; g=ka; b=kb, a=1 }, {r=0.4; g=0.8; b=0.5, a=1 }
	else
		return {r=kb; g=kb; b=ka, a=1 }, {r=0.2; g=0.5; b=0.8, a=1 }
	end
end

local function set_HP_ship( uInfo )

	local Percentage = transport_GetHealth( uInfo.id )
	if not Percentage then return end

	local clr = getRelationColor( uInfo )
	local tst, koef = 0, 0.01
	
	clr.r = clr.r - koef*( 100 - Percentage + tst )/clr.r
	clr.g = clr.g - koef*( 100 - Percentage + tst )/clr.g
	clr.b = clr.b - koef*( 100 - Percentage + tst )/clr.b

	if uInfo.id == getMyShipID() then
		clr.g = clr.g
	else
	end

	for k,v in pairs(clr) do
		if v > 1 then v = 1
		elseif v < 0 then v = 0
		end
	end

	uInfo.wt:SetBackgroundColor( clr )

	if uInfo.wHP then wtSetPlace( uInfo.wHP, { highPosX=(1-Percentage/100)*uInfo.wHP_sizeX} ) end

	uInfo.hpp = Percentage
	local shipInfo = transport.GetShipInfo( uInfo.id )
	--Chat("ss")
	if shipInfo.gearScore ~= 0 then 
		local wtEngine, EngineSize = uInfo.wEP, uInfo.wHP_sizeX
		if wtEngine and EngineSize then
			local EN = transport.GetEnergy( uInfo.id )
		if EN then
			local heat = EN.value/EN.limit * 100

			local clr, clrB = getEngineColors( heat )
			wtEngine:SetBackgroundColor( clr )
			wtEngine:GetParent():SetBackgroundColor( clrB )
			if heat < 50 then
				wtSetPlace( wtEngine, { alignX = 1, sizeX = EngineSize * heat / 100} )
			else
			if heat < 95 then
				wtSetPlace( wtEngine, { alignX = 1, sizeX = EngineSize * heat / 100} )
			else
				wtSetPlace( wtEngine, { alignX = 0, sizeX = ( heat - 100 )/100 * EngineSize * 2} )
			end
			end
		end

		end
	end
end

--local function getShieldColor( hp )
--end
local function showShield( uInfo, side )

	local shld = uInfo and transport.GetShieldStrength( uInfo.id, side )
	if not shld then return end
	local hp = shld.value / shld.maxValue * 100
	local w = uInfo.wShld[side]
	if w and hp >= 0 then 
		local clr = getShieldColor(hp)
		clr.a = 1
		--clr.b = clr.b + 0.2
		--clr.r = clr.r + 0.2
		--clr.g = clr.g + 0.2
		for k, v in pairs(clr) do
			if v > 1 then v = 1 end
		end
		w:SetBackgroundColor( clr )
	end
end

local function UpdChest( uInfo )
	if not uInfo or not object.IsExist( uInfo.id ) then return end
	for i, inf in pairs(uInfo.BuffInfo) do
		uInfo.BuffInfo[i].stackCount:SetVal("value", tostring(uInfo.BuffInfo[i].st) )
		uInfo.BuffInfo[i].remainingMs:SetVal("value", tostring(uInfo.BuffInfo[i].rm - 1) )
	end
end

local function show_deltaZ( uInfo )
	
	
	local dZNum = uInfo.deltaZ
	local wTxt = uInfo.w_dZTxt
	if dZNum and wTxt then
		local frmt
		dZNum = math.ceil(dZNum)
		if not uInfo.deltaZt or uInfo.deltaZt ~= dZNum then
			uInfo.deltaZt = dZNum
			--and math.abs(dZNum) > 2
			if uInfo.dist < 2000 and math.abs(dZNum) > 2 then 
				--wTxt:SetVal("value", ToWS(""..dZNum))
				if dZNum > 0 and get_PS("ColoredFontSwitch") then
					setText(wTxt, ""..dZNum, "ColorGreen", "left", 16, "1", "1")	
				elseif dZNum < 0 and get_PS("ColoredFontSwitch") then
					setText(wTxt, ""..math.abs(dZNum), "ColorRed", "left", 16, "1", "1")	
				else
					setText(wTxt, ""..dZNum, "ColorWhite", "left", 16, "1", "1")	
				end
				wTxt:Show(true)
			else
				wTxt:Show(false)
			end
		end
	end
end
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

local function del_Obj(id, uInfoIn)
	local uInfo = uInfoIn or uts[id]
	if uInfo then
		--LogToChat("delete:"..FromWS(uts[id].name)) LogInfo("delete:"..FromWS(uts[id].name))
		uInfo.wt:DestroyWidget()

		uts[id] = nil --- тут обязательно именно элемент массива нулировать
	end
end

local function show_Obj( uInfo )
	--LogInfo(uInfo)
	
	local dist, relatX, relatY, angle = calcPosition( uInfo )
	local w = uInfo.wt
	if dist then
		if uInfo.type == "ENUM_HubScanInfoObjectType_Mob" then
			--- если это скрытый моб то можно его очистиь
			if dist < 400 then
				clear_Hidden( uInfo.id )
				return
			end
		end
		local rr
		if IsRadarMode() then
			rr = calcRadius( dist )
			wtSetPlace( w, { posX = rr * relatX, posY = rr * relatY, sizeX = iconSize*uInfo.size, sizeY = iconSize*uInfo.size } )
		else
			local X, Y = sm_Pos( relatX, relatY, uInfo.dRad )
			local size = dist<1000 and (1000+500)/(dist+500) or 1
			wtSetPlace( w, { posX = X, posY = Y, sizeX = size * iconSize *uInfo.size, sizeY = size * iconSize*uInfo.size } )
			
		end
		--wtSetPlace( w, { posX = rr * relatX, posY = rr * relatY} )
		show_deltaZ( uInfo )
	else
		---del_Obj( uInfo.id )
	end
end

local function show_Ship( uInfo )
	local dist, relatX, relatY, angle = calcPosition( uInfo )

	if not dist then return end
	
	local w = uInfo.wt

	for side, set in pairs(SHIELDS_ANGLE) do
		uInfo.wShld[side]:Rotate( set + angle )
	end

	if dist > 2 then --- наш корабль тут не показывать?
		local rr
		if IsRadarMode() then
			rr = calcRadius( dist )
			wtSetPlace( w, { posX = rr * relatX, posY = rr * relatY, sizeX = iconSize*uInfo.size, sizeY = iconSize*uInfo.size } )
			uInfo.wHP_sizeX = iconSize*uInfo.size

		else
			local X, Y = sm_Pos( relatX, relatY, uInfo.dRad )
			local size = dist<1000 and (1000+500)/(dist+500) or 1
			wtSetPlace( w, { posX = X, posY = Y, sizeX = size * iconSize *uInfo.size, sizeY = size * iconSize*uInfo.size } )
			uInfo.wHP_sizeX = size * iconSize*uInfo.size

		end
		local wTxt = uInfo.wTxtDist
		if wTxt then
			local dNum = getDistNum(dist)
			if not uInfo.distNum or uInfo.distNum ~= dNum then
				if dist < 2000 then 
					wTxt:SetVal("value", ToWS(""..dNum))
					wTxt:Show(true)
					uInfo.distNum = dNum
				else
					wTxt:Show(false)
				end
			end
		end
		--wtSetPlace( w, { posX = rr * relatX, posY = rr * relatY} )
		w:Rotate( angle )
		show_deltaZ( uInfo )
	else
		--del_Obj( uInfo.id )
	end
end

local function show_Unit( uInfo )
	if IsShortMode() then return end
	local dist, relatX, relatY, angle = calcPosition( uInfo )
	if dist then
		local w = uInfo.wt
		local rr
		local isRdr = IsRadarMode()
		if uInfo.aggro or isRdr or dist < (get_PS("DistMobs1") or 1300) then
			if isRdr then
				rr = calcRadius( dist )
				wtSetPlace( w, { posX = (rr + ((isRdr or uInfo.aggro) and -10 or 15)) * relatX, 
					posY = (rr + ((isRdr or uInfo.aggro) and -10 or 15)) * relatY, 
					sizeX = iconSize*uInfo.size, sizeY = iconSize*uInfo.size,
					} )
				uInfo.wHP_sizeX = iconSize*uInfo.size
			else
				local X, Y = sm_Pos( relatX, relatY, uInfo.dRad*(uInfo.aggro and 1 or 0.95) )
				local size = dist<1000 and (1000+700)/(dist+700) or 1
				wtSetPlace( w, { posX = X, posY = Y, sizeX = size * iconSize *uInfo.size, sizeY = size * iconSize*uInfo.size } )
				uInfo.wHP_sizeX = size* iconSize*uInfo.size
			end
			if not w:IsVisible() then w:Show( true ) end
			local wTxt = uInfo.wTxt
			if wTxt then
				local dNum = getDistNum(dist)
				local frmt
				if not uInfo.distNum or uInfo.distNum ~= dNum then
					if dist < 2000 then 
						if uInfo.aggro then frmt = ToWS("<html fontname='AllodsSystem' fontsize='12' shadow='1' alignx='center' aligny='meddle'><r name='value'/></html>")
						else frmt = ToWS("<html fontname='AllodsSystem' fontsize='12' shadow='1' alignx='center' aligny='meddle' outline='1'><r name='value'/></html>")
						end
						
						wTxt:SetFormat(frmt)
						wTxt:SetVal("value", ToWS(""..dNum))
						wTxt:Show(true)
						uInfo.distNum = dNum
					else
						wTxt:Show(false)
					end
				end
			end
		else
			if w:IsVisible() then w:Show( false ) end
		end

	else
		--del_Obj( uInfo.id )
	end
end

local function add_Edge( id, angle, hubR )
	local uInfo = uts[id]
	if not uInfo then
		uInfo = { id = id, name = ToWS(L("EDGE")), description = ToWS(L("HUB Edge Point №")..id),
			position = {}, image = common.GetAddonRelatedTexture( "ScoresContainerItemOnline" ), --, "SlotHighlight" ),
			size = 0.5, dRad = 1.5,
			}
		local w = WCD( dsc.PanelER, id.."", Get_Panel(), { sizeX = iconSize*uInfo.size, sizeY = iconSize*uInfo.size, alignX=2, alignY=2}, true )
		w:SetPriority( 0 ) --priorMob - 50)
		if uInfo.image then
			w:SetBackgroundTexture( uInfo.image )
			w:SetBackgroundColor( { a=1, r=0.7, g=0.2, b=0.1 } )
		end
		uInfo.Show = show_Obj
		uInfo.wt = w
		uts[id] = uInfo
	end
	uInfo.position.posX = hubR * math.sin( angle )
	uInfo.position.posY = hubR * math.cos( angle )
	show_Obj( uInfo )
end

local function getPOIs( uInfo )
	--LogToChat( uInfo.name )
	local pois, str = astral.GetSectorPOIs( uInfo.sectorId )
	for i, poiId in pairs(pois) do
		local poiInfo = astral.GetPOIInfo( poiId )
		str = (str and str.."; " or "").. FromWS(poiInfo.name)
	end
end


local function add_Obj(id)

	local uInfo = uts[id]
	if uInfo then
		--- оказывается когда падаешь с корабля ID объектов не изменяются но при появлении после смерти на корабле
		--- присылает событие оо появлении опять!
		local info = astral.GetObjectInfo( id )
		for k, v in pairs(info) do
			uInfo[k] = v
		end
		uInfo.wt:Enable( uInfo.isEnabled )
		uInfo.Show( uInfo )
		return
	end

	local uInfo = astral.GetObjectInfo( id )
	uInfo["type"] = "OBJ"
	uInfo.Show = show_Obj
	uInfo.size = 1
	uInfo.dRad = 1.5
	uts[id] = uInfo
	local w = WCD( dsc.PanelER, id.."", Get_Panel(), { sizeX = iconSize*uInfo.size, sizeY = iconSize*uInfo.size, alignX=2, alignY=2}, false )
	w:SetPriority( priorMob + 50)
	if uInfo.image then w:SetBackgroundTexture( uInfo.image ) end
	uInfo.wt = w

	local wTxt = WCD( dsc.Text, nil, w, { alignX = 3, alignY=3, sizeY=20 }, true )
	wTxt:SetEllipsis( false )
	uInfo.w_dZTxt = wTxt

	--LogInfo( uInfo.name)
	if uInfo.sectorId then
		--LogInfo( "uInfo.sectorId ")
		uInfo.getPOIs = getPOIs

	end
	
	show_Obj( uInfo )
	w:Enable( uInfo.isEnabled )
	w:Show( true )

	end

--- будем запоминать невидимок вообще пока хаб не прошли
local hiddensObj = {}
function clear_Hidden( id )
	if not uts[id] then return end
	uts[id].wt:DestroyWidget()
	uts[id] = nil

end
local function clear_Hiddens()
	--exObj("hiddensObj", hiddensObj )
--	LogToChat("clear hub")
	--- очистим все невидимые объекты которые нашли в хабе сканером
	for id,_ in pairs(hiddensObj) do
	--	LogToChat("delete object")
		clear_Hidden( id )
	end
	hiddensObj = {}
end

local function add_Hidden( uInfo )

	uts[uInfo.id] = uInfo
	hiddensObj[ uInfo.id ] = 1
	uInfo.Show = show_Obj
	uInfo.size = 1
	uInfo.dRad = 1.5
	uInfo.description = ToWS(L("scanned hidden object"))
	local w = WCD( dsc.PanelER, uInfo.id, Get_Panel(), { sizeX = iconSize*uInfo.size, sizeY = iconSize*uInfo.size, alignX=2, alignY=2}, false )
	w:SetPriority( priorMob + 10)
	if uInfo.type == "ENUM_HubScanInfoObjectType_Mob" then
		uInfo.image = common.GetAddonRelatedTexture("Monster")
		uInfo.name = ToWS(L("monster"))
		--LogToChat(L("find hidden Monsters"))
	elseif  uInfo.type == "ENUM_HubScanInfoObjectType_Ship" then
		uInfo.image = common.GetAddonRelatedTexture("ShipSymbol")
		uInfo.name = ToWS(L("ship"))
		--LogToChat(L("find hidden Ship")..": "..uInfo.name)
	end
	if uInfo.image then
		w:SetBackgroundTexture( uInfo.image ) 
		w:SetBackgroundColor( { r = 0.2, g=0.2, b=0.2, a=1 } )
	end
	uInfo.wt = w

	local wTxt = WCD( dsc.Text, nil, w, { alignX = 3, alignY=3, sizeY=20 }, true )
	wTxt:SetEllipsis( false )
	uInfo.w_dZTxt = wTxt

	uInfo.Show( uInfo )
	w:Show( true )
	--exObj( "hidden uInfo", uInfo)

end

function SetImageMyShip( id, uInfoIn )
	local uInfo = uInfoIn or uts[id]
	if not uInfo then return end
	local w = uInfo.wt
	local wtRP = Get_RadarPlate()
	wtRP:AddChild( w )
	uInfo.size = 5/3
	wtSetPlace( w, { sizeX = iconSize*uInfo.size, sizeY = iconSize*uInfo.size } )
	w:SetBackgroundColor( { r = 0.1, g=0.5, b=0.2, a=1 } )
end

function add_Ship(id)
	if uts[id] then
		--- оказывается когда падаешь с корабля ID объектов не изменяются но при появлении после смерти на корабле
		--- присылает событие оо появлении опять!
		return
	end
---------------------------------------------------------------------
	if get_PS("TogetherMode") and id == getMyShipID() then 
		return
	end

	if id ~= getMyShipID() then 

		local GSShip =  FromWS(common.FormatFloat(transport.GetShipInfo( id ).gearScore,"%.2f"))
		if transport.GetShipInfo( id ).gearScore ~= 0 then 
			if object.IsFriend(id) then outputChatBox( "#20B2AA "..L("Find Ship: ").."#32CD32"..FromWS(object.GetName( id )).."#20B2AA ["..GSShip.."] Владелец: ".."#32CD32"..FromWS(transport.GetShipInfo(id).ownerName))
				else outputChatBox( "#20B2AA "..L("Find Ship: ").."#FF4040"..FromWS(object.GetName( id )).."#20B2AA ["..GSShip.."] Владелец: ".."#FF4040"..FromWS(transport.GetShipInfo(id).ownerName))
			end
		end
	end
---------------------------------------------------------------------------------------------------------	
	local uInfo = { id = id, type = "SHIP", name = object.GetName( id ), GetPos = transport.GetPosition, GetDir = transport.GetDirection,
		Show = show_Ship, set_AGGRO = nil, set_HP = set_HP_ship,
		image = common.GetAddonRelatedTexture( "ShipSymbol" ),
		size = 5/3, dRad = 1.5,
		}  --astral.GetObjectInfo( id )
	
	local sizeX = iconSize*uInfo.size

	local plc = { sizeX = sizeX, sizeY = sizeX, alignX=2, alignY=2}
	local w = WCD( dsc.PanelER, id.."", Get_Panel(), plc, false )
	w:SetPriority( priorMob + 40)
	uInfo.wt = w

	if object.IsEnemy then
		uInfo.enemy = object.IsEnemy( id )
		uInfo.friend = object.IsFriend( id )
	end
	uts[id] = uInfo


	local clr, clrHPbar = getRelationColor( uInfo )
	local wbar = WCD( dsc.BarHP, nil, w, { alignX = 3, alignY=0, sizeY=8 }, true )
	wbar:SetBackgroundColor( {r=clrHPbar.r-0.6; g=clrHPbar.g-0.6; b=clrHPbar.b-0.6, a=1 } )
	uInfo.wHP = W("dscBar", wbar )
	uInfo.wHP:SetBackgroundColor( clrHPbar ) ---{r=.9; g=0.2; b=0, a=1 } )
	uInfo.wHP:Show( true )
	uInfo.wHP_sizeX = sizeX

	local wbar = WCD( dsc.BarHP, nil, w, { alignX = 3, alignY=1, sizeY=8 }, true )
	wbar:SetBackgroundColor( {r=0.0; g=0.2; b=0.1, a=1 } )
	uInfo.wEP = W("dscBar", wbar )
	uInfo.wEP:SetBackgroundColor( {r=.9; g=0.2; b=0, a=1 } )
	uInfo.wEP:Show( true )
	uInfo.wEP_sizeX = sizeX

	if uInfo.image then
		w:SetBackgroundTexture( uInfo.image )
	end

	local wCh
	uInfo.wShld = {}
	for side, angle in pairs(SHIELDS_ANGLE) do
		wCh = WCD( dsc.PanelEmpty, "shldSide_"..side, w, { alignX = 3, alignY = 3 }, true )
		wCh:SetBackgroundTexture( common.GetAddonRelatedTexture( "ShipPlateShieldArc" ) )
		uInfo.wShld[side] = wCh
		showShield( uInfo, side )
	end

	local wTxt = WCD( dsc.Text, nil, w, { alignX = 1, alignY = 0, sizeX = 40, sizeY = 20 }, true )
	wTxt:SetEllipsis( false )
	--local frmt = ToWS("<html fontname='AllodsSystem' fontsize='14' shadow='1' alignx='right' aligny='top'><r name='value'/></html>")
	--wTxt:SetFormat(frmt)
	uInfo.w_dZTxt = wTxt

	wTxt = WCD( dsc.Text, nil, w, { alignX = 0, alignY = 1, sizeX = 40, sizeY = 16 }, true )
	wTxt:SetEllipsis( false )
	local frmt = ToWS("<html fontname='AllodsSystem' fontsize='14' shadow='1' alignx='left' aligny='bottom'><r name='value'/></html>")
	wTxt:SetFormat(frmt)
	uInfo.wTxtDist = wTxt

	uInfo.set_HP( uInfo )
	uInfo.Show( uInfo )
	uInfo.BuffInfo = {}
--[[	for i, buffid in pairs(object.GetBuffs(id)) do
		if ChestName[FromWS(object.GetBuffsInfo(buffid).name)] then
			local icon = WCD( dsc.PanelEmpty, "icon"..i, w, {alignX = 0, posX = 0 + 22*i, sizeX = 20, sizeY = 20, posY = 5}, true )
			local stackCount = WCD( dsc.Text, "stackCount"..i, icon, { alignX = 1, alignY = 0, sizeX = 20, sizeY = 20 }, true )
			local remainingMs = WCD( dsc.Text, "remainingMs"..i, icon, { alignX = 0, alignY = 0, sizeX = 20, sizeY = 20 }, true )
			local st = object.GetBuffsInfo(buffid).stackCount
			local rm = math.ceil(object.GetBuffsInfo(buffid).remainingMs/1000)
			icon:SetBackgroundTexture(object.GetBuffsInfo(buffid).texture)
		--	stackCount:SetVal("value", tostring(object.GetBuffsInfo(buffid).stackCount) )
		--	remainingMs:SetVal("value", tostring(math.ceil(object.GetBuffsInfo(buffid).remainingMs/1000)) )
			uInfo.BuffInfo[i] = {icon = icon, stackCount = stackCount, remainingMs = remainingMs}
			UpdChest(id, uInfo)
		end
	end]]

	w:Show( true )
	if id == getMyShipID() then
		SetImageMyShip( id, uInfo )
	end
end

local imageTemp
--- Защитные турели - тут добавляются - тоесть это ЮНИТ
local function add_Unit(id)
	if uts[id] then
		--- оказывается когда падаешь с корабля ID объектов не изменяются но при появлении после смерти на корабле
		--- присылает событие оо появлении опять!
		return
	end

	local uInfo = { id = id, type = "UNIT", name = object.GetName( id ), GetPos = object.GetPos,
		Show = show_Unit, set_AGGRO = set_AGGRO, set_HP = set_HP_unit,
		image = astralUnit.GetImage( id ), level = astralUnit.GetLevel( id ),
		size = 1, dRad = 1.5,
	}

	uts[id] = uInfo

	local sizeX = iconSize*uInfo.size
	local w = WCD( dsc.PanelER, id.."", Get_Panel(), { sizeX = sizeX, sizeY = sizeX, alignX=2, alignY=2}, false )
	w:SetPriority( priorMob )
	uInfo.wt = w

	local wbar = WCD( dsc.BarHP, nil, w, { alignX = 3, alignY=0, sizeY=8 }, true )
	wbar:SetBackgroundColor( {r=.2; g=0.0; b=0, a=1 } )
	uInfo.wHP = W("dscBar", wbar )
	uInfo.wHP:SetBackgroundColor( {r=.9; g=0.2; b=0, a=1 } )
	uInfo.wHP:Show( true )
	uInfo.wHP_sizeX = sizeX

	if uInfo.image then
		--if not imageTemp then imageTemp = uInfo.image end
		w:SetBackgroundTexture( uInfo.image )
	else
		w:SetBackgroundTexture( common.GetAddonRelatedTexture("Monster") )
		--w:SetBackgroundColor( {r=.0; g=0.6; b=0.7, a=1 } )
	end
	local wTxt = WCD( dsc.Text, nil, w, { alignX = 3, alignY=1, sizeY=16 }, true )
	wTxt:SetEllipsis( false )
	uInfo.wTxt = wTxt

	uInfo.set_AGGRO( uInfo )
	uInfo.set_HP( uInfo )
	uInfo.Show( uInfo )
	--w:Show( true )
end

function repaintPos( uInfo, trPos1)

	local ShipID = getMyShipID()
	local trPos = trPos1 or ShipID and object.IsExist( ShipID ) and transport.GetPosition( getMyShipID() )
	if uInfo then
		uInfo.Show( uInfo, trPos )
	else
		for _, info in pairs(uts) do
			if info then repaintPos( info, trPos ) end
		end
		repaintScale()
	end
end



local sec1, sec2 = 45, 55
onEvent["EVENT_SECOND_TIMER"] = function ( pars )
	local myShipID = getMyShipID()
	if not myShipID or not transport.CanDrawInterface(myShipID) then return end

	for id, uInfo in pairs(uts) do
		--if uInfo then UpdChest( uInfo ) end
		if uInfo.set_AGGRO then uInfo.set_AGGRO( uInfo ) end
		if uInfo.set_HP then uInfo.set_HP( uInfo ) end
		if uInfo.hpp and uInfo.hpp == 0 and uInfo.type and uInfo.type == "UNIT" then
			--- если это ктулха и 0% то сразу удалим - корабли не удаляем
			del_Obj( id, uInfo ) 
		end
	end

end

onEvent["EVENT_ASTRAL_HUB_CHANGED"] = function ( pars )
	--- очистим все невидимые объекты которые нашли в хабе сканером
	--LogToChat("clear_Hiddens")
	clear_Hiddens()

	-- если вы в ангар залетели то не смотреть хаб
	local map = cartographer.GetCurrentMapInfo()
		if map and (map.isTerrain==true or map.isAstralIsland==true) then return end
	--if not astral.GetCurrentSector() or not astral.GetHubCenter() then return end
	local re = tonumber( get_PS("RadarEdge") )
	if re and re > 0 then
		local hubR = astral.GetHubRadius()
		--LogToChat(" hubR = " ..hubR )
		local an
		for i=0, re - 1 do
			an = 2*math.pi / re * i
			add_Edge( i, an, hubR )
		end
	end

end

onEvent["EVENT_TRANSPORT_POS_CHANGED"] = function ( pars )
	if not getMyShipID() then return end
	local id = pars.id
	if id == getMyShipID() then
		--- перерисоатьв всех
		repaintPos()
	elseif uts[id] then
		-- перерисовать его
		repaintPos(uts[id])
	end
end
onEvent["EVENT_TRANSPORT_DIRECTION_CHANGED"] = function ( pars )
	local id = pars.id
	if id == getMyShipID() then
		repaintPos()
	elseif uts[id] then
		-- перерисовать его
		repaintPos(uts[id])
	end
end

onEvent["EVENT_ASTRAL_OBJECT_DESPAWNED"] = function ( pars )
	del_Obj(pars.objectId)
end
onEvent["EVENT_ASTRAL_OBJECT_SPAWNED"] = function ( pars )
	add_Obj(pars.objectId)
end
onEvent["EVENT_ASTRAL_OBJECT_ENABLED_CHANGED"] = function ( pars )
	local id = pars.objectId
	local uInfo = uts[ id ]
	
	if not uInfo then return end
	local isEnabled = astral.GetObjectInfo( id ).isEnabled
	if uInfo.isEnabled ~= isEnabled then
		uInfo.isEnabled = isEnabled
		uInfo.wt:Enable( isEnabled )
		--LogToChat( FromWS(uInfo.name) .. _ENABLED_CHANGED)
	end
end


onEvent["EVENT_TRANSPORT_SPAWNED"] = function ( pars )
	-- сюда приходят события даже кгда мы не в астрале!
	-- exObj( "par", pars )	LogInfo( getMyShipID() )
	if not getMyShipID() then return end
	add_Ship(pars.id)
end
onEvent["EVENT_TRANSPORT_DESPAWNED"] = function ( pars )
	del_Obj(pars.id)
end

onEvent["EVENT_ASTRAL_UNIT_SPAWNED"] = function ( pars )
	if getMyShipID() then add_Unit(pars.unitId) end
end
onEvent["EVENT_ASTRAL_UNIT_DESPAWNED"] = function ( pars )
	del_Obj(pars.unitId)
end
onEvent["EVENT_ASTRAL_UNIT_HEALTH_PERCENTAGE_CHANGED"] = function ( pars )
	-- не приходят события сюда ((LogToChat("HHHC")
	set_HP( uts[pars.unitId])
end
onEvent["EVENT_ASTRAL_UNIT_POS_CHANGED"] = function ( pars )
	repaintPos(uts[pars.unitId])
end

onEvent["EVENT_ASTRAL_UNIT_AGGRO_CHANGED"] = function ( pars )
	--LogToChat("EVENT_ASTRAL_UNIT_AGGRO_CHANGED")
	--LogInfo("EVENT_ASTRAL_UNIT_AGGRO_CHANGED")
	local id = pars.id
	local uInfo = uts[id]
	if uInfo then uInfo.set_AGGRO( uInfo ) end
end



local function unitPlayerSpawned( id )
	if not unit.IsPlayer ( id ) then return end
	local shipID = unit.GetTransport( id )
	if not shipID or shipID == getMyShipID() then return end

	local shName = FromWS(object.GetName( shipID ))
	local uName = FromWS(object.GetName( id ))
	if not uts[shipID].players then uts[shipID].players = {} end
	local found
	for i, plName in pairs(uts[shipID].players) do
		if plName == uName then found = true break end
	end
	if not found then
		table.insert( uts[shipID].players, uName )
			if object.IsEnemy(shipID) then outputChatBox( " #FF4040"..uName.."#9BCD9B"..L(" on ship: ").."#FF4040"..shName )
				else outputChatBox( " #32CD32"..uName.."#9BCD9B"..L(" on ship: ").."#32CD32"..shName)
			end
	--LogToChat( uName..L(" on ship: ").. shName )
	end

end

onEvent["EVENT_UNITS_CHANGED"] = function ( pars )
	if not getMyShipID() then return end
	for _, id in pairs(pars.spawned) do
		--onSpawnedUnit( { unitId = id } )
		unitPlayerSpawned( id )
	end
	for _, id in pairs(pars.despawned) do
		--onDespawnedPlayer( { unitId = id } )
	end
end


onEvent["EVENT_TRANSPORT_SHIELD_CHANGED"] = function ( pars )
	--LogToChat("EVENT_TRANSPORT_SHIELD_CHANGED")
	--exObj("EVENT_TRANSPORT_SHIELD_CHANGED", pars)
	--LogInfo("ship: ", object.GetName( pars.id ) )
	showShield( uts[pars.id], pars.side )
end


-- выдает его и при смене хаба и при запуске скана невидимок на сканере и при окончании скана
onEvent["EVENT_SCANNED_HUB_OBJECTS_CHANGED"] = function ( pars )
-- Возвращает список таблиц с информацией об объектах (астрольные юниты, корабли), 
-- невидимых с корабля, но насканеных в хабе визором корабля, на котором находится главный игрок.
	local hiddens = astral.GetScannedObjects()
	--exObj("hidden", hiddens )
--[[
  type: string (enum "ENUM_HubScanInfoObjectType...") - тип объекта
"ENUM_HubScanInfoObjectType_Mob"
"ENUM_HubScanInfoObjectType_Ship"
  position: GamePosition - позиция объекта в хабе
  durationMs: number (integer) - время жизни объекта в милисекундах
  elapsedMs: number (integer) - сколько миллисекунд назад произошло сканирование данного объекта.
]]

	--- очистим все невидимые объекты которые нашли в хабе сканером
	clear_Hiddens()

	local key
	for i, uInfo in pairs(hiddens) do
		key = "h"..i
		uInfo.id = key
		add_Hidden( uInfo )
	end
end

local function GetScanerHubInfo()

-- если на ВИЗОРЕ стою:
-- Error: addon ShipControl: Game::LuaDeviceGetScanerHubInfo: cannot get scanner device, details: int __cdecl Game::LuaDeviceGetScanerHubInfo(struct lua_State *)
-- а если на сканере стою:
--Error: addon ShipControl: Game::LuaDeviceGetScanerHubInfo: active device is not scanner, details: int __cdecl Game::LuaDeviceGetScanerHubInfo(struct lua_State *)

	device.SetScanerDestinationDevice()
	local hInfo = device.GetScanerHubInfo()
	exObj2("GetScanerHubInfo", hInfo )
	
	if device.IsScanerScanning() then
		exObj2("GetScanerHubInfo2", hInfo )
	end
end

local usedDevice
onEvent._EVENT_AVATAR_USED_OBJECT_CHANGED =  function()   ---EVENT_AVATAR_USED_OBJECT_CHANGED
	local deviceId = avatar.GetActiveUsableDevice()
	local info = avatar.GetUsableDeviceInfo(deviceId) --avatar.GetActiveUsableDeviceInfo()
	local newDev = info and device.GetUsableDeviceType(info.id)
	--exObj("dev type."..newDev,info)

	if newDev then
		if newDev == USDEV_NAVIGATOR then --- это ВИЗОР
			--LogInfo("USDEV_NAVIGATOR")
			GetScanerHubInfo()
		elseif newDev == USDEV_SCANER then
			--LogInfo("USDEV_SCANER")
			GetScanerHubInfo()
		--- тут визор вешает свои 2Д метки! поэтому при выходе из него они не пашут - может задержку включать?
		elseif newDev == USDEV_CANNON or newDev == USDEV_BEAM_CANNON then
			--- если это пушки то просто перерисуем
		end
	else
		--- мы вышли из устройства - перерисуем обычно метки
		if usedDevice == USDEV_NAVIGATOR then
			--- мы вышли с навигатора
		--else
		end
	end
	usedDevice = newDev
end

onEvent["EVENT_NAVIGATION_SCANER_HUB_PVE_INFO"] = function ( pars )
	exObj2("PVE_INFO", device.GetScanerPvEInfo())
end
onEvent["EVENT_NAVIGATION_SCANER_HUB_PVP_INFO"] = function ( pars )
	exObj2("PVP_INFO", device.GetScanerPvPInfo())
end
onEvent["EVENT_NAVIGATION_SCANER_HUB_TRAILS_INFO"] = function ( pars )
	for i, trailId in pairs(device.GetScanerTrails()) do
		local trailInfo = device.GetScanerTrailInfo( trailId )
		exObj2("trailInfo", trailInfo)
		if false then
			device.SetScanerDestinationTrail( trailId )
		end
	end
end


onEvent["EVENT_NAVIGATOR_TARGET_CHESTS_CHANGED"] = function ( pars )
	local targetId = device.NavigatorGetTarget()
	if not targetId or object.IsAstralUnit(targetId) then return end
	local transName = FromWS(object.GetName( targetId ))
	local transChests = device.GetNavigatorTargetChests() or {}
	if table.getn( transChests ) < 1 then
		uts[targetId].transChests = nil
		return
	end
	
	for i, chestName in pairs(transChests) do
		transChests[ i ] = FromWS( chestName )
	end
	local str = table.concat (transChests, ", ")
	uts[targetId].transChests = str
	outputChatBox( transName.." -> "..str  )
	LogToChat(transName.." -> "..str )
end

onEvent["EVENT_TRANSPORT_OBSERVING_STARTED"] = function ( pars )
	local deviceId = avatar.GetActiveUsableDevice()
	if deviceId ~= nil then
	local info = avatar.GetUsableDeviceInfo(deviceId)
	--if info then
	local newDev = info and device.GetUsableDeviceType(info.id)
		if newDev then
			if newDev ~= USDEV_NAVIGATOR then return 
				else onEvent.EVENT_NAVIGATOR_TARGET_CHESTS_CHANGED( pars )
			end
		end	
	end
	--end
end

function GetTimestamp()
	return common.GetMsFromDateTime( common.GetLocalDateTime() )
end


-------------- REACTIONS --------------
---------------------------------------
local m_lastOverTime = 0
local m_clickCnt = 1
local m_lastID = 0

function MouseDoubleClick(anInfo)
	local deviceId = avatar.GetActiveUsableDevice()
	if deviceId and device.GetUsableDeviceType(deviceId) == USDEV_NAVIGATOR then
		if anInfo[ "type" ] == "SHIP" or anInfo[ "type" ] == "UNIT" then
			local currTarget = device.NavigatorGetTarget()
			if currTarget == anInfo.id then
				--device.NavigatorSetTarget( nil )
			else
				device.NavigatorSetTarget( anInfo.id )
			end
		end
	end
end 

onReact[ "mouse_over" ] = function( reaction )
	if not getMyShipID() then return end

	local id = tonumber ( reaction.widget:GetName() )
	--LogToChat( " id:"..id.." name:"..reaction.widget:GetName() )
	local uInfo = id and uts[id]
	if not uInfo then return end
	show_tip( { obj = uInfo }, reaction.active, reaction.widget )
	
	if get_PS("EnableSelectDblClk") and not reaction.active then
		local delta = GetTimestamp() - m_lastOverTime
		
		if delta < 200 and m_lastID == id then
			m_clickCnt = m_clickCnt + 1
		else
			m_clickCnt = 1
		end
		
		m_lastOverTime = GetTimestamp()
		m_lastID = id
		
		if m_clickCnt >= 2 then
			MouseDoubleClick(uInfo)
			m_clickCnt = 1
		end
	end
end
onReact[ "mouse_double_click" ] = function( reaction )
	--LogToChat("mouse_double_click")

end
------------- init functions -------------
function ShortMap_ShowAll()
	for _, id in pairs(astral.GetObjects()) do
		add_Obj( id )
	end
	for _, id in pairs(avatar.GetTransportList()) do
		--if getMyShipID() and id ~= getMyShipID() then add_Ship(id) end
		add_Ship( id ) 
	end
	for _, id in pairs(astral.GetUnits()) do
		add_Unit( id )
	end
	if avatar.GetUnitList then
		for _, id in pairs(avatar.GetUnitList()) do
			unitPlayerSpawned( id )
		end
	end
	onEvent.EVENT_ASTRAL_HUB_CHANGED()
end

function ShortMap_Init( myShipID )

	RegisterEventHandlers( onEvent )
	RegisterReactionHandlers( onReact )

	local p = get_PS("ShipPlatePlace")
	ShipPlatePlaceX = p.sizeX/2
	ShipPlatePlaceY = p.sizeY/2

end

--LogInfo("PS.ShipPlatePlace",PS)
