local RegisterReaction = common.RegisterReactionHandler
local FromWS, ToWS, SendEvent = userMods.FromWString, userMods.ToWString, userMods.SendEvent
---------------------------------------------------------------------------------------------------
-- Размер окошка
---------------------------------------------------------------------------------------------------
local wtMainPanel =  mainForm:GetChildChecked( "WindowMain", false )
local p = wtMainPanel:GetPlacementPlain()
		p.sizeY = WindowYSize
		wtMainPanel:SetPlacementPlain(p)
---------------------------------------------------------------------------------------------------
-- Константы
local satiationMsLimit = 60000  -- 1 минута в милисекундах
local breakMsLimit = 10000  -- 10 секунд в милисекундах

local textures = { 
  [ 0 ] = common.GetAddonRelatedGroupTexture( 'ButtonSortStates', 'SortNone' ),
  [ 1 ] = common.GetAddonRelatedGroupTexture( 'ButtonSortStates', 'SortUp' ),
  [ 2 ] = common.GetAddonRelatedGroupTexture( 'ButtonSortStates', 'SortDown' )
}

-- Переменные
local mountId
local satiationMs
local breakMs

local wt = {} -- таблица виджетов
local var = {} -- таблица переменных
local mountList = {}
local wtstableButton = mainForm:GetChildChecked( 'ButtonSettings', true )
local wtContextStable = stateMainForm:GetChildChecked( 'ContextStable', false ):GetChildChecked("MainPanel", false )
wtContextStable:AddChild(wtstableButton)
---------------------------------------------------------------------------------------------------
-- Вспомогательные функции
---------------------------------------------------------------------------------------------------
function W( name, parent )
  return parent and parent:GetChildChecked( name, true ) or mainForm:GetChildChecked( name, true )
end
---------------------------------------------------------------------------------------------------
function GetWidgets( group )
  local result = {}
  local groupChilds = W( group ):GetNamedChildren();
  for _, val in pairs(groupChilds) do
    result[ val:GetName() ] = val
  end
  return result
end
---------------------------------------------------------------------------------------------------
-- Функции Аддона
---------------------------------------------------------------------------------------------------
function LangSetup( locale )
  InitLocalText( locale )
  W( 'Header' ):SetVal( 'value', ToWS(L[ 'AutoMountFeed' ]) )
  W( 'ButtonUnSelectAll' ):SetVal( 'button_label', ToWS(L[ 'UnSelect All' ]) )
  W( 'ButtonSelectAll' ):SetVal( 'button_label', ToWS(L[ 'Select All' ]) )
  W( 'ButtonSave' ):SetVal( 'button_label', ToWS(L[ 'Save' ]) )
  W( 'ButtonSort', W( 'SortByName') ):SetVal( 'button_label', ToWS(L[ 'Name' ]) )
end
---------------------------------------------------------------------------------------------------
function ShowSettings()
    SortBy( 'SortByName', true )
    W( 'WindowMain' ):Show( true )

end
---------------------------------------------------------------------------------------------------
function CloseSettings()

  W( 'WindowMain' ):Show( false )
  W('ButtonCornerCross'):Show( true )
  for _, val in pairs(var.items) do
    W( 'ButtonItem', val ):SetVariant( 0 )
  end

end
---------------------------------------------------------------------------------------------------
function AddItem( params )
  local widget
  if not wt.itemDesc then
    widget = W( 'Item' )
    wt.itemDesc = widget:GetWidgetDesc()
  else
    widget = mainForm:CreateWidgetByDesc( wt.itemDesc )
  end

  widget:SetName( params.name )
  W( 'ButtonItem', widget ):SetVariant( params.new and 1 or 0 )
  W( 'ButtonState', widget ):SetVariant( params.state and 1 or 0 )
  W( 'Name', widget ):SetVal( 'value', ToWS( params.name ) )
  if not params.canBeFeeded then
    W( 'ButtonState', widget ):Show( false )
  end
  var.items[ params.name ] = widget
end
---------------------------------------------------------------------------------------------------
function SortBy( name, order )
  local colors = {
    { r = 255 / 255, g = 185 / 255, b = 255 / 255, a = 1.0 },
    { r = 255, g = 255, b = 255, a = 1.0 }
  }
  local array, result = {}
  if name == 'SortByState' then
    for key, val in pairs(mountList) do
      table.insert( array, { state = val and 1 or 0, name = key } )
    end
    result = function( a, b )
      if a.state == b.state then
        result = a.name < b.name
      elseif order then
        result = a.state > b.state
      else
        result = a.state < b.state
      end
      return result
    end      
  elseif name == 'SortByName' then
    for key, val in pairs(mountList) do
      table.insert( array, key )
    end
    result = function( a, b )
      if order then
        return a < b
      else
        return a > b
      end
    end
  end
  table.sort( array, result )
  wt.container:RemoveItems()
  for i, val in pairs(array) do
    val = type( val ) == 'string' and val or val.name
    if val then
      local widget = var.items[ val ]
      if widget then 
        wt.container:PushBack( widget )
        if not widget:IsVisible() then
          widget:Show( true )
        end
        widget = W( 'ButtonItem', widget )
        if math.mod( i, 2 ) == 0 then
          widget:SetBackgroundColor( colors[ 1 ] )
        else
          widget:SetBackgroundColor( colors[ 2 ] )
        end
      end
    end
  end
