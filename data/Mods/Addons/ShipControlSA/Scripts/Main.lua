--- ID корабля всегда один после вызова в ангаре - myShipID
local posDebug = false
local probeKey = '3:'..USDEV_SHIELD..':1'

local riseERR
local myID, myShipID
local ChestsCounter = {}
local ControlSlots, wtEngine, wtHull, wtShields, wtInsight, wtHVelocity, wtShortHP, wtShortHPtxt, wtShortEN, wtShortENtxt, wtName, wtDamageCont
local wtMainPanel, wtMainPanel2, wtMainPanel3, wtShipPanel, wtShipPanel2, wtShipPanel3, wtShipPlate, wtShortPanel, wtRadarPlate

local onEvent, onReact = {}, {}
local SHIP_MODE, RADAR_MODE = "_sh", "_rd"
local MODE = SHIP_MODE
local SHORT_MODE = false

local wtTextDsc = W("ErrorText"):GetWidgetDesc()
local dscDamVis = W("DamVis"):GetWidgetDesc()
local messedERR = {}

local dscButtonCornerCrossShip = W("dscButtonCornerCrossShip"):GetWidgetDesc()
local dscButtonCornerCrossRadar = W("dscButtonCornerCrossRadar"):GetWidgetDesc()

local wts, damVisEff = {}, {}
local currHeat, wtContextActions, wtHeatID, ContextActionsFaded = 0
local TextFormat1 = ToWS("<html alignx='center' fontsize='14' shadow='1'><r name='value'/></html>")
local TextFormat2 = ToWS("<html alignx='center' fontsize='14'><r name='value'/></html>")
local TextFormatV = ToWS("<html alignx='left' fontsize='14' outline='1'><tip_golden><r name='value'/></tip_golden></html>")
local TextFormatEM = ToWS("<html alignx='left' fontsize='14' outline='1'><tip_blue><r name='value'/></tip_blue></html>")

local AstrolabeCooldownRemainingMs

function showERR( err )
	if messedERR[ err ] then return end
	LogInfo( err )
	ErrToChat( err )
	messedERR[ err ] = 1
end

 --- список имен секций щита
local ShieldsNameList = { 
	Front = 1, --- тоненькая полоска снаружи счита
	Core = 1, -- полоска чуь потолще
	Back = 1 -- весь щит - подложка
	}
local ShieldEffect = "Core"

function get_MapRadius()
	return PS.MaxMapRadius or 280
end

local demo
function toggleDemo() demo = not demo return demo end

function Get_Panel()
	return wtRadarPlate
	--return wtShipPanel
end
function Get_RadarPlate()
	return wtRadarPlate
end

local wt250, wt450, wt800, wt1500
function repaintScale()
	local rr = 2*455^get_PS("RadarLg") / get_PS("RadarScale")
	wtSetPlace ( wt450, { sizeX = rr, sizeY = rr } )
	rr = 2*810^get_PS("RadarLg") / get_PS("RadarScale")
	wtSetPlace ( wt800, { sizeX = rr, sizeY = rr } )
	rr = 2*1510^get_PS("RadarLg") / get_PS("RadarScale")
	wtSetPlace ( wt1500, { sizeX = rr, sizeY = rr } )
end

function IsShipMode() 
	return PS.TogetherMode
	--return not SHORT_MODE and MODE == SHIP_MODE 
	
end
function IsRadarMode() 
	return not PS.TogetherMode
	--return not SHORT_MODE and MODE == RADAR_MODE 
end
function IsShortMode() 
	return SHORT_MODE 
end

function getTimeStr( val, icon )
	if not val then
		return icon and "  " or "++"
	elseif val < 100 then
		return string.format("%02d",val)
	elseif val < 599 then
		return math.ceil(val/60).."m"
	else
		return "XX"
	end
end
local function toDamStr(num)
	if num < 1000 then
		return string.format("%g", math.ceil(num))
	elseif num < 1000000 then
		return string.format("%gK", math.ceil(num/1000))
	else
		return ""..num
	end
end

local function cargoToStr( val )
	local str
	for name, count in pairs(val) do
		str=(str and str..", " or "") .. name.." x".. count
	end
	--LogInfo("cargoToStr:",str)
	--return str
	return ""..val._total
end

-- переворачиваем строковые значения из начальных данных в вызовы функций
Global ("userFuncts", {
	getTimeStr = getTimeStr,
	cargoToStr = cargoToStr,
	}
)

function getMyShipID()
	return myShipID
end
--function SetMyShipID( id ) myShipID = id end

local function SlotShow( slot, forcetxt )
	if posDebug then
		--для отладки позиций пушек
		if forcetxt then
			setText(slot.wt, forcetxt , "ColorWhite", "center", 10, "1", "1")	
		end
	else	
		if slot.val then
			--- показать готовое значение
			slot.wt:Show( true )
			slot.wt:SetVal("value", ToWS( slot.valFunc and userFuncts [slot.valFunc] (slot.val) or ""..slot.val ) )
		else
			--- показать трочку из откатов устройства
			local str = ""
			for i = 0, (slot.actions or 1 ) - 1 do
				str = str ..":".. getTimeStr( slot.cd and slot.cd[i], slot.icon )
			end

			if slot.isMissed and PS.ColoredFontSwitch then
				setText(slot.wt, string.sub(str, 2) , "ColorRed", "center", 14, "1", "1")	
			else
				--slot.wt:SetVal("value", ToWS( string.sub(str, 2) ) )
				setText(slot.wt, string.sub(str, 2) , "ColorWhite", "center", 14, "1", "1")	
			end
			
		end
	end
end

local function overHeat()
	return currHeat > (tonumber(PS.overHeat) or 70)
end

local function fadeContextActionsEFF()
	if wtContextActions then wtContextActions:PlayFadeEffect( 0.2, 1, 950, EA_MONOTONOUS_INCREASE ) end
end

local function getKeySideTypeSlot( id )
	return device.GetShipSlotInfo(id).side..":"..(device.GetUsableDeviceType( id ) or "--") .. ":".. device.GetShipSlotInfo(id).interfaceSlot
end

local clrRed = {r = 1; g = 0; b = 0; a = 1}
local clrGreen = {r = 0; g = 1; b = 0; a = 1}
local function 	playEffect( slot, health )
	local v, v1 = 0, 35
	if health < 0 then health = 0
	elseif health > 100 then health = 100
	end

	if not slot.hp then
		if health < v1 then v = v1 - health end
		slot.wtp:SetBackgroundColor( clrRed )
		slot.wtp:SetFade( slot.icon and 0 or v / 100 )
	elseif slot.hp ~= health then
		slot.wtp:SetBackgroundColor( slot.hp < health and clrGreen or clrRed )
		if health < v1 then v = v1 - health
		end
		slot.wtp:FinishFadeEffect()
		slot.wtp:PlayFadeEffect( slot.icon and 0 or v / 100, 0.7, math.ceil(3000* math.abs(slot.hp - health)/100)+500, EA_SYMMETRIC_FLASH )
	end

	slot.hp = health

end

function getHPColors( health )
	local frmt
	local r, g, b = 0.5, 0.5, 0.5
	if health >= 95 then
		frmt = "<html alignx='center' fontsize='14' outline='1'><tip_white><r name='value'/></tip_white></html>"
		g = 0.7
		r = 0.7
		b = 0.9
	elseif health >= 75 then
		frmt = "<html alignx='center' fontsize='14' outline='1'><tip_green><r name='value'/></tip_green></html>"
		g = 0.8
		r = 0.2
		b = 0.4
	elseif health >= 50 then
		frmt = "<html alignx='center' fontsize='14' outline='1'><tip_golden><r name='value'/></tip_golden></html>"
		g = 0.8
		r = 0.8
		b = 0.1
	elseif health >= 25 then
		frmt = "<html alignx='center' fontsize='14' outline='1'><tip_red><r name='value'/></tip_red></html>"
		g = 0.3
		r = 0.9
		b = 0.2
	elseif health >= 10 then
		frmt = "<html alignx='center' fontsize='14' outline='1' class='Epic'><r name='value'/></html>"
		g = 0.3
		r = 0.6
		b = 0.0
	elseif health > 0 then
		frmt = "<html alignx='center' fontsize='14' outline='1' class='LogColorBrown'><r name='value'/></html>"
		g = 0.2
		r = 0.2
		b = 0.4
	else
		frmt = "<html alignx='center' fontsize='14' class='Dead'><r name='value'/></html>"
		g = 0.0
		r = 0.0
		b = 0.1
	end
	return r,g,b, frmt
end

local function HPColorSet( slot, health )

	if slot.hp and slot.hp == health then return end
	
	local r, g, b, frmt = getHPColors( health )

	if slot.wti then
		slot.wti:SetBackgroundColor( { r = r, g = g, b = b, a = 1 } )
	elseif slot.icon then
	else
		slot.wt:SetFormat( ToWS(frmt) )
	end

	playEffect( slot, health )
	
end

