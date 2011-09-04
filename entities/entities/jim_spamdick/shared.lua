AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "Dick"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Attached = false;
ENT.KillTime = false;
ENT.FailedCollisions = 0;
ENT.SpawnTime = false
ENT.Speed = 0
ENT.Seed = 0
function ENT:Draw()
	local mod = math.sin((self.Seed+CurTime())*4)*4
	self:SetModelScale(Vector(5+mod ,5+mod , 5+mod ))
    self:DrawModel()
end

function ENT:Initialize()
	self.Seed = math.random(1,500)
    if(CLIENT) then 
	self:SetModelScale(Vector(5, 5, 5))
	return 
	end  
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
		phys:Wake()
	end
	self.SpawnTime = CurTime()
	self.Speed = math.random(-1500,-50);
	self.trail = util.SpriteTrail(self.Entity, 0, Color(140,100,50), false, 6, 0, 8, 1, "trails/smoke.vmt")	
end

function ENT:OnRemove()
    if(CLIENT) then return end
	if (IsValid(self.trail)) then self.trail:Remove() end
end


function ENT:PhysicsCollide( data, phys )
	self:EmitSound(")cunt/onlymelon.wav");
end

function ENT:Think( )
	if CLIENT then return end
	if (self.SpawnTime + 25 < CurTime()) then
		self:Remove()
	end
end


function ENT:PhysicsUpdate( phys )
	if (!self.Attached) then phys:SetVelocity( self:GetForward() * self.Speed ) end
end