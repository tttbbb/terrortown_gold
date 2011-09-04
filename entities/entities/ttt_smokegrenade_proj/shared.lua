
if SERVER then
   AddCSLuaFile("shared.lua")
end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_smokegrenade_thrown.mdl")


AccessorFunc( ENT, "radius", "Radius", FORCE_NUMBER )

function ENT:Initialize()
   if not self:GetRadius() then self:SetRadius(20) end
   if (SERVER) then 
	self.MeatSound = CreateSound(self, Sound("cunt/spin_l.wav") )
	self.MeatSound:Play()
	self.MeatSound:ChangeVolume(0.3);
   end

   return self.BaseClass.Initialize(self)
end

if CLIENT then

   local smokeparticles = {
      Model("jim/meat")
   };

   function ENT:CreateSmoke(center)
      local em = ParticleEmitter(center)

      local r = self:GetRadius()
      for i=1, 40 do
         local prpos = VectorRand() * r
         prpos.z = prpos.z + 32
         local p = em:Add(table.Random(smokeparticles), center + prpos)
         if p then
            local gray = math.random(75, 200)
            p:SetColor(gray, gray, gray)
            p:SetStartAlpha(255)
            p:SetEndAlpha(0)
            p:SetVelocity(VectorRand() * math.Rand(150, 200))
            p:SetLifeTime(0)
            
            p:SetDieTime(math.Rand(5, 15))

            p:SetStartSize(math.random(40, 75))
            p:SetEndSize(math.random(1, 40))
            p:SetRoll(math.random(-180, 180))
            p:SetRollDelta(math.Rand(-2, 2))
            p:SetAirResistance(0)

            p:SetCollide(true)
            p:SetBounce(1)

            p:SetLighting(false)
         end
      end

      em:Finish()
   end
end

function ENT:Explode(tr)
   if SERVER then
      self:SetNoDraw(true)
      self:SetSolid(SOLID_NONE)

      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      local pos = self:GetPos()
	  
	for k, target in pairs(ents.FindInSphere(pos, 350)) do
		if ValidEntity(target) then
			if target:IsPlayer() && target:Alive() && !target:IsSpec() then
			
				target:SetMaterial("jim/meat");
				
				target:SetNWInt("jim_meatnade_time",CurTime());
				local effect = EffectData()
				  effect:SetStart(target:GetPos())
				  effect:SetOrigin(target:GetPos())
				  util.Effect("cball_explode", effect, true, true)
					util.Effect("Explosion", effect, true, true)
			end
		end
	end
   
	  
		self.MeatSound:Stop()
		self:Remove()
   else
      local spos = self:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

      self:SetDetonateExact(0)

      if tr.Fraction != 1.0 then
         spos = tr.HitPos + tr.HitNormal * 0.6
      end

      -- Smoke particles can't get cleaned up when a round restarts, so prevent
      -- them from existing post-round.
      if GetRoundState() == ROUND_POST then return end

      self:CreateSmoke(spos)
   end
end

