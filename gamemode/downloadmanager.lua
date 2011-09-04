if CLIENT then return end

function AddDir(dir) // recursively adds everything in a directory to be downloaded by client
        local list = file.FindDir("../"..dir.."/*")
        for _, fdir in pairs(list) do
                if fdir != ".svn" then // don't spam people with useless .svn folders
                        AddDir(dir.."/"..fdir)
                end
        end

        for k,v in pairs(file.Find("../"..dir.."/*")) do
                AddFile(dir.."/"..v)
        end
end

function AddFile(filein)
	if (!file.Exists(filein, true)) then
		Msg("==== FILE 404 "..filein.."\n")
		return
	end

	if (string.find(filein,"bz2") || string.find(filein,".git")) then 
		//Msg(" - SKIPPING "..file.."\n")
		return
	end
	
	resource.AddFile(filein)
	//Msg("====== Adding "..filein.."\n")
end	

function AddModel(file)
	Msg("====== Adding Model "..file.."\n")
	AddFile(file..".dx80.vtx")
	AddFile(file..".dx90.vtx")
	AddFile(file..".xbox.vtx")
	AddFile(file..".sw.vtx")
	AddFile(file..".mdl")
	AddFile(file..".vvd")
	AddFile(file..".phy")
end		

function AddMat(file)
	Msg("====== Adding Material "..file.."\n")
	AddFile(file..".vmt")
	AddFile(file..".vtf")
end	
	
//AddDir("materials/models/gnin")
//AddDir("models/gnin")

//AddDir("sound/cunt")
//AddDir("materials/cunt")
//AddFile("materials/Alters.vmt")
//AddFile("materials/Alters.vtf")

AddFile("materials/VGUI/ttt/score_logo_bbb.vmt")
AddFile("materials/VGUI/ttt/score_logo_bbb.vtf")
AddFile("materials/VGUI/ttt/icon_knife_instakill.vmt")
AddFile("materials/VGUI/ttt/icon_knife_instakill.vtf")
AddFile("materials/VGUI/ttt/icon_drilldo.vtf")
AddFile("materials/VGUI/ttt/icon_drilldo.vmt")

AddDir("materials/jaanus")
AddDir("materials/jim")
AddDir("models/jaanus")
AddDir("sound/cunt")

AddDir("materials/models/mlp")
AddDir("sound/pp")
AddFile("models/pinkiepie.dx80.vtx")
AddFile("models/pinkiepie.dx90.vtx")
AddFile("models/pinkiepie.mdl")
AddFile("models/pinkiepie.phy")
AddFile("models/pinkiepie.sw.vtx")
AddFile("models/pinkiepie.vvd")

AddDir("materials/models/feline")
AddFile("models/feline.dx80.vtx")
AddFile("models/feline.dx90.vtx")
AddFile("models/feline.xbox.vtx")
AddFile("models/feline.mdl")
AddFile("models/feline.phy")
AddFile("models/feline.sw.vtx")
AddFile("models/feline.vvd")

AddDir("materials/mixerman3d")
AddDir("models/mixerman3d")


