include('shared.lua')

ENT.CurScale = 1;

function ENT:Draw()	
	if (IsTTTAdmin(LocalPlayer()) && self.Entity:GetNWEntity("spec_owner") == NULL) then
		render.SetMaterial( Material("jim/melon") )
		render.DrawSprite( self.Entity:GetPos(), 8, 8, white)
	end
	
	if (self:GetNWEntity("spec_owner") == LocalPlayer()) then 
		self:SetColor(255, 255, 255, 175)
	else
		self:SetColor(255, 255, 255, 255)
	end
	
	self.Entity:DrawModel()
	
	local destScale = self:GetNetScale();
	self.CurScale = destScale
	local curScale = self.CurScale;
	
	self.Entity:SetModelScale( Vector(curScale,curScale,curScale) )	
	self.Entity:SetRenderBounds(Vector(-curScale,-curScale,-curScale),Vector(curScale,curScale,curScale))
end

function ENT:DrawEntityOutline()
end