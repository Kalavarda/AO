Global("SizePanels", {})
Global("Font", {})
---------------------------------------------------------------
--	ПАНЕЛЬ ПИТОМЦЕВ (ФАНТОМЫ, МЕХАНИЗМЫ)
---------------------------------------------------------------
--	Ширина панели
SizePanels.MainX = 170

--	Высота заголовка
SizePanels.MainY = 30

--	Высота каждого питомца
SizePanels.Y = 30

--	Размер шрифта зоголовка
SizePanels.SizeFont = 12

--	Размер шрифта таймера
SizePanels.TimerFontSize = 18

--	Размер шрифта имени питомца
SizePanels.NameFontSize = 12


---------------------------------------------------------------
--	ПАНЕЛЬ КЛАССОВЫХ РЕСУРСОВ
---------------------------------------------------------------
-- Размер шрифта
Font.Size = 50

-- Некромант. Стиль шрифта
Font.NecromancerStyle = "WarningLogRed"

-- Лучник. Стиль шрифта
Font.StalkerStyle = "Quest"

-- Жрец. Стиль шрифта
Font.PriestStyle = "WarningLogYellow"

-- Бард. Стиль шрифта
Font.BardStyle = "StatFairyBonus"

-- Паладин. Канон света. Стиль шрифта
Font.PaladinLightCanonStyle = "Relic"

-- Паладин. Канон чистоты. Стиль шрифта
Font.PaladinPurityCanonStyle = "WarningLogWhite"

-- Воин. Стиль шрифта
Font.WarriorStyle = "IMPriceLocked"

-- Друид. Стиль шрифта
Font.DruidStyle = "LogColorBlue"

-- Инженер. Стиль шрифта. Температура выше нуля
Font.EngineerPlusStyle = "WarningLogRed"

-- Инженер. Стиль шрифта. Температура ниже нуля
Font.EngineerMinusStyle = "WarningLogBlue"

-- Инженер. Стиль шрифта. Нулевая температура
Font.EngineerZeroStyle = "WarningLogWhite"

-- Мистик. Стиль шрифта. Стресс больше 80
Font.Psionic80Style = "DamageVisHpDrain"

-- Мистик. Стиль шрифта. Стресс бменьше 80
Font.PsionicStyle = "LogColorMagenta"

-- Маг. Стихии Льда. Стиль шрифта
Font.MageIceInstability = "DamageBlue"

-- Маг. Стихии Огня. Стиль шрифта
Font.MageFireInstability = "DamageRed"

-- Маг. Стихии Молний. Стиль шрифта
Font.MageEnergyInstability = "navigator"

-- Демонолог. Стиль шрифта
Font.WarlockStyle = "LogColorSlateBlue"



