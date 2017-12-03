// 1 - Batman skin
// 2 - SekCobra Skin
// 3 - Neo Combine
// 4 - Dipsy
// 5 - creeper
// 6 - stormtrooper
// 7 - barney
// 8 - warhammer
// 9 - Suigintou -- now suited
// 10 - asw model
// 11 - fallout
// 12 - boba fett
// 13 - michael jordan
// 14 - fleshpound
// 15 - gingerbread man
// 16 - osama
// 17 - krystal
// 18 - konata
// 19 - 2142
// 20 - barney_postal
// 21 - zelda
// 22 - zombie
// 23 - solomon
// 24 - gaarus
// 25 - potter
// 26 - bison
// 27 - skeleton NOW spiderman
// 28 - hitler
// 29 - libertyprime
// 30 - chrome robocop
// 32 - billy mays
// 34 - box man now superman
// 35 - postaldude
// 36 - soviet gasmask
// 37 - doomguy
// 38 - joker
// 39 - CJ
// 40 - fat black guy


aDonators = {}
aDonators["STEAM_0:0:10662109"] = 1; // Waals Vander
//aDonators["STEAM_0:0:16780833"] = 2; // SekCobra
aDonators["STEAM_0:1:25827979"] = 3; // NOD
aDonators["STEAM_0:0:15241399"] = 4; // Squarebob/Crash
aDonators["STEAM_0:0:5123217"] = 5; // budspoonce
aDonators["STEAM_0:0:11154803"] = 6; // starpluck
aDonators["STEAM_0:1:13294521"] = 7; // icemaz
aDonators["STEAM_0:1:6991976"] = 8; // foxisus
aDonators["STEAM_0:0:24561765"] = 9; //inacio
aDonators["STEAM_0:1:15945265"] = 10; // elizer
aDonators["STEAM_0:0:25611961"] = 11; // rampageturke
aDonators["STEAM_0:1:433923"] = 12; // strider
aDonators["STEAM_0:1:6052828"] = 13; // absinthe
aDonators["STEAM_0:1:13386915"] = 14; // dr derek
aDonators["STEAM_0:1:20014869"] = 15; // sottalytober
aDonators["STEAM_0:0:1181318"] = 16; // rilez
aDonators["STEAM_0:0:12629346"] = 17; // batmoutarde
aDonators["STEAM_0:1:10822487"] = 18; // dickheadhipster
aDonators["STEAM_0:1:16889825"] = 19; // wplayer
aDonators["STEAM_0:0:3627546"] = 20; // postal
aDonators["STEAM_0:0:18823770"] = 21; // alienfanatic
aDonators["STEAM_0:1:14647903"] = 22; // Jones	
aDonators["STEAM_0:1:10499372"] = 23; // Jaanus
aDonators["STEAM_0:1:5329312"] = 24; // t2lgoose
aDonators["STEAM_0:1:25065249"] = 25; // theforeigner
aDonators["STEAM_0:1:19291688"] = 27; // natrox
aDonators["STEAM_0:0:13767019"] = 28; // jim
aDonators["STEAM_0:1:5902503"] = 29; // redback3
aDonators["STEAM_0:0:13366632"] = 30; // davidofmk
aDonators["STEAM_0:0:6938520"] = 31; // onion
aDonators["STEAM_0:1:15450577"] = 32; // LasPlagas
aDonators["STEAM_0:1:13446132"] = 33; // conro
aDonators["STEAM_0:0:5400054"] = 34; // vent
aDonators["STEAM_0:0:4701298"] = 35; // chuz
aDonators["STEAM_0:1:9769230"] = 36; // mercz
aDonators["STEAM_0:1:3880"] = 37; // nomadic
aDonators["STEAM_0:1:6699149"] = 38; // stepthroat
aDonators["STEAM_0:1:16612480"] = 39; // smurfy
aDonators["STEAM_0:0:16054975"] = 40; // ollih

