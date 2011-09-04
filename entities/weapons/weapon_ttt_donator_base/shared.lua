if SERVER then
   AddCSLuaFile( "shared.lua" )
end
      
if CLIENT then
   SWEP.PrintName = "Grappling Hook"
   SWEP.Slot = 5

   SWEP.Icon = ""
end

SWEP.Kind = WEAPON_DONATOR
SWEP.AllowDrop = false
SWEP.DropOnDeath = false

SWEP.Base = "weapon_tttbase"

SWEP.Primary.Recoil	= 0.9
SWEP.Primary.Damage = 10
SWEP.Primary.Delay = 0.10
SWEP.Primary.Cone = 0.03
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 20
SWEP.Primary.ClipMax = 60
SWEP.Primary.Ammo = "Pistol"

SWEP.AutoSpawnable = false
SWEP.AmmoEnt = ""

SWEP.ViewModel  = "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.Primary.Sound = Sound( "Weapon_Glock.Single" )
SWEP.IronSightsPos = Vector( 4.33, -4.0, 2.9 )

SWEP.HeadshotMultiplier = 1.75
