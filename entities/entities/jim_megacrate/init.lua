AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.BaseSize = 20
ENT.DoSoundTime = 0
ENT.SoundPatch = false
ENT.ResizableProp = true
ENT.SoundName = ")cunt/onlymelon.wav"

function ENT:PhysicsSetup()	
	local radius = self.BaseSize*self:GetNetScale();
	
	self.Entity:PhysicsInitBox(Vector(-radius,-radius,-radius),Vector(radius,radius,radius))
	self.Entity:SetCollisionBounds(Vector(-radius,-radius,-radius),Vector(radius,radius,radius))
end

function ENT:Think()
	//self:DoSound()
	if (self:GetResized()) then
		self:SetResized(false)
		
		local radius = self.BaseSize*self:GetNetScale();		
		local curVel = Vector(0,0,0)
		local angVel = Vector(0,0,0)
		
		local entphys = self.Entity:GetPhysicsObject();
		if entphys:IsValid() then
			curVel = entphys:GetVelocity()
			angVel = entphys:GetAngleVelocity()
		end

		self.Entity:PhysicsInitBox(Vector(-radius,-radius,-radius),Vector(radius,radius,radius))
		self.Entity:SetCollisionBounds(Vector(-radius,-radius,-radius),Vector(radius,radius,radius))
		
		local entphys = self.Entity:GetPhysicsObject();
		if entphys:IsValid() then
			entphys:Wake()
			entphys:SetVelocity(curVel)
			entphys:AddAngleVelocity(angVel)
			
			entphys:SetMass(10000)
		end		
	end
end

function ENT:Initialize()

	self.Entity:DrawShadow( false )
	self.Entity:SetModel("models/props_junk/wood_crate001a.mdl")
	self.Entity:SetNetScale(1)
	self.Entity:PhysicsSetup()
	local entphys = self.Entity:GetPhysicsObject();
	if entphys:IsValid() then
		entphys:SetMass(10000)
	end
	self.SoundPatch = CreateSound(self.Entity, self.SoundName );
	
end

ENT.SoundVol = 500

function ENT:DoSound()
/*return;
local pitch = self:GetNetScale()

if (pitch > 1) then
	local maxScale = 30
	local minPitch = 15
	local maxPitch = 100
	pitch = ((100-pitch)/maxScale)- (100/maxScale)
	pitch = math.Clamp(1-math.abs(pitch),0,1)
	pitch = minPitch+(pitch*(maxPitch-minPitch))
	self:EmitSound(self.SoundName , self.SoundVol, math.Clamp(pitch,0,255))
	//self.SoundPatch:Stop()
	//self.SoundPatch:PlayEx(1,pitch)
	return
end

if (pitch < 1) then
	local minPitch = 100
	local maxPitch = 180
	pitch = (1-pitch)
	pitch = minPitch+(pitch*(maxPitch-minPitch))
	self:EmitSound(self.SoundName, self.SoundVol, math.Clamp(pitch,0,255))
	//self.SoundPatch:Stop()
	//self.SoundPatch:PlayEx(1,pitch)
	return
end

	self.Entity:EmitSound( self.SoundName, self.SoundVol, 100)
	//self.SoundPatch:Stop()
	//self.SoundPatch:PlayEx(1,100)*/
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