end
--------------------------------------------------------------------------------------------------
function LoadConfig()
  local config = userMods.GetAvatarConfigSection("AMF_mountList")
  if config then
    for _, val in pairs(config) do
      local res = string.find (val, "\\")
      local ind = string.sub(val,1,res-1)
      local state = string.sub(val,res+1)
      mountList[ind] = state == '1'
    end
  end
  ScanStable()
end
---------------------------------------------------------------------------------------------------
function SaveConfig()
  local config = {}
  for key, val in pairs(var.items) do
    local state = W( 'ButtonState', val ):GetVariant()
    mountList[key] = state == 1
    table.insert(config, 1, key.."\\"..state )
  end
  if GetTableSize(config) > 0 then
    userMods.SetAvatarConfigSection ("AMF_mountList", config)
  end
end
---------------------------------------------------------------------------------------------------
function ScanStable()
  if mount.IsStableExist() then
    --LogInfo(mountList)
    local countNewMounts = 0
    local countTrue = 0
    var.items = {}
    local mounts = mount.GetMounts()
    for _, mountId in pairs(mounts) do
      if mountId then
        if mount.IsMountExist( mountId ) then
          local mountInfo = mount.GetInfo( mountId )
          local mountName = FromWS( mountInfo.name )
          local newMount = false
          if mountList[mountName] == nil then
            mountList[mountName] = false
            newMount = true
            countNewMounts = countNewMounts + 1
          end
          if mountList[mountName] == true then
            countTrue = countTrue + 1
          end
          AddItem( {name = mountName, canBeFeeded = mountInfo.canBeFeeded, state = mountList[mountName], new = newMount } )
        end
      end
    end
    if countNewMounts > 0 and countTrue == 0 then
      W('ButtonCornerCross'):Show( false )
      ShowSettings()
    end
  end
  
  --LogInfo(mountList)
  
end
---------------------------------------------------------------------------------------------------
-- REACTION HANDLERS
---------------------------------------------------------------------------------------------------
function OnMouseLeftClick( params )

  local parent = params.widget:GetParent()
  local parentName = parent:GetName()
  local widgetVar = params.widget:GetVariant() == 1
  if params.sender == 'ButtonMain' or params.sender == 'ButtonCornerCross' then
    if DnD:IsDragging() then return end
    CloseSettings()
    return
  elseif string.find( parentName, 'SortBy' ) then
    local widget = W( 'ButtonSortState', parent )
    local variant = ( { [ 0 ] = 1, [ 1 ] = 2, [ 2 ] = 1 } )[ params.widget:GetVariant() ]
    for _, val in pairs(wt.sortPanel) do
      W( 'ButtonSort', val ):SetVariant( 0 )
      W( 'ButtonSortState', val ):SetBackgroundTexture( textures[ 0 ] )
    end
    params.widget:SetVariant( variant )
    widget:SetBackgroundTexture( textures[ variant ] )
    var.sortedBy = { parentName, variant }
    SortBy( parentName, not widgetVar )
    return
  elseif params.sender == 'ButtonSelectAll' then
    for _, val in pairs(var.items) do
      local widget = W( 'ButtonState', val )
      if widget:IsVisible() then
        widget:SetVariant( 1 )
      end
    end
  elseif params.sender == 'ButtonUnSelectAll' then
    for _, val in pairs( var.items ) do
      local widget = W( 'ButtonState', val )
      if widget:IsVisible() then
        widget:SetVariant( 0 )
      end
    end
  elseif params.sender == 'ButtonSave' then
    SaveConfig()
    CloseSettings()
    return
  elseif params.sender == 'ButtonState' then
    params.widget:SetVariant( ( not widgetVar ) and 1 or 0 )
    return
  elseif params.sender == 'ButtonSettings' then
    ShowSettings()
    return
  end
end
---------------------------------------------------------------------------------------------------
-- EVENT HANDLERS
---------------------------------------------------------------------------------------------------
function OnEventAvatarCreated()

  LangSetup( GetGameLocalization() )

  LoadConfig()

  RegisterEvent( OnEventActiveMountChanged, "EVENT_ACTIVE_MOUNT_CHANGED" )
  RegisterEvent( OnEventStableMountChanged, "EVENT_STABLE_MOUNT_ADDED" )
  RegisterEvent( OnEventStableMountChanged, "EVENT_STABLE_MOUNT_REMOVED" )

  RegisterEvent( OnEventUnknownSlashCommand, "EVENT_UNKNOWN_SLASH_COMMAND" )
