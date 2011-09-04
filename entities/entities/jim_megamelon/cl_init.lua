include('shared.lua')

ENT.CurScale = 1;
ENT.CurModel = ""

function ENT:Draw()	
	if (self.CurModel == "") then return end
	
	
	local destScale = self:GetNetScale();
	self.CurScale = destScale
	local curScale = self.CurScale;
	
	self.Entity:SetModelScale( Vector(curScale,curScale,curScale) )	
	local radius = self.BaseSize*self:GetNetScale();
	self.Entity:SetRenderBounds(Vector(-radius,-radius,-radius),Vector(radius,radius,radius))
	
	
	if (self:GetNWEntity("spec_owner") == LocalPlayer()) then 
		self:SetColor(255, 255, 255, 120)
	else
		self:SetColor(255, 255, 255, 255)
	end
	
	self.Entity:DrawModel()
	if (IsTTTAdmin(LocalPlayer()) && self.Entity:GetNWEntity("spec_owner") == NULL) then
		render.SetMaterial( Material("jim/melon") )
		render.DrawSprite( self.Entity:GetPos(), 8, 8, white)
	end
	
	
end

function ENT:Think()
	local curmodel = self:GetNWString("curmodel");
	if (curmodel && self.CurModel != curmodel) then
		self.CurModel = curmodel
		self:SetModel(curmodel)
	end
end

function ENT:DrawEntityOutline()
end