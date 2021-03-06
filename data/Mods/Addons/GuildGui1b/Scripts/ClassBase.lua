Global("ToWS", userMods.ToWString)
Global("FromWS", userMods.FromWString)
Global("localization", nil)

Global( "ClassColorsIcons", {
	["WARRIOR"]		= { r = 143/255; g = 119/255; b = 075/255; a = 1 },
	["PALADIN"]		= { r = 207/255; g = 220/255; b = 155/255; a = 1 },
	["STALKER"]		= { r = 150/255; g = 204/255; b = 086/255; a = 1 },
	["BARD"]		= { r = 106/255; g = 230/255; b = 223/255; a = 1 },
	["PRIEST"]		= { r = 255/255; g = 207/255; b = 123/255; a = 1 },
	["DRUID"]		= { r = 255/255; g = 118/255; b = 060/255; a = 1 },
	["PSIONIC"]		= { r = 221/255; g = 123/255; b = 245/255; a = 1 },
	["MAGE"]		= { r = 126/255; g = 159/255; b = 255/255; a = 1 },
	["NECROMANCER"]	= { r = 208/255; g = 069/255; b = 075/255; a = 1 },
	["ENGINEER"]	= { r = 140/255; g = 140/255; b = 120/255; a = 1 },
	["WARLOCK"]     = { r = 125/255; g = 101/255; b = 219/255; a = 1 },
	["UNKNOWN"]		= { r = 127/255; g = 127/255; b = 127/255; a = 1 },
} )

Global( "ClassColors", {
	["WARRIOR"]		= { r = 0.65; g = 0.54; b = 0.34; a = 1 },
	["PALADIN"]		= { r = 0.80; g = 1.00; b = 1.00; a = 1 },
	["STALKER"]		= { r = 0.00; g = 0.78; b = 0.00; a = 1 },
	["BARD"]		= { r = 0.00; g = 1.00; b = 1.00; a = 1 },
	["PRIEST"]		= { r = 1.00; g = 1.00; b = 0.31; a = 1 },
	["DRUID"]		= { r = 1.00; g = 0.50; b = 0.00; a = 1 },
	["PSIONIC"]		= { r = 1.00; g = 0.50; b = 1.00; a = 1 },
	["MAGE"]		= { r = 0.18; g = 0.57; b = 1.00; a = 1 },
	["NECROMANCER"]	= { r = 0.95; g = 0.17; b = 0.28; a = 1 },
	["ENGINEER"]	= { r = 0.55; g = 0.55; b = 0.47; a = 1 },
	["WARLOCK"]     = { r = 0.49; g = 0.39; b = 0.85; a = 1 },
	["UNKNOWN"]		= { r = 0.50; g = 0.50; b = 0.50; a = 1 },
} )

