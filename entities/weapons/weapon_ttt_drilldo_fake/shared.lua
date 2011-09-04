
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
    
SWEP.HoldType = "pistol"

if CLIENT then

   SWEP.PrintName    = "FAKE DRILLDO"
   SWEP.Slot         = 6
  
   SWEP.ViewModelFlip = false

   SWEP.Icon = "VGUI/ttt/icon_drilldo"
end

SWEP.Base               = "weapon_tttbase"

SWEP.ViewModel      = "models/jaanus/v_drilldo.mdl"
SWEP.WorldModel   = "models/jaanus/w_drilldo.mdl"

SWEP.DrawCrosshair      = false
SWEP.AutoSwitchTo      = true
SWEP.Primary.Damage         = 500
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 0.2
SWEP.Primary.Ammo       = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 0.1

SWEP.AllowDrop = false
SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = nil -- only traitors can buy
SWEP.LimitedStock = false
SWEP.WeaponID = AMMO_KNIFE

SWEP.IsSilent = true

-- Pull out faster than standard guns
SWEP.DeploySpeed = 1

SWEP.iDelay = CurTime();

function SWEP:PrimaryAttack()  
	return   
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Equip()
end

function SWEP:PreDrop()
end

function SWEP:OnRemove()
end

if CLIENT then
   function SWEP:DrawHUD()
      
   end
end

SWEP.d = CurTime();
function SWEP:Think()
	if SERVER && CurTime() > self.d then
		if (!self.soundpatch) then self.soundpatch = CreateSound(self.Owner, Sound("npc/dog/dog_servo6.wav") ) end;
		if (self.soundpatch) then
			self.soundpatch:Stop()
			self.soundpatch:Play()
			self.soundpatch:ChangePitch(105);
			self.d = CurTime() + 0.2;
		end
	end
	
	return true
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:SetSpeed(false,true);
	end
	self:SendWeaponAnim(ACT_VM_DRAW)
		
	return true
end

function SWEP:Holster( wep )
	if SERVER then
		self.Owner:SetSpeed(false,false);
	end
	return true
end

if CLIENT then
   function SWEP:Initialize()
      return self.BaseClass.Initialize(self)
   end
end