function donationGetCustomModel(ply,mdl)
	if (ply.Donation == 1) then 
		ply:ChatPrint("Using special playermodel: Batman")
		return "models/Batman/slow/jamis/mkvsdcu/batman/slow_pub_v2.mdl" 
	elseif (ply.Donation == 2) then 
		ply:ChatPrint("Using special playermodel: sekcobra")
		return "models/sekcobra/sekcobra.mdl"
	elseif (ply.Donation == 3) then 
		ply:ChatPrint("Using special playermodel: Neo Combine")
		return "models/player/neo_heavy.mdl"
	elseif (ply.Donation == 4) then 
		ply:ChatPrint("Using special playermodel: Dipsy")
		return "models/player/dipsy_hl2mp_player/dipsy_hl2mp_player.mdl"
	elseif (ply.Donation == 5) then 
		ply:ChatPrint("Using special playermodel: Creeper")
		return "models/jessev92/player/misc/creepr.mdl"
	elseif (ply.Donation == 6) then 
		ply:ChatPrint("Using special playermodel: Stormtrooper")
		return "models/player/b4p/b4p_stormt.mdl"
	elseif (ply.Donation == 7) then 
		ply:ChatPrint("Using special playermodel: Barney")
		return "models/player/hl1/barney.mdl"
	elseif (ply.Donation == 8) then 
		ply:ChatPrint("Using special playermodel: Space Marine")
		return "models/player/spacemarine_veteran.mdl"
	elseif (ply.Donation == 9) then 
		//ply:ChatPrint("Using special playermodel: suigintou")
		//return "models/player/suigintou.mdl"
		ply:ChatPrint("Using special playermodel: Suited Citizen")
		return "models/player/suits/male_07.mdl"
	elseif (ply.Donation == 10) then 
		ply:ChatPrint("Using special playermodel: ASW Officer")
		return "models/player/samzanemesis/marineofficer.mdl"
	elseif (ply.Donation == 11) then 
		ply:ChatPrint("Using special playermodel: Fallout")
		return "models/player/fallout_3/tesla_power_armor.mdl" // - Replaced
	elseif (ply.Donation == 12) then 
		ply:ChatPrint("Using special playermodel: Boba Fett")
		return "models/bobafett_tfu.mdl"
	elseif (ply.Donation == 13) then 
		ply:ChatPrint("Using special playermodel: Michael Jordan")
		ply:ChatPrint("Enabling Michael Jordan Super Jump")
		ply:SetJumpPower( 500 )
		return "models/nba2k11/players/jordan/jordan.mdl"
	elseif (ply.Donation == 14) then 
		ply:ChatPrint("Using special playermodel: Fleshpound")
		return "models/player/slow/fleshpound/slow.mdl"
	elseif (ply.Donation == 15) then 
		ply:ChatPrint("Using special playermodel: gingerbread man")
		return "models/gingerbread/gingerbread.mdl"
	elseif (ply.Donation == 16) then 
		ply:ChatPrint("Using special playermodel: osama")
		return "models/jessev92/player/misc/osamabl1.mdl"
	elseif (ply.Donation == 17) then 
		ply:ChatPrint("Using special playermodel: Krystal")
		return "models/krystal/vixen.mdl"
	elseif (ply.Donation == 18) then 
		ply:ChatPrint("Using special playermodel: Konata")
		return "models/player/konatap.mdl"
	elseif (ply.Donation == 19) then 
		ply:ChatPrint("Using special playermodel: 2142")
		return "models/europee_orange1.mdl"
	elseif (ply.Donation == 20) then 
		ply:ChatPrint("Using special playermodel: kevin is gay")
		return "models/player/posta2/barney_postal.mdl"
	elseif (ply.Donation == 21) then 
		ply:ChatPrint("Using special playermodel: zelda")
		return "models/player/zelda.mdl"
	elseif (ply.Donation == 22) then 
		ply:ChatPrint("Using special playermodel: zombie")
		return "models/player/hl1/zombie.mdl"
	elseif (ply.Donation == 23) then 
		ply:ChatPrint("Using special playermodel: Solomon")
		return "models/player/jaanus/tftg_solomon.mdl"
	elseif (ply.Donation == 24) then 
		ply:ChatPrint("Using special playermodel: Garrus")
		return "models/slash/garrus/garrus.mdl"
	elseif (ply.Donation == 25) then 
		ply:ChatPrint("Using special playermodel: HarryPotter")
		return "models/harry/harry_potter.mdl"
	elseif (ply.Donation == 26) then 
		//ply:ChatPrint("Using special playermodel: Bison")
		//return "models/m.dyson.mdl"
	elseif (ply.Donation == 27) then 
		//ply:ChatPrint("Using special playermodel: Skeleton")
		//return "models/skeleton.mdl"
		//ply:ChatPrint("Using special playermodel: NSA")
		//return "models/player/nsa_agent.mdl"
		ply:ChatPrint("Using special playermodel: Spiderman")
		return "models/Spiderman/spiderman.mdl"
	elseif (ply.Donation == 28) then 
		ply:ChatPrint("Using special playermodel: Hitler")
		return "models/player/hitler.mdl"
	elseif (ply.Donation == 29) then 
		ply:ChatPrint("Using special playermodel: Liberty Prime")
		return "models/player/sam.mdl"
	elseif (ply.Donation == 30) then 
		ply:ChatPrint("Using special playermodel: Chrome robocop")
		return "models/player/robocop_chrome/slow.mdl"
	elseif (ply.Donation == 31) then 
		ply:ChatPrint("Using special playermodel: renamon")
		return "models/player/renamon.mdl"
	elseif (ply.Donation == 32) then 
		ply:ChatPrint("Using special playermodel: billy mays")
		return "models/player/billymays.mdl"
	elseif (ply.Donation == 33) then 
		//ply:ChatPrint("Using special playermodel: robo")
		//return "models/player/mp/robo/robo.mdl"
		ply:ChatPrint("Using special playermodel: legion")
		return "models/slash/legion/legion.mdl"
	elseif (ply.Donation == 34) then 
		ply:ChatPrint("Using special playermodel: Superman")
		return "models/Bizyer/slow/jamis/mkvsdcu/superman/slow_pub.mdl"
	elseif (ply.Donation == 35) then 
		ply:ChatPrint("Using special playermodel: dude_player")
		return "models/dude_player.mdl"
	elseif (ply.Donation == 36) then 
		//ply:ChatPrint("Using special playermodel: sovietquarantine")
		//return "models/player/sovietquarantine.mdl"
		ply:ChatPrint("Using special playermodel: Subzero")
		return "models/player/slow/amberlyn/mkvsdcu/subzero/slow.mdl"
	elseif (ply.Donation == 37) then 
		ply:ChatPrint("Using special playermodel: doomguy")
		return "models/player/doomguy.mdl"
	elseif (ply.Donation == 38) then 
		return "models/player/slow/jamis/mkvsdcu/joker/slow_pub.mdl"
	elseif (ply.Donation == 39) then 
		ply:ChatPrint("Using special playermodel: cj")
		return "models/francis115/carljohnson/carljohnson.mdl"
	elseif (ply.Donation == 40) then 
		ply:ChatPrint("Using special playermodel: Fat black guy")
		return "models/player/slow/amberlyn/re5/fat_majini/slow.mdl"
	end
	
	return mdl
