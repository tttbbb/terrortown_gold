
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
    
SWEP.HoldType = "pistol"

if CLIENT then

   SWEP.PrintName    = "drilldo_name"
   SWEP.Slot         = 6
  
   SWEP.ViewModelFlip = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "drilldo_desc"
   };

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


SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = AMMO_KNIFE

SWEP.IsSilent = true

-- Pull out faster than standard guns
SWEP.DeploySpeed = 2

SWEP.iDelay = CurTime();

function SWEP:PrimaryAttack()  
	self.iDelay = CurTime()+ self.Primary.Delay;
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )	
	if (!self.soundpatch) then self.soundpatch = CreateSound(self.Owner, Sound("npc/dog/dog_servo6.wav") ) end;
	
	if SERVER then
		self.soundpatch:Stop()
		self.soundpatch:Play()
		if (self.Owner.charging) then 
			self.soundpatch:ChangePitch(135); 
		else
			self.soundpatch:ChangePitch(105);
		end
	else
		self.soundpatch:Stop()
		self.soundpatch:Play()
		if (self.Owner:GetNetworkedBool("pl_charging")) then 
			self.soundpatch:ChangePitch(135); 
		else
			self.soundpatch:ChangePitch(105);
		end
	end
   
	//self.Weapon:EmitSound("npc/dog/dog_servo6.wav")
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	
	self.Owner:LagCompensation(true)

	local spos = self.Owner:GetShootPos()
	local sdest = spos + (self.Owner:GetAimVector() * 70)

	local kmins = Vector(1,1,1) * -10
	local kmaxs = Vector(1,1,1) * 10

	local tr = util.TraceHull({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

	-- Hull might hit environment stuff that line does not hit
	if not IsValid(tr.Entity) then
	  tr = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
	end

	local hitEnt = tr.Entity

	-- effects
	if IsValid(hitEnt) then
	  self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

	  local edata = EffectData()
	  edata:SetStart(spos)
	  edata:SetOrigin(tr.HitPos)
	  edata:SetNormal(tr.Normal)
	  edata:SetEntity(hitEnt)

	  if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
		 util.Effect("BloodImpact", edata)
	  end
	else
	  self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	end

	if SERVER then
	  self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end


	if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) then
	  if hitEnt:IsPlayer() then
			self:StabKill(tr, spos, sdest)
	  end
	end

	self.Owner:LagCompensation(false)
   
end

function SWEP:SecondaryAttack()
	if (self.Owner.cancharge && !self.Owner.charging) then self.Owner.charging = true end
end

function SWEP:StabKill(tr, spos, sdest)
   local target = tr.Entity
   
   target:EmitSound("physics/flesh/flesh_bloody_break.wav");
   target:EmitSound("physics/flesh/flesh_bloody_break.wav");
   target:EmitSound("physics/flesh/flesh_bloody_break.wav");
   
   local model = target:GetModel()
   if (model) then
		if (model == "models/player/barney.mdl") then self.Owner:EmitSound("vo/npc/barney/ba_ohshit03.wav"); end
		if (model == "models/player/kleiner.mdl") then self.Owner:EmitSound("vo/k_lab/kl_ohdear.wav"); end		
   end

   local dmg = DamageInfo()
   dmg:SetDamage(2000)
   dmg:SetAttacker(self.Owner)
   dmg:SetInflictor(self.Weapon or self)
   dmg:SetDamageForce(self.Owner:GetAimVector())
   dmg:SetDamagePosition(self.Owner:GetPos())
   dmg:SetDamageType(DMG_SLASH)

   -- now that we use a hull trace, our hitpos is guaranteed to be
   -- terrible, so try to make something of it with a separate trace and
   -- hope our effect_fn trace has more luck

   -- first a straight up line trace to see if we aimed nicely
   local retr = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})

   -- if that fails, just trace to worldcenter so we have SOMETHING
   if retr.Entity != target then
      local center = target:LocalToWorld(target:OBBCenter())
      retr = util.TraceLine({start=spos, endpos=center, filter=self.Owner, mask=MASK_SHOT_HULL})
   end


   -- create knife effect creation fn

   local prints = self.fingerprints
   local ignore = self.Owner

   target.effect_fn = function(rag)
	   /*local bone = rag:LookupBone("ValveBiped.Bip01_Pelvis")
	   local BonePos , BoneAng = rag:GetBonePosition(bone )
	   local pos = BonePos;
		local ang = BoneAng;
		ang:RotateAroundAxis(ang:Right(), -90);
		pos = pos + (ang:Forward() * 4)
		pos = pos + (ang:Right() * 4)*/

		 /*local knife = ents.Create("prop_physics")
		 knife:SetModel("models/jaanus/dildo.mdl")
		 knife:SetPos(pos)
		 //knife:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		 knife:SetAngles(ang)
		 knife.CanPickup = false

		 knife:Spawn()

		 local phys = knife:GetPhysicsObject()
		 if IsValid(phys) then
			phys:EnableCollisions(true)
		 end*/
	  end


   -- seems the spos and sdest are purely for effects/forces?
   target:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)

   -- target appears to die right there, so we could theoretically get to
   -- the ragdoll in here...

   self:Remove()      
