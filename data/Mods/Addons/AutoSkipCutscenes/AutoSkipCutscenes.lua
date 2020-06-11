function OnBuffAdded( params )
	local avatarId = avatar.GetId()
	if ( params.objectId == avatarId ) then
		if ( userMods.FromWString( cartographer.GetCurrentMapInfo().name ) == "Ўпиль ¬ремЄн" ) then
			local buffInfo = object.GetBuffInfo( params.buffId )
			if ( buffInfo.canDetach == true ) then
				if ( buffInfo.isNeedVisualize == false ) and ( userMods.FromWString( buffInfo.name ) == "" ) then
					--LogInfo( "cutscene buff detected!")
					object.RemoveBuff( buffInfo.id )
				end
			end
		end
	end
end

function Init()
	common.RegisterEventHandler( OnBuffAdded, "EVENT_OBJECT_BUFF_ADDED" )
end

Init()