--[[
  The following legacy code is created by blocco.
	
	This code was made to be run by "server.lua".
	It was an attempt at server-sided commands with permission levels.
	There is even a zone to add your own commands.
	
	It contains many comments for documentation purposes.
	It is to be used for educational purposes.
	
	This code is from RBXPri (Blocco Edition).
	This file is "commands.lua".
--]]

--[<>[ DOCUMENTATION ]<>]--
--[==[
	Global ServerUtilities.Commands Class
		SetPermissionZone => string name, int level => Creates a permission zone for certain users;
		GetPermissionZone => string name => returns the level of the permission zone (by name) or 0 if not defined;
		SetPlayerLevel => Instance Player, string name => Sets the permission level of the player by zone name;
		GetPlayerLevel => Instance Player => Gets the permission level of the player;
		SetPlayerLevelRaw => Instance Player, int level => Sets the permission level of the player;
		RunCommand => Instance Player, string command, table argumentTable => Runs a command for a certain player if player's permission level supports it
		RunCommandRaw => Instance Player, string command, table argumentTable => Runs a command for a certain player regardless of permission level
		AddCommand => string command, int level, function commandFunction => Creates a command
		RemoveCommand => string command => Removes a command
]==]--

local commandFormat = "/(%w+)%s*()";
local paramFormat = "%-([^%-]+)%s*";

local commandLookup = {}
local userLevels = {};

function GetPlayerFromName(name)
	local plyr;
	for i, v in pairs(game.Players:GetPlayers()) do
		if v.Name:sub(1, #name):lower() == name:lower() then
			if plyr ~= nil then return nil end;
			plyr = v;
		end
	end
	return plyr;
end

-- void
function SetUserLevel(plyr, lvl)
	assert(pcall(function() return plyr:GetDebugId() end))
	assert(type(lvl) == "number", "The level of the player must be a number.")
	userLevels[plyr:GetDebugId()] = lvl;
end
-- int
function GetUserLevel(plyr)
	for i, v in pairs(userLevels) do
		if i == plyr:GetDebugId() then return v end
	end
	return 0;
end
-- void
function ResetUserLevel(plyr)
	for i, v in pairs(userLevels) do
		if i == plyr:GetDebugId() then userLevels[i] = nil end
	end
end

-- void
function AddCommand(cmd, userLevel, fn)
	commandLookup[cmd:lower()] = {lvl = userLevel, fn = fn};
end
-- void
function RemoveCommand(cmd)
	commandLookup[cmd:lower()] = nil;
end

function parseChat(text)
	local com, argStart = text:match(commandFormat);
	if not com or not argStart then return end;
	local argTable = {};
	for arg in text:sub(argStart):gmatch(paramFormat) do
		argTable[#argTable+1] = arg;
	end
	return com, argTable;
end

game.Players.PlayerAddedEarly:connect(function(plyr)
	SetUserLevel(plyr, 0)
	plyr.Chatted:connect(function(chatMsg)
		local cmd, argTable = parseChat(chatMsg);
		if cmd and type(cmd) == "string" and commandLookup[cmd:lower()] then
			if GetUserLevel(plyr) >= commandLookup[cmd:lower()].lvl then
				argTable.player = plyr;
				Spawn(function()commandLookup[cmd:lower()].fn(argTable)end);
			end
		end
	end)
end)
game.Players.PlayerRemovingLate:connect(function(plyr)
	ResetUserLevel(plyr)
end)

local permissionZones={Normal = 0}

function setPermissionZone(name, lvl)
	permissionZones[name] = lvl;
end
function getPermissionZone(name)
	return permissionZones[name] or 0;
end

-- command addition zone start --
	AddCommand("reset", 0,
		function(argTable)
			local plyr = argTable.player;
			if plyr.Character then
				plyr.Character.Parent = nil;
				wait(1);
				if plyr.Parent then plyr:LoadCharacter(); end
			end
		end
	)
	AddCommand("resetMulti", 0,
		function(argTable)
			for i, v in ipairs(argTable) do
				local plyr = GetPlayerFromName(v)
				if plyr and plyr.Character then
					Spawn(function()
						plyr.Character.Parent = nil;
						wait(1);
						if plyr.Parent then plyr:LoadCharacter(); end
					end)
				end
			end
		end
	)
--  command addition zone end  --

_G.ServerUtilities.Commands={};
_G.ServerUtilities.Commands.AddCommand = AddCommand;
_G.ServerUtilities.Commands.RemoveCommand = RemoveCommand;
_G.ServerUtilities.Commands.SetPermissionZone = setPermissionZone;
_G.ServerUtilities.Commands.GetPermissionZone = getPermissionZone;
_G.ServerUtilities.Commands.SetPlayerLevelRaw = SetUserLevel;
function _G.ServerUtilities.Commands.SetPlayerLevel(plyr, zoneName)
	SetUserLevel(plyr, getPermissionZone(zoneName))
end
function _G.ServerUtilities.Commands.GetPlayerLevel(plyr, zoneName)
	return GetUserLevel(plyr)
end
function _G.ServerUtilities.Commands.RunCommand(plyr, cmd, argTable)
	if cmd and type(cmd) == "string" and commandLookup[cmd:lower()] then
		if GetUserLevel(plyr) >= commandLookup[cmd:lower()].lvl then
			argTable.player = plyr;
			Spawn(function()commandLookup[cmd:lower()].fn(argTable)end);
		end
	end
end
function _G.ServerUtilities.Commands.RunCommandRaw(plyr, cmd, argTable)
	if cmd and type(cmd) == "string" and commandLookup[cmd:lower()] then
		argTable.player = plyr;
		Spawn(function()commandLookup[cmd:lower()].fn(argTable)end);
	end
end
