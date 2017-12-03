datastream = {
  hooks = {}
}
function datastream.Hook(hook, func)
  datastream.hooks[hook] = func
end

if SERVER then
  util.AddNetworkString("Nigger.datastream")
  net.Receive("Nigger.datastream", function(len, ply)
    local tbl = net.ReadTable()
    datastream.hooks[tbl.h](ply, nil, nil, nil, tbl.a)
  end)
elseif CLIENT then
  function datastream.StreamToServer(hook, args)
    net.Start("Nigger.datastream")
    net.WriteTable{h = hook, a= args}
    net.SendToServer()
  end
end
