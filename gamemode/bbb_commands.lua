local jimcmdlist = {
["jim_resize"]="Makes various resizable props, ask jim what they are.",
["jim_effect"]="Spawns an effect.",
["jim_bowling"]="Finds player and places them where you are looking as a pin.",
["jim_melon"]="Spawns a resizable melon.",
["jim_cat"]="Spawns a resizable jim_cat.",
["jim_chimney"]="Spawns a resizable jim_chimney.",
["jim_crate"]="Spawns a resizable crate.",
["jim_meat"]="Forces meatspin on a user/users",
["jim_rocket"]="Spawns an alyx rocket",
["jim_dickspolsion"]="Spawns 50 dicks",
["jim_dick"]="Spawns a standard flying dick, sticks in walls",
["jim_spamdick"]="Spawns a dick that shouts melon on impact",
["jim_drill"]="Gives user standard drilldo",
["jim_barrel"]="Forces playermodel to a barrel.",
["jim_pony"]="Forces playermodel to a pony.",
["jim_rag"]="Creates a ragdoll, run with no argument for listing.",
["jim_prop"]="Creates a prop, run with no argument for listing.",
["jim_ent"]="Creates an entity, run with no argument for listing.",
["jim_alltalk"]="Enables alltalk, force users to hear you.",
["jim_drill_admin"]="Gives admin drilldo",
["jim_meatbang"]="Gives meatbang",
["derg_babby"]="Spawns dragon's baby where you are looking",
["jim_disarm"]="Disarms player",
["jim_teletarg"]="Teleports target to where you're looking",
["jim_teletarg_disarm"]="Teleports target to where you're looking AND DISARMS.",
["jim_c4"]="spawns c4 with x seconds left. 10 if not set.",
["jim_fakedrilldo"]="strips the user, gives them a fake drilldo that they can never drop/swap out.",
["jim_playergive"]="<player/@> <item>, gives the player the specified item.",
["jim_follow"]="Spawns a melon which follows the nearest player. If a name is supplied, it follows that person specifically.",
}

function jim_follow(ply,command,arg)
	if (!IsTTTAdmin(ply)) then return end
	
	local targ = nil
	
	if (arg[1] != nil) then
		for _, v in pairs(player.GetAll()) do
			if (string.find(string.lower(v:Nick()), string.lower(arg[1])) != nil) then
				targ = v
			end
		end
		
		if (targ == nil) then 
			ply:ChatPrint("jim_follow: No users found.");
			return
		else
			ply:ChatPrint("jim_follow: Spawned melon, following "..targ:Nick().." specifically.");
		end
	else
		ply:ChatPrint("jim_follow: Spawned melon, no target.");
	end
	
	local ent = ents.Create( "jim_follow" )
	if ( !ent:IsValid() ) then return end
	ent:SetPos( ply:EyePos() )
	ent:SetAngles(ply:EyeAngles())
	ent:Spawn()
	ent:Activate()
	
	if (targ != nil) then ent:SetTar(targ) end
	
	return true;	
end
concommand.Add("jim_follow", jim_follow)


function jim_fakedrilldo(ply,command,arg)
	if (!IsTTTAdmin(ply)) then return end
	local oldply = ply
	if (arg[1] != nil) then
		for _, v in pairs(player.GetAll()) do
			if (string.find(v:Nick(), arg[1]) != nil || arg[1] == "@all") then
				v:StripWeapons()
				v:StripAmmo()
				v:Give("weapon_ttt_drilldo_fake")
				v.Gimped = "weapon_ttt_drilldo_fake"
				oldply:ChatPrint(Format("Giving fake drilldo to %s",v:Nick()))
			end
		end
	end
	
end
concommand.Add("jim_fakedrilldo", jim_fakedrilldo)

