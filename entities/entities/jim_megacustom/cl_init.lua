include('shared.lua')

ENT.CurScale = 1;
ENT.CurModel = ""

function ENT:Draw()	
	
	local destScale = self:GetNetScale();
	self.CurScale = destScale
	local curScale = self.CurScale;
	
	self.Entity:SetModelScale( Vector(curScale,curScale,curScale) )	
	local sizeMin = self:GetBaseMin()
	local sizeMax = self:GetBaseMax()
	if (sizeMin && sizeMax) then self.Entity:SetRenderBounds(sizeMin,sizeMax) end
	
	
	if (self:GetNWEntity("spec_owner") == LocalPlayer()) then 
		self:SetColor(255, 255, 255, 120)
	else
		self:SetColor(255, 255, 255, 255)
	end
	
	self.Entity:DrawModel()
	
	if (IsTTTAdmin(LocalPlayer()) && self.Entity:GetNWEntity("spec_owner") == NULL) then
		render.SetMaterial( Material("jim/melon") )
		render.DrawSprite( self.Entity:GetPos(), 32, 32, white)
	end
	
	
end

function ENT:Think()
end

function ENT:DrawEntityOutline()
end