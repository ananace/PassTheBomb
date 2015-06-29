require( "Util" )
require( "PTB" )

local function AddTimeCommand( command, description, round_time, match_time, extra_command )
	Convars:RegisterCommand( command, function(...)
		PTB.RoundTime = round_time
		PTB.NewRoundTime = round_time
		PTB.NewMatchTime = match_time
		GameRules:SetPreGameTime( match_time )

		if extra_command then extra_command() end
	end, description, 0 )
end

-- Precache things that need to be precached
function Precache( context )
	PrecacheUnitByNameSync( "npc_dota_hero_techies", context )

	PrecacheResource( "particle", "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context )
	PrecacheResource( "particle_folder",  "particles/units/heroes/hero_treant", context )
end

-- Create the game mode when we activate
function Activate()
	PTB:Init()

	-- TODO: Make a UI for this
	AddTimeCommand( "ptb_normal", "Normal rounds", 15, 30, function()
		Say( nil, "Normal round lengths", false )
	end )
	AddTimeCommand( "ptb_moderate", "Moderately fast rounds", 10, 20, function()
		Say( nil, "Moderately fast rounds", false )
	end )
	AddTimeCommand( "ptb_fast", "Fast rounds", 5, 10, function()
		Say( nil, "Fast rounds", false )
	end )
	AddTimeCommand( "ptb_sanic", "Gotta go fast", 1, 5, function()
		Say( nil, "Sanic mode: ACTIVE", false )
		Say( nil, "May god have mercy on your souls", false )
	end )

	if Convars:GetInt( "sv_cheats" ) == 1 then
		Convars:RegisterCommand( "ptb_test", function(...)
			PTB.Testing = true
			PTB:TestingClients()
		end, "Enable testing mode", 0 )
	end
end