function jim_c4(ply,command,arg)
	if (!IsTTTAdmin(ply) || !ply:IsSpec()) then return end
	
	local time = 10;
	if (arg[1]) then
		time = arg[1];
	end
		
	local trace = ply:GetEyeTrace()		
	local ent = ents.Create( "ttt_c4" )
	if ( !ent:IsValid() ) then return end
	ent:SetPos( trace.HitPos )
	local outa = trace.HitNormal:Angle() + Angle(90,0,0)
			ent:SetAngles( outa  )
	ent:Spawn()
	ent:Activate()
	
	local entphys = ent:GetPhysicsObject();
	if entphys:IsValid() then
		//entphys:EnableMotion(false);
		entphys:Sleep()
	end
	
	ent:Arm(ply,time);
	ent.SafeWires = {}
		
	return true;
end
concommand.Add("jim_c4",jim_c4)

function jim_resize(ply,command,arg)
	if (!IsTTTAdmin(ply) || !ply:IsSpec()) then return end
	
	if (arg[1] == "1") then
		local mdl = "models/alyxmask.mdl"
		local ent = ents.Create( "jim_megacustom" )
		if ( !ent:IsValid() ) then return end
		ent:SetPos( ply:EyePos() )
		ent:SetAngles(ply:EyeAngles())
		ent:DoSetModel( mdl)
		ent:SetModel( mdl)
		ent:Spawn()
		ent:Activate()
		ent.BaseSizeMin = Vector(-18,-16,0)
		ent.BaseSizeMax = Vector(10,10,66)
		ent.SoundName = ")vo/streetwar/alyx_gate/al_no.wav"
		PROPSPEC_A.Start(ply,ent)
		return true;
	end
	
	if (arg[1] == "2") then
		local mdl = "models/jaanus/dildo.mdl"
		local ent = ents.Create( "jim_megacustom" )
		if ( !ent:IsValid() ) then return end
		ent:SetPos( ply:EyePos() )
		ent:SetAngles(ply:EyeAngles())
		ent:DoSetModel( mdl)
		ent:SetModel( mdl)
		ent:Spawn()
		ent:Activate()
		ent.BaseSizeMin = Vector(-15,-2.2,-4.25)
		ent.BaseSizeMax = Vector(0.5,2.2,2.5)
		ent.SoundName = ")ambient/creatures/town_child_scream1.wav"
		PROPSPEC_A.Start(ply,ent)
		return true;
	end
		
	return true;
end
concommand.Add("jim_resize",jim_resize)


local function dosetPos (v,pos,ply)
	if (IsValid(v) && !v:IsSpec() && IsValid(ply)) then 
		v:SetPos(pos) 
	end

end
function jim_hitler(ply,command,arg)
if (!IsTTTAdmin(ply)) then return end
	
	local ent = ents.Create( "prop_ragdoll" )
	if ( !ent:IsValid() ) then return end
	ent:SetPos( ply:GetPos() )
	ent:SetAngles(ply:EyeAngles())
		ent:SetModel("models/player/hitler.mdl")
	ent:Spawn()
	ent:Activate()
	ent:SetHealth(100000)
	if (ent:GetFlexNum() > 0) then
		local FlexNum = ent:GetFlexNum() - 1	 
		for i=0, FlexNum-1 do
			ent:SetFlexScale( 400 )
			ent:SetFlexWeight(i,math.random(0,10)/10)
		end
	end
	if (ent:GetPhysicsObject():IsValid()) then ent:GetPhysicsObject():SetMass(1999999) end
   return true;
end
concommand.Add("jim_hitler", jim_hitler)


function jim_bowling(ply,command,arg)
	if (CLIENT || !IsTTTAdmin(ply)) then return end

	trace = util.GetPlayerTrace( ply )
	traceRes=util.TraceLine(trace)
	local iAdded = 0
	for _, v in pairs(player.GetAll()) do
		if (!v:IsSpec() && !v.IsPin) then
			ply:ChatPrint("Setting up "..v:Nick().."\n")
			v:SetVelocity(Vector(0,0,0))
			v:SetModel("models/mixerman3d/bowling/bowling_pin.mdl")
			//v:Freeze( true )
			v:StripWeapons()
			v:StripAmmo()
			v:SetPos(traceRes.HitPos)
			v:SetVelocity(Vector(0,0,0))
			
			v:SetNWBool("jim_ispin",true)
			
			local entphys = v:GetPhysicsObject();
			if entphys:IsValid() then
				entphys:SetVelocity(Vector(0,0,0))
			end
			timer.Create( "Moving"..v:EntIndex(), 0.25, 6, dosetPos, v, traceRes.HitPos, ply )
			
			v.IsPin = true
			
			SetGlobalInt("jim_currentpins", GetGlobalInt( "jim_currentpins" )+1)
			return
		end
	end
	ply:ChatPrint("No more players available!\n")
		
   return true;