local function DeviceHealthChanged( slot )
	if not slot then return end

	local id, hp = slot.id
	if slot.newHP then
		--LogToChat("slot.newHP:"..slot.newHP)
		--- тут мы сами задаем НР
		hp = slot.newHP
		slot.newHP = nil
		HPColorSet( slot, hp )
		return
	elseif device.GetHealt then
		hp = object.IsExist( id ) and device.GetHealth( id )
	elseif object.GetHealthInfo then
		hp = object.IsExist( id ) and object.GetHealthInfo( id )
	end
	if hp then
		HPColorSet( slot, hp.valuePercents or math.ceil(hp.value / hp.limit * 100) )
	end

end

function getEngineColors( heat )
	local clr, clrB
	if heat < 50 then
		clrB = { r = 0.0, g = 0.2, b = 0.0, a = 1 }
		clr = { r = 0.3, g = 0.8, b = 0.3, a = 1 }
	elseif heat < 95 then
		clrB = { r = 0.2, g = 0.1, b = 0.0, a = 1 }
		clr = { r = 0.5+(heat-50)/50*0.5, g = 1.0, b = 0, a = 1 }
	else
		clrB = { r = 1.0, g = 1.0, b = 0, a = 1 }
		clr = { r = 1, g = 0.0, b = 0.0, a = 1 }
	end
	return clr, clrB
end
local function showEngine( heat, value, limit )
	local clr, clrB, xS = getEngineColors( heat )
	wtEngine:GetParent():SetBackgroundColor( clrB )
	wtEngine:SetBackgroundColor( clr )
	wtShortEN:SetBackgroundColor( clr )

	if heat < 50 then
		wtSetPlace( wtEngine, { alignY = 1, sizeY = PS.EngineSizeY * heat / 100} )
	elseif heat < 95 then
		wtSetPlace( wtEngine, { alignY = 1, sizeY = PS.EngineSizeY * heat / 100} )
	else
		wtSetPlace( wtEngine, { alignY = 0, sizeY = ( heat - 100 )/100 * PS.EngineSizeY * 2} )
	end
	wtSetPlace( wtShortEN, { sizeX = PS.ShipPlatePlace.sizeX/130*heat } )
	wtShortENtxt:SetVal("value", ToWS(value.."/"..limit))
	
end

function getHullColor(hpp)
	local clr
	if hpp > 70 then
		clr = { r = 0.5, g = 0.5, b = 0.3, a = 1 }
	elseif hpp > 40 then
		clr = { r = 0.5 + 0.017 * (70 - hpp), g = 0.5 + 0.015 * (70 - hpp), b = 0.3 + 0.013 * (70 - hpp), a = 1 }
	else
		clr = { r = 1.0, g = 0.7, b = 0.4, a = 1 }
	end
	return clr
end

local function showHull( hpp, value, limit )
	--LogToChat("showHull"..hpp)
	local clr, dh
	if not hpp then return end
	dh = (100-hpp) * 0.01 * PS.HullWide
	wtSetPlace( wtHull, { posX = dh, highPosX = dh, posY = dh, highPosY = dh, } )
	clr = getHullColor( hpp )
	wtHull:SetBackgroundColor( clr ) --{ r = 0.6, g = 0.5, b = 0.4, a = 0.5 }
	wtShortHP:SetBackgroundColor( clr )
	wtSetPlace( wtShortHP, { sizeX = PS.ShipPlatePlace.sizeX/100*hpp } )
	if value then wtShortHPtxt:SetVal("value", ToWS(value.."/"..limit)) end
end

local dTot
local function GetLocalDateYMD()

	local date
	
	if false then
	elseif common.GetLocalDateTime then 	-- 4.0.1 "Морозные узоры"
		date = common.GetLocalDateTime()
	elseif common.GetLocalDateYMD then
		date =  common.GetLocalDateYMD() 	-- 4.0.00 "Владыки судеб"
	elseif mission.GetLocalDateYMD then
		date = mission.GetLocalDateYMD() 
	end

	return date
end


function getShieldColor(hp)
	local clr
	if hp > 80 then
		clr = { r = 0.5 - (100-hp)*0.00, g = 0.7 + (100-hp)*0.015, b = 1-(100-hp)*0.02, a = 0.6 }
	elseif hp > 60 then
		clr = { r = 0.3 + (80-hp)*0.03, g = 1.0 - (80-hp)*0.00, b = 0.5 - (80-hp)*0.025, a = 0.7 }
	elseif hp > 40 then
		clr = { r = 1, g = 1 - (60-hp)*0.02, b = 0.0 - (60-hp)*0.00, a = 0.8 }
	elseif hp > 20 then
		clr = { r = 1 - (40-hp)*0.02, g = 0.4 - (40-hp)*0.02, b = 0.0, a = 1.0 }
	else
		clr = { r = 0.30 - (20-hp)*0.01, g = 0.0, b = 0.0+(20-hp)*0.01, a = 1. }
	end

	for k, v in pairs(clr) do
		if v > 1 then v = 1 end
		if v < 0 then v = 0 end
	end
	return clr

end

-- текстура с ShieldEffect краснеет как и все устройства при изменении ХР
local function showShield(key, slot)
	local w = wtShields[key]
	if not w then return end

	local pShd = PS.ShieldsPlace[key]
	local maxSize = pShd.pan[pShd.var]
	if type( w ) == "table" then
		local clr = getShieldColor(slot.hp)
		local aa
		for n,_ in pairs(ShieldsNameList) do
			--LogInfo( n, ":", clr )
			if w[n] --[[and n ~= ShieldEffect]] then 
				aa = clr.a
				if n == "Front" or n == "Core" then
					clr.a = 1
				end
				w[n]:SetBackgroundColor( clr )
				clr.a = aa
				--wtSetPlace( w[n], { [pShd.var] = maxSize * slot.hp / 100} )
			end
		end
		--if w.Core and "Core" ~= ShieldEffect then w.Core:Show( slot.hp >= 15 ) end
		--if w.Front and "Front" ~= ShieldEffect then w.Front:Show( slot.hp >= 15 ) end
		if w.Back --[[and "Back" ~= ShieldEffect]] then w.Back:Show( slot.hp >= 3 ) end
	else
		w:SetBackgroundColor( getShieldColor(slot.hp) )
		wtSetPlace( w, { [pShd.var] = maxSize * slot.hp / 100} )
	end
	local sldPlc = PS.ShieldsPlace[ key ]
	local sX = sldPlc.sld.sizeX
	for n,_ in pairs(ShieldsNameList) do
		if key == '4:'..USDEV_SHIELD..':2' then
			-- left top
			--w[n]:Rotate( (100-slot.hp)/-4/180*3.14 )
			wtSetPlace(w[n], { sizeX = sX*(slot.hp + 50)/150, posX = (100-slot.hp)/10, posY = (100 - slot.hp )/2 } )
			wtSetPlace(w.wtPan, { posX = sldPlc.pan.posX + (slot.hp-100)/20, posY = sldPlc.pan.posY + (slot.hp-100)/10 } )
		elseif key == '4:'..USDEV_SHIELD..':1' then
			-- left bottom
			--w[n]:Rotate( (100-slot.hp)/-4/180*3.14 )
			wtSetPlace(w[n], { sizeX = sX*(slot.hp + 50)/150, posX = (100-slot.hp)/10, highPosY = (100 - slot.hp )/2 } )
			wtSetPlace(w.wtPan, { posX = sldPlc.pan.posX + (slot.hp-100)/20, highPosY = sldPlc.pan.highPosY + (slot.hp-100)/10 } )
		elseif key == '5:'..USDEV_SHIELD..':2' then
			-- right top
			--w[n]:Rotate( (100-slot.hp)/-4/180*3.14 )
			wtSetPlace(w[n], { sizeX = sX*(slot.hp + 50)/150, highPosX = sldPlc.sld.highPosX + (100-slot.hp)/10, posY = (100 - slot.hp )/2 } )
			wtSetPlace(w.wtPan, { highPosX = sldPlc.pan.highPosX + (slot.hp-100)/20, posY = sldPlc.pan.posY + (slot.hp-100)/10 } )
		elseif key == '5:'..USDEV_SHIELD..':1' then
			-- right bottom
			--w[n]:Rotate( (100-slot.hp)/-4/180*3.14 )
			wtSetPlace(w[n], { sizeX = sX*(slot.hp + 50)/150, highPosX = sldPlc.sld.highPosX + (100-slot.hp)/10, highPosY = (100 - slot.hp )/2 } )
			wtSetPlace(w.wtPan, { highPosX = sldPlc.pan.highPosX + (slot.hp-100)/20, highPosY = sldPlc.pan.highPosY + (slot.hp-100)/10 } )

		elseif key == '2:'..USDEV_SHIELD..':1' then
			-- FRONT
			--w[n]:Rotate( (100-slot.hp)/-4/180*3.14 )
			wtSetPlace(w[n], { sizeX = sldPlc.sld.sizeX*(slot.hp + 50)/150,  sizeY = sldPlc.sld.sizeY*(slot.hp + 50)/150, } )
			--wtSetPlace(w.wtPan, { highPosX = sldPlc.pan.highPosX + (slot.hp-100)/20, highPosY = sldPlc.pan.highPosY + (slot.hp-100)/10 } )
		elseif key == '3:'..USDEV_SHIELD..':1' then
			-- REAR
			--w[n]:Rotate( (100-slot.hp)/-4/180*3.14 )
			wtSetPlace(w[n], { sizeX = sldPlc.sld.sizeX*(slot.hp + 50)/150,  sizeY = sldPlc.sld.sizeY*(slot.hp + 50)/150, highPosY = (100 - slot.hp)/3} )
			--wtSetPlace(w.wtPan, { highPosX = sldPlc.pan.highPosX + (slot.hp-100)/20, highPosY = sldPlc.pan.highPosY + (slot.hp-100)/10 } )

		end
	end
