---- Spectator prop meddling

local string = string
local math = math

PROPSPEC_A = {}

local PROPSPEC_A_base = CreateConVar("ttt_spec_prop_base_a", "8")
local PROPSPEC_A_min = CreateConVar("ttt_spec_prop_maxpenalty_a", "-6")
local PROPSPEC_A_max = CreateConVar("ttt_spec_prop_maxbonus_a", "16")

function PROPSPEC_A.Scroll(ply,up)
	local ent = ply.propspec.ent
	if (!IsValid(ent) || !ent.ResizableProp) then return end
	local scaleMod = 0.4
	if (up) then ent:ModScale(scaleMod) else ent:ModScale(-scaleMod) end
end

function PROPSPEC_A.Start(ply, ent)
	if (ply:GetNWEntity("spec_ent", NULL) != NULL) then Msg("Tried to take control of something when already in control\n"); return end
	if (IsValid(ent:GetOwner()) && ent:GetClass() != "ttt_c4") then return end
	
	Msg(Format("Test control on %s\n",ent:GetClass()));
    if (ent:GetClass() == "env_sprite") then return end
    if (ent:GetClass() == "player") then return end
    ply:ChatPrint(Format("PropSpec: Attempting to control entity (%s)",ent:GetClass()))
	
	if (ent:GetClass() == "func_button") then 
	   ply:ChatPrint("PropSpec: Taking control of a button");
	   ply:ChatPrint("PropSpec: Mouse1: Trigger button");
	   PROPSPEC_A.Start_Physics(ply, ent); 
	   return;
   end
   
	if (ent:GetClass() == "func_breakable") then 
	   ply:ChatPrint("PropSpec: Taking control of a breakable object");
	   ply:ChatPrint("PropSpec: Mouse1: break");
	   PROPSPEC_A.Start_Physics(ply, ent); 
	   return;
   end
   
   if (ent:GetClass() == "prop_door_rotating") then 
	   ply:ChatPrint("PropSpec: Taking control of door.");
	   ply:ChatPrint("PropSpec: Mouse1: Open/Close");
	   ply:ChatPrint("PropSpec: Mouse2: Lock/Unlock");
	   ply:ChatPrint("PropSpec: Reload: Turn into prop.");
	   PROPSPEC_A.Start_Physics(ply, ent); 
	   return;
   end
   
    if (ent:GetClass() == "func_door_rotating") then 
	   ply:ChatPrint("PropSpec: Taking control of door.");
	   ply:ChatPrint("PropSpec: Mouse1: Open/Close");
	   ply:ChatPrint("PropSpec: Mouse2: Lock/Unlock");
	   ply:ChatPrint("PropSpec: Reload explode");
	   PROPSPEC_A.Start_Physics(ply, ent); 
	   return;
   end
   
   if (ent:GetClass() == "prop_physics") then PROPSPEC_A.Start_Copy(ply, ent); return; end
   if (ent:GetClass() == "prop_ragdoll") then PROPSPEC_A.Start_Physics(ply, ent); return; end
   if (ent:GetClass() == "jim_prop") then 
		PROPSPEC_A.Start_Physics(ply, ent); 
		ply:ChatPrint("Attempting jim_prop control...");
		return
   end
   if (string.match(ent:GetClass(), "item_ammo*")) then PROPSPEC_A.Start_Physics(ply, ent); return; end
   if (string.match(ent:GetClass(), "weapon_*")) then PROPSPEC_A.Start_Physics(ply, ent); return; end
   if (string.match(ent:GetClass(), "ttt_health_*")) then PROPSPEC_A.Start_Physics(ply, ent); return; end
   if (ent:GetClass() == "ttt_c4") then PROPSPEC_A.Start_Physics(ply, ent); return; end
   if (ent:GetClass() == "prop_physics_multiplayer") then PROPSPEC_A.Start_Copy(ply, ent); return; end
   if (ent:GetClass() == "prop_physics_respawnable") then PROPSPEC_A.Start_Copy(ply, ent); return; end
   if (ent:GetClass() == "prop_dynamic") then PROPSPEC_A.Start_Copy(ply, ent); return; end
   //if (ent:GetClass() == "func_breakable") then PROPSPEC_A.Start_Copy(ply, ent); return; end
   //if (ent:GetClass() == "func_physbox") then PROPSPEC_A.Start_Copy(ply, ent); return; end
   if (!ent:GetModel() || ent:GetModel() == "") then return end
   //if (ent:GetClass() == "fish") then return; end
   PROPSPEC_A.Start_Physics(ply, ent);
