meatPlaying = false;

iMeatNadePlaying = false;
local iMeatTime = 7.5;
local iMeatFadeTime = 3;
local iStrikeTime = 0
local iCurAlpha1 = 0
function JimHUDPaint()
   local client = LocalPlayer()
   if (client:GetNetworkedInt("thirdperson") == 1) then
		draw.SimpleTextOutlined("Chasecam Enabled", "Trebuchet24", 25, ScrH()/2, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(255,255,255,255))
	end 
   if (client:GetNWBool("jim_barrel",false) == true) then
		draw.SimpleTextOutlined("Disguised as barrel.", "HUDNumber4", ScrW()/2, 55, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5, Color(255,255,255,255))
	end 
	if (client:GetNWBool("jim_alltalk",false) == true) then
		draw.SimpleTextOutlined("ALLTALK ENABLED.", "HUDNumber4", ScrW()/2, 25, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5, Color(255,255,255,255))
	end
	
	if (client:GetNWBool("jim_meatme",false) == true) then
		if (IsTTTAdmin(client)) then
			draw.SimpleTextOutlined("You would be meatspinned, but disabled because you're an admin.", "HUDNumber2", ScrW()/2, 85, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5, Color(255,255,255,255))
		else
			if (!meatPlaying) then
				meatSound = CreateSound(LocalPlayer(), Sound("cunt/spin_l.wav"))
				meatPlaying = true;
				meatSound:Play();
			end
			local QuadTable = {} 
			local iMeats = 200;
			QuadTable.texture 	= surface.GetTextureID("jim/meat")
			QuadTable.color		= Color( 255,255,255, 180 ) 
			
			local width = ScrW()/2.5;
			local height = ScrH()/2.5;
			local i = 0;
			local ioffset = 0;
			while (i < iMeats) do
			ioffset = ioffset + 0.04
			local offsetx = (math.sin((CurTime()+ioffset)*2)*(ScrW()/2));
			local offsety = (math.sin((CurTime()+ioffset))*(ScrH()/2));
		 
			QuadTable.x = ((ScrW()/2)-(width/2))+offsetx
			QuadTable.y = ((ScrH()/2)-(height/2))+offsety
			QuadTable.w = width
			QuadTable.h = height
			draw.TexturedQuad( QuadTable );
			i = i + 1;
			end
		end
	elseif (meatPlaying) then
		meatPlaying = false;
		if (meatSound) then meatSound:Stop(); end
	end
	
	
	local iMeatNadeTime = client:GetNWInt("jim_meatnade_time",false);
	if (iMeatNadeTime && CurTime()-iMeatNadeTime < (iMeatTime+iMeatFadeTime)) then
		if (!iMeatNadePlaying) then
			meatNadeSound = CreateSound(LocalPlayer(), Sound("cunt/spin_l.wav"))
			iMeatNadePlaying = true;
			meatNadeSound:Play();
			datastream.StreamToServer( "MeatHook", { ["mat"] = "jim/meat_lit" } );
		end
		
		local iTime = CurTime()-iMeatNadeTime;
		local QuadTable = {} 
		QuadTable.texture 	= surface.GetTextureID("jim/meat")
		local iFade = 1;
		local iAlpha = 255
		if (CurTime()-iMeatNadeTime > iMeatTime) then
			iFade = (iMeatFadeTime-(iTime-iMeatTime))/iMeatFadeTime;
		end
		QuadTable.color		= Color( 255,255,255, iAlpha*iFade ) 
		
		meatNadeSound:ChangeVolume(iFade);
	 
		QuadTable.x = 0
		QuadTable.y = 0
		QuadTable.w = ScrW()
		QuadTable.h = ScrH()
		
		if (IsTTTAdmin(client)) then
			draw.SimpleTextOutlined("You would be meatspinned, but disabled because you're an admin.", "HUDNumber2", ScrW()/2, 85, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5, Color(255,255,255,255))
		else
		draw.TexturedQuad( QuadTable );
		end
	elseif(iMeatNadePlaying) then
		iMeatNadePlaying = false;
		meatNadeSound:Stop();
		datastream.StreamToServer( "MeatHook", { ["mat"] = "" } );
	end
	
	//MELON INDICATOR
	local specEnt = client:GetNWEntity("spec_ent");
	if (specEnt && specEnt != NULL && IsValid(specEnt) && specEnt.ResizableProp) then
	
		local QuadTable = {} 
		QuadTable.texture 	= surface.GetTextureID("jim/melon")
		QuadTable.color		= Color( 255,255,255, 120 ) 
		QuadTable.x = ScrW()-100
		QuadTable.y = (ScrH()/2)-50
		QuadTable.w = 100
		QuadTable.h = 100
		draw.TexturedQuad( QuadTable );
		
		local scale = specEnt:GetNetScale();
		scale = math.Round(scale*1000)/1000
		draw.SimpleTextOutlined("x"..scale, "ChatFont", ScrW()-50, (ScrH()/2)-50, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(255,255,255,255))
			
	end
	
	if (iStrikeTime > CurTime()) then
		local halfH = ScrH()/2;
		draw.SimpleTextOutlined("STRIKE!", "HUDNumber5", ScrW()/2, halfH-(halfH/2), Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 3, Color(255,255,255,255))
	end
	
end
hook.Add("HUDPaintBackground", "JimHUDPaint", JimHUDPaint);

local function incStrike( data )
 
	strikeSound = CreateSound(LocalPlayer(), Sound("vo/npc/Barney/ba_laugh02.wav"))
	strikeSound:Play()
 iStrikeTime = CurTime()+2
end
usermessage.Hook( "incStrike", incStrike )

