Global("currentLocalization", nil)
Global("Locales", {
	["rus"] = { -- Russian, Win-1251
--- TREASURY
	[ "pcs." ] = "шт.",
	["TREASURY: Here is empty"] = "СОКРОВИЩНИЦА: Тут пусто",
	[ "TREASURY: The number of chests on board is: " ] = "СОКРОВИЩНИЦА: Всего груза на борту: ",
	[ "This might be a cargo items:" ] = "Это может быть вещь из груза:",
-- info
	[ "Damage: " ] = "Урон: ",
--- radar
	[ "  DIST:" ] = "  ДАЛЬН:",
	[ "m" ] = "м",
	[ "EDGE" ] = "КРАЙ",
	[ "HUB Edge Point №" ] = "Краевая точка №",
--- menu
	[ "COMMANDS" ] = "КОММАНДЫ",
	[ "SETTINGS" ] = "НАСТРОЙКИ",
	[ "Load Settings" ] = "Загрузить Настройки",
	[ "Save Settings" ] = "Сохранить Настройки",
	[ "Save" ] = "Настройки сохранены, перезагрузите аддон",

	[ "Test Device Place" ] = "Узнать место устройства",
	[ "For test any device Place on the board - to set 'ON' and use the device." ] = "Для определения места устройства - установить 'Вкл' и использовать устройство.",
	[ "Radar Scale" ] = "Масштаб Радара",
	[ "RadarScale" ] = "Масштаб Радара",
	[ "Radar Power koeff" ] = "Коэффициент степени Радара",
	[ "RadarLg" ] = "Коэффициент степени Радара",
	[ "RadarEdge" ] = "Угол Радара",
	[ "Mobs Radar Radius" ] = "Радиус для Мобов на Радаре",
	[ "DistMobs1" ] = "Радиус для Мобов на Радаре",
	[ "dSizeX" ] = "Отступ от края по горизонтали",
	[ "dSizeY" ] = "Отступ от края по вертикали",
	[ "Ship Over Heat" ] = "Перегрев",
	[ "overHeat" ] = "Перегрев",
	[ "EngineSizeX" ] = "Размер двигателя по горизонтали",
	[ "EngineSizeY" ] = "Размер двигателя по вертикали",
	[ "HullWide" ] = "Ширина корпуса",
	[ "HullSizeY" ] = "Высота корпуса",
	[ "Show Over Map" ] = "Показывать над картой",
	[ "OverMapShow" ] = "Показывать над картой",
	[ "Cannon Target Icon" ] = "Вид прицела на корабле",
	[ "CannonAim" ] = "Вид прицела на корабле",
	[ "Over Map Place" ] = "Позиция Окна над картой",
	[ "Select by double click" ] = "Выделение цели двойным кликом",
	[ "EnableSelectDblClk" ] = "Выделение цели двойным кликом",
	[ "Use red / green highlight" ] = "Цветная подсветка промахов и высот",
	[ "ColoredFontSwitch" ] = "Цветная подсветка промахов и высот",
	[ "TogetherMode" ] = "Совмещенный режим карты и корабля",

	[ "List Devices to mods.txt" ] = "Список устройств в mods.txt",
	[ "'mainForm' Priority" ] = "Приоритет 'mainForm'",
	[ "list Texts to mod.txt" ] = "Список строк в mod.txt",

	[ "Inteface Priority" ] = "Приоритет интерфейса",
	[ "prior" ] = "Приоритет интерфейса",
	[ "Reset to Config.txt" ] = "Сброс настроек до Config.txt",
	[ "window Offset when map open" ] = "Смещение для окна аддона при показе над картой игры",

--- constants
	[ "ON" ] = "ВКЛ",
	[ "true" ] = "Вкл",
	[ "OFF" ] = "выкл",
	[ "false" ] = "Выкл",

-- messages
	[ "loaded" ] = "загружено",
	[ "started" ]  = "запущено",

	[ "TREASURY: the number of chests on board is %d pieces. " ] =  "СОКРОВИЩНИЦА: количество сундуков на борту %d штук. ",
	[ "ASTROLABE: readiness through %s. " ] = "АСТРОЛЯБИЯ: готовность через %s. ",
	[ " on ship: "] = " на корабле: ",
	[ "find hidden Ship" ] = "обнаружен корабль",
	[ "Find Ship: " ] = "Обнаружен корабль: ",
	[ "Empire"] = "Империя",
	[ "League"] = "Лига",
	[ "Friend"] = "Друг",
	[ "Enemy"] = "Враг",
	[ "Stabilization of Anomalous Matter"] = "Стабилизация аномальной материи",
	[ "Captured Anomalous Matter"] = "Захваченная аномальная материя",
	},
		
	["eng_eu"] = { -- English, Latin-1
    ["TREASURY: Here is empty"] = "TREASURY: Here is empty",
	}
})

currentLocalization = common.GetLocalization()

function L( strTextName )
	return Locales[ currentLocalization ][ strTextName ] or Locales[ "eng_eu" ][ strTextName ] or strTextName
end