end

function PROPSPEC_A.Start_Physics(ply, ent)
   ply:Spectate(OBS_MODE_CHASE)
   ply:SpectateEntity(ent, true)
   
   local bonus = math.Clamp(math.ceil(ply:Frags() / 2), PROPSPEC_A_min:GetInt(), PROPSPEC_A_max:GetInt())

   ply.propspec = { ent=ent, t=0, retime=0, punches=0, max=PROPSPEC_A_base:GetInt() + bonus}

   ent:SetNWEntity("spec_owner", ply)
    ply:SetNWEntity("spec_ent", ent)
end

function PROPSPEC_A.Start_Copy(ply, ent)
	
	local newent = ents.Create("jim_prop")
	newent:SetPos(ent:GetPos())
	newent:SetAngles(ent:GetAngles())
	newent:SetModel(ent:GetModel())
	newent:SetSkin(ent:GetSkin())
	newent:SetOwner(ply)
	newent:Spawn()
    newent:SetNWEntity("spec_owner", ply)
    ply:SetNWEntity("spec_ent", newent)
	
	local phys = IsValid(ent) and ent:GetPhysicsObject()
	local newphys = IsValid(newent) and newent:GetPhysicsObject()
	
	if (IsValid(phys)) then
		//newphys:SetMass(math.Clamp(phys:GetMass(),0,5000))
		newphys:SetMass(phys:GetMass())
		newphys:SetMaterial(phys:GetMaterial())
	else
		newphys:SetMass(100)
	end
	
	Msg(Format("Forcing control of %s (%i)\n",newent:GetModel(),newphys:GetMass()));

   ply:Spectate(OBS_MODE_CHASE)
   ply:SpectateEntity(newent, true)

   local bonus = math.Clamp(math.ceil(ply:Frags() / 2), PROPSPEC_A_min:GetInt(), PROPSPEC_A_max:GetInt())

   ply.propspec = { ent=newent, t=0, retime=0, punches=0, max=PROPSPEC_A_base:GetInt() + bonus}

   ent:Remove();
end

local function IsWhitelistedClass(cls)
   return (string.match(cls, "prop_physics*") or
           string.match(cls, "func_physbox*"))
end

function PROPSPEC_A.Target(ply, ent, nearest)
   if (not IsValid(ply)) or (not ply:IsSpec()) or (not IsValid(ent)) then return end

   if ent:GetNWEntity("spec_owner") != NULL && IsTTTAdmin(ent:GetNWEntity("spec_owner")) then return end

   if ent:GetName() != "" and (not GAMEMODE.propspec_allow_named) then return end
   
    if (!ent:GetModel()) then return end
    if (ent:GetModel() == "models/error.mdl") then return end

   -- normally only specific whitelisted ent classes can be possessed, but
   -- custom ents can mark themselves possessable as well
   //if (not ent.Allowpropspec) and (not IsWhitelistedClass(ent:GetClass())) then return end
   
    //local phys = ent:GetPhysicsObject()
    //if (not IsValid(phys)) or (not phys:IsMoveable()) then
	//	ply:ChatPrint(Format("PropSpec: Attempted to control %s, but no phys data.",ent:GetClass())) 
    //end
   
	/*if (nearest == 1) then 
		ply:ChatPrint(Format("PropSpec: Failed to find entity, using nearest ent (%s)",ent:GetClass())) 
	else
		ply:ChatPrint(Format("PropSpec: Taking control of entity. (%s)",ent:GetClass())) 
	end*/

   PROPSPEC_A.Start(ply, ent)
end

function PROPSPEC_A.End(ply)
   local ent = ply.propspec.ent or ply:GetObserverTarget()
   if IsValid(ent) then
      ent:SetNWEntity("spec_owner", NULL)
   end
   local viewAng = ply:EyeAngles();
   local viewPos = ply:EyePos();
   ply.propspec = nil
   ply:SpectateEntity(nil)
   ply:Spectate(OBS_MODE_ROAMING)
   ply:ResetViewRoll()
   ply:SetNWEntity("spec_ent", NULL)
   ply:SetEyeAngles(viewAng);
   //ply:SetPos(ent:GetPos());

   timer.Simple(0.1, function()
                        if IsValid(ply) then ply:ResetViewRoll() end
                     end)