Global("Locales", {
	["rus"] = { 
	["ZoneSep"] = ", ",
	["Yes"] = "��",
	["TitleTXT2"] = "��",
	["TitleTXT1"] = "� �������",
	["Time_minute"] = "�.",
	["Time_hour"] = "�.",
	["Time_day"] = "�.",
	["TabardNone"] = "�������� �������",
	["TabardCommon"] = "��������� �������",
	["TabardChampion"] = "��������� �����������",
	["Tabard"] = "�������",
	["Sort_ZONE"] = "����",
	["Sort_WFAME"] = "�����",
	["Sort_TAB"] = "�",
	["Sort_RNK"] = "����",
	["Sort_NUM"] = "#",
	["Sort_NAME"] = "���",
	["Sort_MAUTH"] = "���. ���.",
	["Sort_MFAME"] = "���. ���.",
	["Sort_LVL"] = "��.",
	["Sort_LOY"] = "����.",
	["Sort_JOIN"] = "�������",
	["Sort_CLS"] = "�����",
	["Sort_AUTH"] = "���.",
	["Sort_ACT"] = "����������",
	["Sex1"] = "�������",
	["Sex0"] = "�������",
	["Sex"] = "���",
	["SeasonPrestige"] = "�����������: ",
	["Rnk11"] = "�� �������",
	["Rnk10"] = "�������",
	["Race"] = "����",
	["Offline"] = "��� ����",
	["No"] = "���",
	["NextLevel"] = ") �� ����������: ",
	["message8"] = "�������� � �������",
	["message7"] = "�����",
	["message6"] = "���������� � �������",
	["message5"] = "��������� �� ������",
	["message4"] = "����� �� �������",
	["message3"] = "�������",
	["message2"] = "���������",
	["message1"] = "���������� � ������",
	["ListAll2"] = "������",
	["ListAll1"] = "���",
	["GuildTabardsBonus"] = "����� �������: ",
	["GuildTabards2"] = "�����������: ",
	["GuildTabards1"] = "�������: ",
	["GuildTabards"] = "�������: ",
	["GuildNextLvl"] = "��������� ������� (",
	["GuildNextLv3"] = "������",
	["GuildNextLv2"] = "), ����: ",
	["GuildName"] = "��������: ",
	["GuildMoney"] = "������: ",
	["GuildMessage"] = "������� ���: ",
	["GuildMembers"] = "����������: ",
	["GuildLvl"] = "�������: ",
	["GuildLeader"] = "�����: ",
	["GuildInfo"] = "���������� � �������",
	["GuildEnable"] = "��������: ",
	["GuildDesc"] = "��������: ",
	["GuildCurr"] = "��������: ",
	["GuildAut"] = "���������: ",
	["Guild"] = "�������",
	["GBE"] = "�������� ������",
	["Friendship"] = "������",
	["Friend"] = "������",
	["Fame"] = "����� �����",
	["Export"] = "��������������",
	["Description"] = "�������������� ������ ������� � ������.",
	["DateYesterday"] = "�����",
	["DateToday"] = "�������",
	["DateSep"] = ".",
	["Comment"] = "�����������",
	["ExportLevel"] = "�������", 
	["ExportTabard"] = "�������",
	["ExportA"] = "���������",
	["ExportMA"] = "�������� ���������",
	["ExportFame"] = "�����������",
	["ExportMFame"] = "�������� �����������",
	["ExportLoy"] = "��������",
	["Champion"] = "�����������",
	["Common"] = "�������",
	["None"] = "���",
	["BannerTier1"] = "����� 1",
	["BannerTier2"] = "����� 2",
	["BannerTier3"] = "����� 3",
	["true"] = "��",
	["false"] = "���",
	["LongFame"] = "�����(�����)",
	["MediumFame"] = "�����(������)",
	["ShortFame"] = "�����(����)",
	["Symbols"] = "������� ���������",
	["LongSymbols"] = "������� ���������(�����)",
	["MediumSymbols"] = "������� ���������(������)",
	["ShortSymbols"] = "������� ���������(����)",
	["Balance"] = "������",
	},
		
	["eng_eu"] = {
	["ZoneSep"] = ", ",
	["Yes"] = "Yes",
	["TitleTXT2"] = "from",
	["TitleTXT1"] = "Online ",
	["Time_minute"] = "m.",
	["Time_hour"] = "h.",
	["Time_day"] = "d.",
	["TabardNone"] = "Take away tabard",
	["TabardCommon"] = "Accept Common",
	["TabardChampion"] = "Accept Champion",
	["Tabard"] = "Tabard",
	["Sort_ZONE"] = "Zone",
	["Sort_WFAME"] = "Fame",
	["Sort_TAB"] = "T",
	["Sort_RNK"] = "Rank",
	["Sort_NUM"] = "#",
	["Sort_NAME"] = "Name",
	["Sort_MAUTH"] = "M. aut.",
	["Sort_MFAME"] = "M. nob.",
	["Sort_LVL"] = "Lvl",
	["Sort_LOY"] = "Loy.",
	["Sort_JOIN"] = "Join",
	["Sort_CLS"] = "Class",
	["Sort_AUTH"] = "Aut.",
	["Sort_ACT"] = "Activity",
	["Sex1"] = "Female",
	["Sex0"] = "Male",
	["Sex"] = "Sex",
	["SeasonPrestige"] = "Prestige: ",
	["Rnk11"] = "�� �������",
	["Rnk10"] = "�������",
	["Race"] = "Race",
	["Offline"] = "Offline",
	["No"] = "No",
	["NextLevel"] = ") Next level: ",
	["message8"] = "Add to frieds",
	["message7"] = "Time",
	["message6"] = "Invite to the guild",
	["message5"] = "Exclude from list",
	["message4"] = "LEAVE GUILD",
	["message3"] = "Close",
	["message2"] = "Inspect",
	["message1"] = "Gruop invite",
	["ListAll2"] = "Online",
	["ListAll1"] = "All",
	["GuildTabardsBonus"] = "Tabards bonus: ",
	["GuildTabards2"] = "Champion: ",
	["GuildTabards1"] = "Common: ",
	["GuildTabards"] = "Tabards: ",
	["GuildNextLvl"] = "Next level (",
	["GuildNextLv3"] = "gold",
	["GuildNextLv2"] = "), price: ",
	["GuildName"] = "Name: ",
	["GuildMoney"] = "Money: ",
	["GuildMessage"] = "Message of day: ",
	["GuildMembers"] = "Members: ",
	["GuildLvl"] = "Level: ",
	["GuildLeader"] = "Leader: ",
	["GuildInfo"] = "Guild information",
	["GuildEnable"] = "Guild enable: ",
	["GuildDesc"] = "Description: ",
	["GuildCurr"] = "Currency: ",
	["GuildAut"] = "Autority: ",
	["Guild"] = "Guild",
	["GBE"] = "Change balance",
	["Friendship"] = "Friendship",
	["Friend"] = "Friends",
	["Fame"] = "All fame",
	["Export"] = "Export",
	["Description"] = "Alternative list of Friends and Guild.",
	["DateYesterday"] = "Yesterday",
	["DateToday"] = "Today",
	["DateSep"] = ".",
	["Comment"] = "Comment",
	["ExportLevel"] = "Level", 
	["ExportTabard"] = "Tabard",
	["ExportA"] = "Autority",
	["ExportMA"] = "Maunth authority",
	["ExportFame"] = "Nobility",
	["ExportMFame"] = "Mounth Nobility",
	["ExportLoy"] = "Loyality",
	["BannerTier1"] = "Banner 1",
	["BannerTier2"] = "Banner 2",
	["BannerTier3"] = "Banner 3",
	["true"] = "Yes",
	["false"] = "No",
	}
})

localization = common.GetLocalization()

function L( strTextName )
	return Locales[ localization ][ strTextName ] or Locales[ "eng_eu" ][ strTextName ] or strTextName
end
