AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "Rocket"
ENT.Spawnable = false
ENT.AdminSpawnable = false
 
function ENT:Draw()
	if (self:GetNWEntity("spec_owner") == LocalPlayer()) then 
		self:SetColor(255, 255, 255, 175)
	else
		self:SetColor(255, 255, 255, 255)
	end
    self:DrawModel()
end

function ENT:Initialize()
    if(CLIENT) then return end  
	
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject();
	if (IsValid(phys)) then phys:EnableDrag(false) end
	//self:GetPhysicsObject():SetMass(10000)
	//self.Entity:GetPhysicsObject():SetMass(10000)
	//self.trail = util.SpriteTrail(self.Entity, 0, Color(255,255,255), true, 15, 0, 10, 1/(15)*0.5, "jim/trail.vmt")	
end

function ENT:SetPlayer(ply)
    self.ply = ply
	self.Entity:SetOwner(ply)
end

function ENT:OnRemove()
    if(CLIENT) then return end
	if (IsValid(self.trail)) then self.trail:Remove() end
end

function ENT:PhysicsCollide( data, physobj )
	local sOwner = self.Entity:GetNWEntity("spec_owner");
	
	if (!sOwner || !IsValid(sOwner) || !IsTTTAdmin(sOwner) || !sOwner:KeyDown( IN_SPEED )) then return end
	
	if (IsValid(data.HitEntity) && (
	data.HitEntity:GetClass() == "prop_door_rotating" || 
	data.HitEntity:GetClass() == "func_door" || 
	data.HitEntity:GetClass() == "func_door_rotating" || 
	data.HitEntity:GetClass() == "prop_physics"|| 
	data.HitEntity:GetClass() == "prop_physics_multiplayer" ||
	data.HitEntity:GetClass() == "func_breakable" ||
	data.HitEntity:GetClass() == "func_breakable_surf" ||
	data.HitEntity:GetClass() == "prop_dynamic"||
	data.HitEntity:GetClass() == "prop_ragdoll"||
	data.HitEntity:GetClass() == "jim_prop" ||
	string.find(data.HitEntity:GetClass(),"ttt_") ||
	string.find(data.HitEntity:GetClass(),"weapon_") ||
	string.find(data.HitEntity:GetClass(),"item_")
	))	then
		if (data.HitEntity:GetClass() == "jim_prop") then
			local sOwner2 = data.HitEntity:GetNWEntity("spec_owner");
			if (sOwner2 && IsValid(sOwner2) && IsTTTAdmin(sOwner2)) then return end			
		end
		
		local bloodeffect = ents.Create( "info_particle_system" )
		bloodeffect:SetKeyValue( "effect_name", "striderbuster_break" )
			bloodeffect:SetPos( data.HitPos ) 
		bloodeffect:Spawn()
		bloodeffect:Activate() 
		bloodeffect:Fire( "Start", "", 0 )
		bloodeffect:Fire( "Kill", "", 1.0 )
		data.HitEntity:Remove()
		local phy = self.Entity:GetPhysicsObject()
		if (phy:IsValid()) then phy:SetVelocity(data.OurOldVelocity) end
	end
end