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
	[ "Save" ] = "��������� ���������, ������������� �����",

	[ "Test Device Place" ] = "������ ����� ����������",
	[ "For test any device Place on the board - to set 'ON' and use the device." ] = "��� ����������� ����� ���������� - ���������� '���' � ������������ ����������.",
	[ "Radar Scale" ] = "������� ������",
	[ "RadarScale" ] = "������� ������",
	[ "Radar Power koeff" ] = "����������� ������� ������",
	[ "RadarLg" ] = "����������� ������� ������",
	[ "RadarEdge" ] = "���� ������",
	[ "Mobs Radar Radius" ] = "������ ��� ����� �� ������",
	[ "DistMobs1" ] = "������ ��� ����� �� ������",
	[ "dSizeX" ] = "������ �� ���� �� �����������",
	[ "dSizeY" ] = "������ �� ���� �� ���������",
	[ "Ship Over Heat" ] = "��������",
	[ "overHeat" ] = "��������",
	[ "EngineSizeX" ] = "������ ��������� �� �����������",
	[ "EngineSizeY" ] = "������ ��������� �� ���������",
	[ "HullWide" ] = "������ �������",
	[ "HullSizeY" ] = "������ �������",
	[ "Show Over Map" ] = "���������� ��� ������",
	[ "OverMapShow" ] = "���������� ��� ������",
	[ "Cannon Target Icon" ] = "��� ������� �� �������",
	[ "CannonAim" ] = "��� ������� �� �������",
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
	[ "prior" ] = "��������� ����������",
	[ "Reset to Config.txt" ] = "����� �������� �� Config.txt",
	[ "window Offset when map open" ] = "�������� ��� ���� ������ ��� ������ ��� ������ ����",

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
	},
		
	["eng_eu"] = { -- English, Latin-1
    ["TREASURY: Here is empty"] = "TREASURY: Here is empty",
	}
})

currentLocalization = common.GetLocalization()

function L( strTextName )
	return Locales[ currentLocalization ][ strTextName ] or Locales[ "eng_eu" ][ strTextName ] or strTextName
end