end
concommand.Add("jim_bowling", jim_bowling)

function jim_baby(ply,command,arg)
	if (!IsTTTAdmin(ply) || !ply:IsSpec()) then return end
	
	local mdl = "models/props_c17/doll01.mdl"
	local ent = ents.Create( "jim_megacustom" )
	if ( !ent:IsValid() ) then return end
	ent:SetPos( ply:EyePos() )
	ent:SetAngles(ply:EyeAngles())
	ent:DoSetModel( mdl)
	ent:SetModel( mdl)
	ent:Spawn()
	ent:Activate()
	ent.BaseSizeMin = Vector(-3.4,-3.4,-8.4)
	ent.BaseSizeMax = Vector(3.4,3.4,8.4)
	ent.SoundName = ")ambient/creatures/teddy.wav"
	PROPSPEC_A.Start(ply,ent)
		
	return true;
end
concommand.Add("jim_baby",jim_baby)

function jim_cat(ply,command,arg)
	if (!IsTTTAdmin(ply) || !ply:IsSpec()) then return end
	
	local mdl = "models/alyx.mdl"
	local ent = ents.Create( "jim_megacustom" )
	if ( !ent:IsValid() ) then return end
	ent:SetPos( ply:EyePos() )
	ent:SetAngles(ply:EyeAngles())
	ent:DoSetModel("models/feline.mdl")
	ent:SetModel("models/feline.mdl")
	ent:Spawn()
	ent:Activate()
	ent.BaseSizeMin = Vector(-20,-8,0)
	ent.BaseSizeMax = Vector(20,8,20)
	ent.SoundName = ")cunt/cat01.wav"
	PROPSPEC_A.Start(ply,ent)
		
	return true;
end
concommand.Add("jim_cat",jim_cat)

function jim_chimney(ply,command,arg)
	if (!IsTTTAdmin(ply) || !ply:IsSpec()) then return end
	
	local mdl = "models/props_animated_breakable/smokestack.mdl"
	local ent = ents.Create( "jim_megacustom" )
	if ( !ent:IsValid() ) then return end
	ent:SetPos( ply:EyePos() )
	ent:SetAngles(ply:EyeAngles())
	ent:DoSetModel(mdl)
	ent:SetModel(mdl)
	ent:Spawn()
	ent:Activate()
	ent.BaseSizeMin = Vector(-192,-192,0)
	ent.BaseSizeMax = Vector(192,192,2752)
	ent.SoundName = "common/null.wav"
	PROPSPEC_A.Start(ply,ent)
		
	return true;
end
concommand.Add("jim_chimney",jim_chimney)

function jim_crate(ply,command,arg)
	if (!IsTTTAdmin(ply) || !ply:IsSpec()) then return end
	
		
	local ent = ents.Create( "jim_megacrate" )
	if ( !ent:IsValid() ) then return end
	ent:SetPos( ply:EyePos() )
	ent:SetAngles(ply:EyeAngles())
	ent:Spawn()
	ent:Activate()
	PROPSPEC_A.Start(ply,ent)
		
	return true;
end
concommand.Add("jim_crate",jim_crate)

function jim_melon(ply,command,arg)
	if (!IsTTTAdmin(ply) || !ply:IsSpec()) then return end
	
		
	local ent = ents.Create( "jim_megamelon" )
	if ( !ent:IsValid() ) then return end
	ent:SetPos( ply:EyePos() )
	ent:SetAngles(ply:EyeAngles())
	ent:DoSetModel("models/props_junk/watermelon01.mdl")
	ent:Spawn()
	ent:Activate()
	PROPSPEC_A.Start(ply,ent)
		
	return true;
