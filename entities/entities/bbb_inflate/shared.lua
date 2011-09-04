if SERVER then
   AddCSLuaFile("shared.lua")
end

ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Think()
	if (SERVER) then 
		if (!self.target || self.hasFoundTarget) then return end
		local target = ents.FindByName(self.target)	
		for k,v in ipairs(target) do 
			self.Entity:SetNWEntity("target",v)
			self.hasFoundTarget = true
		end
	else
		if self.Sized != true then
			self:DoScale()
		end
	end
end

function ENT:KeyValue(key, value)
	if key == "modelscale" then
		self.Entity:SetNWFloat(key,value)
	elseif key == "target" then
		self.target = value
	end
end


function ENT:DoScale()
	local curTarg = self.Entity:GetNWEntity("target",false)
	local curScale = self.Entity:GetNWFloat("modelscale",false)
	if (!curTarg || !curScale) then return end
	self.Sized = true
	Msg("sizing "..curTarg:GetClass().."\n")
	curTarg:SetModelScale(Vector(curScale,curScale,curScale))
end

function ENT:Draw()
	return false
end