end

function bIsDonator(ply)
	if (!IsValid(ply)) then return false end

	local bReturn = false
	local sSteamID = ply:SteamID()
	if (sSteamID) then
		for k, v in pairs(aDonators) do
			if (k == sSteamID) then 
				bReturn = v
			end
		end
	end
	
	return bReturn
end

function donateSpawn( ply )
	local iDonateLevel = bIsDonator(ply);
	
	if (iDonateLevel) then 
		local sPlyNick = ply:Nick();
	
		if (!ply.Donation && ply:SteamID() != "STEAM_0:0:13767019") then
			PrintMessage( HUD_PRINTCENTER, Format("Many thanks to %s for donating!",sPlyNick) )
			PrintMessage( HUD_PRINTTALK, Format("Many thanks to %s for donating!",sPlyNick) )
		end
		
		ply.Donation = iDonateLevel
	end
end
 
hook.Add( "PlayerSpawn", "donateSpawn", donateSpawn )

//SekCobra Visor
local state = 1;
function PlayerSetSEKCobraVisor( ply )
	if state > 0 then
		state = 0;
		ply:ChatPrint("Visor closed\n");
		ply:SetBodygroup ( 1, state);
		return true -- :D
	end
	if state <= 0 then
		state = 1;
		ply:ChatPrint("Visor opened\n");
		ply:SetBodygroup ( 1, state);
		return true -- :D
	end
end
concommand.Add("cobra_visor", PlayerSetSEKCobraVisor)


//Models
//Ironman

AddDir("models/Batman")
AddDir("materials/models/Batman")

//SekCobra
AddDir("materials/models/sekcobra")
AddDir("models/sekcobra")

