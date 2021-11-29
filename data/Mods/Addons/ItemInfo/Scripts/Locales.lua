local ToWString = userMods.ToWString

Global("locales", {})
--------------------------------------------------------------------------------
-- Russian
--------------------------------------------------------------------------------

locales["rus"]={}

--------------------
-- option names --
--------------------

locales["rus"][ "IIStatus1" ] = ToWString("Дополнение включено")

locales["rus"][ "IIOptionTime1" ] = ToWString("Менять на «Скоро исчезнет» за")
locales["rus"][ "IIOptionTime2" ] = ToWString("Стиль «Скоро исчезнет»")
locales["rus"][ "IIOptionTime3" ] = ToWString("Обычный стиль")
locales["rus"][ "IIOptionTime4" ] = ToWString("Уведомление о исчезающих предметах на экране")

locales["rus"][ "IIOptionCompassInsignia1" ] = ToWString("Показать уровень на компасах")
locales["rus"][ "IIOptionCompassInsignia2" ] = ToWString("Показать процент на обычных и упакованных инсигниях")
locales["rus"][ "IIOptionCompassInsignia3" ] = ToWString("Стиль на компасах и инсигниях")

locales["rus"][ "IIOptionGear1" ] = ToWString("Показывать на экипировке в сумке и банке")
locales["rus"][ "IIOptionGear2" ] = ToWString("Показывать на надетых экипировке и артефактах")
locales["rus"][ "IIOptionGear3" ] = ToWString("Стиль на экипировке")
locales["rus"][ "IIOptionGear4" ] = ToWString("Стиль на артефактах")

--------------------
-- category names --
--------------------

locales["rus"][ "IIStatus" ] = ToWString("Статус")
locales["rus"][ "IICategoryTime" ] = ToWString("Исчезающие предметы")
locales["rus"][ "IICategoryCompassInsignia" ] = ToWString("Компасы и инсигнии")
locales["rus"][ "IICategoryGear" ] = ToWString("Экипировка и артефакты")

--------------------
-- header --
--------------------

locales["rus"][ "Settings" ] = ToWString("Настройки Item Info")

--------------------
-- buttons --
--------------------

locales["rus"][ "Apply" ] = ToWString("Применить")
locales["rus"][ "Ok" ] = ToWString("Ок")
locales["rus"][ "Default" ] = ToWString("Сбросить")
locales["rus"][ "Cancel" ] = ToWString("Отмена")

--------------------
-- others --
--------------------
locales["rus"][ "timerListThresholdLow" ] = {"1ч","2ч","4ч","6ч","12ч","24ч","48ч"}

--------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------

locales["eng_eu"]={}

--------------------
-- option names --
--------------------

locales["eng_eu"][ "IIStatus1" ] = ToWString("Addon Active")

locales["eng_eu"][ "IIOptionTime1" ] = ToWString("Threshold - Expire Soon")
locales["eng_eu"][ "IIOptionTime2" ] = ToWString("Expire Soon - style")
locales["eng_eu"][ "IIOptionTime3" ] = ToWString("Time Label - style")
locales["eng_eu"][ "IIOptionTime4" ] = ToWString("Time low notify on screen")

locales["eng_eu"][ "IIOptionCompassInsignia1" ] = ToWString("Show Compass Level")
locales["eng_eu"][ "IIOptionCompassInsignia2" ] = ToWString("Show Insignia Percentage")
locales["eng_eu"][ "IIOptionCompassInsignia3" ] = ToWString("Compass and Insignia - style")

locales["eng_eu"][ "IIOptionGear1" ] = ToWString("On Equipment in Bag and Bank")
locales["eng_eu"][ "IIOptionGear2" ] = ToWString("On Equipped and Artefacts")
locales["eng_eu"][ "IIOptionGear3" ] = ToWString("On Equipment - style")
locales["eng_eu"][ "IIOptionGear4" ] = ToWString("On Equipped Artefacts - style")
--------------------
-- category names --
--------------------

locales["eng_eu"][ "IIStatus" ] = ToWString("Status")
locales["eng_eu"][ "IICategoryTime" ] = ToWString("Time")
locales["eng_eu"][ "IICategoryCompassInsignia" ] = ToWString("Compass and Insignia")
locales["eng_eu"][ "IICategoryGear" ] = ToWString("Equipment")

--------------------
-- header --
--------------------

locales["eng_eu"][ "Settings" ] = ToWString("Item Info")

--------------------
-- buttons --
--------------------

locales["eng_eu"][ "Apply" ] = ToWString("Apply")
locales["eng_eu"][ "Ok" ] = ToWString("Ok")
locales["eng_eu"][ "Default" ] = ToWString("Default")
locales["eng_eu"][ "Cancel" ] = ToWString("Cancel")

--------------------
-- others --
--------------------

locales["eng_eu"][ "timerListThresholdLow" ] = {"1h","2h","4h","6h","12h","24h","48h"}

-- put locales used by client
locales = locales[common.GetLocalization()] or locales["eng_eu"]

-- temporary to have en on ru
--locales = locales["eng_eu"]

-- styles list, free to modify
-- список стилей, который можно изменить
locales["colorsList"] = {"Golden","LogColorRed","LogColorCian","log_brown","StatUseless","log_orange","Label","EpicCursed","RepKindly","DamageGreen","LogColorCyan","DamageVisMiss","RepConfidential","PartyQuestName","RepUnfriendly","WhiteSubtask","EditLineGlobal"}

-- remove items by adding "--" for example: --["Hero's Compass"] = true,
-- удалить элементы, добавив "--" например: --["Компас героя"] = true,
--------------------------------------------------------------------------------
-- Все языки | All languages
--------------------------------------------------------------------------------

Global("insigniaName", {
	--rus
	["Упакованная инсигния героя"] = true,
	["Инсигния героя"] = true,
	--eng_eu
	["Packed Hero's Insignia"] = true,
	["Hero's Insignia"] = true,
	["Packed Hero’s Insignia"] = true,
	["Hero’s Insignia"] = true
	--tur
	--ger
	--fr
})

Global("compassName", {
	--rus
	["Компас героя"] = true,
	--eng_eu
	["Hero's Compass"] = true
	--tur
	--ger
	--fr
})