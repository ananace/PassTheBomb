local Mode = {}
Mode.Name = "Darkest of Nights"
Mode.Min = 0.5

function Mode:Init()
	print( "SuperNight:Init" )
	GameRules:SetTimeOfDay( 0.76 )

	if RollPercentage( 25 ) then
		self.Name = "Dankest of Nights"
	else
		self.Name = "Darkest of Nights"
	end
end

function Mode:Start()
	print( "SuperNight:Start" )
	
	for _, p in pairs( PlayerRegistry:GetAllPlayers() ) do
		p:SetVisionMod( 0.6, VISION_NIGHT )
		p:SetAbilityLevel( "techies_blink", 1 )
	end

	self.Listener = ListenToGameEvent( "ptb_bomb_passed", Dynamic_Wrap( self, 'BombPassed' ), self )
end

function Mode:Cleanup()
	print( "SuperNight:Cleanup" )

	StopListeningToGameEvent( self.Listener )

	for _, p in pairs( PlayerRegistry:GetAllPlayers() ) do
		p:SetVisionMod( 1, VISION_NIGHT )
		p:SetAbilityLevel( "techies_blink", 2 )
	end
end

function Mode:BombPassed( event )
	local from = PlayerRegistry:GetPlayer( { UserID = event.old_carrier } )
	local to   = PlayerRegistry:GetPlayer( { UserID = event.new_carrier } )

	if from then
		from:SetSpeed( from:GetBaseSpeed() )
		from:SetVisionMod( 0.6 )
		from:SetAbilityLevel( "techies_blink", 1 )
	end

	to:SetSpeed( 2048 )
	to:SetVisionMod( 0.3 )
	to:SetAbilityLevel( "techies_blink", 2 )

	Timers:CreateTimer( 0.5, function() 
		to:SetVisionMod( 0.5, VISION_NIGHT )
	end )
end

return Mode
