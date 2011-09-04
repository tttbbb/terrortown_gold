local function checkStrike() 
	local iDiedPins = GetGlobalInt( "jim_diedpins" )
	local iCurrentPins = GetGlobalInt( "jim_currentpins" )
	local iAlivePins = 0;
	for _, v in pairs(player.GetAll()) do
		if (!v:IsSpec() && v.IsPin) then
			iAlivePins = iAlivePins + 1
		end
	end
		
	if (iDiedPins != 0) then
		Msg(iDiedPins.." pins died this half-second. "..iAlivePins.." - "..iCurrentPins.."\n")
		if (iDiedPins == iCurrentPins && iAlivePins == 0) then
			umsg.Start( "incStrike" );
			umsg.End();
		end
	end
	SetGlobalInt("jim_diedpins", 0)
end
timer.Create( "BowlingCheckStrike", 1.0, 0, checkStrike)