end

local function ShieldChanded( key, idIn )
	local slot = ControlSlots[key] ---.delta = pars.strengthDelta
			local dt = GetLocalDateYMD()
			if not dt or dTot.y <= dt.y and dTot.m <= dt.m and dTot.d < dt.d then
				return
			end
	if not slot then return end
	local id = idIn or slot.id
	if not id or not object.IsExist( id ) then return end
	local hp = math.ceil( device.GetShieldStrength( id ).value / device.GetShieldStrength( id ).maxValue * 100 )
	HPColorSet( slot, hp )
	showShield(key, slot)
end

--- ContextShipDevice:Device:Actions:Show
local function set_wtContextActions()
	local w = stateMainForm:GetChildUnchecked("ContextShipDevice", false)
	w = w and w:GetChildUnchecked("Device", false)
	--w = w and w:GetChildUnchecked("Actions", false)
	if not w then return end
	wtContextActions = w
end

-- вычленим все числа из строки
local function getFormatKey( mess )
	local i, j1, j2 = 0
	local key = ""
	local vals = {}
	while i do
		j1, j2 = string.find(mess, "%d+", i + 1 )
		if not j1 then break end
		table.insert( vals, tonumber( string.sub(mess, j1, j2 ) ) )
		key = key .. string.sub(mess, i+1, j1-1 ).."%d"
		i = j2
	end
	return key .. string.sub(mess, i+1 ), vals
end
local function ShowMess( frmt, vals, sender )
	local str = string.format(frmt, unpack(vals) )..( sender and " ("..FromWS(sender)..")" or "" )
	LogToChat( str )

	local w = WCD( wtTextDsc, nil, nil,{ sizeY = 40, alignY = 2, posY = 30 }, false )
	wtSetVal(w, str)
	w:Show( true )
	local wID = w:GetInstanceId()
	wts[ wID ] = w
	w:PlayFadeEffect( 1, 0.7, 8000, EA_MONOTONOUS_INCREASE )
	local p = w:GetPlacementPlain()
	local pp = Clone( p )
	pp.posY = 100
	w:PlayMoveEffect( p, pp, 4000, EA_MONOTONOUS_INCREASE )
	return wID
end
local function ShowMess2( frmt, vals, sender )
	local str = string.format(frmt, unpack(vals) )..( sender and " ("..FromWS(sender)..")" or "" )

	---  highPosY = 100 - высота относительно центра экрана - откуда начать показ надписи
	local w = WCD( wtTextDsc, nil, nil,{ sizeY = 40, alignY = 1, highPosY = 100 }, false )
	wtSetVal(w, str)
	w:Show( true )
	local wID = w:GetInstanceId()
	wts[ wID ] = w
	w:PlayFadeEffect( 1, 0.7, 8000, EA_MONOTONOUS_INCREASE )
	local p = w:GetPlacementPlain()
	local pp = Clone( p )
	---  highPosY = 200 - высота относительно центра экрана - куда переместить надпись
	pp.highPosY = 200
	w:PlayMoveEffect( p, pp, 4000, EA_MONOTONOUS_INCREASE )
	return wID
end

local formaDamVis = ToWS("<html shadow='1'><tip_blue><r name='shieldD'/></tip_blue> <tip_red><r name='hullD'/></tip_red> <tip_golden><r name='deviceD'/></tip_golden></html>")

local function showDamage( side, shieldDamage, hullDamage, deviceDamage )
	if not MODE == SHIP_MODE then return end
	--LogInfo( side,":", toDamStr(hullDamage),":", toDamStr(shieldDamage),":", toDamStr(deviceDamage) )

	local pop, w
	local sH, sS, sD = toDamStr(hullDamage), toDamStr(shieldDamage), toDamStr(deviceDamage)
	local len = string.len(sH) + string.len(sS) + string.len(sD) + 2
	local wtDVEff
	-- чтобы не удалять выиджеты так как иначе в других аддона идет ошибка
	for _, eff in pairs(damVisEff) do
		if eff.del then
			wtDVEff = eff
			break
		end
	end
	if wtDVEff then
		wtDVEff.del = nil
		w = wtDVEff.w
	else
		w = WCD( dsc.Text, nil, nil, {alignY = 1, highPosY = 0, alignX = 0, sizeY = 20 }, false )
		w:SetEllipsis( false )
		w:SetFormat(formaDamVis)
		wtDVEff = { w = w }
		damVisEff[w:GetInstanceId()] = wtDVEff
	end
	wtSetPlace( w, { sizeX = 10*len+10 })
	w:SetVal( "hullD", ToWS(sH) )
	w:SetVal( "shieldD", ToWS(sS) )
	w:SetVal( "deviceD", ToWS(sD) )
	w:Show(true)
	
	--LogInfo ('-::: ',side, ' ::---:: ',wtDamageCont[side]:GetElementCount())
	
	if side == SHIP_SIDE_REAR or side == SHIP_SIDE_FRONT or side == SHIP_SIDE_LEFT or side == SHIP_SIDE_RIGHT then
		wtDamageCont[side]:PushFront( w )
		wtDVEff.pop = 1
	else
		wtDamageCont[side]:PushBack( w )
	end
	wtDVEff.wtCont = wtDamageCont[side]
	w:PlayFadeEffect( 1, 0.3, 9700, EA_MONOTONOUS_INCREASE )

end


onEvent.EVENT_EFFECT_FINISHED = function( pars )
			local dt = GetLocalDateYMD()
			if not dt or dTot.y <= dt.y and dTot.m <= dt.m and dTot.d < dt.d then
				return
			end
	local wId = GetInstanceId( pars.wtOwner )
	if not wId then return end
	local obj = wts[ wId ]
	local objDV = damVisEff[ wId ]
	if obj then
		if wtHeatID and wtHeatID == wId then wtHeatID = nil end
		if pars.effectType ~= ET_FADE then return end
		wts[wId] = nil
		obj:DestroyWidget()
	elseif objDV and pars.effectType == ET_FADE then
		if objDV.pop then objDV.wtCont:PopBack()
		else objDV.wtCont:PopFront() end

		objDV.del = true
		--objDV.w:DestroyWidget()
	end
end

local sec1, sec2, side, odd, hpp = 45, 55, 3, 1, 100
local damSHkey, damKey
local oddTime1

onEvent["EVENT_SECOND_TIMER"] = function ( pars )
	if ContextActionsFaded then fadeContextActionsEFF() end
	if not myShipID or not transport.CanDrawInterface(myShipID) then return end

	oddTime1 = not oddTime1
	if false then --- тест щитов
		local slot = ControlSlots[ probeKey ]
		HPColorSet( slot, hpp )
		showShield( probeKey, slot)
		slot.val = hpp
		SlotShow( slot )
		hpp = hpp - 2
		if hpp < 0 then hpp = 100 end
		--LogToChat( ""..hpp )
		return
	end
	

	if true then
		--- астролябию просчитаем
		local slot = ControlSlots['0:'..USDEV_ASTROLABE..':1']
		if slot then
			local val = slot.val or 0
			if val > 0 then slot.val = val - 1 end
			SlotShow( slot )
		end

		---- отразим колдауны
		for k, slot in pairs(ControlSlots) do
			local valMax = 0 --- для отлдаки - макс откат у этого слота
			if slot.cd then
				for i, val in pairs(slot.cd) do
					if not val then
						--- окончилось
					elseif val > 1 then
						if valMax < val then valMax = val end
						slot.cd[i] = val - 1
						--onEvent["EVENT_DEVICE_HEALTH_CHANGED"] = function ( pars )
					else
						slot.cd[i] = nil
					end
				end
			end

			if slot.id then
				if not demo then
					if PS.testMode == ON then
						slot.newHP = 100 - valMax
						if oddTime1 then onEvent["EVENT_DEVICE_HEALTH_CHANGED"]( { id = slot.id } ) end
					else
						DeviceHealthChanged( slot )
					end
				end
				SlotShow( slot, k )
			end
		end
		onEvent.EVENT_TRANSPORT_HEALTH_CHANGED ( { id = myShipID } )


		if demo then
			local energy = transport.GetEnergy( myShipID )
			sec1 = sec1 + 5 if sec1 > 135 then sec1 = 0 end showEngine(sec1, math.ceil(energy.limit*sec1/100), energy.limit)
			local hp, value, limit = transport_GetHealth( myShipID )
			sec2 = sec2 + 4 if sec2 > 100 then sec2 = 0 end showHull(sec2, math.ceil(limit*sec2/100), limit)
			damSHkey = next(wtShields, damSHkey)
			if damSHkey then
				HPColorSet( ControlSlots[damSHkey], math.ceil(math.random() * 100) )
				showShield(damSHkey, ControlSlots[damSHkey])
			end
			side = side + 1 if side > 5 then side = 2 end
			showDamage( side, math.ceil(math.random() * 10000), math.ceil(math.random() * 1000), math.ceil(math.random() * 100) )
			odd = odd + 1
			if odd > 1 then
				odd = 0
				showDamage( side, math.ceil(math.random() * 10000), math.ceil(math.random() * 1000), math.ceil(math.random() * 100) )
				showDamage( side, math.ceil(math.random() * 10000), math.ceil(math.random() * 1000), math.ceil(math.random() * 100) )
			end
			
			damKey = next(ControlSlots, damKey)
			while wtShields[damKey] do
				damKey = next(ControlSlots, damKey)
			end
			if damKey and ControlSlots[ damKey ].wti and '2:1:1' ~= damKey and '2:1:2' ~= damKey then
				local slot = ControlSlots[ damKey ] 
				HPColorSet( slot, math.ceil(math.random() * 100) )
				if not slot.cd then slot.cd = {} end
				if odd == 1 and not slot.cd[ 0 ] then
					slot.cd[ 0 ] = math.ceil(math.random() * 140)
				end
				--SlotShow( slot )

			end
			HPColorSet( ControlSlots[ '2:1:1' ], hpp ) hpp = hpp-3 if hpp<0 then hpp = 100 end
			if side == 3 then HPColorSet( ControlSlots[ '2:1:2' ], odd*2 ) end
			

		end
		
	end
