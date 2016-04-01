

net.Receive( "CoreTauntAct", function()
	local act = table.Random(CoreTaunts.Acts)
	local id = net.ReadString()
	for k,v in pairs(player.GetAll()) do
		if v:SteamID64() == id then
			v:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, act, true)	
		end
	end
end)