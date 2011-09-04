ENT.Type = "anim"
ENT.ResizableProp = true

function ENT:GetNetScale()
	return self.Entity:GetNetworkedFloat( "scale" )
end

function ENT:GetResized()
	return self.Entity:GetNetworkedBool( "resized" )
end

function ENT:SetResized(set)
	self.Entity:SetNetworkedBool("resized", set)
end

function ENT:SetNetScale( scale )
	self:SetResized(true)
	self.Entity:SetNetworkedFloat( "scale", scale )
end

function ENT:ModScale( mod )
	local curScale = self:GetNetScale();
	if (curScale < 1) then mod = mod/4 else mod = mod*2 end
	curScale = curScale+mod
	curScale = math.Clamp(curScale,0.01,100)
	self:SetNetScale(curScale);
end