end
concommand.Add("jim_melon",jim_melon)


function jim_help(ply,command,arg)
	if (CLIENT || !IsTTTAdmin(ply)) then return end
	
	for k, v in pairs(jimcmdlist) do
		ply:ChatPrint(Format("%s - %s",k,v))
	end
		
	return true;
end
concommand.Add("jim_help", jim_help)

function  jim_giveplayer(ply,command,arg)
	if (CLIENT || !IsTTTAdmin(ply) || !arg[1] || !arg[2]) then return end
	
	for _, v in pairs(player.GetAll()) do
		if (string.find(string.lower(v:Nick()), string.lower(arg[1])) != nil) or (arg[1] == "@") then
			ply:ChatPrint("Giving to "..v:Nick());
			v:Give(arg[2])
		end
	end
		
   return true;
end
concommand.Add("jim_giveplayer", jim_giveplayer)

function  jim_give(ply,command,arg)
	if (CLIENT || !IsTTTAdmin(ply) || !arg[1]) then return end
	ply:ChatPrint(Format("Spawned a %s",arg[1]))
	ply:Give(arg[1])
	
	ply:DrawWorldModel(false)
end
concommand.Add("jim_give", jim_give)

local entlist = {
["bouncer"]="jim_bouncer",
}

function jim_ent(ply,command,arg)
	if (CLIENT || !IsTTTAdmin(ply)) then return end
	if (arg[1] == nil or entlist[arg[1]] == nil) then
		local list = "jim_ent <"
		local i = 0
		for k, v in pairs(entlist) do
			list = list .. k 
			i = i + 1
			if (table.Count(entlist) > i) then
				list = list .. "|"
			end
		end
		list = list .. ">"
		ply:ChatPrint(list.."\n")
		return true
	end
	
	if (entlist[arg[1]] != nil) then
		local trace = ply:GetEyeTrace()		
		
		if (arg[1] == "bouncer") then
			local ent = ents.Create( entlist[arg[1]] )
			if ( !ent:IsValid() ) then return end
			ent:SetPos( trace.HitPos  )
			ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0))
			ent:Spawn()
			ent:Activate()
			
		end
	end
	return true;
end
concommand.Add("jim_ent", jim_ent)

function jim_alltalk(ply,command,arg)
	if (CLIENT || !IsTTTAdmin(ply)) then return end
	local jim_alltalk = ply:GetNWBool("jim_alltalk",false)
	if (jim_alltalk) then
		ply:SetNWBool("jim_alltalk",false)
		ply:ChatPrint("ALLTALK OFF")
	else
		ply:SetNWBool("jim_alltalk",true)
		ply:ChatPrint("ALLTALK ON")
	end
end
concommand.Add("jim_alltalk", jim_alltalk)

function jim_drill_admin(ply,command,arg)
	if (CLIENT || !IsTTTAdmin(ply)) then return end
	
	ply:Give("weapon_ttt_drilldo_admin")
	ply:ChatPrint(Format("Giving SUPER drilldo to %s",ply:Nick()))
end
concommand.Add("jim_drill_admin", jim_drill_admin)

function jim_meatbang(ply,command,arg)
	if (CLIENT || !IsTTTAdmin(ply)) then return end
	
	ply:Give("weapon_ttt_smokegrenade")
	ply:ChatPrint(Format("Giving bang to %s",ply:Nick()))
end
concommand.Add("jim_meatbang", jim_meatbang)

function derg_babby(ply,command,arg)
	if (CLIENT || (!IsTTTAdmin(ply) && ply:SteamID() != "STEAM_0:0:19486494")) then return end
	local trace = ply:GetEyeTrace()
	
	ply:ChatPrint("Spawning dragons baby")
	
	local ent = ents.Create( "derg_babby" )
		if ( !ent:IsValid() ) then return end
		ent:SetPos( trace.HitPos + Vector(0,0,10) )
		ent:SetAngles(Angle(0,0,0))
		ent:Spawn()
		ent:Activate()
