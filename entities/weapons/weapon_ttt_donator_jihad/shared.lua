//Jihad Bomb

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

if CLIENT then
   SWEP.PrintName = "Suicide Bomber"
   SWEP.Slot = 1
   //SWEP.Icon = ""
   SWEP.DrawCrosshair   = false
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

SWEP.ViewModel  = Model("models/weapons/v_c4.mdl")
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")

SWEP.PlayerSpeedMod = 1

local screamSound		= Sound("siege/jihad.wav")
local bombSound			= Sound("siege/big_explosion.wav")
SWEP.ScreamPatch 		= nil

SWEP.Exploded = false
SWEP.BombStage = 0 // 0 - Ready, 1 - Screaming
SWEP.PendingExplosion = false
SWEP.StartExplode = 0
SWEP.ExplodeMinTime = 2.5

function SWEP:Initialize()
	self:MakeSound();
end

function SWEP:MakeSound()
	if (!self.Owner || !IsValid(self.Owner)) then return end
	self.ScreamPatch = CreateSound(self.Owner, screamSound)
end

function SWEP:Think()
	if (CLIENT || !self.Owner || self.Owner == NULL) then return end
	
	if ( self.Owner:KeyPressed( IN_ATTACK ) && self.BombStage == 0) then
		self:StartScream()
	elseif ((self.Owner:KeyReleased( IN_ATTACK ) && self.BombStage == 1) || self.PendingExplosion) then
		self:DoExplode()
	end
end

function SWEP:StartScream()
	if (self.Exploded) then return end
	self.StartExplode = CurTime()
	self.BombStage = 1;
	
	if (self.ScreamPatch == nil) then self:MakeSound() end
	if (self.ScreamPatch == nil) then Msg("ERROR: Jihad sound still nil after attempted load...\n") return end
	
	self.ScreamPatch:Play()	
	self.PlayerSpeedMod = 1.3
end

function SWEP:DoExplode()
	if (self.Exploded) then return end
	
	if (self.StartExplode+self.ExplodeMinTime > CurTime()) then
      self.PendingExplosion = true
      return
    end

	self.Exploded = true;
	
	if (self.Owner && IsValid(self.Owner)) then
		local targPos = self.Owner:GetPos()
		
		WorldSound(bombSound, targPos, 120, 100)
		
		local explode = ents.Create( "env_explosion" )
		explode:SetPos( targPos )
		explode:SetOwner( self.Owner )
		explode:Spawn()
		explode:SetKeyValue( "iMagnitude", "350" )
		explode:SetKeyValue( "iRadiusOverride", "560" )
		explode:Fire( "Explode", 0, 0 )
	else
		Msg("Error: self.Entity wasn't valid...\n")
	end
	
	self.ScreamPatch:Stop();
	self:Remove()
end


function SWEP:Holster()
	if (!self.Exploded && self.BombStage == 1) then 
		self:DoExplode()
	end
	return true
end

function SWEP:OnRemove()
	if (!self.Exploded && self.BombStage == 1) then 
		self:DoExplode()
	end
	return true
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end