end

local PROPSPEC_A_force = CreateConVar("ttt_spec_prop_force_a", "1000")

function PROPSPEC_A.Key_Door(ply,key)
   local ent = ply.propspec.ent
   
   if key == IN_ATTACK then
      ent:Fire("toggle","",0);
      return true
   end
   
   if key == IN_ATTACK2 then
      if (!ent.locked || ent.locked == false) then
			ent.locked = true;
			ent:Fire("lock","",0);
			ply:ChatPrint("PropSpec: Door locked.");
	  else
			ent.locked = false;
			ent:Fire("unlock","",0);
			ply:ChatPrint("PropSpec: Door unlocked.");
	  end
      return true
   end
   
   if key == IN_RELOAD && ent:GetClass() == "prop_door_rotating" then
		local door = ents.Create("prop_physics")
		local doorname = ent:GetName()
		if not IsValid(door) then return nil end
		
		door:SetPos(ent:GetPos())
		door:SetModel(ent:GetModel())
		door:SetSkin(ent:GetSkin())
		door:SetAngles(ent:GetAngles())

		door:Spawn()
		door:Activate()
		
		ply:SetNWEntity("spec_ent", NULL)		
		PROPSPEC_A.Start(ply, door)		
		local phys = IsValid(ent) and door:GetPhysicsObject()
		phys:EnableMotion(false)
		door.frozen = true

		ent:Remove()
		
		for k,v in pairs(ents.FindByClass("func_areaportal")) do
			if (v:GetKeyValues().target == doorname) then
				v:Fire("Open","",0);
			end
		end
		
		ply:ChatPrint("PropSpec: This door is now a frozen prop. Click to unfreeze (or move)");
		
      return true
   elseif key == IN_RELOAD then
   
		local pos = ent:GetPos()
		ent:SetHealth(0)
		ent:Remove()
		
		local explode = ents.Create( "env_explosion" ) //creates the explosion
		explode:SetPos( pos  )
		explode:SetOwner( ply ) // this sets you as the person who made the explosion
		explode:Spawn() //this actually spawns the explosion
		explode:SetKeyValue( "iMagnitude", "10000" ) //the magnitude
		explode:SetKeyValue( "iRadiusOverride", "250" ) //the magnitude
		explode:SetKeyValue("spawnflags","828")
		explode:Fire( "Explode", 0, 0 )
		
		for i=1, 6 do
		
		local bloodeffect = ents.Create( "info_particle_system" )
		bloodeffect:SetKeyValue( "effect_name", "striderbuster_break" )
			bloodeffect:SetPos( pos ) 
		bloodeffect:Spawn()
		bloodeffect:Activate() 
		bloodeffect:Fire( "Start", "", 0 )
		bloodeffect:Fire( "Kill", "", 1.0 )
		
		end
		  
	
	end
end

function PROPSPEC_A.Key_Button(ply,key)
   local ent = ply.propspec.ent
   
   if key == IN_ATTACK then
      ent:Fire("press","",0);
      return true
   end
   
end
function PROPSPEC_A.Key_Break(ply,key)
   local ent = ply.propspec.ent
   
   if key == IN_ATTACK then
      ent:Fire("break","",0);
      return true
   end
   
end