end
concommand.Add("derg_babby", derg_babby)


function jim_disarm(ply,command,arg)
	if (CLIENT || !IsTTTAdmin(ply)) then return end

	if (arg[1] != nil) then
		for _, v in pairs(player.GetAll()) do
			if (string.find(string.lower(v:Nick()), string.lower(arg[1])) != nil) or (arg[1] == "@") then
				if (ply != nil && ply:IsPlayer()) then ply:ChatPrint("STRIPPINg "..v:Nick().."\n") end
				v:StripWeapons()
				v:StripAmmo()
			end
		end
	end
   return true;
end
concommand.Add("jim_disarm", jim_disarm)

function jim_teletarg(ply,command,arg)
	if (CLIENT || !IsTTTAdmin(ply)) then return end

	if (arg[1] != nil) then
		trace = util.GetPlayerTrace( ply )
		traceRes=util.TraceLine(trace)
		for _, v in pairs(player.GetAll()) do
			if (string.find(string.lower(v:Nick()), string.lower(arg[1])) != nil) or (arg[1] == "@") then
				if (ply != nil && ply:IsPlayer()) then ply:ChatPrint("TELEPORTING "..v:Nick().."\n") end
				v:SetPos(traceRes.HitPos+Vector(0,0,10))
			end
		end
	end
   return true;
end
concommand.Add("jim_teletarg", jim_teletarg)

function jim_teletarg_disarm(ply,command,arg)
	if (CLIENT || !IsTTTAdmin(ply)) then return end

	if (arg[1] != nil) then
		trace = util.GetPlayerTrace( ply )
		traceRes=util.TraceLine(trace)
		for _, v in pairs(player.GetAll()) do
			if (string.find(string.lower(v:Nick()), string.lower(arg[1])) != nil) or (arg[1] == "@") then
				if (ply != nil && ply:IsPlayer() && !ply:IsSpec()) then 
					ply:ChatPrint("TELEPORTING "..v:Nick().." and stripping\n") 
					v:SetPos(traceRes.HitPos+Vector(0,0,10))
					
					v:StripWeapons()
					v:StripAmmo()
				end
			end
		end
	end
   return true;
end
concommand.Add("jim_teletarg_disarm", jim_teletarg_disarm)


function myinfoFix(ply)
	local filter = RecipientFilter();
	filter:AddPlayer( ply );
	umsg.Start( "PlySpawn", filter );
	umsg.End();
end
hook.Add( "PlayerSpawn", "myinfoFix", myinfoFix );

function MeatHook( ply, handle, id, encoded, decoded )
	ply:SetMaterial(decoded.mat)
end
datastream.Hook( "MeatHook", MeatHook );


function effct(ply,command,arg)
	if (!IsTTTAdmin(ply)) then return end
	
	if (arg[1] != nil) then
		local trace = ply:GetEyeTrace()
		
		local ent = ents.Create( "jim_dummy" )
		if ( !ent:IsValid() ) then return end
		ent:SetPos( trace.HitPos + Vector(0,0,10) )
		ent:SetAngles(Angle(0,0,0))
		ent:Spawn()
		ent:Activate()
		ent:SetNWString("effect",arg[1]);
	end
	return true;
end
concommand.Add("jim_effect",effct)

function  meat(ply,command,arg)
	if (!IsTTTAdmin(ply)) then return end
	local originalply = ply;
	if (arg[1] != nil) then
		for _, v in pairs(player.GetAll()) do
			if (string.find(v:Nick(), arg[1]) != nil || arg[1] == "@all") then
				ply = v
				local bisMeated = ply:GetNWBool("jim_meatme", false)
				ply:SetNWBool("jim_meatme",!bisMeated);
				if (bisMeated) then
					originalply:ChatPrint("Disabled meatspin on "..ply:Nick());
				else
					originalply:ChatPrint("Enabled meatspin on "..ply:Nick());
				end
			end
		end
	end
	
end

concommand.Add("jim_meat", meat)