---------------------------------------------------------------
--	ВСЕ ВОЗМОЖНЫЕ СТИЛИ ТЕКСТА
---------------------------------------------------------------
--[[
"DamageVisDp"
"Quest"
"CombatCyan"
"StatControl"
"WarningLogOrange"
"StatAdditionalColor"
"WarningLogYellow"
"EditLineCenterSmall"
"SecretCompleteFormat"
"EditLineGlobal"
"tip_blue"
"WarningLogBlue"
"StatFairyBonus"
"DamageVisMiss"
"log_blue"
"DamageVisBuffGain"
"WarningLogRed"
"CombatRed"
"ColorWarmYellow"
"DamageVisExpGain"
"LogColorBlue"
"CombatBlue"
"EditLineSelectionCenterSmall"
"ColorWarmGreen"
"StatDebuffed"
"log_orange"
"log_yellow"
"calendar"
"StatUselessColor"
"ColorYellow"
"p2p"
"EpicCursed"
"QuestLogRed"
"tutorRed"
"LogColorLightRed"
"Label"
"tip_purple"
"YellowQuestName"
"IMPriceLocked"
"YellowQuestTimer"
"StatDefenceColor"
"ReputationEnemy"
"tutorGold"
"WarningLogWhite"
"CreditsText"
"Raid"
"SecretIncompleteFormat"
"RepConfidential"
"ColorDarkWarmGreen"
"RelicWithoutShadow"
"OutlineOnPaper"
"EditLineMoneyCountSelection"
"log_magenta"
"IMPrice"
"nav_avatar"
"body"
"ColorBlack"
"CombatLightYellow"
"DamageWhite"
"QuestLogGray"
"LabelCenterSmall8"
"DamageVisEnergyDrain"
"EditLinePageCountSelection"
"ColorWarmRed"
"GrayQuestName"
"LabelCenterGoldSmall"
"tip_red"
"log_violet"
"DamageYellow"
"WarningLogGreen"
"DamageVisMpDrain"
"CoinSettings"
"nav_enemy"
"SubscribeNormal"
"StatPrimaryColor"
"QuestLogNormal"
"p"
"tip_base"
"tip_white"
"ColorMagenta"
"DamageVisBarrier"
"Rare"
"DamageGreen"
"DamageVisReputationDrain"
"LogColorPink"
"DamageVisBlock"
"log_brown"
"Common"
"RepKindly"
"DamageRed"
"Legendary"
"tutorGrey"
"WhiteQuestName"
"ReputationNeutral"
"default"
"ColorCian"
"StatUseless"
"CreditsHeader"
"ListItemSelected"
"LogColorMagenta"
"QuestFailedOnPaper"
"OnPaper"
"LogColorBlack"
"LegendaryCursed"
"tip_green"
"Subtitle"
"tutorCian"
"log_white"
"SecretInProgressFormat"
"ColorWhite"
"LogColorLightGreen"
"LegendaryWithoutShadow"
"QuestLogGreen"
"DamageBlue"
"RelicCursed"
"TabNormal"
"Golden"
"LabelCenterRedSmall8"
"DamageVisHpDrain"
"DamageVisHpGain"
"tutorLink"
"ColorMidWarmGreen"
"LabelCenterSmall"
"QuestLogBlue"
"tip_golden"
"ReputationKindly"
"log_light_yellow"
"ColorBlue"
"Goods"
"DamageVisBarrierGain"
"LogColorBrown"
"log_green"
"ColorGreen"
"LogColorSlateBlue"
"f2p"
"AllodsSystem"
"SubscribeWarning"
"tutorBlue"
"EditLineOnPaper"
"Neutral"
"QuestProgressPercent"
"DamageVisCriticalDrain"
"alignRight"
"RepEnemy"
"EditLineGlobalCenter"
"GoodsCursed"
"LogColorWhite"
"CombatWhite"
"html"
"QuestCompleteOnPaper"
"br"
"PartyQuestName"
"AllodsFantasy"
"label"
"ColorLightBrown"
"bodysmall"
"alignJustify"
"HeaderOnPaper"
"RaidQuestName"
"tutorWhite"
"FullCollectionColor"
"DamageVisMpGain"
"Outline"
"navigator"
"DamageVisReputationGain"
"RedQuestTimer"
"LogColorGreen"
"CombatGreen"
"log"
"Aggressive"
"EditLineMailOnPaper"
"tip_button"
"Spouse"
"log_red"
"CommonCursed"
"tutorPurple"
"LogColorRed"
"EditLineSelection"
"StatAdditional"
"StatControlColor"
"log_dark_white"
"alignLeft"
"tutorGreen"
"StatBuffed"
"DamageVisParry"
"nav_friend"
"button"
"WhiteSubtask"
"EditLinePageCount"
"StatNormal"
"BlueQuestTimer"
"RepNeutral"
"LogColorOrange"
"IMPriceDisabled"
"LogColorYellow"
"StatDefence"
"GraySubtask"
"Relic"
"CollectionColor"
"log_dark_green"
"LogColorGold"
"ColorGray40"
"shortcut"
"disabled"
"ColorLightBeige"
"ColorGray50"
"Uncommon"
"Friendly"
"QuestLogOrange"
"ColorGray60"
"QuestLogYellow"
"DamageVisEnergyGain"
"nav_dead"
"DamageVisDodge"
"RedQuestName"
"DamageVisAbsorb"
"CombatOrange"
"TabSelected"
"Party"
"CombatYellow"
"Dead"
"RareCursed"
"RepFriendly"
"RepHostility"
"LabelCenterRedSmall"
"ReputationFriendly"
"tip_grey"
"ReputationHostility"
"LogColorViolet"
"RepUnfriendly"
"alignCenter"
"UncommonCursed"
"DamageVisResist"
"QuestProgressFullPercent"
"Size10"
"Size11"
"Avatar"
"Size12"
"Size13"
"Size14"
"ListItemNormal"
"ColorRed"
"Size20"
"Size15"
"Size16"
"header"
"highlighted"
"Size22"
"Size17"
"TabDisabled"
"Size18"
"CoinSettingsRed"
"Size24"
"ReputationConfidential"
"EditLineMoneyCount"
"JunkCursed"
"GreenQuestName"
"DarkGreenQuestName"
"StatPrimary"
"Epic"
"log_cyan"
"LogColorCian"
"ReputationUnfriendly"
"nav_neutral"
"Junk"
]]--