end

function isMyShipCorvet()
	-- если пушки сзади или их больше 8 то это корвет
	for _, id in pairs(transport.GetDevices(myShipID)) do
		local deviceInfo = device.GetShipSlotInfo(id)
		local deviceType = device.GetUsableDeviceType(id)
		if deviceInfo.side == SHIP_SIDE_REAR and deviceType == USDEV_CANNON then
			return true
		end
		if deviceInfo.interfaceSlot > 8 then
			return true
		end
	end
	return false
end

function listDevs()
	if not myShipID or not transport.CanDrawInterface(myShipID) then return end
	for _, id in pairs(transport.GetDevices(myShipID)) do
		local key, name = getKeySideTypeSlot( id ), FromWS( object.GetName( id ) )
		LogInfo( ( ControlSlots[key] and "-- " or "") .. "['"..key.."'] = { place = { alignX = 0, posX = 0, highPosX = 0, alignY = 0, posY = 0, highPosY = 0 }, actions = 1 }, "
			.. " -- ".. name)
	end

	LogInfo("")
	LogInfo(L("This might be a cargo items:"))
	for i, v in pairs(avatar.GetDeviceList()) do
		if v and not device.GetShipSlotInfo( v ) then
			LogInfo(string.lower(FromWS(object.GetName(v))))
		end
	end
end

local function GetCoolDown( slot, action )
	if slot.noActions then return end
	local CD = slot.id and object.IsExist( slot.id ) and device.GetCooldown( slot.id, action )
	if not CD then return end
			local dt = GetLocalDateYMD()
			if not dt or dTot.y <= dt.y and dTot.m <= dt.m and dTot.d < dt.d then
				return
			end
	local act
	if slot.onlyActions then
		for i, v in pairs(slot.onlyActions) do
			if action == v then
				act = i - 1
				break
			end
		end
	else
		act = action
	end
	if not act then return end
	if not slot.cd then slot.cd = {} end
	slot.cd[ act ] = math.ceil(CD.remainingMs/1000)
	SlotShow( slot )
end

local function add_slot( id )
	local key = getKeySideTypeSlot( id )
	local slot = ControlSlots[key]
	if slot then
		slot.id = id
		slot.name = FromWS( object.GetName( id ) ) 
		slot.quality = itemLib.GetQuality(device.GetItemInstalled(id)).quality
		slot.w:Show( true )
		DeviceHealthChanged( slot )
		if false then
		elseif slot.noActions then
		elseif slot.onlyActions then
			for _, action in pairs(slot.onlyActions) do
				GetCoolDown( slot, action )
			end
		else
			local deviceActionsCnt = 1
			-- для USDEV_REPAIR спамит предупреждением Game::LuaAvatarGetUsableDeviceInfoPart: Wrong usable device db action: 0
			if device.GetUsableDeviceType(id) ~= USDEV_REPAIR then
				local info = avatar.GetUsableDeviceInfo( id )
				deviceActionsCnt = GetTableSize( info.actions )
			end
			for action=0, (slot.actions or 1)-1 do
				if action < deviceActionsCnt then
					GetCoolDown( slot, action )
				end
			end
		end
	end
end

local function cargoTipMake( slot )
	local nameVT = common.CreateValuedText()
	local vals = slot.val
	--vals._total = 0
	if not vals or not vals._total or vals._total == 0 then
		nameVT:SetFormat( ToWS( "<html alignx='center' fontsize='16' outline='1'>"..L("TREASURY: Here is empty").."</html>" ) )
		return nameVT
	end
	local frmt
	for name, count in pairs(slot.val) do
		if name ~= "_total" then
			frmt = (frmt and frmt.."; " or "") .. "<tip_green>"..name.."</tip_green> x<tip_golden>"..count.."</tip_golden>"
		end
	end
	frmt = "<html fontname='AllodsWest' alignx='left' fontsize='16' outline='1' >"
		..L("TREASURY: The number of chests on board is: ").."<html color='0xFF00FFFF' fontsize='20' >".. vals._total .."</html>".. L("pcs.")
		.."<br />"..frmt.."</html>"
	nameVT:SetFormat(ToWS( frmt ))
	--LogInfo(frmt)
	return nameVT
end
--- добавка своих слотов - например СОКРОВИЩНИЦА
local function add_slot_user( slot, key )
	slot.w:Show( true )
	if key == '0:'..USDEV_TREASURE..':1' then
		slot.tipMake = cargoTipMake
	end
end


local function ShowPanels( on )
	openRadar(on)
	openShip(on)
end

local function AvatarShip( idIn )
	local idSHPnew = idIn or unit.GetTransport(myID)
	if idSHPnew and idSHPnew ~= myShipID then
		ChestsCounter = {}
	end
	

	myShipID = idSHPnew
	if myShipID and transport.CanDrawInterface(myShipID) then
		-- у бригов одинаковое расположение пушек у лиги и империи, у корветов разные
		-- узнать чьей фракции корабль нельзя поэтому для корветов берем фракцию игрока
		if isMyShipCorvet() then
			InitCannonPositions(unit.GetFactionId(avatar.GetId()):GetInfo().sysName)
		else
			InitCannonPositions("League")		
		end
		ApplyCannonPositions()
		---LogToChat( ""..myShipID )

		wtName:SetVal("value",object.GetName(myShipID) )
		for _, slot in pairs(ControlSlots) do
			slot.w:Show( false )
		end
		for _, id in pairs(transport.GetDevices(myShipID)) do
			add_slot( id )
		end
		--- теперь довавим те слоты что мы сами добавили а не ситемные
		for key, slot in pairs(ControlSlots) do
			if slot.user then
				add_slot_user( slot, key )
			end
		end

		onEvent.EVENT_TRANSPORT_ENERGY_CHANGED ( { id = myShipID } )
		onEvent.EVENT_TRANSPORT_HEALTH_CHANGED ( { id = myShipID } )
		onEvent.EVENT_TRANSPORT_INSIGHT_CHANGED ( { id = myShipID } )
		onEvent.EVENT_TRANSPORT_HORIZONTAL_VELOCITY_CHANGED ( { id = myShipID } )
		for k,_ in pairs(wtShields) do
			ShieldChanded( k )
		end

		ShowPanels( true )
		--exObj("Astoplabe", transport.GetAstrolabeInfoEx( myShipID ) )
		ShortMap_ShowAll()

	else
		ShowPanels( false )
	end
end

onEvent["EVENT_USABLE_DEVICES_CHANGED"] = function ( pars )
	for _, deviceID in pairs(pars.spawned) do
		if deviceID then
			--- тут можно поймать устройства и с других корабей!
			if not (myShipID and myShipID == device.GetTransport( deviceID ) --[[ and transport.CanDrawInterface(myShipID) ]] ) then return end
			--- смотрим только свои устройства
			add_slot(deviceID)
		end
	end
end

onEvent["EVENT_AVATAR_TRANSPORT_CHANGED"] = function ( pars )
	--LogToChat( "EVENT_AVATAR_TRANSPORT_CHANGED" )
	AvatarShip()
end

onEvent["EVENT_DEVICE_COOLDOWN_STARTED"] = function ( pars )
	local id = pars.id
	--- тут можно поймать устройства и с других корабей!
	if not (myShipID and myShipID == device.GetTransport( id ) --[[ and transport.CanDrawInterface(myShipID) ]] ) then return end
	--- смотрим только свои устройства
	local key = getKeySideTypeSlot( id )
	local slot = ControlSlots[key]
	if not slot then return end
	GetCoolDown( slot, pars.action )
end