function rock(ply,command,arg)
if (!IsTTTAdmin(ply)) then return end

	local ent = ents.Create( "jim_rocket" )
	if ( !ent:IsValid() ) then return end
	 
	ent:SetPos( ply:EyePos() )
	ent:SetAngles(ply:EyeAngles())
	ent:Spawn()
	ent:Activate()
   return true;
end
concommand.Add("jim_rocket", rock)

function dickspolsion(ply,command,arg)
if (!IsTTTAdmin(ply)) then return end

	local i = 0;
		while i < 50 do
			local dildo = ents.Create("prop_physics")
			if not IsValid(dildo) then return nil end

			dildo:SetPos(ply:GetPos()+Vector(0,0,32))
			dildo:SetModel("models/jaanus/dildo.mdl")
			dildo:SetAngles(ply:GetAngles())
			dildo:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			dildo:SetOwner(ply)

			dildo:Spawn()
			dildo:Activate()
			dildo:GetPhysicsObject():SetVelocity(Vector(math.random(-150,155),math.random(-155,155),math.random(10,1050)))
			i = i + 1;
		end
		
   return true;
end
concommand.Add("jim_dickspolsion", dickspolsion)

function dick(ply,command,arg)
if (!IsTTTAdmin(ply)) then return end

	local ent = ents.Create( "jim_dick" )
	if ( !ent:IsValid() ) then return end
	 
	ent:SetPos( ply:EyePos() )
	ent:SetAngles(ply:EyeAngles())
	ent:SetOwner(ply)
	ent:Spawn()
	ent:Activate()
   return true;
end
concommand.Add("jim_dick", dick)

function spamdick(ply,command,arg)
if (!IsTTTAdmin(ply)) then return end

	local ent = ents.Create( "jim_spamdick" )
	if ( !ent:IsValid() ) then return end
	 
	ent:SetPos( ply:EyePos() )
	ent:SetAngles(ply:EyeAngles())
	ent:SetOwner(ply)
	ent:Spawn()
	ent:Activate()
   return true;
end
concommand.Add("jim_spamdick", spamdick)

function jim_drill(ply,command,arg)
	if (!IsTTTAdmin(ply) && ply:SteamID() != "STEAM_0:1:10499372") then return end
	local oldply = ply
	if (arg[1] != nil) then
		for _, v in pairs(player.GetAll()) do
			if (string.find(v:Nick(), arg[1]) != nil) then
				ply = v
			end
		end
	end
	
	ply:Give("weapon_ttt_drilldo")
	oldply:ChatPrint(Format("Giving drilldo to %s",ply:Nick()))
end
concommand.Add("jim_drill", jim_drill)

function barrelme(ply,command,arg)
	if (!IsTTTAdmin(ply)) then return end
	
	if (arg[1] != nil) then
		for _, v in pairs(player.GetAll()) do
			if (string.find(v:Nick(), arg[1]) != nil) then
				ply = v
			end
		end
	end
	
	if (!ply:GetNWBool("jim_barrel", false)) then
		ply.originalModel = ply:GetModel();
		ply:DrawWorldModel(false)	
		ply:SetModel("models/props_c17/oildrum001.mdl");
		ply:SetNWBool("jim_barrel",true);
	else
		Msg("disable barrel")
		ply:DrawWorldModel(true)
		if (ply.originalModel) then ply:SetModel(ply.originalModel) end
		ply:SetNWBool("jim_barrel",false);
	end
end
concommand.Add("jim_barrel", barrelme)

function jim_pony(ply,command,arg)
	if (!IsTTTAdmin(ply)) then return end
	local oldply = ply
	if (arg[1] != nil) then
		for _, v in pairs(player.GetAll()) do
			if (string.find(v:Nick(), arg[1]) != nil || arg[1] == "@all") then
				ply = v
				if (!ply:GetNWBool("jim_pony", false)) then
					ply.originalModel = ply:GetModel();
					ply:DrawWorldModel(false)	
					ply:SetModel("models/pinkiepie.mdl");
					ply:SetNWBool("jim_pony",true);
					
					oldply:ChatPrint(Format("pony ENABLED ON %s",v:Nick()))
				else
					ply:DrawWorldModel(true)
					if (ply.originalModel) then ply:SetModel(ply.originalModel) end
					ply:SetNWBool("jim_pony",false);
					oldply:ChatPrint(Format("pony DISABLED ON %s",v:Nick()))
				end
			end
		end
	end