end


function SWEP:Equip()
   self.Weapon:SetNextPrimaryFire( CurTime() + (self.Primary.Delay * 1.5) )
   self.Weapon:SetNextSecondaryFire( CurTime() + (self.Secondary.Delay * 1.5) )
end

function SWEP:PreDrop()
   -- for consistency, dropped knife should not have DNA/prints
   self.fingerprints = {}
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end

if CLIENT then
   function SWEP:DrawHUD()
      local tr = self.Owner:GetEyeTrace(MASK_SHOT)
		local x = ScrW() / 2.0
		local y = ScrH() / 2.0
		  if tr.HitNonWorld and IsValid(tr.Entity) and tr.Entity:IsPlayer()  then

			 

			 surface.SetDrawColor(255, 0, 0, 255)

			 local outer = 20
			 local inner = 10
			 surface.DrawLine(x - outer, y - outer, x - inner, y - inner)
			 surface.DrawLine(x + outer, y + outer, x + inner, y + inner)

			 surface.DrawLine(x - outer, y + outer, x - inner, y + inner)
			 surface.DrawLine(x + outer, y - outer, x + inner, y - inner)

			 draw.SimpleText("INSTANT PENETRATION", "TabLarge", x, y - 30, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		  end 
		
		local bCanCharge = self.Owner:GetNetworkedBool("pl_cancharge");
		local iCharge = self.Owner:GetNetworkedFloat("pl_charge");
		local bCharging = self.Owner:GetNetworkedBool("pl_charging");
		
		local iOffsetX = 0;
		local iOffsetY = -75;
		local iHeightX = 160;
		local iHeightY = 10
		
		surface.SetDrawColor( 0, 0, 0, 60) 
		surface.DrawRect((x+iOffsetX)-(iHeightX/2),(y+iOffsetY)-(iHeightY/2),iHeightX,iHeightY)
		
		
		if (bCharging) then 
			surface.SetDrawColor( 0, 255, 0, 120) 
			surface.DrawRect((x+iOffsetX)-(iHeightX/2),(y+iOffsetY)-(iHeightY/2),(iHeightX*(iCharge/100)),iHeightY)
			
			draw.SimpleText("Charging!", "TabLarge", x, y - 60, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		elseif (bCanCharge) then
		
			surface.SetDrawColor( 0, 255, 0, 120) 
			surface.DrawRect((x+iOffsetX)-(iHeightX/2),(y+iOffsetY)-(iHeightY/2),(iHeightX*(iCharge/100)),iHeightY)
			draw.SimpleText("Ready!", "TabLarge", x, y - 60, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		else
			surface.SetDrawColor( 255, 0, 0, 120)
			surface.DrawRect((x+iOffsetX)-(iHeightX/2),(y+iOffsetY)-(iHeightY/2),(iHeightX*(iCharge/100)),iHeightY)
			draw.SimpleText("Recharging...", "TabLarge", x, y - 60, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end
		
      return self.BaseClass.DrawHUD(self)
   end
end

//SWEP.d = CurTime();

function SWEP:Think()
	if SERVER then
		if (self.Owner.charging && self.iDelay < CurTime()) then
			self:PrimaryAttack() 
		end
	else
		if (self.Owner:GetNetworkedBool("pl_charging") && self.iDelay < CurTime()) then
			self:PrimaryAttack() 
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
      self:AddHUDHelp("drilldo_help_pri", "drilldo_help_sec", true)

      return self.BaseClass.Initialize(self)
   end
end