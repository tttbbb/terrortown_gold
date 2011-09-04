AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "Dick"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Attached = false;
ENT.KillTime = false;
function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    if(CLIENT) then return end  
	if (self.Attached) then return end
	local curAngle = self:GetAngles()
	curAngle:RotateAroundAxis(curAngle:Right(), -180)
	curAngle:RotateAroundAxis(curAngle:Forward(), -180)
	self:SetAngles(curAngle);
	
	self:SetModel("models/jaanus/dildo.mdl");
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject();
	if (IsValid(phys)) then 
	//phys:EnableGravity(false) 
	phys:Wake()
	end
	
	self.trail = util.SpriteTrail(self.Entity, 0, Color(140,100,50), false, 6, 0, 0.3, 1, "trails/smoke.vmt")	
end

function ENT:OnRemove()
    if(CLIENT) then return end
	if (IsValid(self.trail)) then self.trail:Remove() end
end

function ENT:Think()
	if SERVER then
		if self.KillTime && self.KillTime < CurTime() then self:Remove() end
	end
end

function ENT:PhysicsCollide( data, phys )
	if (self.Attached) then return end
	self.Attached = true;
	
	local hitEnt = data.HitEntity
	local hitObj = data.HitEntity
	if (hitEnt:IsWorld()) then
		phys:EnableMotion(false);
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetPos(self:GetPos()+(self:GetForward()*-10))
		self:EmitSound("Flesh.BulletImpact");
		self.KillTime = CurTime()+35
		return
	end
	
	if (hitEnt:IsPlayer()) then
		local hp = hitEnt:Health();
		if (hp > 30) then hitEnt:SetHealth(hitEnt:Health()-30) else hitEnt:Kill() end
		self:EmitSound("Flesh.BulletImpact");
		self:EmitSound("Flesh_Bloody.ImpactHard");
	else
		hitEnt:SetHealth(hitEnt:Health()-30)
	end
	
	
	phys:EnableMotion(false);
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetNoDraw( true )
	self.KillTime = CurTime()+1
end



function ENT:PhysicsUpdate( phys )
	if (!self.Attached) then phys:SetVelocity( self:GetForward() * -2700 ) end
end