//Neo Combine player
AddDir("materials/models/characters/neoheavy")
AddFile("models/player/neo_heavy.dx80.vtx")
AddFile("models/player/neo_heavy.dx90.vtx")
AddFile("models/player/neo_heavy.xbox.vtx")
AddFile("models/player/neo_heavy.mdl")
AddFile("models/player/neo_heavy.phy")
AddFile("models/player/neo_heavy.sw.vtx")
AddFile("models/player/neo_heavy.vvd")

//Dipsy
AddDir("materials/models/player/dipsy_hl2mp")
AddDir("models/player/dipsy_hl2mp_player")

//creeper
AddDir("materials/jessev92")
AddDir("models/jessev92")

//stormtrooper
AddDir("materials/models/player/b4p")
AddDir("models/player/b4p")

//barny
AddDir("materials/models/barney")
AddDir("materials/detail")
AddDir("models/player/hl1")

//spacemarine
AddDir("materials/models/spacemarine")
AddFile("models/player/spacemarine_veteran.dx80.vtx")
AddFile("models/player/spacemarine_veteran.dx90.vtx")
AddFile("models/player/spacemarine_veteran.xbox.vtx")
AddFile("models/player/spacemarine_veteran.mdl")
AddFile("models/player/spacemarine_veteran.phy")
AddFile("models/player/spacemarine_veteran.sw.vtx")
AddFile("models/player/spacemarine_veteran.vvd")

//suigintou
/*AddDir("materials/models/player/suigintou")
AddFile("models/player/suigintou.dx80.vtx")
AddFile("models/player/suigintou.dx90.vtx")
AddFile("models/player/suigintou.xbox.vtx")
AddFile("models/player/suigintou.mdl")
AddFile("models/player/suigintou.phy")
AddFile("models/player/suigintou.sw.vtx")
AddFile("models/player/suigintou.vvd")*/
AddDir("materials/models/humans/jackntie")
AddDir("models/player/suits")

//asw
AddDir("materials/models/player/male")
AddDir("models/player/samzanemesis")

//fallout
//AddDir("materials/models/player/dmgn")
//AddDir("models/player/dmgn")
AddDir("models/player/fallout_3")
AddDir("materials/models/player/slow/fallout_3")

//boba fett
AddDir("materials/models/ryan7259")
AddFile("models/bobafett_tfu.dx80.vtx")
AddFile("models/bobafett_tfu.dx90.vtx")
AddFile("models/bobafett_tfu.xbox.vtx")
AddFile("models/bobafett_tfu.mdl")
AddFile("models/bobafett_tfu.phy")
AddFile("models/bobafett_tfu.sw.vtx")
AddFile("models/bobafett_tfu.vvd")

//michael jordan
AddDir("materials/nba2k11")
AddDir("models/nba2k11")

///fleshpound
AddFile("materials/effects/black.vtf")
AddFile("models/m_all.mdl")
AddDir("models/player/slow/fleshpound")
AddDir("materials/models/player/slow/fleshpound")

///gbread
AddDir("materials/models/gingerbread")
AddDir("models/gingerbread")

//osama
AddDir("materials/jessev92")
AddDir("models/jessev92")

//krystal
AddDir("models/krystal")
AddDir("materials/models/krystal")

//konata
AddDir("materials/konata")
AddFile("models/player/konatap.dx80.vtx")
AddFile("models/player/konatap.dx90.vtx")
AddFile("models/player/konatap.mdl")
AddFile("models/player/konatap.phy")
AddFile("models/player/konatap.sw.vtx")
AddFile("models/player/konatap.vvd")

//2142
AddDir("materials/models/europee_orange1")
AddFile("models/Europee_orange1.dx80.vtx")
AddFile("models/Europee_orange1.dx90.vtx")
AddFile("models/Europee_orange1.mdl")
AddFile("models/Europee_orange1.phy")
AddFile("models/Europee_orange1.sw.vtx")
AddFile("models/Europee_orange1.vvd")

//barney
AddDir("models/player/posta2")
AddDir("materials/models/player/posta2")

//zelda
AddDir("materials/models/zelda")
AddFile("models/player/zelda.dx80.vtx")
AddFile("models/player/zelda.dx90.vtx")
AddFile("models/player/zelda.mdl")
AddFile("models/player/zelda.phy")
AddFile("models/player/zelda.sw.vtx")
AddFile("models/player/zelda.vvd")