end
concommand.Add("jim_pony", jim_pony)


function rag(ply,command,arg)
if (!IsTTTAdmin(ply)) then return end
	if (arg[1] == nil) then
		ply:ChatPrint("jim_rag 1 = alyx")
		ply:ChatPrint("jim_rag 2 = grigori")
		ply:ChatPrint("jim_rag 3 = barney")
		ply:ChatPrint("jim_rag 4 = kleiner")
		ply:ChatPrint("jim_rag 5 = pony1")
		return true
	end
	
	local ent = ents.Create( "prop_ragdoll" )
	if ( !ent:IsValid() ) then return end
	ent:SetPos( ply:GetPos() )
	ent:SetAngles(ply:EyeAngles())
	if (arg[1] == "1") then
		ent:SetModel("models/alyx.mdl")
	elseif (arg[1] == "2") then
		ent:SetModel("models/monk.mdl")
	elseif (arg[1] == "3") then
		ent:SetModel("models/barney.mdl")
	elseif (arg[1] == "4") then
		ent:SetModel("models/kleiner.mdl")
	elseif (arg[1] == "5") then
		ent:SetModel("models/pinkiepie.mdl")
	else
		ent:SetModel("models/alyx.mdl")
	end
	ent:Spawn()
	ent:Activate()
	ent:SetHealth(100000)
	if (ent:GetFlexNum() > 0) then
		local FlexNum = ent:GetFlexNum() - 1	 
		for i=0, FlexNum-1 do
			ent:SetFlexScale( 400 )
			ent:SetFlexWeight(i,math.random(0,10)/10)
		end
	end
	if (ent:GetPhysicsObject():IsValid()) then ent:GetPhysicsObject():SetMass(1999999) end
   return true;
end
concommand.Add("jim_rag", rag)

local proplist = {
["melon"]="models/props_junk/watermelon01.mdl",
["baby"]="models/props_c17/doll01.mdl",
["banana"]="models/props/cs_italy/bananna_bunch.mdl",
["orange"]="models/props/cs_italy/orange.mdl",
["horse"]="models/props_c17/statue_horse.mdl",
["barrel"]="models/props_c17/oildrum001.mdl",
["explosivebarrel"]="models/props_c17/oildrum001_explosive.mdl",  a
}

function propspawn(ply,command,arg)
	if (!IsTTTAdmin(ply)) then return end
	if (arg[1] == nil or proplist[arg[1]] == nil) then
		local list = "jim_prop <"
		local i = 0
		for k, v in pairs(proplist) do
			list = list .. k 
			i = i + 1
			if (table.Count(proplist) > i) then
				list = list .. "|"
			end
		end
		list = list .. ">"
		ply:ChatPrint(list.."\n")
		return true
	end
	
	if (proplist[arg[1]] != nil) then
		local trace = ply:GetEyeTrace()
		
		local ent = ents.Create( "prop_physics" )
		if ( !ent:IsValid() ) then return end
		ent:SetPos( trace.HitPos + Vector(0,0,10) )
		ent:SetAngles(Angle(0,0,0))
		ent:SetModel(proplist[arg[1]])
		ent:Spawn()
		ent:Activate()
		if (arg[1] != "explosivebarrel") then ent:SetHealth(100000) end
		if (ent:GetPhysicsObject():IsValid()) then 
			ent:GetPhysicsObject():EnableMotion(true) 
		end
	end
	return true;
end
concommand.Add("jim_prop", propspawn)

function Doorfix()
	if (!SERVER) then return end
    for k,v in pairs(ents.FindByClass("func_door")) do
        v:SetKeyValue( "loopmovesound", "0" )
    end
end
 hook.Add( "PlayerSpawn", "FixDoorLoop", Doorfix )