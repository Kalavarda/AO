Global("currentLocalization", nil)
Global("Locales", {
	["rus"] = { -- Russian, Win-1251
--- TREASURY
	[ "pcs." ] = "��.",
	["TREASURY: Here is empty"] = "������������: ��� �����",
	[ "TREASURY: The number of chests on board is: " ] = "������������: ����� ����� �� �����: ",
	[ "This might be a cargo items:" ] = "��� ����� ���� ���� �� �����:",
-- info
	[ "Damage: " ] = "����: ",
--- radar
	[ "  DIST:" ] = "  �����:",
	[ "m" ] = "�",
	[ "EDGE" ] = "����",
	[ "HUB Edge Point �" ] = "������� ����� �",
--- menu
	[ "COMMANDS" ] = "��������",
	[ "SETTINGS" ] = "���������",
	[ "Load Settings" ] = "��������� ���������",
	[ "Save Settings" ] = "��������� ���������",
	[ "Save" ] = "��������� ���������, ������������ �����...",

	[ "Test Device Place" ] = "������ ����� ����������",
	[ "For test any device Place on the board - to set 'ON' and use the device." ] = "��� ����������� ����� ���������� - ���������� '���' � ������������ ����������.",
	[ "Radar Scale" ] = "������� ������",
	[ "RadarScale" ] = "����. �������� ������(X / ���� ����.)",
	[ "Radar Power koeff" ] = "����������� ������� ������",
	[ "RadarLg" ] = "����. �������� ������(X � ������� ���� ����.)",
	[ "RadarEdge" ] = "���������� ������� �����",
	[ "Mobs Radar Radius" ] = "������ ��� ����� �� ������",
	[ "DistMobs1" ] = "������ ��� ����� �� ������",
	[ "dSizeX" ] = "������ �� ����������� ��� ������ �����",
	[ "dSizeY" ] = "������ �� ��������� ��� ������ �����",
	[ "Ship Over Heat" ] = "��������",
	[ "overHeat" ] = "����� ��������� (%)",
	[ "EngineSizeX" ] = "������ ���� ���������",
	[ "EngineSizeY" ] = "������ ���� ���������",
	[ "HullWide" ] = "������ ������� �������",
	[ "HullSizeY" ] = "������ �������",
	[ "Show Over Map" ] = "���������� ��� ������",
	[ "OverMapShow" ] = "���������� ��� ������ (��������� PopUpChatPro)",
	[ "Cannon Target Icon" ] = "��� ������� �� �������",
	[ "CannonAim" ] = "��� ������� �� �������(system - ���������� ����)",
	[ "Over Map Place" ] = "������� ���� ��� ������",
	[ "Select by double click" ] = "��������� ���� ������� ������",
	[ "EnableSelectDblClk" ] = "��������� ���� ������� ������",
	[ "Use red / green highlight" ] = "������� ��������� �������� � �����",
	[ "ColoredFontSwitch" ] = "������� ��������� �������� � �����",
	[ "TogetherMode" ] = "����������� ����� ����� � �������",

	[ "List Devices to mods.txt" ] = "������ ��������� � mods.txt",
	[ "'mainForm' Priority" ] = "��������� 'mainForm'",
	[ "list Texts to mod.txt" ] = "������ ����� � mod.txt",

	[ "Inteface Priority" ] = "��������� ����������",
	[ "prior" ] = "��������� ���������� (�������� ������)",
	[ "Reset to Config.txt" ] = "����� �������� �� Config.txt",
	[ "window Offset when map open" ] = "�������� ��� ���� ������ ��� ������ ��� ������ ����",
	[ "MaxMapRadius" ] = "����������� ���������� ������ �����",
	[ "HighlightTarget" ] = "�������� ����",

--- constants
	[ "ON" ] = "���",
	[ "true" ] = "���",
	[ "OFF" ] = "����",
	[ "false" ] = "����",

-- messages
	[ "loaded" ] = "���������",
	[ "started" ]  = "��������",

	[ "TREASURY: the number of chests on board is %d pieces. " ] =  "������������: ���������� �������� �� ����� %d ����. ",
	[ "ASTROLABE: readiness through %s. " ] = "����������: ���������� ����� %s. ",
	[ " on ship: "] = " �� �������: ",
	[ "find hidden Ship" ] = "��������� �������",
	[ "Find Ship: " ] = "��������� �������: ",
	[ "Empire"] = "�������",
	[ "League"] = "����",
	[ "Friend"] = "����",
	[ "Enemy"] = "����",
	[ "Stabilization of Anomalous Matter"] = "������������ ���������� �������",
	[ "Captured Anomalous Matter"] = "����������� ���������� �������",
	["������� �������� �� %d"] = "������� �������� �� %d",

-- ship tip
	["ship_gearscore"] = "�������",
	["ship_hull_generation"] = "��������� �������",
	},
		
	["eng_eu"] = { -- English, Latin-1
	--- TREASURY
	[ "pcs." ] = "��.",
	["TREASURY: Here is empty"] = "Treasury: empty",
	[ "TREASURY: The number of chests on board is: " ] = "Treasury: chests on board - ",
	[ "This might be a cargo items:" ] = "It could be a cargo item:",
-- info
	[ "Damage: " ] = "Damage: ",
--- radar
	[ "  DIST:" ] = "  Distance:",
	[ "m" ] = "m",
	[ "EDGE" ] = "Edge",
	[ "HUB Edge Point �" ] = "Edge point No.",
--- menu
	[ "COMMANDS" ] = "COMMANDS",
	[ "SETTINGS" ] = "SETTINGS",
	[ "Load Settings" ] = "Load Settings",
	[ "Save Settings" ] = "Save Settings",
	[ "Save" ] = "Settings saved, reloading addon...",

	[ "Test Device Place" ] = "Find out the location of the device",
	[ "For test any device Place on the board - to set 'ON' and use the device." ] = "To determine the location of the device - set 'On' and use the device.",
	[ "Radar Scale" ] = "Radar Scale",
	[ "RadarScale" ] = "Radar Scale",
	[ "Radar Power koeff" ] = "Radar degree coefficient",
	[ "RadarLg" ] = "Radar degree coefficient",
	[ "RadarEdge" ] = "Number of edge points",
	[ "Mobs Radar Radius" ] = "Radar for Mobs on Radar",
	[ "DistMobs1" ] = "Radar for Mobs on Radar",
	[ "dSizeX" ] = "Horizontal offset from the edge",
	[ "dSizeY" ] = "Vertical offset from the edge",
	[ "Ship Over Heat" ] = "Overheat",
	[ "overHeat" ] = "Overheat",
	[ "EngineSizeX" ] = "Horizontal motor size",
	[ "EngineSizeY" ] = "Vertical motor size",
	[ "HullWide" ] = "Hull width",
	[ "HullSizeY" ] = "Hull height",
	[ "Show Over Map" ] = "Show above the map",
	[ "OverMapShow" ] = "Show above the map",
	[ "Cannon Target Icon" ] = "canon target icon",
	[ "CannonAim" ] = "View of the sight on the ship",
	[ "Over Map Place" ] = "Position of the Window above the map",
	[ "Select by double click" ] = "Selecting a target with a double click",
	[ "EnableSelectDblClk" ] = "Selecting a target with a double click",
	[ "Use red / green highlight" ] = "Colored illumination of misses and critical",
	[ "ColoredFontSwitch" ] = "Colored illumination of misses and critical",
	[ "TogetherMode" ] = "Combined map and ship mode",

	[ "List Devices to mods.txt" ] = "List of devices in mods.txt",
	[ "'mainForm' Priority" ] = "Priority 'mainForm'",
	[ "list Texts to mod.txt" ] = "List of strings in mod.txt",

	[ "Inteface Priority" ] = "Interface priority",
	[ "prior" ] = "Interface priority",
	[ "Reset to Config.txt" ] = "Reset settings to Config.txt",
	[ "window Offset when map open" ] = "Offset for the addon window when displayed above the game map",
	[ "MaxMapRadius" ] = "Max Map Radius ",
	[ "HighlightTarget" ] = "Highlight target",

--- constants
	[ "ON" ] = "ON",
	[ "true" ] = "On",
	[ "OFF" ] = "Off",
	[ "false" ] = "Off",

-- messages
	[ "loaded" ] = "loaded",
	[ "started" ]  = "launched",

	[ "TREASURY: the number of chests on board is %d pieces. " ] =  "Treasury: number of chests on board %d.",
	[ "ASTROLABE: readiness through %s. " ] = "Astrolabe: readiness through %s. ",
	[ " on ship: "] = " on the ship: ",
	[ "find hidden Ship" ] = "ship found",
	[ "Find Ship: " ] = "Ship detected: ",
	[ "Empire"] = "Empire",
	[ "League"] = "League",
	[ "Friend"] = "Friend",
	[ "Enemy"] = "Enemy",
	[ "Stabilization of Anomalous Matter"] = "Stabilization of Anomalous Matter",
	[ "Captured Anomalous Matter"] = "Captured Anomalous Matter",
	["������� �������� �� %d"] = "Reactor load at %d",

-- ship tip
	["ship_gearscore"] = "Rating",
	["ship_hull_generation"] = "Hull generation",
	}
})

currentLocalization = common.GetLocalization()

function L( strTextName )
	return Locales[ currentLocalization ][ strTextName ] or Locales[ "eng_eu" ][ strTextName ] or strTextName
end