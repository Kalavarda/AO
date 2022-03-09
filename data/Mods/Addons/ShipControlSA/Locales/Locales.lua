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
	[ "Save" ] = "Настройки сохранены, перезагружаю аддон...",

	[ "Test Device Place" ] = "Узнать место устройства",
	[ "For test any device Place on the board - to set 'ON' and use the device." ] = "Для определения места устройства - установить 'Вкл' и использовать устройство.",
	[ "Radar Scale" ] = "Масштаб Радара",
	[ "RadarScale" ] = "Коэф. масштаба Радара(X / Этот коэф.)",
	[ "Radar Power koeff" ] = "Коэффициент степени Радара",
	[ "RadarLg" ] = "Коэф. масштаба Радара(X в степени Этот коэф.)",
	[ "RadarEdge" ] = "Количество краевых точек",
	[ "Mobs Radar Radius" ] = "Радиус для Мобов на Радаре",
	[ "DistMobs1" ] = "Радиус для Мобов на Радаре",
	[ "dSizeX" ] = "Отступ по горизонтали для окошек урона",
	[ "dSizeY" ] = "Отступ по вертикали для окошек урона",
	[ "Ship Over Heat" ] = "Перегрев",
	[ "overHeat" ] = "Порог перегрева (%)",
	[ "EngineSizeX" ] = "Ширина поля перегрева",
	[ "EngineSizeY" ] = "Высота поля перегрева",
	[ "HullWide" ] = "Ширина обводки корпуса",
	[ "HullSizeY" ] = "Высота корпуса",
	[ "Show Over Map" ] = "Показывать над картой",
	[ "OverMapShow" ] = "Показывать над картой (требуется PopUpChatPro)",
	[ "Cannon Target Icon" ] = "Вид прицела на корабле",
	[ "CannonAim" ] = "Вид прицела на корабле(system - перезапуск игры)",
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
	[ "prior" ] = "Приоритет интерфейса (работает всегда)",
	[ "Reset to Config.txt" ] = "Сброс настроек до Config.txt",
	[ "window Offset when map open" ] = "Смещение для окна аддона при показе над картой игры",
	[ "MaxMapRadius" ] = "Максимально допустимый радиус карты",
	[ "HighlightTarget" ] = "Выделять цель",

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
	["Реактор загружен на %d"] = "Реактор загружен на %d",

-- ship tip
	["ship_gearscore"] = "рейтинг",
	["ship_hull_generation"] = "поколение корпуса",
	},
		
	["eng_eu"] = { -- English, Latin-1
	--- TREASURY
	[ "pcs." ] = "шт.",
	["TREASURY: Here is empty"] = "Treasury: empty",
	[ "TREASURY: The number of chests on board is: " ] = "Treasury: chests on board - ",
	[ "This might be a cargo items:" ] = "It could be a cargo item:",
-- info
	[ "Damage: " ] = "Damage: ",
--- radar
	[ "  DIST:" ] = "  Distance:",
	[ "m" ] = "m",
	[ "EDGE" ] = "Edge",
	[ "HUB Edge Point №" ] = "Edge point No.",
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
	["Реактор загружен на %d"] = "Reactor load at %d",

-- ship tip
	["ship_gearscore"] = "Rating",
	["ship_hull_generation"] = "Hull generation",
	}
})

currentLocalization = common.GetLocalization()

function L( strTextName )
	return Locales[ currentLocalization ][ strTextName ] or Locales[ "eng_eu" ][ strTextName ] or strTextName
end