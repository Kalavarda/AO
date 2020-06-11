--------------------------------------------------------------------------------
-- GLOBALS ��� �������� �� config.txt
-------------------------
Global("ADDONname", common.GetAddonName() )
Global("dsc", menuDscInit(mainForm) )
Global( "ON", "ON" )
Global( "OFF", "OFF" )
Global( "names", {
	[ON] = "ON",
	[OFF] = "OFF",
})

Global( "Targets",  {
"system",
"OrkAura01Glow",
"CannonAim",
"CannonAim2",
})

Global("Options", {})
Global( "USDEV_TREASURE", 99 ) -- empty in API
Global( "USDEV_ASTROLABE", 98 ) -- empty in API

Global( "PS", { --parameters
	prior = 10000,
	overHeat = 70,
	DistMobs1 = 1300,
	ShipPlatePlace = { sizeX = 200, alignX = 0, sizeY = 270, alignY = 0},
	dSizeX = 180, -- ������� �� ��������� ������� - ��� ����-����� � ������ �����
	dSizeY = 150, -- ������� �� ��������� �������
	EngineSizeX = 20,
	EngineSizeY = 80,
	HullWide = 30,
	HullSizeY = 100,

	TextSize = { sizeX = 40, sizeY = 30 },
	OverMapShow = true,
	EnableSelectDblClk = true,
	ColoredFontSwitch = true,
	TogetherMode = false,
	OverMapPlace = { posX = 1200, posY = 100},
	RadarEdge = 70,
	RadarScale = 1,
	RadarLg = 0.7,
	CannonAim = "CannonAim2", --"system" "OrkAura01Glow"  "CannonAim"  "CannonAim2" "sysCannonAim2"
	ControlSlots = {
	['2:'..USDEV_SHIELD..':1'] = { place = { alignY = 0, posY = 0, alignX = 2, posX = 0 }, icon = "-" }, -- shield 
	['3:'..USDEV_SHIELD..':1'] = { place = { alignY = 1, highPosY = 0, alignX = 2, posX = 0 }, icon = "-" }, -- shield 

	['4:'..USDEV_SHIELD..':1'] = { place = { alignY = 1, highPosY = 60, alignX = 0, posX = 0 }, }, -- shield 
	['4:'..USDEV_SHIELD..':2'] = { place = { alignY = 0, posY = 60, alignX = 0, posX = 0 }, }, -- shield 
	['5:'..USDEV_SHIELD..':1'] = { place = { alignY = 1, highPosY = 60, alignX = 1, highPosX = 0 }, }, -- shield 
	['5:'..USDEV_SHIELD..':2'] = { place = { alignY = 0, posY = 60, alignX = 1, highPosX = 0 }, }, -- shield 


	--CANNON BEAMS
	['2:'..USDEV_BEAM_CANNON..':1'] = { place = { alignY = 0, posY = 0, alignX = 2, posX = -30, sizeY = 60 }, icon = "Beam", iconPlace = { sizeX=20, sizeY=nil} }, -- artillery
	['2:'..USDEV_BEAM_CANNON..':2'] = { place = { alignY = 0, posY = 0, alignX = 2, posX = 30, sizeY = 60 }, icon = "Beam", iconPlace = { sizeX=20, sizeY=nil} }, -- artillery

	['0:'..USDEV_NAVIGATOR..':1'] = { place = { alignY = 0, posY = 30, alignX = 2, posX = 0, sizeY = 28, sizeX = 205 }, actions = 9, priority = 10 },

	--CANNONS left
	['4:'..USDEV_CANNON..':1'] = { place = { alignY = 0, posY = 85, alignX = 0, posX = 20, sizeX=35 }, icon = "LCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['4:'..USDEV_CANNON..':2'] = { place = { alignY = 0, posY = 110, alignX = 0, posX = 20 }, icon = "LCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['4:'..USDEV_CANNON..':3'] = { place = { alignY = 0, posY = 135, alignX = 0, posX = 20 }, icon = "LCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['4:'..USDEV_CANNON..':4'] = { place = { alignY = 0, posY = 160, alignX = 0, posX = 20 }, icon = "LCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['4:'..USDEV_CANNON..':8'] = { place = { alignY = 0, posY = 150, alignX = 0, posX = 50 }, icon = "LCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['4:'..USDEV_CANNON..':7'] = { place = { alignY = 0, posY = 125, alignX = 0, posX = 50 }, icon = "LCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['4:'..USDEV_CANNON..':6'] = { place = { alignY = 0, posY = 105, alignX = 0, posX = 50 }, icon = "LCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['4:'..USDEV_CANNON..':5'] = { place = { alignY = 0, posY = 80, alignX = 0, posX = 50 }, icon = "LCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon

	['4:'..USDEV_CANNON..':9'] = { place = { alignY = 0, posY = 60, alignX = 0, posX = 30 }, icon = "LCannon", iconPlace = { sizeX = nil, sizeY=20, } },  -- cannon

	['4:'..USDEV_CANNON..':10'] = { place = { alignY = 1, highPosY = 20, alignX = 0, posX = 35 }, icon = "LCannon", iconPlace = { sizeX = nil, sizeY=20, } },  -- cannon

	--CANNONS right
	['5:'..USDEV_CANNON..':1'] = { place = { alignY = 0, posY = 85, alignX = 1, highPosX = 20 }, icon = "RCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['5:'..USDEV_CANNON..':2'] = { place = { alignY = 0, posY = 110, alignX = 1, highPosX = 20 }, icon = "RCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['5:'..USDEV_CANNON..':3'] = { place = { alignY = 0, posY = 135, alignX = 1, highPosX = 20 }, icon = "RCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['5:'..USDEV_CANNON..':4'] = { place = { alignY = 0, posY = 160, alignX = 1, highPosX = 20 }, icon = "RCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['5:'..USDEV_CANNON..':5'] = { place = { alignY = 0, posY = 80, alignX = 1, highPosX = 50 }, icon = "RCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['5:'..USDEV_CANNON..':6'] = { place = { alignY = 0, posY = 105, alignX = 1, highPosX = 50 }, icon = "RCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['5:'..USDEV_CANNON..':7'] = { place = { alignY = 0, posY = 125, alignX = 1, highPosX = 50 }, icon = "RCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon
	['5:'..USDEV_CANNON..':8'] = { place = { alignY = 0, posY = 150, alignX = 1, highPosX = 50 }, icon = "RCannon", iconPlace = { sizeX = nil, sizeY=20, } }, -- cannon

	['5:'..USDEV_CANNON..':9'] = { place = { alignY = 0, posY = 60, alignX = 1, highPosX = 30 }, icon = "RCannon", iconPlace = { sizeX = nil, sizeY=20, } },  -- cannon

	['5:'..USDEV_CANNON..':10'] = { place = { alignY = 1, highPosY = 20, alignX = 1, highPosX = 35 }, icon = "RCannon", iconPlace = { sizeX = nil, sizeY=20, } },  -- cannon

	-------------------------
	['0:'..USDEV_REPAIR..':1'] = { place = { alignY = 2, posY = -34, alignX = 2, posX = 0 } }, -- technicians Goblin
	['0:'..USDEV_REPAIR..':2'] = { place = { alignY = 2, posY = -17, alignX = 2, posX = 0 } }, -- technicians Goblin
	['0:'..USDEV_REPAIR..':3'] = { place = { alignY = 2, posY = 0, alignX = 2, posX = 0 } }, -- technicians Goblin

	['0:'..USDEV_REACTOR..':1'] = { place = { alignY = 2, posY = 40, alignX = 2, posX = 0, sizeY = 20 }, actions = 3, icon = "-" }, -- reactor

	['3:'..USDEV_RUDDER..':1'] = { noActions = true, place = { alignY = 1, highPosY = 45, alignX = 2, posX = 45, sizeX=40, sizeY=40 }, icon = "Helm" }, -- wheel drive

	['3:'..USDEV_ENGINE_HORIZONTAL..':1'] = { place = { alignY = 1, highPosY = 50, alignX = 2, posX = 0, sizeX = nil, sizeY=nil }, icon = "Drive", rotate=0, iconPlace = { sizeX=45, sizeY=40, }}, -- motor

	['3:'..USDEV_ENGINE_VERTICAL..':1'] = { noActions = true, place = { alignY = 1, highPosY = 50, alignX = 2, posX = -45 }, icon = "VDrive", rotate=180 }, -- turbine  - vertical motor

	['0:'..USDEV_SCANER..':1'] = { place = { alignY = 1, highPosY = 25, alignX = 2, posX = 0 }, onlyActions = { 6 }  }, -- detector - navigator
	
	-- it's USDEV_TREASURE
	--- ��� ���������������� ����
	['0:'..USDEV_TREASURE..':1'] = { place = { alignY = 2, posY = 20, alignX = 2, posX = 0 }, user = true,
		},
	['0:'..USDEV_ASTROLABE..':1'] = { place = { alignX = 0, alignX = 0 }, user = true,
		textFormat = "<html alignx='center' fontsize='16' outline='1'><tip_green><r name='value'/></tip_green></html>",
		tip = "ASTROLABE: readiness through %s. ",
		valFunc = "getTimeStr",
		},
	},
	ShieldsPlace = {
	['2:'..USDEV_SHIELD..':1'] = { pan = { alignY = 0, alignX = 2, sizeX = 130, sizeY = 60, posX = -0, posY = -0 },
		sld = { alignX = 2, sizeX = 130, alignY = 0, sizeY = 60}, var="sizeX", place = "Head" }, -- shield
	['3:'..USDEV_SHIELD..':1'] = { pan = { alignY = 1, alignX = 2, sizeX = 130, sizeY = 70, posX = -0, highPosY = -20 },
		sld = { alignX = 2, sizeX = 130, alignY = 1, sizeY = 60}, var="sizeX", place = "Rear" }, -- shield

	['4:'..USDEV_SHIELD..':2'] = { pan = { alignY = 0, posY = 30, alignX = 0, posX = 0, sizeY = 100, sizeX = 40 },
		sld = { alignX = 0, alignY = 0, sizeX = 50, posX = 0, sizeY = 200, posY = 10 }, var="sizeY", place = "Left" }, -- shield
	['4:'..USDEV_SHIELD..':1'] = { pan = { alignY = 1, highPosY = 30, alignX = 0, posX = 0, sizeY = 100, sizeX = 40 },
		sld = { alignX = 0, alignY = 1, sizeX = 50, posX = 0, sizeY = 200, highPosY = 10 }, var="sizeY", place = "Left" }, -- shield

	['5:'..USDEV_SHIELD..':2'] = { pan = { alignY = 0, posY = 30, alignX = 1, highPosX = -0, sizeY = 100, sizeX = 40 },
		sld = { alignX = 1, alignY = 0, sizeX = 50, highPosX = -10, sizeY = 200, posY = 10 }, var="sizeY", place = "Right" }, -- shield
	['5:'..USDEV_SHIELD..':1'] = { pan = { alignY = 1, highPosY = 30, alignX = 1, highPosX = -0, sizeY = 100, sizeX = 40 },
		sld = { alignX = 1, alignY = 1, sizeX = 50, highPosX = -10, sizeY = 200, highPosY = 10 }, var="sizeY", place = "Right" }, -- shield
	},
	ShowDamage = {
	[SHIP_SIDE_FRONT] = {},
	[SHIP_SIDE_REAR] = {},
	[SHIP_SIDE_LEFT] = {},
	[SHIP_SIDE_RIGHT] = {},
	},
	
 } )

--- localize name of 'chest'
Global( "chestNameLoc", {
	[ "eng" ] = {"chest"},
	[ "rus" ] = {"������", "�����", "��������", "���������", "������", "����", "�����", "�������", "����", "����", "����", "����"},
	} )
	

	
function writeSettingsLog(name,pttttt)
	local isc = {
		[ "ControlSlots" ] = true,
		[ "ShieldsPlace" ] = true,
	}
	if pttttt then
		LogInfo("start --"..name.."-- pttttt")
		
		local dddd = {}
		
		for key, value in pairs(pttttt) do
			if isc[key] then
			
			else
				dddd[key] = value
			end
		end
		
		LogInfo(dddd)
		
		LogInfo("end --"..name.."-- pttttt")
	else
		LogInfo("pttttt = nil")
	
	end

end
	