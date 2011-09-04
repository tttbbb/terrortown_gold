local iFails = 0
local function PlySpawn()
	RunConsoleCommand("myinfo_bytes","4000")
	
	if (GetConVarString("cl_downloadfilter") != "all") then
		local iFailLimit = 2
		if (iFails == iFailLimit) then
			RunConsoleCommand("say", Format("!!! My download filter is not set to all! I'm forcefully disconnecting myself. This can be fixed by setting cl_downloadfilter all !!!"))
			RunConsoleCommand("say", Format("!!! My download filter is not set to all! I'm forcefully disconnecting myself. This can be fixed by setting cl_downloadfilter all !!!"))
			RunConsoleCommand("disconnect")
		else
			RunConsoleCommand("say", Format("!!! My download filter is not set to all! I'm going to disconnect after %i more spawn(s). This can be fixed by setting cl_downloadfilter all !!!",iFailLimit-iFails))
			RunConsoleCommand("say", Format("!!! My download filter is not set to all! I'm going to disconnect after %i more spawn(s). This can be fixed by setting cl_downloadfilter all !!!",iFailLimit-iFails))
			iFails = iFails + 1;
		end
	end
end

usermessage.Hook( "PlySpawn", PlySpawn )