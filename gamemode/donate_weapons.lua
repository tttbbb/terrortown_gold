//aDonatorWeapon = {}
//aDonatorWeapon["STEAM_0:1:19291688"] = "weapon_ttt_donator_grapple"; // Natrox
//aDonatorWeapon["STEAM_0:0:6938520"] = "weapon_ttt_donator_combinerifle"; // Onion
//aDonatorWeapon["STEAM_0:0:13767019"] = "weapon_ttt_donator_jihad"; // jim
//aDonatorWeapon["STEAM_0:0:1181318"] = "weapon_ttt_donator_jihad"; // rilez

function bIsWeaponDonator(ply)
	if (!IsValid(ply)) then return false end

	local bReturn = false
	local sSteamID = ply:SteamID()
	if (sSteamID) then
		for k, v in pairs(aDonatorWeapon) do
			if (k == sSteamID) then 
				bReturn = v
			end
		end
	end
	
	return bReturn
end

function donateWeaponSpawn( ply )
	local iDonateWep = bIsWeaponDonator(ply);
	
	if (iDonateWep && !ply:IsSpec() && !ply:HasWeapon(iDonateWep)) then 
		ply:ChatPrint("Donator Weapon: Giving "..iDonateWep);
		ply:Give(iDonateWep);
	end
end
 
 
//Files
//Combine Rifle
AddMat("materials/jaanus/ep2_snip_parascope");
AddMat("materials/jaanus/rotatingthing");
AddMat("materials/jaanus/sniper_corner");
AddMat("materials/jaanus/w_sniper");
AddMat("materials/jaanus/w_sniper_new");
AddMat("materials/jaanus/w_sniper_new_n");
AddMat("materials/jaanus/w_sniper_phong");
AddModel("models/weapons/v_combinesniper_e2");
AddModel("models/weapons/w_combinesniper_e2");
AddFile("sound/jaanus/ep2sniper_empty.wav");
AddFile("sound/jaanus/ep2sniper_fire.wav");
AddFile("sound/jaanus/ep2sniper_reload.wav");

//Jihad
//AddModel("models/weapons/v_jb"); --Turns out the world model isn't set up properly, doesn't appear to be in the player hands, so we'll use normal c4 for now.
//AddModel("models/weapons/w_jb");
//AddDir("materials/models/weapons/v_models/pr0d.c4");
//AddDir("materials/models/weapons/w_models/pr0d.c4");
AddFile("sound/siege/big_explosion.wav");
AddFile("sound/siege/jihad.wav");
