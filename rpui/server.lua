--[[
  The following legacy code is created by blocco.
	
	A little fun fact about this file:
		No one ever used RBXPri Blocco Edition to make a server!
		So I never got to test this!
		I don't even know if it works.
	
	It contains many comments for documentation purposes.
	It is to be used for educational purposes.
	
	This code is from RBXPri (Blocco Edition).
	This file is "server.lua".
--]]

--[<>[ DOCUMENTATION ]<>]--
--[==[
	Global ServerUtilities Class
		Start => int port => starts a server at a port;
		Stop => stops the server;
		Ban => string playerName => Bans player by IP and name;
		Unban => string playerName => Unbans player by IP and name;
		GetIP => string playerName => Gets IP of player by player object;
		SetRespawnTime => number respawnTime => Sets amount of time taken to respawn;
		int ClientsConnected: number of clients connected
]==]--

local Instance=Instance;

local serverStarted=false;
local bannedIPs={} -- index = {true, nameOfPlayer}
_G.ServerUtilities={};

function isBannedIP(rep)
	if rep == nil then return end
	if rep:IsA("NetworkReplicator") and bannedIPs[rep.MachineAddress] and bannedIPs[rep.MachineAddress][1] then
		return true
	end
end
function isBannedPlayer(plyrName)
	for i, v in pairs(bannedIPs) do
		if v[2] == plyrName then
			return true
		end
	end
end

function getIP(plyr)
	if not serverStarted then return end
	for i, v in pairs(game:service("NetworkServer"):children()) do
		if v:GetPlayer() == plyr then
			return v.MachineAddress;
		end
	end
end

function ban(plyrName) -- bans IP from connection given by GetPlayer
	if not serverStarted then return end
	local plyr=game.Players:FindFirstChild(plyrName);
	if plyr == nil then return end;
	local ip = getIP(plyr);
	if ip == nil then print("IP not found") else bannedIPs[ip]={true, plyrName} pcall(plyr.Remove, plyr) end
end

function unban(plyrName)
	if not serverStarted then return end
	for i, v in pairs(bannedIPs) do
		if v[2] == plyrName then bannedIPs[i]=nil end
	end
end

function start(port)
	if serverStarted then return end;
	serverStarted=true;
	game:service("NetworkServer"):Start(port)
	game:service("RunService"):Run();
end
function stop()
	if not serverStarted then return end;
	serverStarted=false
	game:service("NetworkServer"):Stop();
end

_G.ServerUtilities.GetIP=getIP;
_G.ServerUtilities.Ban=ban;
_G.ServerUtilities.Unban=unban;
_G.ServerUtilities.Start=start;
_G.ServerUtilities.Stop=stop;
_G.ServerUtilities.ClientsConnected=0;
local respawnTime=5;
_G.ServerUtilities.SetRespawnTime=function(x) respawnTime=x or 5 end


coroutine.resume(coroutine.create(function() dofile("rbxasset://rpui//commands.lua") end)); -- OYUS, I ADDED SERVER COMMANDS (that no one ever used)

--repeat wait() until serverStarted; -- BUG: Causing error message w/ coroutine stuff
game:service("NetworkServer").IncommingConnection:connect(function(peer, rep)
	if not serverStarted then return end
	if isBannedIP(rep) or (rep:GetPlayer() and isBannedPlayer(rep:GetPlayer().Name)) then
		rep:CloseConnection();
	end
	_G.ServerUtilities.ClientsConnected=game:service("NetworkServer"):GetClientCount();
end)

game.Players.PlayerAddedEarly:connect(function(plyr)
	if not serverStarted then return end
	-- moved to PlayerAddedEarly
	_G.ServerUtilities.ClientsConnected=game:service("NetworkServer"):GetClientCount();
	if isBannedPlayer(plyr.Name) then plyr:Remove(); end
	plyr.CharacterAdded:connect(function(char) -- I wrote this respawn code
		char.Humanoid.Died:connect(function()
			wait(respawnTime);
			if plyr.Parent then char:Remove(); plyr:LoadCharacter(); end
		end)
	end)
end)
