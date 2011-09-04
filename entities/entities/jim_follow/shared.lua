AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "Chaser."
ENT.Spawnable = false
ENT.AdminSpawnable = false
 
if (CLIENT) then
	local Laser = Material( "cable/redlaser" )
end

function ENT:Draw()
    self:DrawModel()
	
	self:SetModelScale(Vector(3,3,2+(math.sin(CurTime()*self.wobbleSpeed)/2)))
	
	local Vector1 = self:LocalToWorld( Vector( 10240, 0, 0 ) )
	local Vector2 = self:LocalToWorld( Vector( 0, 0, 0)  )
		
	render.SetMaterial( Laser )
	render.DrawBeam( Vector1, Vector2, 3, 0, 80, Color( 255, 255, 255, 255 ) )	
end

function ENT:Initialize()
    self:SetModel( "models/props_junk/watermelon01.mdl" )    
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_NONE )
	self.Target = nil
	self.LastUpdateCheck = 0
	
	self.offsetX = math.random(-25,25)
	self.offsetY = math.random(-25,25)
	self.offsetZ = math.random(-5,5)
	self.pitch = math.random(60,130)
	
	self.LastSound = -1
	
	if (CLIENT) then
		self:DrawShadow(false)
		self.wobbleSpeed = math.random(4,34)
		
		local minRender = Vector(-32, -32, -32)
		local maxRender = Vector(8000, 32, 32)
		
		self:SetRenderBounds(minRender, maxRender)
		self.Entity:SetRenderBounds(minRender, maxRender)
	end
	
end

function ENT:SetTar(ent)
	self.Exclusive = ent
	self.Target = ent
end

function ENT:UpdateTargets()

	self.Target = nil

	if (self.Exclusive != nil) then
		self.Target = self.Exclusive
		
		if (!IsValid(self.Target)) then return false else return true end
	end
	
	
	local closestPlayer = NULL
	local closestDist = -1;
	local myPos = self.Entity:GetPos()
	
	for k, v in pairs(player.GetAll()) do
		if (IsValid(v) and v:IsPlayer() and !v:IsSpec()) then
		
			local ourdist = myPos:Distance(v:GetPos())
			
			if ((closestDist == -1 or ourdist < closestDist)) then
				closestPlayer = v
				closestDist = ourdist
			end
		end
	end
	
	if (closestPlayer != NULL) then
		self.Target = closestPlayer
		return true;
	end
		
	return false;
end
	
function ENT:Think()
    if(CLIENT) then return end
	
	if (self.LastUpdateCheck < CurTime()) then
		
		if (!self:UpdateTargets()) then 
			self.Entity:Remove()
			return
		end
		
		self.LastUpdateCheck = CurTime() + 4
	end
	
	if (self.Target == nil || !IsValid(self.Target) || self.Target:IsSpec()) then 
		self.Entity:Remove()
		return
	end
	
	self.Entity:SetAngles( ( (self.Target:EyePos()+Vector(self.offsetX,self.offsetY,self.offsetZ)) - self.Entity:GetPos() ):Angle() )  //Point at our target.

	local dist = self.Entity:GetPos():Distance(self.Target:GetPos()+Vector(0,0,64))
	if (dist > 150) then
		self.Entity:SetPos(self.Entity:GetPos() + (self.Entity:GetForward()*4.5))
	end

	if (self.LastSound == -1 or self.LastSound < CurTime()) then
		local pitch = 50
		
		local dist = self.Entity:GetPos():Distance(self.Target:GetPos()+Vector(0,0,64))			
		pitch = 150-(dist/14)
		//self.LastSound = CurTime() + (dist/100)*0.1
		self.LastSound = CurTime() + (math.random(8,20)/10)
		if (dist < 160) then
			self.Entity:EmitSound("cunt/onlymelon.wav",60,self.pitch)
		end
	end
	
	self.Entity:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
end
