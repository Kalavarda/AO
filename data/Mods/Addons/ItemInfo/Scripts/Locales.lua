local ToWString = userMods.ToWString
local FromWString = userMods.FromWString
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
locales["rus"][ "IIOptionGear2" ] = ToWString("Показывать на надетых экипировке, артефактах и осмотре")
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
locales["rus"]["levelLocalized"] = " уровень: "
locales["rus"]["timeLocalization"] = {["second"] = "с",["minute"] = "м",["hour"] = "ч",["day"] = "д"}

--------------------
-- tips
--------------------

locales["rus"][FromWString(locales["rus"][ "IIStatus1" ])]=ToWString("<html>Активен ли он?</html>")
locales["rus"][FromWString(locales["rus"][ "IIStatus1" ]).."SizeX"]=500
locales["rus"][FromWString(locales["rus"][ "IIStatus1" ]).."SizeY"]=90

locales["rus"][FromWString(locales["rus"][ "IIOptionTime1" ])]=ToWString("<html>Порог времени, при котором элемент изменит цвет</html>")
locales["rus"][FromWString(locales["rus"][ "IIOptionTime1" ]).."SizeX"]=500
locales["rus"][FromWString(locales["rus"][ "IIOptionTime1" ]).."SizeY"]=70

locales["rus"][FromWString(locales["rus"][ "IIOptionTime2" ])]=ToWString("<html>Этикетки с истекающим сроком годности - стиль </html>")
locales["rus"][FromWString(locales["rus"][ "IIOptionTime2" ]).."SizeX"]=550
locales["rus"][FromWString(locales["rus"][ "IIOptionTime2" ]).."SizeY"]=90

locales["rus"][FromWString(locales["rus"][ "IIOptionTime3" ])]=ToWString("<html>Временные метки - стиль</html>")
locales["rus"][FromWString(locales["rus"][ "IIOptionTime3" ]).."SizeX"]=500
locales["rus"][FromWString(locales["rus"][ "IIOptionTime3" ]).."SizeY"]=90

locales["rus"][FromWString(locales["rus"][ "IIOptionTime4" ])]=ToWString("<html></html>")
locales["rus"][FromWString(locales["rus"][ "IIOptionTime4" ]).."SizeX"]=500
locales["rus"][FromWString(locales["rus"][ "IIOptionTime4" ]).."SizeY"]=90

locales["rus"][FromWString(locales["rus"][ "IIOptionCompassInsignia1" ])]=ToWString("<html>Показать метки уровня компаса</html>")
locales["rus"][FromWString(locales["rus"][ "IIOptionCompassInsignia1" ]).."SizeX"]=500
locales["rus"][FromWString(locales["rus"][ "IIOptionCompassInsignia1" ]).."SizeY"]=90

locales["rus"][FromWString(locales["rus"][ "IIOptionCompassInsignia2" ])]=ToWString("<html>Показать процентные метки знаков отличия</html>")
locales["rus"][FromWString(locales["rus"][ "IIOptionCompassInsignia2" ]).."SizeX"]=500
locales["rus"][FromWString(locales["rus"][ "IIOptionCompassInsignia2" ]).."SizeY"]=90

locales["rus"][FromWString(locales["rus"][ "IIOptionCompassInsignia3" ])]=ToWString("<html>Наклейки для компасов и знаков отличия - стиль</html>")
locales["rus"][FromWString(locales["rus"][ "IIOptionCompassInsignia3" ]).."SizeX"]=500
locales["rus"][FromWString(locales["rus"][ "IIOptionCompassInsignia3" ]).."SizeY"]=90

locales["rus"][FromWString(locales["rus"][ "IIOptionGear1" ])]=ToWString("<html>Показать этикетки на оборудовании, находящемся в сумке и банке</html>")
locales["rus"][FromWString(locales["rus"][ "IIOptionGear1" ]).."SizeX"]=600
locales["rus"][FromWString(locales["rus"][ "IIOptionGear1" ]).."SizeY"]=90