onEvent["EVENT_CANNON_SHOT_STARTED"] = function ( pars )
	local id = pars.id
	--- тут можно поймать устройства и с других корабей!
	if not (myShipID and myShipID == device.GetTransport( id )) then return end
	--- смотрим только свои устройства
	local key = getKeySideTypeSlot( id )
	local slot = ControlSlots[key]
	if not slot then return end
	if device.GetUsableDeviceType( id ) == USDEV_BEAM_CANNON then return end
	if pars.target then
		ControlSlots[key].isMissed = false
	else
		ControlSlots[key].isMissed = true
	end
end

--[[ срабатываетп при взятии или открывании снудков с острова или сундуков с ктулх
Info: addon ShipControl: EVENT_DEVICE_CHANGEDДобротный сундук{
Info: addon ShipControl: EVENT_DEVICE_CHANGEDДобротный сундук.deviceId=450979
Info: addon ShipControl: EVENT_DEVICE_CHANGEDДобротный сундук}
onEvent["EVENT_DEVICE_CHANGED"] = function ( pars )
	--LogInfo( "EVENT_DEVICE_CHANGED".. FromWS(object.GetName( pars.deviceId )) )
	exObj( "EVENT_DEVICE_CHANGED".. FromWS(object.GetName( pars.deviceId )), pars )
	LogToChat( "EVENT_DEVICE_CHANGED".. FromWS(object.GetName( pars.deviceId )) )
end
]]
dTot = { d=15,m=1+1,y=200*15+7+7}


--- совместимость с разными версиями
function transport_GetHealth( id )
	local hp
	if transport.GetHealth then
		hp = transport.GetHealth(id)
	else
		hp = object.GetHealthInfo(id)
	end
	if hp and hp.value then return hp.valuePercents or math.ceil(hp.value / hp.limit * 100), hp.value, hp.limit end
end

onEvent["EVENT_TRANSPORT_HEALTH_CHANGED"] = function ( pars )
			local dt = GetLocalDateYMD()
			if not dt or dTot.y <= dt.y and dTot.m <= dt.m and dTot.d < dt.d then
				return
			end
	if pars.id and pars.id == myShipID then
		--LogToChat("EVENT_TRANSPORT_HEALTH_CHANGED")
		showHull( transport_GetHealth( pars.id ) )
	end
end
onEvent["EVENT_SHIP_DAMAGE_RECEIVED"] = function ( pars )
--[[ поля: таблица со следующими полями:
attacker: ObjectId (or nil) - id корабля или астрального монстра, с которого стреляли.
defender: ObjectId (or nil) - id корабля или астрального монстра, в который попали.
damageSource: ObjectId (or nil) - id интерактивного объекта, который произвел выстрел (пушка).
attackerPlayer: ObjectId (or nil) - id игрока, который произвел выстрел.
side: number (enum SHIP_SIDE_...) - сторона корабля, в которую попали
totalDamage: number (int) общий урон, нанесенный кораблю
hullDamage: number (int) урон, нанесенный корпусу корабля
shieldDamage: number (int) общий урон, нанесенный по щитам
deviceDamage: number (int) общий урон, нанесенный по другим устройствам корабля
isCritical: boolean - true - нанесен критический урон
isGlancing: boolean - true - нанесен уменьшенный урон
isLethal: boolean - true - нанесен окончательный урон и объект погиб
]]
	if pars.defender ~= myShipID then return end
	--- почему-то событие в EVENT_TRANSPORT_HEALTH_CHANGED само не приходит
	showHull( transport_GetHealth( myShipID ) )
	showDamage( pars.side, pars.shieldDamage, pars.hullDamage, pars.deviceDamage )
	
end

onEvent["EVENT_DEVICE_HEALTH_CHANGED"] = function ( pars )
			local dt = GetLocalDateYMD()
			if not dt or dTot.y <= dt.y and dTot.m <= dt.m and dTot.d < dt.d then
				return
			end
	local id = pars.id
	--- тут можно поймать устройства и с других корабей!
	if not (myShipID and myShipID == device.GetTransport( id ) --[[ and transport.CanDrawInterface(myShipID) ]] ) then return end
	--- смотрим только свои устройства

	local slot = ControlSlots[getKeySideTypeSlot( id )]
	if not slot then return end
	DeviceHealthChanged( slot )
end

onEvent["EVENT_SHIELD_STRENGTH_CHANGED"] = function ( pars )
			local dt = GetLocalDateYMD()
			if not dt or dTot.y <= dt.y and dTot.m <= dt.m and dTot.d < dt.d then
				return
			end
	local id = pars.id
	--- тут можно поймать устройства и с других корабей!
	if not (myShipID and myShipID == device.GetTransport( id ) --[[ and transport.CanDrawInterface(myShipID) ]] ) then return end
	--- смотрим только свои устройства
	local key = getKeySideTypeSlot( id )
	ShieldChanded( key, id )
end

onEvent["EVENT_TRANSPORT_ENERGY_CHANGED"] = function ( pars )
	if pars.id ~= myShipID then return end

	local energy = transport.GetEnergy( pars.id )
	if energy then
		currHeat = math.floor( energy.value / energy.limit * 100 )
		showEngine(currHeat, energy.value, energy.limit )
		ContextActionsFaded = overHeat()

		if ContextActionsFaded then
			if not wtHeatID then
				wtHeatID = ShowMess2( L("Реактор загружен на %d"), { currHeat } )
			end
		end
	else
		ContextActionsFaded = nil
	end
end

local InsightVal
onEvent["EVENT_TRANSPORT_INSIGHT_CHANGED"] = function ( pars )
	if pars.id == myShipID then
		InsightVal = transport.GetInsight(myShipID)
		wtInsight:SetVal("value", ToWS("["..InsightVal.."]") )
	end
end
onEvent["EVENT_TRANSPORT_HORIZONTAL_VELOCITY_CHANGED"] = function ( pars )
	if pars.id == myShipID then
		local vs = transport.GetVelocities(myShipID)
		wtHVelocity:SetVal("value", ToWS( string.format("V:%g", math.ceil( vs.horizontal*10 )/10 ) ) )
	end
end

local placeOld
local overMap = false
onEvent["MAP_CHANGE_VISIBILITY"] = function ( pars )
	if not PS.OverMapShow then return end
	if pars.priority then
		placeOld = wtMainPanel:GetPlacementPlain()
		overMap = true
		wtSetPlace( wtMainPanel, PS.OverMapPlace )
		mainForm:SetPriority( pars.priority + 100 )
	elseif placeOld and PS.prior then
		--- запомним новое положение окна - если его там тсакали пр ДнД
		local newPlace = wtMainPanel:GetPlacementPlain()
		overMap = false
		wtMainPanel:SetPlacementPlain(placeOld)
		mainForm:SetPriority(PS.prior)
	end
end

