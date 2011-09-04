AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "Rocket"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.trigger = 200 //danger zoneeee
ENT.pitch = 80
ENT.active = false
ENT.triggered = false
ENT.explodewatch = 0
ENT.explodetime = 1.5
ENT.pitch = 60
ENT.activewatch = 0
ENT.activetime = 2

function ENT:Initialize()
	if CLIENT then return end
    self:SetModel( "models/props_c17/doll01.mdl" )    
	
	
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )
	
	phys = self:GetPhysicsObject()
	if IsValid(phys) then
		self:GetPhysicsObject():ApplyForceCenter( Vector( 0, 0, 20 ) )
	end
	
	self.activewatch = CurTime() + self.activetime
	
	self.pitch = math.random(1,255)
end

function ENT:Think()
    if(CLIENT) then return end
	self:NextThink(CurTime()+.1)
	

	local mypos = self.Entity:LocalToWorld(self.Entity:OBBCenter( ))
	local close = false
			
	for k, v in pairs(player.GetAll()) do
		if (v:IsValid() and v:IsPlayer() and v:Alive() and !v:IsSpec()) then
			local ourdist = mypos:Distance(v:GetPos())
			if (ourdist < self.trigger) then
				local theirpos = v:LocalToWorld(v:OBBCenter( ))
				local tracedata = {}
				tracedata.start = mypos
				tracedata.endpos = theirpos
				tracedata.filter = self.Entity
				local trace = util.TraceLine(tracedata)
				if (trace.HitNonWorld && trace.Entity && trace.Entity == v) then
					close = true	
				end						
			end
		end
	end
	
	if self.active then
		if not self.triggered then
			if close then --triggered
				self.triggered = true
				self:SetColor(255,0,0,255)
				self:SetPos(self:GetPos() + Vector(0,0,5))
				phys = self:GetPhysicsObject()
				
				if IsValid(phys) then 
					phys:EnableGravity(false)
					phys:Sleep()
					phys:Wake()
					phys:ApplyForceCenter( Vector( 0, 0, 20 ))  
					phys:AddAngleVelocity(Vector(0,10000,0))

				end
				
				self.explodewatch = CurTime() + self.explodetime
			end
		else --exploding
				self.Entity:StopSound("ambient/creatures/teddy.wav")
				self.Entity:EmitSound("ambient/creatures/teddy.wav",80, self.pitch)
				phys:AddAngleVelocity(Vector(0,10000,0))
				self.pitch = self.pitch + 5
				if self.pitch > 255 then
					self.pitch = math.random(0,255)
				end
				
				if self.explodewatch < CurTime() then
					self.Entity:StopSound("ambient/creatures/teddy.wav")
					
					explode = ents.Create( "env_explosion" ) //creates the explosion
					explode:SetPos(self:GetPos()  )
					//explode:SetOwner( self.owner ) // this sets you as the person who made the explosion
					explode:Spawn() //this actually spawns the explosion
					explode:SetKeyValue( "iMagnitude", "80" ) //the damage
					explode:SetKeyValue( "iRadiusOverride", "300" ) //the rad
					explode:Fire( "Explode", 0, 0 )
					
					self.Entity:Remove()
				end	
		end
	else
		if self.activewatch < CurTime() then
			self.active = true
			self:EmitSound("HL1/fvox/activated.wav")
		end
	end
	
	
	return true
end