end
--------------------------------------------------------------------------------
function OnEventStableMountChanged()
  ScanStable()
end
--------------------------------------------------------------------------------
function OnEventActiveMountChanged()
  --Chat(tostring("OnEventActiveMountChanged"))
  mountId = mount.GetActive()
  if mountId then
    local mountInfo = mount.GetInfo( mountId )
    local mountName = FromWS( mountInfo.name )
    -- MetaMorph fix
	local metamorphId = mount.GetMetamorph()
    if metamorphId then
      if metamorphId == mountId then
		local MMname = string.sub(FromWS(mount.GetInfo( metamorphId ).name), 19)
        mountName = MMname 
      end
    end
    --
    if mountList[mountName] then
      satiationMs = mountInfo.satiationMs
      RegisterEvent( OnEventSecondTimer, "EVENT_SECOND_TIMER" )
    end
  else
    UnRegisterEvent( OnEventSecondTimer, "EVENT_SECOND_TIMER" )
    satiationMs = nil
  end
end
--------------------------------------------------------------------------------
function OnEventSecondTimer( params )
  if satiationMs then
    satiationMs = satiationMs - params.elapsedMs
    if  satiationMs <= satiationMsLimit  and  not breakMs  then
      breakMs = 0
      if mount.GetStableInfo().foodCount > 0 then
        mount.Feed( mountId )
      end
    elseif breakMs then
      breakMs = breakMs + params.elapsedMs
      if breakMs >= breakMsLimit then
        local mountInfo = mount.GetInfo( mountId )
        satiationMs = mountInfo.satiationMs
        breakMs = nil
      end
    end
  end
end
--------------------------------------------------------------------------------
function OnEventUnknownSlashCommand( params )
  local cmd = FromWS( params.text )
  local pin
  local outString

  if cmd == "/amf" then
    ShowSettings()
  end
end
--------------------------------------------------------------------------------
function OnAMAddonInfoRequest( params )
  if params.target == common.GetAddonName() then
    LangSetup( params.locale )
    userMods.SendEvent( "SCRIPT_ADDON_INFO_RESPONSE", {
      sender = common.GetAddonName(),
      desc = L["Description"],
      showSettingsButton = true,
    } )
  end
end
--------------------------------------------------------------------------------
function OnAMAddonMemRequest( params )
  if params.target == common.GetAddonName() then
    userMods.SendEvent( "SCRIPT_ADDON_MEM_RESPONSE", { sender = params.target, memUsage = gcinfo() } )
  end
end
--------------------------------------------------------------------------------
function OnAMAddonLocalizationChanged( params )
  OnAMAddonInfoRequest( {target = common.GetAddonName(), locale = params.locale} )
end
--------------------------------------------------------------------------------
function OnAMShowSettings( params )
  if params.target == common.GetAddonName() then
    ShowSettings()
  end
end
--------------------------------------------------------------------------------
function OnAOPanelStart( params )
  local SetVal = { val = ToWS( 'AMF' ) }
  local params = { header = SetVal, ptype = 'button', size = 56 } 
  SendEvent( 'AOPANEL_SEND_ADDON', { name = common.GetAddonName(), sysName = common.GetAddonName(), param = params } )
end
--------------------------------------------------------------------------------
function OnAOPanelButtonLeftClick( params )
  if params.sender == common.GetAddonName() then
    ShowSettings()
  end
end
--------------------------------------------------------------------------------
function Init()
  
  wt.container = W( 'Frame' ):GetChildChecked( 'Container', false )
  wt.sortPanel = GetWidgets( 'SortPanel' )
  
  local header = W( 'Header' )
  local WindowMain = W( 'WindowMain' )
  
  DnD:Init( WindowMain , header )
  
  -- Регистрация событий системы
  RegisterEvent( OnEventAvatarCreated, "EVENT_AVATAR_CREATED")

  -- События "AddonManager"
  RegisterEvent( OnAMAddonInfoRequest, "SCRIPT_ADDON_INFO_REQUEST" )
  RegisterEvent( OnAMAddonMemRequest, "SCRIPT_ADDON_MEM_REQUEST" )
  RegisterEvent( OnAMAddonLocalizationChanged, "SCRIPT_ADDON_MANAGER_LOCALIZATION_CHANGED" )
  RegisterEvent( OnAMShowSettings, "SCRIPT_SHOW_SETTINGS" )

  -- События "AO Panel"
  RegisterEvent( OnAOPanelStart, "AOPANEL_START" )
  RegisterEvent( OnAOPanelButtonLeftClick, "AOPANEL_BUTTON_LEFT_CLICK" )

  -- События виджетов
  RegisterReaction( OnMouseLeftClick, "mouse_left_click" )

  if avatar.IsExist() then
    OnEventAvatarCreated()
    OnEventActiveMountChanged()
  end

end
--------------------------------------------------------------------------------
Init()