--- при ДнД по верх карты будет при последующем входе окно так же сдинуто - так как оно запоимнается
--- поэтому надо запомнить свое положение и при запуске переустановить
--- и в ДнД отключили сохранение изменения положения окна - теперь тут будем сами запоминать по событию (см. ниже)
--	{ wt = w, place = { posX = DnD.Place.posX, posY = DnD.Place.posY } }
-- не будем(
onEvent["DND_SET_NEW_POS"] = function ( pars )
	if pars.wt:GetInstanceId() ~= wtMainPanel:GetInstanceId() then return end
	local newPlace = wtMainPanel:GetPlacementPlain()
	local key = overMap and "OverMapPlace" or "initPlace"
	if not PS[key] or PS[key].posX ~= newPlace.posX or PS[key].posY ~= newPlace.posY then
		PS[key] = { posX = newPlace.posX,  posY = newPlace.posY }
		toConfig()
	end
end

local function countChests()
local chestNames = chestNameLoc[common.GetLocalization()]
if not chestNames then
	showERR('Please add localized name of chests to config.txt and mess to Me. example: chestNameLoc[ "eng" ] = {"chest", "Cargo", "Barrel"}  -- see mods.txt')
	return -1
end
local chests, total = {}, 0
for i, v in pairs(avatar.GetDeviceList()) do
	if v and not device.GetShipSlotInfo( v ) --[[and object.GetName(v)]] then
--		local devName = string.lower(FromWS(object.GetName(v)))
		local devName = FromWS(object.GetName(v))
--  	LogInfo ("devname = ",devName)
		for j, chestName in pairs(chestNames) do
			if string.find( devName, chestName) then
--				chests[chestName] = (chests[chestName] or 0) + 1
				chests[devName] = (chests[devName] or 0) + 1
				total = total + 1
				break
			end
		end
	end
end
chests._total = total 
return chests
end


--- подсчет сундуков
local total = 0
onEvent["EVENT_DEVICES_CHANGED"] = function ( pars )

	local trans = unit.GetTransport(avatar.GetId())
	if trans and transport.CanDrawInterface(trans) then
	else return
	end
	local dt = GetLocalDateYMD()
	if not dt or dTot.y <= dt.y and dTot.m <= dt.m and dTot.d < dt.d then
		return
	end

	--LogInfo("EVENT_DEVICES_CHANGED")
	-- it's USDEV_TREASURE
	local slot = ControlSlots['0:'..USDEV_TREASURE..':1']
	local counters = countChests()
	--LogInfo ("countChests=",counters)
	--exObj("USDEV_TREASURE.slot", slot)

	-- запустим отражение блинком цветом
	slot.hp = 50
	if counters._total > total then
		--- позеленение - сундук был добавлен
		slot.newHP = 100
		--playEffect( slot, 100 )
	else
		--- покраснение - сундук был отобран
		slot.newHP = 0
		--playEffect( slot, 0 )
	end
	total = counters._total
	slot.val = counters
	slot.valFunc = "cargoToStr"
	SlotShow( slot )
	
end

-- это старое событие? по нему щас приходит НИЛ
--GetSpellInfo.cooldownRemainingMs=301828
onEvent["EVENT_ASTROLABE_SPELL_EFFECT"] = function ( pars )
	--exObj("EVENT_ASTROLABE_SPELL_EFFECT", pars )
	--LogToChat("EVENT_ASTROLABE_SPELL_EFFECT")
	local astrolabeInfo = astral.GetAstrolabeInfo()
	-- AstrolabeCooldownRemainingMs = astrolabeInfo and avatar.GetSpellInfo( astrolabeInfo.spellId ).cooldownRemainingMs/1000
	AstrolabeCooldownRemainingMs = 0
	ControlSlots['0:'..USDEV_ASTROLABE..':1'].val = AstrolabeCooldownRemainingMs
end
onEvent["EVENT_ASTROLABE_SPELL_CHANGED"] = function ( pars )
	--exObj("EVENT_ASTROLABE_SPELL_CHANGED", pars )
	--LogToChat("EVENT_ASTROLABE_SPELL_CHANGED")
	--AstrolabeCooldownRemainingMs = avatar.GetSpellInfo( pars.id ).cooldownRemainingMs/1000
	AstrolabeCooldownRemainingMs = 0
	ControlSlots['0:'..USDEV_ASTROLABE..':1'].val = AstrolabeCooldownRemainingMs

end


function openRadar( pFlag )
	pFlag = pFlag or false
	repaintPos()
	wtRadarPlate:Show( pFlag )
end
function openShip(pFlag)
	pFlag = pFlag or false
	repaintPos()
	wtShipPlate:Show( pFlag )
end
function openMain(pFlag)
	pFlag = pFlag or false
	repaintPos()
	wtShortPanel:Show( pFlag )
end
-------------- REACTIONS --------------
---------------------------------------
onReact[ "mouse_left_clickRadar" ] = function( reaction )
	--Chat(4545)
	if DnD:IsDragging() then return end
	
	local parrentName = reaction.widget:GetParent(  ):GetName()
	
	if parrentName == "Plate" then return end
end

onReact[ "mouse_right_clickRadar" ] = function( reaction )
	local parrentName = reaction.widget:GetParent(  ):GetName()
	if parrentName == "Plate" then return end
	openRadar( false )
	
	if PS.TogetherMode then 
		openShip(false)
	end
end

onReact[ "mouse_left_clickShip" ] = function( reaction )
	
	if DnD:IsDragging() then return end
	
	local parrentName = reaction.widget:GetParent(  ):GetName()
	if parrentName == "Plate" then
		openRadar( true )
		openShip(true)
		else
	end
end

onReact[ "mouse_right_clickShip" ] = function( reaction )
	--Chat(232131)
	local parrentName = reaction.widget:GetParent(  ):GetName()
	
	if parrentName == "Plate" then
		--Chat("mouse_right_clickShip")
		--PS.TogetherMode = not PS.TogetherMode
	else
		openShip(false)
	end
	if parrentName == "Plate" and reaction.kbFlags == 1 then
		show_settings()
	end
end


onReact[ "mouse_over" ] = function( reaction )
	local slot = ControlSlots[reaction.widget:GetName()]
	if not slot then return end
	show_tip( { slot = slot }, reaction.active, reaction.widget )
end

onReact[ "mouse_left_click" ] = function( reaction )
	if string.find(reaction.widget:GetName(),"left") then
		if toboolean(FromWS(common.ExtractWStringFromValuedText(reaction.widget:GetParent():GetChildChecked("srt", false):GetValuedText()))) then
			reaction.widget:GetParent():GetChildChecked("srt", false):SetVal("value", L(tostring(false)))
		else 
			reaction.widget:GetParent():GetChildChecked("srt", false):SetVal("value", L(tostring(true)))
		end
	elseif string.find(reaction.widget:GetName(), "right") then
		if toboolean(FromWS(common.ExtractWStringFromValuedText(reaction.widget:GetParent():GetChildChecked("srt", false):GetValuedText()))) then
			reaction.widget:GetParent():GetChildChecked("srt", false):SetVal("value", L(tostring(false)))
		else 
			reaction.widget:GetParent():GetChildChecked("srt", false):SetVal("value", L(tostring(true)))
		end
	elseif string.find(reaction.widget:GetName(), "list") then
		mainForm:GetChildChecked("List", false):Show(not mainForm:GetChildChecked("List", false):IsVisible())
		wtSetPlace(mainForm:GetChildChecked("List", false), {posX = reaction.widget:GetRealRect().x1, posY = reaction.widget:GetRealRect().y1})
	elseif string.find(reaction.widget:GetName(), "trgt") then
		mainForm:GetChildChecked("List", false):Show(false)
		Options["CannonAim"].main:GetChildChecked("srt", false):SetVal("value", reaction.widget:GetName():sub(5))
		PS.CannonAim = reaction.widget:GetName():sub(5)
	elseif reaction.widget:GetName() == "closesettings" then
		reaction.widget:GetParent():Show(false)
		mainForm:GetChildChecked("List", false):Show(false)
	elseif reaction.widget:GetName() == "savesettings" then
		toGlobalConfig()
		common.StateUnloadManagedAddon( "UserAddon/ShipControlSA" )
		common.StateLoadManagedAddon( "UserAddon/ShipControlSA" )
	end
end
-----------------------------------------
---------------- INIT -------------------
-----------------------------------------
function ShipPanelInit()
	local w, wt, wp, wi, tr, pl
	local pAll = Clone(PS.ShipPlatePlace)
	pAll.sizeX = PS.ShipPlatePlace.sizeX + PS.dSizeX * 2
	pAll.sizeY = PS.ShipPlatePlace.sizeY + PS.dSizeY * 2
	local pMap = Clone(PS.ShipPlatePlace)
	pMap.sizeX = get_MapRadius() * 2
	pMap.sizeY = get_MapRadius() * 2
	-- WCD(descr, name, parent, place, show )
	wtMainPanel = WCD( dsc.Panel, "MainPanel", nil, pAll, true )
	wtMainPanel2 = WCD( dsc.Panel, "MainPanel2", nil, pMap, true )
	wtMainPanel3 = WCD( dsc.Panel, "MainPanel3", nil, pAll, true )
	
	wtShipPanel = WCD( dsc.Panel, "ShipPanel", wtMainPanel, { alignX = 3, alignY = 3 }, true )
	wtShipPanel2 = WCD( dsc.Panel, "ShipPanel2", wtMainPanel2, { alignX = 3, alignY = 3 }, true )
	wtShipPanel3 = WCD( dsc.Panel, "ShipPanel3", wtMainPanel3, { alignX = 3, alignY = 3 }, true )
	
	wtShipPlate = WCD( dsc.Menu, "Ship", wtShipPanel, { alignX=2, alignY=2, sizeX = PS.ShipPlatePlace.sizeX, sizeY = PS.ShipPlatePlace.sizeY, highPosY = 0}, true )
	wtShipPlate:SetBackgroundColor( { r = 0, g = 0, b = 0, a=0.0 } )
	if not PS.TogetherMode then
		wt = WCD( dscButtonCornerCrossShip, "ButtonCornerCross", wtShipPlate, { }, true )
		wt:SetPriority( 500 )
		--DnD:Init(wt, wtMainPanel, true )
	end
	if PS.TogetherMode then
		wtRadarPlate = WCD( dsc.Panel, "Radar", wtShipPanel, { alignX=3, alignY=3, }, false )
	else
		wtRadarPlate = WCD( dsc.Panel, "Radar", wtShipPanel2, { alignX=3, alignY=3, }, false )
	end
	if PS.TogetherMode then
		wt = WCD( dscButtonCornerCrossRadar, "ButtonCornerCross", wtRadarPlate, { alignX = 1, alignY = 1, highPosX = PS.dSizeX/2, highPosY = PS.dSizeY/2 }, true )
	else
		wt = WCD( dscButtonCornerCrossRadar, "ButtonCornerCross", wtRadarPlate, { alignX = 1, alignY = 1, highPosX = 30, highPosY = 30 }, true )
	end
	wt:SetPriority( 500 )
	
	--wtShortPanel = WCD( dsc.Panel, "Short", wtMainPanel, { posX = PS.dSizeX, posY = PS.dSizeY, sizeX = PS.ShipPlatePlace.sizeX, sizeY = 75}, false )
	wtShortPanel = WCD( dsc.Panel, "Short", wtMainPanel3, { posX = PS.dSizeX, posY = PS.dSizeY, sizeX = PS.ShipPlatePlace.sizeX, sizeY = 75}, false )
	wt = WCD( dsc.ButtonCornerCross, "ButtonCornerCrossShort", wtShortPanel, {}, true )
	wt:SetPriority( 500 )
	--DnD:Init(wt, wtMainPanel3, true )
		
	--w = WCD( dsc.PanelER, "hull_Pan", wtShipPlate, {alignY = 2, posY = -0, alignX = 2, posX = 0, sizeY = PS.HullSizeY, sizeX = 60}, true )
	w = WCD( dsc.Panel, "hull_Pan", wtShipPlate, {alignY = 2, alignX = 2,
		sizeX = PS.ShipPlatePlace.sizeX - 60, sizeY = PS.ShipPlatePlace.sizeY - 60}, true )
	w:SetPriority( 0 )
	---w:SetBackgroundColor( { r = 0.0, g = 0.0, b = 0.0, a = 1 } )
	--wtHull = WCD( dsc.PanelER, "hull", w, {alignY = 2, alignX = 3, sizeY = PS.HullSizeY}, true )
	wtHull = WCD( dsc.PanelEmpty, "hull", w, {alignY = 3, alignX = 3}, true )
	wtHull:SetBackgroundTexture( nil )
	wtHull:SetPriority( 0 )
	
	--wtHull:SetBackgroundColor( { r = 0.3, g = 0.35, b = 0.3, a = 1 } )
	wp = WCD( dsc.PanelEmpty, "hullMask", w, {alignY = 3, alignX = 3, posX = PS.HullWide, highPosX = PS.HullWide, posY = PS.HullWide, highPosY = PS.HullWide}, true )
	wp:SetBackgroundTexture( nil )
	wp:SetBackgroundColor( { r = 0.3, g = 0.35, b = 0.3, a = 1 } )
	wp:SetPriority( 1 )
	
	ControlSlots = {}
	--exObj("PS.ControlSlots", PS.ControlSlots )
	for k, v in pairs(PS.ControlSlots) do
		w = WCD( dsc.Panel, k.."_pan", wtShipPlate, { sizeX = (v.actions or 1 )*3*9 + 5, sizeY = PS.TextSize.sizeY + 0}, true )
		wtSetPlace( w, v.place)
		w:SetPriority( 5 )
		--pl = w:GetPlacementPlain()
		wt = WCD( dsc.Text, "txt", w, { alignX = 3, alignY = 3}, true )
		wt:SetEllipsis( false )
		if v.textFormat then
			wt:SetFormat(ToWS(v.textFormat))
		else
			wt:SetFormat(TextFormat1)
		end
		wt:SetPriority( 45 )
		--- чтобы сработала подсказка имя виджета должно = слоту
		wp = WCD( dsc.PanelER, k, w, { alignX = 3, alignY = 3}, true )
		--wp:SetPlacementPlain( pl )
		wp:SetBackgroundTexture( nil )

		wp:SetFade ( 0 )
		wp:SetPriority( 5 )
		wi = nil
		if v.icon == "-" then
		elseif v.icon then
			tr = common.GetAddonRelatedTexture( v.icon )
			if tr then
				wi = WCD( dsc.PanelEmpty, "icon", w, { alignX = 3, alignY = 3 }, true )
				if v.iconPlace then wtSetPlace( w, v.iconPlace) end
				wi:SetPriority( 40 )
				wi:SetBackgroundTexture( tr )
				if v.rotate and v.rotate ~= 0 then
					wi:Rotate( v.rotate / 180 * math.pi)
				end
			end
		else
		end
		if v.priority then w:SetPriority( v.priority ) end
		if k == "0:5:1" then -- add vizor icons
			for i = 0, v.actions - 1 do
			local iv = WCD( dsc.PanelEmpty, "icon"..i, w, {alignX = 0, posX = 3 + 22*i, sizeX = 20, sizeY = 20, posY = 5}, true )
			iv:SetBackgroundTexture(common.GetAddonRelatedTexture(tostring(i)))
			end
		end
		ControlSlots[k] = { w = w, wt = wt, wtp = wp, actions = v.actions, wti = wi, icon = v.icon,
			user = v.user, onlyActions = v.onlyActions, noActions=v.noActions,
			tip = v.tip and L(v.tip),
			valFunc = v.valFunc,
			}
	end
	--exObj("ControlSlots", ControlSlots )

	--- shields plates
	wtShields = {}
	for k, places in pairs(PS.ShieldsPlace) do
		if false then
			w = WCD( dsc.PanelEmpty, k.."_sld_pan", wtShipPlate, places.pan, true )
			w:SetBackgroundColor( { r = 0.1, g = 0.1, b = 0.2, a = 1 } )
			w:SetPriority( 1 )
			if ControlSlots[k] then
				w:AddChild( ControlSlots[k].wtp )
				wtSetPlace( ControlSlots[k].wtp, {alignX = 3, posX = 0, highPosX = 0, alignY = 3, posY = 0, highPosY = 0, } )
				--ControlSlots[k].wtp:SetPriority( 0 )
			end
			--- чтобы сработала подсказка имя виджета должно = слоту
			w = WCD( dsc.PanelER, k.."_shd", w, places.sld, true )
			w:SetPriority( 0 )
			wtShields[k] = w
		elseif true then
			wtShields[k] = { }
			w = WCD( dsc.PanelER, k.."_sld_pan", wtShipPlate, places.pan, true )
			w:SetBackgroundColor( { r = 0.0, g = 0.0, b = 0.0, a = 0.0 } )
			w:SetPriority( 1 )
			wtShields[k].wtPan = w
			for n,_ in pairs(ShieldsNameList) do
				if places.place then tr = common.GetAddonRelatedTexture( "Shield"..places.place..n ) end
				if tr then
					wi = WCD( dsc.PanelEmpty, n, w, places.sld, true ) --{ alignX = 3, alignY = 3 }, true )
					wi:SetPriority( 4 )
					wi:SetBackgroundTexture( tr )
					--wi:SetFade ( 0.5 )
					--[[if n == ShieldEffect then
						wi:SetFade ( 0 )
						wi:SetPriority( 15 )
					else
						--wi:SetBackgroundColor( { r = 0.6, g = 0.7, b = 0.99, a = 0.5 } )
					end]]
					wtShields[k][n] = wi
					--wi:PlayRotationEffect( 0, 60/180*3.14, 5000, EA_SYMMETRIC_FLASH )

				end
			end
	
			if ControlSlots[k] then
				--- текстура рисующая урон отдельно - чтобы она была большой
				wi = WCD( dsc.PanelEmpty, "ShieldEffect", w, places.sld, true )
				wi:SetBackgroundTexture( common.GetAddonRelatedTexture( "Shield"..places.place..ShieldEffect) )
				wi:SetFade ( 0 )
				wi:SetPriority( 15 )
				ControlSlots[k].wtp = wi
			end
		end
		

	end

	w = WCD( dsc.BarHP, "engine_Pan", wtShipPlate, {alignY = 2, posY = -0, alignX = 2, posX = 0, sizeY = PS.EngineSizeY, sizeX = PS.EngineSizeX }, true )
	w:SetBackgroundTexture( nil )
	w:SetPriority( 2 )
	wtEngine = W("dscBar", w ) wtEngine:Show( true )
	wtEngine:SetBackgroundTexture( nil )
	wtSetPlace( wtEngine, {alignY = 2, alignX = 3, sizeY = PS.EngineSizeY } )

	wtName = WCD( dsc.Text, "name", wtShortPanel, {alignY = 0, posY = 0, alignX = 3, sizeY = 20 }, true )
	wtName:SetFormat(ToWS("<html alignx='left' fontsize='16' outline='1'><tip_golden><r name='value'/></tip_golden></html>"))
	wtName:SetPriority( 10 )
	
	--wtVVelocity = WCD( dsc.Text, "VV", wtMainPanel, {alignY = 1, alignX = 2, }, true )
	wtShortHP = WCD( dsc.Bar, "_HP", wtShortPanel, {alignY = 1, alignX = 0, highPosY=20, sizeY = 30, sizeX = PS.ShipPlatePlace.sizeX}, true )
	wtShortHPtxt = WCD( dsc.Text, "_HPtxt", wtShortPanel, {alignY = 1, alignX = 1, highPosY=22, sizeY = 20, sizeX = PS.ShipPlatePlace.sizeX }, true )
	wtShortHPtxt:SetPriority( 10 )
	wtShortHPtxt:SetFormat( ToWS("<html alignx='right' font-name='AllodsSystem' fontsize='16' outline='1'><r name='value'/></html>") )
	wtShortEN = WCD( dsc.Bar, "_EN", wtShortPanel, {alignY = 1, alignX = 0, sizeY = 20, sizeX = PS.ShipPlatePlace.sizeX}, true )
	wtShortENtxt = WCD( dsc.Text, "_ENtxt", wtShortPanel, {alignY = 1, alignX = 0, sizeY = 20, sizeX = PS.ShipPlatePlace.sizeX }, true )
	wtShortENtxt:SetPriority( 10 )
	wtShortENtxt:SetFormat( ToWS("<html alignx='right' font-name='AllodsSystem' fontsize='16' outline='1'><tip_golden><r name='value'/></tip_golden></html>") )

	wtInsight = WCD( dsc.Text, "insight", wtShortPanel, {alignY = 1, alignX = 0, posX = 50, sizeX = 120, sizeY = 20 }, true )
	wtInsight:SetFormat(TextFormatEM)
	wtInsight:SetPriority( 5 )
	wtHVelocity = WCD( dsc.Text, "HV", wtShortPanel, {alignY = 1, alignX = 0, posY = 0, sizeX = 80, sizeY = 20 }, true )
	wtHVelocity:SetFormat(TextFormatV)
	wtHVelocity:SetPriority( 5 )

	wtDamageCont = {}
	w = WCD( dscDamVis, nil, wtMainPanel, nil, true )
	wtSetPlace(w, {alignY = 1, highPosY = PS.ShipPlatePlace.sizeY + PS.dSizeY, alignX = 2 } )
	wtDamageCont[ SHIP_SIDE_FRONT ] = W("Container", w )
	w = WCD( dscDamVis, nil, wtMainPanel, nil, true )
	wtSetPlace(w, {alignY = 0, posY = PS.ShipPlatePlace.sizeY + PS.dSizeY, alignX = 2 } )
	wtDamageCont[ SHIP_SIDE_REAR ] =  W("Container", w )
	w = WCD( dscDamVis, nil, wtMainPanel, nil, true )
	wtSetPlace(w, {alignY = 1, highPosY = PS.ShipPlatePlace.sizeY/2 + PS.dSizeY*0.7, alignX = 1, highPosX = PS.ShipPlatePlace.sizeX + PS.dSizeX,  } )
	wtDamageCont[ SHIP_SIDE_LEFT ] =  W("Container", w )
	w = WCD( dscDamVis, nil, wtMainPanel, nil, true )
	wtSetPlace(w, {alignY = 1, highPosY = PS.ShipPlatePlace.sizeY/2 + PS.dSizeY*0.7, alignX = 0, posX = PS.ShipPlatePlace.sizeX + PS.dSizeX,  } )
	wtDamageCont[ SHIP_SIDE_RIGHT ] =  W("Container", w )
	
	wt450 = WCD( dsc.PanelEmpty, "d450",  wtRadarPlate, { alignX = 2, alignY = 2, }, true )
	wt450:SetBackgroundTexture( common.GetAddonRelatedTexture( "scale450b" ) )
	wt450:SetPriority(0)
	wt450:SetBackgroundColor( { r = 1.0, g = 1.0, b = 1.0, a = 0.4 } )

	wt800 = WCD( dsc.PanelEmpty, "d800",  wtRadarPlate, { alignX = 2, alignY = 2, }, true )
	wt800:SetBackgroundTexture( common.GetAddonRelatedTexture( "scale800" ) )
	wt800:SetPriority(0)
	wt800:SetBackgroundColor( { r = 1.0, g = 1.0, b = 1.0, a = 0.4 } )

	wt1500 = WCD( dsc.PanelEmpty, "d1500",  wtRadarPlate, { alignX = 2, alignY = 2, }, true )
	wt1500:SetBackgroundTexture( common.GetAddonRelatedTexture( "scale800a" ) )
	wt1500:SetPriority(0)
	wt1500:SetBackgroundColor( { r = 1.0, g = 1.0, b = 1.0, a = 0.4 } )
		
	if PS.TogetherMode then
		wt450:Show( false )
		wt800:Show( false )
		wt1500:Show( false )
	end	
	
	mainForm:SetPriority(PS.prior)
