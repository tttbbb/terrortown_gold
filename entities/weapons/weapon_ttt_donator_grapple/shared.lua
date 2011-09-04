//Grappling weapons for Natrox

if SERVER then
   AddCSLuaFile( "shared.lua" )
end


if CLIENT then
   SWEP.PrintName = "Grappling Hook"
   SWEP.Slot = 1

   SWEP.Icon = ""
   
   SWEP.DrawCrosshair   = true
   SWEP.ViewModelFOV    = 82
   SWEP.ViewModelFlip   = false
   SWEP.CSMuzzleFlashes = false
end


SWEP.Base = "weapon_ttt_donator_base"

SWEP.Primary.Recoil	= 0
SWEP.Primary.Damage = 0
SWEP.Primary.Delay = 0.10
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = -1
SWEP.Primary.ClipMax = -1
SWEP.Primary.Ammo = "Pistol"

SWEP.ViewModel			= "models/weapons/v_crossbow.mdl"
SWEP.WorldModel			= "models/weapons/w_crossbow.mdl"
SWEP.HoldType = "pistol"

SWEP.Primary.Sound = Sound( "Weapon_Glock.Single" )

local sndPowerUp		= Sound("weapons/crossbow/hit1.wav")
local sndPowerDown		= Sound("Airboat.FireGunRevDown")
local sndTooFar			= Sound("buttons/button10.wav")


function SWEP:Initialize()
	nextshottime = CurTime()
end

function SWEP:Think()

	if (CLIENT || !self.Owner || self.Owner == NULL) then return end
	
	if ( self.Owner:KeyPressed( IN_ATTACK ) ) then
	
		self:StartAttack()
		
	elseif ( self.Owner:KeyDown( IN_ATTACK ) && inRange ) then
	
		self:UpdateAttack()
		
	elseif ( self.Owner:KeyReleased( IN_ATTACK ) && inRange ) then
	
		self:EndAttack( true )
	
	end
end

function SWEP:DoTrace( endpos )
	local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = trace.start + (self.Owner:GetAimVector() * 14096) //14096 is length modifier.
		if(endpos) then trace.endpos = (endpos - self.Tr.HitNormal * 7) end
		trace.filter = { self.Owner, self.Weapon }
		
	self.Tr = nil
	self.Tr = util.TraceLine( trace )
end

function SWEP:StartAttack()
	//Get begining and end poins of trace.
	local gunPos = self.Owner:GetShootPos() //Start of distance trace.
	local disTrace = self.Owner:GetEyeTrace() //Store all results of a trace in disTrace.
	local hitPos = disTrace.HitPos //Stores Hit Position of disTrace.
			
	
	//Calculate Distance
	//Thanks to rgovostes for this code.
	local x = (gunPos.x - hitPos.x)^2;
	local y = (gunPos.y - hitPos.y)^2;
	local z = (gunPos.z - hitPos.z)^2;
	local distance = math.sqrt(x + y + z);
	
	inRange = false
	if distance <= 800 && (gunPos.z < hitPos.z) && !disTrace.HitSky && disTrace.HitWorld then
		inRange = true
	end
	
	if inRange then
		if (SERVER) then
			
			if (!self.Beam) then //If the beam does not exist, draw the beam.
				//grapple_beam
				self.Beam = ents.Create( "grapple_trace" )
					self.Beam:SetPos( self.Owner:GetShootPos() )
				self.Beam:Spawn()
			end
			
			self.Beam:SetParent( self.Owner )
			self.Beam:SetOwner( self.Owner )
		
		end
		
		self:DoTrace()
		self.speed = 10000 //Rope latch speed. Was 3000.
		self.startTime = CurTime()
		self.endTime = CurTime() + self.speed
		self.dtime = -1
		
		if (SERVER && self.Beam) then
			self.Beam:GetTable():SetEndPos( self.Tr.HitPos )
		end
		
		self:UpdateAttack()
		
		self.Owner:EmitSound( sndPowerDown )
	else
		//Play A Sound
		self.Owner:EmitSound( sndTooFar )
	end
end

function SWEP:UpdateAttack()

	if (!self.Tr) then self:EndAttack( false ) end
	
	if (!endpos) then endpos = self.Tr.HitPos end
	
	if (SERVER && self.Beam) then
		self.Beam:GetTable():SetEndPos( endpos )
	end

	lastpos = endpos
	
	
			if ( self.Tr.Entity:IsValid() ) then
			
					endpos = self.Tr.Entity:GetPos()
					if ( SERVER ) then
					self.Beam:GetTable():SetEndPos( endpos )
					end
			
			end
			
			local vVel = (endpos - self.Owner:GetPos())
			local Distance = endpos:Distance(self.Owner:GetPos())
			
			local et = (self.startTime + (Distance/self.speed))
			
			if(self.dtime != 0) then
				self.dtime = ((et - CurTime()) / (et - self.startTime))
			end
			
			if(self.dtime < 0) then
				self.Owner:EmitSound( sndPowerUp )
				self.dtime = 0
			end
			
			if(self.dtime == 0) then
				zVel = self.Owner:GetVelocity().z
				vVel = vVel:GetNormalized()*(math.Clamp(Distance,0,7))
				if( SERVER ) then
				local gravity = GetConVarNumber("sv_Gravity")
				vVel:Add(Vector(0,0,(gravity/100)*1.5)) //Player speed. DO NOT MESS WITH THIS VALUE!
				if(zVel < 0) then
					vVel:Add(Vector(0,0,zVel/75))
				end
				self.Owner:SetVelocity(vVel)
				end
			end
	
	endpos = nil
	
	
end

function SWEP:EndAttack( shutdownsound )
	
	if ( shutdownsound ) then
		self.Owner:EmitSound( sndPowerDown )
	end
	
	if ( CLIENT ) then return end
	if ( !self.Beam || !IsValid(self.Beam) ) then return end
	
	self.Beam:Remove()
	self.Beam = nil
	
end


function SWEP:Holster()
	self:EndAttack( false )
	return true
end

function SWEP:OnRemove()
	self:EndAttack( false )
	return true
end


function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end