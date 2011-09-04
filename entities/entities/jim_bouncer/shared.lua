AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "bouncer"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.force = 1724

function ENT:Initialize()
	if CLIENT then return end
    self:SetModel( "models/props_lab/blastdoor001c.mdl" )    
	
	
    self:SetMoveType( MOVETYPE_VPHYSICS    )
    self:SetSolid( SOLID_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )
	
	phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
	
	
end

function ENT:PhysicsCollide( data, physobj )
	if (data.HitEntity && IsValid(data.HitEntity)) then
		if (data.HitEntity:IsPlayer()) then data.HitEntity:SetHealth(200) end
		data.HitEntity:SetVelocity(self.Entity:GetUp() * self.force )
		
	end
end

function ENT:Initialize()
	if CLIENT then return end
    self:SetModel( "models/props_junk/trashdumpster02b.mdl" )    
	
	
    self:SetMoveType( MOVETYPE_NONE )
    self:SetSolid( SOLID_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )
	
	phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
	
end

function ENT:Draw()
	render.SuppressEngineLighting( true )
	render.SetColorModulation( 0, 0, 1 )
	render.SetBlend( 1 )
	SetMaterialOverride( "debug/white" )

	self:DrawModel()
	render.SuppressEngineLighting( false )
end