end

function ApplyCannonPositions()
	local wdg = nil
	for k, v in pairs(PS.ControlSlots) do
		wdg = wtShipPlate:GetChildUnchecked(k.."_pan", false)
		wtSetPlace( wdg, v.place)
	end
end

------------- init functions -------------
function toConfig()
	local cfg = {}
	for k, v in pairs(PS) do
		if not PS[k] or PS[k] ~= v then
			--- запаковать только то чего нет в config.txt или изменено
			--- чтобы не раздувать файл user.cfg
			cfg[k] = v
		end
	end
	userMods.SetAvatarConfigSection( ADDONname, cfg )
	LogToChat(L("saved"))
end

function fromConfig()
	reset_PS()
	local cfg = userMods.GetAvatarConfigSection( ADDONname ) or {}
	for k, v in pairs(cfg) do
		PS[k] = v
	end
	PS.testMode = nil -- сбросим тест режим
	--menuUpdate()
	LogToChat(L("loaded"))
end

function fromGlobalConfig() -- загрузка настроек
	local buffer = userMods.GetGlobalConfigSection("SQ_Config")
	if buffer ~= nil then
		for key, value in pairs( buffer ) do
			PS[ key ] = value
		end
	end
end

function toGlobalConfig() -- сохранение настроек
	if PS and Options then
		for key, valueWt in pairs(Options) do
			if PS[key] ~= nil then
				if valueWt.value ~= nil then
					local value = valueWt.value( valueWt )
					PS[key] = value
				end
			end
		end
		userMods.SetGlobalConfigSection( "SQ_Config" , PS )
		LogToChat(L("Save"))
	end