locales["rus"][FromWString(locales["rus"][ "IIOptionGear2" ])]=ToWString("<html>Показывать этикетки на снаряженных предметах, артефактах и при осмотре других предметов</html>")
locales["rus"][FromWString(locales["rus"][ "IIOptionGear2" ]).."SizeX"]=750
locales["rus"][FromWString(locales["rus"][ "IIOptionGear2" ]).."SizeY"]=90

locales["rus"][FromWString(locales["rus"][ "IIOptionGear3" ])]=ToWString("<html>Оборудование в сумке, банке, оборудованное и проверенное этикетки - стиль</html>")
locales["rus"][FromWString(locales["rus"][ "IIOptionGear3" ]).."SizeX"]=700
locales["rus"][FromWString(locales["rus"][ "IIOptionGear3" ]).."SizeY"]=90

locales["rus"][FromWString(locales["rus"][ "IIOptionGear4" ])]=ToWString("<html>Этикетки для оснащенных артефактов - стиль</html>")
locales["rus"][FromWString(locales["rus"][ "IIOptionGear4" ]).."SizeX"]=500
locales["rus"][FromWString(locales["rus"][ "IIOptionGear4" ]).."SizeY"]=90

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
locales["eng_eu"][ "IIOptionGear2" ] = ToWString("On Equipped, Artefacts and Inspection")
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
locales["eng_eu"]["levelLocalized"] = " level: "
locales["eng_eu"]["timeLocalization"] = {["second"] = "s",["minute"] = "m",["hour"] = "h",["day"] = "d"}
--------------------
-- tips
--------------------

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIStatus1" ])]=ToWString("<html>Is it active?</html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIStatus1" ]).."SizeX"]=500
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIStatus1" ]).."SizeY"]=90

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime1" ])]=ToWString("<html>Time threshold at which item will change color</html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime1" ]).."SizeX"]=400
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime1" ]).."SizeY"]=70

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime2" ])]=ToWString("<html>Expire soon labels - style </html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime2" ]).."SizeX"]=550
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime2" ]).."SizeY"]=90

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime3" ])]=ToWString("<html>Times labels - style</html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime3" ]).."SizeX"]=500
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime3" ]).."SizeY"]=90

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime4" ])]=ToWString("<html></html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime4" ]).."SizeX"]=500
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionTime4" ]).."SizeY"]=90

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionCompassInsignia1" ])]=ToWString("<html>Show compass level labels</html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionCompassInsignia1" ]).."SizeX"]=500
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionCompassInsignia1" ]).."SizeY"]=90

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionCompassInsignia2" ])]=ToWString("<html>Show insignia percentage labels</html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionCompassInsignia2" ]).."SizeX"]=500
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionCompassInsignia2" ]).."SizeY"]=90

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionCompassInsignia3" ])]=ToWString("<html>Compass and insignia labels - style</html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionCompassInsignia3" ]).."SizeX"]=500
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionCompassInsignia3" ]).."SizeY"]=90

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear1" ])]=ToWString("<html>Show labels on equipment located in bag and bank</html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear1" ]).."SizeX"]=500
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear1" ]).."SizeY"]=90

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear2" ])]=ToWString("<html>Show labels on equipped items, artefacts and while inspecting others</html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear2" ]).."SizeX"]=500
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear2" ]).."SizeY"]=90

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear3" ])]=ToWString("<html>Equipment in bag, bank, equipped and inspected labels - style</html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear3" ]).."SizeX"]=500
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear3" ]).."SizeY"]=90

locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear4" ])]=ToWString("<html>Equipped artefacts labels - style</html>")
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear4" ]).."SizeX"]=500
locales["eng_eu"][FromWString(locales["eng_eu"][ "IIOptionGear4" ]).."SizeY"]=90

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