AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "Rocket"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.iTick = 0;
if (CLIENT) then 
Laser = Material( "cable/redlaser" )
end
 
function ENT:Draw()
	
	
	local Vector1 = self:LocalToWorld( Vector( 50000, 50000, 50000 ) )
	local Vector2 = self:LocalToWorld( Vector( -50000, -50000, -50000 )  )
	self.Entity:SetRenderBoundsWS( Vector2, Vector1 ) 
	self:SetRenderBoundsWS( Vector2, Vector1 ) 
	
	
	render.SetMaterial( Laser )
	render.DrawBeam( Vector1, Vector2, 3, 0, 80, Color( 255, 255, 255, 255 ) ) 
	
	self:SetModelScale(Vector(3+(math.sin(CurTime())*2), 3+(math.sin(CurTime())*2), 3+(math.sin(CurTime())*2)))
    self:DrawModel()
	
end

function ENT:Initialize()
	//self:SetModel( "models/weapons/w_missile.mdl" )
	//self:SetModel( "models/alyx.mdl" )
	//local rand = math.random(2,2) 
	//if (rand == 1) then
	//	self.Mod = "barney"
	//	self:SetModel( "models/barney.mdl" )
	//elseif (rand == 2) then
		self.Mod = "alyx"
		self:SetModel( "models/alyx.mdl" )
	//elseif (rand == 3) then
	//	self.Mod = "baby"
	//	self:SetModel( "models/props_c17/doll01.mdl" )
	//elseif (rand == 4) then
	//	self.Mod = "melon"
	//	self:SetModel( "models/props_junk/watermelon01.mdl" )
	//end
    if(CLIENT) then 
		self.Entity:SetRenderBoundsWS( Vector(-90000,-90000,-90000), Vector(90000,90000,90000) )
		self:SetRenderBoundsWS( Vector(-90000,-90000,-90000), Vector(90000,90000,90000) )
		self.Entity:SetRenderBounds( Vector(-90000,-90000,-90000), Vector(90000,90000,90000) )
		self:SetRenderBounds( Vector(-90000,-90000,-90000), Vector(90000,90000,90000) )
	return 
	
	end
    
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_NONE )
	self.Target = nil
	self.LastThink = 0
	
	local bloodeffect = ents.Create( "info_particle_system" )
	bloodeffect:SetKeyValue( "effect_name", "Advisor_Pod_Steam_Continuous" )
	bloodeffect:SetPos( self.Entity:GetPos()+Vector(-45,0,0) ) 
	bloodeffect:SetAngles( self.Entity:GetAngles()-Vector(-180,0,0) ) 
	bloodeffect:Spawn()
	bloodeffect:Activate() 
	bloodeffect:Fire( "Start", "", 0 )
	bloodeffect:SetParent(self.Entity)
	/*if (self.Mod == "melon") then
		self.Trail = util.SpriteTrail(self.Entity, 0, Color(255,255,255), false, 32, 16, 12, 1/(40+1)*0.5, "cunt/_f2.vmt")
	else
		self.Trail = util.SpriteTrail(self.Entity, 0, Color(255,255,255), false, 128, 64, 12, 1/(40+1)*0.5, "cunt/_hello.vmt")
	end*/
	self.LastSound = -1
end

function ENT:Think()
    if(CLIENT) then return end
	self.iTick = self.iTick + 1;
	if (self.LastThink < CurTime()) then
		local mypos = self.Entity:GetPos()
		local closest = -1
		local closestplayer = nil
		
		for k, v in pairs(player.GetAll()) do
			if (v:IsValid() and v:IsPlayer() 
			and v:Team() < 100
			) then
				local ourdist = mypos:Distance(v:GetPos())
				if ((closest == -1 or ourdist < closest) && !IsTTTAdmin(v)) then
					closestplayer = v
					closest = ourdist
				end
			end
		end
		if (closestplayer == nil) then 
			self.Entity:Remove() 
			return 
		end
		if (closestplayer != self.Target) then
			self.Target = closestplayer
		end
		
		self.LastThink = CurTime()+0.5
		
		
	end
	if (self.Target != nil && self.Target:IsValid() && self.Target:IsPlayer()) then
		local endang = ( (self.Target:GetPos()+Vector(0,0,64)) - self.Entity:GetPos() ):Angle();
		
		endang:RotateAroundAxis(endang:Forward(), self.iTick*2)
		self.Entity:SetAngles( endang )  
		
		local dist = self.Entity:GetPos():Distance(self.Target:GetPos()+Vector(0,0,64))
		if (dist  < 50) then
			local position = self.Entity:GetPos()
			local damage = 10000
			local radius = 128
			local attacker = self.Target
			local inflictor = self.Entity
			util.BlastDamage(inflictor, attacker, position, radius, damage)
			
			local effectdata = EffectData()
			effectdata:SetStart( position ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
			effectdata:SetOrigin( position )
			effectdata:SetScale( 1 )
			util.Effect( "Explosion", effectdata )	
			self.Entity:EmitSound("ambient/voices/f_scream1.wav");
			self.Entity:Remove()
		end
	end
	if (self.Entity:IsValid()) then 
		self.Entity:SetPos(self.Entity:GetPos() + (self.Entity:GetForward()*4.5))
		
	end
	
	if (self.LastSound == -1 or self.LastSound < CurTime()) then
		if (self.Entity:IsValid()) then
			local pitch = 50
			
			local dist = self.Entity:GetPos():Distance(self.Target:GetPos()+Vector(0,0,64))
			
			pitch = 150-(dist/14)
			//self.LastSound = CurTime() + (dist/100)*0.1
			self.LastSound = CurTime() + 0.8
			
			//self.Entity:EmitSound("npc/roller/mine/rmine_blip3.wav",80,math.Clamp(pitch, 50,150))
			if (self.Mod == "barney") then
				self.Entity:EmitSound("cunt/barney.wav",80,math.Clamp(pitch, 80,120))
			elseif (self.Mod == "alyx") then
				local rand = math.random(1,6) 
				if (rand == 1) then self.Entity:EmitSound("vo/npc/alyx/hurt04.wav",80,math.Clamp(pitch, 80,120)) end
				if (rand == 2) then self.Entity:EmitSound("vo/npc/alyx/hurt05.wav",80,math.Clamp(pitch, 80,120)) end
				if (rand == 3) then self.Entity:EmitSound("vo/npc/alyx/hurt06.wav",80,math.Clamp(pitch, 80,120)) end
				if (rand == 4) then self.Entity:EmitSound("vo/npc/alyx/hurt08.wav",80,math.Clamp(pitch, 80,120)) end
				if (rand == 5) then self.Entity:EmitSound("vo/npc/alyx/uggh01.wav",80,math.Clamp(pitch, 80,120)) end
				if (rand == 6) then self.Entity:EmitSound("vo/npc/alyx/uggh02.wav",80,math.Clamp(pitch, 80,120)) end
				
			elseif (self.Mod == "baby") then
				self.Entity:EmitSound("ambient/creatures/teddy.wav",80,math.Clamp(pitch, 60,140))
			elseif (self.Mod == "melon") then
				self.Entity:EmitSound("cunt/melon_solo.wav",80,math.Clamp(pitch, 60,140))
			end
		end
	end
	
	self.Entity:NextThink(CurTime()+0.025)
	return true
end

function ENT:OnRemove()
    if(CLIENT) then return end
	//self.Trail:Remove()
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end;