//zombie
AddDir("models/player/hl1")
AddDir("materials/models/zombie")

//solomon
AddDir("models/player/jaanus")
AddDir("materials/models/player/jaanus")
//garrus
AddDir("materials/models/slash")
AddDir("models/slash")
//harry
AddDir("materials/models/harry")
AddDir("models/harry")
//nsa
/*AddDir("materials/models/player/nsa")
AddFile("models/player/nsa_agent.dx80.vtx")
AddFile("models/player/nsa_agent.dx90.vtx")
AddFile("models/player/nsa_agent.xbox.vtx")
AddFile("models/player/nsa_agent.mdl")
AddFile("models/player/nsa_agent.phy")
AddFile("models/player/nsa_agent.sw.vtx")
AddFile("models/player/nsa_agent.vvd")*/
//hitler
AddDir("materials/models/humans/Hitlerman")
AddDir("materials/models/humans/male/Hitlerman")
AddFile("models/player/hitler.dx80.vtx")
AddFile("models/player/hitler.dx90.vtx")
AddFile("models/player/hitler.mdl")
AddFile("models/player/hitler.phy")
AddFile("models/player/hitler.sw.vtx")
AddFile("models/player/hitler.vvd")
AddFile("models/player/hitler.xbox.vtx")
//libertyprime

AddFile("materials/models/player/libertyprimebody_d.vmt")
AddFile("materials/models/player/libertyprimebody_d.vtf")
AddFile("materials/models/player/libertyprimebody_n.vtf")
AddFile("materials/models/player/libertyprimeleg_d.vmt")
AddFile("materials/models/player/libertyprimeleg_d.vtf")
AddFile("materials/models/player/libertyprimeleg_n.vtf")

AddFile("models/player/sam.dx80.vtx")
AddFile("models/player/sam.dx90.vtx")
AddFile("models/player/sam.xbox.vtx")
AddFile("models/player/sam.mdl")
AddFile("models/player/sam.phy")
AddFile("models/player/sam.sw.vtx")
AddFile("models/player/sam.vvd")

//chrome robocop
AddDir("models/player/robocop")
AddDir("models/player/robocop_chrome")
AddDir("materials/models/player/slow/robocop_chrome")

//renamon
AddModel("models/player/renamon")
AddDir("materials/models/renamon2009")

//billymays
AddModel("models/player/billymays")
AddDir("materials/models/player/billy")
AddDir("materials/models/billymays")

//robo
//AddDir("models/player/mp/robo")
//AddDir("materials/models/player/mp/robo")

//box
/*AddModel("models/player/danboard")
AddFile("models/player/danboard_arm_leg_sheet.vmt")
AddFile("models/player/danboard_arm_leg_sheet.vtf")
AddFile("models/player/danboard_body_sheet.vmt")
AddFile("models/player/danboard_body_sheet.vtf")
AddFile("models/player/danboard_head_sheet.vmt")
AddFile("models/player/danboard_head_sheet.vtf")*/

//spiderman
AddDir("materials/spiderman")
AddDir("models/Spiderman")

//leigon
AddDir("materials/models/slash/legion")
AddDir("models/slash/legion")


//super
AddDir("materials/models/Bizyer/slow/jamis/mkvsdcu/superman")
AddDir("models/Bizyer/slow/jamis/mkvsdcu/superman")

//postal
AddModel("models/dude_player")
AddDir("materials/models/dude")

//gasmask
//AddModel("models/player/sovietquarantine")
//AddDir("materials/models/comask")

//doomguy
AddModel("models/player/doomguy")
AddDir("materials/models/doomguy")

//joker
AddDir("models/player/slow/jamis/mkvsdcu/joker")
AddDir("materials/models/player/slow/jamis/mkvsdcu/joker")
//cj
AddDir("models/francis115/carljohnson")
AddDir("materials/models/francis115/cj")

//Subzero
AddDir("models/player/slow/amberlyn/mkvsdcu/subzero")
AddDir("materials/models/player/slow/amberlyn/mkvsdcu/subzero")

//fat black guy
AddDir("models/player/slow/amberlyn/re5/fat_majini")
AddDir("materials/models/player/slow/amberlyn/re5/fat_majini")