function PROPSPEC_A.Key(ply, key)
   local ent = ply.propspec.ent
   
   local phys = IsValid(ent) and ent:GetPhysicsObject()
   if (not IsValid(ent)) or (not IsValid(phys)) then 
      PROPSPEC_A.End(ply)
      return false
   end
   if key == IN_DUCK then
	  PROPSPEC_A.End(ply)
	  return true
   end
	   
   if (ent:GetClass() == "prop_door_rotating" || ent:GetClass() == "func_door_rotating") then
		PROPSPEC_A.Key_Door(ply,key);
		return;
	end
	
	if (ent:GetClass() == "func_button" || ent:GetClass() == "func_robutton") then   
		PROPSPEC_A.Key_Button(ply,key);
		return;
	end
	
	if (ent:GetClass() == "func_breakable") then   
		PROPSPEC_A.Key_Break(ply,key);
		return;
	end

	if key == IN_ATTACK then
		if (!ent.frozen) then 
			phys:EnableMotion(false)
			ent.frozen = true
			//ent:SetColor(0, 0, 255, 128)
		else
			phys:EnableMotion(true)
			ent.frozen = false	
			//ent:SetColor(255,255,255,255)	
		end
		
      return true
   end
   
   if key == IN_DUCK then
      PROPSPEC_A.End(ply)
      return true
   end

   local pr = ply.propspec
   //if pr.t > CurTime() then return true end

   //local m = math.min(150, phys:GetMass())
   local m = phys:GetMass()
   local force = PROPSPEC_A_force:GetInt()
   if (ent:GetClass() == "prop_ragdoll") then force = force * 1.75 end
   local aim = ply:GetAimVector()

   local mf = m * force

   pr.t = CurTime() + 0.15
   
	if key == IN_JUMP || key == IN_FORWARD || key == IN_BACK || key == IN_MOVELEFT || key == IN_MOVERIGHT then
		phys:EnableMotion(true)
		ent.frozen = false;
		//ent:SetColor(255,255,255,255)	
	end

	if key == IN_ATTACK2 then
		if (ent.ResizableProp) then
			ent:DoSound()
		end
	
		if (string.find(ent:GetModel(),"alyx.mdl")) then
			local rand = math.random(1,12) 
			if (rand == 1) then ent:EmitSound("vo/npc/alyx/watchout01.wav", 100, 100) end
			if (rand == 2) then ent:EmitSound("vo/npc/alyx/watchout02.wav", 100, 100) end
			if (rand == 3) then ent:EmitSound("vo/npc/alyx/lookout01.wav", 100, 100) end
			if (rand == 4) then ent:EmitSound("vo/npc/alyx/lookout03.wav", 100, 100) end
			if (rand == 5) then ent:EmitSound("vo/streetwar/alyx_gate/al_ahno.wav", 100, 100) end
			if (rand == 6) then ent:EmitSound("vo/streetwar/alyx_gate/al_hey.wav", 100, 100) end
			if (rand == 7) then ent:EmitSound("vo/npc/alyx/gordon_dist01.wav", 100, 100) end
			if (rand == 8) then ent:EmitSound("vo/npc/alyx/al_excuse03.wav", 100, 100) end
			if (rand == 9) then ent:EmitSound("vo/npc/alyx/al_excuse02.wav", 100, 100) end
			if (rand == 10) then ent:EmitSound("vo/npc/alyx/no01.wav", 100, 100) end
			if (rand == 11) then ent:EmitSound("vo/npc/alyx/no02.wav", 100, 100) end
			if (rand == 12) then ent:EmitSound("vo/npc/alyx/no03.wav", 100, 100) end
			return
		end
		if (string.find(ent:GetModel(),"monk.mdl")) then
			local rand = math.random(1,4) 
			if (rand == 1) then ent:EmitSound("vo/ravenholm/madlaugh01.wav", 100, 100) end
			if (rand == 2) then ent:EmitSound("vo/ravenholm/madlaugh02.wav", 100, 100) end
			if (rand == 3) then ent:EmitSound("vo/ravenholm/madlaugh03.wav", 100, 100) end
			if (rand == 4) then ent:EmitSound("vo/ravenholm/madlaugh04.wav", 100, 100) end
			return
		end
		if (string.find(ent:GetModel(),"barney.mdl")) then
			local rand = math.random(1,2) 
			//if (rand == 1) then ent:EmitSound("vo/npc/barney/ba_laugh01.wav", 100, 100) end
			if (rand == 1) then ent:EmitSound("cunt/barney.wav", 500, 100) end
			if (rand == 2) then ent:EmitSound("vo/npc/barney/ba_laugh02.wav", 100, 100) end
			
			return
		end
		if (string.find(ent:GetModel(),"kleiner.mdl")) then
			local rand = math.random(1,8) 
			if (rand == 1) then ent:EmitSound("vo/k_lab/kl_ahhhh.wav", 100, 100) end
			if (rand == 2) then ent:EmitSound("vo/k_lab/kl_blast.wav", 100, 100) end
			if (rand == 3) then ent:EmitSound("vo/k_lab/kl_cantwade.wav", 100, 100) end
			if (rand == 4) then ent:EmitSound("vo/k_lab/kl_dearme.wav", 100, 100) end
			if (rand == 5) then ent:EmitSound("vo/k_lab/kl_fiddlesticks.wav", 100, 100) end
			if (rand == 6) then ent:EmitSound("vo/k_lab/kl_hedyno03.wav", 100, 100) end
			if (rand == 7) then ent:EmitSound("vo/k_lab2/kl_greatscott.wav", 100, 100) end
			if (rand == 8) then ent:EmitSound("vo/trainyard/kl_morewarn01.wav", 100, 100) end
			return
		end	
		if (string.find(ent:GetModel(),"pinkiepie.mdl")) then
			local rand = math.random(1,6) 
			//if (rand == 1) then ent:EmitSound("pp/pyro_autodejectedtie01.wav", 100, 100) end
			if (rand == 2) then ent:EmitSound("pp/pyro_cheers01.wav", 100, 100) end
			if (rand == 3) then ent:EmitSound("pp/pyro_go01.wav", 100, 100) end
			if (rand == 4) then ent:EmitSound("pp/pyro_go01.wav", 100, 100) end
			if (rand == 5) then ent:EmitSound("pp/pyro_taunts03.wav", 100, 100) end
			if (rand == 6) then ent:EmitSound("pp/pyro_taunts03.wav", 100, 100) end
			if (rand == 1) then ent:EmitSound("pp/pyro_taunts03.wav", 100, 100) end
			return
		end	
		if (string.find(ent:GetModel(),"hitler.mdl")) then
			ent:EmitSound("cunt/hitler2.wav", 100, 100)
			return
		end	
	end
	
	
   
   if key == IN_RELOAD   then
		if (!IsTTTAdmin(ply)) then 
			ply:ChatPrint("Denied.")
			return
		end
		local pos = ent:GetPos()
		ent:SetHealth(0)
		ent:Remove()
		
		local explode = ents.Create( "env_explosion" ) //creates the explosion
		explode:SetPos( pos  )
		explode:SetOwner( ply ) // this sets you as the person who made the explosion
		explode:Spawn() //this actually spawns the explosion
		explode:SetKeyValue( "iMagnitude", "10000" ) //the magnitude
		explode:SetKeyValue( "iRadiusOverride", "250" ) //the magnitude
		explode:SetKeyValue("spawnflags","828")
		explode:Fire( "Explode", 0, 0 )
		
		for i=1, 6 do
		
		local bloodeffect = ents.Create( "info_particle_system" )
		bloodeffect:SetKeyValue( "effect_name", "striderbuster_break" )
			bloodeffect:SetPos( pos ) 
		bloodeffect:Spawn()
		bloodeffect:Activate() 
		bloodeffect:Fire( "Start", "", 0 )
		bloodeffect:Fire( "Kill", "", 1.0 )
		
		end
		  
	end
	
   if key == IN_JUMP then
      phys:ApplyForceCenter(Vector(0,0, mf/1.2))
      pr.t = CurTime() + 0.05
   elseif key == IN_FORWARD then
      phys:ApplyForceCenter(aim * mf)
   elseif key == IN_BACK then
      phys:ApplyForceCenter(aim * (mf * -1))
   elseif key == IN_MOVELEFT then
      phys:AddAngleVelocity(Vector(0, 0, 200))
      phys:ApplyForceCenter(Vector(0,0, mf / 3))
   elseif key == IN_MOVERIGHT then
      phys:AddAngleVelocity(Vector(0, 0, -200))
      phys:ApplyForceCenter(Vector(0,0, mf / 3))
   else
      return true -- eat other keys, and do not decrement punches
   end
  

   return true
end

local PROPSPEC_A_retime = CreateConVar("ttt_spec_prop_rechargetime_a", "1")
function PROPSPEC_A.Recharge(ply)
   local pr = ply.propspec
   if pr.retime < CurTime() then
      pr.punches = math.min(pr.punches + 1, pr.max)
      ply:SetNWFloat("specpunches", pr.punches / pr.max)

      pr.retime = CurTime() + PROPSPEC_A_retime:GetFloat()
   end
end

