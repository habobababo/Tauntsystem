

util.AddNetworkString( "CoreTauntAct" )
local TeamName

if CoreTaunts.Gamemode == 0 then // 0 Sandbox | 1 Deathrun | 2 TTT
	TeamName = TEAM_CONNECTING
elseif CoreTaunts.Gamemode == 1 then
	TeamName = TEAM_RUNNER
end

if CoreTaunts.Custom then
	if CoreTaunts.Compress then
		for _, snd in pairs(CoreTaunts.Runner) do resource.AddFile("sound/"..snd..".bz2") end
		for _, snd in pairs(CoreTaunts.Death) do resource.AddFile("sound/"..snd..".bz2") end
	else
		for _, snd in pairs(CoreTaunts.Runner) do resource.AddFile("sound/"..snd) end
		for _, snd in pairs(CoreTaunts.Death) do resource.AddFile("sound/"..snd) end
	end
end

local function Tauntfunc( ply )
	local id = ply:SteamID64()
	local pitch = 255	
	
	if CoreTaunts.CanTalk then	
		if table.HasValue(CoreTaunts.AllowedGroupsT, ply:GetNWString("usergroup")) then
			ply:SetNWBool("TauntCanUse", false)
		else
			ply:SetNWBool("TauntCanUse", true)
		end
	end

	if ply:Alive() then
		if ply:GetNWBool("TauntCD") then return end
		if ply:GetNWBool("TauntCanUse") then return end
		timer.Simple(CoreTaunts.Cooldown, function() 
			ply:SetNWBool("TauntCD", false)
		end)
		ply:SetNWBool("TauntCD", true)
		if CoreTaunts.Gamemode != 2 then
			if ply:Team() == TeamName then
				taunt = table.Random(CoreTaunts.Team1)
			else
				taunt = table.Random(CoreTaunts.Team2)
			end
		else
			if ply:GetRole() == 1 then
				taunt = table.Random(CoreTaunts.Team1)
			else
				taunt = table.Random(CoreTaunts.Team2)
			end
		end
		tauntact = table.Random(CoreTaunts.Acts)
		
		net.Start( "CoreTauntAct" )
			net.WriteString(id)
		net.Broadcast()

		if CoreTaunts.Pitch == 0 then
			pitch = math.random(50,255)
		else
			pitch = CoreTaunts.Pitch
		end
		ply:EmitSound(taunt, 100, pitch)
	end
	
end
if CoreTaunts.F2 then
	hook.Add("ShowTeam", "School", Tauntfunc)
end
concommand.Add("taunt", Tauntfunc)



