AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "Rocket"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Done = false
ENT.Effect = false
ENT.DieTime = false

function ENT:Draw()
	return false
end

function ENT:Initialize()
    if(CLIENT) then return end  
end

function ENT:Think()
	if SERVER then
		if (self.DieTime &&  CurTime() > self.DieTime) then
			self:Remove()
		else
			if (self:GetNWInt("effect",false) != false && !self.DieTime) then
				self.DieTime = CurTime()+1
			end
		end
	elseif (!self.Done) then
		local effect = self:GetNWString("effect",false)
		if (effect == "1") then
			local smokeparticles = {
				  Model("jim/meat")
			   };
			local center = self.Entity:GetPos()
			local em = ParticleEmitter(center)
			  for i=1, 150 do
				 local p = em:Add(table.Random(smokeparticles), center )
				 if p then
					local gray = math.random(75, 200)
					p:SetColor(gray, gray, gray)
					p:SetStartAlpha(255)
					p:SetEndAlpha(255)
					p:SetVelocity(VectorRand() * math.Rand(250, 1500))
					p:SetLifeTime(0)
					
					p:SetDieTime(math.Rand(15, 25))

					p:SetStartSize(math.random(30, 50))
					p:SetEndSize(math.random(30, 40))
					p:SetRoll(math.random(-180, 180))
					p:SetRollDelta(math.Rand(-2, 2))
					p:SetAirResistance(0)

					p:SetCollide(true)
					p:SetBounce(1.5)

					p:SetLighting(false)
				 end
			  end

			  em:Finish()
			  
			self.Done = true
		end
	end
end