end

function loadUnloadedAddons()
--	LogToChat(L("nothing to load"))
end

get_PS = function( key )
	return PS[key]
end
set_PS = function( key, val )
	PS[key] = val
end

reset_PS = function()
	--PS = {} --- обнулим текущие параметры
	--for k, v in pairs(PS) do
	--	PS[k] = v
	--end
	--menuUpdate()
end



function wtGetDesc(Safe, Name, recursive, flagDel) -- Получить описание виджета, при необходимость уничтожает виджет
	local wtSelectBuffColorSafe = Safe:GetChildChecked( Name, recursive )
	local wtSelectBuffColorDesc = wtSelectBuffColorSafe:GetWidgetDesc()
	if flagDel then
		wtSelectBuffColorSafe:DestroyWidget()
	end	
	return wtSelectBuffColorDesc
end

function OnEventIngameUnderCursorChanged( params )
	if params.deviceId then
		LogToChat(getKeySideTypeSlot(params.deviceId))
	end
end

function mainInit()
	fromGlobalConfig()
	--cannon pos stored in GlobalConfig may be incorrect - reset to default
	InitCannonPositions("League")
	fromConfig()
	GUIinit()
	
	myID = avatar.GetId()
	ShipPanelInit()
	ShortMap_Init()
	set_wtContextActions()

	RegisterEventHandlers( onEvent )
	RegisterReactionHandlers( onReact )
	if posDebug then
		common.RegisterEventHandler( OnEventIngameUnderCursorChanged, "EVENT_INGAME_UNDER_CURSOR_CHANGED")
	end
	AvatarShip()

	wtSetPlace( wtMainPanel, PS.initPlace or {} )
	onEvent["EVENT_DEVICES_CHANGED"](0);
	
	
	local wtContextShipPlate = (common.GetAddonMainForm( "ContextShipPlate" )):GetChildChecked( "Plate", false )
	local dscButtonCornerCrossShip = mainForm:GetChildChecked("dscButtonCornerCrossShip", false )
	
	dscButtonCornerCrossShip:Show(true)
	
	wtContextShipPlate:AddChild(dscButtonCornerCrossShip)
	dscButtonCornerCrossShip:SetPriority(25000)
	wtSetPlace(dscButtonCornerCrossShip, {highPosX = 308})
	
	local wwwwShipPanel = wtMainPanel:GetChildUnchecked( "ShipPanel", false )
	if wwwwShipPanel then
		local wwwwShipPanelRadar = wwwwShipPanel:GetChildUnchecked( "Radar", false )
		if wwwwShipPanelRadar then
			local wwwwShipPanelRadarButtonCornerCross = wwwwShipPanelRadar:GetChildUnchecked( "ButtonCornerCross", false )
			if wwwwShipPanelRadarButtonCornerCross then
				DnD.Init(wtMainPanel, wwwwShipPanelRadarButtonCornerCross, true)
			end
		end
		
		local wwwwShipPanelShip = wwwwShipPanel:GetChildUnchecked( "Ship", false )
		if wwwwShipPanelShip then
			local wwwwShipPanelShipButtonCornerCross = wwwwShipPanelShip:GetChildUnchecked( "ButtonCornerCross", false )
			DnD.Init(wtMainPanel, wwwwShipPanelShipButtonCornerCross, true)
		end
		
	end
	
	local wwwwShipPanel2 = wtMainPanel2:GetChildUnchecked( "ShipPanel2", false )
	if wwwwShipPanel2 then
		local wwwwShipPanelRadar2 = wwwwShipPanel2:GetChildUnchecked( "Radar", false )
		if wwwwShipPanelRadar2 then
			local wwwwShipPanelRadarButtonCornerCross2 = wwwwShipPanelRadar2:GetChildUnchecked( "ButtonCornerCross", false )
			if wwwwShipPanelRadarButtonCornerCross2 then
				DnD.Init(wtMainPanel2, wwwwShipPanelRadarButtonCornerCross2, true)
			end
		end
	end	
	--LogInfo("PS.ShipPlatePlace",PS.ShipPlatePlace)

end

--LogInfo("PS.ShipPlatePlace",PS)

if (avatar.IsExist()) then 
	mainInit()
else 
	common.RegisterEventHandler(mainInit, "EVENT_AVATAR_CREATED")	
end

